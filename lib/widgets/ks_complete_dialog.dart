import 'package:flutter/material.dart';

class CompleteDialog extends StatefulWidget {
  final Color color;
  final String message;

  CompleteDialog({
    Key? key,
    required this.color,
    required this.message,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => LoadingDialogState();
}

class LoadingDialogState extends State<CompleteDialog>
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
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  widget.message,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future showKSComplete(BuildContext context,
    {required String message, Color color: Colors.greenAccent}) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(.4),
    builder: (_) => CompleteDialog(
      color: color,
      message: message,
    ),
  );
}
