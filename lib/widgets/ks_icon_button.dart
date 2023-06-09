import 'package:flutter/material.dart';
import 'package:kroma_sport/themes/colors.dart';

class KSIconButton extends StatelessWidget {
  const KSIconButton({
    Key? key,
    required this.icon,
    this.iconSize = 20.0,
    this.iconColor,
    this.onTap,
  }) : super(key: key);

  final IconData icon;
  final double iconSize;
  final Color? iconColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular((iconSize + 16.0) / 2),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            icon,
            color: iconColor != null
                ? iconColor
                : ColorResources.getSecondaryIconColor(context),
            size: iconSize,
          ),
        ),
      ),
    );
  }
}
