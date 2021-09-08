import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/ks_images.dart';
import 'package:kroma_sport/utils/tools.dart';

class KSScreenState extends StatelessWidget {
  final Widget icon;
  final String? title;
  final String? subTitle;
  final Color? titleColor;
  final Color? subTitleColor;
  final double? bottomPadding;

  const KSScreenState({
    Key? key,
    required this.icon,
    this.title,
    this.subTitle,
    this.titleColor,
    this.subTitleColor,
    this.bottomPadding = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          32.height,
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                title!,
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: titleColor ?? (isLight(context) ? Colors.blueGrey[700] : Colors.white60),
                      fontFamily: 'Aeonik'
                    ),
              ),
            ),
          if (subTitle != null)
            Text(
              subTitle!,
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    color: subTitleColor ?? (isLight(context) ? Colors.grey : Colors.white54),
                  ),
            ),
          SizedBox(height: bottomPadding),
        ],
      ),
    );
  }
}

class KSNoInternet extends StatelessWidget {
  const KSNoInternet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            icNoConnection,
            width: 70,
            color: isLight(context) ? Colors.grey[600] : Colors.white60,
          ),
          32.height,
          Text(
            'No Internet connection!',
            style: Theme.of(context)
                .textTheme
                .bodyText1
                ?.copyWith(fontWeight: FontWeight.w600, color: isLight(context) ? Colors.grey[600] : Colors.white60),
          ),
          4.height,
          Text(
            'Please check your network connection.',
            style: Theme.of(context).textTheme.bodyText1?.copyWith(color: isLight(context) ? Colors.grey : Colors.white54),
          ),
        ],
      ),
    );
  }
}
