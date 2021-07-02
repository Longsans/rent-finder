import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rent_finder_hi/data/models/models.dart' as model;
import 'package:rent_finder_hi/logic/bloc.dart';
import 'package:rent_finder_hi/presentation/widgets/widgets.dart';
import 'package:rent_finder_hi/utils/format.dart';

import '../../constants.dart';

class HouseInfoSmallCard extends StatelessWidget {
  const HouseInfoSmallCard({
    Key key,
    @required this.size,
    this.house,
  }) : super(key: key);

  final Size size;
  final model.House house;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailHouseCubit(),
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, authState) {
          return BlocBuilder<RecentViewBloc, RecentViewState>(
            builder: (context, state) {
              return BlocListener<DetailHouseCubit, DetailHouseState>(
                listener: (context, detailState) {
                  if (detailState.status == DetailStatus.success) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    if (detailState.house.daGO == true) {
                      var t = showDialog(
                        context: context,
                        builder: (_) => ConfirmDialog(
                          title:
                              'Bài đăng này đã bị gỡ, bạn có muốn xóa khỏi danh sách không?',
                        ),
                      );
                      t.then(
                        (value) {
                          if (value != null) {
                            if (value) {
                              BlocProvider.of<RecentViewBloc>(context).add(
                                  RemoveViewedHouse(
                                      user: (authState
                                              as AuthenticationStateSuccess)
                                          .user,
                                      house: house));
                              Fluttertoast.showToast(
                                  msg:
                                      'Đã xóa khỏi danh sách xem gần đây');
                            }
                          }
                        },
                      );
                    } else if (detailState.house.dangCapNhat) {
                      Fluttertoast.showToast(
                          msg:
                              'Nhà đang được cập nhật, hãy thử lại sau một lát!');
                    } else {
                      if (state is RecentViewLoaded &&
                          authState is AuthenticationStateSuccess) {
                        if (state.houses
                            .map((e) => e.uid)
                            .toList()
                            .contains(house.uid)) {
                          BlocProvider.of<RecentViewBloc>(context).add(
                              RemoveViewedHouse(
                                  user: authState.user, house: house));
                        }
                        BlocProvider.of<RecentViewBloc>(context).add(
                            AddToViewed(user: authState.user, house: house));
                      }
                      Navigator.of(context)
                          .pushNamed('/detail', arguments: [detailState.house]);
                    }
                  } else if (detailState.status == DetailStatus.loading) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(" Đang tải..."),
                              CircularProgressIndicator(),
                            ],
                          ),
                        ),
                      );
                  } else
                    Fluttertoast.showToast(msg: 'Đã có lỗi xảy ra');
                },
                child: GestureDetector(
                  onTap: () async {
                    BlocProvider.of<DetailHouseCubit>(context).click(house);
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: defaultPadding / 2),
                    padding: EdgeInsets.all(defaultPadding * 0.75),
                    width: double.infinity,
                    height: size.height * 0.15,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        CachedNetworkImage(
                          imageUrl: house.urlHinhAnh[0] ?? '',
                          imageBuilder: (context, imageProvider) => Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(19),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => SizedBox(
                              height: 100,
                              width: 100,
                              child:
                                  Center(child: CircularProgressIndicator())),
                          errorWidget: (context, url, error) => Icon(
                            Icons.error_outline,
                            size: 100,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(
                          width: defaultPadding / 2,
                        ),
                        Expanded(
                          flex: 6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
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
                                height: defaultPadding / 2,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        SvgPicture.asset(
                                          'assets/icons/bed.svg',
                                          width: 25,
                                          height: 25,
                                        ),
                                        SizedBox(
                                          width: defaultPadding / 2,
                                        ),
                                        Text('${house.soPhongNgu}'),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        SvgPicture.asset(
                                          'assets/icons/bathtub.svg',
                                          width: 25,
                                          height: 25,
                                        ),
                                        SizedBox(
                                          width: defaultPadding / 2,
                                        ),
                                        Text('${house.soPhongTam}'),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        SvgPicture.asset(
                                          'assets/icons/area.svg',
                                          width: 25,
                                          height: 25,
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
                        Spacer(),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
