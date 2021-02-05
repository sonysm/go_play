/*
 * File: app_theme.dart
 * Project: themes
 * -----
 * Created Date: Friday January 8th 2021
 * Author: Sony Sum
 * -----
 * Copyright (c) 2021 ERROR-DEV All rights reserved.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sport_booking/main.dart';
import 'package:sport_booking/theme/color.dart';

ThemeData darkTheme() {
  ThemeData defaultTheme = ThemeData.dark();
  return ThemeData.dark().copyWith(
    // visualDensity: VisualDensity.adaptivePlatformDensity,
    buttonColor: mainColor,
    textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'OpenSans'),
    appBarTheme: AppBarTheme(iconTheme: IconThemeData(color: mainColor)),
    buttonTheme: ButtonThemeData(buttonColor: mainColor),
    floatingActionButtonTheme: defaultTheme.floatingActionButtonTheme
        .copyWith(backgroundColor: mainColor, foregroundColor: whiteColor),
    cupertinoOverrideTheme: CupertinoThemeData(
        primaryContrastingColor: mainColor,
        primaryColor: mainColor,
        textTheme:
            CupertinoTextThemeData(textStyle: TextStyle(color: whiteColor))),
  );
}

ThemeData lightTheme() {
  ThemeData defaultTheme = ThemeData.light();

  return ThemeData.light().copyWith(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primaryColor: whiteColor,
    disabledColor: whiteColor,
    primaryColorDark: Colors.grey[200],
    primaryColorLight: Colors.pink,
    primaryIconTheme: defaultTheme.primaryIconTheme.copyWith(color: mainColor),
    accentIconTheme: defaultTheme.accentIconTheme.copyWith(color: mainColor),
    iconTheme: defaultTheme.iconTheme.copyWith(color: mainColor),
    appBarTheme: defaultTheme.appBarTheme.copyWith(
      centerTitle: false,
      iconTheme: IconThemeData(color: mainColor),
      textTheme: defaultTheme.primaryTextTheme.apply(bodyColor: mainColor),
    ),
    textTheme: ThemeData.light().textTheme.apply(fontFamily: 'OpenSans'),
    buttonTheme: ButtonThemeData(
      buttonColor: mainColor,
      colorScheme: defaultTheme.colorScheme.copyWith(secondary: Colors.white),
    ),
    floatingActionButtonTheme: defaultTheme.floatingActionButtonTheme
        .copyWith(backgroundColor: mainColor),
    cupertinoOverrideTheme: CupertinoThemeData(primaryColor: mainColor),
  );
}
