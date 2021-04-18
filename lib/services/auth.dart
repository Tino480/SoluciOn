import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChange => _firebaseAuth.authStateChanges();

  String errorType;
  bool logedIn;

  login({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      logedIn = true;
    } on FirebaseAuthException catch (e) {
      switch (e.message) {
        case 'There is no user record corresponding to this identifier. The user may have been deleted.':
          errorType = 'El usuario no existe por favor crea una cuenta!!';
          break;
        case 'The password is invalid or the user does not have a password.':
          errorType =
              'La contraseña es incorrecta por favor ingressa la contraseña correcta!! Si se te olvido tu contraseña por favor restablesala';
          break;
        case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
          errorType =
              'Existe un error con tu connecion por favor revisala y reintenta de nuevo!!';
          break;
        default:
          print('Case ${e.message} is not yet implemented');
      }
      logedIn = false;
    }
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
      print(e);
      signedUp = false;
    }
    return signedUp;
  }

  Future<void> deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();

    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }

  Future<void> deleteAppDir() async {
    final appDir = await getApplicationSupportDirectory();

    if (appDir.existsSync()) {
      appDir.deleteSync(recursive: true);
    }
  }

  Future<void> signOut(context) async {
    await _firebaseAuth.signOut();
    await deleteCacheDir();
    await deleteAppDir();
    Navigator.popAndPushNamed(context, '/Splash');
  }

  Future<void> resetPassword({String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
