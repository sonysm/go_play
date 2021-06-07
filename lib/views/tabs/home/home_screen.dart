import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:kroma_sport/bloc/data_state.dart';
import 'package:kroma_sport/bloc/home.dart';
import 'package:kroma_sport/bloc/user.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/models/post.dart';
import 'package:kroma_sport/models/user.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/home/create_activity_screen.dart';
import 'package:kroma_sport/views/tabs/home/create_post_screen.dart';
import 'package:kroma_sport/views/tabs/home/widget/activity_cell.dart';
import 'package:kroma_sport/views/tabs/home/widget/home_feed_cell.dart';
import 'package:kroma_sport/views/tabs/notification/notifitcation_screen.dart';
import 'package:kroma_sport/widgets/avatar.dart';

import 'widget/home_feed_cell.dart';

class HomeScreen extends StatefulWidget {
  static const String tag = '/homeScreen';

  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget buildNavbar() {
    return SliverAppBar(
      title: Text('Home'),
      elevation: 0,
      pinned: true,
    );
  }

  Widget createFeedWidget() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 0.0),
        margin: const EdgeInsets.only(bottom: 8.0),
        color: Theme.of(context).primaryColor,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<UserCubit, User>(
                  builder: (context, user) {
                    return Avatar(
                      radius: 24.0,
                      user: user,
                    );
                  },
                ),
                8.width,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'What\'s going on ${KS.shared.user.getFullname()}',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Text(
                        'Share a photo, post or activity with your followers.',
                        style: Theme.of(context).textTheme.bodyText2,
                      )
                    ],
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => launchScreen(context, CreatPostScreen.tag),
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(Colors.grey[200]),
                      foregroundColor: MaterialStateProperty.all(mainColor),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(FeatherIcons.camera),
                        8.width,
                        Text(
                          'Photo',
                          style:
                              Theme.of(context).textTheme.bodyText1?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: mainColor,
                                    fontSize: 18.0,
                                    fontFamily: 'ProximaNova',
                                  ),
                          strutStyle: StrutStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () =>
                        launchScreen(context, CreateActivityScreen.tag),
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(Colors.grey[200]),
                      foregroundColor: MaterialStateProperty.all(mainColor),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(FeatherIcons.activity),
                        8.width,
                        Text(
                          'Activity',
                          style:
                              Theme.of(context).textTheme.bodyText1?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18.0,
                                    color: mainColor,
                                    fontFamily: 'ProximaNova',
                                  ),
                          strutStyle: StrutStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildHomeFeedList(HomeData feedData) {
    return feedData.status == DataState.Loading
        ? loadingSliver()
        : SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                var post = feedData.data.elementAt(index);
                if (post.type == PostType.feed) {
                  return Column(
                    children: [
                      HomeFeedCell(
                        post: post,
                      ),
                      Container(
                        height: 8.0,
                      )
                    ],
                  );
                } else if (post.type == PostType.activity) {
                  return Column(
                    children: [
                      ActivityCell(post: post),
                      Container(height: 8.0),
                    ],
                  );
                }
                return SizedBox();
              },
              childCount: feedData.data.length,
            ),
          );
  }

  Widget loadingSliver() {
    return SliverFillRemaining(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeData>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Home'),
            elevation: 0.0,
            actions: [
              CupertinoButton(
                child: Icon(FeatherIcons.bell,
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.grey[600]
                        : whiteColor),
                onPressed: () => launchScreen(context, NotificationScreen.tag),
              ),
            ],
          ),
          body: EasyRefresh.custom(
            header: MaterialHeader(
              valueColor: AlwaysStoppedAnimation<Color>(mainColor),
            ),
            footer: ClassicalFooter(
              enableInfiniteLoad: false,
              completeDuration: Duration(milliseconds: 1200),
            ),
            slivers: [
              createFeedWidget(),
              buildHomeFeedList(state),
              //BottomRefresher(onRefresh: () {
              //    return Future<void>.delayed(const Duration(seconds: 10))
              //        ..then((re) {
              //          // setState(() {
              //          //   changeRandomList();
              //          //   _scrollController.animateTo(0.0,
              //          //       duration: new Duration(milliseconds: 100),
              //          //       curve: Curves.bounceOut);
              //          // });
              //          print("==============");
              //        });
              //}),
            ],
            onRefresh: () async {
              BlocProvider.of<HomeCubit>(context).onRefresh();
            },
            onLoad: () async {
              await Future.delayed(Duration(seconds: 2));
            },
          ),
        );
      },
    );
  }
}
