import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/app_size.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/ks_images.dart';
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

Widget noConnection(BuildContext context) {
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(icNoConnection,
            width: 70,
            color: isLight(context) ? Colors.grey[600] : Colors.white60),
        32.height,
        Text(
          'No Internet connection!',
          style: Theme.of(context).textTheme.bodyText1?.copyWith(
              fontWeight: FontWeight.w600,
              color: isLight(context) ? Colors.grey[600] : Colors.white60),
        ),
        4.height,
        Text(
          'Please check your network connection.',
          style: Theme.of(context).textTheme.bodyText1?.copyWith(
              color: isLight(context) ? Colors.grey : Colors.white54),
        ),
      ],
    ),
  );
}

Future<dynamic> showKSBottomSheet(BuildContext context,
    {String? title, List<Widget> children = const <Widget>[]}) async {
  await showModalBottomSheet(
    context: context,
    backgroundColor: Theme.of(context).primaryColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
    ),
    builder: (context) {
      return SafeArea(
        maintainBottomViewPadding: true,
        child: Container(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              bottomSheetBar(context),
              title != null
                  ? Container(
                      padding: const EdgeInsets.only(
                          left: 16.0, top: 8.0, bottom: 8.0),
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    )
                  : SizedBox(),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    // mainAxisSize: MainAxisSize.min,
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
