import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_finder/data/repos/user_repository.dart';

import 'constants.dart';
import 'logic/bloc.dart';
import 'routes/app_router.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  UserRepository userRepository =
      UserRepository(firebaseAuth: FirebaseAuth.instance);
  AppRouter appRouter = new AppRouter();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<NavigationBarBloc>(
          create: (context) => NavigationBarBloc(),
        ),
        BlocProvider<LikeBloc>(
          create: (context) => LikeBloc(likedHouses),
        ),
        BlocProvider<CategoryBloc>(
          create: (context) => CategoryBloc()..add(CategoryStarted()),
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
      initialRoute: '/intro',
    );
  }
}
