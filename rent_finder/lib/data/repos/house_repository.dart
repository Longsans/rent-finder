import 'dart:io';

import 'package:rent_finder/data/data_providers/data_providers.dart';
import 'package:rent_finder/data/models/models.dart' as model;

class HouseRepository {
  final HouseFireStoreApi houseFireStoreApi = HouseFireStoreApi();
  final UserFireStoreApi userFireStoreApi = UserFireStoreApi();
  Future<void> createHouse(model.House house) async {
    return await houseFireStoreApi.createHouse(house);
  }

  Future<List<model.House>> getListHouseByOwner(model.User user) async {
    return await houseFireStoreApi.getAllHousesOwnedByUser(user.uid);
  }

  Future<List<String>> getDownURLs(model.House house, List<File> files) async {
    List<String> urlHinhAnh = [];
    for (int i = 0; i < files.length; i++) {
      String url =
          await houseFireStoreApi.getDownURL(house: house, file: files[i]);
      urlHinhAnh.add(url);
    }
    return urlHinhAnh;
  }

  Future<model.House> getHouseByUid(String uid) async {
    final house = await houseFireStoreApi.getHouseByUID(uid);
    if (house != null)
    {final chuNha = await userFireStoreApi.getUserByUID(house.chuNha.uid);
    house.setSensitiveInfo(false, chuNha);}
    return house;
  }

  Stream<List<model.House>> houses() {
    return houseFireStoreApi.houses();
  }

  Stream<List<String>> savedHouses(String userUid) {
    return houseFireStoreApi.savedHouses(userUid);
  }

  Stream<List<String>> viewedHouses(String userUid) {
    return houseFireStoreApi.viewedHouses(userUid);
  }

  Future<void> addHouseToUserSavedHouses(
      String userUid, model.House house) async {
    await houseFireStoreApi.addHouseToUserSavedHouses(userUid, house);
  }

  Future<void> removeHouseFromUserSavedHouses(
      String userUid, String houseUid) async {
    await houseFireStoreApi.removeHouseFromUserSavedHouses(userUid, houseUid);
  }

  Future<void> addHouseToUserViewedHouses(
      String userUid, model.House house) async {
    await houseFireStoreApi.addHouseToUserViewedHouses(userUid, house);
  }

  Future<void> removeHouseFromUserViewHouses(
      String userUid, String houseUid) async {
    await houseFireStoreApi.removeHouseFromUserViewHouses(userUid, houseUid);
  }
}