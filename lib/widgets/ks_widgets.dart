import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/app_size.dart';
import 'package:kroma_sport/utils/tools.dart';

Widget sliverDivider(BuildContext context, {double? height, Color? color}) {
  return SliverToBoxAdapter(
    child: Container(
      height: height ?? 8.0,
      color: color ?? Theme.of(context).scaffoldBackgroundColor,
    ),
  );
}

Future<dynamic> showKSBottomSheet(BuildContext context,
    {String? title,
    List<Widget> children = const <Widget>[],
    bool hasTopbar = true}) async {
  await showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).primaryColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
    ),
    builder: (context) {
      final statusHeight = MediaQuery.of(context).padding.top;
      return SafeArea(
        maintainBottomViewPadding: true,
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: AppSize(context).appHeight(100) - statusHeight - 80),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (hasTopbar)
                Container(
                  width: 40.0,
                  height: 5.0,
                  margin: const EdgeInsets.only(top: 10.0, bottom: 2.0),
                  decoration: BoxDecoration(
                    color:
                        isLight(context) ? Colors.grey[300] : Colors.grey[50],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              if (title != null)
                Container(
                  margin: EdgeInsets.only(top: hasTopbar ? 0 : 12),
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    top: 8.0,
                    bottom: 8.0,
                  ),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: children,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future generalSheet(BuildContext context,
        {Widget? child, String? title}) async =>
    await showModalBottomSheet(
      useRootNavigator: true,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
      ),
      elevation: 2,
      context: context,
      backgroundColor: ColorResources.getPrimary(context),
      builder: (context) {
        final statusHeight = MediaQuery.of(context).padding.top;
        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: AppSize(context).appHeight(100) - statusHeight - 80),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 4,
                  width: 25,
                  margin: EdgeInsets.only(top: 10.0, bottom: 2.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2.0),
                    color: ColorResources.getBlueGrey(context),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: 50, right: 50, top: 6.0, bottom: 10),
                  child: Text(
                    title ?? '',
                    style: Theme.of(context).textTheme.bodyText2,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                  ),
                ),
                Divider(height: 1),
                Flexible(child: SingleChildScrollView(child: child)),
              ],
            ),
          ),
        );
      },
    );

Future generalDialog(BuildContext context,
        {Widget? title, Widget? content, List<Widget>? actions}) async =>
    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animaiton, secondaryAnimation) =>
          AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor:
              Theme.of(context).brightness == Brightness.light
                  ? Color.fromRGBO(113, 113, 113, 1)
                  : Color.fromRGBO(15, 15, 15, 1),
        ),
        child: AlertDialog(
            elevation: 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            titlePadding: EdgeInsets.all(20),
            title: SizedBox(
                width: AppSize(context).appWidth(100) - 120, child: title),
            content: content,
            contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            actions: actions),
      ),
    );

/// Set action to true to show SnackBar action.
void showKSSnackBar(
  BuildContext context, {
  required String title,
  Color titleColor = Colors.white,
  Color backgroundColor = Colors.black87,
  bool action = false,
  String actionTitle = '',
  Color actionTitleColor = Colors.white,
  VoidCallback? onAction,
}) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      elevation: 0,
      backgroundColor: backgroundColor, //Color(0xFF696969),
      behavior: SnackBarBehavior.floating,
      content: Text(title, style: Theme.of(context).textTheme.bodyText2?.copyWith(color: titleColor)),
      margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      action: action
          ? SnackBarAction(
              label: action ? actionTitle : '',
              textColor: actionTitleColor,
              onPressed: () {
                scaffold.hideCurrentSnackBar();
                onAction!();
              })
          : null,
    ),
  );
}
