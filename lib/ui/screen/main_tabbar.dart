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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class MainTabbar extends StatefulWidget {
  @override
  _MainTabbarState createState() => _MainTabbarState();
}

class _MainTabbarState extends State<MainTabbar> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return Scaffold(
      bottomNavigationBar: CupertinoTabBar(items: [
        BottomNavigationBarItem(
            // label: 'Home',
            icon: Icon(LineAwesomeIcons.home)),
        BottomNavigationBarItem(icon: Icon(LineAwesomeIcons.newspaper_o)),
        BottomNavigationBarItem(icon: Icon(LineAwesomeIcons.bell)),
        BottomNavigationBarItem(icon: Icon(LineAwesomeIcons.cog))
      ]),
    );
  }
}
