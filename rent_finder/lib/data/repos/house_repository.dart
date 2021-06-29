import 'dart:io';

import 'package:rent_finder_hi/data/data_providers/data_providers.dart';
import 'package:rent_finder_hi/data/models/models.dart';

class HouseRepository {
  Future<void> createHouse(House house, List<File> housePictures) async {
    house.setUid(_houseFireStoreApi.createHouseDocument());
    house.urlHinhAnh =
        await uploadHousePicsAndGetDownloadUrls(house, housePictures);
    await _houseFireStoreApi.setHouseData(house);
  }

  Future<List<String>> uploadHousePicsAndGetDownloadUrls(
      House house, List<File> files) async {
    List<String> urlHinhAnh = [];
    for (int i = 0; i < files.length; i++) {
      String url = await _houseFireStoreApi.uploadHousePicAndGetDownloadUrl(
          house: house, file: files[i]);
      urlHinhAnh.add(url);
    }
    return urlHinhAnh;
  }

  Future<House> getHouseByUid(String uid) async {
    final house = await _houseFireStoreApi.getHouseByUID(uid);
    if (house != null) {
      final chuNha = await _userFireStoreApi.getUserByUID(house.chuNha.uid);
      house.setSensitiveInfo(house.daGO, chuNha);
    }
    return house;
  }

  Stream<List<House>> housesByLocation(String quanHuyen, String phuongXa) {
    return _houseFireStoreApi.housesByLocation(quanHuyen, phuongXa);
  }

  Future<List<House>> getHousesByLocation(
      String quanHuyen, String phuongXa) async {
    return await _houseFireStoreApi.getHousesByLocation(quanHuyen, phuongXa);
  }

  Stream<List<House>> myHouses(String uuid) {
    return _houseFireStoreApi.myHouses(uuid);
  }

  Stream<List<House>> newestHouses() {
    return _houseFireStoreApi.newestHouses();
  }

  Stream<List<House>> savedHouses(String userUid) {
    return _houseFireStoreApi.savedHouses(userUid);
  }

  Stream<List<House>> viewedHouses(String userUid) {
    return _houseFireStoreApi.lastViewedHouses(userUid);
  }

  Future<void> addHouseToUserSavedHouses(String userUid, House house) async {
    await _houseFireStoreApi.addHouseToUserSavedHouses(userUid, house);
  }

  Future<void> removeHouseFromUserSavedHouses(
      String userUid, String houseUid) async {
    await _houseFireStoreApi.removeHouseFromUserSavedHouses(userUid, houseUid);
  }

  Future<void> addHouseToUserViewedHouses(String userUid, House house) async {
    await _houseFireStoreApi.addHouseToUserViewedHouses(userUid, house);
  }

  Future<void> removeHouseFromUserViewHouses(
      String userUid, String houseUid) async {
    await _houseFireStoreApi.removeHouseFromUserViewHouses(userUid, houseUid);
  }

  Future<void> updateHouse(House updatedHouse) async {
    await _houseFireStoreApi.updateHouse(updatedHouse: updatedHouse);
  }

  Future<void> setHouseRemoved(String uid) async {
    await _houseFireStoreApi.setHouseRemoved(uid);
  }

  final HouseFireStoreApi _houseFireStoreApi = HouseFireStoreApi();
  final UserFireStoreApi _userFireStoreApi = UserFireStoreApi();
}
