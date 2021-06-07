import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rent_finder/constants.dart';
import 'package:rent_finder/presentation/widgets/house_info_big_card.dart';

import 'package:rent_finder/presentation/widgets/search_bar.dart';

class SearchResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.centerRight,
              children: [
                SearchBar(
                  hintText: "Quận 3, TP.HCM",
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 25,
                    width: 25,
                    margin: EdgeInsets.only(right: defaultPadding / 2),
                    child: SvgPicture.asset('assets/icons/close.svg'),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: defaultPadding,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FilterHouseButton(
                      title: "Bộ lọc",
                      isActive: true,
                    ),
                    SizedBox(
                      width: defaultPadding,
                    ),
                    FilterHouseButton(
                      title: "Nhà",
                    ),
                    SizedBox(
                      width: defaultPadding,
                    ),
                    FilterHouseButton(
                      title: "Căn hộ",
                    ),
                    SizedBox(
                      width: defaultPadding,
                    ),
                    FilterHouseButton(
                      title: "Chung cư",
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Nhà trọ',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                MaterialButton(
                  onPressed: () {},
                  shape: CircleBorder(),
                  color: Colors.white,
                  child: SvgPicture.asset(
                    "assets/icons/ascending_sort.svg",
                    height: 21,
                    width: 21,
                  ),
                  height: 50,
                ),
              ],
            ),
            SizedBox(
              height: defaultPadding,
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return HouseInfoBigCard(
                    house: houses[index],
                  );
                },
                itemCount: houses.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FilterHouseButton extends StatelessWidget {
  const FilterHouseButton({
    Key key,
    this.title,
    this.isActive = false,
    this.press,
  }) : super(key: key);

  final bool isActive;
  final String title;
  final Function press;
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: press,
      style: ButtonStyle(
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0))),
          backgroundColor: MaterialStateProperty.all(
              isActive ? Colors.black87 : Colors.white)),
      child: Text(
        title,
        style: TextStyle(
            color: isActive ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
            fontSize: 20),
      ),
    );
  }
}

