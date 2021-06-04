import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rent_finder/constants.dart';

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
                  return HomeInfoBigCard(
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

class HomeInfoBigCard extends StatelessWidget {
  const HomeInfoBigCard({
    Key key,
    this.house,
  }) : super(key: key);
  final House house;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: defaultPadding),
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  image: DecorationImage(
                      fit: BoxFit.cover, image: AssetImage(house.imgSrc))),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: defaultPadding / 4,
                      horizontal: defaultPadding,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: textColor,
                    ),
                    child: Text(house.category,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        )),
                  ),
                  SizedBox(
                    height: defaultPadding / 4,
                  ),
                  Text(
                    house.price,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff318E99),
                    ),
                  ),
                  SizedBox(
                    height: defaultPadding / 4,
                  ),
                  Text(
                    house.location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            SvgPicture.asset(
                              'assets/icons/bed.svg',
                              width: 30,
                              height: 30,
                            ),
                            SizedBox(
                              width: defaultPadding / 2,
                            ),
                            Text('${house.numOfBed}'),
                          ],
                        ),
                        SizedBox(
                          width: defaultPadding * 2,
                        ),
                        Row(
                          children: <Widget>[
                            SvgPicture.asset(
                              'assets/icons/bathtub.svg',
                              width: 30,
                              height: 30,
                            ),
                            SizedBox(
                              width: defaultPadding / 2,
                            ),
                            Text('${house.numOfBath}'),
                          ],
                        ),
                        SizedBox(
                          width: defaultPadding * 2,
                        ),
                        Row(
                          children: <Widget>[
                            SvgPicture.asset(
                              'assets/icons/area.svg',
                              width: 30,
                              height: 30,
                            ),
                            SizedBox(
                              width: defaultPadding / 2,
                            ),
                            Text('${house.area}'),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
