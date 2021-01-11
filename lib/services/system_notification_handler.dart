import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sport_booking/models/notification.dart';

class NotificationHandler {
  final BuildContext context;
  final FirebaseMessaging _firebaseMessaging;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationHandler(this.context, this._firebaseMessaging) {
    _initialLocalNotification();
    _firebaseMessaging
        .requestNotificationPermissions(const IosNotificationSettings(
      sound: true,
      badge: true,
      alert: true,
    ));

    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });

    _firebaseMessaging.configure(
      onMessage: _onMessage,
      onLaunch: _onLaunch,
      onResume: _onResume,
      // onBackgroundMessage: _onBackgroundMessage
    );
  }

  _initialLocalNotification() async {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: _onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: _onSelectNotification);
  }

  _prepareNotification(Map<String, dynamic> message) {
    String title = '';
    String boby = '';
    String payload = '';

    if (Platform.isIOS) {
      title = message['aps']['alert']['title'] ?? '';
      boby = message['aps']['alert']['body'] ?? '';
      if (message['type'] != null) {
        Map<String, dynamic> pl = {'type': message['type']};
        if (message['data'] != null) {
          pl['data'] = message['data'];
        }
        payload = jsonEncode(pl);
      }
    } else {
      title = message['notification']['title'] ?? '';
      boby = message['notification']['body'] ?? '';
      payload = jsonEncode(message['data']);
    }

    showNotification(title: title, message: boby, payload: payload);
  }

  showNotification({String title, String message, String payload = ''}) async {
    if (_flutterLocalNotificationsPlugin == null) return;

    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'com.itsumo.thefresh',
      'the_fresh',
      'THE fresh',
      importance: Importance.max,
      priority: Priority.high,
      ongoing: true,
      autoCancel: true,
      vibrationPattern: vibrationPattern,
      enableLights: true,
      playSound: true,
      ticker: 'ticker',
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
        Random().nextInt(100), title, message, platformChannelSpecifics,
        payload: payload);
  }

  Future<dynamic> _onDidReceiveLocalNotification(
      int id, String title, String body, String payload) {
    print("________Receive_Notification____________");
    return Future.value(true);
  }

  Future<dynamic> _onSelectNotification(String payload) {
    Map<String, dynamic> data;

    try {
      data = json.decode(payload);
    } catch (e) {}

    if (data != null) {
      String type = data['type'];
      switch (type) {
        case 'NEW_MESSAGE':
          break;
        case 'SUB_SUCCESS':
          try {
            // var d = jsonDecode(data['data']);
            // List<int> ids = List.from(d['ids']);
            Navigator.of(context).pushNamed('/my-order');
          } catch (e) {}
          break;

        case 'SHCEDULE_DELIVERY':
          try {
            Map<String, dynamic> d = jsonDecode(data['data']);
            int subId = int.parse(d['id'].toString());
            // Navigator.of(context).pushNamed('/my-order/order-details',
            //     arguments: Subscription(id: subId));
          } catch (e) {
            print(e);
          }
          break;

        case 'NOTIFICATION':
          try {
            //name_c
            Map<String, dynamic> d = jsonDecode(data['data']);
            int nId = int.parse(d['n_id'].toString());
            var notif = SNotification();
            Navigator.of(context).pushNamed(
                '/home/notification/notification-detail',
                arguments: notif);
          } catch (e) {
            print(e);
          }
          break;

        default:
          break;
      }
    }

    print("________Select_Notification____________");
    return Future.value(true);
  }

  Future<dynamic> _onMessage(Map<String, dynamic> message) {
    _prepareNotification(message);
    return Future.value(true);
  }

  static Future<dynamic> _onBackgroundMessage(Map<String, dynamic> message) {
    return Future.value(true);
  }

  Future<dynamic> _onLaunch(Map<String, dynamic> message) {
    return Future.value(true);
  }

  Future<dynamic> _onResume(Map<String, dynamic> message) {
    return Future.value(true);
  }
}
