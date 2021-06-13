import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_finder/logic/auth_bloc/authentication_bloc.dart';
import 'package:rent_finder/logic/auth_bloc/authentication_event.dart';
import 'package:rent_finder/logic/auth_bloc/authentication_state.dart';
import 'package:rent_finder/presentation/screens/home_screen.dart';
import 'package:rent_finder/presentation/screens/login_screen.dart';
import 'package:rent_finder/presentation/widgets/custom_list_tile.dart';
import 'package:rent_finder/presentation/widgets/small_button.dart';
import 'package:rent_finder/data/repos/user_repository.dart';

class UserArea extends StatelessWidget {
  final UserRepository _userRepository;

  UserArea({@required UserRepository userRepository})
      : assert(1 == 1),
        _userRepository = userRepository;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      state is AuthenticationStateSuccess
                          ? "Xin chào ${state.firebaseUser.email}"
                          : "Đăng nhập để sử dụng đầy đủ chức năng",
                      style: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Center(
                      child: RaisedButton(
                        padding: EdgeInsets.fromLTRB(100, 0, 100, 0),
                        child: Text(state is AuthenticationStateSuccess
                            ? "Đăng xuất"
                            : "Đăng nhập"),
                        onPressed: () {
                          if (state is AuthenticationStateSuccess == false)
                            Navigator.of(context).pushNamed('/login');
                          else
                            BlocProvider.of<AuthenticationBloc>(context)
                                .add(AuthenticationEventLoggedOut());
                        },
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
