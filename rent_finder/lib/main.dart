import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rent_finder/presentation/screens/find_house_screen.dart';
import 'package:rent_finder/presentation/screens/search_result_screen.dart';
import 'package:rent_finder/presentation/screens/search_screen.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SearchScreen(),
    );
  }
}
