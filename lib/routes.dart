import 'package:flutter/widgets.dart';
import 'package:solucion/screens/login.dart';
import 'package:solucion/screens/signUp.dart';
import 'package:solucion/screens/splash.dart';
import 'package:solucion/screens/home.dart';
import 'package:solucion/screens/chat.dart';
import 'package:solucion/screens/recover.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  '/Splash': (BuildContext context) => SplashScreen(),
  '/Login': (BuildContext context) => LoginPage(),
  '/Signup': (BuildContext context) => SignUp(),
  '/Home': (BuildContext context) => MyHomePage(),
  '/Chat': (BuildContext context) => Chat(),
  '/Recover': (BuildContext context) => RecoverPage(),
};
