import 'package:flutter/material.dart';

import './orders_listing_screen.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: theme.primaryColor,
          centerTitle: true,
          elevation: 0,
          title: const Text('Manage Orders'),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: [
              Tab(
                text: 'Pending',
              ),
              Tab(
                text: 'Active',
              ),
              Tab(
                text: 'Completed',
              ),
            ],
          ),
        ),
        body: const SafeArea(
          child: TabBarView(
            children: [
              OrdersListingScreen('pending'),
              OrdersListingScreen('active'),
              OrdersListingScreen('completed'),
            ],
          ),
        ),
      ),
    );
  }
}
