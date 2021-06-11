
import 'package:rent_finder/data/repos/user_repository.dart';
import 'package:rent_finder/logic/bloc/auth_bloc/authentication_bloc.dart';
import 'package:rent_finder/logic/bloc/auth_bloc/authentication_event.dart';
import 'package:rent_finder/logic/bloc/auth_bloc/authentication_state.dart';
import 'package:rent_finder/logic/bloc/login_bloc/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_finder/logic/bloc/register_bloc/register_bloc.dart';
import 'package:rent_finder/presentation/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login_form.dart';

class LoginScreen extends StatelessWidget {
  final UserRepository _userRepository = UserRepository();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Login with Firebase',
        home: BlocProvider(
          create: (context) =>
          AuthenticationBloc(userRepository: _userRepository)
            ..add(AuthenticationEventStarted()),
          child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, authenticationState) {
              if (authenticationState is AuthenticationStateSuccess) {
                print('111111111111111111111111111111111111111111');
                return HomeScreen(userRepository: _userRepository,user:authenticationState.firebaseUser);
              } else if (authenticationState is AuthenticationStateFailure) {
                print('222222222222222222222222222222222222');
                return BlocProvider<LoginBloc>(
                    create: (context) =>
                        LoginBloc(userRepository: _userRepository),
                    child: LoginForm(
                      userRepository: _userRepository,) //LoginPage,
                );
              }
              return Scaffold(
                body: Text('huhu'),
              );
            },
          ),
        )
    );
  }
}
