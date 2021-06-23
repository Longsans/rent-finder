import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'models.dart';

/// Model class for all houses
class House extends SerializableObject {
  House(
      {this.soNha,
      this.tenDuong,
      this.phuongXa,
      this.quanHuyen,
      this.dienTich,
      this.urlHinhAnh,
      this.loaiChoThue,
      this.soPhongNgu,
      this.soPhongTam,
      this.tienThueThang,
      this.tinhTrang,
      this.ngayVaoO,
      this.coSoVatChat,
      this.moTa,
      this.toaDo});

  // Map json to members
  House.fromJson(Map<String, dynamic> json) {
    soNha = json['soNha'] as String;
    tenDuong = json['tenDuong'] as String;
    phuongXa = json['phuongXa'] as String;
    quanHuyen = json['quanHuyen'] as String;
    dienTich = json['dienTich'] as double;
    urlHinhAnh = json['urlHinhAnh'].cast<String>();
    loaiChoThue = LoaiChoThue.values.firstWhere(
        (element) => describeEnum(element) == json['loaiChoThue'] as String);
    soPhongNgu = json['soPhongNgu'] as int;
    soPhongTam = json['soPhongTam'] as int;
    tienThueThang = json['tienThueThang'] as double;
    tinhTrang = TinhTrangChoThue.values.firstWhere(
        (element) => describeEnum(element) == json['tinhTrang'].toString());
    ngayVaoO = (json['ngayVaoO'] as Timestamp).toDate();

    coSoVatChat = CoSoVatChat();
    coSoVatChat.mayGiat = CSVCMayGiat.values.firstWhere((element) =>
        describeEnum(element) == json['coSoVatChat']['mayGiat'].toString());
    coSoVatChat.choDauXe = CSVCChoDauXe.values.firstWhere((element) =>
        describeEnum(element) == json['coSoVatChat']['choDauXe'].toString());
    coSoVatChat.banCong = json['coSoVatChat']['banCong'] as bool;
    coSoVatChat.baoVe = json['coSoVatChat']['baoVe'] as bool;
    coSoVatChat.cctv = json['coSoVatChat']['cctv'] as bool;
    coSoVatChat.dieuHoa = json['coSoVatChat']['dieuHoa'] as bool;
    coSoVatChat.gacLung = json['coSoVatChat']['gacLung'] as bool;
    coSoVatChat.hoBoi = json['coSoVatChat']['hoBoi'] as bool;
    coSoVatChat.noiThat = json['coSoVatChat']['noiThat'] as bool;
    coSoVatChat.nuoiThuCung = json['coSoVatChat']['nuoiThuCung'] as bool;
    coSoVatChat.sanThuong = json['coSoVatChat']['sanThuong'] as bool;

    moTa = json['moTa'] as String;
    GeoPoint location = json['toaDo'];
    toaDo = LatLng(location.latitude, location.longitude);

    _daGo = json['daGo'] as bool;
    _chuNha = User(
        uid: json['idChuNha'] as String,
        sdt: json['sdtChuNha'] as String,
        urlHinhDaiDien: json['avatarChuNha'] as String,
        hoTen: json['tenChuNha'] as String);
    _uid = json['uid'] as String;
    _dangCapNhat = json['dangCapNhat'] as bool;
  }

  House.fromSnippetJson(Map<String, dynamic> map) {
    _uid = map['houseUid'] as String;
    soNha = map['soNha'] as String;
    tenDuong = map['tenDuong'] as String;
    phuongXa = map['phuongXa'] as String;
    quanHuyen = map['quanHuyen'] as String;
    dienTich = map['dienTich'] as double;
    loaiChoThue = LoaiChoThue.values.firstWhere(
        (element) => describeEnum(element) == map['loaiChoThue'] as String);
    tienThueThang = map['tienThueThang'] as double;
    soPhongNgu = map['soPhongNgu'] as int;
    soPhongTam = map['soPhongTam'] as int;
    urlHinhAnh = List<String>.from(map['urlHinhAnh']);
  }

  // Serialize
  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonMap = Map<String, dynamic>();

