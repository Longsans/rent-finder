import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  UserRepository({FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<void> signInWithCredentials(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signUp(String email, String password) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount account = await GoogleSignIn().signIn();

    if (account != null) {
      try {
        final GoogleSignInAuthentication authentication =
            await account.authentication;

        final GoogleAuthCredential credential = GoogleAuthProvider.credential(
            idToken: authentication.idToken,
            accessToken: authentication.accessToken);

        return await FirebaseAuth.instance.signInWithCredential(credential);
      } on PlatformException {}
    }
    print('null nè');
    return null;
  }

  Future<void> signOut() async {
    if (await _googleSignIn.isSignedIn()) await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }

  Future<bool> isSignedIn() async {
    return await _firebaseAuth.currentUser != null;
  }

  Future<User> getUser() async {
    return await _firebaseAuth.currentUser;
  }
}
