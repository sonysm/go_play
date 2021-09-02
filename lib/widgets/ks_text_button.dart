import 'package:flutter/material.dart';
import 'package:kroma_sport/utils/tools.dart';

class KSTextButtonBottomSheet extends StatelessWidget {
  final String title;
  final TextStyle? titleTextStyle;
  final double? height;
  final IconData? icon;
  final double? iconSize;
  final VoidCallback? onTab;

  const KSTextButtonBottomSheet({
    Key? key,
    required this.title,
    this.titleTextStyle,
    this.height = 54.0,
    this.icon,
    this.iconSize = 22.0,
    this.onTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(horizontal: 0.0),
        ),
        overlayColor: MaterialStateProperty.all(
            isLight(context) ? Colors.grey[100] : Colors.blueGrey[300]),
      ),
      onPressed: onTab,
      child: Container(
        height: height,
        child: Row(
          children: <Widget>[
            SizedBox(width: 16.0),
            if (icon != null)
              Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: Icon(
                  icon,
                  color: Theme.of(context).textTheme.bodyText1!.color,
                  size: iconSize,
                ),
              ),
            Text(
              title,
              style: titleTextStyle ?? Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
      ),
    );
  }
}
