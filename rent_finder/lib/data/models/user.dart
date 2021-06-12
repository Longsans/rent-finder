import 'dart:core';
import 'models.dart';

class User extends SerializableObject {
  User(
      {this.hoTen,
      this.sdt,
      this.email,
      this.urlHinhDaiDien,
      this.moTa,
      this.banned,
      this.uid});

  @override
  User.fromJson(Map<String, dynamic> json) {
    uid = json['uid'] as String;
    hoTen = json['hoTen'] as String;
    sdt = json['sdt'] as String;
    email = json['email'] as String;
    urlHinhDaiDien = json['urlHinhDaiDien'] as String;
    moTa = json['moTa'] as String;
    banned = json['banned'] as bool;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'hoTen': this.hoTen,
      'sdt': this.sdt,
      'email': this.email,
      'urlHinhDaiDien': this.urlHinhDaiDien,
      'moTa': this.moTa,
      'banned': this.banned
    };
  }

  String uid;
  String hoTen;
  String sdt;
  String email;
  String urlHinhDaiDien;
  String moTa;
  bool banned;
}
