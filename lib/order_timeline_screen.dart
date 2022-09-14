import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderTimelineScreen extends StatefulWidget {
  final String orderId;
  const OrderTimelineScreen(this.orderId, {Key? key}) : super(key: key);

  @override
  State<OrderTimelineScreen> createState() => _OrderTimelineScreenState();
}

class _OrderTimelineScreenState extends State<OrderTimelineScreen> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  int remainingDays = 0;
  int remainingHours = 0;
  int remainingMinutes = 0;
  @override
  Widget build(BuildContext context) {
    //theme and screen size
    ThemeData theme = Theme.of(context);
    MediaQueryData media = MediaQuery.of(context);
    double bodyHeight = media.size.height - media.padding.top;
    return SingleChildScrollView(
      child: StreamBuilder(
          stream: firebaseFirestore
              .collection('orders')
              .doc(widget.orderId)
              .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: theme.primaryColor,
                ),
              );
            }
            // calculating remaining days hours and minutes
            String fetchedDateTime = snapshot.data!['deliveryDateTime'];
            DateTime deliveryDtObject =
                DateFormat('yyyy-MM-dd HH:mm:ss').parse(fetchedDateTime);
            DateTime now = DateTime.now();
            Duration remainingTime = deliveryDtObject.difference(now);
            remainingDays = remainingTime.inDays;
            remainingHours = remainingTime.inHours % 24;
            remainingMinutes = remainingTime.inMinutes % 60;
            //fetch the payment status
            String paymentStatus = snapshot.data!['paymentStatus'].toString();
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  height: bodyHeight * 0.15,
                  child: Card(
                    child: Row(
                      children: [
                        Image.network(
                          snapshot.data!['imageUrl'],
                          height: 70,
                          width: 70,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 20, right: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(snapshot.data!['title']),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //status
                                  Container(
                                    color: theme.primaryColor.withAlpha(50),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 2,
                                    ),
                                    child: Text(
                                      snapshot.data!['status'].toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: theme.primaryColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 50),
                                  //price
                                  Text(
                                    'Rs.${snapshot.data!['price']}',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 5),
                  child: Column(
                    children: [
                      if (snapshot.data!['paymentStatus'].toString() ==
                              'paid' ||
                          snapshot.data!['paymentStatus'].toString() == 'cod')
                        TimelineTile(
                          afterLineStyle: LineStyle(color: theme.primaryColor),
                          beforeLineStyle: LineStyle(color: theme.primaryColor),
                          indicatorStyle:
                              const IndicatorStyle(color: Colors.amber),
                          endChild: buildSellerReviewTile(
                            snapshot.data!['reviewGiven'].toString(),
                          ),
                        ),
                      const Divider(),
                      TimelineTile(
                        afterLineStyle: LineStyle(color: theme.primaryColor),
                        beforeLineStyle: LineStyle(color: theme.primaryColor),
                        indicatorStyle:
                            const IndicatorStyle(color: Colors.amber),
                        endChild: buildSellerPaymentTile(paymentStatus),
                      ),
                      TimelineTile(
                        afterLineStyle: LineStyle(color: theme.primaryColor),
                        beforeLineStyle: LineStyle(color: theme.primaryColor),
                        indicatorStyle:
                            const IndicatorStyle(color: Colors.amber),
                        endChild: buildExpectedDeliveryTile(deliveryDtObject),
                      ),
                      const Divider(),
                      TimelineTile(
                        afterLineStyle: LineStyle(color: theme.primaryColor),
                        beforeLineStyle: LineStyle(color: theme.primaryColor),
                        indicatorStyle:
                            const IndicatorStyle(color: Colors.amber),
                        endChild: buildDeliveryDateTile(deliveryDtObject),
                      ),
                      const Divider(),
                      TimelineTile(
                        afterLineStyle: LineStyle(color: theme.primaryColor),
                        beforeLineStyle: LineStyle(color: theme.primaryColor),
                        indicatorStyle:
                            const IndicatorStyle(color: Colors.amber),
                        endChild: buildOrderStartedTile(),
                      ),
                      const Divider(),
                      TimelineTile(
                        afterLineStyle: LineStyle(color: theme.primaryColor),
                        beforeLineStyle: LineStyle(color: theme.primaryColor),
                        indicatorStyle:
                            const IndicatorStyle(color: Colors.amber),
                        endChild: buildOrderCreatedTile(
                          snapshot.data!['title'],
                          snapshot.data!['price'],
                          snapshot.data!['date'],
                          snapshot.data!['id'],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }

  Widget buildDeliveryDateTile(DateTime dtObject) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              'Your delivery date was updated to ${dtObject.day}-${dtObject.month}-${dtObject.year}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOrderStartedTile() {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: const Text(
              'Order Started',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOrderCreatedTile(
      String title, String price, String date, String id) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: const Text(
              'Order Created',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.only(
              left: 20,
              right: 8,
            ),
            child: Column(
              children: [
                Text(date),
                Text(
                  'ID: $id',
                  style: const TextStyle(fontSize: 12),
                ),
                const Divider(),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 35),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title),
                      Text('Rs. ' + price),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 35),
                  alignment: Alignment.centerLeft,
                  child: Text('Delivery Date: ' + date),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSellerPaymentTile(String paymentStatus) {
    String paymentText = '';
    if (paymentStatus == 'pending') {
      paymentText = 'Pending';
    } else if (paymentStatus == 'cod') {
      paymentText = 'Cash on Delivery';
    } else {
      paymentText = 'Paid';
    }
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          //heading
          Container(
            alignment: Alignment.centerLeft,
            child: const Text(
              'Payment',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text('Payment Status: $paymentText'),
        ],
      ),
    );
  }

  Widget buildSellerReviewTile(String reviewStatus) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          //heading
          Container(
            alignment: Alignment.centerLeft,
            child: const Text(
              'Review',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          reviewStatus == '0'
              ? const Text('Review not given yet')
              : const Text(
                  'Buyer has given the review, you can view it in your Reviews section from the dashboard',
                ),
        ],
      ),
    );
  }

  Widget buildExpectedDeliveryTile(DateTime dtObject) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              'Expected delivery ${dtObject.day}-${dtObject.month}-${dtObject.year}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Theme.of(context).primaryColor.withAlpha(50),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      remainingDays.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text('Days'),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      remainingHours.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text('Hours'),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      remainingMinutes.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text('Minutes'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
