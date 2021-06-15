import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_finder/logic/bloc.dart';


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
    return isPopulated && !state.isSubmitting;
  }

  LoginBloc _loginBloc;

  @override
  void initState() {
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onEmailChange);
    _passwordController.addListener(_onPasswordChange);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.isFailure) {
          ScaffoldMessenger.of(context)
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Login Failed"),
                    Icon(Icons.error),
                  ],
                ),
              ),
            );
        }

        if (state.isSubmitting) {
          print("isSubmitting");
          ScaffoldMessenger.of(context)
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(" Logging In..."),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }
        
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context)
              .add(AuthenticationEventLoggedIn());
          Navigator.of(context).pushReplacementNamed('/');
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return SafeArea(
            child: Container(
              padding: const EdgeInsets.only(right: 20.0, left: 20.0, top: 10.0),
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
                              Text(" Bỏ qua",
                                  style: new TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ],
                          ),
                        )),
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
                                fontSize: 24.0),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            "Đăng nhập để có thêm các tính năng mới",
                            style: TextStyle(
                                fontSize: 10.0, color: Colors.black38),
                          )
                        ],
                      )),
                  SizedBox(
                    height: 30.0,
                  ),
                  TextFormField(
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black45,
                        fontWeight: FontWeight.bold),
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email, color: Colors.black26),
                      enabledBorder: OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.black12),
                          borderRadius: BorderRadius.circular(30.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(30.0)),
                      contentPadding: EdgeInsets.only(left: 10.0, right: 10.0),
                      labelText: "E-Mail",
                      hintStyle: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500),
                      labelStyle: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500),
                    ),
                    autocorrect: false,
                    autovalidateMode: AutovalidateMode.always,
                    validator: (_) {
                      return !state.isEmailValid
                          ? "Email sai định dạng hoặc đã trùng"
                          : null;
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                      style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black45,
                          fontWeight: FontWeight.bold),
                      controller: _passwordController,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: Colors.black26,
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(30.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(30.0)),
                        contentPadding:
                            EdgeInsets.only(left: 10.0, right: 10.0),
                        labelText: "Mật khẩu",
                        hintStyle: TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500),
                        labelStyle: TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500),
                      ),
                      autocorrect: false,
                      obscureText: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (_) {
                        return !state.isPasswordValid
                            ? 'Invalid Password'
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
                          style:
                              TextStyle(color: Colors.black45, fontSize: 12.0),
                        ),
                        onTap: () {}),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30.0, bottom: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(
                            height: 45,
                            child: GestureDetector(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.0),
                                    color: Colors.blue,
                                  ),
                                  child: Center(
                                    child: Text("Đăng nhập",
                                        style: new TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                  ),
                                ),
                                onTap: () {
                                  if (isButtonEnabled(state)) {
                                    _onFormSubmitted();
                                  }
                                })),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Hoặc đăng nhập cách khác",
                        style: TextStyle(color: Colors.black26, fontSize: 12.0),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: GestureDetector(
                            onTap: () {
                              _loginBloc.add(LoginWithGooglePressed());
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                color: Color(0xFFf14436),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    EvaIcons.google,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  Text(" Đăng nhập với Google",
                                      style: new TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ],
                              ),
                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Expanded(
                    child: Align(
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
                  ),
                  SizedBox(
                    height: 20.0,
                  )
                ],
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

  void _onEmailChange() {
    _loginBloc.add(LoginEmailChange(email: _emailController.text));
  }

  void _onPasswordChange() {
    _loginBloc.add(LoginPasswordChanged(password: _passwordController.text));
  }

  void _onFormSubmitted() {
    _loginBloc.add(LoginWithCredentialsPressed(
        email: _emailController.text, password: _passwordController.text));
  }
}
