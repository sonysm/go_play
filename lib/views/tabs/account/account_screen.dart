import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/models/sport.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/account/setting/setting_screen.dart';
import 'package:kroma_sport/views/tabs/account/sport_activity/fav_sport_detail.dart';
import 'package:kroma_sport/views/tabs/account/sport_activity/sports_screen.dart';
import 'package:kroma_sport/views/tabs/account/widget/sport_card.dart';
import 'package:kroma_sport/widgets/avatar.dart';
import 'package:kroma_sport/widgets/ks_icon_button.dart';

class AccountScreen extends StatefulWidget {
  static const String tag = '/accountScreen';

  AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  KSHttpClient ksClient = KSHttpClient();
  List<FavoriteSport> favSportList = [];

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
              user: KS.shared.user,
              isSelectable: false,
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

  Widget buildFavoriteSport() {
    return SliverToBoxAdapter(
      child: Container(
        color: Theme.of(context).primaryColor,
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Favorite Sport',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                Spacer(),
                KSIconButton(
                  icon: Feather.plus_circle,
                  iconSize: 24.0,
                  onTap: () async {
                    var value = await launchScreen(context, SportsScreen.tag);
                    if (value != null && value) {
                      getFavoriteSport();
                    }
                  },
                ),
              ],
            ),
            favSportList.isNotEmpty
                ? Column(
                    children: List.generate(favSportList.length, (index) {
                      final sport = favSportList.elementAt(index).sport;
                      return TextButton(
                        onPressed: () async {
                          var value = await launchScreen(
                              context, FavoriteSportDetailScreen.tag,
                              arguments: sport);
                          if (value != null && value) {
                            getFavoriteSport();
                          }
                        },
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(horizontal: 0)),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                        child: Row(
                          children: [
                            Text(
                              sport.name == 'Volleyball' ? '🏐' : '⚽️',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            8.width,
                            Text(
                              sport.name,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ],
                        ),
                      );
                    }),
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'No Favorite Sport',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          ?.copyWith(color: Colors.grey[400]),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  Widget buildFavSport() {
    return SliverToBoxAdapter(
      child: Container(
        height: 220.0,
        color: Theme.of(context).primaryColor,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          itemBuilder: (context, index) {
            if (index < favSportList.length) {
              final favSport = favSportList.elementAt(index);
              return SportCard(
                favSport: favSport,
                onCardTap: () async {
                  var value = await launchScreen(
                    context,
                    FavoriteSportDetailScreen.tag,
                    arguments: favSport.sport,
                  );
                  if (value != null && value) {
                    getFavoriteSport();
                  }
                },
              );
            }
            return InkWell(
              onTap: () async {
                var value = await launchScreen(context, SportsScreen.tag);
                if (value != null && value) {
                  getFavoriteSport();
                }
              },
              child: Container(
                width: 320.0,
                margin: const EdgeInsets.only(top: 24.0, bottom: 16.0),
                padding: const EdgeInsets.all(16.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  gradient: LinearGradient(
                    colors: [
                      mainColor,
                      mainColor,
                      mainColor,
                      Colors.green[400]!,
                      Colors.lightGreen[400]!,
                      Colors.lightGreen[300]!,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Feather.plus, color: whiteColor),
                    8.width,
                    Text(
                      'Add Sport',
                      style: TextStyle(
                          fontSize: 18.0,
                          color: whiteColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return 16.width;
          },
          itemCount: favSportList.length + 1,
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
          // buildFavoriteSport(),
          buildFavSport(),
        ],
      ),
    );
  }

  @override
  void setState(fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  @override
  void initState() {
    super.initState();
    getFavoriteSport();
  }

  void getFavoriteSport() async {
    var data = await ksClient.getApi('/user/favorite/sport');
    if (data != null) {
      if (data is! HttpResult) {
        favSportList =
            List.from((data as List).map((e) => FavoriteSport.fromJson(e)));
        setState(() {});
      }
    }
  }
}
