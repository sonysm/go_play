import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/bloc/account.dart';
import 'package:kroma_sport/bloc/data_state.dart';
import 'package:kroma_sport/bloc/home.dart';
import 'package:kroma_sport/bloc/meetup.dart';
import 'package:kroma_sport/bloc/notify.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/option_screen.dart';
import 'package:kroma_sport/views/tabs/account/account_screen.dart';
import 'package:kroma_sport/views/tabs/home/create_post_screen.dart';
import 'package:kroma_sport/views/detail_screen.dart';
import 'package:kroma_sport/views/tabs/home/home_screen.dart';
import 'package:kroma_sport/views/tabs/meetup/meetup_screen.dart';
import 'package:kroma_sport/views/tabs/notification/notifitcation_screen.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:uni_links/uni_links.dart';
import 'package:kroma_sport/main.dart';
import 'package:kroma_sport/models/notification.dart';

class MainView extends StatefulWidget {
  static const String tag = '/mainScreen';

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  List<Widget> _screens = [
    HomeScreen(key: homeStateKey),
    MeetupScreen(),
    NotificationScreen(),
    AccountScreen(),
  ];

  List<IconData> _icons = [
    FeatherIcons.home,
    FeatherIcons.activity,
    FeatherIcons.plus,
    FeatherIcons.bell,
    FeatherIcons.user,
  ];
  int _tapIndex = 0;
  int _screenIndex = 0;

  KSHttpClient ksClient = KSHttpClient();

  StreamSubscription? _streamSubscription;
  // List<SharedMediaFile>? _sharedFiles;
  // String? _sharedText;
  dynamic _sharedInfo;

  StreamSubscription? _uniSub;

  @override
  Widget build(BuildContext context) {
    if (_sharedInfo != null) {
      return CreatePostScreen(data: _sharedInfo);
    }

    return DefaultTabController(
      length: _icons.length,
      child: Scaffold(
        body: IndexedStack(
          index: _screenIndex,
          children: _screens,
        ),
        bottomNavigationBar: Container(
          color: Theme.of(context).primaryColor,
          child: SafeArea(
            child: Container(
              height: 54.0,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                border: Border(
                  top: BorderSide(
                    color: !isLight(context) ? Colors.grey : Color(0xFF455A64),
                    width: 0.1,
                  ),
                ),
              ),
              child: _CustomTabBar(
                icons: _icons,
                selectedIndex: _tapIndex,
                onTap: (index) {
                  if (index == _tapIndex) {
                    if (_screenIndex == 0) {
                      homeStateKey.currentState!.onHomeIconTap();
                    }
                    return;
                  }

                  if (index < 2) {
                    setState(() {
                      _tapIndex = index;
                      _screenIndex = index;
                    });
                  } else if (index > 2) {
                    setState(() {
                      _tapIndex = index;
                      _screenIndex = index - 1;
                    });
                  } else {
                    showKSMainOption(context);
                  }

                  if(index == 3){ // notification
                      NotifyCubit notifyCubit = context.read<NotifyCubit>();
                      if(notifyCubit.state.badge > 0){
                          notifyCubit.tapViewNotify();
                          notifyCubit.emit(notifyCubit.state.copyWith(badge: 0));
                      }
                  }else if(index == 4){ //account
                       AccountCubit accCubit = context.read<AccountCubit>();
                       if(accCubit.state.postStatus == DataState.None){
                          accCubit.onLoad();
                       }
                  }
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
    setupFirebaseMessage();
    fetchLocation();
    initShareIntent();
    BlocProvider.of<HomeCubit>(context).onLoad();
    BlocProvider.of<MeetupCubit>(context).onLoad();

    _handleIncomingLinks();
    _handleInitialUri();
    _onNotificationInitial();
  }

  @override
  void dispose() {
    // _sharedText = null;
    _sharedInfo = null;
    if (_uniSub != null) {
      _uniSub?.cancel();
    }
    if (_streamSubscription != null) {
      _streamSubscription?.cancel();
    }
    super.dispose();
  }

  fetchLocation() async {
    if (KS.shared.currentPosition == null) {
      var service = await KS.shared.locationService.serviceEnabled();
      if (service) {
        try {
          var location = await KS.shared.locationService.getLocation();
          if (location.latitude != null && location.longitude != null) {
            KS.shared.setupLocationMintor();
          } else {}
        } catch (e) {}
      } else {}
    }
  }

  setupFirebaseMessage() {
    FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging.instance.getToken().then((token) async {
      await getDeviceDetails();
      setFCMToken(deviceToken: token!, deviceId: identifier);
    });
  }

  void setFCMToken({
    required String deviceToken,
    required String deviceId,
  }) async {
    KS.shared.deviceId = deviceId;
    var res = await ksClient.postApi(
      '/user/update/device_token',
      body: {
        'device_token': deviceToken,
        'device_id': deviceId,
      },
    );
    if (res != null) {
      if (res is! HttpResult) {}
    }
  }

  String identifier = '';

  Future<void> getDeviceDetails() async {
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        setState(() => identifier = build.androidId); //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        setState(() => identifier = data.identifierForVendor); //UUID for iOS
      }
    } on PlatformException {
      print('Failed to get platform version');
    }
  }

  void initShareIntent() {
    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    _streamSubscription = ReceiveSharingIntent.getTextStream().listen((String value) {
      if (!value.contains('v-play.cc')) {
        setState(() {
          // _sharedText = value;
          _sharedInfo = value;
        });
        // print("Shared: $value");
      }
    }, onError: (err) {
      print("getLinkStream error: $err");
    });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((String? value) {
      if (value != null && !value.contains('v-play.cc')) {
        setState(() {
          // _sharedText = value;
          _sharedInfo = value;
        });
        // print("Shared: $value");
      }
    });

    // // For sharing images coming from outside the app while the app is in the memory
    // _intentDataStreamSubscription = ReceiveSharingIntent.getMediaStream()
    //     .listen((List<SharedMediaFile> value) {
    //   if (value.isEmpty) return;
    //   setState(() {
    //     _sharedFiles = value;
    //     _sharedInfo = value;
    //     print("Shared:" + (_sharedFiles?.map((f) => f.path).join(",") ?? ""));
    //   });
    // }, onError: (err) {
    //   print("getIntentDataStream error: $err");
    // });

    // // For sharing images coming from outside the app while the app is closed
    // ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> value) {
    //   if (value.isEmpty) return;
    //   setState(() {
    //     _sharedFiles = value;
    //     _sharedInfo = value;
    //     print("Shared:" + (_sharedFiles?.map((f) => f.path).join(",") ?? ""));
    //   });
    // });
  }

  /// Handle incoming links - the ones that the app will recieve from the OS
  /// while already started.
  void _handleIncomingLinks() {
    // It will handle app links while the app is already started - be it in
    // the foreground or in the background.
    _uniSub = uriLinkStream.listen((Uri? uri) {
      if (!mounted || uri == null) return;
      _handleVplayUri(uri);
    }, onError: (Object err) {
      if (!mounted) return;
      print('got err: $err');
    });
  }

  /// Handle the initial Uri - the one the app was started with
  ///
  /// **ATTENTION**: `getInitialLink`/`getInitialUri` should be handled
  /// ONLY ONCE in your app's lifetime, since it is not meant to change
  /// throughout your app's life.
  ///
  /// We handle all exceptions, since it is called from initState.
  Future<void> _handleInitialUri() async {
    // In this example app this is an almost useless guard, but it is here to
    // show we are not going to call getInitialUri multiple times, even if this
    // was a weidget that will be disposed of (ex. a navigation route change).
    try {
      final uri = await getInitialUri();
      if (!mounted || uri == null) return;
      _handleVplayUri(uri);
    } on PlatformException {
      // Platform messages may fail but we ignore the exception
      print('falied to get initial uri');
    } on FormatException catch (err) {
      if (!mounted) return;
      print('malformed initial uri $err');
    }
  }

  _handleVplayUri(Uri uri) {
    if (uri.host == "v-play.cc") {
      final params = uri.queryParameters;
      if (params.containsKey("shared") && params.containsKey("aid")) {
        try {
          final postId = int.parse(params['aid'].toString());
          launchScreen(context, DetailScreen.tag, arguments: {'postId': postId});
        } on FormatException catch (e) {
          print(e);
        }
      }
    }
  }

  _onNotificationInitial() {
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        var jsonData = jsonDecode(message.data['content']);
        KSNotification _notification = KSNotification.fromJson(jsonData);
        if (_notification.type == KSNotificationType.like) {
          App.navigatorKey.currentState!.pushNamed(DetailScreen.tag, arguments: {'postId': _notification.post});
        } else if (_notification.type == KSNotificationType.comment) {
          App.navigatorKey.currentState!.pushNamed(DetailScreen.tag, arguments: {'postId': _notification.post});
        } else if (_notification.type == KSNotificationType.invite) {
        } else if (_notification.type == KSNotificationType.joined) {
        } else if (_notification.type == KSNotificationType.left) {}
      }
    });
  }
}

class _CustomTabBar extends StatelessWidget {
  final List<IconData> icons;
  final int selectedIndex;
  final Function(int) onTap;

