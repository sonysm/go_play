import 'package:flutter/material.dart';

Widget sliverDivider(BuildContext context, {double? height, Color? color}) {
  return SliverToBoxAdapter(
    child: Container(
      height: height ?? 8.0,
      color: color ?? Theme.of(context).scaffoldBackgroundColor,
    ),
  );
}
