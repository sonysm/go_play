import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/models/post.dart';
import 'package:kroma_sport/models/sport.dart';
import 'package:kroma_sport/models/user.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/account/follow_screen.dart';
import 'package:kroma_sport/views/tabs/account/sport_activity/fav_sport_detail.dart';
import 'package:kroma_sport/views/tabs/account/widget/sport_card.dart';
import 'package:kroma_sport/views/tabs/home/widget/activity_cell.dart';
import 'package:kroma_sport/views/tabs/home/widget/home_feed_cell.dart';
import 'package:kroma_sport/views/tabs/meetup/widget/meetup_cell.dart';
import 'package:kroma_sport/widgets/avatar.dart';
import 'package:kroma_sport/widgets/ks_confirm_dialog.dart';
import 'package:kroma_sport/widgets/ks_screen_state.dart';
import 'package:kroma_sport/widgets/ks_text_button.dart';
import 'package:kroma_sport/widgets/ks_widgets.dart';
import 'package:kroma_sport/widgets/pull_to_refresh_header.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';
import 'package:shimmer/shimmer.dart';

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

class _ViewUserProfileScreenState extends State<ViewUserProfileScreen>
    with TickerProviderStateMixin {
  KSHttpClient ksClient = KSHttpClient();
  List<FavoriteSport> favSportList = [];

  List<Post> userPostList = [];
  List<Post> userMeetupList = [];

  late User _user;

  late TabController tabController;
  int _currentIndex = 0;

  bool isLoaded = false;

  late AnimationController animationController;
  late Animation<double> animation;

  late bool isFollow;

  bool postHasReachedMax = false;
  bool meetupHasReachedMax = false;

  int postPage = 1;
  int meetupPage = 1;

  Widget buildNavbar() {
    return SliverAppBar(
      title: Text(widget.user.getFullname()),
      elevation: 0.0,
      pinned: true,
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
        child: Column(
          children: [
            Row(
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
                        style: Theme.of(context).textTheme.headline6?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Metropolis'),
                      ),
                      //Text(
                      //  'Phnom Penh, Cambodia',
                      //  style: Theme.of(context).textTheme.bodyText2,
                      //),
                      16.height,
                      Row(
                        children: [
                          actionHeader(
                            amt: '${_user.followerCount}',
                            title: 'Followers',
                            onTap: () => launchScreen(context, FollowScreen.tag,
                                arguments: _user),
                          ),
                          actionHeader(
                            amt: '${_user.followingCount}',
                            title: 'Following',
                            onTap: () => launchScreen(context, FollowScreen.tag,
                                arguments: _user),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            8.height,
            Row(
              children: [
                Expanded(
                  child: isLoaded
                      ? ElevatedButton(
                          onPressed:
                              isFollow ? showFollowingOption : followUser,
                          style: ButtonStyle(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            elevation: MaterialStateProperty.all(0.0),
                            backgroundColor: MaterialStateProperty.all(isFollow
                                ? Colors.transparent
                                : Color(0xFF1D976C)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                  side: isFollow
                                      ? BorderSide(
                                          color: isLight(context)
                                              ? Color(0xFF1D976C)
                                              : whiteColor)
                                      : BorderSide.none),
                            ),
                          ),
                          child: isLoaded
                              ? Text(
                                  isFollow ? 'Following' : 'Follow',
                                  style: TextStyle(
                                    color: isFollow
                                        ? isLight(context)
                                            ? Color(0xFF1D976C)
                                            : whiteColor
                                        : whiteColor,
                                    fontSize: 16.0,
                                    fontFamily: 'ProximaNova',
                                  ),
                                )
                              : Container(
                                  color: Colors.grey[300],
                                ),
                        )
                      : Shimmer.fromColors(
                          baseColor: isLight(context)
                              ? Colors.grey[300]!
                              : Colors.blueGrey[600]!,
                          highlightColor: isLight(context)
                              ? Colors.grey[100]!
                              : Colors.blueGrey,
                          child: Container(
                            height: 32.0,
                            decoration: BoxDecoration(
                              color: isLight(context)
                                  ? Colors.grey[300]
                                  : Colors.blueGrey[600],
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                        ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSportShimmer() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 320.0,
            margin: const EdgeInsets.only(right: 16.0, top: 16.0, bottom: 16.0),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        );
      },
      itemCount: 2,
    );
  }

  Widget buildFavoriteSport() {
    return SliverToBoxAdapter(
      child: favSportList.isNotEmpty
          ? Container(
              height: 240.0,
              color: Theme.of(context).primaryColor,
              child: isLoaded
                  ? FadeTransition(
                      opacity: animation,
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
                                arguments: {
                                  'favSport': favSport,
                                  'isMe': false
                                },
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
                    )
                  : buildSportShimmer(),
            )
          : SizedBox(),
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

  Widget buildPostFeedList() {
    return isLoaded
        ? userPostList.isNotEmpty
            ? FadeTransition(
                opacity: animation,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (scrollInfo.metrics.atEdge &&
                        scrollInfo.metrics.pixels > 0 &&
                        scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {
                      loadMorePost();
                    }
                    return false;
                  },
                  child: ListView.separated(
                    key: PageStorageKey<String>('TabPost'),
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      if (index >= userPostList.length) {
                        return BottomLoader();
                      }

                      var post = userPostList.elementAt(index);
                      if (post.type == PostType.feed) {
                        return Padding(
                          padding: EdgeInsets.only(top: (index == 0 ? 4.0 : 0)),
                          child: HomeFeedCell(
                            index: index,
                            post: post,
                            isAvatarSelectable: false,
                            isHomeFeed: false,
                            key: Key("acc${post.id}"),
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
                    itemCount: postHasReachedMax
                        ? userPostList.length
                        : userPostList.length + 1,
                  ),
                ),
              )
            : Container(
                margin: const EdgeInsets.only(top: 50),
                child: Center(
                  child: SingleChildScrollView(
                    child: KSScreenState(
                      icon: SizedBox(
                        height: 100,
                        child: Image.asset(
                          'assets/images/img_emptypost.png',
                          color: Colors.grey,
                        ),
                      ),
                      title: 'No Post',
                      bottomPadding:
                          AppBar().preferredSize.height + kToolbarHeight,
                    ),
                  ),
                ),
              )
        : SizedBox();
  }

  Widget buildMeetupList() {
    return userMeetupList.isNotEmpty
        ? NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.atEdge &&
                  scrollInfo.metrics.pixels > 0 &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                loadMoreMeetup();
              }
              return false;
            },
            child: ListView.builder(
              key: PageStorageKey<String>('TabMeetup'),
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                if (index >= userMeetupList.length) {
                  return BottomLoader();
                }
                var meetup = userMeetupList.elementAt(index);

                return Padding(
                  padding: EdgeInsets.only(top: (index == 0 ? 8.0 : 0)),
                  child: MeetupCell(
                    post: meetup,
                    isAvatarSelectable: false,
                  ),
                );
              },
              itemCount: meetupHasReachedMax
                  ? userMeetupList.length
                  : userMeetupList.length + 1,
            ),
          )
        : Container(
            margin: const EdgeInsets.only(top: 50),
            child: Center(
              child: SingleChildScrollView(
                child: KSScreenState(
                  icon: SizedBox(
                    height: 100,
                    child: Image.asset(
                      'assets/images/img_emptypost.png',
                      color: Colors.grey,
                    ),
                  ),
                  title: 'No Meetup',
                  bottomPadding: AppBar().preferredSize.height + kToolbarHeight,
                ),
              ),
            ),
          );
  }

  Widget _buildScaffoldBody() {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double pinnedHeaderHeight = statusBarHeight + kToolbarHeight;

    return PullToRefreshNotification(
      color: Colors.blue,
      onRefresh: () {
        return Future<bool>.delayed(const Duration(seconds: 1), () {
          getUserPostAndMeetupById();
          return true;
        });
      },
      maxDragOffset: maxDragOffset,
      child: GlowNotificationWidget(
        ExtendedNestedScrollView(
          headerSliverBuilder: (BuildContext c, bool f) {
            return <Widget>[
              SliverAppBar(
                elevation: 0.5,
                pinned: true,
                title: Text(widget.user.getFullname()),
              ),
              PullToRefreshContainer(
                  (PullToRefreshScrollNotificationInfo? info) {
                return SliverToBoxAdapter(
                  child: PullToRefreshHeader(
                    info,
                    DateTime.now(),
                    color: Colors.white,
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
          // onlyOneScrollInBody: true,
          body: Column(
            children: <Widget>[
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
                  indicatorColor: ColorResources.getMainColor(context),
                  isScrollable: true,
                  tabs: const <Tab>[
                    Tab(text: 'Post'),
                    Tab(text: 'Meetup'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: tabController,
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
    return WillPopScope(
      onWillPop: () async {
        dismissScreen(context, _user);
        return true;
      },
      child: Scaffold(
        body: _buildScaffoldBody(),
        // CustomScrollView(
        //   slivers: [
        //     buildNavbar(),
        //     buildProfileHeader(),
        //     buildFavoriteSport(),
        //     buildFeedTabbar(),
        //   ],
        // ),
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
    _user = widget.user;

    animationController = AnimationController(
        duration: Duration(milliseconds: 1500), vsync: this);

    animation = Tween(begin: 0.0, end: 1.0).animate(animationController);

    Future.delayed(Duration.zero).then((_) {
      getUserDetail();
      getUserPostAndMeetupById();
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void getUserPostAndMeetupById() async {
    postPage = 1;
    meetupPage = 1;
    postHasReachedMax = false;
    meetupHasReachedMax = false;
    var postData = await ksClient.getApi('/user/feed/by/${widget.user.id}');
    if (postData != null) {
      if (postData is! HttpResult) {
        userPostList =
            List.from((postData as List).map((e) => Post.fromJson(e)));
      }
    }

    var meetupData = await ksClient.getApi('/user/meetup/by/${widget.user.id}');
    if (meetupData != null) {
      if (meetupData is! HttpResult) {
        userMeetupList =
            List.from((meetupData as List).map((e) => Post.fromJson(e)));
      }
    }
    setState(() {});
    animationController.forward();
  }

  void getUserDetail() async {
    var data = await ksClient.getApi('/user/view/user/${widget.user.id}');
    if (data != null) {
      if (data is! HttpResult) {
        _user = User.fromJson(data['user']);
        isFollow = data['my_following'];
        favSportList = (data['fav_sport'] as List)
            .map((e) => FavoriteSport.fromJson(e))
            .toList();
        isLoaded = true;
        // setState(() {});
      }
    }
  }

  void followUser() async {
    var res = await ksClient.postApi('/user/follow/${_user.id}');
    if (res != null) {
      if (res is! HttpResult) {
        _user.followerCount += 1;
        isFollow = true;
        setState(() {});
      }
    }
  }

  void showFollowingOption() {
    showKSBottomSheet(context, children: [
      KSTextButtonBottomSheet(
        title: 'Unfollow',
        onTab: () {
          dismissScreen(context);

          showKSConfirmDialog(
            context,
            message:
                'Are you sure you want to unfollow ${_user.getFullname()}?',
            onYesPressed: () async {
              var res = await ksClient.postApi('/user/unfollow/${_user.id}');
              if (res != null) {
                if (res is! HttpResult) {
                  _user.followerCount -= 1;
                  isFollow = false;
                  setState(() {});
                }
              }
            },
          );
        },
      )
    ]);
  }

  void loadMorePost() async {
    postPage += 1;
    List<Post> morePost = [];
    await ksClient.getApi('/user/feed/by/${widget.user.id}',
        queryParameters: {'page': postPage.toString()}).then((data) {
      if (data != null) {
        if (data is! HttpResult) {
          morePost = List.from((data as List).map((e) => Post.fromJson(e)));
          if (morePost.isNotEmpty) {
            userPostList.addAll(morePost);
          } else {
            postHasReachedMax = true;
          }
        }
      }
    });

    await Future.delayed(Duration(seconds: 1), () {
      setState(() {});
    });
  }

  void loadMoreMeetup() async {
    meetupPage += 1;
    List<Post> moreMeetup = [];
    await ksClient.getApi('/user/meetup/by/${widget.user.id}',
        queryParameters: {'page': meetupPage.toString()}).then((data) {
      if (data != null) {
        if (data is! HttpResult) {
          moreMeetup = List.from((data as List).map((e) => Post.fromJson(e)));
          if (moreMeetup.isNotEmpty) {
            userMeetupList.addAll(moreMeetup);
          } else {
            meetupHasReachedMax = true;
          }
        }
      }
    });

    await Future.delayed(Duration(seconds: 1), () {
      setState(() {});
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
