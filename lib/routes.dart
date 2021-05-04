import 'package:flutter/material.dart';
import 'package:kroma_sport/views/auth/login_screen.dart';
import 'package:kroma_sport/views/auth/register_screen.dart';
import 'package:kroma_sport/views/auth/verify_code_screen.dart';
import 'package:kroma_sport/views/main.dart';
import 'package:kroma_sport/views/tabs/account/account_screen.dart';
import 'package:kroma_sport/views/tabs/account/setting/setting_screen.dart';
import 'package:kroma_sport/views/tabs/activity/activity_screen.dart';
import 'package:kroma_sport/views/tabs/home/create_post_screen.dart';
import 'package:kroma_sport/views/tabs/home/feed_detail_screen.dart';
import 'package:kroma_sport/views/tabs/home/home_screen.dart';
import 'package:kroma_sport/views/tabs/notification/notifitcation_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case LoginScreen.tag:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case RegisterScreen.tag:
        return MaterialPageRoute(
            builder: (_) => RegisterScreen(phoneNumber: args as String));
      case VerifyCodeScreen.tag:
        return MaterialPageRoute(
          builder: (_) => VerifyCodeScreen(phoneNumber: args as String),
        );
      case MainView.tag:
        return MaterialPageRoute(builder: (_) => MainView());
      case HomeScreen.tag:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case ActivityScreen.tag:
        return MaterialPageRoute(builder: (_) => ActivityScreen());
      case NotificationScreen.tag:
        return MaterialPageRoute(builder: (_) => NotificationScreen());
      case AccountScreen.tag:
        return MaterialPageRoute(builder: (_) => AccountScreen());
      case FeedDetailScreen.tag:
        return MaterialPageRoute(builder: (_) => FeedDetailScreen());
      case CreatPostScreen.tag:
        return MaterialPageRoute(builder: (_) => CreatPostScreen());
      case SettingScreen.tag:
        return MaterialPageRoute(builder: (_) => SettingScreen());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('No View'),
        ),
        body: Center(
          child: Text('No data'),
        ),
      );
    });
  }
}