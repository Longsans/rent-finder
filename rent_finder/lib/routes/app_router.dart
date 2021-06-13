import 'package:flutter/material.dart';
import 'package:rent_finder/data/repos/user_repository.dart';
import 'package:rent_finder/presentation/screens/detail_screen.dart';
import 'package:rent_finder/presentation/screens/filter_enhance_screen.dart';
import 'package:rent_finder/presentation/screens/gallery_page.dart';

import 'package:rent_finder/presentation/screens/intro_screen.dart';
import 'package:rent_finder/presentation/screens/login_screen.dart';
import 'package:rent_finder/presentation/screens/register_screen.dart';
import 'package:rent_finder/presentation/screens/screens.dart';
import 'package:rent_finder/presentation/screens/search_area.dart';
import 'package:rent_finder/presentation/screens/search_result_screen.dart';

class AppRouter {
  final UserRepository userRepository;

  AppRouter({@required this.userRepository});
  Route onGenerateRoute(RouteSettings routeSettings) {
    List<dynamic> args = routeSettings.arguments;
    switch (routeSettings.name) {
      case '/intro':
       return MaterialPageRoute(
            builder: (_) => IntroPage());
        break;
        case '/login':
       return MaterialPageRoute(
            builder: (_) => LoginScreen());
        break;
      case '/':
        return MaterialPageRoute(
            builder: (_) => HomeScreen(userRepository: userRepository));
        break;
        case '/register':
        return MaterialPageRoute(
            builder: (_) => RegisterScreen(userRepository: userRepository));
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
      default:
        return null;
    }
  }
}
