import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sport_booking/services/route.dart';
import 'package:sport_booking/theme/app_theme.dart';
import 'package:sport_booking/theme/color.dart';

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
