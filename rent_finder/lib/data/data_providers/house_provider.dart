import 'package:flutter/cupertino.dart';
import 'package:rent_finder/data/models/models.dart';

import 'data_providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HouseFireStoreApi extends BaseApi {
  Future<List<House>> getAllHousesOwnedByUser(User user) async {
    final queryResult =
        await _collection.where('idChuNha', isEqualTo: user.uid).get();
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

  Future<void> createHouse(House house) async {
    await _collection.add(house.toJson());
  }

  Future<void> updateHouse({@required House updatedHouse}) async {
    await _collection.doc(updatedHouse.uid).update(updatedHouse.toJson());
  }

  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('houses');
}
