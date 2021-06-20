import 'package:firebase_auth/firebase_auth.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:rent_finder/data/data_providers/data_providers.dart';
import 'package:rent_finder/data/models/models.dart' as model;

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  UserFireStoreApi _userProvider = UserFireStoreApi();
  UserRepository({FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<void> signInWithCredentials(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signUp(String email, String password) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    createUser();
  }

  Future<User> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn().catchError((err) {
      print(err.toString());
    });
    print('cái đcm mày lần 2');
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);
    final UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(credential);
    return userCredential.user;
  }

  Future<void> signOut() async {
    if (await _googleSignIn.isSignedIn()) _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }

  Future<bool> isSignedIn() async {
    return _firebaseAuth.currentUser != null;
  }

  Future<User> getUser() async {
    return _firebaseAuth.currentUser;
  }

  Future<model.User> getCurrentUser() async {
    User currentUser = await getUser();
    String uid = currentUser.uid;
    return await _userProvider.getUserByUID(uid);
  }

  Future<model.User> getUserByUID(String uid) async {
    return await _userProvider.getUserByUID(uid);
  }

  Future<void> createUser() async {
    model.User user = model.User();
    User firebaseUser = _firebaseAuth.currentUser;
    user.email = firebaseUser.email;
    user.uid = firebaseUser.uid;
    user.urlHinhDaiDien = firebaseUser.photoURL ?? "";
    user.banned = false;
    await _userProvider.createUser(user);
  }

  Future<void> updateUser(String phone, String name, String url) async {
    model.User user = await getCurrentUser();
    user.sdt = phone ?? "";
    user.hoTen = name ?? "";
    await _userProvider.updateAllUserInfo(updatedUser: user);
    if (url != null)
      await _userProvider.updateHinhDaiDienUser(
          user: user, pathHinhDaiDien: url);
  }
}
