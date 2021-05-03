import 'package:flutter/material.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/home/feed_detail_screen.dart';
import 'package:kroma_sport/views/tabs/home/widget/home_feed_cell.dart';
import 'package:kroma_sport/widgets/refresh/bottom_refresher.dart';
import 'package:kroma_sport/widgets/refresh/top_refresher.dart';

import 'widget/home_feed_cell.dart';

class HomeScreen extends StatefulWidget {
  static String tag = '/homeScreen';

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

  Widget buildHomeFeedList() {
    return SliverList(
      delegate: SliverChildListDelegate(
        List.generate(
            8,
            (index) => Column(
                  children: [
                    HomeFeedCell(
                      onCellTap: () =>
                          launchScreen(context, FeedDetailScreen.tag),
                      onLikeTap: () {},
                      onCommentTap: () =>
                          launchScreen(context, FeedDetailScreen.tag),
                      onShareTap: () {},
                      onAddCommentTap: () =>
                          launchScreen(context, FeedDetailScreen.tag),
                    ),
                    Container(
                      height: 8.0,
                    )
                  ],
                )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          buildNavbar(),
            TopRefresher(onRefresh: () {
                return new Future<void>.delayed(const Duration(seconds: 10))
                  ..then((re) {
                    // setState(() {
                    //   changeRandomList();
                    //   _scrollController.animateTo(0.0,
                    //       duration: new Duration(milliseconds: 100),
                    //       curve: Curves.bounceOut);
                    // });
                    print("==============");
                  });
              }),

          buildHomeFeedList(),
          BottomRefresher(onRefresh: () {
              return Future<void>.delayed(const Duration(seconds: 10))
                  ..then((re) {
                    // setState(() {
                    //   changeRandomList();
                    //   _scrollController.animateTo(0.0,
                    //       duration: new Duration(milliseconds: 100),
                    //       curve: Curves.bounceOut);
                    // });
                    print("==============");
                  });
          })
        ],
      ),
    );
  }
}
