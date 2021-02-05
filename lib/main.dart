import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sport_booking/services/ksp.dart';
import 'package:sport_booking/services/route.dart';
import 'package:sport_booking/theme/app_theme.dart';

void main() {
  // SystemChrome.setSystemUIOverlayStyle(
  //   SystemUiOverlayStyle(
  //     statusBarColor: Colors.transparent,
  //     systemNavigationBarColor: blackColor,
  //     systemNavigationBarDividerColor: Colors.transparent,
  //     // statusBarBrightness: Brightness.dark,
  //     // statusBarIconBrightness: Brightness.dark,
  //     // systemNavigationBarIconBrightness: Brightness.dark,
  //   ),
  // );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme(),
      darkTheme: darkTheme(),
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
