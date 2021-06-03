import 'package:flutter/material.dart';
import 'package:kroma_sport/utils/tools.dart';

class KSTextButtonBottomSheet extends StatelessWidget {
  final String title;
  final IconData? icon;
  final VoidCallback? onTab;

  const KSTextButtonBottomSheet({
    Key? key,
    required this.title,
    this.icon,
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
        height: 54.0,
        child: Row(
          children: <Widget>[
            SizedBox(width: 16.0),
            icon != null
                ? Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: Icon(
                      icon,
                      color: isLight(context) ? Colors.blueGrey : Colors.white,
                    ),
                  )
                : SizedBox(),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyText1,
            )
          ],
        ),
      ),
    );
  }
}
