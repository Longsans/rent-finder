import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_finder/constants.dart';
import 'package:rent_finder/logic/bloc.dart';
import 'package:rent_finder/presentation/widgets/widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(defaultPadding),
            child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    if (state is AuthenticationStateSuccess)
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            CachedNetworkImage(
                              imageUrl: (state.user != null)
                                  ? state.user.urlHinhDaiDien ?? ""
                                  : "",
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
                            ),
                            GestureDetector(
                              onTap: () {
                                print('cc nè');
                              },
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Họ và tên',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    SizedBox(
                      height: defaultPadding / 2,
                    ),
                    TextFieldProfile(
                      controller: _nameController,
                      inputType: TextInputType.name,
                    ),
                    SizedBox(
                      height: defaultPadding,
                    ),
                    Text(
                      'Số điện thoại',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    SizedBox(
                      height: defaultPadding / 2,
                    ),
                    TextFieldProfile(
                      controller: _phoneController,
                      inputType: TextInputType.phone,
                    ),
                    SizedBox(
                      height: defaultPadding,
                    ),
                    Text(
                      'Email',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    SizedBox(
                      height: defaultPadding / 2,
                    ),
                    TextFieldProfile(
                      controller: _emailController,
                      inputType: TextInputType.emailAddress,
                    ),
                    SizedBox(
                      height: 120,
                    ),
                    CustomButton(
                      title: 'Lưu',
                      press: () {},
                      icon: Icon(
                        Icons.save,
                        color: Colors.white,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class TextFieldProfile extends StatelessWidget {
  const TextFieldProfile({
    Key key,
    @required TextEditingController controller,
    this.inputType,
  })  : _controller = controller,
        super(key: key);

  final TextEditingController _controller;
  final TextInputType inputType;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black54, width: 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        
        keyboardType: inputType,
        controller: _controller,
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
      ),
    );
  }
}
