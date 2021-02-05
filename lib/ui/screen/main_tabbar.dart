/*
 * File: main_tabbar.dart
 * Project: screen
 * -----
 * Created Date: Monday January 11th 2021
 * Author: Sony Sum
 * -----
 * Copyright (c) 2021 ERROR-DEV All rights reserved.
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:sport_booking/services/ksp.dart';
import 'package:sport_booking/ui/screen/activities/activity_screen.dart';
import 'package:sport_booking/ui/screen/dashboard/dashboard_screen.dart';
import 'package:sport_booking/ui/screen/news/news_screen.dart';
import 'package:sport_booking/ui/screen/notification/notification_screen.dart';
import 'package:sport_booking/ui/screen/profile/profile_screen.dart';

class MainTabbar extends StatefulWidget {
  @override
  _MainTabbarState createState() => _MainTabbarState();
}

class _MainTabbarState extends State<MainTabbar> {
  final _key = GlobalKey();

  int _currentIndex = 0;
  List<Widget> _screen = [
    ActivityScreen(),
    DashboardScreen(),
    NewsScreen(),
    NotificationScreen(),
    ProfileScreen()
  ];

  @override
  void initState() {
    KSP.shared.mainKey = _key;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.bottom, SystemUiOverlay.top]);
    return CupertinoTabScaffold(
      key: _key,
      tabBar: CupertinoTabBar(
        onTap: (idx) => setState(() {
          _currentIndex = idx;
        }),
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(LineAwesomeIcons.users)),
          BottomNavigationBarItem(
              icon: Icon(LineAwesomeIcons.alternate_ticket)),
          BottomNavigationBarItem(icon: Icon(LineAwesomeIcons.newspaper_1)),
          BottomNavigationBarItem(icon: Icon(LineAwesomeIcons.bell)),
          BottomNavigationBarItem(icon: Icon(LineAwesomeIcons.user))
        ],
      ),
      tabBuilder: (context, index) {
        return IndexedStack(index: _currentIndex, children: _screen);
      },
    );
  }
}
