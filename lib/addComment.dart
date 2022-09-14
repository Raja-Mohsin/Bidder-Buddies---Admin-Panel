

import 'package:flutter/material.dart';
class addComment extends StatefulWidget {
  const addComment({Key? key}) : super(key: key);

  @override
  State<addComment> createState() => _addCommentState();
}

class _addCommentState extends State<addComment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
            backgroundColor: Color(0xff282664),
        centerTitle: true,
        title: const Text('Admin Panel'),
        ),
        body: Column(

        ),
    );
}
}
