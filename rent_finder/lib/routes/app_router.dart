import 'package:flutter/material.dart';

import '../presentation/screens/screens.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomeScreen());
        break;
      case '/saved':
        return MaterialPageRoute(builder: (_) => SavedArea());
        break;
      case '/user':
        return MaterialPageRoute(builder: (_) => UserArea());
        break;
      case '/search':
        return MaterialPageRoute(builder: (_) => SearchArea());
        break;
      default:
        return null;
        
    }
  }
}
