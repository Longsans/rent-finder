import 'package:flutter/material.dart';
import 'package:rent_finder/presentation/screens/detail_screen.dart';
import 'package:rent_finder/presentation/screens/gallery_page.dart';
import '../presentation/screens/screens.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings routeSettings) {
    List<dynamic> args = routeSettings.arguments;
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomeScreen());
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
            index:  args[1],
            imgList: args[0],
          );
        });
        break;
      case '/search':
        return MaterialPageRoute(builder: (_) => SearchArea());
        break;
      default:
        return null;
    }
  }
}
