import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/account/setting/setting_screen.dart';
import 'package:kroma_sport/widgets/avatar.dart';

class AccountScreen extends StatefulWidget {
  static const String tag = '/accountScreen';

  AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  Widget buildNavbar() {
    return SliverAppBar(
      title: Text('Account'),
      actions: [
        CupertinoButton(
          child: Icon(FeatherIcons.settings,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey[600]
                  : whiteColor),
          onPressed: () => launchScreen(context, SettingScreen.tag),
        )
      ],
    );
  }

  Widget actionHeader({String? amt, required String title}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                amt ?? '0',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProfileHeader() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.only(
            left: 16.0, top: 16.0, right: 16.0, bottom: 16.0),
        color: Theme.of(context).primaryColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Avatar(
              radius: 48.0,
              imageUrl: KS.shared.user.photo ?? '',
            ),
            8.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    KS.shared.user.getFullname(),
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Phnom Penh, Cambodia',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  16.height,
                  Row(
                    children: [
                      actionHeader(amt: '22', title: 'Activities'),
                      actionHeader(amt: '1.7k', title: 'Followers'),
                      actionHeader(amt: '337', title: 'Following'),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          buildNavbar(),
          buildProfileHeader(),
        ],
      ),
    );
  }
}
