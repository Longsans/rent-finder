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

  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    final signInMethods = await _firebaseAuth.fetchSignInMethodsForEmail(email);

    if (signInMethods.isNotEmpty)
      throw FirebaseAuthException(code: 'email-already-in-use');

    final credential =
        EmailAuthProvider.credential(email: email, password: password);
    final linkResult =
        await _tryLinkAnonDataToAuthCredential(email, credential);
    await signInWithCredentials(email, password);

    if (linkResult)
      await updateUser(currentUser.phoneNumber, currentUser.displayName,
          currentUser.photoURL,
          email: currentUser.email);

    await currentUser.sendEmailVerification();
    await signOut();
  }

  Future<void> signInWithCredentials(String email, String password) async {
    final signInMethods = await _firebaseAuth.fetchSignInMethodsForEmail(email);

    if (signInMethods.isEmpty)
      throw FirebaseAuthException(code: 'user-not-found');

    await _deleteCurrentAnonUser();
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<User> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();

    if (googleSignInAccount == null)
      throw Exception('Sign in process aborted.');

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

    return userCredential.user;
  }

  Future<void> signOut() async {
    if (await _googleSignIn.isSignedIn()) await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
    await signInAnonymously();
  }

  bool isSignedIn() {
    return currentUser != null;
  }

  bool isAuthenticated() {
    return isSignedIn() &&
        currentUser.email != null &&
        currentUser.email.isNotEmpty;
  }

  Future<bool> isEmailVerified() async {
    if (currentUser != null)
      await currentUser.reload();
    else
      throw Exception();

    return currentUser.emailVerified;
  }

  Future<model.User> getCurrentUserData() async {
    return await _userProvider.getUserByUID(currentUser.uid);
  }

  Future<model.User> getUserByUID(String uid) async {
    return await _userProvider.getUserByUID(uid);
  }

  Future<void> _createUserForCurrentFirebaseUser() async {
    model.User user = model.User();
    user.hoTen = currentUser.displayName;
    user.email = currentUser.email;
    user.uid = currentUser.uid;
    user.urlHinhDaiDien = currentUser.photoURL ?? "";
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

  /// Attempts linking **already signed in** anonymous account's data to the now-signing-in [authCredential].
  ///
  /// The [email] parameter is used to check for existing data already linked with [authCredential] before actually linking.
  Future<bool> _tryLinkAnonDataToAuthCredential(
      String email, AuthCredential authCredential) async {
    if (currentUser != null && currentUser.isAnonymous) {
      final signInMethods =
          await _firebaseAuth.fetchSignInMethodsForEmail(email);
      if (signInMethods.isEmpty) {
        await currentUser.linkWithCredential(authCredential);
        return true;
      } else {
        await _deleteCurrentAnonUser();
        return false;
      }
    } else
      return false;
  }

  Future<void> _deleteCurrentAnonUser() async {
    if (currentUser != null && currentUser.isAnonymous) {
      await _userProvider.deleteUser(userUid: currentUser.uid);
      await currentUser.delete();
    }
  }

  // endregion
}
