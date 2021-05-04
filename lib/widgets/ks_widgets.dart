import 'package:flutter/material.dart';

Widget ksIconBtn({
  required IconData icon,
  double iconSize = 20.0,
  Color iconColor = Colors.blueGrey,
  VoidCallback? onTap,
}) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular((iconSize + 16.0) / 2),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          icon,
          //color: iconColor,
          size: iconSize,
        ),
      ),
    ),
  );
}

Widget sliverDivider({double? height}) {
  return SliverPadding(padding: EdgeInsets.only(bottom: height ?? 8.0));
}