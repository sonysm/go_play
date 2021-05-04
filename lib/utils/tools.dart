import 'package:flutter/material.dart';

launchScreen(context, String tag, {Object? arguments}) {
  if (arguments == null) {
    Navigator.pushNamed(context, tag);
  } else {
    Navigator.pushNamed(context, tag, arguments: arguments);
  }
}

dismissScreen(context) {
  Navigator.pop(context);
}