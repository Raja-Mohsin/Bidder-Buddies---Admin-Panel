import 'package:bidder_buddies_admin/dashboard.dart';
import 'package:bidder_buddies_admin/reviewAuctions.dart';
import 'package:bidder_buddies_admin/review_Reports.dart';
import 'package:bidder_buddies_admin/users.dart';
import 'package:bidder_buddies_admin/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'bottom_nav.dart';
import 'login.dart';
import 'orders_screen.dart';

class adminDrawer extends StatefulWidget {
  const adminDrawer({Key? key}) : super(key: key);

  @override
  State<adminDrawer> createState() => _adminDrawerState();
}

class _adminDrawerState extends State<adminDrawer> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextStyle bodyTextStyle =
    TextStyle(fontFamily: theme.textTheme.bodyText1!.fontFamily);
    MediaQueryData media = MediaQuery.of(context);
    double bodyHeight = media.size.height - media.padding.top;
    double bodyWidth = media.size.width - media.padding.top;

    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            //header
            DrawerHeader(
              decoration: BoxDecoration(color: kPrimaryColor),
              child: Column(
                children: [
                  //back button
                  Container(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: kWhite,
                      ),
                    ),
                  ),
                  Container(
                    height: 80,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/wlogo.png")
                      )
                    ),
                  )
                ],
              ),
            ),

            Column(children: [
              ListTile(
                leading: Icon(
                  Icons.home_outlined,
                  size: 25,
                  color:kPrimaryColor,
                ),
                title: Text(
                  'Home',
                  style: bodyTextStyle,
                ),
                onTap: () {
                  Navigator.of(context).pop();},
              ),
              const Divider(
                thickness: 3.0,
              ),
              ListTile(
                leading: Icon(
                  Icons.fact_check_outlined,
                  size: 25,
                  color:kPrimaryColor,
                ),
                title: Text(
                  'Review Auctions',
                  style: bodyTextStyle,
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => BottomNav(index: 1,),
                    ),
                  );
                },
              ),
              const Divider(
                thickness: 3.0,
              ),
              ListTile(
                leading: Icon(
                  Icons.report_outlined,
                  size: 25,
                  color:kPrimaryColor,
                ),
                title: Text(
                  'Review Reports',
                  style: bodyTextStyle,
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => BottomNav(index: 2,),
                    ),
                  );
                },
              ),
              const Divider(
                thickness: 3.0,
              ),
              ListTile(
                leading: Icon(
                  Icons.local_shipping_outlined,
                  size: 25,
                  color:kPrimaryColor,
                ),
                title: Text(
                  'Order Details',
                  style: bodyTextStyle,
                ),
                onTap: () {Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BottomNav(index: 3,),
                  ),
                );},
              ),
              const Divider(
                thickness: 3.0,
              ),
              ListTile(
                leading: Icon(
                  Icons.group_outlined,
                  size: 25,
                  color:kPrimaryColor,
                ),
                title: Text(
                  'Users',
                  style: bodyTextStyle,
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => users(),
                    ),
                  );
                },
              ),
              const Divider(
                thickness: 3.0,
              ),

              //logout button
              Container(
                margin: EdgeInsets.only(top:30),
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(bodyWidth * 0.6, 45),
                      primary: theme.primaryColor,
                      elevation: 10,
                    ),
                    onPressed: () {
                      signOut();
                    },
                    child: Text(
                      'Log out',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: theme.textTheme.bodyText1!.fontFamily,
                      ),
                    ),
                  ),
                ),
              ),
            ],),
          ],
        ),
      ),
    );
  }
  signOut() async {

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
  }
}