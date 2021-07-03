import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as ggMap;
import 'package:rent_finder_hi/data/models/models.dart';
import 'package:rent_finder_hi/logic/bloc.dart';
import 'package:rent_finder_hi/presentation/widgets/widgets.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../constants.dart';

class EditHouseForm extends StatefulWidget {
  const EditHouseForm({Key key, this.house}) : super(key: key);
  final House house;

  @override
  _EditHouseFormState createState() => _EditHouseFormState();
}

class _EditHouseFormState extends State<EditHouseForm> {
  ggMap.LatLng toaDo;
  int bed = 1, bath = 1;
  List<File> files = [];
  String phuongXa, quanHuyen;
  List<AssetEntity> images = <AssetEntity>[];
  TextEditingController _streetController = TextEditingController();
  TextEditingController _bedController = TextEditingController();
  TextEditingController _bathController = TextEditingController();
  TextEditingController _numController = TextEditingController();
  TextEditingController _moneyController = TextEditingController();
  TextEditingController _areaController = TextEditingController();
  TextEditingController _describeController = TextEditingController();
  CoSoVatChat coSoVatChat = CoSoVatChat();
  House res;
  bool get isFilled =>
      _streetController.text.isNotEmpty &&
      _bedController.text.isNotEmpty &&
      _numController.text.isNotEmpty &&
      _moneyController.text.isNotEmpty &&
      _areaController.text.isNotEmpty &&
      _bathController.text.isNotEmpty &&
      _describeController.text.isNotEmpty &&
      quanHuyen.isNotEmpty &&
      phuongXa != null &&
      phuongXa.isNotEmpty &&
      quanHuyen != null;
  void initState() {
    res = widget.house;
    _streetController.text = widget.house.tenDuong;
    _bedController.text = widget.house.soPhongNgu.toString();
    _bathController.text = widget.house.soPhongTam.toString();
    _numController.text = widget.house.soNha;
    _moneyController.text = widget.house.tienThueThang.toStringAsFixed(0);
    _areaController.text = widget.house.dienTich.toStringAsFixed(0);
    _describeController.text = widget.house.moTa.toString();
    coSoVatChat.banCong = widget.house.coSoVatChat.banCong;
    coSoVatChat.baoVe = widget.house.coSoVatChat.baoVe;
    coSoVatChat.cctv = widget.house.coSoVatChat.cctv;
    coSoVatChat.baiDauXe = widget.house.coSoVatChat.baiDauXe;
    coSoVatChat.dieuHoa = widget.house.coSoVatChat.dieuHoa;
    coSoVatChat.gacLung = widget.house.coSoVatChat.gacLung;
    coSoVatChat.hoBoi = widget.house.coSoVatChat.hoBoi;
    coSoVatChat.mayGiat = widget.house.coSoVatChat.mayGiat;
    coSoVatChat.noiThat = widget.house.coSoVatChat.noiThat;
    coSoVatChat.nuoiThuCung = widget.house.coSoVatChat.nuoiThuCung;
    coSoVatChat.sanThuong = widget.house.coSoVatChat.sanThuong;
    phuongXa = res.phuongXa;
    quanHuyen = res.quanHuyen;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => EditFormCubit(),
        ),
        BlocProvider(
          create: (context) => PickMultiImageCubit(),
        ),
        BlocProvider(
          create: (context) => UrlImageCubit()..loadUrl(res.urlHinhAnh),
        ),
        BlocProvider(
          create: (context) =>
              DistrictCubit()..selectedChange(widget.house.quanHuyen),
        ),
        BlocProvider(
          create: (context) =>
              CommuneCubit()..selectedChange(widget.house.phuongXa),
        )
      ],
      child: Builder(
        builder: (context) => BlocListener<EditFormCubit, EditFormState>(
          listener: (context, state) {
            if (state.status == EditStatus.failure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Đã có lỗi xảy ra. Cập nhật thất bại!'),
                        Icon(Icons.error, color: Colors.red),
                      ],
                    ),
                  ),
                );
            } else if (state.status == EditStatus.success) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Nhà của bạn đã được cập nhật thành công'),
                        Icon(
                          Icons.verified,
                          color: Colors.green,
                        ),
                      ],
                    ),
                  ),
                );
              Navigator.of(context).pop();
            } else if (state.status == EditStatus.loading) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    duration: Duration(minutes: 10),
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Đang cập nhật...'),
                        CircularProgressIndicator(),
                      ],
                    ),
                  ),
                );
            }
          },
          child: SafeArea(
            child: Scaffold(
              bottomNavigationBar: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: defaultPadding * 2, vertical: defaultPadding),
                child: CustomButton(
                  title: 'Xác nhận',
                  press: () async {
                    if (!isFilled) {
                      Fluttertoast.showToast(
                          msg: 'Vui lòng nhập đầy đủ thông tin');
                    } else {
                      if (res.urlHinhAnh.length + files.length < 2) {
                        Fluttertoast.showToast(
                            msg: 'Bạn cần thêm tối thiểu 2 ảnh');
                        return;
                      }
                      try {
                        var location = await locationFromAddress(
                            '${_numController.text} ${_streetController.text}');
                      } catch (e) {
                        Fluttertoast.showToast(
                            msg:
                                'Địa chỉ không hợp lệ. Nếu có lỗi hãy báo cáo với chúng tôi tại phần Người dùng');
                        return;
                      }
                      var query =
                          '${_numController.text} ${_streetController.text}, $phuongXa, $quanHuyen Thành phố Hồ Chí Minh';
                      print(query);
                      try {
                        var address =
                            await Geocoder.local.findAddressesFromQuery(query);
                        var splitAddress = address.first.addressLine.split(',');
                        print(address.first.addressLine.split(',').length);
                        print(address.first.addressLine);
                        print(address.first.adminArea);
                        print(address.first.subAdminArea);
                        print(address.first.thoroughfare);
                        print(address.first.subThoroughfare);
                        print(address.first.locality);
                        print(address.first.subLocality);
                        if (splitAddress.length < 4 ||
                            !quanHuyen.contains(address.first.subAdminArea)) {
                          Fluttertoast.showToast(
                              msg:
                                  'Địa chỉ không hợp lệ. Nếu có lỗi hãy báo cáo với chúng tôi tại phần Người dùng');
                          return;
                        }
                        toaDo = ggMap.LatLng(address.first.coordinates.latitude,
                            address.first.coordinates.longitude);
                      } catch (e) {
                        print(e.toString());
                        print('Địa chỉ không hợp lệ');
                        Fluttertoast.showToast(
                            msg:
                                'Địa chỉ không hợp lệ. Nếu có lỗi hãy báo cáo với chúng tôi tại phần Người dùng');
                        return;
                      }
                      var t = showDialog(
                        context: context,
                        builder: (context) {
                          return ConfirmDialog(
                            title: 'Bạn có chắc chắn cập nhật nhà này không?',
                          );
                        },
                      );
                      t.then(
                        (value) {
                          if (value != null) {
                            if (value) {
                              res.toaDo = toaDo;
                              res.moTa = _describeController.text;
                              res.soNha = _numController.text;
                              res.tenDuong = _streetController.text;
                              res.soPhongNgu =
                                  int.tryParse(_bedController.text) ?? 0;
                              res.soPhongTam =
                                  int.tryParse(_bathController.text) ?? 0;
                              res.dienTich =
                                  double.tryParse(_areaController.text) ?? 0;
                              res.tienThueThang =
                                  double.tryParse(_moneyController.text) ?? 0;
                              res.coSoVatChat = coSoVatChat;
                              res.quanHuyen = quanHuyen;
                              res.phuongXa = phuongXa;
                              res.ngayCapNhat = DateTime.now();
                              print(files.length);
                              BlocProvider.of<EditFormCubit>(context)
                                  .submitForm(res, files);
                            }
                          }
                        },
                      );
                    }
                  },
                ),
              ),
              appBar: AppBar(
                leading: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                centerTitle: true,
                title: Text(
                  'Cập nhật nhà',
                  style: TextStyle(color: Colors.black),
                ),
                backgroundColor: Colors.white,
              ),
              body: Builder(
                builder: (context) =>
                    BlocListener<EditFormCubit, EditFormState>(
                  listener: (context, state) {},
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(defaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Địa chỉ',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: defaultPadding / 2,
                        ),
                        Builder(
                          builder: (context) =>
                              BlocBuilder<DistrictCubit, String>(
                            builder: (context, district) {
                              return Container(
                                padding:
                                    EdgeInsets.only(left: 20.0, right: 10.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.black54),
                                ),
                                child: DropdownButton(
                                  underline: Container(),
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
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: defaultPadding,
                        ),
                        Builder(
                          builder: (context) =>
                              BlocBuilder<CommuneCubit, String>(
                            builder: (context, state) {
                              return BlocBuilder<DistrictCubit, String>(
                                builder: (context, district) {
                                  return Container(
                                    padding: EdgeInsets.only(
                                        left: 20.0, right: 10.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.black54),
                                    ),
                                    child: DropdownButton(
                                      underline: Container(),
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
                                              .map((e) => DropdownMenuItem(
                                                  value: e, child: Text(e)))
                                              .toList()
                                          : [],
                                      hint: Text('Chọn xã/phường'),
                                      isExpanded: true,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: defaultPadding,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: _numController,
                                onChanged: (value) {
                                  // BlocProvider.of<PostFormBloc>(context)
                                  //     .add(NumChanged(num: value));
                                },
                                decoration: InputDecoration(
                                    labelText: 'Số nhà',
                                    errorBorder: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.red),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.black54),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: textColor),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    contentPadding: EdgeInsets.only(
                                        left: 20.0, right: 10.0),
                                    // errorText:
                                    //     state.isNumValid ? '' : "Không được để trống",
                                    hintText: '239/4'),
                              ),
                            ),
                            SizedBox(
                              width: defaultPadding,
                            ),
                            Expanded(
                              flex: 3,
                              child: TextFormField(
                                controller: _streetController,
                                onChanged: (value) {
                                  // BlocProvider.of<PostFormBloc>(context)
                                  //     .add(StreetChanged(street: value));
                                },
                                decoration: InputDecoration(
                                    errorBorder: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.red),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.black54),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: textColor),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    contentPadding: EdgeInsets.only(
                                        left: 20.0, right: 10.0),
                                    labelText: 'Tên đường',
                                    // errorText: state.isStreetValid
                                    //     ? ''
                                    //     : "Không được để trống",
                                    hintText: 'Nguyễn Bỉnh Khiêm'),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: defaultPadding,
                        ),
                        Text(
                          'Thông tin cơ bản',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: defaultPadding / 2,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                controller: _bedController,
                                onChanged: (value) {
                                  // BlocProvider.of<PostFormBloc>(context)
                                  //     .add(NumChanged(num: value));
                                },
                                decoration: InputDecoration(
                                    labelText: 'Số phòng ngủ',
                                    errorBorder: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.red),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.black54),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: textColor),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    contentPadding: EdgeInsets.only(
                                        left: 20.0, right: 10.0),
                                    // errorText:
                                    //     state.isNumValid ? '' : "Không được để trống",
                                    hintText: '2'),
                              ),
                            ),
                            SizedBox(
                              width: defaultPadding,
                            ),
                            Expanded(
                              child: TextFormField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                controller: _bathController,
                                onChanged: (value) {
                                  // BlocProvider.of<PostFormBloc>(context)
                                  //     .add(StreetChanged(street: value));
                                },
                                decoration: InputDecoration(
                                    errorBorder: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.red),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.black54),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: textColor),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    contentPadding: EdgeInsets.only(
                                        left: 20.0, right: 10.0),
                                    labelText: 'Số phòng tắm',
                                    // errorText: state.isStreetValid
                                    //     ? ''
                                    //     : "Không được để trống",
                                    hintText: '2'),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: defaultPadding,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                controller: _areaController,
                                onChanged: (value) {
                                  // BlocProvider.of<PostFormBloc>(context)
                                  //     .add(NumChanged(num: value));
                                },
                                decoration: InputDecoration(
                                    labelText: 'Diện tích(m2)',
                                    errorBorder: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.red),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.black54),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: textColor),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    contentPadding: EdgeInsets.only(
                                        left: 20.0, right: 10.0),
                                    // errorText:
                                    //     state.isNumValid ? '' : "Không được để trống",
                                    hintText: '100'),
                              ),
                            ),
                            SizedBox(
                              width: defaultPadding,
                            ),
                            Expanded(
                              flex: 3,
                              child: TextFormField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                keyboardType: TextInputType.number,
                                controller: _moneyController,
                                onChanged: (value) {
                                  // BlocProvider.of<PostFormBloc>(context)
                                  //     .add(NumChanged(num: value));
                                },
                                decoration: InputDecoration(
                                    labelText: 'Giá tiền tháng (VNĐ)',
                                    errorBorder: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.red),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.black54),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: textColor),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    contentPadding: EdgeInsets.only(
                                        left: 20.0, right: 10.0),
                                    // errorText:
                                    //     state.isNumValid ? '' : "Không được để trống",
                                    hintText: '1500000'),
                              ),
                            ),
                          ],
                        ),
                        //
                        SizedBox(
                          height: defaultPadding,
                        ),
                        Text(
                          'Loại hình',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: defaultPadding / 4,
                        ),
                        _buildCategorySelector(),
                        SizedBox(
                          height: defaultPadding,
                        ),
                        Text(
                          'Tình trạng',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: defaultPadding / 4,
                        ),
                        _buildStatusSelector(),
                        SizedBox(
                          height: defaultPadding,
                        ),
                        Text(
                          'Cơ sở vật chất',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: defaultPadding,
                        ),
                        _buildUtilitiesList(),
                        SizedBox(
                          height: defaultPadding,
                        ),
                        Builder(
                          builder: (context) =>
                              BlocBuilder<UrlImageCubit, List<String>>(
                            builder: (context, urlState) {
                              return TextButton.icon(
                                  onPressed: () async {
                                    try {
                                      final List<AssetEntity> results =
                                          await AssetPicker.pickAssets(context,
                                              textDelegate:
                                                  EnglishTextDelegate(),
                                              maxAssets: 8 - urlState.length,
                                              selectedAssets: images);
                                      if (results == null) return;
                                      images = results;
                                      files = [];
                                      for (int i = 0; i < images.length; i++) {
                                        File file = await images[i].file;
                                        files.add(file);
                                      }

                                      BlocProvider.of<PickMultiImageCubit>(
                                              context)
                                          .pickImages(images);
                                    } catch (err) {
                                      Fluttertoast.showToast(
                                          msg: 'Đã có lỗi xảy ra');
                                    }
                                  },
                                  icon: Icon(Icons.photo_album_rounded),
                                  label:
                                      Text('Chọn ảnh (tối đa 8, tối thiểu 2)'));
                            },
                          ),
                        ),
                        BlocBuilder<UrlImageCubit, List<String>>(
                          builder: (context, urlState) {
                            return BlocBuilder<PickMultiImageCubit, List<File>>(
                              builder: (context, state) {
                                print(state.length);
                                return GridView.count(
                                  crossAxisSpacing: defaultPadding,
                                  physics: NeverScrollableScrollPhysics(),
                                  crossAxisCount: 4,
                                  mainAxisSpacing: defaultPadding,
                                  shrinkWrap: true,
                                  children: List.generate(
                                    state.length + urlState.length,
                                    (index) => Stack(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: index < urlState.length
                                                  ? NetworkImage(
                                                      urlState[index])
                                                  : FileImage(
                                                      state[index -
                                                          urlState.length],
                                                    ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.black26,
                                            ),
                                            child: IconButton(
                                              color: Colors.white,
                                              padding: EdgeInsets.all(0),
                                              iconSize: 20,
                                              onPressed: () {
                                                if (index < urlState.length) {
                                                  res.urlHinhAnh
                                                      .remove(urlState[index]);
                                                  BlocProvider.of<
                                                              UrlImageCubit>(
                                                          context)
                                                      .loadUrl(res.urlHinhAnh);
                                                  print(res.urlHinhAnh.length);
                                                } else
                                                  images.remove(images[
                                                      index - urlState.length]);
                                                BlocProvider.of<
                                                            PickMultiImageCubit>(
                                                        context)
                                                    .pickImages(images);
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
                            );
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        Text(
                          'Mô tả',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: defaultPadding / 2,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: defaultPadding,
                              vertical: defaultPadding / 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black54),
                          ),
                          child: TextFormField(
                            maxLength: 500,
                            inputFormatters: [],
                            maxLines: null,
                            controller: _describeController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
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
          create: (context) =>
              coSoVatChat.dieuHoa ? (EnableCubit()..click()) : EnableCubit(),
          child: _buildUtilityCard(
            svgSrc: 'assets/icons/air_conditioner.svg',
            title: 'Điều hòa',
          ),
        ),
        BlocProvider(
          create: (context) =>
              coSoVatChat.banCong ? (EnableCubit()..click()) : EnableCubit(),
          child: _buildUtilityCard(
            svgSrc: 'assets/icons/balcony.svg',
            title: 'Ban công',
          ),
        ),
        BlocProvider(
          create: (context) =>
              coSoVatChat.mayGiat ? (EnableCubit()..click()) : EnableCubit(),
          child: _buildUtilityCard(
            svgSrc: 'assets/icons/washer.svg',
            title: 'Máy giặt',
          ),
        ),
        BlocProvider(
          create: (context) =>
              coSoVatChat.noiThat ? (EnableCubit()..click()) : EnableCubit(),
          child: _buildUtilityCard(
            svgSrc: 'assets/icons/interior.svg',
            title: 'Nội thất',
          ),
        ),
        BlocProvider(
          create: (context) =>
              coSoVatChat.gacLung ? (EnableCubit()..click()) : EnableCubit(),
          child: _buildUtilityCard(
            svgSrc: 'assets/icons/mezzanine.svg',
            title: 'Gác lửng',
          ),
        ),
        BlocProvider(
          create: (context) =>
              coSoVatChat.baoVe ? (EnableCubit()..click()) : EnableCubit(),
          child: _buildUtilityCard(
            svgSrc: 'assets/icons/guard.svg',
            title: 'Bảo vệ',
          ),
        ),
        BlocProvider(
          create: (context) =>
              coSoVatChat.hoBoi ? (EnableCubit()..click()) : EnableCubit(),
          child: _buildUtilityCard(
            svgSrc: 'assets/icons/pool.svg',
            title: 'Hồ bơi',
          ),
        ),
        BlocProvider(
          create: (context) =>
              coSoVatChat.baiDauXe ? (EnableCubit()..click()) : EnableCubit(),
          child: _buildUtilityCard(
            svgSrc: 'assets/icons/parking.svg',
            title: 'Bãi đậu xe',
          ),
        ),
        BlocProvider(
          create: (context) =>
              coSoVatChat.sanThuong ? (EnableCubit()..click()) : EnableCubit(),
          child: _buildUtilityCard(
            svgSrc: 'assets/icons/roof.svg',
            title: 'Sân thượng',
          ),
        ),
        BlocProvider(
          create: (context) =>
              coSoVatChat.cctv ? (EnableCubit()..click()) : EnableCubit(),
          child: _buildUtilityCard(
            svgSrc: 'assets/icons/cctv.svg',
            title: 'CCTV',
          ),
        ),
        BlocProvider(
          create: (context) => coSoVatChat.nuoiThuCung
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

  BlocProvider<RadioCubit> _buildCategorySelector() {
    return BlocProvider(
      create: (context) => RadioCubit()
        ..click(res.loaiChoThue == LoaiChoThue.Nha
            ? 0
            : res.loaiChoThue == LoaiChoThue.CanHo
                ? 1
                : 2),
      child: Builder(
        builder: (context) => BlocBuilder<RadioCubit, int>(
          builder: (context, state) {
            return Row(
              children: [
                MaterialButton(
                  color: (state == 0) ? Color(0xFF0D4880) : Colors.white,
                  onPressed: () {
                    res.loaiChoThue = LoaiChoThue.Nha;
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
                    res.loaiChoThue = LoaiChoThue.CanHo;
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
                    res.loaiChoThue = LoaiChoThue.Phong;
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

  BlocProvider<RadioCubit> _buildStatusSelector() {
    return BlocProvider(
      create: (context) => RadioCubit()
        ..click(res.tinhTrang == TinhTrangChoThue.ConTrong
            ? 0
            : res.tinhTrang == TinhTrangChoThue.DaThue
                ? 1
                : 2),
      child: Builder(
        builder: (context) => BlocBuilder<RadioCubit, int>(
          builder: (context, state) {
            return Row(
              children: [
                MaterialButton(
                  color: (state == 0) ? Color(0xFF0D4880) : Colors.white,
                  onPressed: () {
                    res.tinhTrang = TinhTrangChoThue.ConTrong;
                    BlocProvider.of<RadioCubit>(context).click(0);
                  },
                  child: Text(
                    'Còn trống',
                    style: TextStyle(
                        color: !(state == 0) ? Colors.black : Colors.white),
                  ),
                ),
                MaterialButton(
                  color: (state == 1) ? Color(0xFF0D4880) : Colors.white,
                  onPressed: () {
                    res.tinhTrang = TinhTrangChoThue.DaThue;
                    BlocProvider.of<RadioCubit>(context).click(1);
                  },
                  child: Text(
                    'Đã thuê',
                    style: TextStyle(
                        color: !(state == 1) ? Colors.black : Colors.white),
                  ),
                ),
                MaterialButton(
                  color: (state == 2) ? Color(0xFF0D4880) : Colors.white,
                  onPressed: () {
                    res.tinhTrang = TinhTrangChoThue.DangBaoTri;
                    BlocProvider.of<RadioCubit>(context).click(2);
                  },
                  child: Text(
                    'Đang bảo trì',
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

  @override
  void dispose() {
    _areaController.dispose();
    _bathController.dispose();
    _bedController.dispose();
    _moneyController.dispose();
    _describeController.dispose();
    _numController.dispose();
    _streetController.dispose();
    super.dispose();
  }
}
