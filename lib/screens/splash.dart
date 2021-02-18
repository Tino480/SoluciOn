import 'package:flutter/material.dart';
import 'package:solucion/services/auth.dart' as auth;
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    if (auth.checkIfLogedIn() == true) {
      Timer(const Duration(seconds: 2),
          () => Navigator.popAndPushNamed(context, '/Home'));
    } else {
      Timer(const Duration(seconds: 2),
          () => Navigator.popAndPushNamed(context, '/Login'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: SafeArea(
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: const AssetImage("assets/logo_solucion.png"),
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
                          const Text(
                            "Salva Una Vida Con",
                            style: const TextStyle(
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
                          const CircularProgressIndicator(),
                          const Padding(
                            padding: const EdgeInsets.only(bottom: 30.0),
                          ),
                          const Text(
                            "SoluciOn",
                            style: const TextStyle(
                                color: Colors.red,
                                fontSize: 60.0,
                                fontWeight: FontWeight.bold),
                          ),
                          const Padding(
                            padding: const EdgeInsets.only(bottom: 40.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
