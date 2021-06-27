import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rent_finder_hi/data/models/models.dart' as model;
import 'package:rent_finder_hi/presentation/widgets/widgets.dart';

import 'package:rent_finder_hi/utils/format.dart';

import '../../constants.dart';
import 'category_card.dart';

class HouseInfoBigCard extends StatelessWidget {
  const HouseInfoBigCard({
    Key key,
    this.house,
  }) : super(key: key);
  final model.House house;

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
            child: CachedNetworkImage(
              imageUrl: house.urlHinhAnh[0] ?? '',
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Icon(
                Icons.error_outline,
                size: 100,
                color: Colors.red,
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CategoryCard(
                      category: (house.loaiChoThue == model.LoaiChoThue.CanHo)
                          ? 'Căn hộ'
                          : (house.loaiChoThue == model.LoaiChoThue.Nha)
                              ? 'Nhà'
                              : 'Phòng'),
                  SizedBox(
                    height: defaultPadding / 4,
                  ),
                  Text(
                    Format.toMoneyPerMonth(house.tienThueThang),
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
                    house.diaChi,
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
                            Text('${house.soPhongNgu}'),
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
                            Text('${house.soPhongTam}'),
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
                            Text('${house.dienTich}'),
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
