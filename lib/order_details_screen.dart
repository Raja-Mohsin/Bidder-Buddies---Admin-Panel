import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './order_timeline_screen.dart';
import './order_chat_screen.dart';

class OrderDetailsScreen extends StatelessWidget {
  final String orderId;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  OrderDetailsScreen(this.orderId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: theme.primaryColor,
          centerTitle: true,
          elevation: 0,
          title: const Text('Manage Order'),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: [
              Tab(
                text: 'Manage',
              ),
              Tab(
                text: 'Chat',
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              OrderTimelineScreen(orderId),
              OrderChatScreen(orderId),
            ],
          ),
        ),
      ),
    );
  }
}
