import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/app_size.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/ks_images.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/auth/register_screen.dart';
import 'package:kroma_sport/views/auth/verify_code_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String tag = '/loginScreen';
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  PhoneNumber number = PhoneNumber(isoCode: "KH", phoneNumber: '');

  bool isValid = false;
  bool showInvalidText = false;

  Widget headerText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   'VPlay',
        //   style: TextStyle(
        //     color: whiteColor,
        //     fontSize: 36.0,
        //     fontWeight: FontWeight.w700,
        //     fontFamily: 'ProximaNova',
        //   ),
        // ),
        SizedBox(height: 42.0, child: Image.asset(imgVplayText)),
        8.height,
        Text(
          'Welcome to sport community!',
          style: TextStyle(
            color: whiteColor,
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            fontFamily: 'Metropolis',
          ),
        ),
        4.height,
        Text(
          'Meet people, find the sport to play and a venue to play at.',
          style: TextStyle(
            color: whiteColor,
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            // fontFamily: 'Metropolis',
          ),
        ),
      ],
    );
  }

  Widget phoneTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: Theme(
            data: ThemeData(
                // canvasColor: Theme.of(context).primaryColor,
                // textTheme: Theme.of(context).textTheme,
                ),
            child: InternationalPhoneNumberInput(
              textStyle: Theme.of(context).textTheme.bodyText1?.copyWith(
                    color: whiteColor,
                    fontSize: 18.0,
                    fontFamily: 'ProximaNova',
                  ),
              selectorTextStyle:
                  Theme.of(context).textTheme.bodyText2?.copyWith(
                        color: whiteColor,
                        fontSize: 18.0,
                        fontFamily: 'ProximaNova',
                      ),
              inputDecoration: InputDecoration(
                  hintText: 'Phone number',
                  hintStyle: Theme.of(context).textTheme.bodyText1?.copyWith(
                        color: Colors.white70,
                        fontSize: 18,
                        fontFamily: 'ProximaNova',
                      ),
                  enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.white60, width: 1.5)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2.0))),
              searchBoxDecoration: InputDecoration(
                labelStyle: Theme.of(context).textTheme.bodyText2,
                hintStyle: Theme.of(context).textTheme.bodyText2,
                hintText: 'Search by country name or dial code',
              ),
              selectorConfig: SelectorConfig(
                setSelectorButtonAsPrefixIcon: true,
                trailingSpace: false,
                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                leadingPadding: 0.0,
              ),
              inputBorder: InputBorder.none,
              onInputChanged: (PhoneNumber numb) {
                number = numb;
              },
              hintText: 'Phone number',
              onInputValidated: (bool value) {
                showInvalidText = false;
                isValid = value;
              },
              initialValue: number,
            ),
          ),
        ),
        showInvalidText
            ? Container(
                margin: EdgeInsets.only(top: 8.0),
                child: Text(
                  'Invalid phone number!',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: blackColor,
                  ),
                ),
              )
            : SizedBox()
      ],
    );
  }

  Widget btnFacebookWidget() {
    return Container(
      height: 48.0,
      width: AppSize(context).appWidth(100.0) - 48,
      margin: EdgeInsets.only(top: 32.0, bottom: 16.0),
      child: ElevatedButton(
        onPressed: () {
          launchScreen(context, RegisterScreen.tag, arguments: '+85598333688');
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Color(0xFF4267B2)),
          elevation: MaterialStateProperty.all(0),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              // side: BorderSide(color: whiteColor),
            ),
          ),
        ),
        child: Row(
          children: <Widget>[
            8.width,
            SizedBox(
              height: 20.0,
              width: 20.0,
              child: Image.asset('assets/icons/ic_facebook_white.png'),
            ),
            Expanded(
              child: Text(
                'Facebook',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    color: whiteColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0,
                    fontFamily: 'ProximaNova'),
              ),
            ),
            28.width,
          ],
        ),
      ),
    );
  }

  Widget signupWithText() {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 34.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: 0.5,
              color: Colors.white70,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Or Login with',
              style: TextStyle(color: whiteColor),
            ),
          ),
          Expanded(
            child: Container(
              height: 0.5,
              color: Colors.white70,
            ),
          )
        ],
      ),
    );
  }

  Widget btnLoginWidget() {
    return Container(
      height: 48.0,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => onLogin(),
        style: ButtonStyle(
            elevation: MaterialStateProperty.all(0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            backgroundColor: MaterialStateProperty.all(whiteColor),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)))),
        child: Text(
          'Login',
          style: Theme.of(context).textTheme.bodyText1?.copyWith(
              color: mainColor,
              fontWeight: FontWeight.w600,
              fontFamily: 'ProximaNova'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Opacity(
            //   opacity: 0.9,
            //   child: Image.asset(
            //     loginBackground,
            //     fit: BoxFit.cover,
            //   ),
            // ),
            Container(
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
            ),
            Positioned(
              top: 100.0,
              left: 24.0,
              right: 24.0,
              child: headerText(),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  50.height,
                  phoneTextField(),
                  16.height,
                  btnLoginWidget(),
                  32.height,
                  // signupWithText(),
                  // btnFacebookWidget(),
                ],
              ),
            ),
            Positioned(
              bottom: 16.0,
              left: 24.0,
              right: 24.0,
              child: Text(
                'Copyrights 2021, Kroma Tec',
                style: TextStyle(color: whiteColor),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  onLogin() {
    if (isValid) {
      launchScreen(context, VerifyCodeScreen.tag,
          arguments: number.phoneNumber);
    } else {
      setState(() => showInvalidText = true);
    }
  }
}
