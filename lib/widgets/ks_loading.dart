import 'package:flutter/material.dart';
import 'package:kroma_sport/themes/colors.dart';

class LoadingDialog extends StatefulWidget {
  final Color color;
  final String? message;

  LoadingDialog({
    Key? key,
    this.message,
    required this.color,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => LoadingDialogState();
}

class LoadingDialogState extends State<LoadingDialog> with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<double>? scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 350));
    scaleAnimation = CurvedAnimation(parent: controller!, curve: Curves.easeInOut);

    controller!.addListener(() {
      setState(() {});
    });

    controller!.forward();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.transparent,
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: scaleAnimation!,
                child: CircularProgressIndicator(
                  strokeWidth: 3.0,
                  valueColor: AlwaysStoppedAnimation<Color>(widget.color),
                ),
              ),
              if (widget.message != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    widget.message!,
                    style: TextStyle(color: whiteColor, fontSize: 16.0),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}

void showKSLoading(BuildContext context, {Color color: Colors.greenAccent, String? message}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(.4),
    builder: (_) => LoadingDialog(color: color, message: message),
  );
}
