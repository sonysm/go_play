/*
 * File: pk_dialog.dart
 * Project: utils
 * -----
 * Created Date: Monday February 1st 2021
 * Author: Sony Sum
 * -----
 * Copyright (c) 2021 ERROR-DEV All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:sport_booking/services/ksp.dart';
import 'package:sport_booking/theme/color.dart';

class KSPLoading extends StatefulWidget {
  final Color color;

  KSPLoading({
    Key key,
    @required this.color,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => KSPLoadingState();

  static hideLoading(
      {BuildContext context, Color color: mainColor, Widget content}) {
    if (Navigator.canPop(context ?? KSP.shared.mainKey.currentContext)) {
      Navigator.pop(context ?? KSP.shared.mainKey.currentContext);
    }
  }
}

class KSPLoadingState extends State<KSPLoading>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 350));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.easeInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // controller.reverse().then((_) {
        //   Navigator.pop(context);
        // });
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.transparent,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: ScaleTransition(
                scale: scaleAnimation,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(widget.color),
                )),
          ),
        ),
      ),
    );
  }
}

class LoadingSuccessDialog extends StatefulWidget {
  final Color color;

  LoadingSuccessDialog({
    Key key,
    @required this.color,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => LoadingSuccessDialogState();
}

class LoadingSuccessDialogState extends State<LoadingSuccessDialog>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 350));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.easeInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // controller.reverse().then((_) {
        //   Navigator.pop(context);
        // });
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.transparent,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: ScaleTransition(
                scale: scaleAnimation,
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0)),
                  width: 320,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        LineAwesomeIcons.check_circle,
                        size: 64,
                        color: Colors.green,
                      ),
                      Text('I have received the parcel from sender.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.subtitle1)
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}

showLoading(
    {BuildContext context,
    Color color: mainColor,
    bool willPop = true,
    Widget content}) {
  showDialog(
    context: context ?? KSP.shared.mainKey.currentContext,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(.3),
    builder: (_) => WillPopScope(
      onWillPop: () async => false,
      child: content ?? KSPLoading(color: color),
    ),
  );
}

hideLoading({BuildContext context}) {
  Navigator.pop(context ?? KSP.shared.mainKey.currentContext);
}
