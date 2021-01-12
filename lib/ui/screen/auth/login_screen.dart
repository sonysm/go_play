/*
 * File: login_screen.dart
 * Project: auth
 * -----
 * Created Date: Friday January 8th 2021
 * Author: Sony Sum
 * -----
 * Copyright (c) 2021 ERROR-DEV All rights reserved.
 */
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sport_booking/ui/components/apple_signin_button.dart';
import 'package:sport_booking/ui/components/facebook_signin_button.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Widget privacyPolicyLinkAndTermsOfService() {
    return Container(
      width: 320,
      alignment: Alignment.center,
      padding: EdgeInsets.all(10),
      child: Center(
          child: Text.rich(TextSpan(
              text: 'By continuing, you agree to our ',
              style: TextStyle(fontSize: 12),
              children: <TextSpan>[
            TextSpan(
                text: 'Terms of Service',
                style: TextStyle(
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    // code to open / launch terms of service link here
                  }),
            TextSpan(
                text: ' and ',
                style: TextStyle(fontSize: 12),
                children: <TextSpan>[
                  TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(
                          fontSize: 14, decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // code to open / launch privacy policy link here
                        })
                ])
          ]))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: double.infinity,
          width: double.infinity,
          padding: EdgeInsets.all(32.0),
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/login_background.jpg'))),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  child: Row(
                    children: [
                      Expanded(child: Divider(color: Colors.white)),
                      Text(' Sign in with '),
                      Expanded(child: Divider(color: Colors.white)),
                    ],
                  ),
                ),
                SizedBox(height: 32.0),
                Container(
                  child: SignInWithFBButton(
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(
                          context, '/home', (route) => false)),
                ),
                SizedBox(height: 16.0),
                Container(
                  child: SignInWithAppleButton(
                    style: SignInWithAppleButtonStyle.white,
                    onPressed: () {},
                  ),
                ),
                SizedBox(height: 16.0),
                privacyPolicyLinkAndTermsOfService(),
                SizedBox(height: 32.0),
              ],
            ),
          )),
    );
  }
}
