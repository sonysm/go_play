/*
 * File: login_screen.dart
 * Project: auth
 * -----
 * Created Date: Friday January 8th 2021
 * Author: Sony Sum
 * -----
 * Copyright (c) 2021 ERROR-DEV All rights reserved.
 */
import 'package:firebase_phone_verify_ui/enum.dart';
import 'package:firebase_phone_verify_ui/firebase_phone_verify_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_booking/bloc/auth/auth_bloc.dart';
import 'package:sport_booking/ui/components/facebook_signin_button.dart';
import 'package:sport_booking/ui/components/phone_signin_button.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebasePhoneVerifyUi _verifyUi = FirebasePhoneVerifyUi();
  final _authBloc = AuthBloc();

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
      body: BlocProvider(
        create: (context) => _authBloc,
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthLoadingState) {
            } else if (state is AuthDidLoginState) {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/home', (route) => false);
            }
          },
          builder: (context, state) {
            return Container(
                height: double.infinity,
                width: double.infinity,
                padding: EdgeInsets.all(32.0),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image:
                            AssetImage('assets/images/login_background.jpg'))),
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
                        child: SignInWithPhoneButton(
                          style: SignInWithPhoneButtonStyle.white,
                          onPressed: () async {
                            // _authBloc.add(AuthLoginEvent());
                            // var result = await _verifyUi.loginWithPhone(context);
                            // if (result == FirebaseVerifyResult.verifySuccess) {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/home', (route) => false);
                            // }
                          },
                        ),
                      ),
                      SizedBox(height: 24.0),
                      Container(
                        child: SignInWithFBButton(onPressed: () {
                          // _authBloc.add(AuthLoginEvent());
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/home', (route) => false);
                        }),
                      ),
                      SizedBox(height: 64.0),
                      privacyPolicyLinkAndTermsOfService(),
                      SizedBox(height: 32.0),
                    ],
                  ),
                ));
          },
        ),
      ),
    );
  }
}
