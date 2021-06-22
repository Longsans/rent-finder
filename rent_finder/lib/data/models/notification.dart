import 'models.dart';

class Notification extends SerializableObject {
  Notification(
      {this.nguoiGui,
      this.thoiGianGui,
      this.chuDe,
      this.tinNhan,
      this.daXem,
      this.daXoa});

  Notification.fromJson(Map<String, dynamic> json) {
    Notification(
        thoiGianGui: json['thoiGianGui'] as DateTime,
        chuDe: json['chuDe'] as String,
        tinNhan: json['tinNhan'] as String,
        daXem: json['daXem'] as bool,
        daXoa: json['daXoa'] as bool);

    if (json.containsKey('nguoiGui')) {
      nguoiGui = User(
          uid: json['nguoiGui']['uid'] as String,
          hoTen: json['nguoiGui']['hoTen'] as String);
    } else {
      nguoiGui = null;
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonMap = {
      'thoiGianGui': thoiGianGui,
      'chuDe': chuDe,
      'tinNhan': tinNhan,
      'daXem': daXem,
      'daXoa': daXoa
    };

    if (nguoiGui != null) {
      jsonMap['nguoiGui']['uid'] = nguoiGui.uid;
      jsonMap['nguoiGui']['hoTen'] = nguoiGui.hoTen;
    }

    return jsonMap;
  }

  User nguoiGui;
  DateTime thoiGianGui;
  String chuDe;
  String tinNhan;
  bool daXem;
  bool daXoa;
  // EmbeddedInfo thongTinDinhKem;
}

class EmbeddedInfo extends SerializableObject {
  EmbeddedInfo({this.hoTen, this.sdt, this.email});

  EmbeddedInfo.fromJson(Map<String, dynamic> json) {
    hoTen = json['hoTen'] as String;
    sdt = json['sdt'] as String;
    email = json['email'] as String;
  }

  @override
  Map<String, dynamic> toJson() {
    return {'hoTen': hoTen, 'sdt': sdt, 'email': email};
  }

  String hoTen;
  String sdt;
  String email;
}
