import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rent_finder_hi/constants.dart';
import 'package:rent_finder_hi/logic/bloc.dart';
import 'package:rent_finder_hi/presentation/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rent_finder_hi/data/models/models.dart' as model;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key, this.user}) : super(key: key);
  final model.User user;
  @override
  _ProfileScreenState createState() => _ProfileScreenState(user: user);
}

class _ProfileScreenState extends State<ProfileScreen> {
  final model.User user;

  _ProfileScreenState({this.user});
  TextEditingController _phoneController;
  TextEditingController _nameController;

  @override
  void initState() {
    _nameController = TextEditingController(text: user.hoTen ?? "");
    _phoneController = TextEditingController(text: user.sdt ?? "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PickImageCubit>(
      create: (context) => PickImageCubit(
          userRepository:
              BlocProvider.of<UpdateProfileBloc>(context).userRepository),
      child: Scaffold(
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
          title: Text(
            'Thông tin cá nhân',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        body: BlocListener<UpdateProfileBloc, UpdateProfileState>(
          listener: (context, state) {
            if (state.isSuccess) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Cập nhật thành công"),
                      Icon(Icons.verified, color: Colors.green),
                    ],
                  ),
                ));
              BlocProvider.of<AuthenticationBloc>(context)
                  .add(AuthenticationEventStarted());
              Navigator.of(context).pop();
            } else if (state.isFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Cập nhật thất bại"),
                      Icon(Icons.error, color: Colors.red),
                    ],
                  ),
                ));
            } else if (state.isSubmitting) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(" Đang cập nhật..."),
                      CircularProgressIndicator(),
                    ],
                  ),
                ));
            }
          },
          child: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            BlocBuilder<PickImageCubit, String>(
                              builder: (context, state) {
                                if (state == null)
                                  return CachedNetworkImage(
                                    imageUrl: user.urlHinhDaiDien ?? '',
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      height: 90,
                                      width: 90,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => Icon(
                                      Icons.account_circle_outlined,
                                      size: 90,
                                      color: Color(0xFF0D4880),
                                    ),
                                  );
                                else {
                                  return Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Center(
                                        child: Container(
                                          height: 90,
                                          width: 90,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: FileImage(File(state)),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: GestureDetector(
                                            onTap: () {
                                              BlocProvider.of<PickImageCubit>(
                                                      context)
                                                  .removeImage();
                                            },
                                            child: CircleAvatar(
                                                backgroundColor: Colors.black12,
                                                child: Icon(Icons.close,
                                                    color: Colors.white))),
                                      )
                                    ],
                                  );
                                }
                              },
                            ),
                            ImageButton(user: user),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      buildNameInput(),
                      SizedBox(
                        height: defaultPadding,
                      ),
                      buildPhoneInput(),
                      SizedBox(
                        height: 120,
                      ),
                      buildSaveButton(),
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }

  BlocBuilder<UpdateProfileBloc, UpdateProfileState> buildSaveButton() {
    return BlocBuilder<UpdateProfileBloc, UpdateProfileState>(
      builder: (context, state) {
        return BlocBuilder<PickImageCubit, String>(
          builder: (context, stateImage) {
            return CustomButton(
              title: 'Lưu',
              press: () {
                if (state.isFormValid) {
                  if (_nameController.text.trim().isEmpty ||
                      _phoneController.text.trim().isEmpty) {
                    Fluttertoast.showToast(
                        msg:
                            'Hãy chắc chắn rằng bạn đã nhập đầy đủ thông tin');
                    return;
                  }

                  BlocProvider.of<UpdateProfileBloc>(context).add(FormSubmitted(
                    phone: _phoneController.text,
                    name: _nameController.text,
                    url: stateImage,
                  ));
                } else {
                  Fluttertoast.showToast(
                      msg: 'Hãy nhập thông tin của bạn chính xác');
                }
              },
              icon: Icon(
                Icons.save,
                color: Colors.white,
              ),
            );
          },
        );
      },
    );
  }

  BlocBuilder<UpdateProfileBloc, UpdateProfileState> buildPhoneInput() {
    return BlocBuilder<UpdateProfileBloc, UpdateProfileState>(
      builder: (context, state) {
        return TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Số điện thoại',
            hintText: '0353398596',
            errorText:
                !state.isPhoneValid ? 'Số điện thoại không hợp lệ' : null,
          ),
          onChanged: (value) {
            BlocProvider.of<UpdateProfileBloc>(context)
                .add(PhoneChanged(phone: value));
          },
        );
      },
    );
  }

  BlocBuilder<UpdateProfileBloc, UpdateProfileState> buildNameInput() {
    return BlocBuilder<UpdateProfileBloc, UpdateProfileState>(
      builder: (context, state) {
        return TextFormField(
          controller: _nameController,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            labelText: 'Tên',
            hintText: 'James',
            errorText: !state.isNameValid ? 'Không được để trống ô này' : null,
          ),
          onChanged: (value) {
            BlocProvider.of<UpdateProfileBloc>(context)
                .add(NameChanged(name: value));
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}

class ImageButton extends StatelessWidget {
  ImageButton({Key key, this.user}) : super(key: key);
  final model.User user;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        String pathDaiDien;
        ImagePicker imagePicker = ImagePicker();
        PickedFile pickedFile = await imagePicker
            .getImage(source: ImageSource.gallery)
            .catchError((err) {
          Fluttertoast.showToast(msg: 'Đã có lỗi xảy ra');
        });
        if (pickedFile != null) {
          pathDaiDien = pickedFile.path;
          BlocProvider.of<PickImageCubit>(context).pickImage(pathDaiDien);
        }
      },
      child: Icon(
        Icons.camera_alt,
        color: Colors.blueGrey,
      ),
    );
  }
}
