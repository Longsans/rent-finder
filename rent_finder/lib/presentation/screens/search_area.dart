import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'package:rent_finder_hi/data/models/models.dart' as model;

import 'package:rent_finder_hi/logic/bloc.dart';
import 'package:rent_finder_hi/presentation/widgets/widgets.dart';

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
                        var t = showModalBottomSheet<List<String>>(
                            context: context,
                            builder: (context) {
                              return LocationBottomSheet();
                            });
                        t.then((value) {
                          if (value != null) {
                            BlocProvider.of<HouseBloc>(context)
                                .add(LoadHouses(value[0], value[1], sortType: 0));
                            Navigator.pushNamed(context, '/result',
                                arguments: [value[0], value[1]]);
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: defaultPadding),
              BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, authState) {
                  return BlocBuilder<RecentViewBloc, RecentViewState>(
                    builder: (context, state) {
                      if (authState is AuthenticationStateSuccess &&
                          state is RecentViewLoaded) {
                        if (state.houses.length > 0)
                          return Container(
                            margin: EdgeInsets.only(bottom: defaultPadding),
                            child: Text(
                              'Đã xem gần đây',
                              style: TextStyle(fontSize: 16),
                            ),
                          );
                        else
                          return Container();
                      } else
                        return Container();
                    },
                  );
                },
              ),
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
        HouseInfoSmallCard(
          size: size,
          house: house,
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
