import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as ggMap;
import 'package:rent_finder_hi/constants.dart';
import 'package:rent_finder_hi/logic/bloc.dart';
import 'package:rent_finder_hi/logic/radio/radio_cubit.dart';
import 'package:rent_finder_hi/data/models/models.dart' as model;

import 'package:rent_finder_hi/presentation/widgets/widgets.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PostHouseScreen extends StatefulWidget {
  PostHouseScreen({Key key, this.user}) : super(key: key);
  final model.User user;
  @override
  _PostHouseScreenState createState() => _PostHouseScreenState(user: user);
}

class _PostHouseScreenState extends State<PostHouseScreen> {
  FocusNode focus = FocusNode();
  ggMap.LatLng toaDo;
  int bed = 1, bath = 1;
  List<File> files = [];
  String phuongXa, quanHuyen;
  List<AssetEntity> images = <AssetEntity>[];
  TextEditingController _streetController = TextEditingController();
  TextEditingController _numController = TextEditingController();
  TextEditingController _moneyController = TextEditingController();
  TextEditingController _areaController = TextEditingController();
  TextEditingController _describeController = TextEditingController();
  final model.User user;
  model.CoSoVatChat coSoVatChat = model.CoSoVatChat();
  List<String> urlHinhAnh;
  model.LoaiChoThue loaiChoThue;
  model.TinhTrangChoThue thue;

