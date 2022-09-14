import 'package:bidder_buddies_admin/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import './seller_details_auction_detail_screen.dart';
import './product_details_widget_auction_detail_screen.dart';
import './product_info_card_auction_detail_screen.dart';

class AuctionDetailWidget extends StatefulWidget {
  final String userType;
  final String auctionId;

  const AuctionDetailWidget(this.auctionId, this.userType, {Key? key})
      : super(key: key);

  @override
  State<AuctionDetailWidget> createState() => _AuctionDetailWidgetState();
}

class _AuctionDetailWidgetState extends State<AuctionDetailWidget> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  TextEditingController reasonController = TextEditingController();
  List<String> imageUrls = [];
  String highestAmount = '';
  String wonUserId = '';
  TextEditingController bidController = TextEditingController();
  static final DateTime now = DateTime.now();
  static final DateFormat formatter = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    MediaQueryData media = MediaQuery.of(context);
    double bodyHeight = media.size.height - media.padding.top;
    double bodyWidth = media.size.width - media.padding.top;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Color(0xff282664),
        centerTitle: true,
        title: const Text('Admin Panel'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: StreamBuilder(
                stream: firebaseFirestore
                    .collection('auctions')
                    .doc(widget.auctionId)
                    .snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: theme.primaryColor,
                      ),
                    );
                  }
                  //get the upload date and time of auction
                  String date = snapshot.data!['date'];
                  String time = snapshot.data!['time'];
                  //convert the date and time to DateTime object
                  DateTime uploadDateTime = DateFormat('yyyy-MM-dd HH:mm:ss')
                      .parse(date + ' ' + time);
                  DateTime terminationDateTime = uploadDateTime.add(
                    const Duration(
                      days: 15,
                    ),
                  );
                  //remaining time is the difference between current time and termination time
                  Duration timeRemaining = terminationDateTime.difference(
                    DateTime.now(),
                  );
                  //now calculate remaining days, hours and minutes seprately
                  int remainingDays = timeRemaining.inDays;
                  int remainingHours = timeRemaining.inHours % 24;
                  int remainingMinutes = timeRemaining.inMinutes % 60;
                  //get the images urls for the slider
                  List<dynamic> imageUrlsDynamic = snapshot.data!['imageUrls'];
                  imageUrls = imageUrlsDynamic
                      .map(
                        (item) => item.toString(),
                      )
                      .toList();
                  //preparing the slider with images
                  final List<Widget> imageSliders = imageUrls
                      .map(
                        (item) => Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 20),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                            child: Image.network(
                              item,
                              fit: BoxFit.cover,
                              width: bodyWidth * 0.8,
                            ),
                          ),
                        ),
                      )
                      .toList();
                  //get the seller information
                  String sellerId = snapshot.data!['sellerId'].toString();
                  //get the current bid
                  //first convert dynamic list fetched from database to string list
                  List<dynamic> bidsListDynamic = snapshot.data!['bids'];
                  List<String> bidsListString =
                      bidsListDynamic.map((e) => e.toString()).toList();
                  //build the ui
                  return Column(
                    children: [
                      //images slider widget
                      CarouselSlider(
                        options: CarouselOptions(
                          autoPlay: true,
                          height: bodyHeight * 0.45,
                          enlargeCenterPage: true,
                        ),
                        items: imageSliders,
                      ),
                      //product info card
                      ProductInfoCard(
                        snapshot.data!['id'],
                        snapshot.data!['name'],
                        [...bidsListString],
                        remainingDays.toString(),
                        remainingHours.toString(),
                        remainingMinutes.toString(),
                        updateHighestBidAmount,
                        snapshot.data!['maxPrice'].toString(),
                        highestAmount,
                        snapshot.data!['startingPrice'].toString(),
                        wonUserId,
                      ),
                      //product details card
                      widget.userType == 'user'
                          ? ProductDetailsCard(
                              snapshot.data!['category'],
                              snapshot.data!['city'].toString() + '/Pakistan',
                              'Rs. ' + snapshot.data!['maxPrice'].toString(),
                              'Rs. ' +
                                  snapshot.data!['minIncrement'].toString(),
                              snapshot.data!['description'],
                            )
                          : Container(),
                      //seller details card
                      widget.userType == 'user'
                          ? SellerDetailsCard(sellerId)
                          : Container(),
                      //accept reject buttons
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await acceptAuction(
                                  widget.auctionId,
                                  snapshot.data!['sellerId'],
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Auction is Accepted',
                                      style: TextStyle(color: kPrimaryColor),
                                    ),
                                    backgroundColor: Colors.white,
                                  ),
                                );
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                height: 45,
                                width: 150,
                                decoration: BoxDecoration(
                                    color: kPrimaryColor,
                                    borderRadius: BorderRadius.circular(16)),
                                child: Center(
                                  child: Text(
                                    'Accept',
                                    style:
                                        TextStyle(fontSize: 18, color: kWhite),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.defaultDialog(
                                  backgroundColor: kWhite,
                                  title: "Reason",
                                  content: Center(
                                    child: Column(
                                      children: [
                                        //Text Field
                                        TextFormField(
                                          controller: reasonController,
                                          cursorColor: kPrimaryColor,
                                          textInputAction: TextInputAction.done,
                                          keyboardType: TextInputType.text,
                                          maxLines: 5,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 5,
                                                    vertical: 15),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              borderSide: BorderSide(
                                                color: kPrimaryColor,
                                                width: 1.3,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              borderSide: BorderSide(
                                                color: kPrimaryColor,
                                                width: 1.3,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 20),
                                  actions: <Widget>[
                                    OutlinedButton(
                                      onPressed: () async {
                                        String reason = reasonController.text;
                                        if (reason.isEmpty ||
                                            reason.length < 10) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Add a valid reason with details',
                                                style: TextStyle(
                                                    color: kPrimaryColor),
                                              ),
                                              backgroundColor: Colors.white,
                                            ),
                                          );
                                          return;
                                        }
                                        await declineAuction(
                                            widget.auctionId, sellerId, reason);
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'Send Feedback',
                                        style: TextStyle(
                                          color: kPrimaryColor,
                                        ),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                              child: Container(
                                height: 45,
                                width: 150,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: kPrimaryColor, width: 2),
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(16)),
                                child: Center(
                                  child: Text(
                                    'Decline',
                                    style: TextStyle(
                                        fontSize: 18, color: kPrimaryColor),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          //
        ],
      ),
    );
  }

  void updateHighestBidAmount(String bidAmount, String fetchedWonUserId) {
    highestAmount = bidAmount;
    wonUserId = fetchedWonUserId;
  }

  Future<void> acceptAuction(String auctionId, String sellerId) async {
    //update status
    await firebaseFirestore.collection('auctions').doc(auctionId).update(
      {'status': 'approved'},
    );
    //send notification
    String notificationId = Uuid().v4();
    firebaseFirestore.collection('notifications').doc(notificationId).set(
      {
        'id': notificationId,
        'to': sellerId,
        'from': 'Admin',
        'title': 'Congratulations!',
        'subTitle': 'Your auction is accepted by the admin',
        'isSeen': 0,
        'imageUrl': 'assets/logo.png',
        'date': '-',
        'time': '-',
      },
    );
  }

  Future<void> declineAuction(
      String auctionId, String sellerId, String declineReason) async {
    //update status
    await firebaseFirestore.collection('auctions').doc(auctionId).update(
      {'status': 'rejected'},
    );
    //send notification
    String notificationId = Uuid().v4();
    firebaseFirestore.collection('notifications').doc(notificationId).set(
      {
        'id': notificationId,
        'to': sellerId,
        'from': 'Admin',
        'title': 'Your auction is rejected',
        'subTitle': declineReason,
        'isSeen': '0',
        'imageUrl': 'assets/logo.png',
        'date': '-',
        'time': '-',
      },
    );
  }
}
