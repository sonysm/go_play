import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/home/create_post_screen.dart';
import 'package:kroma_sport/views/tabs/home/feed_detail_screen.dart';
import 'package:kroma_sport/views/tabs/home/widget/home_feed_cell.dart';
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
                Avatar(
                  radius: 24.0,
                  imageUrl: KS.shared.user.photo,
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
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: mainColor),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {},
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
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: mainColor),
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
      appBar: AppBar(
        title: Text('Home'),
        elevation: 0.0,
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
          buildHomeFeedList(),
        ],
        onRefresh: () async {},
        onLoad: () async {},
      ),
    );
  }
}
