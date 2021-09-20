import 'dart:async';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/bloc/home.dart';
import 'package:kroma_sport/bloc/meetup.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/option_screen.dart';
import 'package:kroma_sport/views/tabs/account/account_screen_new.dart';
import 'package:kroma_sport/views/tabs/home/create_post_screen.dart';
import 'package:kroma_sport/views/tabs/home/home_screen.dart';
import 'package:kroma_sport/views/tabs/meetup/meetup_screen.dart';
import 'package:kroma_sport/views/tabs/meetup/organize_list_screen.dart';
import 'package:kroma_sport/views/tabs/notification/notifitcation_screen.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class MainView extends StatefulWidget {
  static const String tag = '/mainScreen';

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  List<Widget> _screens = [HomeScreen(key: homeStateKey,), MeetupScreen(), NotificationScreen(), AccountScreen2()];

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

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

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
                    // createActivityScreen();
                    showKSMainOption(context);
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
    // setupLocalNotification();
    fetchLocation();
    initShareIntent();
    BlocProvider.of<HomeCubit>(context).onLoad();
    BlocProvider.of<MeetupCubit>(context).onLoad();
  }

  @override
  void dispose() {
    _sharedText = null;
    _sharedInfo = null;
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

  void createActivityScreen() {
    launchScreen(context, OrganizeListScreen.tag);
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

  late StreamSubscription _intentDataStreamSubscription;
  List<SharedMediaFile>? _sharedFiles;
  String? _sharedText;
  dynamic _sharedInfo;

  void initShareIntent() {
    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    _intentDataStreamSubscription = ReceiveSharingIntent.getTextStream().listen((String value) {
      setState(() {
        _sharedText = value;
        _sharedInfo = value;
        print("Shared: $_sharedText");
      });
    }, onError: (err) {
      print("getLinkStream error: $err");
    });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((String? value) {
      setState(() {
        _sharedText = value;
        _sharedInfo = value;
        print("Shared: $_sharedText");
      });
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
                            ? Icon(value,
                                color: key == selectedIndex
                                    ? ColorResources.getPrimaryIconColor(context)
                                    : ColorResources.getPrimaryIconColorDark(context))
                            :
                            // Container(
                            //     height: 40,
                            //     width: 40,
                            //     child: Material(
                            //       shape: CircleBorder(
                            //           side: BorderSide(
                            //               width: 0, color: Colors.transparent)),
                            //       clipBehavior: Clip.hardEdge,
                            //       color:
                            //           ColorResources.getPrimaryIconColor(context),
                            //       child: Icon(
                            //         value,
                            //         color: Colors.white,
                            //       ),
                            //     ),
                            //   ),

                            Container(
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
                                )
                                // ElevatedButton(
                                //   onPressed: onPressed,
                                //   style: ButtonStyle(
                                //     padding: MaterialStateProperty.all(EdgeInsetsDirectional.all(10.0)),
                                //     backgroundColor: MaterialStateProperty.all(Colors.transparent),
                                //     shape: MaterialStateProperty.all(CircleBorder()),
                                //     elevation: MaterialStateProperty.all(0),
                                //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                //   ),
                                //   child: Icon(
                                //     value,
                                //     color: Colors.white,
                                //   ),
                                // ),
                                )),
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
