import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import './order.dart';
import './order_details_screen.dart';

class OrdersListingScreen extends StatefulWidget {
  final String type;
  const OrdersListingScreen(this.type, {Key? key}) : super(key: key);

  @override
  State<OrdersListingScreen> createState() => _OrdersListingScreenState();
}

class _OrdersListingScreenState extends State<OrdersListingScreen> {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  List<Order> orders = [];

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    MediaQueryData media = MediaQuery.of(context);
    double bodyHeight = media.size.height - media.padding.top;
    double bodyWidth = media.size.width - media.padding.top;
    return StreamBuilder(
      stream: firebaseFirestore
          .collection('orders')
          .where('status', isEqualTo: widget.type)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: theme.primaryColor),
          );
        }
        if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'There are no ${widget.type} auctions currently',
              style: const TextStyle(fontSize: 16),
            ),
          );
        }
        orders.clear();
        snapshot.data!.docs.forEach(
          (order) {
            orders.add(
              Order(
                order['id'],
                order['auctionId'],
                order['buyerId'],
                order['sellerId'],
                order['chatId'],
                order['title'],
                order['price'],
                order['imageUrl'],
                order['date'],
                order['time'],
                order['status'],
                order['reviewGiven'],
                order['paymentStatus'],
                order['deliveryDateTime'],
              ),
            );
          },
        );
        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            //converting date to required format
            //fetched date in default format
            String date = orders[index].date.toString();
            //create date time object from fetched date
            DateTime dateObject = DateFormat('yyyy-MM-dd').parse(date);
            //calculate month name from int
            const List months = [
              'January',
              'Febuary',
              'March',
              'April',
              'May',
              'June',
              'July',
              'August',
              'September',
              'October',
              'November',
              'December',
            ];
            int monthIndex = dateObject.month;
            String monthName = months[monthIndex - 1];
            return GestureDetector(
              onTap: () {
                //move to detail screen
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => OrderDetailsScreen(orders[index].id),
                  ),
                );
              },
              child: Container(
                width: bodyWidth * 0.9,
                height: bodyHeight * 0.3,
                margin: const EdgeInsets.all(8),
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: theme.primaryColor,
                                  width: 0.6,
                                ),
                              ),
                              child: Image.network(
                                orders[index].imageUrl,
                                width: 70,
                                height: 70,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 25),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Rs. ${orders[index].price}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    orders[index].title,
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Divider(),
                        Container(
                          margin: const EdgeInsets.only(left: 8, top: 6),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '$monthName ${dateObject.day}, ${dateObject.year}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
