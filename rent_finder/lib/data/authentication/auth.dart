import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<void> register(
    {@required String email, @required String password}) async {
  await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: email,
    password: password,
  );
}

Future<void> signInWithEmailAndPassword(
    {@required String email, @required String password}) async {
  await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: email,
    password: password,
  );
}

bool currentUserEmailIsVerified() {
  User user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    return user.emailVerified;
  } else {
    return false;
  }
}

Future<void> sendUserEmailVerification() async {
  User user = FirebaseAuth.instance.currentUser;

  if (!user.emailVerified) {
    await user.sendEmailVerification();
  }
}

Future<void> signOut() async {
  await FirebaseAuth.instance.signOut();
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
  return null;
}

Future<void> sendPasswordResetEmail({@required String email}) async {
  await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
}

Future<void> confirmPasswordReset(
    {@required String code, @required String newPassword}) async {
  await FirebaseAuth.instance
      .confirmPasswordReset(code: code, newPassword: newPassword);
}

Future<void> setLanguageVN() async {
  FirebaseAuth.instance.setLanguageCode('vi');
}

StreamSubscription litenToAuthStateChanged(Function(Object) f) {
  return FirebaseAuth.instance.authStateChanges().listen((event) {
    f('User changed to ${event.email}');
  });
}
