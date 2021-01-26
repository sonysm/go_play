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
import 'package:sport_booking/theme/color.dart';

ThemeData darkTheme() => ThemeData.dark().copyWith(
      // visualDensity: VisualDensity.adaptivePlatformDensity,
      buttonColor: mainColor,
      // iconTheme: IconThemeData(color: mainColor),

      appBarTheme: AppBarTheme(iconTheme: IconThemeData(color: mainColor)),
      buttonTheme: ButtonThemeData(buttonColor: mainColor),

      cupertinoOverrideTheme: CupertinoThemeData(
          primaryContrastingColor: mainColor,
          primaryColor: mainColor,
          textTheme:
              CupertinoTextThemeData(textStyle: TextStyle(color: whiteColor))),
    );

ThemeData lightTheme() => ThemeData.light().copyWith(
      // visualDensity: VisualDensity.adaptivePlatformDensity,
      buttonColor: Colors.green,
      buttonTheme: ButtonThemeData(buttonColor: Colors.green),
      cupertinoOverrideTheme: CupertinoThemeData(primaryColor: whiteColor),
    );
