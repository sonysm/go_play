import 'package:flutter/material.dart';
import 'package:kroma_sport/utils/tools.dart';

Widget sliverDivider(BuildContext context, {double? height, Color? color}) {
  return SliverToBoxAdapter(
    child: Container(
      height: height ?? 8.0,
      color: color ?? Theme.of(context).scaffoldBackgroundColor,
    ),
  );
}

Widget bottomSheetBar(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: 40.0,
        height: 5.0,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: isLight(context) ? Colors.grey[300] : Colors.grey[50],
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    ],
  );
}
