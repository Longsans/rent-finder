import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rent_finder_hi/logic/bloc.dart';
import 'package:rent_finder_hi/presentation/widgets/widgets.dart';

import 'screens.dart';

class LoginForm extends StatefulWidget {
  LoginForm();

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isButtonEnabled(LoginState state) {
    return isPopulated && state.isFormValid;
  }

  LoginBloc _loginBloc;

  @override
  void initState() {
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.isFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(state.error),
                        Icon(Icons.error, color: Colors.red),
                      ],
                    ),
                  ),
                );
            }

            if (state.isSubmitting) {
              print("isSubmitting");
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    duration: Duration(minutes: 1),
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(" Đang đăng nhập..."),
                        CircularProgressIndicator(),
                      ],
                    ),
                  ),
                );
            }

            if (state.isSuccess) {
              BlocProvider.of<AuthenticationBloc>(context)
                  .add(AuthenticationEventLoggedIn());
            }
          },
        ),
        BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (context, authState) {
          if (authState is AuthenticationStateSuccess) {
            if (authState.user.banned) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              Fluttertoast.showToast(
                  msg:
                      'Tài khoản của bạn đã bị khóa! Vui lòng liên hệ với chúng tôi để được hỗ trợ!');
            } else {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              Fluttertoast.showToast(msg: 'Đăng nhập thành công');
              Navigator.of(context).pushReplacementNamed('/');
            }
          }
        }),
      ],
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding:
                    const EdgeInsets.only(right: 20.0, left: 20.0, top: 10.0),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(220.0, 0.0, 0.0, 0.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed('/');
                        },
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[400],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                EvaIcons.arrowCircleRight,
                                color: Colors.white,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                " Bỏ qua",
                                style: new TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 200.0,
                      padding: EdgeInsets.only(bottom: 20.0, top: 40.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Rent Finder",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 30.0),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            "Ứng dụng tìm nhà trọ tiện lợi cho bạn",
                            style: TextStyle(
                                fontSize: 12.0, color: Colors.black38),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        _loginBloc.add(LoginEmailChange(email: value));
                      },
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black45,
                          fontWeight: FontWeight.bold),
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email, color: Colors.black54),
                        enabledBorder: OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.black54),
                            borderRadius: BorderRadius.circular(10.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(10.0)),
                        contentPadding: EdgeInsets.only(
                            left: 10.0, right: 10.0, top: 20, bottom: 20),
                        labelText: "E-Mail",
                        hintStyle: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.w500),
                        labelStyle: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.w500),
                        border: OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.black54),
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                      autocorrect: false,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (_) {
                        return !state.isEmailValid
                            ? "Email không hợp lệ"
                            : null;
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                        onChanged: (value) {
                          _loginBloc.add(LoginPasswordChanged(
                              password: _passwordController.text));
                        },
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black45,
                            fontWeight: FontWeight.bold),
                        controller: _passwordController,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: Colors.black54,
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.black54),
                              borderRadius: BorderRadius.circular(10.0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(10.0)),
                          contentPadding: EdgeInsets.only(
                              left: 10.0, right: 10.0, top: 20, bottom: 20),
                          labelText: "Mật khẩu",
                          hintStyle: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500),
                          labelStyle: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500),
                          border: OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.black54),
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                        autocorrect: false,
                        obscureText: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (_) {
                          return !state.isPasswordValid
                              ? 'Mật khẩu không hợp lệ'
                              : null;
                        }),
                    SizedBox(
                      height: 30.0,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: new InkWell(
                          child: new Text(
                            "Quên mật khẩu?",
                            style: TextStyle(color: Colors.black45),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgotPassword()),
                            );
                          }),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    CustomButton(
                      press: () {
                        if (isButtonEnabled(state)) {
                          _onFormSubmitted();
                        }
                      },
                      title: 'Đăng nhập',
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Hoặc đăng nhập cách khác",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 12.0),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    CustomButton(
                      color: Colors.red,
                      press: () {
                        _loginBloc.add(LoginWithGooglePressed());
                      },
                      title: ' Đăng nhập với Google',
                      icon: Icon(
                        EvaIcons.google,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          padding: EdgeInsets.only(bottom: 30.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Bạn chưa có tài khoản ?",
                                style: TextStyle(color: Colors.grey),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 5.0),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed('/register');
                                  },
                                  child: Text(
                                    "Đăng ký",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold),
                                  ))
                            ],
                          )),
                    ),
                    SizedBox(
                      height: 20.0,
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
    // return Container();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onFormSubmitted() {
    _loginBloc.add(LoginWithCredentialsPressed(
        email: _emailController.text, password: _passwordController.text));
  }
}
