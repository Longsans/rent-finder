import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_finder_hi/data/models/filter.dart';
import 'package:rent_finder_hi/logic/bloc.dart';
import 'package:rent_finder_hi/presentation/widgets/custom_button.dart';
import 'package:rent_finder_hi/utils/format.dart';

import '../../constants.dart';

class FilterBasicBottomSheet extends StatelessWidget {
  FilterBasicBottomSheet({
    Key key,
    this.filter,
  }) : super(key: key);
  Filter filter;
  static double _lowerPrice = 0;
  static double _upperPrice = 30000000;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding * 0.75),
      height: 450,
      width: 800,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
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
                'Lọc kết quả',
                style: Theme.of(context).textTheme.headline6,
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/filter_enhance');
                },
                child: Text('Nâng cao'),
              ),
            ],
          ),
          SizedBox(
            height: defaultPadding,
          ),
          Text(
            'Giá',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(
            height: defaultPadding / 2,
          ),
          BlocProvider(
            create: (context) =>
                SliderCubit()..setValues(RangeValues( filter.tienThueMin ?? _lowerPrice,filter.tienThueMax ?? _upperPrice,)),
            child: Builder(
              builder: (context) => BlocBuilder<SliderCubit, RangeValues>(
                builder: (context, state) {
                  return RangeSlider(
                    labels: RangeLabels(
                        Format.toCurrenncy(state.start),
                        Format.toCurrenncy(state.end) +
                            ((state.end == _upperPrice) ? "+" : "")),
                    divisions: 60,
                    activeColor: primaryColor,
                    min: _lowerPrice,
                    max: _upperPrice,
                    values: state,
                    onChanged: (val) {
                      BlocProvider.of<SliderCubit>(context).setValues(val);
                     filter = filter.copyWith(tienThueMin: val.start, tienThueMax: val.end);
                    },
                  );
                },
              ),
            ),
          ),
          SizedBox(
            height: defaultPadding,
          ),
          Text(
            'Phòng ngủ tối thiểu',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          _buildBedNumSelector(),
          SizedBox(
            height: defaultPadding,
          ),
          Text(
            'Phòng tắm tối thiểu',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          _buildBathNumSelector(),
          Spacer(),
          Align(
              alignment: Alignment.bottomCenter,
              child: CustomButton(
                title: 'Áp dụng',
                press: () {
                  if (filter.soPhongNgu == null)
                    filter = filter.copyWith(soPhongNgu: 1);
                  if (filter.soPhongTam == null)
                    filter = filter.copyWith(soPhongTam: 1);

                  Navigator.of(context).pop(filter);
                },
              ))
        ],
      ),
    );
  }

  BlocProvider<RadioCubit> _buildBathNumSelector() {
    return BlocProvider(
      create: (context) {
        if ((filter.soPhongTam != null)) {
          return RadioCubit()..click(filter.soPhongTam - 1);
        } else {
          return RadioCubit();
        }
      },
      child: Builder(
        builder: (context) => BlocBuilder<RadioCubit, int>(
          builder: (context, state) {
            return Row(
              children: [
                MaterialButton(
                  color: (state == 0) ? Color(0xFF0D4880) : Colors.white,
                  onPressed: () {
                    filter = filter.copyWith(soPhongTam: 1);
                    BlocProvider.of<RadioCubit>(context).click(0);
                  },
                  child: Text(
                    '1',
                    style: TextStyle(
                        color: !(state == 0) ? Colors.black : Colors.white),
                  ),
                ),
                MaterialButton(
                  color: (state == 1) ? Color(0xFF0D4880) : Colors.white,
                  onPressed: () {
                    filter = filter.copyWith(soPhongTam: 2);
                    BlocProvider.of<RadioCubit>(context).click(1);
                  },
                  child: Text(
                    '2',
                    style: TextStyle(
                        color: !(state == 1) ? Colors.black : Colors.white),
                  ),
                ),
                MaterialButton(
                  color: (state == 2) ? Color(0xFF0D4880) : Colors.white,
                  onPressed: () {
                    filter = filter.copyWith(soPhongTam: 3);
                    BlocProvider.of<RadioCubit>(context).click(2);
                  },
                  child: Text(
                    '3',
                    style: TextStyle(
                        color: !(state == 2) ? Colors.black : Colors.white),
                  ),
                ),
                MaterialButton(
                  color: (state == 3) ? Color(0xFF0D4880) : Colors.white,
                  onPressed: () {
                    filter = filter.copyWith(soPhongTam: 4);
                    BlocProvider.of<RadioCubit>(context).click(3);
                  },
                  child: Text(
                    '4+',
                    style: TextStyle(
                        color: !(state == 3) ? Colors.black : Colors.white),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  BlocProvider<RadioCubit> _buildBedNumSelector() {
    return BlocProvider(
      create: (context) {
        if ((filter.soPhongNgu != null)) {
          return RadioCubit()..click(filter.soPhongNgu - 1);
        } else {
          return RadioCubit();
        }
      },
      child: Builder(
        builder: (context) => BlocBuilder<RadioCubit, int>(
          builder: (context, state) {
            return Row(
              children: [
                MaterialButton(
                  color: (state == 0) ? Color(0xFF0D4880) : Colors.white,
                  onPressed: () {
                    filter = filter.copyWith(soPhongNgu: 1);
                    BlocProvider.of<RadioCubit>(context).click(0);
                  },
                  child: Text(
                    '1',
                    style: TextStyle(
                        color: !(state == 0) ? Colors.black : Colors.white),
                  ),
                ),
                MaterialButton(
                  color: (state == 1) ? Color(0xFF0D4880) : Colors.white,
                  onPressed: () {
                    filter = filter.copyWith(soPhongNgu: 2);
                    BlocProvider.of<RadioCubit>(context).click(1);
                  },
                  child: Text(
                    '2',
                    style: TextStyle(
                        color: !(state == 1) ? Colors.black : Colors.white),
                  ),
                ),
                MaterialButton(
                  color: (state == 2) ? Color(0xFF0D4880) : Colors.white,
                  onPressed: () {
                    filter = filter.copyWith(soPhongNgu: 3);
                    BlocProvider.of<RadioCubit>(context).click(2);
                  },
                  child: Text(
                    '3',
                    style: TextStyle(
                        color: !(state == 2) ? Colors.black : Colors.white),
                  ),
                ),
                MaterialButton(
                  color: (state == 3) ? Color(0xFF0D4880) : Colors.white,
                  onPressed: () {
                    filter = filter.copyWith(soPhongNgu: 4);
                    BlocProvider.of<RadioCubit>(context).click(3);
                  },
                  child: Text(
                    '4+',
                    style: TextStyle(
                        color: !(state == 3) ? Colors.black : Colors.white),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
