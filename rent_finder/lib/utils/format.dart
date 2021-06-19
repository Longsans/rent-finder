import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class Format {
  static String toMoney(double num) {
    final formatCurrency = new NumberFormat.simpleCurrency(decimalDigits: 0);
    return formatCurrency.format(num) + " VNĐ/Tháng";
  }

  static Future<LatLng> fromString(String query) async {
    var addresses = await Geocoder.local.findAddressesFromQuery(query);
    var first = addresses.first;
    return LatLng(first.coordinates.latitude, first.coordinates.longitude);
  }
}