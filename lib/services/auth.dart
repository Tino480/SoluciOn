import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChange => _firebaseAuth.authStateChanges();

  Future<bool> login({String email, String password}) async {
    bool logedIn;
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      logedIn = true;
    } on FirebaseAuthException catch (e) {
      logedIn = false;
    }
    return logedIn;
  }

  Future<bool> signUp({String email, String password}) async {
    bool signedUp;
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _firebaseAuth.currentUser.sendEmailVerification();
      signedUp = true;
    } on FirebaseAuthException catch (e) {
      signedUp = false;
    }
    return signedUp;
  }

  Future<void> signOut(context) async {
    await _firebaseAuth.signOut();
    Navigator.popAndPushNamed(context, '/Splash');
  }

  Future<void> resetPassword({String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
