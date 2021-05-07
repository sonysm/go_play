import 'package:flutter/material.dart';

class KSIconButton extends StatelessWidget {
  const KSIconButton({
    Key? key,
    required this.icon,
    this.iconSize = 20.0,
    this.onTap,
  }) : super(key: key);

  final IconData icon;
  final double iconSize;
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
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.blueGrey
                : Colors.white,
            size: iconSize,
          ),
        ),
      ),
    );
  }
}
