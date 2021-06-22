import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:rent_finder_hi/data/models/models.dart';
import 'package:flutter/foundation.dart';
import 'package:rent_finder_hi/data/models/models.dart' as model;
import 'data_providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class HouseFireStoreApi extends BaseApi {
  UserFireStoreApi userFireStoreApi = UserFireStoreApi();

  Stream<List<House>> houses() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs.map((e) {
        final map = e.data() as Map<String, dynamic>;
        map['uid'] = e.reference.id;
        return House.fromJson(map);
      }).toList();
    });
  }

  //TODO: decide changes to implement
  Future<List<House>> housesOwnedByUser(String userUid) async {
    final queryResult =
        await _collection.where('idChuNha', isEqualTo: userUid).get();
    final houseList = <House>[];

    queryResult.docs.forEach((element) {
      final map = element.data() as Map<String, dynamic>;
      houseList.add(House.fromJson(map));
    });
    return houseList;
  }

  Future<House> getHouseByUID(String uid) async {
    final doc = await _collection.doc(uid).get();

    if (doc.exists) {
      final map = doc.data() as Map<String, dynamic>;
      map['uid'] = doc.reference.id;

      return House.fromJson(map);
    }
    return null;
  }

  Stream<List<House>> savedHouses(String userUid) {
    return _savedHousesCollection
        .where('userUid', isEqualTo: userUid)
        .orderBy('ngayCapNhat', descending: true)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((e) {
        final map = e.data();
        return House.fromSnippetJson(map);
      }).toList();
    });
  }

  Stream<List<House>> lastViewedHouses(String userUid) {
    return _viewedHousesCollection
        .where('userUid', isEqualTo: userUid)
        .orderBy('ngayCapNhat', descending: true)
        .limit(10)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((e) {
        final map = e.data();
        return House.fromSnippetJson(map);
      }).toList();
    });
  }

  Future<void> addHouseToUserSavedHouses(String userUid, House house) async {
    final map = house.toSnippetJson();
    map['userUid'] = userUid;
    map['ngayCapNhat'] = DateTime.now();
    _savedHousesCollection.add(map);
  }

  Future<void> addHouseToUserViewedHouses(String userUid, House house) async {
    final map = house.toSnippetJson();
    map['userUid'] = userUid;
    map['ngayCapNhat'] = DateTime.now();
    _viewedHousesCollection.add(map);
  }

  Future<void> removeHouseFromUserSavedHouses(
      String userUid, String houseUid) async {
    final querySnapshot = await _savedHousesCollection
        .where('userUid', isEqualTo: userUid)
        .where('houseUid', isEqualTo: houseUid)
        .get();
    for (var doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> removeHouseFromUserViewHouses(
      String userUid, String houseUid) async {
    final querySnapshot = await _viewedHousesCollection
        .where('userUid', isEqualTo: userUid)
        .where('houseUid', isEqualTo: houseUid)
        .get();
    for (var doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> createHouse(House house) async {
    await _collection.add(house.toJson());
  }

  Future<void> updateHouse({@required House updatedHouse}) async {
    await _collection.doc(updatedHouse.uid).update(updatedHouse.toJson());
  }

  Future<void> setHouseRemoved(String uid) async {
    await _collection.doc(uid).update({'daGo': true});
  }

  Future<void> setHouseUnremoved(String uid) async {
    await _collection.doc(uid).update({'daGo': false});
  }

  Future<String> getDownloadURL(
      {@required model.House house, @required File file}) async {
    final newPfpRef = _storageRoot
        .child('house_pfp')
        .child(house.ngayVaoO.millisecondsSinceEpoch.hashCode.toString())
        .child(file.path);
    var uploadTask = newPfpRef.putFile(file);
    firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
    String url = await taskSnapshot.ref.getDownloadURL();
    return url;
  }

  // private members
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('houses');

  final CollectionReference _savedHousesCollection =
      FirebaseFirestore.instance.collection('savedHouses');

  final CollectionReference _viewedHousesCollection =
      FirebaseFirestore.instance.collection('viewedHouses');

  final firebase_storage.Reference _storageRoot =
      firebase_storage.FirebaseStorage.instance.ref();
}
