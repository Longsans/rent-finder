import 'dart:core';
import 'models.dart';

class User extends SerializableObject {
  User({this.hoTen, this.soDienThoai, this.email, this.banned, this.uid});

  @override
  User.fromJson(Map<String, dynamic> json) {
    hoTen = json['hoTen'] as String;
    soDienThoai = json['soDienThoai'] as String;
    email = json['email'] as String;
    banned = json['banned'] as bool;

    if (json.containsKey('uid')) {
      uid = json['uid'] as String;
    }
  }

  String hoTen;
  String soDienThoai;
  String email;
  bool banned;
  String uid;

  @override
  Map<String, dynamic> toJson() {
    if (uid == null) {
      return {
        'hoTen': this.hoTen,
        'soDienThoai': this.soDienThoai,
        'email': this.email,
        'banned': this.banned
      };
    } else {
      return {
        'hoTen': this.hoTen,
        'soDienThoai': this.soDienThoai,
        'email': this.email,
        'banned': this.banned,
        'uid': this.uid
      };
    }
  }
}
