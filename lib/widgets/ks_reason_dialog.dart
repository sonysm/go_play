import 'package:flutter/material.dart';
import 'package:kroma_sport/utils/tools.dart';

class KSReasonDialog extends StatefulWidget {
  final String title;
  final VoidCallback onYesPressed;

  KSReasonDialog({
    Key? key,
    required this.title,
    required this.onYesPressed,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => KSReasonDialogState();
}

class KSReasonDialogState extends State<KSReasonDialog>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<double>? scaleAnimation;

  Animation<double>? animation;

  TextStyle ts18BlackW600 = const TextStyle(
    color: Colors.black,
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
  );

  TextStyle ts18BlackW700 = const TextStyle(
    color: Colors.black,
    fontSize: 18.0,
    fontWeight: FontWeight.w700,
  );

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    scaleAnimation =
        CurvedAnimation(parent: controller!, curve: Curves.easeInOut);

    animation = Tween(begin: 0.0, end: 1.0).animate(controller!);

    controller!.addListener(() {
      setState(() {});
    });

    controller!.forward();
    controller!.duration = Duration(milliseconds: 0);
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // controller!.reverse().then((_) {
        //   Navigator.pop(context);
        // });
      },
      child: Container(
        color: Colors.transparent,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: FadeTransition(
              //scale: scaleAnimation!,
              opacity: animation!,
              child: Container(
                padding: EdgeInsets.only(top: 16.0),
                margin: EdgeInsets.symmetric(
                  horizontal: 35.0,
                ),
                decoration: ShapeDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0))),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 16.0),
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        widget.title,
                        style: Theme.of(context).textTheme.bodyText1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16.0),
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: isLight(context) ? Colors.grey[100]: Colors.blueGrey[400],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextField(
                        textCapitalization: TextCapitalization.sentences,
                        style: Theme.of(context).textTheme.bodyText1,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Write here...'
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              height: 48.0,
                              child: ElevatedButton(
                                onPressed: () {
                                  controller!.reverse().then((_) {
                                    Navigator.pop(context);
                                    widget.onYesPressed();
                                  });
                                },
                                child: Text(
                                  'Submit',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.zero),
                                  elevation: MaterialStateProperty.all(0),
                                  overlayColor: MaterialStateProperty.all(
                                      Colors.grey[200]),
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void showKSReasonDialog(
    BuildContext context, {required String title, required VoidCallback onSubmit}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(.3),
    builder: (_) => KSReasonDialog(
      title: title,
      onYesPressed: onSubmit,
    ),
  );
}
