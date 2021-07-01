import 'package:firebase_auth/firebase_auth.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:rent_finder_hi/data/data_providers/data_providers.dart';
import 'package:rent_finder_hi/data/models/models.dart' as model;

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final UserFireStoreApi _userProvider = UserFireStoreApi();

  UserRepository({FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<void> signInAnonymously() async {
    await _firebaseAuth.signInAnonymously();
    await _createUserForCurrentFirebaseUser();
  }

  Future<void> signInWithCredentials(String email, String password) async {
    final credential =
        EmailAuthProvider.credential(email: email, password: password);
    final linkResult =
        await _tryLinkAnonDataToAuthCredential(email, credential);

    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);

    if (linkResult)
      await updateUser(currentUser.phoneNumber, currentUser.displayName,
          currentUser.photoURL,
          email: currentUser.email);
  }

  Future<User> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();

    if (googleSignInAccount == null) return null;

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    final linkResult = await _tryLinkAnonDataToAuthCredential(
        googleSignInAccount.email, credential);
    final userCredential = await _firebaseAuth.signInWithCredential(credential);

    if (linkResult)
      await updateUser(currentUser.phoneNumber, currentUser.displayName,
          currentUser.photoURL,
          email: currentUser.email);
    if (await getCurrentUserData() == null)
      await _createUserForCurrentFirebaseUser(); // TODO: Opt for removal of _createUser in signInWithGoogle

    return userCredential.user;
  }

  Future<void> signOut() async {
    if (await _googleSignIn.isSignedIn()) await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
    await signInAnonymously();
  }

  bool isSignedIn() {
    return _firebaseAuth.currentUser != null;
  }

  bool isAuthenticated() {
    return isSignedIn() &&
        _firebaseAuth.currentUser.email != null &&
        _firebaseAuth.currentUser.email.isNotEmpty;
  }

  Future<model.User> getCurrentUserData() async {
    return await _userProvider.getUserByUID(currentUser.uid);
  }

  Future<model.User> getUserByUID(String uid) async {
    return await _userProvider.getUserByUID(uid);
  }

  Future<void> _createUserForCurrentFirebaseUser() async {
    model.User user = model.User();
    User firebaseUser = _firebaseAuth.currentUser;
    user.hoTen = firebaseUser.displayName;
    user.email = firebaseUser.email;
    user.uid = firebaseUser.uid;
    user.urlHinhDaiDien = firebaseUser.photoURL ?? "";
    user.banned = false;
    await _userProvider.createUser(user);
  }

  Future<void> updateUser(String phone, String name, String url,
      {String userUid, String email}) async {
    model.User user;

    if (userUid != null)
      user = await getUserByUID(userUid);
    else
      user = await getCurrentUserData();

    user.sdt = phone ?? "";
    user.hoTen = name ?? "";
    user.email = email ?? user.email;
    await _userProvider.updateAllUserInfo(updatedUser: user);
    if (url != null)
      await _userProvider.updateHinhDaiDienUser(
          user: user, pathHinhDaiDien: url);
  }

  User get currentUser => _firebaseAuth.currentUser;

  // private members
  Future<model.User> _getUserByEmail(String email) async {
    return await _userProvider.getUserByEmail(email);
  }

  /// Attempts linking **already signed in** anonymous account's data to the now-signing-in [authCredential].
  ///
  /// The [email] parameter is used to check for existing data already linked with [authCredential] before actually linking.
  Future<bool> _tryLinkAnonDataToAuthCredential(
      String email, AuthCredential authCredential) async {
    if (isSignedIn() && _firebaseAuth.currentUser.isAnonymous) {
      if (await _getUserByEmail(email) != null) {
        await _userProvider.deleteUser(userUid: _firebaseAuth.currentUser.uid);
        await _firebaseAuth.currentUser.delete();
        return false;
      } else {
        await _firebaseAuth.currentUser.linkWithCredential(authCredential);
        return true;
      }
    } else
      return false;
  }

  // endregion
}
