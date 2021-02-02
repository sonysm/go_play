import 'package:flutter/material.dart';
import 'package:sport_booking/ui/screen/activities/create_activity_screen.dart';
import 'package:sport_booking/ui/screen/auth/login_screen.dart';
import 'package:sport_booking/ui/screen/booking/booking_screen.dart';
import 'package:sport_booking/ui/screen/dashboard/venue_detail_screen.dart';
import 'package:sport_booking/ui/screen/dashboard/venue_list_screen.dart';
import 'package:sport_booking/ui/screen/main_tabbar.dart';
import 'package:sport_booking/ui/screen/news/news_detail_screen.dart';
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
      case '/venue-detail':
        return MaterialPageRoute(
          builder: (_) => VenueDetailScreen(args),
        );
      case '/book':
        return MaterialPageRoute(
          builder: (_) => BookingScreen(),
        );
      case '/create-activity':
        return MaterialPageRoute(
          builder: (_) => CreateActivityScreen(),
        );

      case '/login':
        return MaterialPageRoute(
          builder: (_) => LoginScreen(),
        );
      case '/news-detail':
        return MaterialPageRoute(
          builder: (_) => NewDetailScreen(args),
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
