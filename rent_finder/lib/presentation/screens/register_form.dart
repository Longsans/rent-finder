import 'dart:developer';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:eva_icons_flutter/icon_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rent_finder_hi/constants.dart';
import 'package:rent_finder_hi/logic/bloc.dart';

class RegisterForm extends StatefulWidget {
  RegisterForm();

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  RegisterBloc _signUpBloc;
  //UserRepository get _userRepository => widget._userRepository;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isSignUpButtonEnabled(RegisterState state) {
    return isPopulated && state.isFormValid;
  }

  @override
  void initState() {
    _signUpBloc = BlocProvider.of<RegisterBloc>(context);
    super.initState();
  }

  void _onFormSubmitted() {
    _signUpBloc.add(
      RegisterSubmitted(
          email: _emailController.text, password: _passwordController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (BuildContext context, RegisterState state) {
        if (state.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(state.error),
                    Icon(
                      Icons.error,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            );
        }
        if (state.isSubmitting) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Đang đăng ký..."),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }
        if (state.isSuccess) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          Fluttertoast.showToast(msg: 'Đăng ký thành công!');
          BlocProvider.of<AuthenticationBloc>(context)
              .add(AuthenticationEventLoggedIn());
          Navigator.of(context).pushReplacementNamed('/');
        }
      },
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
                child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    SvgPicture.asset(
                      'assets/images/register.svg',
                      height: MediaQuery.of(context).size.height * 0.3,
                    ),
                    Text(
                      'Đăng ký',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: defaultPadding * 2,
                    ),
                    TextFormField(
                      onChanged: (val) {
                        _signUpBloc.add(
                          RegisterEmailChanged(email: _emailController.text),
                        );
                      },
                      decoration: InputDecoration(
                          labelText: 'Email',
                          focusColor: textColor,
                          errorBorder: OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.black54),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: new BorderSide(color: textColor),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          contentPadding:
                              EdgeInsets.only(left: 20.0, right: 10.0),
                          suffixIcon: Icon(
                            Icons.mail,
                            color: textColor,
                          ),
                          hintText: 'Email',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      autovalidateMode: AutovalidateMode.always,
                      validator: (_) {
                        return !state.isEmailValid
                            ? "Email không hợp lệ"
                            : null;
                      },
                    ),
                    SizedBox(
                      height: defaultPadding * 1.5,
                    ),
                    BlocProvider(
                      create: (context) => EnableCubit(),
                      child: Builder(
                        builder: (context) => BlocBuilder<EnableCubit, bool>(
                          builder: (context, passState) {
                            return TextFormField(
                              onChanged: (val) {
                                _signUpBloc.add(
                                  RegisterPasswordChanged(
                                      password: _passwordController.text),
                                );
                              },
                              decoration: InputDecoration(
                                labelText: 'Mật khẩu',
                                focusColor: textColor,
                                errorBorder: OutlineInputBorder(
                                  borderSide: new BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.black54),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: new BorderSide(color: textColor),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                contentPadding:
                                    EdgeInsets.only(left: 20.0, right: 10.0),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    BlocProvider.of<EnableCubit>(context)
                                        .click();
                                  },
                                  child: Icon(
                                      passState
                                          ? EvaIcons.eye
                                          : EvaIcons.eyeOff,
                                      color: textColor),
                                ),
                                hintText: 'Mật khẩu',
                                border: OutlineInputBorder(),
                              ),
                              controller: _passwordController,
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              obscureText: !passState,
                              autovalidateMode: AutovalidateMode.always,
                              validator: (_) {
                                return !state.isPasswordValid
                                    ? "Mật khẩu yêu cầu tối thiểu 8 ký tự bao gồm cả chữ và số"
                                    : null;
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    GestureDetector(
                        child: Container(
                          height: 50,
                          padding: EdgeInsets.fromLTRB(120.0, 0, 120.0, 0),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0, 17),
                                  color: Color(0xFFE6E6E6),
                                  blurRadius: 23,
                                  spreadRadius: 0)
                            ],
                            borderRadius: BorderRadius.circular(10.0),
                            color: textColor,
                          ),
                          child: Center(
                            child: Text("Đăng ký",
                                style: new TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ),
                        ),
                        onTap: () {
                          if (isSignUpButtonEnabled(state)) {
                            log("${_emailController.text.toString()}+0111111111111000000000000");
                            _onFormSubmitted();
                          }
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Bạn đã có tài khoản?',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            '  Đăng nhập',
                            style: TextStyle(
                                color: Colors.red[600],
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            )),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();

    super.dispose();
  }
}
