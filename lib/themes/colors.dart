import 'package:flutter/material.dart';
import 'package:kroma_sport/utils/tools.dart';

const mainColor = Color(0xFF26a65b);
const mainDarkColor = Colors.greenAccent;

const primaryColor = Colors.white;
const primaryDarkColor = Color(0xFF536872);

const backgroundPrimary = Color(0xFFF1F2F6);
const backgroundDarkPrimary = Color(0xFF36454f);

const darkColor = Color(0xFF6F6F6F);

const whiteColor = Colors.white;
const blackColor = Colors.black;
const greyColor = Color(0xFFF1F2F6);
const textColorPrimary = Color(0xFF333333);
const textColorSecondary = Color(0xFF949292);
const appBackgroundColor = Color(0xFFf8f8f8);

class ColorResources {
  static Color getPrimary(BuildContext context) {
    return isLight(context) ? Color(0xFFFFFFFF) : Color(0xFF536872);
  }

  static Color getMainColor(BuildContext context) {
    return isLight(context) ? Color(0xFF26a65b) : Colors.greenAccent;
  }

  static Color getPrimaryText(BuildContext context) {
    return isLight(context) ? Color(0xFF000000) : Color(0xFFFFFFFF);
  }

  static Color getSecondaryText(BuildContext context) {
    return isLight(context) ? Color(0xFF78909C) : Color(0xFFCFD8DC);
  }

  static Color getPrimaryIconColor(BuildContext context) {
    return isLight(context) ? mainColor : Colors.greenAccent;
  }

  static Color getPrimaryIconColorDark(BuildContext context) {
    return isLight(context) ? darkColor : whiteColor;
  }

  static Color getSecondaryIconColor(BuildContext context) {
    return isLight(context) ? Colors.black87 : Colors.white;
  }

  static Color getBlueGrey(BuildContext context) {
    return isLight(context) ? Color(0xFF90A4AE) : Color(0xFFCFD8DC);
  }

  static Color getActiveIconColor(BuildContext context) {
    return isLight(context) ? Colors.green : Colors.greenAccent;
  }

  static Color getInactiveIconColor(BuildContext context) {
    return isLight(context) ? Colors.blueGrey : Colors.white;
  }

  static Color getSuggestionBorderColor(BuildContext context) {
    return isLight(context) ? Color(0xFFD6D6D6) : Color(0xFF90A4AE);
  }

  static Color getOverlayIconColor(BuildContext context) {
    return isLight(context) ? Color(0xFFEEEEEE) : Color(0xFF90A4AE);
  }
}
