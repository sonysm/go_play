/*
 * File: apple_signin_button.dart
 * Project: components
 * -----
 * Created Date: Monday January 11th 2021
 * Author: Sony Sum
 * -----
 * Copyright (c) 2021 ERROR-DEV All rights reserved.
 */
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sport_booking/theme/color.dart';

/// The scale based on the height of the button
const _appleIconSizeScale = 28 / 44;

/// A `Sign in with Apple` button according to the Apple Guidelines.
///
/// https://developer.apple.com/design/human-interface-guidelines/sign-in-with-apple/overview/buttons/
class SignInWithFBButton extends StatelessWidget {
  const SignInWithFBButton({
    Key key,
    @required this.onPressed,
    this.text = ' Facebook ',
    this.height = 44,
    this.style = SignInWithFBButtonStyle.blue,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.iconAlignment = IconAlignment.center,
  })  : assert(text != null),
        assert(height != null),
        assert(style != null),
        assert(borderRadius != null),
        assert(iconAlignment != null),
        super(key: key);

  /// The callback that is be called when the button is pressed.
  final VoidCallback onPressed;

  /// The text to display next to the Apple logo.
  ///
  /// Defaults to `Sign in with Apple`.
  final String text;

  /// The height of the button.
  ///
  /// This defaults to `44` according to Apple's guidelines.
  final double height;

  /// The style of the button.
  ///
  /// Supported options are in line with Apple's guidelines.
  ///
  /// This defaults to [SignInWithAppleButtonStyle.black].
  final SignInWithFBButtonStyle style;

  /// The border radius of the button.
  ///
  /// Defaults to `8` pixels.
  final BorderRadius borderRadius;

  /// The alignment of the Apple logo inside the button.
  ///
  /// This defaults to [IconAlignment.center].
  final IconAlignment iconAlignment;

  /// Returns the background color of the button based on the current [style].
  Color get _backgroundColor {
    switch (style) {
      case SignInWithFBButtonStyle.blue:
        return facebookColor;
      case SignInWithFBButtonStyle.white:
      case SignInWithFBButtonStyle.whiteOutlined:
        return Colors.white;
    }

    assert(false, 'Unknown style: $style');
    return null;
  }

  /// Returns the contrast color to the [_backgroundColor] derived from the current [style].
  ///
  /// This is used for the text and logo color.
  Color get _contrastColor {
    switch (style) {
      case SignInWithFBButtonStyle.blue:
        return Colors.white;
      case SignInWithFBButtonStyle.white:
      case SignInWithFBButtonStyle.whiteOutlined:
        return Colors.black;
    }

    assert(false, 'Unknown style: $style');
    return null;
  }

  /// The decoration which should be applied to the inner container inside the button
  ///
  /// This allows to customize the border of the button
  Decoration get _decoration {
    switch (style) {
      case SignInWithFBButtonStyle.blue:
      case SignInWithFBButtonStyle.white:
        return null;

      case SignInWithFBButtonStyle.whiteOutlined:
        return BoxDecoration(
          border: Border.all(width: 1, color: _contrastColor),
          borderRadius: borderRadius,
        );
    }

    assert(false, 'Unknown style: $style');
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // per Apple's guidelines
    final fontSize = height * 0.43;

    final textWidget = Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        inherit: false,
        fontSize: fontSize,
        color: _contrastColor,
        // defaults styles aligned with https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/cupertino/text_theme.dart#L16
        fontFamily: '.SF Pro Text',
        letterSpacing: -0.41,
      ),
    );

    final facebookIcon = Container(
      width: _appleIconSizeScale * height,
      height: _appleIconSizeScale * height + 2,
      padding: EdgeInsets.only(
        // Properly aligns the Apple icon with the text of the button
        bottom: (4 / 44) * height,
      ),
      child: Center(
        child: Container(
          width: fontSize * (25 / 31),
          height: fontSize,
          child: Icon(FontAwesomeIcons.facebookF),
        ),
      ),
    );

    var children = <Widget>[];

    switch (iconAlignment) {
      case IconAlignment.center:
        children = [
          facebookIcon,
          Flexible(
            child: textWidget,
          ),
        ];
        break;
      case IconAlignment.left:
        children = [
          facebookIcon,
          Expanded(
            child: textWidget,
          ),
          SizedBox(
            width: _appleIconSizeScale * height,
          ),
        ];
        break;
    }

    return Container(
      height: height,
      child: SizedBox.expand(
        child: CupertinoButton(
          borderRadius: borderRadius,
          padding: EdgeInsets.zero,
          color: _backgroundColor,
          child: Container(
            decoration: _decoration,
            padding: EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            height: height,
            child: Row(
              children: children,
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}

/// The style of the button according to Apple's documentation.
///
/// https://developer.apple.com/design/human-interface-guidelines/sign-in-with-apple/overview/buttons/
enum SignInWithFBButtonStyle {
  /// A black button with white text and white icon
  ///
  /// ![Black Button](https://raw.githubusercontent.com/aboutyou/dart_packages/master/packages/sign_in_with_apple/test/sign_in_with_apple_button/goldens/black_button.png)
  blue,

  /// A white button with black text and black icon
  ///
  /// ![White Button](https://raw.githubusercontent.com/aboutyou/dart_packages/master/packages/sign_in_with_apple/test/sign_in_with_apple_button/goldens/white_button.png)
  white,

  /// A white button which has a black outline
  ///
  /// ![White Outline Button](https://raw.githubusercontent.com/aboutyou/dart_packages/master/packages/sign_in_with_apple/test/sign_in_with_apple_button/goldens/white_outlined_button.png)
  whiteOutlined,
}

/// This controls the alignment of the Apple Logo on the [SignInWithFBButton]
enum IconAlignment {
  /// The icon will be centered together with the text
  ///
  /// ![Center Icon Alignment](https://raw.githubusercontent.com/aboutyou/dart_packages/master/packages/sign_in_with_apple/test/sign_in_with_apple_button/goldens/center_aligned_icon.png)
  center,

  /// The icon will be on the left side, while the text will be centered accordingly
  ///
  /// ![Left Icon Alignment](https://raw.githubusercontent.com/aboutyou/dart_packages/master/packages/sign_in_with_apple/test/sign_in_with_apple_button/goldens/left_aligned_icon.png)
  left,
}
