import 'package:flutter/cupertino.dart';
import 'package:rent_finder/data/models/models.dart';
import 'package:flutter/foundation.dart';

import 'data_providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HouseFireStoreApi extends BaseApi {
  Future<List<House>> getAllHousesOwnedByUser(String userUid) async {
    final queryResult =
        await _collection.where('idChuNha', isEqualTo: userUid).get();
    final houseList = <House>[];

    queryResult.docs.forEach((element) {
      final map = element.data() as Map<String, dynamic>;
      map['uid'] = element.reference.id;

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
    final Map<String, dynamic> map = house.toSubcollectionJson();
    map['ngayCapNhat'] = DateTime.now();

    await _userCollection.doc(userUid).collection('savedHouses').add(map);
  }

  Future<void> addHouseToUserViewedHouses(String userUid, House house) async {
    final Map<String, dynamic> map = house.toSubcollectionJson();
    map['ngayCapNhat'] = DateTime.now();

    await _userCollection.doc(userUid).collection('viewedHouses').add(map);
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

  // private members
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('houses');

  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');
}
