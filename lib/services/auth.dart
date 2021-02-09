import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solucion/models/globals.dart' as globals;

checkIfLogedIn() async {
  FirebaseAuth.instance.authStateChanges().listen((firebaseUser) {
    if (firebaseUser == null) {
      return false;
    } else {
      globals.getData(firebaseUser);
      return true;
    }
  });
}

login(context, save, _email, _password) async {
  FocusScope.of(context).unfocus();
  if (save == true) {
    try {
      CircularProgressIndicator();
      UserCredential result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password);
      User user = result.user;
      globals.getData(user);
      Navigator.popAndPushNamed(context, '/Home');
    } catch (e) {
      print('Error: $e');
    }
  }
}

createUserAndLogIn(context, save, _email, _password, _name, _lastName, _state,
    _city, _bloodType) async {
  FocusScope.of(context).unfocus();
  if (save == true) {
    try {
      UserCredential result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email, password: _password);
      User user = result.user;
      await FirebaseFirestore.instance.collection('Users').doc().set({
        'User': user.uid,
        'Email': _email,
        'First': _name,
        'Last': _lastName,
        'State': _state,
        'City': _city,
        'Blood Type': _bloodType,
      });
      globals.getData(user);
      Navigator.popAndPushNamed(context, '/Home');
    } catch (e) {
      print('Error: $e');
    }
  }
}
