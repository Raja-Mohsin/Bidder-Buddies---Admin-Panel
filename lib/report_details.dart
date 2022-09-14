import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class report_details extends StatefulWidget {
  final String reportId;

  report_details(this.reportId);

  @override
  State<report_details> createState() => _report_detailsState();
}

class _report_detailsState extends State<report_details> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  List<String> items = [
    'pending',
    'approved',
    'blocked',
  ];
  String dropdownvalue = 'Pending';

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextStyle heading = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );
    TextStyle text = TextStyle(
      fontSize: 17,
      color: Colors.black38,
    );
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Color(0xff282664),
        centerTitle: true,
        title: const Text('Admin Panel'),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: StreamBuilder(
        stream: firebaseFirestore
            .collection('reports')
            .doc(widget.reportId)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor,
              ),
            );
          }
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            width: double.infinity,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 8,
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Message:',
                      style: heading,
                    ),
                    Text(
                      snapshot.data!['content'],
                      style: text,
                    ),
                    Divider(),
                    Text(
                      'Reason:',
                      style: heading,
                    ),
                    Text(
                      snapshot.data!['userComment'],
                      style: text,
                    ),
                    Divider(),
                    Text(
                      'Date:',
                      style: heading,
                    ),
                    Text(
                      snapshot.data!['date'],
                      style: text,
                    ),
                    Divider(),
                    Text(
                      'Time:',
                      style: heading,
                    ),
                    Text(
                      snapshot.data!['time'],
                      style: text,
                    ),
                    SizedBox(height: 10),
                    Column(
                      children: [
                        //text
                        Text(
                          'Change status of this user:',
                          style: heading,
                        ),
                        const SizedBox(height: 10),
                        //dropdown button
                        Center(
                          child: FutureBuilder(
                            future: firebaseFirestore
                                .collection('users')
                                .doc(snapshot.data!['to'].toString())
                                .get(),
                            builder: (context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(
                                      backgroundColor: theme.primaryColor),
                                );
                              }
                              String currentStatus =
                                  snapshot.data!['status'].toString();
                              dropdownvalue = currentStatus;
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.amber,
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 60, vertical: 3),
                                child: DropdownButton(
                                  value: dropdownvalue,
                                  items: items.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(items),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) async {
                                    setState(() {
                                      dropdownvalue = newValue!;
                                    });
                                    await changeUserStatus(
                                      '',
                                      newValue!,
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            const Text('User status changed'),
                                        backgroundColor: theme.primaryColor,
                                      ),
                                    );
                                  },
                                  dropdownColor: theme.primaryColor,
                                  style: const TextStyle(color: Colors.white),
                                  icon: Icon(
                                    Icons.arrow_drop_down_rounded,
                                    color: theme.primaryColor,
                                  ),
                                  iconSize: 28,
                                  underline: Container(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Text(
                        'Send warning to this user:',
                        style: heading,
                      ),
                    ),
                    SizedBox(height: 5),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          await sendWarning(snapshot.data!['to']);
                        },
                        child: Text('Send Warning'),
                        style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> changeUserStatus(String userId, String status) async {
    await firebaseFirestore.collection('users').doc(userId).update(
      {
        'status': status,
      },
    );
  }

  Future<void> sendWarning(String userId) async {
    String id = Uuid().v4();
    await firebaseFirestore.collection('notifications').doc(id).set(
      {
        'id': id,
        'to': userId,
        'from': 'Admin',
        'title': 'Admin sent you a warning',
        'subTitle': 'There is a warning against your comment/message',
        'isSeen': '0',
        'imageUrl': 'assets/logo.png',
        'date': '-',
        'time': '-',
      },
    );
  }
}
