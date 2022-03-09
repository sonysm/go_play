import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kroma_sport/bloc/splash.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/ks_images.dart';
import 'package:kroma_sport/views/auth/get_started_screen.dart';
import 'package:kroma_sport/views/main.dart';
import 'package:package_info/package_info.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  Widget splashText() {
    return ScaleTransition(
      scale: _animationController,
      child: Opacity(
        opacity: (1.02 - (_animationController.value / 3)),
        child: SizedBox(
            height: 42.0,
            child: Image.asset(
              imgVplayText,
              color: mainColor,
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit()..init(),
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          _animationController.addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              if (state == SplashState.Exist) {
                Navigator.pushNamedAndRemoveUntil(
                    context, MainView.tag, (route) => false);
              } else if (state == SplashState.New) {
                navigateToLoginScreen();
              }
            }
          });
        },
        child: Scaffold(
          backgroundColor: whiteColor,
          body: Container(
            // decoration: BoxDecoration(
            //   gradient: LinearGradient(
            //     colors: [
            //       mainColor,
            //       Color(0xFF3cba92),
            //       Color(0xFF1ba39c),
            //     ],
            //     begin: Alignment.topCenter,
            //     end: Alignment.bottomCenter,
            //   ),
            // ),
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
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
      lowerBound: 1.0,
      upperBound: 3.0,
    );
    _animationController.forward();
    _animationController.addListener(() {
      setState(() {});
    });
    _initPackageInfo();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  navigateToLoginScreen() {
    // return Timer(Duration(milliseconds: 500), () => Navigator.pushReplacementNamed(context, GetStartedScreen.tag));
    return Timer(
        Duration(milliseconds: 1000),
        () => Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) {
                return GetStartedScreen();
              },
              transitionsBuilder: (context, animation1, animation2, child) {
                return FadeTransition(
                  opacity: animation1,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset.zero,
                      end: Offset(-1.0, 0.0),
                    ).animate(animation2),
                    child: child,
                  ),
                );
              },
              transitionDuration: Duration(milliseconds: 350),
            )));
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    KS.shared.packageInfo = info;
  }
}
