import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './users_listing_widget.dart';

class users extends StatefulWidget {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  State<users> createState() => _usersState();
}

class _usersState extends State<users> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: theme.primaryColor,
          centerTitle: true,
          elevation: 0,
          title: const Text('Manage Users'),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: [
              Tab(
                text: 'Pending',
              ),
              Tab(
                text: 'Approved',
              ),
              Tab(
                text: 'Blocked',
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              UsersListingScreen('pending'),
              UsersListingScreen('approved'),
              UsersListingScreen('blocked'),
            ],
          ),
        ),
      ),
    );
  }
}
