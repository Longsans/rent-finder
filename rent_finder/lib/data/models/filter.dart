import 'package:rent_finder_hi/data/models/models.dart';

class Filter {
  final int soPhongNgu, soPhongTam;
  final LoaiChoThue loaiChoThue;
  final double tienThueMin, tienThueMax, areaMin, areaMax;
  final CoSoVatChat coSoVatChat;
  Filter(
      {this.coSoVatChat,
      this.areaMin,
      this.areaMax,
      this.tienThueMin,
      this.tienThueMax,
      this.soPhongNgu,
      this.soPhongTam,
      this.loaiChoThue});

  Filter copyWith({
    CoSoVatChat coSoVatChat,
    int soPhongNgu,
    int soPhongTam,
    LoaiChoThue loaiChoThue,
    double tienThueMin,
    double tienThueMax,
    double areaMin,
    double areaMax,
  }) {
    return Filter(
      coSoVatChat: coSoVatChat ?? this.coSoVatChat,
      areaMax: areaMax ?? this.areaMax,
      areaMin: areaMin ?? this.areaMin,
      soPhongNgu: soPhongNgu ?? this.soPhongNgu,
      soPhongTam: soPhongTam ?? this.soPhongTam,
      loaiChoThue: loaiChoThue ?? this.loaiChoThue,
      tienThueMax: tienThueMax ?? this.tienThueMax,
      tienThueMin: tienThueMin ?? this.tienThueMin,
    );
  }

  @override
  String toString() {
    return 'soPhongNgu: $soPhongNgu, soPhongTam: $soPhongTam, loaiChoThue: $loaiChoThue,tienThueMax: $tienThueMax,tienThueMin: $tienThueMin';
  }
}
