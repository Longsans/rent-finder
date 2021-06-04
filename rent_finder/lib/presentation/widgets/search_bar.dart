import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchBar extends StatelessWidget {
  final String hintText;
  const SearchBar({
    Key key,
    this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          icon: SvgPicture.asset('assets/icons/search.svg'),
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
              offset: Offset(0, 17),
              color: Color(0xFFE6E6E6),
              blurRadius: 23,
              spreadRadius: -13)
        ],
      ),
    );
  }
}
