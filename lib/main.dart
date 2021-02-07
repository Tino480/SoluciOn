import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:solucion/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SoluciOn App',
      theme: ThemeData(
        primaryColor: Colors.red,
        accentColor: Colors.redAccent,
        brightness: Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Georgia',
      ),
      routes: routes,
      initialRoute: '/Splash',
    );
  }
}
