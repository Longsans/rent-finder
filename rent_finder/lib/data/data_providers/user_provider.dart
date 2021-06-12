import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'data_providers.dart';
import 'package:rent_finder/data/models/models.dart' as model;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UserFireStoreApi extends BaseApi {
  Future<model.User> getUserByUID(String uid) async {
    final snapshot = await _collection.doc(uid).get();
    if (snapshot.exists) {
      final map = snapshot.data() as Map<String, dynamic>;
      map['uid'] = snapshot.reference.id;

      return model.User.fromJson(map);
    }
    return null;
  }

  /// Create a user in Firestore database with uid as uid of the **signed in** user
  ///
  /// **NOTE:** When creating a new user, call *Auth.instance.signIn* first and pass the UID of the signed in user to this function
  Future<void> createUser(model.User user) async {
    await _collection.doc(user.uid).set(user.toJson());
  }

  Future<void> updateAllUserInfo({@required model.User updatedUser}) async {
    await _collection.doc(updatedUser.uid).set(updatedUser.toJson());
  }

  Future<void> updateHoTenUser({@required model.User updatedUser}) async {
    await _collection.doc(updatedUser.uid).update({'hoTen': updatedUser.hoTen});
  }

  Future<void> updateSdtUser({@required model.User updatedUser}) async {
    await _collection.doc(updatedUser.uid).update({'sdt': updatedUser.sdt});
  }

  Future<void> updateMoTaUser({@required model.User updatedUser}) async {
    await _collection.doc(updatedUser.uid).update({'moTa': updatedUser.moTa});
  }

  /// Updates the **current** user with the new profile picture, identified by [pathHinhDaiDien];
  /// then set the new urlHinhDaiDien to [user]
  Future<void> updateHinhDaiDienUser(
      {@required model.User user, @required String pathHinhDaiDien}) async {
    // Delete the old pfp from Cloud Storage
    await _storageRoot.child('user_pfp').child(user.uid).delete();

    // Create new File from pathHinhDaiDien and upload it to Storage with file name as user's uid
    final file = File(pathHinhDaiDien);
    final newPfpRef = _storageRoot.child('user_pfp').child(user.uid);
    await newPfpRef.putFile(file);

    // And update the new download URL for user's new pfp
    // (pending changes since i think the download URL doesn't depend on the file that's put there)
    await _collection
        .doc(user.uid)
        .update({'urlHinhDaiDien': await newPfpRef.getDownloadURL()});
  }

  Future<void> updateEmailUser({@required model.User updatedUser}) async {
    await Auth.instance.updateEmail(updatedUser.email);
    await _collection.doc(updatedUser.uid).update({'email': updatedUser.email});
  }

  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('users');

  final firebase_storage.Reference _storageRoot =
      firebase_storage.FirebaseStorage.instance.ref();
}
