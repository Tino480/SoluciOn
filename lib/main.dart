import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:solucion/login.dart';
import 'package:solucion/userSignUp.dart';
import 'package:solucion/splash.dart';
import 'package:solucion/myHomePage.dart';
import 'package:solucion/chat.dart';

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Solucion App',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: <String, WidgetBuilder>{
        '/Splash': (BuildContext context) => SplashScreen(),
        '/Login': (BuildContext context) => LoginPage(),
        '/Signup': (BuildContext context) => SignUp(),
        '/Home': (BuildContext context) => MyHomePage(),
        '/Chat': (BuildContext context) => Chat(),
      },
      home: SplashScreen(),
    );
  }
}