  const _CustomTabBar({Key? key, required this.icons, required this.selectedIndex, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: icons
            .asMap()
            .map(
              (key, value) => MapEntry(
                key,
                Expanded(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                      ),
                      elevation: MaterialStateProperty.all(0),
                      overlayColor: MaterialStateProperty.all(Colors.transparent),
                      backgroundColor: MaterialStateProperty.all(Colors.transparent),
                    ),
                    onPressed: () => onTap(key),
                    child: Tab(
                      icon: key != 2
                          ? key != 3
                              ? Icon(value,
                                  color: key == selectedIndex
                                      ? ColorResources.getPrimaryIconColor(context)
                                      : ColorResources.getPrimaryIconColorDark(context))
                              : BlocBuilder<NotifyCubit, NotifyData>(builder: (context, state) {
                                  return Stack(
                                    children: [
                                      Icon(value,
                                          color: key == selectedIndex
                                              ? ColorResources.getPrimaryIconColor(context)
                                              : ColorResources.getPrimaryIconColorDark(context)),
                                      if (state.badge > 0)
                                        Positioned(
                                          // draw a red marble
                                          top: 0.0,
                                          right: 0.0,
                                          child: new Icon(Icons.brightness_1, size: 8.0, color: Colors.redAccent),
                                        )
                                    ],
                                  );
                                })
                          : Container(
                              width: 48.0,
                              height: 48.0,
                              decoration: BoxDecoration(
                                border: Border.all(width: 3.0, color: whiteColor),
                                shape: BoxShape.circle,
                                // color: Colors.green,
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF11998e),
                                    Color(0xFF38ef7d),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 4.0,
                                    color: Colors.black12,
                                    spreadRadius: 2.0,
                                  )
                                ],
                              ),
                              child: Icon(
                                value,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            )
            .values
            .toList(),
      ),
    );
  }
}
