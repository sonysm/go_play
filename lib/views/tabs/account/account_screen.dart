import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/bloc/data_state.dart';
import 'package:kroma_sport/bloc/home.dart';
import 'package:kroma_sport/bloc/meetup.dart';
import 'package:kroma_sport/bloc/user.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/models/post.dart';
import 'package:kroma_sport/models/sport.dart';
import 'package:kroma_sport/models/user.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/app_size.dart';
import 'package:kroma_sport/utils/connection_service.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/account/edit_profile_screen.dart';
import 'package:kroma_sport/views/tabs/account/follow_screen.dart';
import 'package:kroma_sport/views/tabs/account/setting/setting_screen.dart';
import 'package:kroma_sport/views/tabs/account/sport_activity/fav_sport_detail.dart';
import 'package:kroma_sport/views/tabs/account/sport_activity/sports_screen.dart';
import 'package:kroma_sport/views/tabs/account/widget/sport_card.dart';
import 'package:kroma_sport/views/tabs/home/create_post_screen.dart';
import 'package:kroma_sport/views/tabs/home/widget/activity_cell.dart';
import 'package:kroma_sport/views/tabs/home/widget/home_feed_cell.dart';
import 'package:kroma_sport/views/tabs/meetup/organize_list_screen.dart';
import 'package:kroma_sport/views/tabs/meetup/widget/meetup_cell.dart';
import 'package:kroma_sport/views/tabs/venue/booking_history_screen.dart';
import 'package:kroma_sport/widgets/avatar.dart';
import 'package:kroma_sport/widgets/ks_screen_state.dart';
import 'package:kroma_sport/widgets/pull_to_refresh_header.dart';
import 'package:line_icons/line_icons.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';

