import 'dart:core';
import 'models.dart';

class User extends SerializableObject {
  User(
      {this.hoTen,
      this.soDienThoai,
      this.email,
      this.urlHinhDaiDien,
      this.moTa,
      this.banned,
      this.uid});

  @override
  User.fromJson(Map<String, dynamic> json) {
    hoTen = json['hoTen'] as String;
    soDienThoai = json['soDienThoai'] as String;
    email = json['email'] as String;
    urlHinhDaiDien = json['urlHinhDaiDien'] as String;
    moTa = json['moTa'] as String;
    banned = json['banned'] as bool;

    if (json.containsKey('uid')) {
      uid = json['uid'] as String;
    }
  }

  String hoTen;
  String soDienThoai;
  String email;
  String urlHinhDaiDien;
  String moTa;
  bool banned;
  String uid;

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = {
      'hoTen': this.hoTen,
      'soDienThoai': this.soDienThoai,
      'email': this.email,
      'urlHinhDaiDien': this.urlHinhDaiDien,
      'moTa': this.moTa,
      'banned': this.banned
    };
    if (uid != null) {
      jsonMap['uid'] = this.uid;
    }

    return jsonMap;
  }
}
