import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'logic/bloc/navigation_bar_bloc.dart';
import 'routes/app_router.dart';

void main() {
  AppRouter appRouter = new AppRouter();
  runApp(
    BlocProvider<NavigationBarBloc>(
      create: (context) => NavigationBarBloc(),
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
