import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:kroma_sport/api/api_checker.dart';
import 'package:kroma_sport/bloc/data_state.dart';
import 'package:kroma_sport/bloc/home.dart';
import 'package:kroma_sport/bloc/suggestion.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/home/create_activity_screen.dart';
import 'package:kroma_sport/views/tabs/home/create_post_screen.dart';
import 'package:kroma_sport/views/tabs/home/widget/home_appbar.dart';
import 'package:kroma_sport/views/tabs/home/widget/sliver_create_feed.dart';
import 'package:kroma_sport/views/tabs/home/widget/sliver_home_feed_list.dart';
import 'package:kroma_sport/views/tabs/home/widget/suggestion_cell.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  static const String tag = '/homeScreen';

  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

GlobalKey<_HomeScreenState> homeStateKey = GlobalKey();

class _HomeScreenState extends State<HomeScreen> {
  ScrollController _homeScrollController = ScrollController();
  EasyRefreshController _easyRefreshController = EasyRefreshController();

  late HomeCubit _homeCubit;
  late SuggestionCubit _suggestionCubit;

  //final RegExp urlRegExp = RegExp(
  //  r"((https?:www\.)|(https?:\/\/)|(www\.))?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?",
  //  caseSensitive: false,
  //);

  //final _protocolIdentifierRegex = RegExp(
  //  r'^(https?:\/\/)',
  //  caseSensitive: false,
  //);

  void scrollToTop() {
    Future.delayed(Duration.zero).then((value) {
      _homeScrollController.animateTo(
        _homeScrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 200),
        curve: Curves.fastLinearToSlowEaseIn,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeData>(
      listener: (context, state) {
        ApiChecker.checkApi(context, state.status);
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarIconBrightness: isLight(context) ? Brightness.dark : Brightness.light,
          systemNavigationBarColor: isLight(context) ? Color.fromRGBO(113, 113, 113, 1) : Color.fromRGBO(15, 15, 15, 1),
        ),
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          body: SafeArea(
            child: Container(
              color: ColorResources.getSecondaryBackgroundColor(context),
              child: BlocBuilder<HomeCubit, HomeData>(
                builder: (context, state) {
                  return EasyRefresh.custom(
                    scrollController: _homeScrollController,
                    controller: _easyRefreshController,
                    bottomBouncing: state.status != DataState.ErrorSocket,
                    header: MaterialHeader(
                      valueColor: AlwaysStoppedAnimation<Color>(mainColor),
                    ),
                    footer: ClassicalFooter(
                      enableInfiniteLoad: state.status == DataState.NoMore ? false : true,
                      // completeDuration: Duration(milliseconds: 1200),
                    ),
                    slivers: [
                      HomeAppBar(onTap: scrollToTop),
                      SliverCreateFeed(
                        onPost: addPhoto,
                        onActivity: () => launchScreen(context, CreateActivityScreen.tag),
                      ),
                      SliverToBoxAdapter(child: SuggestionCell()),
                      SliverHomeFeedList(homeState: state),
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
                      // await Future.delayed(Duration(milliseconds: 300));
                      _suggestionCubit.onLoad();
                      HomeData data = await _homeCubit.onRefresh();
                      _homeCubit.emit(data);
                    },
                    onLoad: state.status != DataState.NoMore
                        ? () async {
                            var data = await _homeCubit.onLoadMore();
                            _homeCubit.emit(data);
                          }
                        : null,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _homeCubit = context.read<HomeCubit>();
    _suggestionCubit = context.read<SuggestionCubit>();
    _suggestionCubit.onLoad();
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
            contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
            content: Text(
              'Please enable your photo.',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
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

  void onHomeIconTap() {
    if (_homeScrollController.offset > 500) {
      Future.delayed(Duration.zero).then((value) {
        _homeScrollController.animateTo(
          _homeScrollController.position.minScrollExtent,
          duration: Duration(milliseconds: 1000),
          curve: Curves.easeInOut,
        );
        _easyRefreshController.callRefresh();
      });
    }
  }
}
