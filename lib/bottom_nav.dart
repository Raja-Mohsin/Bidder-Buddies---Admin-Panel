import 'package:bidder_buddies_admin/dashboard.dart';
import 'package:bidder_buddies_admin/orders_screen.dart';
import 'package:bidder_buddies_admin/reviewAuctions.dart';
import './review_Reports.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNav extends StatefulWidget {
  final int index;
  const BottomNav({Key? key,required this.index}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PageStorageBucket bucket = PageStorageBucket();

  void updateScreen(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
  late final List<Widget> widgets = <Widget>[
    Dashboard(updateScreen),
    ReviewAuctions(),
    review_Reports(),
    OrdersScreen(),
  ];
  late int selectedIndex ;
  @override
  void initState() {
    selectedIndex=widget.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      body: PageStorage(
        bucket: bucket,
        child: widgets.elementAt(selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: GNav(
            activeColor: Colors.white,
            tabBackgroundColor: Color(0xff282664),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            tabBorderRadius: 12,
            gap: 8,
            iconSize: 25,
            tabs: [
              GButton(
                icon: Icons.home_outlined,
                text: 'Home',
                onPressed: () {
                  setState(() {
                    selectedIndex = 0;
                  });
                },
              ),
              GButton(
                icon: Icons.fact_check_outlined,
                text: 'Review Auctions',
                onPressed: () {
                  setState(() {
                    selectedIndex = 1;
                  });
                },
              ),
              GButton(
                icon: Icons.report_outlined,
                text: 'Reports',
                onPressed: () {
                  setState(() {
                    selectedIndex = 2;
                  });
                },
              ),
              GButton(
                icon: Icons.local_shipping_outlined,
                text: 'Orders',
                onPressed: () {
                  setState(() {
                    selectedIndex = 3;
                  });
                },
              ),
            ],
            selectedIndex: selectedIndex,
            onTabChange: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
