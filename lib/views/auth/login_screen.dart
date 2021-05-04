import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/ks_images.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/auth/verify_code_screen.dart';
import 'package:kroma_sport/widgets/ks_round_button.dart';

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

  Widget phoneTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.0),
            border:
                Border.all(width: 0.5, color: Colors.black.withOpacity(0.2)),
          ),
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Theme(
            data: ThemeData(
              canvasColor: Theme.of(context).primaryColor,
              textTheme: Theme.of(context).textTheme,
            ),
            child: InternationalPhoneNumberInput(
              textStyle: Theme.of(context)
                  .textTheme
                  .bodyText2
                  ?.copyWith(color: blackColor),
              selectorTextStyle: Theme.of(context)
                  .textTheme
                  .bodyText2
                  ?.copyWith(color: blackColor),
              inputDecoration: InputDecoration(
                hintText: 'Phone number',
                hintStyle: Theme.of(context)
                    .textTheme
                    .bodyText2
                    ?.copyWith(color: Colors.grey),
                border: InputBorder.none,
              ),
              searchBoxDecoration: InputDecoration(
                labelStyle: Theme.of(context).textTheme.bodyText2,
                hintStyle: Theme.of(context).textTheme.bodyText2,
                hintText: 'Search by country name or dial code',
              ),
              selectorConfig: SelectorConfig(
                setSelectorButtonAsPrefixIcon: true,
                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                leadingPadding: 8.0,
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
                margin: EdgeInsets.only(top: 4.0),
                child: Text(
                  'Invalid phone number!',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.red,
                  ),
                ),
              )
            : SizedBox()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Opacity(
              opacity: 0.9,
              child: Image.asset(
                loginBackground,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  70.height,
                  phoneTextField(),
                  8.height,
                  KsRoundButton(
                    title: 'Login',
                    onPressed: () => onLogin(),
                    backgroundColor: mainColor,
                  ),
                ],
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
