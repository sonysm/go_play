import 'package:flutter/material.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/models/user.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/account/account_screen.dart';
import 'package:kroma_sport/views/tabs/account/view_user_screen.dart';
import 'package:kroma_sport/widgets/avatar.dart';

class FollowScreen extends StatefulWidget {
  static const tag = '/followScreen';

  final User? user;

  FollowScreen({Key? key, this.user}) : super(key: key);

  @override
  _FollowScreenState createState() => _FollowScreenState();
}

class _FollowScreenState extends State<FollowScreen> {
  KSHttpClient ksClient = KSHttpClient();

  late User _user;
  bool isLoaded = false;

  List<User> followerList = [];
  List<User> followingList = [];

  String followerTitle = 'Follower';
  String followingTitle = 'Following';

  Widget buildFollowerTab() {
    return isLoaded
        ? followerList.isNotEmpty
            ? Container(
                color: Theme.of(context).primaryColor,
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 8.0),
                  itemBuilder: (context, index) {
                    final user = followerList[index];
                    return FollowCell(user: user);
                  },
                  itemCount: followerList.length,
                ),
              )
            : Container(
                color: Theme.of(context).primaryColor,
                child: Center(
                  child: Text('No follower'),
                ),
              )
        : SizedBox();
  }

  Widget buildFollowingTab() {
    return isLoaded
        ? followingList.isNotEmpty
            ? Container(
                color: Theme.of(context).primaryColor,
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 8.0),
                  itemBuilder: (context, index) {
                    final user = followingList[index];
                    return FollowCell(user: user);
                  },
                  itemCount: followingList.length,
                ),
              )
            : Container(
                color: Theme.of(context).primaryColor,
                child: Center(
                  child: Text('No following'),
                ),
              )
        : SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('${_user.getFullname()}'),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size(double.infinity, 30),
            child: Align(
              alignment: Alignment.centerLeft,
              child: IgnorePointer(
                ignoring: !isLoaded,
                child: TabBar(
                  labelStyle: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Metropolis',
                  ),
                  indicatorColor:
                      isLight(context) ? mainColor : Colors.greenAccent,
                  indicatorWeight: 1.0,
                  tabs: [
                    Tab(text: followerTitle),
                    Tab(text: followingTitle),
                  ],
                  onTap: (index) {},
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            buildFollowerTab(),
            buildFollowingTab(),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _user = widget.user ?? KS.shared.user;
    getFollow();
  }

  void getFollow() async {
    var followerRes = await ksClient.getApi('/user/follower/${_user.id}');
    if (followerRes != null) {
      if (followerRes is! HttpResult) {
        followerList =
            List.from(followerRes.map((e) => User.fromJson(e['follower'])));
      }
    }

    var followingRes = await ksClient.getApi('/user/following/${_user.id}');
    if (followingRes != null) {
      if (followingRes is! HttpResult) {
        followingList =
            List.from(followingRes.map((e) => User.fromJson(e['following'])));
      }
    }

    isLoaded = true;
    if (followerList.isNotEmpty) {
      followerTitle = followerList.length > 1
          ? '${followerList.length} Followers'
          : '1 Follower';
    }
    if (followingList.isNotEmpty) {
      followingTitle = '${followingList.length} Following';
    }

    await Future.delayed(Duration(milliseconds: 300));
    setState(() {});
  }
}

class FollowCell extends StatelessWidget {
  const FollowCell({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (user.id == KS.shared.user.id) {
            launchScreen(context, AccountScreen.tag);
          } else {
            launchScreen(context, ViewUserProfileScreen.tag, arguments: user);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          child: Row(
            children: [
              Avatar(radius: 24, user: user, isSelectable: false),
              8.width,
              Text(
                user.getFullname(),
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    fontFamily: 'ProximaNova', fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
