import 'package:flutter/material.dart';
import 'package:kroma_sport/themes/colors.dart';

class KsRoundButton extends StatelessWidget {
  final double width;
  final double height;
  final String title;
  final Color titleColor;
  final Color backgroundColor;
  final Color? borderColor;
  final VoidCallback? onPressed;

  const KsRoundButton({
    Key? key,
    this.width = double.infinity,
    this.height = 44.0,
    required this.title,
    this.titleColor = whiteColor,
    this.backgroundColor = Colors.transparent,
    this.borderColor,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(0),
          foregroundColor: MaterialStateProperty.all(titleColor),
          backgroundColor: MaterialStateProperty.all(backgroundColor),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(height / 2),
              side: borderColor != null
                  ? BorderSide(color: borderColor!)
                  : BorderSide.none,
            ),
          ),
        ),
        child: Text(
          title,
          style: Theme.of(context).textTheme.bodyText2?.copyWith(
                color: titleColor,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }
}
