import 'package:flutter/material.dart';
import 'package:rent_finder_hi/presentation/screens/screens.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings routeSettings) {
    List<dynamic> args = routeSettings.arguments;
    switch (routeSettings.name) {
      case '/intro':
        return MaterialPageRoute(builder: (_) => IntroPage());
        break;
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginScreen());
        break;
      case '/':
        return MaterialPageRoute(builder: (_) => HomeScreen());
        break;
      case '/register':
        return MaterialPageRoute(builder: (_) => RegisterScreen());
        break;
      case '/detail':
        return MaterialPageRoute(builder: (_) {
          return DetailScreen(
            house: args[0],
          );
        });
        break;
      case '/gallery':
        return MaterialPageRoute(builder: (_) {
          return GalleryPage(
            index: args[1],
            imgList: args[0],
          );
        });
        break;
      case '/search':
        return MaterialPageRoute(builder: (_) => SearchArea());
        break;
      case '/filter_enhance':
        return MaterialPageRoute(builder: (_) => FilterEnhanceScreen());
        break;
      case '/result':
        return MaterialPageRoute(builder: (_) => SearchResultScreen());
        break;
      case '/profile':
        return MaterialPageRoute(
          builder: (_) => ProfileScreen(
            user: args[0],
          ),
        );
        break;
     
      default:
        return null;
    }
  }
}
