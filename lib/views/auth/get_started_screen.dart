import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kroma_sport/routes.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/ks_images.dart';
import 'package:kroma_sport/views/auth/login_screen.dart';
import 'package:kroma_sport/views/auth/walkthrough_screen.dart';

class GetStartedScreen extends StatelessWidget {
  static const tag = '/getStarted';
  const GetStartedScreen({Key? key}) : super(key: key);

  Widget headerText() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 42.0, child: Image.asset(imgVplayText)),
          8.height,
          Text(
            'Welcome to sport community!',
            style: TextStyle(
              color: whiteColor,
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          4.height,
          Text(
            'Meet people, find the sport to play and a venue to play at.',
            style: TextStyle(
              color: whiteColor,
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Image.asset(
          //   loginBackground,
          //   fit: BoxFit.cover,
          // ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black,
              image: new DecorationImage(
                fit: BoxFit.cover,
                colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.8), BlendMode.dstATop),
                image: AssetImage(loginBackground),
              ),
            ),
          ),
          // Positioned(
          //   top: -210.0,
          //   left: -250.0,
          //   child: Container(
          //     decoration: BoxDecoration(
          //       // color: Colors.black.withOpacity(0.2),
          //       shape: BoxShape.circle,
          //       gradient: LinearGradient(
          //         colors: [
          //           Colors.black,
          //           Color(0x00000000),
          //         ],
          //         begin: Alignment.centerLeft,
          //         end: Alignment.centerRight,
          //       ),
          //     ),
          //     width: 600.0,
          //     height: 600.0,
          //   ),
          // ),
          Positioned(
            top: 100.0,
            left: 24.0,
            right: 24.0,
            child: headerText(),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(bottom: 24.0, top: 70.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black,
                    Color(0x00000000),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Column(
                children: [
                  // Image.asset(
                  //   imgVplayText,
                  //   width: 100.0,
                  // ),
                  // Text(
                  //   'Your Sports Community App',
                  //   style: TextStyle(
                  //     fontSize: 16.0,
                  //     color: whiteColor,
                  //     fontWeight: FontWeight.w500,
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0, bottom: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, KSSlidePageRoute(builder: (_) => WalkThroughScreen()));
                      },
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        minimumSize: MaterialStateProperty.all(Size(250, 0)),
                        foregroundColor: MaterialStateProperty.all(whiteColor),
                        backgroundColor: MaterialStateProperty.all(mainColor),
                        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                      ),
                      child: Text(
                        'Let\'s get started',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          color: whiteColor,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, KSSlidePageRoute(builder: (_) => LoginScreen(isLogin: true)));
                    },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0)),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: MaterialStateProperty.all(Size(0, 0)),
                      overlayColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.5)),
                    ),
                    child: RichText(
                      text: TextSpan(
                        text: 'Already has account? ',
                        children: [
                          TextSpan(
                            text: 'Login',
                            style: TextStyle(color: mainColor, decoration: TextDecoration.underline),
                          ),
                        ],
                        style: TextStyle(
                          fontFamily: 'Aeonik',
                          fontWeight: FontWeight.w500,
                          color: whiteColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
