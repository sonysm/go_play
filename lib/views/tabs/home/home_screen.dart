import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/bloc/data_state.dart';
import 'package:kroma_sport/bloc/home.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/models/post.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/home/create_post_screen.dart';
import 'package:kroma_sport/views/tabs/home/feed_detail_screen.dart';
import 'package:kroma_sport/views/tabs/home/widget/home_feed_cell.dart';
import 'package:kroma_sport/widgets/avatar.dart';
import 'package:kroma_sport/widgets/ks_confirm_dialog.dart';
import 'package:kroma_sport/widgets/ks_loading.dart';
import 'package:kroma_sport/widgets/refresh/bottom_refresher.dart';

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
                  user: KS.shared.user,
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
                        onCellTap: () => launchFeedDetailScreen(post),
                        onLikeTap: () {},
                        onCommentTap: () => launchFeedDetailScreen(post),
                        onShareTap: () {},
                        onAddCommentTap: () => launchFeedDetailScreen(post),
                        onMoreTap: () => showOptionActionBottomSheet(post),
                        post: post,
                      ),
                      Container(
                        height: 8.0,
                      )
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

  void launchFeedDetailScreen(Post post) {
    launchScreen(context, FeedDetailScreen.tag, arguments: post);
  }

  void showOptionActionBottomSheet(Post post) {
    showModalBottomSheet(
      context: context,
      //backgroundColor: Colors.transparent,
      //shape: RoundedRectangleBorder(
      //  borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      //),
      builder: (context) {
        return SafeArea(
          maintainBottomViewPadding: true,
          child: Container(
            color: Theme.of(context).primaryColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                isMe(post.owner.id)
                    ? TextButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(horizontal: 0.0)),
                        ),
                        onPressed: () {
                          dismissScreen(context);
                          showKSConfirmDialog(context,
                              'Are you sure you want to delete this post?', () {
                            deletePost(post.id);
                          });
                        },
                        child: Container(
                          height: 54.0,
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding:
                                    EdgeInsets.only(left: 16.0, right: 16.0),
                                child: Icon(
                                  Feather.trash_2,
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.blueGrey
                                      : Colors.white,
                                ),
                              ),
                              Text(
                                'Delete Post',
                                style: Theme.of(context).textTheme.bodyText1,
                              )
                            ],
                          ),
                        ),
                      )
                    : SizedBox(),
                TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(horizontal: 0.0)),
                  ),
                  onPressed: () {
                    dismissScreen(context);
                  },
                  child: Container(
                    height: 54.0,
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Icon(
                            Feather.info,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.blueGrey
                                    : Colors.white,
                          ),
                        ),
                        Text(
                          'Report Post',
                          style: Theme.of(context).textTheme.bodyText1,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  KSHttpClient ksClient = KSHttpClient();

  void deletePost(int postId) async {
    showKSLoading(context);
    var result = await ksClient.postApi('/delete/post/$postId');
    if (result != null) {
      await Future.delayed(Duration(milliseconds: 500));
      dismissScreen(context);
      if (result is! HttpResult) {
        BlocProvider.of<HomeCubit>(context).onDeletePostFeed(postId);
      }
    }
  }
}
