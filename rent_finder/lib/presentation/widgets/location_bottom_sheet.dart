import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_finder/data/models/filter.dart';
import 'package:rent_finder/logic/place/commune/commune_cubit.dart';
import 'package:rent_finder/logic/place/district/district_cubit.dart';
import 'package:rent_finder/presentation/widgets/widgets.dart';

import '../../constants.dart';

class LocationBottomSheet extends StatelessWidget {
  LocationBottomSheet({
    this.filter,
    Key key,
  }) : super(key: key);
  Filter filter;
  String quanHuyen, phuongXa;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CommuneCubit>(
          create: (context) => CommuneCubit(),
        ),
        BlocProvider<DistrictCubit>(
          create: (context) => DistrictCubit(),
        ),
      ],
      child: Container(
        padding: EdgeInsets.all(defaultPadding * 1.25),
        height: 300,
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
              height: defaultPadding,
            ),
            _buildLocation(),
            Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomButton(
                title: 'Tìm kiếm',
                press: () {
                  filter = filter.copyWith(quanHuyen: quanHuyen, phuongXa: phuongXa);
                  Navigator.of(context).pop(filter);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Container _buildLocation() {
    return Container(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) {
              if (filter.quanHuyen == null)
                return DistrictCubit();
              else
                return DistrictCubit()..emit(filter.quanHuyen);
            },
          ),
          BlocProvider(
            create: (context) {
              if (filter.quanHuyen == null)
                return CommuneCubit();
              else
                return CommuneCubit()..emit(filter.phuongXa);
            },
          )
        ],
        child: Column(
          children: [
            SizedBox(
              height: defaultPadding,
            ),
            Builder(
              builder: (context) => BlocBuilder<DistrictCubit, String>(
                builder: (context, district) {
                  return DropdownButton(
                    value: district,
                    onChanged: (value) {
                      BlocProvider.of<DistrictCubit>(context)
                          .selectedChange(value);
                      quanHuyen = value;
                      BlocProvider.of<CommuneCubit>(context)
                          .selectedChange(null);
                      phuongXa = null;
                    },
                    items: districts
                        .map((e) => DropdownMenuItem(
                            value: e.name, child: Text(e.name)))
                        .toList(),
                    hint: Text('Chọn quận/huyện'),
                    isExpanded: true,
                  );
                },
              ),
            ),
            Builder(
              builder: (context) => BlocBuilder<CommuneCubit, String>(
                builder: (context, state) {
                  return DropdownButton(
                    value: state,
                    onChanged: (value) {
                      phuongXa = value;
                      BlocProvider.of<CommuneCubit>(context)
                          .selectedChange(value);
                    },
                    items: quanHuyen != null
                        ? districts
                            .where((e) => e.name == quanHuyen)
                            .first
                            .commune
                            .map((e) =>
                                DropdownMenuItem(value: e, child: Text(e)))
                            .toList()
                        : [],
                    hint: Text('Chọn xã/phường'),
                    isExpanded: true,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
