import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'package:rent_finder_hi/data/models/models.dart' as model;
import 'package:rent_finder_hi/data/repos/repos.dart' as repos;

import 'package:rent_finder_hi/logic/bloc.dart';
import 'package:rent_finder_hi/presentation/screens/screens.dart';
import 'package:rent_finder_hi/presentation/widgets/widgets.dart';
import 'package:rent_finder_hi/utils/format.dart';

import '../../constants.dart';

class SearchArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderSearchScreen(size: size),
              SizedBox(height: defaultPadding),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SearchBar(
                      hintText: "Tìm theo khu vực hoặc địa chỉ",
                      press: () {
                        BlocProvider.of<HouseBloc>(context).add(LoadHouses());
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                    create: (context) => FilteredHousesBloc(
                                        housesBloc: BlocProvider.of<HouseBloc>(
                                            context)),
                                    child: SearchResultScreen())));
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: defaultPadding),
              // Text(
              //   'Đã xem gần đây',
              //   style: TextStyle(fontSize: 16),
              // ),

              SizedBox(height: defaultPadding),
              Expanded(
                child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (context, authState) {
                    if (authState is AuthenticationStateSuccess)
                      BlocProvider.of<RecentViewBloc>(context)
                          .add(LoadViewedHouses(userUid: authState.user.uid));
                    return BlocBuilder<RecentViewBloc, RecentViewState>(
                      builder: (context, state) {
                        if (authState is AuthenticationStateSuccess) {
                          if (state
                              is RecentViewLoaded) if (state.houses.length > 0)
                            return ListView.builder(
                              itemCount: state.houses.length,
                              itemBuilder: (context, index) {
                                return RecentHomeListTile(
                                  size: size,
                                  house: state.houses[index],
                                );
                              },
                            );
                          else
                            return Center(
                                child: SvgPicture.asset(
                              'assets/images/search.svg',
                              width: MediaQuery.of(context).size.width,
                            ));
                          else {
                            return Center(child: CircularProgressIndicator());
                          }
                        } else {
                          return Center(
                              child: SvgPicture.asset(
                            'assets/images/search.svg',
                            width: MediaQuery.of(context).size.width,
                          ));
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RecentHomeListTile extends StatelessWidget {
  const RecentHomeListTile({
    Key key,
    @required this.size,
    this.house,
  }) : super(key: key);

  final Size size;
  final model.House house;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, authState) {
            return BlocBuilder<RecentViewBloc, RecentViewState>(
              builder: (context, state) {
                return GestureDetector(
                  onTap: () async {
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
                      BlocProvider.of<RecentViewBloc>(context)
                          .add(AddToViewed(user: authState.user, house: house));
                    }
                    Navigator.pushNamed(context, '/detail', arguments: [
                      await repos.HouseRepository().getHouseByUid(house.uid)
                    ]);
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
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
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
                                Format.toMoney(house.tienThueThang),
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
                );
              },
            );
          },
        ),
        BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, authState) {
            return GestureDetector(
              onTap: () {
                if (authState is AuthenticationStateSuccess) {
                  BlocProvider.of<RecentViewBloc>(context).add(
                      RemoveViewedHouse(user: authState.user, house: house));
                }
              },
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.all(defaultPadding * 0.75),
                  child: Icon(Icons.close),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