  _PostHouseScreenState({this.user});
  @override
  void initState() {
    coSoVatChat.banCong = false;
    coSoVatChat.baoVe = false;
    coSoVatChat.cctv = false;
    coSoVatChat.baiDauXe = false;
    coSoVatChat.dieuHoa = false;
    coSoVatChat.gacLung = false;
    coSoVatChat.hoBoi = false;
    coSoVatChat.mayGiat = false;
    coSoVatChat.noiThat = false;
    coSoVatChat.nuoiThuCung = false;
    coSoVatChat.sanThuong = false;
    loaiChoThue = model.LoaiChoThue.Nha;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool confirm = await showDialog<bool>(
            context: context,
            builder: (context) {
              return ConfirmDialog(
                title: 'Bạn có muốn hủy đăng tin không?',
              );
            });
        if (confirm) Navigator.of(context).pop();
        return null;
      },
      child: BlocProvider(
        create: (context) => StepperCubit(),
        child: Builder(
          builder: (context) => BlocListener<PostFormBloc, PostFormState>(
            listener: (context, state) {
              if (state.isFailure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Đăng tin thất bại'),
                        Icon(Icons.error),
                      ],
                    ),
                  ));
              } else if (state.isSuccess) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Tin của bạn đã được đăng thành công'),
                        Icon(Icons.verified),
                      ],
                    ),
                  ));
                Navigator.of(context).pop();
              } else if (state.isSubmitting) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                    duration: Duration(seconds: 10),
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Đang đăng tải...'),
                        CircularProgressIndicator(),
                      ],
                    ),
                  ));
              }
            },
            child: SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  leading: BlocBuilder<StepperCubit, int>(
                    builder: (context, state) {
                      return GestureDetector(
                        onTap: () async {
                          if (state > 0)
                            BlocProvider.of<StepperCubit>(context).cancel();
                          else {
                            var t = showDialog<bool>(
                              context: context,
                              builder: (context) {
                                return ConfirmDialog(
                                  title: 'Bạn có muốn hủy đăng tin không?',
                                );
                              },
                            );
                            t.then((value) {
                              if (value != null) {
                                if (value) Navigator.of(context).pop();
                              }
                            });
                          }
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                      );
                    },
                  ),
                  centerTitle: true,
                  title: Text(
                    'Đăng tin',
                    style: TextStyle(color: Colors.black),
                  ),
                  backgroundColor: Colors.white,
                ),
                backgroundColor: Colors.white,
                body: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(defaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 30),
                        CustomStepper(),
                        // Text('Vị trí'),
                        SizedBox(
                          height: defaultPadding,
                        ),
                        BlocBuilder<StepperCubit, int>(
                          builder: (context, state) {
                            return IndexedStack(
                              index: state,
                              children: [
                                _buildLocation(),
                                Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Loại cho thuê'),
                                      _buildCategorySelector(),
                                      Text('Số phòng ngủ'),
                                      _buildBedNumSelector(),
                                      Text('Số phòng tắm'),
                                      _buildBathNumSelector(),
                                      BlocBuilder<PostFormBloc, PostFormState>(
                                        builder: (context, state) {
                                          return TextFormField(
                                            keyboardType: TextInputType.number,
                                            controller: _moneyController,
                                            onChanged: (value) {
                                              BlocProvider.of<PostFormBloc>(
                                                      context)
                                                  .add(MoneyChanged(
                                                      money: value));
                                            },
                                            decoration: InputDecoration(
                                                errorText: state.isMoneyValid
                                                    ? null
                                                    : 'Số tiền không hợp lệ',
                                                labelText:
                                                    'Số tiền thuê tháng(VNĐ)',
                                                hintText: '100000'),
                                          );
                                        },
                                      ),
                                      SizedBox(
                                        height: defaultPadding,
                                      ),
                                      BlocBuilder<PostFormBloc, PostFormState>(
                                        builder: (context, state) {
                                          return TextFormField(
                                            controller: _areaController,
                                            onChanged: (value) {
                                              BlocProvider.of<PostFormBloc>(
                                                      context)
                                                  .add(
                                                      AreaChanged(area: value));
                                            },
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                                labelText: 'Diện tích (m2)',
                                                errorText: state.isAreaValid
                                                    ? null
                                                    : 'Diện tích không hợp lệ',
                                                hintText: '100'),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextButton.icon(
                                          onPressed: () async {
                                            try {
                                              final List<AssetEntity> results =
                                                  await AssetPicker.pickAssets(
                                                      context,
                                                      maxAssets: 8,
                                                      selectedAssets: images);
                                              if (results == null) return;
                                              images = results;
                                              files = [];
                                              for (int i = 0;
                                                  i < images.length;
                                                  i++) {
                                                File file =
                                                    await images[i].file;
                                                files.add(file);
                                              }

                                              BlocProvider.of<
                                                          PickMultiImageCubit>(
                                                      context)
                                                  .pickImages(images);
                                            } catch (err) {
                                              Fluttertoast.showToast(
                                                  msg: 'Đã có lỗi xảy ra');
                                            }
                                          },
                                          icon: Icon(Icons.photo_album_rounded),
                                          label: Text(
                                              'Chọn ảnh (tối đa 8, tối thiểu 2)')),
                                      BlocBuilder<PickMultiImageCubit,
                                          List<File>>(
                                        builder: (context, state) {
                                          print(state.length);
                                          return GridView.count(
                                            crossAxisSpacing: defaultPadding,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            crossAxisCount: 4,
                                            mainAxisSpacing: defaultPadding,
                                            shrinkWrap: true,
                                            children: List.generate(
                                              state.length,
                                              (index) => Stack(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: FileImage(
                                                          state[index],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: Container(
                                                      width: 30,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.black26,
                                                      ),
                                                      child: IconButton(
                                                        color: Colors.white,
                                                        padding:
                                                            EdgeInsets.all(0),
                                                        iconSize: 20,
                                                        onPressed: () {
                                                          images.remove(
                                                              images[index]);
                                                          BlocProvider.of<
                                                                      PickMultiImageCubit>(
                                                                  context)
                                                              .pickImages(
                                                                  images);
                                                        },
                                                        icon: Icon(Icons.close),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Text('Cơ sở vật chất'),
                                      SizedBox(
                                        height: defaultPadding,
                                      ),
                                      _buildUtilitiesList()
                                    ],
                                  ),
                                ),
                                Container(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Họ và tên'),
                                    SizedBox(
                                      height: defaultPadding / 2,
                                    ),
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(defaultPadding),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border:
                                            Border.all(color: Colors.black54),
                                      ),
                                      child: Text(user.hoTen ?? ""),
                                    ),
                                    SizedBox(
                                      height: defaultPadding,
                                    ),
                                    Text('Số điện thoại'),
                                    SizedBox(
                                      height: defaultPadding / 2,
                                    ),
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(defaultPadding),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border:
                                            Border.all(color: Colors.black54),
                                      ),
                                      child: Text(user.sdt ?? ""),
                                    ),
                                    SizedBox(
                                      height: defaultPadding,
                                    ),
                                    Text('Mô tả'),
                                    SizedBox(
                                      height: defaultPadding / 2,
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: defaultPadding,
                                          vertical: defaultPadding / 2),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border:
                                            Border.all(color: Colors.black54),
                                      ),
                                      child: TextFormField(
                                        maxLines: 10,
                                        keyboardType: TextInputType.multiline,
                                        controller: _describeController,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                              ],
                            );
                          },
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        BlocBuilder<PostFormBloc, PostFormState>(
                          builder: (context, stateForm) {
                            return BlocBuilder<StepperCubit, int>(
                              builder: (context, state) {
                                return CustomButton(
                                  title: state <= 2 ? 'Tiếp theo' : "Đăng tin",
                                  press: () async {
                                    if (state == 0 &&
                                        (_streetController.text == "" ||
                                            _numController.text == "" ||
                                            quanHuyen == null ||
                                            phuongXa == null)) {
                                      if (quanHuyen == null) {
                                        Fluttertoast.cancel();
                                        Fluttertoast.showToast(
                                            msg: 'Vui lòng chọn quận huyện');
                                      } else {
                                        if (phuongXa == null)
                                          Fluttertoast.cancel();
                                        Fluttertoast.showToast(
                                            msg: 'Vui lòng chọn xã phường');
                                      }
                                      if (_numController.text == "") {
                                        BlocProvider.of<PostFormBloc>(context)
                                            .add(NumChanged(num: ""));
                                      }
                                      if (_streetController.text == "") {
                                        BlocProvider.of<PostFormBloc>(context)
                                            .add(StreetChanged(street: ""));
                                      }
                                      return;
                                    } else {
                                      var query =
                                          '${_numController.text} ${_streetController.text}, ${phuongXa}, ${quanHuyen} Thành phố Hồ Chí Minh';
                                      try {
                                        var address = await Geocoder.local
                                            .findAddressesFromQuery(query);
                                        // print(address.first.addressLine
                                        //     .split(',')
                                        //     .length);
                                        // print(address.first.addressLine);
                                        // print(address.first.adminArea);
                                        // print(address.first.subAdminArea);
                                        // print(address.first.thoroughfare);
                                        // print(address.first.subThoroughfare);
                                        // print(address.first.locality);
                                        // print(address.first.subLocality);
                                        var splitAddress = address
                                            .first.addressLine
                                            .split(',');
                                        if (splitAddress.length < 4 ||
                                            !quanHuyen.contains(
                                                address.first.subAdminArea)) {
                                          Fluttertoast.showToast(
                                              msg:
                                                  'Địa chỉ không hợp lệ. Nếu có lỗi hãy báo cáo với chúng tôi tại phần Người dùng');
                                          return;
                                        }
                                        toaDo = ggMap.LatLng(
                                            address.first.coordinates.latitude,
                                            address
                                                .first.coordinates.longitude);
                                      } catch (e) {
                                        print(e.toString());
                                        print('Địa chỉ không hợp lệ');
                                        Fluttertoast.showToast(
                                            msg:
                                                'Địa chỉ không hợp lệ. Nếu có lỗi hãy báo cáo với chúng tôi tại phần Người dùng');
                                        return;
                                      }
                                    }

                                    if (state == 1 &&
                                        (_moneyController.text == "" ||
                                            _areaController.text == "" ||
                                            !stateForm.isForm2Valid)) {
                                      if (_moneyController.text == "") {
                                        BlocProvider.of<PostFormBloc>(context)
                                            .add(MoneyChanged(money: ""));
                                        if (_areaController.text == "") {
                                          BlocProvider.of<PostFormBloc>(context)
                                              .add(AreaChanged(area: ""));
                                        }
                                      }
                                      return;
                                    }
                                    if (state == 2 && images.length < 2) {
                                      Fluttertoast.cancel();
                                      Fluttertoast.showToast(
                                          msg: 'Bạn cần chọn tối thiểu 2 ảnh');
                                      return;
                                    }
                                    if (state <= 2)
                                      BlocProvider.of<StepperCubit>(context)
                                          .next();
                                    else {
                                      if (_describeController.text == "" ||
                                          _describeController.text == null) {
                                        Fluttertoast.cancel();
                                        Fluttertoast.showToast(
                                            msg:
                                                'Vui lòng nhập mô tả nhà của bạn');
                                        return;
                                      }
                                      var t = showDialog(
                                        context: context,
                                        builder: (context) {
                                          return ConfirmDialog(
                                            title:
                                                'Bạn có chắc chắn đăng tin này không?',
                                          );
                                        },
                                      );
                                      t.then(
                                        (value) {
                                          print(value);
                                          if (value != null) {
                                            print(value);
                                            if (value) {
                                              model.House house = model.House();
                                              house.toaDo = toaDo;
                                              house.setSensitiveInfo(
                                                  false, user);
                                              house.soNha = _numController.text;
                                              house.tenDuong =
                                                  _streetController.text;
                                              house.phuongXa = phuongXa;
                                              house.quanHuyen = quanHuyen;
                                              house.dienTich = double.tryParse(
                                                  _areaController.text);
                                              house.urlHinhAnh = urlHinhAnh;
                                              house.loaiChoThue = loaiChoThue;
                                              house.soPhongNgu = bed;
                                              house.soPhongTam = bath;
                                              house.tienThueThang =
                                                  double.tryParse(
                                                      _moneyController.text);
                                              house.tinhTrang = model
                                                  .TinhTrangChoThue.ConTrong;
                                              house.ngayCapNhat =
                                                  DateTime.now();
                                              house.coSoVatChat = coSoVatChat;
                                              house.moTa =
                                                  _describeController.text;
                                              BlocProvider.of<PostFormBloc>(
                                                      context)
                                                  .add(PostFormSubmitted(
                                                      house: house,
                                                      files: files));
                                            }
                                          }
                                        },
                                      );
                                    }
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
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
          create: (context) => EnableCubit(),
          child: _buildUtilityCard(
            svgSrc: 'assets/icons/air_conditioner.svg',
            title: 'Điều hòa',
          ),
        ),
        BlocProvider(
          create: (context) => EnableCubit(),
          child: _buildUtilityCard(
            svgSrc: 'assets/icons/balcony.svg',
            title: 'Ban công',
          ),
        ),
        BlocProvider(
          create: (context) => EnableCubit(),
          child: _buildUtilityCard(
            svgSrc: 'assets/icons/washer.svg',
            title: 'Máy giặt',
          ),
        ),
        BlocProvider(
          create: (context) => EnableCubit(),
          child: _buildUtilityCard(
            svgSrc: 'assets/icons/interior.svg',
            title: 'Nội thất',
          ),
        ),
        BlocProvider(
          create: (context) => EnableCubit(),
          child: _buildUtilityCard(
            svgSrc: 'assets/icons/mezzanine.svg',
            title: 'Gác lửng',
          ),
        ),
        BlocProvider(
          create: (context) => EnableCubit(),
          child: _buildUtilityCard(
            svgSrc: 'assets/icons/guard.svg',
            title: 'Bảo vệ',
          ),
        ),
        BlocProvider(
          create: (context) => EnableCubit(),
          child: _buildUtilityCard(
            svgSrc: 'assets/icons/pool.svg',
            title: 'Hồ bơi',
          ),
        ),
        BlocProvider(
          create: (context) => EnableCubit(),
          child: _buildUtilityCard(
            svgSrc: 'assets/icons/parking.svg',
            title: 'Bãi đậu xe',
          ),
        ),
        BlocProvider(
          create: (context) => EnableCubit(),
          child: _buildUtilityCard(
            svgSrc: 'assets/icons/roof.svg',
            title: 'Sân thượng',
          ),
        ),
        BlocProvider(
          create: (context) => EnableCubit(),
          child: _buildUtilityCard(
            svgSrc: 'assets/icons/cctv.svg',
            title: 'CCTV',
          ),
        ),
        BlocProvider(
          create: (context) => EnableCubit(),
          child: _buildUtilityCard(
            svgSrc: 'assets/icons/pet.svg',
            title: 'Thú cưng',
          ),
        ),
      ],
    );
  }

  Container _buildLocation() {
    return Container(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => DistrictCubit(),
          ),
          BlocProvider(
            create: (context) => CommuneCubit(),
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
                  return BlocBuilder<DistrictCubit, String>(
                    builder: (context, district) {
                      return DropdownButton(
                        value: state,
                        onChanged: (value) {
                          phuongXa = value;
                          BlocProvider.of<CommuneCubit>(context)
                              .selectedChange(value);
                        },
                        items: district != null
                            ? districts
                                .where((e) => e.name == district)
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
                  );
                },
              ),
            ),
            BlocBuilder<PostFormBloc, PostFormState>(
              builder: (context, state) {
                return TextFormField(
                  controller: _streetController,
                  onChanged: (value) {
                    BlocProvider.of<PostFormBloc>(context)
                        .add(StreetChanged(street: value));
                  },
                  decoration: InputDecoration(
                      labelText: 'Tên đường',
                      errorText:
                          state.isStreetValid ? '' : "Không được để trống",
                      hintText: 'Nguyễn Bỉnh Khiêm'),
                );
              },
            ),
            BlocBuilder<PostFormBloc, PostFormState>(
              builder: (context, state) {
                return TextFormField(
                  controller: _numController,
                  onChanged: (value) {
                    BlocProvider.of<PostFormBloc>(context)
                        .add(NumChanged(num: value));
                  },
                  decoration: InputDecoration(
                      labelText: 'Số nhà',
                      errorText: state.isNumValid ? '' : "Không được để trống",
                      hintText: '5'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  BlocProvider<RadioCubit> _buildBedNumSelector() {
    return BlocProvider(
      create: (context) => RadioCubit(),
      child: Builder(
        builder: (context) => BlocBuilder<RadioCubit, int>(
          builder: (context, state) {
            return Row(
              children: [
                MaterialButton(
                  color: (state == 0) ? Color(0xFF0D4880) : Colors.white,
                  onPressed: () {
                    bed = 1;
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
                    bed = 2;
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
                    bed = 3;
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
                    bed = 4;
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

  BlocProvider<RadioCubit> _buildBathNumSelector() {
    return BlocProvider(
      create: (context) => RadioCubit(),
      child: Builder(
        builder: (context) => BlocBuilder<RadioCubit, int>(
          builder: (context, state) {
            return Row(
              children: [
                MaterialButton(
                  color: (state == 0) ? Color(0xFF0D4880) : Colors.white,
                  onPressed: () {
                    bath = 1;
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
                    bath = 2;
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
                    bath = 3;
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
                    bath = 4;
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

  BlocProvider<RadioCubit> _buildCategorySelector() {
    return BlocProvider(
      create: (context) => RadioCubit(),
      child: Builder(
        builder: (context) => BlocBuilder<RadioCubit, int>(
          builder: (context, state) {
            return Row(
              children: [
                MaterialButton(
                  color: (state == 0) ? Color(0xFF0D4880) : Colors.white,
                  onPressed: () {
                    loaiChoThue = model.LoaiChoThue.Nha;
                    BlocProvider.of<RadioCubit>(context).click(0);
                  },
                  child: Text(
                    'Nhà',
                    style: TextStyle(
                        color: !(state == 0) ? Colors.black : Colors.white),
                  ),
                ),
                MaterialButton(
                  color: (state == 1) ? Color(0xFF0D4880) : Colors.white,
                  onPressed: () {
                    loaiChoThue = model.LoaiChoThue.CanHo;
                    BlocProvider.of<RadioCubit>(context).click(1);
                  },
                  child: Text(
                    'Căn hộ',
                    style: TextStyle(
                        color: !(state == 1) ? Colors.black : Colors.white),
                  ),
                ),
                MaterialButton(
                  color: (state == 2) ? Color(0xFF0D4880) : Colors.white,
                  onPressed: () {
                    loaiChoThue = model.LoaiChoThue.Phong;
                    BlocProvider.of<RadioCubit>(context).click(2);
                  },
                  child: Text(
                    'Phòng',
                    style: TextStyle(
                        color: !(state == 2) ? Colors.black : Colors.white),
                  ),
                ),
              ],
            );
          },
        ),
      ),
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

class CustomStepper extends StatelessWidget {
  const CustomStepper({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StepperCubit, int>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(defaultPadding / 3),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Color(0xFF0D4880)),
              child: Icon(
                (state > 0) ? Icons.verified_user : Icons.circle,
                color: Colors.white,
                size: 16,
              ),
            ),
            Container(
              height: 3,
              width: 50,
              color: state > 0 ? Color(0xFF0D4880) : Colors.grey,
            ),
            Container(
              padding: EdgeInsets.all(defaultPadding / 3),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (state < 1) ? Colors.grey : Color(0xFF0D4880)),
              child: Icon(
                state > 1 ? Icons.verified_user : Icons.circle,
                color: Colors.white,
                size: 16,
              ),
            ),
            Container(
              height: 3,
              width: 50,
              color: state > 1 ? Color(0xFF0D4880) : Colors.grey,
            ),
            Container(
              padding: EdgeInsets.all(defaultPadding / 3),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (state < 2) ? Colors.grey : Color(0xFF0D4880)),
              child: Icon(
                state > 2 ? Icons.verified_user : Icons.circle,
                size: 16,
                color: Colors.white,
              ),
            ),
            Container(
              height: 3,
              width: 50,
              color: state > 2 ? Color(0xFF0D4880) : Colors.grey,
            ),
            Container(
              padding: EdgeInsets.all(defaultPadding / 3),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (state < 3) ? Colors.grey : Color(0xFF0D4880)),
              child: Icon(
                state > 3 ? Icons.verified_user : Icons.circle,
                size: 16,
                color: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }
}
