import 'package:flutter/material.dart';
import 'package:rent_finder_hi/constants.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key key,
    this.title,
    this.icon,
    this.press,
    this.color,
  }) : super(key: key);
  final String title;
  final Icon icon;
  final Function press;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon ?? Container(),
            SizedBox(
              width: defaultPadding / 2,
            ),
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .button
                  .copyWith(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
        decoration: BoxDecoration(
            color: color ?? Color(0xFF0D4880),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 17),
                  color: Color(0xFFE6E6E6),
                  blurRadius: 23,
                  spreadRadius: 0)
            ]),
      ),
    );
  }
}
