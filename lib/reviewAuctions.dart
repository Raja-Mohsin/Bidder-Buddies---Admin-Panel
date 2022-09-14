import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './auction_detail_widget.dart';
class ReviewAuctions extends StatefulWidget {
  const ReviewAuctions({Key? key}) : super(key: key);

  @override
  State<ReviewAuctions> createState() => _ReviewAuctionsState();
}

class _ReviewAuctionsState extends State<ReviewAuctions> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 20, 10),
              //apply padding to LTRB, L:Left, T:Top, R:Right, B:Bottom
              child: Text(
                "Review Auctions",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),
            StreamBuilder(
              stream: firebaseFirestore
                  .collection('auctions')
                  .where('status', isEqualTo: 'pending')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  );
                }
                if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text('No pending auctions currently'),
                  );
                }
                return SizedBox(
                  height: 500,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return auctionCard(
                        size,
                        snapshot.data!.docs.elementAt(index)['name'],
                        snapshot.data!.docs.elementAt(index)['category'],
                        "Rs ${snapshot.data!.docs.elementAt(index)['startingPrice']}-${snapshot.data!.docs.elementAt(index)['maxPrice']}",
                        snapshot.data!.docs.elementAt(index)['imageUrls'][0],
                            () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AuctionDetailWidget(
                                snapshot.data!.docs.elementAt(index)['id'],
                                'user',
                              ),
                            ),
                          );
                        },
                      );
                    },
                    itemCount: snapshot.data!.docs.length,
                  ),
                );

              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff282664),
        centerTitle: true,
        title: const Text('Admin Panel'),
      ),
    );
  }

  Container auctionCard(Size size, String name, String username,
      String priceRange, String image, Function onTap) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 15,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ]),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.all(20),
            width: 100,
            height: 110,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: SizedBox(
              width: size.width * 0.47,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, bottom: 8),
                        child: Text(
                          username,
                          style: TextStyle(
                            color: Colors.black38,
                            fontSize: 17.0,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Text(
                        priceRange,
                        style: TextStyle(
                            color: Color(0xff282664),
                            fontSize: 19.0,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          onTap();
                        },
                        child: Container(
                          margin: EdgeInsets.all(5),
                          height: 40,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Color(0xff282664),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Text(
                              "View",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
