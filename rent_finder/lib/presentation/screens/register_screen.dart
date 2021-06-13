import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_finder/data/repos/user_repository.dart';

import 'package:rent_finder/logic/register_bloc/register_bloc.dart';
import 'package:rent_finder/presentation/screens/register_form.dart';
class RegisterScreen extends StatelessWidget {
  final UserRepository _userRepository;

  RegisterScreen({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Sign Up",
            style: TextStyle(fontSize: 36.0),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: BlocProvider<RegisterBloc>(
          create: (context) => RegisterBloc(
            userRepository: _userRepository,
          ),
          child: RegisterForm(
            userRepository: _userRepository,
          ),
        ),
      );
  }
}