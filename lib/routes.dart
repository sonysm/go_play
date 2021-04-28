import 'package:flutter/material.dart';
import 'package:kroma_sport/views/tabs/account/account_screen.dart';
import 'package:kroma_sport/views/tabs/activity/activity_screen.dart';
import 'package:kroma_sport/views/tabs/home/feed_detail_screen.dart';
import 'package:kroma_sport/views/tabs/home/home_screen.dart';
import 'package:kroma_sport/views/tabs/notification/notifitcation_screen.dart';

class RouteGenerator {
  static Map<String, Widget Function(BuildContext)> getAllRoutes = {
    HomeScreen.tag: (context) => HomeScreen(),
    ActivityScreen.tag: (context) => ActivityScreen(),
    NotificationScreen.tag: (context) => NotificationScreen(),
    AccountScreen.tag: (context) => AccountScreen(),
    FeedDetailScreen.tag: (context) => FeedDetailScreen(),
  };
}
