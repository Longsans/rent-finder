import 'package:flutter/foundation.dart';

import 'models.dart';

/// Model class for all houses
class House extends SerializableObject {
  House.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('quan')) {
      diaChi = DiaChiQuan.fromJson(json);
    } else if (json.containsKey('huyen')) {
      diaChi = DiaChiHuyen.fromJson(json);
    } else {
      throw Exception('Incompatible map type');
    }

    dienTich = json['dienTich'] as double;
    urlHinhAnh = json['urlHinhAnh'] as List<String>;
    loaiChoThue = LoaiChoThue.values.firstWhere(
        (element) => describeEnum(element) == json['loaiChoThue'] as String);
    soPhongNgu = json['soPhongNgu'] as int;
    soPhongTam = json['soPhongTam'] as int;
    tienThueThang = json['tienThueThang'] as double;
    tinhTrang = TinhTrangChoThue.values.firstWhere(
        (element) => describeEnum(element) == json['tinhTrang'].toString());
    ngayVaoO = json['ngayVaoO'] as DateTime;

    coSoVatChat = CoSoVatChat();
    coSoVatChat.mayGiat = CSVCMayGiat.values.firstWhere(
        (element) => describeEnum(element) == json['mayGiat'].toString());
    coSoVatChat.choDauXe = CSVCChoDauXe.values.firstWhere(
        (element) => describeEnum(element) == json['choDauXe'].toString());
    coSoVatChat.banCong = json.containsValue('BanCong');
    coSoVatChat.baoVe = json.containsValue('BaoVe');
    coSoVatChat.cctv = json.containsValue('CCTV');
    coSoVatChat.dieuHoa = json.containsValue('ChoDauXe');
    coSoVatChat.gacLung = json.containsValue('GacLung');
    coSoVatChat.hoBoi = json.containsValue('HoBoi');
    coSoVatChat.noiThat = json.containsValue('NoiThat');
    coSoVatChat.nuoiThuCung = json.containsValue('NuoiThuCung');
    coSoVatChat.sanThuong = json.containsValue('SanThuong');
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonMap = Map<String, dynamic>();
    final diaChiMap = diaChi.toJson();

    jsonMap['diaChi'] = diaChiMap;
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

    return jsonMap;
  }

  // House info
  IDiaChi diaChi;
  double dienTich;
  List<String> urlHinhAnh;
  LoaiChoThue loaiChoThue;
  int soPhongNgu;
  int soPhongTam;
  double tienThueThang;
  TinhTrangChoThue tinhTrang;
  DateTime ngayVaoO;
  CoSoVatChat coSoVatChat;

  bool daGo; // true nếu bài đăng nhà đã bị gỡ
  User chuNha;
}

/// Interface for different types of house addresses in TP.HCM
abstract class IDiaChi extends SerializableObject {
  String soNha;
  String tenDuong;
}

/// "Quận" address type
class DiaChiQuan implements IDiaChi {
  DiaChiQuan.fromJson(Map<String, dynamic> json) {
    soNha = json['soNha'] as String;
    tenDuong = json['tenDuong'] as String;
    phuong = json['phuong'] as String;
    quan = json['quan'] as String;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'soNha': soNha,
      'tenDuong': tenDuong,
      'phuong': phuong,
      'quan': quan,
    };
  }

  @override
  String soNha;
  @override
  String tenDuong;
  String phuong;
  String quan;
}

/// "Huyện" address type
class DiaChiHuyen implements IDiaChi {
  DiaChiHuyen.fromJson(Map<String, dynamic> json) {
    soNha = json['soNha'] as String;
    tenDuong = json['tenDuong'] as String;
    xa = json['xa'] as String;
    huyen = json['huyen'] as String;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'soNha': soNha,
      'tenDuong': tenDuong,
      'xa': xa,
      'huyen': huyen,
    };
  }

  @override
  String soNha;
  @override
  String tenDuong;
  String xa;
  String huyen;
}

/// Enum for renting type
enum LoaiChoThue { Nha, CanHo, Phong }

/// Enum for house rental status
enum TinhTrangChoThue { ConTrong, DaThue, DangBaoTri }

// Enums for facility
enum CSVCMayGiat { TrongNha, TrongKhuChungCu, KhongCo }

enum CSVCChoDauXe { Garage, TrongKhuChungCu, TrongNha }

class CoSoVatChat {
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

// enum CSVCKhac {
//   DieuHoa,
//   BanCong,
//   NoiThat,
//   GacLung,
//   BaoVe,
//   HoBoi,
//   SanThuong,
//   CCTV,
//   NuoiThuCung
// }
