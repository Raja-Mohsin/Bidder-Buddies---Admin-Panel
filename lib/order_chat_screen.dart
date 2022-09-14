import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './order_message.dart';
import './order_msg_chat_bubble.dart';

class OrderChatScreen extends StatefulWidget {
  final String orderId;
  const OrderChatScreen(this.orderId, {Key? key}) : super(key: key);

  @override
  State<OrderChatScreen> createState() => _OrderChatScreenState();
}

class _OrderChatScreenState extends State<OrderChatScreen> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  List<OrderMessage> messages = [];
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    MediaQueryData media = MediaQuery.of(context);
    double bodyWidth = media.size.width - media.padding.top;
    return StreamBuilder(
      stream: firebaseFirestore
          .collection('orders')
          .doc(widget.orderId)
          .collection('chat')
          .orderBy('timestamp', descending: true)
          .limit(500)
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
          return const Center(
            child:
                Text('Nothing to show, send some messages to show them here.'),
          );
        }
        messages.clear();
        snapshot.data!.docs.forEach(
          (msg) {
            messages.add(
              OrderMessage(
                msg['id'],
                msg['orderId'],
                msg['senderId'],
                msg['recieverId'],
                msg['content'],
                msg['timestamp'],
              ),
            );
          },
        );
        return Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return OrderMsgChatBubble(
                false,
                messages[index].content,
                messages[index].senderId,
              );
            },
            itemCount: messages.length,
            reverse: true,
          ),
        );
      },
    );
  }
}
