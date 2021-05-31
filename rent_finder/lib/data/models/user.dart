import 'dart:core';
import 'package:flutter/cupertino.dart';

abstract class SerializableObject {
  SerializableObject();
  SerializableObject.fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson();
}

class User extends SerializableObject {
  User(
      {@required this.hoTen,
      @required this.soDienThoai,
      @required this.email,
      @required this.banned});

  @override
  User.fromJson(Map<String, dynamic> json) {
    hoTen = json['hoTen'] as String;
    soDienThoai = json['soDienThoai'] as String;
    email = json['email'] as String;
    banned = json['banned'] as bool;
  }

  String hoTen;
  String soDienThoai;
  String email;
  bool banned;

  @override
  Map<String, dynamic> toJson() {
    return {
      'hoTen': this.hoTen,
      'soDienThoai': this.soDienThoai,
      'email': this.email,
      'banned': this.banned
    };
  }
}
