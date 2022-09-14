import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'bottom_nav.dart';

class Login extends StatefulWidget {
  bool isRememberMe = false;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isRememberMe = false;
  bool isLoading = false;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Widget buildEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'username',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black87,
                  offset: Offset(0, 2),
                  blurRadius: 6,
                )
              ]),
          height: 60,
          child: TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.black87,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(
                Icons.person,
                color: Color(0xff282664),
              ),
              hintText: 'username',
              helperStyle: TextStyle(
                color: Colors.black38,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildpassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black87,
                  offset: Offset(0, 2),
                  blurRadius: 6,
                )
              ]),
          height: 60,
          child: TextField(
            controller: passwordController,
            obscureText: true,
            style: TextStyle(
              color: Colors.black87,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(
                Icons.lock,
                color: Color(0xff282664),
              ),
              hintText: 'Password',
              helperStyle: TextStyle(
                color: Colors.black38,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLoginbtn() {
    return isLoading ? CircularProgressIndicator() : Container(
      padding: EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          String email = emailController.text;
          String password = passwordController.text;
          if (email.isEmpty || password.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Email or password can\'t be empty',
                  style: TextStyle(color: Colors.redAccent),
                ),
                backgroundColor: Colors.white,
              ),
            );
            return;
          }
          setState(() {
            isLoading = true;
          });
          //start
          firebaseFirestore
              .collection('admin')
              .doc('admin')
              .get()
              .then((snapshot) {
            String fetchedEmail = snapshot['username'];
            String fetchedPassword = snapshot['password'];
            //compare
            if (email == fetchedEmail && password == fetchedPassword) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BottomNav(index: 0,),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Incorrect Email or password',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                  backgroundColor: Colors.white,
                ),
              );
              setState(() {
                isLoading = false;
              });
              return;
            }
          });
          //end
          setState(() {
            isLoading = false;
          });
        },
        style: ElevatedButton.styleFrom(
          elevation: 5,
          primary: Colors.white,
          padding: EdgeInsets.all(15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: Text(
          'Login',
          style: TextStyle(
            color: Color(0xff282664),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: GestureDetector(
        child: Stack(
          children: <Widget>[
            Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0x6629377d),
                        Color(0x9929377d),
                        Color(0xcc282664),
                        Color(0xff282664),
                      ]),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 120,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Admin Login',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 50),
                      buildEmail(),
                      SizedBox(height: 20),
                      buildpassword(),
                      buildLoginbtn(),
                    ],
                  ),
                )),
          ],
        ),
      ),
    ));
  }
}
