import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rent_finder_hi/constants.dart';
import 'package:rent_finder_hi/data/models/filter.dart';
import 'package:rent_finder_hi/data/models/house.dart';
import 'package:rent_finder_hi/logic/bloc.dart';
import 'package:rent_finder_hi/presentation/widgets/widgets.dart';

class SearchResultScreen extends StatelessWidget {
  SearchResultScreen({Key key}) : super(key: key);
  Filter filter = Filter();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Builder(
          builder: (context) => Container(
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    SearchBar(
                      hintText: "Quận 3, TP.HCM",
                      press: () async {
                        var t = showModalBottomSheet<Filter>(
                            context: context,
                            builder: (context) {
                              return LocationBottomSheet(
                                filter: filter,
                              );
                            });
                        t.then((value) {
                          if (value != null) {
                            filter = value;
                            BlocProvider.of<FilteredHousesBloc>(context)
                                .add(UpdateFilter(filter: filter));
                          }
                        });
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
                    child: BlocProvider(
                      create: (context) => CategoryCubit(),
                      child: Builder(
                        builder: (context) => Row(
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
                                var t = showModalBottomSheet<Filter>(
                                    context: context,
                                    builder: (context) {
                                      return FilterBasicBottomSheet(
                                        filter: filter,
                                      );
                                    });
                                t.then((value) {
                                  if (value != null) {
                                    filter = value;
                                    BlocProvider.of<FilteredHousesBloc>(context)
                                        .add(UpdateFilter(filter: filter));
                                  }
                                });
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
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    BlocBuilder<FilteredHousesBloc, FilteredHousesState>(
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
                  child: BlocBuilder<FilteredHousesBloc, FilteredHousesState>(
                    builder: (context, state) {
                      if (state is FilteredHousesLoaded)
                        return ListView.builder(
                          itemBuilder: (context, index) {
                            return HouseInfoBigCard(
                                house: state.filteredHouses[index]);
                          },
                          itemCount: state.filteredHouses.length,
                        );
                      return Container();
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
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
                UpdateFilter(
                  filter: filter,
                ),
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
