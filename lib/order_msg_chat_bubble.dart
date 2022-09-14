import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderMsgChatBubble extends StatefulWidget {
  final bool isYourMsg;
  final String content;
  final String senderId;

  const OrderMsgChatBubble(this.isYourMsg, this.content, this.senderId,
      {Key? key})
      : super(key: key);

  @override
  State<OrderMsgChatBubble> createState() => _OrderMsgChatBubbleState();
}

class _OrderMsgChatBubbleState extends State<OrderMsgChatBubble> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  TextEditingController reportMessageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    MediaQueryData media = MediaQuery.of(context);
    double bodyWidth = media.size.width - media.padding.top;
    return Card(
      color: widget.isYourMsg ? theme.primaryColor : Colors.white,
      elevation: 0.5,
      margin: EdgeInsets.only(
        left: widget.isYourMsg ? bodyWidth * 0.15 : 15,
        right: widget.isYourMsg ? 15 : bodyWidth * 0.15,
        top: 12,
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 6,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.isYourMsg
                      ? const Text(
                          'You',
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                            fontSize: 12,
                          ),
                        )
                      : Container(),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: bodyWidth * 0.6,
                    child: Text(
                      widget.content,
                      style: TextStyle(
                        fontSize: 12,
                        color: widget.isYourMsg ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              //pop up menu icon button
              // GestureDetector(
              //   child: Icon(
              //     Icons.more_vert,
              //     color: widget.isYourMsg ? Colors.white : theme.primaryColor,
              //   ),
              // ),
            ],
          ),
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: const Radius.circular(14),
          bottomRight: const Radius.circular(14),
          topRight: widget.isYourMsg ? Radius.zero : const Radius.circular(14),
          topLeft: widget.isYourMsg ? const Radius.circular(14) : Radius.zero,
        ),
      ),
    );
  }
}
