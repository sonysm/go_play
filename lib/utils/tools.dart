import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
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

Future<Size> calculateImageDimension(String url) {
    Completer<Size> completer = Completer();
    // Image image = Image.network("https://i.stack.imgur.com/lkd0a.png");
    CachedNetworkImageProvider(url).resolve(ImageConfiguration()).addListener(
      ImageStreamListener(
        (ImageInfo image, bool synchronousCall) {
          var myImage = image.image;
          Size size = Size(myImage.width.toDouble(), myImage.height.toDouble());
          completer.complete(size);
        },
      ),
    );
    return completer.future;
  }