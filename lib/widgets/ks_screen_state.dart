import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kroma_sport/utils/app_size.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/ks_images.dart';
import 'package:kroma_sport/utils/tools.dart';

class KSScreenState extends StatelessWidget {
  final Widget icon;
  final String? title;
  final String? subTitle;
  final Color? titleColor;
  final Color? subTitleColor;

  const KSScreenState({
    Key? key,
    required this.icon,
    this.title,
    this.subTitle,
    this.titleColor,
    this.subTitleColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: AppSize(context).appHeight(50) - (AppBar().preferredSize.height + kToolbarHeight) - 100.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(color: isLight(context) ? Colors.green.shade50 : Colors.blueGrey[600], shape: BoxShape.circle),
            child: icon,
          ),
          24.height,
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: SizedBox(
                width: 300.0,
                child: Text(
                  title!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: titleColor ?? (isLight(context) ? Colors.blueGrey[700] : Colors.white60),
                  ),
                ),
              ),
            ),
          if (subTitle != null)
            SizedBox(
              width: 320.0,
              child: Text(
                subTitle!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      color: subTitleColor ?? (isLight(context) ? Colors.blueGrey[400] : Colors.white54),
                    ),
              ),
            ),
        ],
      ),
    );
  }
}

class KSNoInternet extends StatelessWidget {
  const KSNoInternet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(color: Colors.green.shade50, shape: BoxShape.circle),
              child: SvgPicture.asset(
                icNoConnection,
                height: 150,
                color: isLight(context) ? Colors.blueGrey[700] : Colors.white60,
              ),
            ),
            32.height,
            Text(
              'No Internet connection!',
              style: Theme.of(context).textTheme.headline6?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: (isLight(context) ? Colors.blueGrey[700] : Colors.white60),
                  ),
            ),
            8.height,
            Text(
              'Please check your network connection.',
              style: Theme.of(context).textTheme.bodyText2?.copyWith(color: isLight(context) ? Colors.grey[800] : Colors.white54),
            ),
            SizedBox(height: AppBar().preferredSize.height + kToolbarHeight - 32),
          ],
        ),
      ),
    );
  }
}
