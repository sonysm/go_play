import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:kroma_sport/bloc/data_state.dart';
import 'package:kroma_sport/bloc/home.dart';
import 'package:kroma_sport/bloc/user.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/models/post.dart';
import 'package:kroma_sport/models/user.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/ks_images.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/home/create_activity_screen.dart';
import 'package:kroma_sport/views/tabs/home/create_post_screen.dart';
import 'package:kroma_sport/views/tabs/home/widget/activity_cell.dart';
import 'package:kroma_sport/views/tabs/home/widget/home_feed_cell.dart';
import 'package:kroma_sport/views/tabs/notification/notifitcation_screen.dart';
import 'package:kroma_sport/widgets/avatar.dart';
import 'package:kroma_sport/widgets/ks_widgets.dart';
import 'package:permission_handler/permission_handler.dart';

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
      title: InkWell(
        onTap: scrollToBottom,
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        child: SizedBox(
          height: 24.0,
          child: Image.asset(
            imgVplayText,
            color: mainColor,
          ),
        ),
      ),
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
      floating: true,
      automaticallyImplyLeading: false,
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
                      ),
                    ],
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: addPhoto,
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(isLight(context)
                          ? Colors.grey[100]
                          : Colors.blueGrey[300]),
                      foregroundColor: MaterialStateProperty.all(
                          isLight(context) ? mainColor : Colors.greenAccent),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(FeatherIcons.camera),
                        8.width,
                        Text(
                          'Post',
                          style:
                              Theme.of(context).textTheme.bodyText1?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: isLight(context)
                                        ? mainColor
                                        : Colors.greenAccent,
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
                      overlayColor: MaterialStateProperty.all(isLight(context)
                          ? Colors.grey[100]
                          : Colors.blueGrey[300]),
                      foregroundColor: MaterialStateProperty.all(
                          isLight(context) ? mainColor : Colors.greenAccent),
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
                                    color: isLight(context)
                                        ? mainColor
                                        : Colors.greenAccent,
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
    if (feedData.status == DataState.ErrorSocket && feedData.data.isEmpty) {
      return SliverFillRemaining(
        child: noConnection(context),
      );
    }

    return feedData.status == DataState.Loading
        ? loadingSliver()
        : SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                var post = feedData.data.elementAt(index);

                if (post.type == PostType.feed) {
                  String? _urlInfo;
                  if (post.description != null) {
                    final urlMatches = urlRegExp.allMatches(post.description!);

                    List<String> urls = urlMatches
                        .map((urlMatch) => post.description!
                            .substring(urlMatch.start, urlMatch.end))
                        .toList();
                    // urls.forEach((x) => print(x));
                    if (urls.isNotEmpty) {
                      _urlInfo = urls.elementAt(0);

                      if (!_urlInfo.startsWith(_protocolIdentifierRegex)) {
                        _urlInfo = (LinkifyOptions().defaultToHttps
                                ? "https://"
                                : "http://") +
                            _urlInfo;
                      }
                    }
                  }

                  return Column(
                    children: [
                      HomeFeedCell(post: post),
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

  Widget noInternet() {
    return SliverFillRemaining(
      child: noConnection(context),
    );
  }

  ScrollController _homeScrollController = ScrollController();

  void scrollToBottom() {
    Future.delayed(Duration(milliseconds: 300)).then((value) {
      _homeScrollController.animateTo(
        _homeScrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  final RegExp urlRegExp = RegExp(
    r"((https?:www\.)|(https?:\/\/)|(www\.))?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?",
    caseSensitive: false,
  );

  final _protocolIdentifierRegex = RegExp(
    r'^(https?:\/\/)',
    caseSensitive: false,
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeData>(
      builder: (context, state) {
        return Scaffold(
          // appBar: AppBar(
          //   title: InkWell(
          //     onTap: scrollToBottom,
          //     child: SizedBox(
          //       height: 24.0,
          //       child: Image.asset(
          //         imgVplayText,
          //         color: mainColor,
          //       ),
          //     ),
          //   ),
          //   elevation: 0.0,
          //   actions: [
          //     CupertinoButton(
          //       child: Icon(FeatherIcons.bell,
          //           color: Theme.of(context).brightness == Brightness.light
          //               ? Colors.grey[600]
          //               : whiteColor),
          //       onPressed: () => launchScreen(context, NotificationScreen.tag),
          //     ),
          //   ],
          // ),
          backgroundColor: Theme.of(context).primaryColor,
          body: SafeArea(
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: EasyRefresh.custom(
                scrollController: _homeScrollController,
                header: MaterialHeader(
                  valueColor: AlwaysStoppedAnimation<Color>(mainColor),
                ),
                footer: ClassicalFooter(
                  enableInfiniteLoad: false,
                  completeDuration: Duration(milliseconds: 1200),
                ),
                slivers: [
                  buildNavbar(),
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
                  await Future.delayed(Duration(milliseconds: 300));
                  BlocProvider.of<HomeCubit>(context).onLoadMore();
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Future<bool> checkAndRequestPhotoPermissions() async {
    PermissionStatus photoPermission = await Permission.photos.status;
    if (photoPermission != PermissionStatus.granted) {
      var status = await Permission.photos.request().isGranted;
      return status;
    } else {
      return true;
    }
  }

  void addPhoto() async {
    if (Platform.isIOS) {
      launchScreen(context, CreatePostScreen.tag);
    } else {
      var permission = await checkAndRequestPhotoPermissions();
      if (permission) {
        launchScreen(context, CreatePostScreen.tag);
      } else {
        _showPhotoAlert();
      }
    }
  }

  _showPhotoAlert() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Photo disable'),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
            content: Text(
              'Please enable your photo.',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    AppSettings.openAppSettings();
                  },
                  child: Text('Open setting')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Not now'))
            ],
          );
        });
  }
}
