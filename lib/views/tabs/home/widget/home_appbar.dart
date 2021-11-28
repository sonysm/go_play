import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/ks_images.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/search/search_screen.dart';

class HomeAppBar extends StatelessWidget {
  final VoidCallback? onTap;
  const HomeAppBar({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      elevation: 0.0,
      title: InkWell(
        onTap: onTap,
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        child: SizedBox(
          height: 28.0,
          child: Image.asset(imgVplayText, color: isLight(context) ? mainColor : whiteColor),
        ),
      ),
      actions: [
        CupertinoButton(
          padding: EdgeInsets.only(right: 16.0),
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isLight(context) ? Colors.blueGrey[50] : Colors.blueGrey,
              shape: BoxShape.circle,
            ),
            child: Icon(
              FeatherIcons.search,
              size: 20.0,
              color: isLight(context) ? Colors.grey[600] : whiteColor,
            ),
          ),
          onPressed: () => launchScreen(context, SearchScreen.tag),
        ),
        SizedBox(),
      ],
      floating: true,
      automaticallyImplyLeading: false,
    );
  }
}
