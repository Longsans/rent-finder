import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rent_finder_hi/constants.dart';
import 'package:rent_finder_hi/data/models/filter.dart';
import 'package:rent_finder_hi/data/models/house.dart';
import 'package:rent_finder_hi/logic/bloc.dart';
import 'package:rent_finder_hi/presentation/widgets/widgets.dart';

class SearchResultScreen extends StatelessWidget {
  SearchResultScreen({Key key, this.phuongXa, this.quanHuyen})
      : super(key: key);
  final String phuongXa, quanHuyen;
  Filter filter = Filter(onlyEmpty: true);
  int type = 0;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FilteredHousesBloc(
            housesBloc: BlocProvider.of<HouseBloc>(context),
          )..add(UpdateFilter(filter: filter, type: type)),
        ),
        BlocProvider(
          create: (context) => SearchCubit()..search(quanHuyen, phuongXa),
        ),
        BlocProvider(
          create: (context) => CategoryCubit(),
        ),
      ],
      child: SafeArea(
        child: Scaffold(
          body: Builder(
            builder: (context) => Container(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      BlocBuilder<SearchCubit, List<String>>(
                        builder: (context, state) {
                          return SearchBar(
                            hintText: (state[1] ?? "") +
                                " " +
                                (state[0] ?? "") +
                                " TP.HCM",
                            press: () {
                              var t = showModalBottomSheet<List<String>>(
                                context: context,
                                builder: (context) {
                                  return LocationBottomSheet(
                                    quanHuyen: state[0],
                                    phuongXa: state[1],
                                  );
                                },
                              );
                              t.then(
                                (value) {
                                  if (value != null) {
                                    BlocProvider.of<HouseBloc>(context)
                                        .add(LoadHouses(value[0], value[1]));
                                    BlocProvider.of<SearchCubit>(context)
                                        .search(value[0], value[1]);
                                    BlocProvider.of<CategoryCubit>(context)
                                        .click(null);
                                  }
                                },
                              );
                            },
                          );
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
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
                          SizedBox(
                            width: defaultPadding,
                          ),
                          _buildFilterButton(
                            title: "Bộ lọc",
                            type: 0,
                            press: () async {
                              var t = showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return FilterBasicBottomSheet(
                                      filter: filter,
                                    );
                                  });
                              t.then(
                                (value) {
                                  if (value != null) {
                                    if (value is Filter) {
                                      filter = value;
                                      BlocProvider.of<FilteredHousesBloc>(
                                              context)
                                          .add(UpdateFilter(
                                              filter: filter, type: type));
                                    } else {
                                      var a = Navigator.of(context).pushNamed(
                                          '/filter_enhance',
                                          arguments: [filter]);
                                      a.then((value) {
                                        if (value != null) {
                                          if (value is Filter) {
                                            filter = value;
                                            BlocProvider.of<FilteredHousesBloc>(
                                                    context)
                                                .add(UpdateFilter(
                                                    filter: filter,
                                                    type: type));
                                          } else {
                                            BlocProvider.of<CategoryCubit>(
                                                    context)
                                                .click(null);
                                            filter = Filter(onlyEmpty: true);
                                            BlocProvider.of<FilteredHousesBloc>(
                                                    context)
                                                .add(UpdateFilter(
                                                    filter: filter,
                                                    type: type));
                                          }
                                        }
                                      });
                                    }
                                  }
                                },
                              );
                            },
                          ),
                          SizedBox(
                            width: defaultPadding,
                          ),
                          _buildFilterButton(title: 'Nhà'),
                          SizedBox(
                            width: defaultPadding,
                          ),
                          _buildFilterButton(title: 'Căn hộ'),
                          SizedBox(
                            width: defaultPadding,
                          ),
                          _buildFilterButton(title: 'Phòng'),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      BlocBuilder<HouseBloc, HouseState>(
                        builder: (context, houseState) {
                          if (houseState is HouseLoadSuccess) {
                            return BlocBuilder<FilteredHousesBloc,
                                FilteredHousesState>(
                              builder: (context, state) {
                                if (state is FilteredHousesLoaded)
                                  return Text(
                                    '${state.filteredHouses.length} kết quả',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        .copyWith(fontWeight: FontWeight.bold),
                                  );
                                else
                                  return Container();
                              },
                            );
                          } else
                            return Container();
                        },
                      ),
                      BlocBuilder<SearchCubit, List<String>>(
                        builder: (context, state) {
                          return MaterialButton(
                            onPressed: () {
                              var t = showDialog(
                                context: context,
                                builder: (_) {
                                  return Dialog(
                                    child: Container(
                                      width: 100,
                                      height: 250,
                                      child: BlocProvider(
                                        create: (context) =>
                                            RadioCubit()..click(type),
                                        child: Builder(
                                          builder: (context) =>
                                              BlocBuilder<RadioCubit, int>(
                                            builder: (context, state) {
                                              return Column(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.all(
                                                        defaultPadding),
                                                    color: primaryColor,
                                                    width: double.infinity,
                                                    child: Center(
                                                      child: Text(
                                                        'Sắp xếp theo',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                  ),
                                                  RadioListTile(
                                                    title: Text(
                                                        'Ngày cập nhật mới nhất'),
                                                    value: 0,
                                                    groupValue: state,
                                                    onChanged: (value) {
                                                      BlocProvider.of<
                                                                  RadioCubit>(
                                                              context)
                                                          .click(value);
                                                      Navigator.of(context)
                                                          .pop(value);
                                                    },
                                                  ),
                                                  RadioListTile(
                                                    title: Text('Giá tăng dần'),
                                                    value: 1,
                                                    groupValue: state,
                                                    onChanged: (value) {
                                                      BlocProvider.of<
                                                                  RadioCubit>(
                                                              context)
                                                          .click(value);
                                                      Navigator.of(context)
                                                          .pop(value);
                                                    },
                                                  ),
                                                  RadioListTile(
                                                    title: Text('Giá giảm dần'),
                                                    value: 2,
                                                    groupValue: state,
                                                    onChanged: (value) {
                                                      BlocProvider.of<
                                                                  RadioCubit>(
                                                              context)
                                                          .click(value);
                                                      Navigator.of(context)
                                                          .pop(value);
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                              t.then((value) {
                                if (value != null) {
                                  type = value;
                                  BlocProvider.of<FilteredHousesBloc>(context)
                                      .add(UpdateFilter(
                                          type: type, filter: filter));
                                }
                              });
                            },
                            shape: CircleBorder(),
                            color: Colors.white,
                            child: SvgPicture.asset(
                              "assets/icons/ascending_sort.svg",
                              height: 21,
                              width: 21,
                            ),
                            height: 50,
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: defaultPadding,
                  ),
                  Expanded(
                    child: _buildListHouse(),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  BlocBuilder<AuthenticationBloc, AuthenticationState> _buildListHouse() {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, authState) {
        return BlocBuilder<HouseBloc, HouseState>(
          builder: (context, houseState) {
            if (houseState is HouseLoadSuccess)
              return BlocBuilder<FilteredHousesBloc, FilteredHousesState>(
                builder: (context, state) {
                  if (state is FilteredHousesLoaded)
                    return BlocBuilder<SearchCubit, List<String>>(
                      builder: (context, stringState) {
                        return RefreshIndicator(
                          onRefresh: () async {
                            BlocProvider.of<HouseBloc>(context).add(
                                LoadHouses(stringState[0], stringState[1]));
                          },
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return BlocProvider(
                                create: (context) => DetailHouseCubit(),
                                child: BlocBuilder<RecentViewBloc,
                                    RecentViewState>(
                                  builder: (context, recentState) {
                                    return BlocListener<DetailHouseCubit,
                                        DetailHouseState>(
                                      listener: (context, detailState) {
                                        if (detailState.status ==
                                            DetailStatus.success) {
                                          ScaffoldMessenger.of(context)
                                              .hideCurrentSnackBar();
                                          if (detailState.house.daGO == true)
                                            Fluttertoast.showToast(
                                                msg:
                                                    'Nhà đã bị gỡ vui lòng tải lại trang');
                                          else if (detailState
                                              .house.dangCapNhat) {
                                            Fluttertoast.showToast(
                                                msg:
                                                    'Nhà đang được cập nhật, hãy thử lại sau một lát!');
                                          } else {
                                            if (recentState
                                                    is RecentViewLoaded &&
                                                authState
                                                    is AuthenticationStateSuccess) {
                                              if (recentState.houses
                                                  .map((e) => e.uid)
                                                  .toList()
                                                  .contains(state
                                                      .filteredHouses[index]
                                                      .uid)) {
                                                BlocProvider.of<RecentViewBloc>(
                                                        context)
                                                    .add(
                                                  RemoveViewedHouse(
                                                    user: authState.user,
                                                    house: state
                                                        .filteredHouses[index],
                                                  ),
                                                );
                                              }
                                              BlocProvider.of<RecentViewBloc>(
                                                      context)
                                                  .add(
                                                AddToViewed(
                                                  user: authState.user,
                                                  house: state
                                                      .filteredHouses[index],
                                                ),
                                              );
                                            }
                                            Navigator.of(context).pushNamed(
                                                '/detail',
                                                arguments: [detailState.house]);
                                          }
                                        } else if (detailState.status ==
                                            DetailStatus.loading) {
                                          ScaffoldMessenger.of(context)
                                            ..hideCurrentSnackBar()
                                            ..showSnackBar(
                                              SnackBar(
                                                content: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Text(" Đang tải..."),
                                                    CircularProgressIndicator(),
                                                  ],
                                                ),
                                              ),
                                            );
                                        } else
                                          Fluttertoast.showToast(
                                              msg: 'Đã có lỗi xảy ra');
                                      },
                                      child: Stack(
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              BlocProvider.of<DetailHouseCubit>(
                                                      context)
                                                  .click(state
                                                      .filteredHouses[index]);
                                            },
                                            child: HouseInfoBigCard(
                                                house: state
                                                    .filteredHouses[index]),
                                          ),
                                          SaveButton(
                                              house:
                                                  state.filteredHouses[index])
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                            itemCount: state.filteredHouses.length,
                          ),
                        );
                      },
                    );
                  else
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                },
              );
            else if (houseState is HouseLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Center(child: Text('Có lỗi xảy ra'));
            }
          },
        );
      },
    );
  }

  BlocBuilder<CategoryCubit, String> _buildFilterButton(
      {int type = 1, Function press, String title}) {
    return BlocBuilder<CategoryCubit, String>(
      builder: (context, state) {
        return OutlinedButton(
          onPressed: () async {
            if (type == 1) {
              BlocProvider.of<CategoryCubit>(context).click(title);
              filter = filter.copyWith(
                  loaiChoThue: (title == 'Nhà')
                      ? LoaiChoThue.Nha
                      : (title == 'Căn hộ')
                          ? LoaiChoThue.CanHo
                          : LoaiChoThue.Phong);
              BlocProvider.of<FilteredHousesBloc>(context).add(
                UpdateFilter(filter: filter, type: type),
              );
            } else
              press();
          },
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            backgroundColor: MaterialStateProperty.all(
                (state != title) ? Colors.white : Colors.black87),
          ),
          child: Text(
            title,
            style: TextStyle(
                color: (state == title) ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 20),
          ),
        );
      },
    );
  }
}
