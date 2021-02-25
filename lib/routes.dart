import 'package:flutter/widgets.dart';
import 'package:solucion/views/login.dart';
import 'package:solucion/views/signup.dart';
import 'package:solucion/views/splash.dart';
import 'package:solucion/views/home.dart';
import 'package:solucion/views/chat.dart';
import 'package:solucion/views/recover.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  '/Splash': (BuildContext context) => SplashScreenPage(),
  '/Login': (BuildContext context) => LoginPage(),
  '/Signup': (BuildContext context) => SignUpPage(),
  '/Recover': (BuildContext context) => RecoverPage(),
  '/Home': (BuildContext context) => HomePage(),
  '/Chat': (BuildContext context) => ChatPage(),
};
