import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:rent_finder/data/data_providers/data_providers.dart';
import 'package:rent_finder/data/models/models.dart' as model;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UserApiProvider extends BaseAPI {
  Future<model.User> getUserByUID(String uid) async {
    final snapshot = await collection.doc(uid).get();
    if (snapshot.exists) {
      return model.User.fromJson(snapshot.data());
    }
    return null;
  }

  Future<void> createUser(model.User user) async {
    await collection.doc(user.uid).set(user.toJsonWithoutUID());
  }

  Future<void> updateAllUserInfo({@required model.User updatedUser}) async {
    await collection.doc(updatedUser.uid).set(updatedUser.toJsonWithoutUID());
  }

  Future<void> updateHoTenUser({@required model.User updatedUser}) async {
    await collection.doc(updatedUser.uid).update({'hoTen': updatedUser.hoTen});
  }

  Future<void> updateSdtUser({@required model.User updatedUser}) async {
    await collection.doc(updatedUser.uid).update({'sdt': updatedUser.sdt});
  }

  Future<void> updateMoTaUser({@required model.User updatedUser}) async {
    await collection.doc(updatedUser.uid).update({'moTa': updatedUser.moTa});
  }

  /// Updates the **current** user with the new profile picture, identified by [pathHinhDaiDien];
  /// then set the new urlHinhDaiDien to [user]
  Future<void> updateHinhDaiDienUser(
      {@required model.User user, @required String pathHinhDaiDien}) async {
    // Delete the old pfp from Cloud Storage
    await storageRoot.child('user_pfp').child(user.uid).delete();

    // Create new File from pathHinhDaiDien and upload it to Storage with file name as user's uid
    final file = File(pathHinhDaiDien);
    final newPfpRef = storageRoot.child('user_pfp').child(user.uid);
    await newPfpRef.putFile(file);

    // And update the new download URL for user's new pfp
    // (pending changes since i think the download URL doesn't depend on the file that's put there)
    await collection
        .doc(user.uid)
        .update({'urlHinhDaiDien': await newPfpRef.getDownloadURL()});
  }

  Future<void> updateEmailUser({@required model.User updatedUser}) {
    //TODO: implement this update user's email shit

    // call update email on firebase auth
    // re-authenticate if needed
    // then update the new email onto firestore

    throw UnimplementedError('imma go have lunch first');
  }

  Future<void> banUser(model.User user) async {
    await collection.doc(user.uid).update({'banned': true});
  }

  Future<void> unbanUser(model.User user) async {
    await collection.doc(user.uid).update({'banned': false});
  }

  final CollectionReference collection =
      FirebaseFirestore.instance.collection('users');

  final firebase_storage.Reference storageRoot =
      firebase_storage.FirebaseStorage.instance.ref();
}
