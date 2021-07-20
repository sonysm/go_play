import 'dart:async';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/bloc/home.dart';
import 'package:kroma_sport/bloc/meetup.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/account/account_screen.dart';
import 'package:kroma_sport/views/tabs/home/create_post_screen.dart';
import 'package:kroma_sport/views/tabs/home/home_screen.dart';
import 'package:kroma_sport/views/tabs/meetup/meetup_screen.dart';
import 'package:kroma_sport/views/tabs/meetup/organize_list_screen.dart';
import 'package:kroma_sport/views/tabs/venue/venue_screen.dart';
import 'package:kroma_sport/widgets/ks_text_button.dart';
import 'package:kroma_sport/widgets/ks_widgets.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class MainView extends StatefulWidget {
  static const String tag = '/mainScreen';

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  List<Widget> _screens = [
    HomeScreen(),
    MeetupScreen(),
    VenueScreen(),
    AccountScreen()
  ];

  List<IconData> _icons = [
    FeatherIcons.home,
    FeatherIcons.activity,
    FeatherIcons.plus,
    FeatherIcons.grid,
    FeatherIcons.user,
  ];
  int _tapIndex = 0;
  int _screenIndex = 0;

  KSHttpClient ksClient = KSHttpClient();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

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
              //color: Theme.of(context).primaryColor,
              height: 54.0,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                border: Border(
                  top: BorderSide(
                    color: isLight(context) ? Colors.grey : Color(0xFF455A64),
                    width: 0.1,
                  ),
                ),
              ),
              child: _CustomTabBar(
                icons: _icons,
                selectedIndex: _tapIndex,
                onTap: (index) {
                  if (index == _tapIndex) {
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
                    createActivityScreen();
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
    setupLocalNotification();
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
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return SafeArea(
          maintainBottomViewPadding: true,
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                bottomSheetBar(context),
                KSTextButtonBottomSheet(
                  title: 'Organize activity',
                  icon: Feather.activity,
                  onTab: () {
                    dismissScreen(context);
                    launchScreen(context, OrganizeListScreen.tag);
                  },
                ),
                Divider(indent: 16.0, endIndent: 16.0, height: 0),
                50.height,
              ],
            ),
          ),
        );
      },
    );
  }

  setupFirebaseMessage() {
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print('remote_message: ${message.category}');
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification!;
      showLocalNotification(notification, message.data);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      print("____onMessageOpenedApp____: $message");
      //serializeAndNavigate(message.data);
    });

    FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging.instance.getToken().then((token) async {
      await getDeviceDetails();
      // print('___device id: $identifier'); //af64cdb1c8f2f5d3
      // Todo update token
      // print('___fcm: $token');
      setFCMToken(deviceToken: token!, deviceId: identifier);
    });
  }

  void setFCMToken({
    required String deviceToken,
    required String deviceId,
  }) async {
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

  setupLocalNotification() async {
    var android = new AndroidInitializationSettings('ic_notification');
    var ios = new IOSInitializationSettings();
    var platform = new InitializationSettings(android: android, iOS: ios);
    flutterLocalNotificationsPlugin.initialize(platform);
  }

  Future<void> showLocalNotification(
      RemoteNotification notification, Map<String, dynamic> data) async {
    // AndroidNotification androidNotification = notification.android!;
    // AppleNotification appleNotification = notification.apple!;

    // const AndroidNotificationChannel channel = AndroidNotificationChannel(
    //   'high_importance_channel', // id
    //   'High Importance Notifications', // title
    //   'This channel is used for important notifications.', // description
    //   importance: Importance.max,
    // );

    // await flutterLocalNotificationsPlugin
    //     .resolvePlatformSpecificImplementation<
    //         AndroidFlutterLocalNotificationsPlugin>()
    //     ?.createNotificationChannel(channel);

    // if (notification != null && androidNotification != null) {
    //   flutterLocalNotificationsPlugin.show(
    //       notification.hashCode,
    //       notification.title,
    //       notification.body,
    //       NotificationDetails(
    //         android: AndroidNotificationDetails(
    //           channel.id,
    //           channel.name,
    //           channel.description,
    //           icon: androidNotification.smallIcon,
    //           // other properties...
    //         ),
    //       ));
    // }

    const AndroidNotificationDetails android = AndroidNotificationDetails(
      'channel ID',
      "CHANNLE NAME",
      "channelDescription",
      importance: Importance.max,
      priority: Priority.high,
      ongoing: false,
      autoCancel: true,
    );

    const IOSNotificationDetails iOS = IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const NotificationDetails platform =
        NotificationDetails(android: android, iOS: iOS);

    await flutterLocalNotificationsPlugin.show(
        notification.hashCode, notification.title, notification.body, platform);
  }

  String identifier = '';

  Future<void> getDeviceDetails() async {
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        setState(() {
          identifier = build.androidId;
        });
        //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        setState(() {
          identifier = data.identifierForVendor;
        }); //UUID for iOS
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
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
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

  const _CustomTabBar(
      {Key? key,
      required this.icons,
      required this.selectedIndex,
      required this.onTap})
      : super(key: key);

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
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0)),
                      ),
                      elevation: MaterialStateProperty.all(0),
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent),
                    ),
                    onPressed: () => onTap(key),
                    child: Tab(
                      icon: key != 2
                          ? Icon(value,
                              color: key == selectedIndex
                                  ? isLight(context)
                                      ? mainColor
                                      : Colors.greenAccent
                                  : isLight(context)
                                      ? darkColor
                                      : whiteColor)
                          : Container(
                              height: 40,
                              width: 40,
                              child: Material(
                                shape: CircleBorder(
                                    side: BorderSide(
                                        width: 0, color: Colors.transparent)),
                                clipBehavior: Clip.hardEdge,
                                color: isLight(context)
                                    ? mainColor
                                    : Colors.greenAccent,
                                child: Icon(
                                  value,
                                  color: Colors.white,
                                ),
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

class ShareIntentTest extends StatelessWidget {
  const ShareIntentTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Share'),
        leading: TextButton(
          onPressed: () {
            SystemNavigator.pop();
          },
          child: Text(
            'Cancel',
          ),
        ),
      ),
      body: Container(
          child: Center(
        child: ElevatedButton(
          onPressed: () {
            SystemNavigator.pop();
          },
          child: Text('Done'),
        ),
      )),
    );
  }
}
