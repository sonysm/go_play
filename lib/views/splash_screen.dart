import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kroma_sport/bloc/splash_cubit/splash_cubit.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/views/auth/login_screen.dart';
import 'package:kroma_sport/views/main.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Widget splashText() {
    return Text(
      'Kroma Sport',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 28.0,
        color: mainColor,
        fontWeight: FontWeight.w700,
      ),
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
          body: Stack(
            children: [
              Center(child: splashText()),
            ],
          ),
        ),
      ),
    );
  }

  navigateToLoginScreen() {
    return Timer(Duration(milliseconds: 1500),
        () => Navigator.pushReplacementNamed(context, LoginScreen.tag));
  }
}