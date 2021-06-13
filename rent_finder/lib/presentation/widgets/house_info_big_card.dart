import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:rent_finder/constants.dart';
import 'package:rent_finder/logic/heart/heart_bloc.dart';

import 'category_card.dart';
import 'yellow_heart_button.dart';

class HouseInfoBigCard extends StatelessWidget {
  const HouseInfoBigCard({
    Key key,
    this.house,
  }) : super(key: key);
  final House house;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HeartBloc>(
      create: (context) => HeartBloc(house),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/detail',
                  arguments: [house]);
            },
            child: Container(
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
                              fit: BoxFit.cover,
                              image: AssetImage(house.imgSrc))),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(defaultPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CategoryCard(category: house.category),
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
                              color: Color(0xffB3B3B3),
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
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding * 0.75),
              child: YellowHeartButton(
                  house: house,
                  press: () {
                    Navigator.of(context).pushReplacementNamed('/');
                  }),
            ),
          ),
        ],
      ),
    );
  }
}

