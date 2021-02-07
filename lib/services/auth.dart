import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

checkIfLogedIn() async {
  FirebaseAuth.instance.authStateChanges().listen((firebaseUser) {
    if (firebaseUser == null) {
      return false;
    } else {
      return true;
    }
  });
}
