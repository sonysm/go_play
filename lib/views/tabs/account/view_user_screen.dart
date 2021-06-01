import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/models/sport.dart';
import 'package:kroma_sport/models/user.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/account/sport_activity/fav_sport_detail.dart';
import 'package:kroma_sport/views/tabs/account/widget/sport_card.dart';
import 'package:kroma_sport/widgets/avatar.dart';

class ViewUserProfileScreen extends StatefulWidget {
  static const String tag = '/viewUserProfileScreen';

  final User user;

  ViewUserProfileScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  _ViewUserProfileScreenState createState() => _ViewUserProfileScreenState();
}

class _ViewUserProfileScreenState extends State<ViewUserProfileScreen> {
  KSHttpClient ksClient = KSHttpClient();
  List<FavoriteSport> favSportList = [];

  late User _user;

  Widget buildNavbar() {
    return SliverAppBar(
      title: Text(widget.user.getFullname()),
      elevation: 0.0,
      pinned: true,
      //actions: [
      //  CupertinoButton(
      //    child: Icon(FeatherIcons.settings,
      //        color: Theme.of(context).brightness == Brightness.light
      //            ? Colors.grey[600]
      //            : whiteColor),
      //    onPressed: () => launchScreen(context, SettingScreen.tag),
      //  )
      //],
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
              user: widget.user,
              isSelectable: false,
            ),
            8.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.user.getFullname(),
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
        height: 240.0,
        color: Theme.of(context).primaryColor,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          itemBuilder: (context, index) {
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
                  // getFavoriteSport();
                }
              },
            );
          },
          separatorBuilder: (context, index) {
            return 16.width;
          },
          itemCount: favSportList.length,
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
          buildFavoriteSport(),
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
    _user = widget.user;
    getUserDetail();
    // getFavoriteSport();
  }

  // void getFavoriteSport() async {
  //   var data = await ksClient.getApi('/user/favorite/sport');
  //   if (data != null) {
  //     if (data is! HttpResult) {
  //       favSportList =
  //           List.from((data as List).map((e) => FavoriteSport.fromJson(e)));
  //       setState(() {});
  //     }
  //   }
  // }

  void getUserDetail() async {
    var data = await ksClient.getApi('/user/view/user/${widget.user.id}');
    if (data != null) {
      if (data is! HttpResult) {
        _user = User.fromJson(data['user']);
        favSportList = (data['fav_sport'] as List).map((e) => FavoriteSport.fromJson(e)).toList();
        setState(() {});
      }
    }
  }
}
