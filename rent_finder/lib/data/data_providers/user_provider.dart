import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'data_providers.dart';
import 'package:rent_finder_hi/data/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserFireStoreApi {
  Future<User> getUserByUID(String uid) async {
    final snapshot = await _collection.doc(uid).get();
    if (snapshot.exists) {
      final map = snapshot.data() as Map<String, dynamic>;
      map['uid'] = snapshot.reference.id;

      return User.fromJson(map);
    }
    return null;
  }

  Future<User> getUserByEmail(String email) async {
    final querySnapshot =
        await _collection.where('email', isEqualTo: email).get();

    User user;
    if (querySnapshot.docs.length > 0) {
      final doc = querySnapshot.docs.first;
      final map = doc.data() as Map<String, dynamic>;
      map['uid'] = doc.reference.id;
      user = User.fromJson(map);
    }

    return user;
  }

  /// Create a user in Firestore database with uid as uid of the **signed in** user
  ///
  /// **NOTE:** When creating a new user, call *Auth.instance.signIn* first and after that pass the UID of the signed in user to this function
  Future<void> createUser(User user) async {
    await _collection.doc(user.uid).set(user.toJson());
  }

  Future<void> updateAllUserInfo({@required User updatedUser}) async {
    await _collection.doc(updatedUser.uid).set(updatedUser.toJson());
  }

  Future<void> updateHoTenUser({@required User updatedUser}) async {
    await _collection.doc(updatedUser.uid).update({'hoTen': updatedUser.hoTen});
  }

  Future<void> updateSdtUser({@required User updatedUser}) async {
    await _collection.doc(updatedUser.uid).update({'sdt': updatedUser.sdt});
  }

  Future<void> updateMoTaUser({@required User updatedUser}) async {
    await _collection.doc(updatedUser.uid).update({'moTa': updatedUser.moTa});
  }

  /// Updates the **current** user with the new profile picture, identified by [pathHinhDaiDien];
  /// then set the new urlHinhDaiDien to [user]
  Future<void> updateHinhDaiDienUser(
      {@required User user, @required String pathHinhDaiDien}) async {
    // Create new File from pathHinhDaiDien and upload it to Storage with file name as user's uid
    final file = File(pathHinhDaiDien);
    final newPfpRef = _storageRoot.child('user_pfp').child(user.uid);
    var uploadTask = newPfpRef.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    String url = await taskSnapshot.ref.getDownloadURL();

    // And update the new download URL for user's new pfp
    await _collection.doc(user.uid).update({'urlHinhDaiDien': url});
  }

  Future<void> updateEmailUser({@required User updatedUser}) async {
    await Auth.instance.updateEmail(updatedUser.email);
    await _collection.doc(updatedUser.uid).update({'email': updatedUser.email});
  }

  Future<void> deleteUser({@required String userUid}) async {
    await _collection.doc(userUid).delete();
  }

  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('users');

  final Reference _storageRoot = FirebaseStorage.instance.ref();
}
