import 'package:flutter/material.dart';
import 'package:kroma_sport/themes/colors.dart';

class InputStyles {
  //get the border for the textform field
  static InputBorder inputUnderlineEnabledBorder() {
    return UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey));
  }

  static InputBorder inputUnderlineFocusBorder() {
    return UnderlineInputBorder(borderSide: BorderSide(color: mainColor));
  }
}
