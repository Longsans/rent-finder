import 'package:rent_finder_hi/data/models/models.dart';

class Filter {
  final int soPhongNgu, soPhongTam;
  final LoaiChoThue loaiChoThue;
  final double tienThueMin, tienThueMax;
  Filter(
      {
      this.tienThueMin,
      this.tienThueMax,
      this.soPhongNgu,
      this.soPhongTam,
      this.loaiChoThue});

  Filter copyWith({
    int soPhongNgu,
    int soPhongTam,
    LoaiChoThue loaiChoThue,
    double tienThueMin,
    double tienThueMax,
  }) {
    return Filter(

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
