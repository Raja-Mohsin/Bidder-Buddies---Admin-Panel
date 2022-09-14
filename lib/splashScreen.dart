import 'dart:async';

import 'package:bidder_buddies_admin/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bidder_buddies_admin/login.dart';
import 'package:get/get.dart';

class Splash extends StatefulWidget {

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  startTime() async {
    var _duration = new Duration(seconds: 5);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => Login()));
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Image.asset(
            "assets/bg.png",
            fit: BoxFit.fitWidth,
            alignment: Alignment.bottomLeft,
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 120),
          child: Center(
              child: Image.asset(
                "assets/logo2.png",
                width: 250,
                height: 250,
              )),
        ),
      ],
    );
  }
}
