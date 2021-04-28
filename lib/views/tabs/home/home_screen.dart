import 'package:flutter/material.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/home/feed_detail_screen.dart';
import 'package:kroma_sport/views/tabs/home/widget/home_feed_cell.dart';

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
          buildHomeFeedList(),
        ],
      ),
    );
  }
}
