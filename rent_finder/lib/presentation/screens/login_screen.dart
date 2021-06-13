import 'package:rent_finder/data/repos/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_finder/logic/auth_bloc/authentication_bloc.dart';
import 'package:rent_finder/logic/auth_bloc/authentication_event.dart';
import 'package:rent_finder/logic/auth_bloc/authentication_state.dart';
import 'package:rent_finder/logic/login_bloc/login_bloc.dart';
import 'package:rent_finder/presentation/screens/home_screen.dart';
import 'login_form.dart';

class LoginScreen extends StatelessWidget {
  final UserRepository _userRepository = UserRepository();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:  LoginForm(
        userRepository: _userRepository,
      ),
    );
  }
}
