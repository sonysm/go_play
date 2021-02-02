/*
 * File: phone_signin_button.dart
 * Project: components
 * -----
 * Created Date: Wednesday January 27th 2021
 * Author: Sony Sum
 * -----
 * Copyright (c) 2021 ERROR-DEV All rights reserved.
 */
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

/// The scale based on the height of the button
const _appleIconSizeScale = 28 / 44;

/// A `Sign in with Apple` button according to the Apple Guidelines.
///
/// https://developer.apple.com/design/human-interface-guidelines/sign-in-with-apple/overview/buttons/
class SignInWithPhoneButton extends StatelessWidget {
  const SignInWithPhoneButton({
    Key key,
    @required this.onPressed,
    this.text = 'Sign in with Phone',
    this.height = 44,
    this.style = SignInWithPhoneButtonStyle.black,
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
  final SignInWithPhoneButtonStyle style;

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
      case SignInWithPhoneButtonStyle.black:
        return Colors.black;
      case SignInWithPhoneButtonStyle.white:
      case SignInWithPhoneButtonStyle.whiteOutlined:
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
      case SignInWithPhoneButtonStyle.black:
        return Colors.white;
      case SignInWithPhoneButtonStyle.white:
      case SignInWithPhoneButtonStyle.whiteOutlined:
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
      case SignInWithPhoneButtonStyle.black:
      case SignInWithPhoneButtonStyle.white:
        return null;

      case SignInWithPhoneButtonStyle.whiteOutlined:
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
    final fontSize = height * 0.40;

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

    final appleIcon = Container(
      width: _appleIconSizeScale * height,
      height: _appleIconSizeScale * height + 2,
      padding: EdgeInsets.only(
        // Properly aligns the Apple icon with the text of the button
        bottom: (4 / 44) * height,
        right: 8,
      ),
      child: Center(
        child: Container(
          width: fontSize * (25 / 31),
          height: fontSize,
          child: Icon(LineAwesomeIcons.mobile_phone, color: Colors.black),
        ),
      ),
    );

    var children = <Widget>[];

    switch (iconAlignment) {
      case IconAlignment.center:
        children = [
          appleIcon,
          Flexible(
            child: textWidget,
          ),
        ];
        break;
      case IconAlignment.left:
        children = [
          appleIcon,
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
enum SignInWithPhoneButtonStyle {
  /// A black button with white text and white icon
  ///
  /// ![Black Button](https://raw.githubusercontent.com/aboutyou/dart_packages/master/packages/sign_in_with_apple/test/sign_in_with_apple_button/goldens/black_button.png)
  black,

  /// A white button with black text and black icon
  ///
  /// ![White Button](https://raw.githubusercontent.com/aboutyou/dart_packages/master/packages/sign_in_with_apple/test/sign_in_with_apple_button/goldens/white_button.png)
  white,

  /// A white button which has a black outline
  ///
  /// ![White Outline Button](https://raw.githubusercontent.com/aboutyou/dart_packages/master/packages/sign_in_with_apple/test/sign_in_with_apple_button/goldens/white_outlined_button.png)
  whiteOutlined,
}

/// This controls the alignment of the Apple Logo on the [SignInWithPhoneButton]
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

/// A custom painter which draws Apple's logo inside its boundaries.
class AppleLogoPainter extends CustomPainter {
  /// Creates an Apple Logo Painter with the provided [color]
  const AppleLogoPainter({
    @required this.color,
  }) : assert(color != null);

  /// The [Color] of the logo
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    canvas.drawPath(_getApplePath(size.width, size.height), paint);
  }

  static Path _getApplePath(double w, double h) {
    return Path()
      ..moveTo(w * .50779, h * .28732)
      ..cubicTo(
          w * .4593, h * .28732, w * .38424, h * .24241, w * .30519, h * .24404)
      ..cubicTo(
          w * .2009, h * .24512, w * .10525, h * .29328, w * .05145, h * .36957)
      ..cubicTo(w * -.05683, h * .5227, w * .02355, h * .74888, w * .12916,
          h * .87333)
      ..cubicTo(w * .18097, h * .93394, w * .24209, h * 1.00211, w * .32313,
          h * .99995)
      ..cubicTo(w * .40084, h * .99724, w * .43007, h * .95883, w * .52439,
          h * .95883)
      ..cubicTo(w * .61805, h * .95883, w * .64462, h * .99995, w * .72699,
          h * .99833)
      ..cubicTo(
          w * .81069, h * .99724, w * .86383, h * .93664, w * .91498, h * .8755)
      ..cubicTo(
          w * .97409, h * .80515, w * .99867, h * .73698, w * 1, h * .73319)
      ..cubicTo(w * .99801, h * .73265, w * .83726, h * .68233, w * .83526,
          h * .53082)
      ..cubicTo(
          w * .83394, h * .4042, w * .96214, h * .3436, w * .96812, h * .34089)
      ..cubicTo(
          w * .89505, h * .25378, w * .78279, h * .24404, w * .7436, h * .24187)
      ..cubicTo(
          w * .6413, h * .23538, w * .55561, h * .28732, w * .50779, h * .28732)
      ..close()
      ..moveTo(w * .68049, h * .15962)
      ..cubicTo(w * .72367, h * .11742, w * .75223, h * .05844, w * .74426, 0)
      ..cubicTo(w * .68249, h * .00216, w * .60809, h * .03355, w * .56359,
          h * .07575)
      ..cubicTo(w * .52373, h * .11309, w * .48919, h * .17315, w * .49849,
          h * .23051)
      ..cubicTo(w * .56691, h * .23484, w * .63732, h * .20183, w * .68049,
          h * .15962)
      ..close();
  }

  @override
  bool shouldRepaint(AppleLogoPainter oldDelegate) =>
      oldDelegate.color != color;
}
