//import 'dart:ffi';

import 'package:bidder_buddies_admin/drawer.dart';
import 'package:bidder_buddies_admin/orders_screen.dart';
import 'package:bidder_buddies_admin/review_Reports.dart';
import 'package:bidder_buddies_admin/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Dashboard extends StatefulWidget {
  Function updateScreen;

  Dashboard(this.updateScreen);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Widget reviewCard(BuildContext context, String title, String type,
      String count, Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 15,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(5, 5, 0, 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          // your text
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      'You have $count\n$type',
                      style: TextStyle(
                          // your text
                          fontSize: 15.0,
                          color: Colors.black54),
                      textAlign: TextAlign.left,
                    ),
                  ], //children
                ),
              ),
              Container(
                height: 30,
                width: 80,
                alignment: Alignment.bottomRight,
                margin: EdgeInsets.only(right: 20.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1.3,
                    color: Color(0xff282664),
                  ),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Center(
                  child: Text(count.toString()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        backgroundColor: Color(0xff282664),
        centerTitle: true,
        title: const Text('Admin Panel'),
        leading: GestureDetector(
            onTap: () {
              _scaffoldkey.currentState!.openDrawer();
            },
            child: Icon(
              Icons.menu,
              size: 30,
              color: Colors.white,
            )),
      ),
      // Admin Drawer ***************************************************
      drawer: adminDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 20, 10),
              //apply padding to LTRB, L:Left, T:Top, R:Right, B:Bottom
              child: Text(
                "To-Do's",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),

//card..........................................................................
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
                if (snapshot.data == null) {
                  return reviewCard(
                      context, 'Review Reuqests', 'Reuqests', '0', () {});
                }
                String totalReviewRequests =
                    snapshot.data!.docs.length.toString();
                return reviewCard(context, 'Review Reuqests', 'Reuqests',
                    totalReviewRequests, () {});
              },
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
                    return reviewCard(
                        context, 'Review Reports', 'Reports', '0', () {});
                  }
                  String totalReports = snapshot.data!.docs.length.toString();
                  return reviewCard(context, 'Review Reports', 'Reports',
                      totalReports, () {});
                }),

            // Container for Four cards
            Container(
              width: size.width,
              margin: const EdgeInsets.only(top: 20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 5,
                    blurRadius: 5,
                    offset: Offset(0, -3), // changes position of shadow
                  ),
                ],
              ),
              //Card................

              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        categoryCard(
                          size,
                          () {
                            widget.updateScreen(1);
                          },
                          'Review Auctions',
                        ),
                        categoryCard(size, () {
                          widget.updateScreen(2);
                        }, 'Review reports'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        categoryCard(size, () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => OrdersScreen(),
                            ),
                          );
                        }, 'Orders'),
                        categoryCard(size, () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => users(),
                            ),
                          );
                        }, 'Users'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // nav bar
      //
    );
  }

  Widget categoryCard(Size size, Function() onTap, String title) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: size.width * 0.35,
          width: size.width * 0.35,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: AssetImage('assets/cardBG.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Center(
              child: Text(title.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ),
    );
  }
}
