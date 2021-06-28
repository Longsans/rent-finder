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
      this.ngayCapNhat,
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
    ngayCapNhat = (json['ngayCapNhat'] as Timestamp).toDate();

    coSoVatChat = CoSoVatChat(
      mayGiat: json['coSoVatChat']['mayGiat'] as bool,
      baiDauXe: json['coSoVatChat']['baiDauXe'] as bool,
      banCong: json['coSoVatChat']['banCong'] as bool,
      baoVe: json['coSoVatChat']['baoVe'] as bool,
      cctv: json['coSoVatChat']['cctv'] as bool,
      dieuHoa: json['coSoVatChat']['dieuHoa'] as bool,
      gacLung: json['coSoVatChat']['gacLung'] as bool,
      hoBoi: json['coSoVatChat']['hoBoi'] as bool,
      noiThat: json['coSoVatChat']['noiThat'] as bool,
      nuoiThuCung: json['coSoVatChat']['nuoiThuCung'] as bool,
      sanThuong: json['coSoVatChat']['sanThuong'] as bool,
    );

    moTa = json['moTa'] as String;
    if (json['toaDo'] != null) {
      GeoPoint location = json['toaDo'];
      toaDo = LatLng(location.latitude, location.longitude);
    }

    _daGo = json['daGo'] as bool;
    _chuNha = User(
        uid: json['idChuNha'] as String,
        sdt: json['sdtChuNha'] as String,
        urlHinhDaiDien: json['avatarChuNha'] as String,
        hoTen: json['tenChuNha'] as String);
    _uid = json['uid'] as String;
    _dangCapNhat = json['dangCapNhat'] as bool;
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
    jsonMap['ngayCapNhat'] = ngayCapNhat;
    jsonMap['coSoVatChat'] = {
      'mayGiat': coSoVatChat.mayGiat,
      'baiDauXe': coSoVatChat.baiDauXe,
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
    jsonMap['toaDo'] =
        toaDo != null ? GeoPoint(toaDo.latitude, toaDo.longitude) : null;
    jsonMap['dangCapNhat'] = _dangCapNhat;

    return jsonMap;
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
  DateTime ngayCapNhat;
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

class CoSoVatChat {
  CoSoVatChat(
      {this.mayGiat,
      this.baiDauXe,
      this.dieuHoa,
      this.banCong,
      this.noiThat,
      this.gacLung,
      this.baoVe,
      this.hoBoi,
      this.sanThuong,
      this.cctv,
      this.nuoiThuCung});

  bool mayGiat;

  bool baiDauXe;
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
