import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/bloc/data_state.dart';
import 'package:kroma_sport/bloc/home.dart';
import 'package:kroma_sport/bloc/meetup.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/models/post.dart';
import 'package:kroma_sport/models/sport.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/account/edit_profile_screen.dart';
import 'package:kroma_sport/views/tabs/account/follow_screen.dart';
import 'package:kroma_sport/views/tabs/account/setting/setting_screen.dart';
import 'package:kroma_sport/views/tabs/account/sport_activity/fav_sport_detail.dart';
import 'package:kroma_sport/views/tabs/account/sport_activity/sports_screen.dart';
import 'package:kroma_sport/views/tabs/account/widget/sport_card.dart';
import 'package:kroma_sport/views/tabs/home/widget/activity_cell.dart';
import 'package:kroma_sport/views/tabs/home/widget/home_feed_cell.dart';
import 'package:kroma_sport/views/tabs/meetup/widget/meetup_cell.dart';
import 'package:kroma_sport/widgets/avatar.dart';
import 'package:line_icons/line_icons.dart';

class AccountScreen extends StatefulWidget {
  static const String tag = '/accountScreen';

  AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>
    with SingleTickerProviderStateMixin {
  KSHttpClient ksClient = KSHttpClient();
  List<FavoriteSport> favSportList = [];

  late TabController tabController;
  int _currentIndex = 0;

  bool isLoaded = false;

  Widget buildNavbar() {
    return SliverAppBar(
      pinned: true,
      title: Text('Account'),
      actions: [
        CupertinoButton(
          padding: EdgeInsets.zero,
          minSize: 0,
          child: Icon(
            LineIcons.userEdit,
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.grey[600]
                : whiteColor,
            size: 28.0,
          ),
          onPressed: () => launchScreen(context, EditProfileScreen.tag),
        ),
        CupertinoButton(
          child: Icon(FeatherIcons.settings,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey[600]
                  : whiteColor),
          onPressed: () => launchScreen(context, SettingScreen.tag),
        ),
      ],
    );
  }

  Widget actionHeader(
      {String? amt, required String title, VoidCallback? onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
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
                  Text(KS.shared.user.getFullname(),
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Metropolis')),
                  Text(
                    'Phnom Penh, Cambodia',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  16.height,
                  Row(
                    children: [
                      actionHeader(amt: '0', title: 'Coin'),
                      actionHeader(
                        amt: '${KS.shared.user.followerCount}',
                        title: 'Followers',
                        onTap: () => launchScreen(context, FollowScreen.tag),
                      ),
                      actionHeader(
                        amt: '${KS.shared.user.followingCount}',
                        title: 'Following',
                        onTap: () => launchScreen(context, FollowScreen.tag),
                      ),
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
                      Color(0xFF1D976C),
                      Color(0xFF93F9B9),
                    ],
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

  Widget buildFeedTabbar() {
    return SliverPadding(
      padding: const EdgeInsets.only(top: 8.0),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                border: Border(
                    bottom: BorderSide(
                        width: 0.5,
                        color: isLight(context)
                            ? Colors.blueGrey[50]!
                            : Colors.blueGrey)),
              ),
              child: TabBar(
                controller: tabController,
                labelStyle: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
                indicatorColor:
                      isLight(context) ? mainColor : Colors.greenAccent,
                isScrollable: true,
                onTap: (index) => setState(() => _currentIndex = index),
                tabs: [
                  Tab(text: 'Post'),
                  Tab(text: 'Meetup'),
                ],
              ),
            ),
            _currentIndex == 0 ? buildPostFeedList() : buildMeetupList()
          ],
        ),
      ),
    );
  }

  Widget buildMeetupList() {
    return BlocBuilder<MeetupCubit, MeetupData>(
      builder: (context, data) {
        return data.status == DataState.Loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : data.ownerMeetup.isNotEmpty
                ? ListView.separated(
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var meetup = data.ownerMeetup.elementAt(index);

                      return Padding(
                        padding: EdgeInsets.only(top: (index == 0 ? 4.0 : 0)),
                        child: MeetupCell(
                          post: meetup,
                          isAvatarSelectable: false,
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return 8.height;
                    },
                    itemCount: data.ownerMeetup.length,
                  )
                : SizedBox();
      },
    );
  }

  Widget buildPostFeedList() {
    return BlocBuilder<HomeCubit, HomeData>(
      builder: (context, data) {
        return data.status == DataState.Loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : data.ownerPost.isNotEmpty
                ? ListView.separated(
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var post = data.ownerPost.elementAt(index);
                      if (post.type == PostType.feed) {
                        return Padding(
                          padding: EdgeInsets.only(top: (index == 0 ? 4.0 : 0)),
                          child: HomeFeedCell(
                            post: post,
                            isAvatarSelectable: false,
                          ),
                        );
                      } else if (post.type == PostType.activity) {
                        return Padding(
                          padding: EdgeInsets.only(top: (index == 0 ? 4.0 : 0)),
                          child: ActivityCell(
                            post: post,
                            isAvatarSelectable: false,
                          ),
                        );
                      }
                      return SizedBox();
                    },
                    separatorBuilder: (context, index) {
                      return 8.height;
                    },
                    itemCount: data.ownerPost.length)
                : SizedBox();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Text('Account'),
        actions: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            minSize: 0,
            child: Icon(
              LineIcons.userEdit,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey[600]
                  : whiteColor,
              size: 28.0,
            ),
            onPressed: () => launchScreen(context, EditProfileScreen.tag),
          ),
          CupertinoButton(
            child: Icon(FeatherIcons.settings,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey[600]
                    : whiteColor),
            onPressed: () => launchScreen(context, SettingScreen.tag),
          ),
        ],
      ),
      body: EasyRefresh.custom(
        header: MaterialHeader(
          valueColor: AlwaysStoppedAnimation<Color>(mainColor),
        ),
        slivers: [
          // buildNavbar(),
          buildProfileHeader(),
          buildFavoriteSport(),
          isLoaded ? buildFeedTabbar() : SliverToBoxAdapter(),
        ],
        onRefresh: () async {
          BlocProvider.of<HomeCubit>(context).onRefresh();
          BlocProvider.of<MeetupCubit>(context).onRefresh();
        },
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
    tabController = TabController(length: 2, vsync: this);

    Future.delayed(Duration(milliseconds: 300)).then((_) {
      getFavoriteSport();
    });
  }

  void getFavoriteSport() async {
    var data = await ksClient.getApi('/user/favorite/sport');
    if (data != null) {
      if (data is! HttpResult) {
        favSportList =
            List.from((data as List).map((e) => FavoriteSport.fromJson(e)));
        isLoaded = true;
        setState(() {});
      }
    }
  }
}
