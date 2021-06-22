import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_finder_hi/logic/bloc.dart';
import 'package:rent_finder_hi/logic/place/commune/commune_cubit.dart';
import 'package:rent_finder_hi/logic/place/district/district_cubit.dart';
import 'package:rent_finder_hi/presentation/screens/screens.dart';
import 'package:rent_finder_hi/presentation/widgets/widgets.dart';

import '../../constants.dart';

class LocationBottomSheet extends StatelessWidget {
  LocationBottomSheet({
    Key key,
    this.quanHuyen,
    this.phuongXa,
  }) : super(key: key);
  String quanHuyen, phuongXa;
  @override
  Widget build(BuildContext context) {
    return Container(
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
                Navigator.pop(context, [quanHuyen, phuongXa]);
              },
            ),
          )
        ],
      ),
    );
  }

  Container _buildLocation() {
    return Container(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) {
              if (quanHuyen == null)
                return DistrictCubit();
              else
                return DistrictCubit()..emit(quanHuyen);
            },
          ),
          BlocProvider(
            create: (context) {
              if (phuongXa == null)
                return CommuneCubit();
              else
                return CommuneCubit()..emit(phuongXa);
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
