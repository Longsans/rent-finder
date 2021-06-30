import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:flutter/cupertino.dart';
import 'package:rent_finder_hi/data/models/models.dart';
import 'package:flutter/foundation.dart';
import 'package:rent_finder_hi/data/models/models.dart' as model;
import 'data_providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class HouseFireStoreApi {
  UserFireStoreApi userFireStoreApi = UserFireStoreApi();

  // get methods
  Stream<List<House>> houses() {
    return _collection
        .where('daGo', isEqualTo: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((e) {
        final map = e.data() as Map<String, dynamic>;
        map['uid'] = e.reference.id;
        return House.fromJson(map);
      }).toList();
    });
  }

  Stream<List<House>> newestHouses() {
    return _collection
        .where('daGo', isEqualTo: false)
        .orderBy('ngayCapNhat', descending: true)
        .limit(5)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((e) {
        final map = e.data() as Map<String, dynamic>;
        map['uid'] = e.reference.id;
        return House.fromJson(map);
      }).toList();
    });
  }

  Stream<List<House>> housesByLocation(String quanHuyen, String phuongXa) {
    if (quanHuyen == null) return houses();
    Query<Object> query;
    if (phuongXa == null) {
      query = _collection
          .where('quanHuyen', isEqualTo: quanHuyen)
          .where('daGo', isEqualTo: false);
    } else {
      query = _collection
          .where('quanHuyen', isEqualTo: quanHuyen)
          .where('phuongXa', isEqualTo: phuongXa)
          .where('daGo', isEqualTo: false);
    }
    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((e) {
        final map = e.data() as Map<String, dynamic>;
        map['uid'] = e.reference.id;

        return House.fromJson(map);
      }).toList();
    });
  }

  Future<List<House>> getHousesByLocation(
      String quanHuyen, String phuongXa) async {
    Query query = _collection.where('daGo', isEqualTo: false);
    QuerySnapshot<Object> querySnapshot;

    if (quanHuyen != null) {
      if (phuongXa == null) {
        querySnapshot =
            await query.where('quanHuyen', isEqualTo: quanHuyen).get();
      } else {
        querySnapshot = await query
            .where('quanHuyen', isEqualTo: quanHuyen)
            .where('phuongXa', isEqualTo: phuongXa)
            .get();
      }
    } else
      querySnapshot = await query.get();

    final docs = querySnapshot.docs;
    if (docs.isNotEmpty) {
      return docs.map((e) {
        final map = e.data() as Map<String, dynamic>;
        map['uid'] = e.reference.id;

        return House.fromJson(map);
      }).toList();
    }
    return [];
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

  Stream<List<House>> myHouses(String userUid) {
    return _collection
        .where('idChuNha', isEqualTo: userUid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((e) {
        final map = e.data() as Map<String, dynamic>;
        map['uid'] = e.reference.id;

        return House.fromJson(map);
      }).toList();
    });
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

  // end region

  // Create and Delete methods
  String createHouseDocument() {
    return _collection.doc().id;
  }

  Future<void> setHouseData(House house) async {
    await _collection.doc(house.uid).set(house.toJson());
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

  // end region

  // Update methods

  //TODO: TEST updateHouse method
  /// Updates the house with UID of [updatedHouse] with the data in [updatedHouse]
  Future<void> updateHouse({@required House updatedHouse}) async {
    final updatedHouseMap = updatedHouse.toJson();
    updatedHouseMap['dangCapNhat'] = true;
    await _collection.doc(updatedHouse.uid).update(updatedHouseMap);

    final savedHousesList = await _savedHousesCollection
        .where('houseUid', isEqualTo: updatedHouse.uid)
        .get();
    final viewedHouseList = await _viewedHousesCollection
        .where('houseUid', isEqualTo: updatedHouse.uid)
        .get();
    final batch = FirebaseFirestore.instance.batch();

    try {
      for (final doc in savedHousesList.docs) {
        batch.update(doc.reference, updatedHouse.toSnippetJson());
      }
      for (final doc in viewedHouseList.docs) {
        batch.update(doc.reference, updatedHouse.toSnippetJson());
      }
      await batch.commit();
    } on FirebaseException {
      rethrow;
    } finally {
      await _collection.doc(updatedHouse.uid).update({'dangCapNhat': false});
      await _deleteUnusedHousePictures(updatedHouse);
    }
  }

  Future<void> updateViewedHouseViewTime(String houseUid) async {
    await _viewedHousesCollection
        .doc(houseUid)
        .update({'ngayCapNhat': DateTime.now()});
  }

  Future<void> setHouseRemoved(String uid) async {
    await _collection.doc(uid).update({'daGo': true});
  }

  Future<void> setHouseUnremoved(String uid) async {
    await _collection.doc(uid).update({'daGo': false});
  }

  // end region

  // Other methods
  Future<String> uploadHousePicAndGetDownloadUrl(
      {@required model.House house, @required File file}) async {
    final newPfpRef = _storageRoot
        .child('house_pfp')
        .child(house.uid)
        .child(path.basename(file.path));
    var uploadTask = newPfpRef.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    String url = await taskSnapshot.ref.getDownloadURL();
    return url;
  }

  Future<void> _deleteUnusedHousePictures(House house) async {
    final ListResult housePicsRef =
        await _storageRoot.child(house.uid).listAll();

    housePicsRef.items.forEach((element) async {
      if (!house.urlHinhAnh.contains(await element.getDownloadURL()))
        await element.delete();
    });
  }

  // end region

  // private references
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('houses');

  final CollectionReference _savedHousesCollection =
      FirebaseFirestore.instance.collection('savedHouses');

  final CollectionReference _viewedHousesCollection =
      FirebaseFirestore.instance.collection('viewedHouses');

  final Reference _storageRoot = FirebaseStorage.instance.ref();
}
