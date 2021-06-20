import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rent_finder_hi/logic/bloc.dart';
import 'screens.dart';

class HomeArea extends StatelessWidget {
  const HomeArea({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
          BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          return FloatingActionButton(
            onPressed: () {
              if (state is AuthenticationStateSuccess)
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (context) => PostFormBloc(),
                        ),
                        BlocProvider(
                          create: (context) => PickMultiImageCubit(),
                        ),
                      ],
                      child: PostHouseScreen(
                        user: state.user,
                      ),
                    ),
                  ),
                );
              else
                Fluttertoast.showToast(
                    msg: 'Cần đnăg nhập để thực hiện chức năng này');
            },
          );
        },
      ),
      body: SafeArea(
        child: Center(
          child: Text('Trang chủ'),
        ),
      ),
    );
  }
}
