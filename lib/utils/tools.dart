import 'package:flutter/material.dart';
import 'package:kroma_sport/ks.dart';

launchScreen(context, String tag, {Object? arguments}) {
  if (arguments == null) {
    return Navigator.pushNamed(context, tag);
  } else {
    return Navigator.pushNamed(context, tag, arguments: arguments);
  }
}

dismissScreen(BuildContext context, [dynamic result]) {
  Navigator.pop(context, result);
}

bool isMe(int userId) {
  if (userId == KS.shared.user.id) return true;
  return false;
}
