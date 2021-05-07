import 'package:flutter/material.dart';

Widget sliverDivider({double? height}) {
  return SliverPadding(padding: EdgeInsets.only(bottom: height ?? 8.0));
}