import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rent_finder_hi/constants.dart';
import 'package:rent_finder_hi/data/models/models.dart' as model;
import 'package:rent_finder_hi/logic/bloc.dart';
import 'package:rent_finder_hi/presentation/widgets/widgets.dart';
import 'package:rent_finder_hi/utils/format.dart';

class FilterEnhanceScreen extends StatelessWidget {
  FilterEnhanceScreen({Key key, this.filter}) : super(key: key);
  model.Filter filter;
  double _lowerPrice = 0;
  double _upperPrice = 30000000;
  double _lowerArea = 0;
  double _upperArea = 100;
  model.CoSoVatChat coSoVatChat = model.CoSoVatChat(
      baiDauXe: false,
      mayGiat: false,
      banCong: false,
      baoVe: false,
      cctv: false,
      hoBoi: false,
      dieuHoa: false,
      gacLung: false,
      sanThuong: false,
      noiThat: false,
      nuoiThuCung: false);
  @override
  Widget build(BuildContext context) {
    if (filter.coSoVatChat != null) coSoVatChat = filter.coSoVatChat;
    return Scaffold(
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(
            horizontal: defaultPadding * 2, vertical: defaultPadding),
        child: CustomButton(
          title: 'Áp dụng',
          press: () {
            filter = filter.copyWith(coSoVatChat: coSoVatChat);
            Navigator.of(context).pop(filter);
          },
        ),
      ),
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Đặt lại')),
        ],
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: Text(
          'Lọc nâng cao',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: defaultPadding,
            ),
            Text(
              'Tổng quan',
              style: Theme.of(context).textTheme.headline5,
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
              create: (context) => SliderCubit()
                ..setValues(RangeValues(
                  filter.tienThueMin ?? _lowerPrice,
                  filter.tienThueMax ?? _upperPrice,
                )),
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
                        filter = filter.copyWith(
                            tienThueMin: val.start, tienThueMax: val.end);
                      },
                    );
                  },
                ),
              ),
            ),
            Text(
              'Diện tích',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(
              height: defaultPadding / 2,
            ),
            BlocProvider(
              create: (context) => SliderCubit()
                ..setValues(RangeValues(
                  filter.areaMin ?? _lowerArea,
                  filter.areaMax ?? _upperArea,
                )),
              child: Builder(
                builder: (context) => BlocBuilder<SliderCubit, RangeValues>(
                  builder: (context, state) {
                    return RangeSlider(
                      labels: RangeLabels(
                          Format.toCurrenncy(state.start),
                          Format.toCurrenncy(state.end) +
                              ((state.end == _upperArea) ? "+" : "")),
                      divisions: 10,
                      activeColor: primaryColor,
                      min: _lowerArea,
                      max: _upperArea,
                      values: state,
                      onChanged: (val) {
                        BlocProvider.of<SliderCubit>(context).setValues(val);
                        filter = filter.copyWith(
                            areaMin: val.start, areaMax: val.end);
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

            Row(
            children: [
              BlocProvider(
                create: (context) =>
                    filter.onlyEmpty ? (EnableCubit()..click()) : EnableCubit(),
                child: Builder(
                  builder: (context) => BlocBuilder<EnableCubit, bool>(
                    builder: (context, state) {
                      return Checkbox(
                        value: state,
                        onChanged: (val) {
                          filter = filter.copyWith(onlyEmpty: !state);
                          BlocProvider.of<EnableCubit>(context).click();
                        },
                      );
                    },
                  ),
                ),
              ),
              Text('Chỉ hiển thị nhà còn trống'),
            ],
          ),
            Text(
              'Cơ sở vật chất',
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(
              height: defaultPadding,
            ),

            _buildUtilitiesList(),
            // Spacer(),
          ],
        ),
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

  GridView _buildUtilitiesList() {
    return GridView.count(
      crossAxisSpacing: defaultPadding,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      mainAxisSpacing: defaultPadding,
      childAspectRatio: 1,
      shrinkWrap: true,
      children: [
        BlocProvider(
          create: (context) =>
              (coSoVatChat.dieuHoa) ? (EnableCubit()..click()) : EnableCubit(),
          child: _buildUtilityCard(
            svgSrc: 'assets/icons/air_conditioner.svg',
            title: 'Điều hòa',
          ),
        ),
        BlocProvider(
          create: (context) =>
              (coSoVatChat.banCong) ? (EnableCubit()..click()) : EnableCubit(),
          child: _buildUtilityCard(
            svgSrc: 'assets/icons/balcony.svg',
            title: 'Ban công',
          ),
        ),
        BlocProvider(
          create: (context) =>
              (coSoVatChat.noiThat) ? (EnableCubit()..click()) : EnableCubit(),
          child: _buildUtilityCard(
            svgSrc: 'assets/icons/interior.svg',
            title: 'Nội thất',
          ),
        ),
        BlocProvider(
          create: (context) =>
              (coSoVatChat.mayGiat) ? (EnableCubit()..click()) : EnableCubit(),
          child: _buildUtilityCard(
            svgSrc: 'assets/icons/washer.svg',
            title: 'Máy giặt',
          ),
        ),
        BlocProvider(
          create: (context) =>
              (coSoVatChat.gacLung) ? (EnableCubit()..click()) : EnableCubit(),
          child: _buildUtilityCard(
            svgSrc: 'assets/icons/mezzanine.svg',
            title: 'Gác lửng',
          ),
        ),
        BlocProvider(
          create: (context) =>
              (coSoVatChat.baoVe) ? (EnableCubit()..click()) : EnableCubit(),
          child: _buildUtilityCard(
            svgSrc: 'assets/icons/guard.svg',
            title: 'Bảo vệ',
          ),
        ),
        BlocProvider(
          create: (context) =>
              (coSoVatChat.baiDauXe) ? (EnableCubit()..click()) : EnableCubit(),
          child: _buildUtilityCard(
            svgSrc: 'assets/icons/parking.svg',
            title: 'Bãi đậu xe',
          ),
        ),
        BlocProvider(
          create: (context) =>
              (coSoVatChat.hoBoi) ? (EnableCubit()..click()) : EnableCubit(),
          child: _buildUtilityCard(
            svgSrc: 'assets/icons/pool.svg',
            title: 'Hồ bơi',
          ),
        ),
        BlocProvider(
          create: (context) => (coSoVatChat.sanThuong)
              ? (EnableCubit()..click())
              : EnableCubit(),
          child: _buildUtilityCard(
            svgSrc: 'assets/icons/roof.svg',
            title: 'Sân thượng',
          ),
        ),
        BlocProvider(
          create: (context) =>
              (coSoVatChat.cctv) ? (EnableCubit()..click()) : EnableCubit(),
          child: _buildUtilityCard(
            svgSrc: 'assets/icons/cctv.svg',
            title: 'CCTV',
          ),
        ),
        BlocProvider(
          create: (context) => (coSoVatChat.nuoiThuCung)
              ? (EnableCubit()..click())
              : EnableCubit(),
          child: _buildUtilityCard(
            svgSrc: 'assets/icons/pet.svg',
            title: 'Thú cưng',
          ),
        ),
      ],
    );
  }

  BlocBuilder<EnableCubit, bool> _buildUtilityCard(
      {String svgSrc, String title}) {
    return BlocBuilder<EnableCubit, bool>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            switch (title) {
              case 'Điều hòa':
                coSoVatChat.dieuHoa = !state;
                break;
              case 'Ban công':
                coSoVatChat.banCong = !state;
                break;
              case 'Nội thất':
                coSoVatChat.noiThat = !state;
                break;
              case 'Gác lửng':
                coSoVatChat.gacLung = !state;
                break;
              case 'Bảo vệ':
                coSoVatChat.baoVe = !state;
                break;
              case 'Hồ bơi':
                coSoVatChat.hoBoi = !state;
                break;
              case 'Sân thượng':
                coSoVatChat.sanThuong = !state;
                break;
              case 'CCTV':
                coSoVatChat.cctv = !state;
                break;
              case 'Thú cưng':
                coSoVatChat.nuoiThuCung = !state;
                break;
              case 'Máy giặt':
                coSoVatChat.mayGiat = !state;
                break;

              case 'Bãi đậu xe':
                coSoVatChat.baiDauXe = !state;
                break;
            }
            BlocProvider.of<EnableCubit>(context).click();
          },
          child: Container(
            padding: EdgeInsets.all(defaultPadding / 2),
            decoration: BoxDecoration(
                color: state ? Colors.white : Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: state ? Color(0xFF0D4880) : Colors.grey[200])),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: SvgPicture.asset(
                    svgSrc,
                    color: state ? Color(0xFF0D4880) : Colors.black,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                      color: state ? Color(0xFF0D4880) : Colors.black),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
