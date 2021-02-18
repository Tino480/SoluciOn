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
      const CircularProgressIndicator();
      UserCredential result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password);
      if (result.user.emailVerified) {
        User user = result.user;
        globals.getData(user);
        Navigator.popAndPushNamed(context, '/Home');
      }
      else{
        // todo popup need to verify email
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}

createUserAndLogIn(context, save, _email, _password, _name, _state,
    _municipality, _bloodType) async {
  FocusScope.of(context).unfocus();
  if (save == true) {
    try {
      const CircularProgressIndicator();
      UserCredential result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email, password: _password);
      await result.user.sendEmailVerification();
      await FirebaseFirestore.instance.collection('Users').doc().set({
        'User': result.user.uid,
        'Email': _email,
        'Name': _name,
        'State': _state,
        'Municipality': _municipality,
        'Blood Type': _bloodType,
      });
    } catch (e) {
      print('Error: $e');
    }
  }
}

@override
Future<void> resetPassword(context, save, email) async {
  FocusScope.of(context).unfocus();
  const CircularProgressIndicator();
  if (save == true) {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}
