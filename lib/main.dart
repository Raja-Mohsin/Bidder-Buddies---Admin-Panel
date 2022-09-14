import 'package:bidder_buddies_admin/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Budder Buddies Admin',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.blue[50],
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xff282664),
        ),
        primaryColor: const Color(0xff282664),
      ),
      home: Splash(),
    );
  }
}
