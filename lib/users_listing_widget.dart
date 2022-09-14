import './user_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsersListingScreen extends StatelessWidget {
  final String type;
  UsersListingScreen(this.type);

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return StreamBuilder(
      stream: firebaseFirestore
          .collection('users')
          .where('status', isEqualTo: type)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: theme.primaryColor,
            ),
          );
        }
        if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text('There are no $type users currently'),
          );
        }
        return ListView.builder(
          itemBuilder: (context, index) {
            return Column(
              children: [
                ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => UserDetailsScreen(
                          snapshot.data!.docs.elementAt(index)['id'].toString(),
                          snapshot.data!.docs
                              .elementAt(index)['name']
                              .toString(),
                          snapshot.data!.docs
                              .elementAt(index)['email']
                              .toString(),
                          snapshot.data!.docs
                              .elementAt(index)['phone']
                              .toString(),
                          snapshot.data!.docs
                              .elementAt(index)['address']
                              .toString(),
                          snapshot.data!.docs
                              .elementAt(index)['imageUrl']
                              .toString(),
                          snapshot.data!.docs
                              .elementAt(index)['status']
                              .toString(),
                        ),
                      ),
                    );
                  },
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      snapshot.data!.docs
                          .elementAt(index)['imageUrl']
                          .toString(),
                    ),
                  ),
                  title: Text(
                    snapshot.data!.docs.elementAt(index)['name'].toString(),
                  ),
                  subtitle: Text(
                    snapshot.data!.docs.elementAt(index)['email'].toString(),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
                const Divider(),
              ],
            );
          },
          itemCount: snapshot.data!.docs.length,
        );
      },
    );
  }
}
