import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:rent_finder/data/models/models.dart';
import 'package:flutter/foundation.dart';
import 'package:rent_finder/data/models/models.dart' as model;
import 'data_providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class HouseFireStoreApi extends BaseApi {
  UserFireStoreApi userFireStoreApi = UserFireStoreApi();
  Stream<List<House>> houses() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs.map((e) {
        final map = e.data() as Map<String, dynamic>;
        return House.fromJson(map);
      }).toList();
    });
  }

  Future<List<House>> getAllHousesOwnedByUser(String userUid) async {
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

      return House.fromJson(map);
    }
    return null;
  }

  Stream<List<String>> savedHouses(String userUid) {
    return _userCollection
        .doc(userUid)
        .collection('savedHouses')
        .orderBy('ngayCapNhat', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((e) {
        final map = e.data();
        return map['uid'] as String;
      }).toList();
    });
  }

  Stream<List<String>> viewedHouses(String userUid) {
    return _userCollection
        .doc(userUid)
        .collection('viewedHouses')
        .orderBy('ngayCapNhat', descending: true)
        .limit(10)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((e) {
        final map = e.data();
       return map['uid'] as String;
      }).toList();
    });
  }

  Future<List<House>> getSavedHousesByUser(String userUid) async {
    final queryResult = await _userCollection
        .doc(userUid)
        .collection('savedHouses')
        .orderBy('ngayCapNhat', descending: true)
        .get();
    final houseList = <House>[];

    queryResult.docs.forEach((element) {
      final map = element.data();

      final house = House.fromSubcollectionJson(map);
      house.setSensitiveInfo(map['daGo'] as bool, null);
      houseList.add(house);
    });

    return houseList;
  }

  Future<List<House>> getRecentlyViewedHousesByUser(String userUid) async {
    final queryResult = await _userCollection
        .doc(userUid)
        .collection('viewedHouses')
        .orderBy('ngayCapNhat', descending: true)
        .limit(5)
        .get();
    final houseList = <House>[];

    queryResult.docs.forEach((element) {
      final map = element.data();

      final house = House.fromSubcollectionJson(map);
      house.setSensitiveInfo(map['daGo'] as bool, null);
      houseList.add(house);
    });

    return houseList;
  }

  Future<void> addHouseToUserSavedHouses(String userUid, House house) async {
    Map<String, dynamic> map = house.toSubcollectionJson();
    map['uid'] = house.uid;
    map['ngayCapNhat'] = DateTime.now();
    await _userCollection
        .doc(userUid)
        .collection('savedHouses')
        .doc(house.uid)
        .set(map);
  }

  Future<void> addHouseToUserViewedHouses(String userUid, House house) async {
    Map<String, dynamic> map = house.toSubcollectionJson();
    map['ngayCapNhat'] = DateTime.now();
    map['uid'] = house.uid;
    await _userCollection
        .doc(userUid)
        .collection('viewedHouses')
        .doc(house.uid)
        .set(map);
  }

  Future<void> removeHouseFromUserSavedHouses(
      String userUid, String houseUid) async {
    await _userCollection
        .doc(userUid)
        .collection('savedHouses')
        .doc(houseUid)
        .delete();
  }

  Future<void> removeHouseFromUserViewHouses(
      String userUid, String houseUid) async {
    await _userCollection
        .doc(userUid)
        .collection('viewedHouses')
        .doc(houseUid)
        .delete();
  }

  Future<void> createHouse(House house) async {
    await _collection.doc(house.uid).set(house.toJson());
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

  Future<String> getDownURL(
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

  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');
  final firebase_storage.Reference _storageRoot =
      firebase_storage.FirebaseStorage.instance.ref();
}
