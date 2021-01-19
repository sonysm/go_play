import 'package:flutter/material.dart';
import 'package:sport_booking/ui/screen/auth/login_screen.dart';
import 'package:sport_booking/ui/screen/dashboard/venue_list_screen.dart';
import 'package:sport_booking/ui/screen/main_tabbar.dart';
import 'package:sport_booking/ui/screen/splash_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => SplashScreen(),
        );
      case '/home':
        return MaterialPageRoute(
          builder: (_) => MainTabbar(),
        );

      case '/venue-list':
        return MaterialPageRoute(
          builder: (_) => VenueListScreen(),
        );

      case '/login':
        return MaterialPageRoute(
          builder: (_) => LoginScreen(),
        );

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
