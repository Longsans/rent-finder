import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_finder/data/repos/user_repository.dart';
import 'package:rent_finder/logic/auth_bloc/authentication_bloc.dart';
import 'package:rent_finder/logic/auth_bloc/authentication_event.dart';
import 'package:rent_finder/logic/register_bloc/register_bloc.dart';
import 'package:rent_finder/logic/register_bloc/register_event.dart';
import 'package:rent_finder/logic/register_bloc/register_state.dart';

import 'package:rent_finder/presentation/screens/login_screen.dart';

class RegisterForm extends StatefulWidget {
  final UserRepository _userRepository;

  RegisterForm({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

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
    return isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    _signUpBloc = BlocProvider.of<RegisterBloc>(context);

    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);

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
          Scaffold.of(context)
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Sign Up Failed"),
                    Icon(Icons.error),
                  ],
                ),
              ),
            );
        }
        if (state.isSubmitting) {
          print("isSubmitting");
          Scaffold.of(context)
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Signing up..."),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }
        if (state.isSuccess) {
          print("Success login");
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            'Đăng ký',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.person),
                            hintText: 'Tên',
                            border: UnderlineInputBorder()),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.phone),
                            hintText: 'Số điện thoại',
                            border: UnderlineInputBorder()),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.mail),
                            hintText: 'Email',
                            border: UnderlineInputBorder()),
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        autovalidate: true,
                        validator: (_) {
                          return !state.isEmailValid ? "Invalid Email" : null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.remove_red_eye),
                            hintText: 'Mật khẩu',
                            border: UnderlineInputBorder()),
                        controller: _passwordController,
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        obscureText: true,
                        autovalidate: true,
                        validator: (_) {
                          return !state.isPasswordValid
                              ? "Invalid Password"
                              : null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.code),
                            hintText: 'Referral Code',
                            border: UnderlineInputBorder()),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    RaisedButton(
                        padding: EdgeInsets.fromLTRB(120.0, 0, 120.0, 0),
                        color: Colors.red,
                        disabledColor: Colors.blue,
                        disabledTextColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Text("Đăng ký",
                            style: new TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        onPressed: () {
                          /* Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => HomeScreen()),
                                        );*/
                          /* isButtonEnabled(state)
                                            ? _onFormSubmitted
                                            : null;*/
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
                          'Tôi đã có tài khoản',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return LoginScreen();
                                },
                              ),
                            );
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
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: NeverScrollableScrollPhysics(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'By Logging in, you agree to our  ',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Term & Conditions',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          // Text(
                          //   '&',
                          //   style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          // ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      '&',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    Center(
                      child: Text(
                        'Privacy Policy',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
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

  void _onEmailChanged() {
    _signUpBloc.add(
      RegisterEmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _signUpBloc.add(
      RegisterPasswordChanged(password: _passwordController.text),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();

    super.dispose();
  }
}
