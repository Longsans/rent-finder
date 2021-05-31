import 'package:firebase_auth/firebase_auth.dart';

Future<bool> register(String email, String password) async {
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    return true;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    }

    return false;
  } catch (e) {
    print(e);

    return false;
  }
}

Future<bool> signInWithEmailAndPassword(String email, String password) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return true;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
    }

    return false;
  } catch (e) {
    print(e);

    return false;
  }
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
