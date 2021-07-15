import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kroma_sport/bloc/splash.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/views/auth/login_screen.dart';
import 'package:kroma_sport/views/main.dart';
import 'package:package_info/package_info.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Widget splashText() {
    return Text(
      'VPlay',
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 28.0,
          color: whiteColor,
          fontWeight: FontWeight.w700,
          fontFamily: 'ProximaNova'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit()..init(),
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state == SplashState.Exist) {
            Navigator.pushNamedAndRemoveUntil(
                context, MainView.tag, (route) => false);
          } else if (state == SplashState.New) {
            navigateToLoginScreen();
          }
        },
        child: Scaffold(
          backgroundColor: whiteColor,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  mainColor,
                  Color(0xFF3cba92),
                  Color(0xFF1ba39c),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Stack(
              children: [
                Center(child: splashText()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  navigateToLoginScreen() {
    return Timer(Duration(milliseconds: 1500),
        () => Navigator.pushReplacementNamed(context, LoginScreen.tag));
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    KS.shared.packageInfo = info;
  }
}
