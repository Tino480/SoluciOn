import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:solucion/routes.dart';
import 'package:solucion/theme/style.dart';

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
      theme: appTheme,
      routes: routes,
      initialRoute: '/Splash',
    );
  }
}
