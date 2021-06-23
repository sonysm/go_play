import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:kroma_sport/bloc/home.dart';
import 'package:kroma_sport/bloc/meetup.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/account/account_screen.dart';
import 'package:kroma_sport/views/tabs/home/home_screen.dart';
import 'package:kroma_sport/views/tabs/meetup/meetup_screen.dart';
import 'package:kroma_sport/views/tabs/meetup/organize_list_screen.dart';
import 'package:kroma_sport/views/tabs/venue/venue_screen.dart';
import 'package:kroma_sport/widgets/ks_text_button.dart';
import 'package:kroma_sport/widgets/ks_widgets.dart';

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

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  Widget build(BuildContext context) {
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
    // setupLocalNotification();
    fetchLocation();
    BlocProvider.of<HomeCubit>(context).onLoad();
    BlocProvider.of<MeetupCubit>(context).onLoad();
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
    FirebaseMessaging.instance.getToken().then((token) {
      // Todo update token
      print('___fcm: $token');
    });
  }

  setupLocalNotification() async {
    var android = new AndroidInitializationSettings('ic_notification');
    var ios = new IOSInitializationSettings();
    var platform = new InitializationSettings(android: android, iOS: ios);
    flutterLocalNotificationsPlugin.initialize(platform);
  }

  Future<void> showLocalNotification(
      RemoteNotification notification, Map<String, dynamic> data) async {
    AndroidNotification androidNotification = notification.android!;
    // AppleNotification appleNotification = notification.apple!;

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.max,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    if (notification != null && androidNotification != null) {
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              icon: androidNotification.smallIcon,
              // other properties...
            ),
          ));
    }

    // const AndroidNotificationDetails android = AndroidNotificationDetails(
    //   'channel ID',
    //   "CHANNLE NAME",
    //   "channelDescription",
    //   importance: Importance.max,
    //   priority: Priority.high,
    //   ongoing: false,
    //   autoCancel: true,
    // );

    // const IOSNotificationDetails iOS = IOSNotificationDetails(
    //   presentAlert: true,
    //   presentBadge: true,
    //   presentSound: true,
    // );
    // const NotificationDetails platform =
    //     NotificationDetails(android: android, iOS: iOS);

    // await flutterLocalNotificationsPlugin.show(
    //     notification.hashCode, notification.title, notification.body, platform);
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
