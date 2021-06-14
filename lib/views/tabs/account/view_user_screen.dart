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
import 'package:kroma_sport/views/tabs/account/sport_activity/fav_sport_detail.dart';
import 'package:kroma_sport/views/tabs/account/widget/sport_card.dart';
import 'package:kroma_sport/views/tabs/home/widget/activity_cell.dart';
import 'package:kroma_sport/views/tabs/home/widget/home_feed_cell.dart';
import 'package:kroma_sport/views/tabs/meetup/widget/meetup_cell.dart';
import 'package:kroma_sport/widgets/avatar.dart';
import 'package:kroma_sport/widgets/ks_confirm_dialog.dart';
import 'package:kroma_sport/widgets/ks_text_button.dart';
import 'package:kroma_sport/widgets/ks_widgets.dart';
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

  late User _user;

  late TabController tabController;
  int _currentIndex = 0;

  bool isLoaded = false;

  late AnimationController animationController;
  late Animation<double> animation;

  late bool isFollow;

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
                      Text(
                        'Phnom Penh, Cambodia',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      16.height,
                      Row(
                        children: [
                          actionHeader(
                              amt: '${_user.followerCount}',
                              title: 'Followers'),
                          actionHeader(
                              amt: '${_user.followingCount}',
                              title: 'Following'),
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
                                      ? BorderSide(color: Color(0xFF1D976C))
                                      : BorderSide.none),
                            ),
                          ),
                          child: isLoaded
                              ? Text(
                                  isFollow ? 'Following' : 'Follow',
                                  style: TextStyle(
                                    color: isFollow
                                        ? Color(0xFF1D976C)
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
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            height: 32.0,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                        ),
                )
              ],
            )
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
      child: Container(
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
              )
            : buildSportShimmer(),
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
                indicatorColor: mainColor,
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

  List<Post> userPostList = [];
  List<Post> userMeetupList = [];

  Widget buildPostFeedList() {
    return isLoaded
        ? userPostList.isNotEmpty
            ? FadeTransition(
                opacity: animation,
                child: ListView.separated(
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var post = userPostList.elementAt(index);
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
                    itemCount: userPostList.length),
              )
            : SizedBox()
        : Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              margin: const EdgeInsets.only(top: 8.0),
              width: double.infinity,
              height: 400,
              color: Colors.grey[300],
            ),
          );
  }

  Widget buildMeetupList() {
    return userMeetupList.isNotEmpty
        ? ListView.separated(
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var meetup = userMeetupList.elementAt(index);

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
            itemCount: userMeetupList.length,
          )
        : SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        dismissScreen(context, _user);
        return true;
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            buildNavbar(),
            buildProfileHeader(),
            buildFavoriteSport(),
            buildFeedTabbar(),
          ],
        ),
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

    Future.delayed(Duration(milliseconds: 300)).then((_) {
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

          showKSConfirmDialog(context,
              'Are you sure you want to unfollow ${_user.getFullname()}?',
              () async {
            var res = await ksClient.postApi('/user/unfollow/${_user.id}');
            if (res != null) {
              if (res is! HttpResult) {
                _user.followerCount -= 1;
                isFollow = false;
                setState(() {});
              }
            }
          });
        },
      )
    ]);
  }
}
