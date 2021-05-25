import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rent_finder/presentation/screens/search_screen.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: size.height * 0.08,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          BottomNavItem(
            title: "Trang chính",
            svgSrc: "assets/icons/home.svg",
          ),
          BottomNavItem(
            press: () {
            },
            title: "Tìm kiếm",
            svgSrc: "assets/icons/search.svg",
          ),
          BottomNavItem(
            title: "Đã lưu",
            svgSrc: "assets/icons/heart.svg",
          ),
          BottomNavItem(
            title: "Tài khoản",
            svgSrc: "assets/icons/user.svg",
          ),
        ],
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  final String title;
  final String svgSrc;
  final Function press;
  const BottomNavItem({
    Key key,
    this.title,
    this.svgSrc,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SvgPicture.asset(
            svgSrc,
            width: 21,
            height: 21,
          ),
          Text(title),
        ],
      ),
    );
  }
}