class AccountScreen extends StatefulWidget {
  static const tag = '/accountScreen';
  AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> with TickerProviderStateMixin {
  late TabController _controller;
  late ConnectionStatusSingleton connectionStatus;
  late HomeCubit _homeCubit;
  late MeetupCubit _meetupCubit;

  KSHttpClient ksClient = KSHttpClient();
  List<FavoriteSport> favSportList = [];

  bool isLoaded = false;
  int postPage = 1;
  int meetupPage = 1;

  Widget actionHeader({String? amt, required String title, VoidCallback? onTap}) {
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
                style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProfileHeader() {
    return BlocBuilder<UserCubit, User>(builder: (context, user) {
      return SliverToBoxAdapter(
        child: Container(
          padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0, bottom: 16.0),
          color: Theme.of(context).primaryColor,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Avatar(
                radius: 48.0,
                user: user,
                isSelectable: false,
              ),
              8.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.getFullname(),
                      style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    //Text(
                    //  'Phnom Penh, Cambodia',
                    //  style: Theme.of(context).textTheme.bodyText2,
                    //),
                    16.height,
                    Row(
                      children: [
                        // actionHeader(amt: '0', title: 'Coin'),
                        actionHeader(
                          amt: '${user.followerCount}',
                          title: '${user.followerCount > 1 ? 'Followers' : 'Follower'}',
                          onTap: () => launchScreen(context, FollowScreen.tag),
                        ),
                        actionHeader(
                          amt: '${user.followingCount}',
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
    });
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
                    arguments: {'favSport': favSport},
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
                      style: TextStyle(fontSize: 18.0, color: whiteColor, fontWeight: FontWeight.w600),
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

  Widget buildMeetupList() {
    return BlocBuilder<MeetupCubit, MeetupData>(
      builder: (context, data) {
        if (!data.ownerHasReachedMax) meetupPage = 1;
        if (data.status == DataState.ErrorSocket) {
          return Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: KSNoInternet(),
          );
        }

        return data.status == DataState.Loading
            ? Container(
                margin: const EdgeInsets.only(top: 100),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : data.ownerMeetup.isNotEmpty
                ? NotificationListener(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (scrollInfo.metrics.atEdge &&
                          scrollInfo.metrics.pixels > 0 &&
                          (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent)) {
                        loadMoreMeetup();
                      }
                      return false;
                    },
                    child: ListView.separated(
                      key: PageStorageKey<String>('Tab1'),
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        if (index >= data.ownerMeetup.length) {
                          return BottomLoader();
                        }

                        var meetup = data.ownerMeetup.elementAt(index);

                        return Padding(
                          padding: EdgeInsets.only(top: (index == 0 ? 4.0 : 0)),
                          child: MeetupCell(
                            key: Key(meetup.id.toString()),
                            post: meetup,
                            index: index,
                            isAvatarSelectable: false,
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return 8.height;
                      },
                      itemCount: data.ownerHasReachedMax ? data.ownerMeetup.length : data.ownerMeetup.length + 1,
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        KSScreenState(
                          icon: Image.asset('assets/images/img_emptypost.png', color: Colors.blueGrey[700], height: 100.0),
                          title: 'No Meetup',
                          subTitle: 'You don\'t have meetup yet.',
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: SizedBox(
                            width: 200.0,
                            height: 44.0,
                            child: ElevatedButton(
                              onPressed: () => launchScreen(context, OrganizeListScreen.tag),
                              style: ButtonStyle(
                                elevation: MaterialStateProperty.all(0),
                                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0))),
                                backgroundColor: MaterialStateProperty.all(mainColor),
                              ),
                              child: Text(
                                'Create new meetup',
                                style: TextStyle(color: whiteColor, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
      },
    );
  }

  Widget buildPostFeedList() {
    return BlocBuilder<HomeCubit, HomeData>(
      builder: (context, data) {
        if (!data.ownerHasReachedMax) postPage = 1;
        if (data.status == DataState.ErrorSocket && data.ownerPost.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: KSNoInternet(),
          );
        }

        return data.status == DataState.Loading
            ? Container(
                margin: const EdgeInsets.only(top: 100),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : data.ownerPost.isNotEmpty
                ? NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (scrollInfo.metrics.atEdge &&
                          scrollInfo.metrics.pixels > 0 &&
                          (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent)) {
                        loadMorePost();
                      }
                      return false;
                    },
                    child: ListView.separated(
                      key: PageStorageKey<String>('Tab0'),
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        if (index >= data.ownerPost.length) {
                          return BottomLoader();
                        }

                        var post = data.ownerPost.elementAt(index);
                        if (post.type == PostType.feed) {
                          return Padding(
                            padding: EdgeInsets.only(top: (index == 0 ? 4.0 : 0)),
                            child: HomeFeedCell(
                              index: index,
                              key: Key("home${post.id}"),
                              post: post,
                              isAvatarSelectable: false,
                              isHomeFeed: false,
                            ),
                          );
                        } else if (post.type == PostType.activity) {
                          return Padding(
                            padding: EdgeInsets.only(top: (index == 0 ? 4.0 : 0)),
                            child: ActivityCell(
                              index: index,
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
                      itemCount: data.ownerHasReachedMax ? data.ownerPost.length : data.ownerPost.length + 1,
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        KSScreenState(
                          icon: Image.asset(
                            'assets/images/img_emptypost.png',
                            color: Colors.blueGrey[700],
                            height: 100.0,
                          ),
                          title: 'No Post yet',
                          subTitle: 'You don\'t have any post.',
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: SizedBox(
                            width: 200.0,
                            height: 44.0,
                            child: ElevatedButton(
                              onPressed: () => launchScreen(context, CreatePostScreen.tag),
                              style: ButtonStyle(
                                elevation: MaterialStateProperty.all(0),
                                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0))),
                                backgroundColor: MaterialStateProperty.all(mainColor),
                              ),
                              child: Text(
                                'Create new post',
                                style: TextStyle(color: whiteColor, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
      },
    );
  }

  Widget _buildScaffoldBody() {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double pinnedHeaderHeight = statusBarHeight + kToolbarHeight;

    return PullToRefreshNotification(
      color: Colors.blue,
      onRefresh: () {
        return Future<bool>.delayed(
            const Duration(
              seconds: 1,
            ), () {
          _homeCubit.loadOwnerPost(1);
          _meetupCubit.loadOwnerMeetup(1);
          return true;
        });
      },
      maxDragOffset: 100,
      child: GlowNotificationWidget(
        ExtendedNestedScrollView(
          headerSliverBuilder: (BuildContext c, bool f) {
            return <Widget>[
              SliverAppBar(
                elevation: 0.3,
                pinned: true,
                title: Text('Account'),
                actions: [
                  CupertinoButton(
                    onPressed: () => showAccountOptionSheet(),
                    child: Icon(
                      LineIcons.bars,
                      size: 28.0,
                      color: ColorResources.getSecondaryIconColor(context),
                    ),
                  ),
                ],
              ),
              PullToRefreshContainer((PullToRefreshScrollNotificationInfo? info) {
                return SliverToBoxAdapter(
                  child: PullToRefreshHeader(
                    info,
                    DateTime.now(),
                    color: Theme.of(context).primaryColor,
                  ),
                );
              }),
              buildProfileHeader(),
              buildFavoriteSport(),
            ];
          },
          pinnedHeaderSliverHeightBuilder: () {
            return pinnedHeaderHeight;
          },
          onlyOneScrollInBody: true,
          body: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  border: Border(bottom: BorderSide(width: 0.5, color: isLight(context) ? Colors.blueGrey[50]! : Colors.blueGrey)),
                ),
                child: TabBar(
                  controller: _controller,
                  labelStyle: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                  indicatorColor: isLight(context) ? mainColor : Colors.greenAccent,
                  isScrollable: true,
                  tabs: const <Tab>[
                    Tab(text: 'Post'),
                    Tab(text: 'Meetup'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _controller,
                  children: <Widget>[
                    buildPostFeedList(),
                    buildMeetupList(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildScaffoldBody(),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);

    connectionStatus = ConnectionStatusSingleton.getInstance();
    connectionStatus.connectionChange.listen(connectionChanged);

    Future.delayed(Duration(milliseconds: 300)).then((_) {
      getFavoriteSport();
    });

    _homeCubit = context.read<HomeCubit>();
    _meetupCubit = context.read<MeetupCubit>();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void getFavoriteSport() async {
    var data = await ksClient.getApi('/user/favorite/sport');
    if (data != null) {
      if (data is! HttpResult) {
        favSportList = List.from((data as List).map((e) => FavoriteSport.fromJson(e)));
        isLoaded = true;
      } else {
        if (data.code == -500) {
          isLoaded = true;
        }
      }
      setState(() {});
    }
  }

  void connectionChanged(dynamic hasConnection) {
    if (hasConnection) {
      getFavoriteSport();
      _homeCubit.onLoad();
      _meetupCubit.onLoad();
    }
  }

  Future accountOptionSheet(BuildContext context, {Widget? child}) async => await showModalBottomSheet(
        useRootNavigator: true,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
        ),
        elevation: 2,
        context: context,
        backgroundColor: ColorResources.getPrimary(context),
        builder: (context) {
          final statusHeight = MediaQuery.of(context).padding.top;
          return SafeArea(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: AppSize(context).appHeight(100) - statusHeight - 80),
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
                  Flexible(child: SingleChildScrollView(child: child)),
                ],
              ),
            ),
          );
        },
      );

  void showAccountOptionSheet() {
    accountOptionSheet(
      context,
      child: Column(
        children: [
          ListTile(
            leading: Avatar(
              radius: 22.0,
              user: KS.shared.user,
              isSelectable: false,
            ),
            title: Text(
              KS.shared.user.getFullname(),
              style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w600),
            ),
            subtitle: Row(
              children: [
                TextButton(
                  onPressed: () {
                    dismissScreen(context);
                    launchScreen(context, EditProfileScreen.tag);
                  },
                  style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(Colors.grey[100]),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: MaterialStateProperty.all(Size(0, 0)),
                      padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0.0))),
                  child: Text(
                    'Edit Profile',
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          color: ColorResources.getBlueGrey(context),
                        ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            onTap: () {
              dismissScreen(context);
              launchScreen(context, BookingHistoryScreen.tag);
            },
            leading: Icon(
              LineIcons.history,
              color: ColorResources.getSecondaryIconColor(context),
              // size: 20.0,
            ),
            title: Text(
              'My Booking',
              style: Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 18),
            ),
            horizontalTitleGap: 0,
          ),
          ListTile(
            onTap: () {
              dismissScreen(context);
              launchScreen(context, SettingScreen.tag);
            },
            leading: Icon(
              LineIcons.cog,
              color: ColorResources.getSecondaryIconColor(context),
              // size: 20.0,
            ),
            title: Text(
              'Settings & Privacy',
              style: Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 18),
            ),
            horizontalTitleGap: 0,
          ),
        ],
      ),
    );
  }

  void loadMorePost() async {
    postPage += 1;
    await Future.delayed(Duration(seconds: 1), () {
      _homeCubit.loadOwnerPost(postPage);
    });
  }

  void loadMoreMeetup() async {
    meetupPage += 1;
    await Future.delayed(Duration(seconds: 1), () {
      _meetupCubit.loadOwnerMeetup(meetupPage);
    });
  }
}

class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.only(bottom: 8.0),
        child: SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
            valueColor: AlwaysStoppedAnimation(mainColor),
          ),
        ),
      ),
    );
  }
}
