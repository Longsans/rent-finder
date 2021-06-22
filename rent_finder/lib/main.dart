import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/repos/repos.dart';
import 'logic/bloc.dart';
import 'routes/app_router.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  UserRepository userRepository =
      UserRepository(firebaseAuth: FirebaseAuth.instance);
  HouseRepository houseRepository = HouseRepository();
  AppRouter appRouter = new AppRouter();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<NavigationBarBloc>(
          create: (context) => NavigationBarBloc(),
        ),
        BlocProvider(
          create: (context) => SavedHouseBloc()..add(LoadSavedHouses()),
        ),
        BlocProvider(
          create: (context) => RecentViewBloc()..add(LoadViewedHouses()),
        ),
        BlocProvider<AuthenticationBloc>(
          create: (context) =>
              AuthenticationBloc(userRepository: userRepository)
                ..add(AuthenticationEventStarted()),
        ),
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(
            userRepository: userRepository,
          ),
        ),
        BlocProvider<RegisterBloc>(
          create: (context) => RegisterBloc(
            userRepository: userRepository,
          ),
        ),
        BlocProvider<UpdateProfileBloc>(
          create: (context) => UpdateProfileBloc(
            userRepository: userRepository,
          ),
        ),
        BlocProvider<HouseBloc>(
          create: (context) => HouseBloc(houseRepository: houseRepository),
        ),
        BlocProvider(
          create: (context) => MyHousesBloc(),
        ),
      ],
      child: MyApp(
        appRouter: appRouter,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;

  const MyApp({Key key, @required this.appRouter}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: appRouter.onGenerateRoute,
      initialRoute: '/',
    );
  }
}
