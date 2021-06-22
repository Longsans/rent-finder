import 'package:flutter/material.dart';
import 'package:rent_finder_hi/constants.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key key,
    this.category,
  }) : super(key: key);

  final String category;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: defaultPadding / 4,
        horizontal: defaultPadding,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: textColor,
      ),
      child: Text(
        category,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
