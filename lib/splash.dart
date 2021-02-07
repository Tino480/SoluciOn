import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:solucion/globals.dart' as globals;

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) {
      if (firebaseUser == null) {
        Timer(Duration(seconds: 2),
            () => Navigator.popAndPushNamed(context, '/Login'));
      } else {
        globals.getData();
        Timer(Duration(seconds: 2),
            () => Navigator.popAndPushNamed(context, '/Home'));
      }
      // do whatever you want based on the firebaseUser state
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/logo_solucion.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Salva Una Vida Con",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        CircularProgressIndicator(),
                        Padding(
                          padding: EdgeInsets.only(bottom: 30.0),
                        ),
                        Text(
                          "SoluciOn",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 60.0,
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 40.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
