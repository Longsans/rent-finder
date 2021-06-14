import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rent_finder/constants.dart';
import 'package:rent_finder/logic/bloc.dart';
import 'package:rent_finder/presentation/widgets/widgets.dart';


class SearchResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.centerRight,
                children: [
                  SearchBar(
                    hintText: "Quận 3, TP.HCM",
                    press: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return LocationBottomSheet();
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      FilterHouseButton(title: "Bộ lọc", type: 0),
                      SizedBox(
                        width: defaultPadding,
                      ),
                      FilterHouseButton(
                        title: "Nhà trọ",
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
                  BlocBuilder<CategoryBloc, CategoryState>(
                    builder: (context, state) {
                      if (state is CategoryLoaded)
                        return Text(
                          ('${state.houses.length} kết quả'),
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
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
              BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, state) {
                if (state is CategoryInitial) {
                  BlocProvider.of<CategoryBloc>(context).add(CategoryStarted());
                } else if (state is CategoryLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is CategoryLoaded) {
                  return Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return HouseInfoBigCard(
                          house: state.houses[index],
                        );
                      },
                      itemCount: state.houses.length,
                    ),
                  );
                }
                return Center(
                  child: Text('Đã có lỗi xảy ra'),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}

class FilterHouseButton extends StatelessWidget {
  const FilterHouseButton({
    Key key,
    this.title,
    this.type = 1,
  }) : super(key: key);
  final int type;
  final String title;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FilterHouseCubit(),
      child: BlocBuilder<FilterHouseCubit, bool>(
        builder: (context, state) {
          return OutlinedButton(
            onPressed: () {
              if (type == 1) {
                BlocProvider.of<FilterHouseCubit>(context).click();
                BlocProvider.of<CategoryBloc>(context)
                    .add(CategoryPressed(isClicked: state, query: title));
              } else
                showDialog(
                    context: context,
                    builder: (context) {
                      return FilterBasicDialog();
                    });
            },
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              backgroundColor: MaterialStateProperty.all(
                  state ? Colors.black87 : Colors.white),
            ),
            child: Text(
              title,
              style: TextStyle(
                  color: state ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 20),
            ),
          );
        },
      ),
    );
  }
}
