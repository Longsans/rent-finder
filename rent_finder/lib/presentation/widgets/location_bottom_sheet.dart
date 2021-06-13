import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_finder/logic/place/commune/commune_cubit.dart';
import 'package:rent_finder/logic/place/district/district_cubit.dart';
import 'package:rent_finder/logic/place/province/province_cubit.dart';

import '../../constants.dart';

class LocationBottomSheet extends StatelessWidget {
  const LocationBottomSheet({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CommuneCubit>(
          create: (context) => CommuneCubit(),
        ),
        BlocProvider<ProvinceCubit>(
          create: (context) => ProvinceCubit(),
        ),
        BlocProvider<DistrictCubit>(
          create: (context) => DistrictCubit(),
        ),
      ],
      child: Container(
        padding: EdgeInsets.all(defaultPadding * 1.25),
        height: 350,
        width: 800,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: defaultPadding,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Lựa chọn địa điểm',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
            SizedBox(
              height: defaultPadding * 1.5,
            ),
            Container(
              padding: EdgeInsets.only(right: defaultPadding * 1.5),
              child: Column(
                children: [
                  BlocBuilder<ProvinceCubit, String>(
                    builder: (context, state) {
                      return DropdownButton(
                        value: state,
                        onChanged: (newValue) {
                          BlocProvider.of<ProvinceCubit>(context)
                              .selectedChange(newValue);
                        },
                        items: Province.map((e) =>
                                DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        hint: Text('Chọn tỉnh/ thành phố'),
                        isExpanded: true,
                      );
                    },
                  ),
                  BlocBuilder<DistrictCubit, String>(
                    builder: (context, state) {
                      return DropdownButton(
                        value: state,
                        onChanged: (newValue) {
                          BlocProvider.of<DistrictCubit>(context)
                              .selectedChange(newValue);
                        },
                        items: District.map((e) =>
                                DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        hint: Text('Chọn quận/huyện'),
                        isExpanded: true,
                      );
                    },
                  ),
                  BlocBuilder<CommuneCubit, String>(
                    builder: (context, state) {
                      return DropdownButton(
                        value: state,
                        onChanged: (newValue) {
                          BlocProvider.of<CommuneCubit>(context)
                              .selectedChange(newValue);
                        },
                        items: [],
                        hint: Text('Chọn xã/phường'),
                        isExpanded: true,
                      );
                    },
                  ),
                ],
              ),
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 17),
                            color: Color(0xFFE6E6E6),
                            blurRadius: 23,
                            spreadRadius: -13)
                      ],
                    ),
                    width: double.infinity,
                    child: Text(
                      'Tìm kiếm',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
