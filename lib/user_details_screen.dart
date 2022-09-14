import 'package:flutter/material.dart';

class UserDetailsScreen extends StatelessWidget {
  final String userId;
  final String userName;
  final String email;
  final String phone;
  final String address;
  final String imageUrl;
  final String status;
  UserDetailsScreen(
    this.userId,
    this.userName,
    this.email,
    this.phone,
    this.address,
    this.imageUrl,
    this.status,
  );
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        centerTitle: true,
        elevation: 0,
        title: Text(userName),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: CircleAvatar(
                  backgroundImage: NetworkImage(imageUrl),
                  radius: 100,
                ),
              ),
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    buildPara(userName),
                    const SizedBox(height: 8),
                    buildPara(email),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildHeading(context, 'Phone'),
                  buildPara(phone),
                  buildHeading(context, 'Address'),
                  buildPara(address),
                  buildHeading(context, 'Status'),
                  buildPara(status),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeading(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget buildPara(String content) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Column(
        children: [
          Text(
            content,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
