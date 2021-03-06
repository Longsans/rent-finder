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
  bool firstPress;
  void initState() {
    firstPress = true;
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
              firstPress = true;
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('???? c?? l???i x???y ra. C???p nh???t th???t b???i!'),
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
                        Text('Nh?? c???a b???n ???? ???????c c???p nh???t th??nh c??ng'),
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
                        Text('??ang c???p nh???t...'),
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
                  title: 'X??c nh???n',
                  press: () async {
                    if (!isFilled) {
                      Fluttertoast.showToast(
                          msg: 'Vui l??ng nh???p ?????y ????? th??ng tin');
                    } else {
                      if (res.urlHinhAnh.length + files.length < 2) {
                        Fluttertoast.showToast(
                            msg: 'B???n c???n th??m t???i thi???u 2 ???nh');
                        return;
                      }

                      var query =
                          '${_numController.text} ${_streetController.text}, $phuongXa, $quanHuyen Th??nh ph??? H??? Ch?? Minh';
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
                                  '?????a ch??? kh??ng h???p l???. N???u c?? l???i h??y b??o c??o v???i ch??ng t??i t???i ph???n Ng?????i d??ng');
                          return;
                        }
                        toaDo = ggMap.LatLng(address.first.coordinates.latitude,
                            address.first.coordinates.longitude);
                      } catch (e) {
                        print(e.toString());
                        print('?????a ch??? kh??ng h???p l???');
                        Fluttertoast.showToast(
                            msg:
                                '?????a ch??? kh??ng h???p l???. N???u c?? l???i h??y b??o c??o v???i ch??ng t??i t???i ph???n Ng?????i d??ng');
                        return;
                      }
                      if (firstPress) {
                        var t = showDialog(
                          context: context,
                          builder: (context) {
                            return ConfirmDialog(
                              title: 'B???n c?? ch???c ch???n c???p nh???t nh?? n??y kh??ng?',
                            );
                          },
                        );
                        t.then(
                          (value) {
                            if (value != null) {
                              if (value) {
                                firstPress = false;
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
                  'C???p nh???t nh??',
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
                          '?????a ch???',
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
                                  hint: Text('Ch???n qu???n/huy???n'),
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
                                      hint: Text('Ch???n x??/ph?????ng'),
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
                                    labelText: 'S??? nh??',
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
                                    //     state.isNumValid ? '' : "Kh??ng ???????c ????? tr???ng",
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
                                    labelText: 'T??n ???????ng',
                                    // errorText: state.isStreetValid
                                    //     ? ''
                                    //     : "Kh??ng ???????c ????? tr???ng",
                                    hintText: 'Nguy???n B???nh Khi??m'),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: defaultPadding,
                        ),
                        Text(
                          'Th??ng tin c?? b???n',
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
                                    labelText: 'S??? ph??ng ng???',
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
                                    //     state.isNumValid ? '' : "Kh??ng ???????c ????? tr???ng",
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
                                    labelText: 'S??? ph??ng t???m',
                                    // errorText: state.isStreetValid
                                    //     ? ''
                                    //     : "Kh??ng ???????c ????? tr???ng",
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
                                    labelText: 'Di???n t??ch(m2)',
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
                                    //     state.isNumValid ? '' : "Kh??ng ???????c ????? tr???ng",
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
                                    labelText: 'Gi?? ti???n th??ng (VN??)',
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
                                    //     state.isNumValid ? '' : "Kh??ng ???????c ????? tr???ng",
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
                          'Lo???i h??nh',
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
                          'T??nh tr???ng',
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
                          'C?? s??? v???t ch???t',
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
                                          msg: '???? c?? l???i x???y ra');
                                    }
                                  },
                                  icon: Icon(Icons.photo_album_rounded),
                                  label:
                                      Text('Ch???n ???nh (t???i ??a 8, t???i thi???u 2)'));
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
                          'M?? t???',
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
            title: '??i???u h??a',
          ),
        ),
        BlocProvider(
          create: (context) =>
              coSoVatChat.banCong ? (EnableCubit()..click()) : EnableCubit(),
          child: _buildUtilityCard(
            svgSrc: 'assets/icons/balcony.svg',
            title: 'Ban c??ng',
          ),
        ),
        BlocProvider(
          create: (context) =>
              coSoVatChat.mayGiat ? (EnableCubit()..click()) : EnableCubit(),
          child: _buildUtilityCard(
            svgSrc: 'assets/icons/washer.svg',
            title: 'M??y gi???t',
          ),
        ),
        BlocProvider(
          create: (context) =>
              coSoVatChat.noiThat ? (EnableCubit()..click()) : EnableCubit(),
          child: _buildUtilityCard(
            svgSrc: 'assets/icons/interior.svg',
            title: 'N???i th???t',
          ),
        ),
        BlocProvider(
          create: (context) =>
              coSoVatChat.gacLung ? (EnableCubit()..click()) : EnableCubit(),
          child: _buildUtilityCard(
            svgSrc: 'assets/icons/mezzanine.svg',
            title: 'G??c l???ng',
          ),
        ),
        BlocProvider(
          create: (context) =>
              coSoVatChat.baoVe ? (EnableCubit()..click()) : EnableCubit(),
          child: _buildUtilityCard(
            svgSrc: 'assets/icons/guard.svg',
            title: 'B???o v???',
          ),
        ),
        BlocProvider(
          create: (context) =>
              coSoVatChat.hoBoi ? (EnableCubit()..click()) : EnableCubit(),
          child: _buildUtilityCard(
            svgSrc: 'assets/icons/pool.svg',
            title: 'H??? b??i',
          ),
        ),
        BlocProvider(
          create: (context) =>
              coSoVatChat.baiDauXe ? (EnableCubit()..click()) : EnableCubit(),
          child: _buildUtilityCard(
            svgSrc: 'assets/icons/parking.svg',
            title: 'B??i ?????u xe',
          ),
        ),
        BlocProvider(
          create: (context) =>
              coSoVatChat.sanThuong ? (EnableCubit()..click()) : EnableCubit(),
          child: _buildUtilityCard(
            svgSrc: 'assets/icons/roof.svg',
            title: 'S??n th?????ng',
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
            title: 'Th?? c??ng',
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
              case '??i???u h??a':
                coSoVatChat.dieuHoa = !state;
                break;
              case 'Ban c??ng':
                coSoVatChat.banCong = !state;
                break;
              case 'N???i th???t':
                coSoVatChat.noiThat = !state;
                break;
              case 'G??c l???ng':
                coSoVatChat.gacLung = !state;
                break;
              case 'B???o v???':
                coSoVatChat.baoVe = !state;
                break;
              case 'H??? b??i':
                coSoVatChat.hoBoi = !state;
                break;
              case 'S??n th?????ng':
                coSoVatChat.sanThuong = !state;
                break;
              case 'CCTV':
                coSoVatChat.cctv = !state;
                break;
              case 'Th?? c??ng':
                coSoVatChat.nuoiThuCung = !state;
                break;
              case 'M??y gi???t':
                coSoVatChat.mayGiat = !state;
                break;

              case 'B??i ?????u xe':
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
                    'Nh??',
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
                    'C??n h???',
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
                    'Ph??ng',
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
                    'C??n tr???ng',
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
                    '???? thu??',
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
                    '??ang b???o tr??',
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