    jsonMap['soNha'] = soNha;
    jsonMap['tenDuong'] = tenDuong;
    jsonMap['phuongXa'] = phuongXa;
    jsonMap['quanHuyen'] = quanHuyen;
    jsonMap['dienTich'] = dienTich;
    jsonMap['urlHinhAnh'] = urlHinhAnh;
    jsonMap['loaiChoThue'] = describeEnum(loaiChoThue);
    jsonMap['soPhongNgu'] = soPhongNgu;
    jsonMap['soPhongTam'] = soPhongTam;
    jsonMap['tienThueThang'] = tienThueThang;
    jsonMap['tinhTrang'] = describeEnum(tinhTrang);
    jsonMap['ngayVaoO'] = ngayVaoO;
    jsonMap['coSoVatChat'] = {
      'mayGiat': describeEnum(coSoVatChat.mayGiat),
      'choDauXe': describeEnum(coSoVatChat.choDauXe),
      'banCong': coSoVatChat.banCong,
      'baoVe': coSoVatChat.baoVe,
      'cctv': coSoVatChat.cctv,
      'dieuHoa': coSoVatChat.dieuHoa,
      'gacLung': coSoVatChat.gacLung,
      'hoBoi': coSoVatChat.hoBoi,
      'noiThat': coSoVatChat.noiThat,
      'nuoiThuCung': coSoVatChat.nuoiThuCung,
      'sanThuong': coSoVatChat.sanThuong,
    };
    jsonMap['moTa'] = moTa;
    jsonMap['daGo'] = _daGo;
    jsonMap['idChuNha'] = _chuNha.uid;
    jsonMap['toaDo'] = GeoPoint(toaDo.latitude, toaDo.longitude);
    jsonMap['dangCapNhat'] = _dangCapNhat;

    return jsonMap;
  }

  Map<String, dynamic> toSnippetJson() {
    return {
      'houseUid': _uid,
      'soNha': soNha,
      'tenDuong': tenDuong,
      'phuongXa': phuongXa,
      'quanHuyen': quanHuyen,
      'dienTich': dienTich,
      'loaiChoThue': describeEnum(loaiChoThue),
      'tienThueThang': tienThueThang,
      'soPhongNgu': soPhongNgu,
      'soPhongTam': soPhongTam,
      'urlHinhAnh': urlHinhAnh,
    };
  }

  /// Set sensitive info including: *daGo*, *chuNha*
  void setSensitiveInfo(bool daGo, User chuNha) {
    this._daGo = daGo;
    this._chuNha = chuNha;
  }

  void setUid(String uid) {
    this._uid = uid;
  }

  // House info
  String soNha;
  String tenDuong;
  String phuongXa;
  String quanHuyen;
  double dienTich;
  List<String> urlHinhAnh;
  LoaiChoThue loaiChoThue;
  int soPhongNgu;
  int soPhongTam;
  double tienThueThang;
  TinhTrangChoThue tinhTrang;
  DateTime ngayVaoO;
  CoSoVatChat coSoVatChat;
  String moTa;
  LatLng toaDo;

  bool _daGo = false; // true nếu bài đăng nhà đã bị gỡ
  User _chuNha;
  String _uid;
  bool _dangCapNhat =
      false; // true nếu thông tin nhà đang được chủ nhà cập nhật

  bool get daGO => _daGo;
  User get chuNha => _chuNha;
  String get uid => _uid;
  bool get dangCapNhat => _dangCapNhat;
  String get diaChi =>
      soNha +
      " " +
      tenDuong +
      ", " +
      phuongXa +
      ", " +
      quanHuyen +
      ", Thành phố Hồ Chí Minh";
}

/// Enum for renting type
enum LoaiChoThue { Nha, CanHo, Phong }

/// Enum for house rental status
enum TinhTrangChoThue { ConTrong, DaThue, DangBaoTri }

// Enums for facility
enum CSVCMayGiat { TrongNha, TrongKhuChungCu, KhongCo }

enum CSVCChoDauXe { Garage, TrongKhuChungCu, TrongNha }

class CoSoVatChat {
  CoSoVatChat(
      {this.mayGiat,
      this.choDauXe,
      this.dieuHoa,
      this.banCong,
      this.noiThat,
      this.gacLung,
      this.baoVe,
      this.hoBoi,
      this.sanThuong,
      this.cctv,
      this.nuoiThuCung});

  CSVCMayGiat mayGiat;
  CSVCChoDauXe choDauXe;
  bool dieuHoa;
  bool banCong;
  bool noiThat;
  bool gacLung;
  bool baoVe;
  bool hoBoi;
  bool sanThuong;
  bool cctv;
  bool nuoiThuCung;
}
