import 'package:bidder_buddies_admin/report_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class review_Reports extends StatefulWidget {
  const review_Reports({Key? key}) : super(key: key);

  @override
  State<review_Reports> createState() => _review_ReportsState();
}

class _review_ReportsState extends State<review_Reports> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff282664),
        centerTitle: true,
        title: const Text('Admin Panel'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 20, 10),
              //apply padding to LTRB, L:Left, T:Top, R:Right, B:Bottom
              child: Text(
                "Review Reports",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),
            StreamBuilder(
              stream: firebaseFirestore.collection('reports').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  );
                }
                if (snapshot.data == null) {
                  return Center(
                    child: Text('No reports currently'),
                  );
                }
                return SizedBox(
                  height: 500,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return reportCard(
                        size,
                        "Report",
                        "There is a report against a comment",
                        'assets/warning.png',
                        () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => report_details(
                                  snapshot.data!.docs.elementAt(index)['id']),
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
    );
  }

  Container reportCard(Size size, String username, String notification,
      String image, Function() onTap) {
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
        ],
      ),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            width: 90,
            height: 100,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.fill,
                ),
                shape: BoxShape.rectangle),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
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
                        username,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, bottom: 8),
                        child: Text(
                          notification,
                          style: TextStyle(
                            color: Colors.black38,
                            fontSize: 17.0,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: onTap,
                        child: Container(
                          margin: EdgeInsets.all(2),
                          child: Center(
                            child: Text(
                              "View Report",
                              style: TextStyle(
                                color: Color(0xff282664),
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
