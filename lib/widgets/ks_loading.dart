import 'package:flutter/material.dart';

class LoadingDialog extends StatefulWidget {
  final Color color;

  LoadingDialog({
    Key? key,
    required this.color,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => LoadingDialogState();
}

class LoadingDialogState extends State<LoadingDialog>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<double>? scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 350));
    scaleAnimation =
        CurvedAnimation(parent: controller!, curve: Curves.easeInOut);

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
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: ScaleTransition(
                scale: scaleAnimation!,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(widget.color),
                )),
          ),
        ),
      ),
    );
  }
}

void showKSLoading(BuildContext context, {Color color: Colors.greenAccent}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(.4),
    builder: (_) => LoadingDialog(color: color),
  );
}
