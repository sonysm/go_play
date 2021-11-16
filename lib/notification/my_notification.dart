import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:kroma_sport/main.dart';
import 'package:kroma_sport/models/notification.dart';
import 'package:kroma_sport/utils/constant.dart';
import 'package:kroma_sport/views/detail_screen.dart';
import 'package:kroma_sport/views/tabs/account/view_user_screen.dart';
import 'package:kroma_sport/views/tabs/meetup/meetup_detail_screen.dart';
import 'package:kroma_sport/views/tabs/venue/booking_history_detail.dart';
import 'package:path_provider/path_provider.dart';

class MyNotification {
  static Future<void> initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize = new AndroidInitializationSettings('ic_notification');
    var iOSInitialize = new IOSInitializationSettings();
    var initializationsSettings = new InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    flutterLocalNotificationsPlugin.initialize(initializationsSettings, onSelectNotification: (String? payload) {
      try {
        if (payload != null && payload.isNotEmpty) {
          _onhandleMessage(payload);
        }
      } catch (e) {}

      return Future.value(1);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onMessage: ${message.data}");
      if (!Platform.isIOS) {
        MyNotification.showNotification(message.data, flutterLocalNotificationsPlugin);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("onMessageApp: ${message.data}");
      _onhandleMessage(message);
    });
  }

  static Future<void> showNotification(Map<String, dynamic> message, FlutterLocalNotificationsPlugin fln) async {
    if (message['image'] != null && message['image'].isNotEmpty) {
      try {
        await showBigPictureNotificationHiddenLargeIcon(message, fln);
      } catch (e) {
        await showBigTextNotification(message, fln);
      }
    } else {
      await showTextNotification(message, fln);
    }
  }

  static Future<void> showTextNotification(Map<String, dynamic> message, FlutterLocalNotificationsPlugin fln) async {
    var content = jsonDecode(message['content']);
    String _title = content['title'];
    String _body = content['body'] ?? '';

    Map _payload = {'type': content['type'], 'post': content['post']};

    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      'your channel description',
      // sound: RawResourceAndroidNotificationSound('notification'),
      importance: Importance.max,
      priority: Priority.high,
      color: Color(0xFF0BA360),
    );

    const IOSNotificationDetails iOSPlatform = IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatform);
    await fln.show(0, _title, _body, platformChannelSpecifics, payload: jsonEncode(_payload));
  }

  static Future<void> showBigTextNotification(Map<String, dynamic> message, FlutterLocalNotificationsPlugin fln) async {
    var content = jsonDecode(message['content']);
    String _title = content['title'] ?? '';
    String _body = content['body'] ?? '';
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      _body,
      htmlFormatBigText: true,
      contentTitle: _title,
      htmlFormatContentTitle: true,
    );
    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'big text channel id',
      'big text channel name',
      'big text channel description',
      importance: Importance.max,
      styleInformation: bigTextStyleInformation,
      priority: Priority.high,
      // sound: RawResourceAndroidNotificationSound('notification'),
      color: Color(0xFF0BA360),
    );

    const IOSNotificationDetails iOSPlatform = IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatform);
    await fln.show(0, _title, _body, platformChannelSpecifics, payload: message['content']);
  }

  static Future<void> showBigPictureNotificationHiddenLargeIcon(Map<String, dynamic> message, FlutterLocalNotificationsPlugin fln) async {
    var content = jsonDecode(message['content']);
    String _title = content['title'];
    String _body = content['body'];
    String _image = content['image'].startsWith('http') ? message['image'] : '$BASE_URL/storage/app/public/notification/${message['image']}';
    final String largeIconPath = await _downloadAndSaveFile(_image, 'largeIcon');
    final String bigPicturePath = await _downloadAndSaveFile(_image, 'bigPicture');
    final BigPictureStyleInformation bigPictureStyleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath),
      hideExpandedLargeIcon: true,
      contentTitle: _title,
      htmlFormatContentTitle: true,
      summaryText: _body,
      htmlFormatSummaryText: true,
    );
    final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'big text channel id',
      'big text channel name',
      'big text channel description',
      largeIcon: FilePathAndroidBitmap(largeIconPath),
      priority: Priority.high,
      color: Color(0xFF0BA360),
      // sound: RawResourceAndroidNotificationSound('notification'),
      styleInformation: bigPictureStyleInformation,
      importance: Importance.max,
    );

    const IOSNotificationDetails iOSPlatform = IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatform);
    await fln.show(0, _title, _body, platformChannelSpecifics, payload: message['content']);
  }

  static Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    // final Response response = await Dio().get(url, options: Options(responseType: ResponseType.bytes));
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  static void _onhandleMessage(dynamic message) {
    if (message is RemoteMessage) {
      var jsonData = jsonDecode(message.data['content']);
      KSNotification _notification = KSNotification.fromJson(jsonData);
      if (_notification.type == KSNotificationType.like) {
        App.navigatorKey.currentState!.pushNamed(DetailScreen.tag, arguments: {'postId': _notification.post});
      } else if (_notification.type == KSNotificationType.comment) {
        App.navigatorKey.currentState!.pushNamed(DetailScreen.tag, arguments: {'postId': _notification.post});
      } else if (_notification.type == KSNotificationType.invite) {
        App.navigatorKey.currentState!.pushNamed(MeetupDetailScreen.tag, arguments: _notification.post);
      } else if (_notification.type == KSNotificationType.joined) {
        App.navigatorKey.currentState!.pushNamed(MeetupDetailScreen.tag, arguments: _notification.post);
      } else if (_notification.type == KSNotificationType.left) {
        App.navigatorKey.currentState!.pushNamed(MeetupDetailScreen.tag, arguments: _notification.post);
      } else if (_notification.type == KSNotificationType.followed) {
        App.navigatorKey.currentState!.pushNamed(ViewUserProfileScreen.tag, arguments: {'user': _notification.actor});
      } else if (_notification.type == KSNotificationType.bookAccepted ||
          _notification.type == KSNotificationType.bookCanceled ||
          _notification.type == KSNotificationType.bookRejected) {
        App.navigatorKey.currentState!.pushNamed(BookingHistoryDetailScreen.tag, arguments: {'id': _notification.otherId});
      }
    } else {
      var jsonData = jsonDecode(message);

      if (jsonData['type'] == 1) {
        App.navigatorKey.currentState!.pushNamed(DetailScreen.tag, arguments: {'postId': jsonData['post']});
      } else if (jsonData['type'] == 2) {
        App.navigatorKey.currentState!.pushNamed(DetailScreen.tag, arguments: {'postId': jsonData['post']});
      } else if (jsonData['type'] == 3) {
        App.navigatorKey.currentState!.pushNamed(MeetupDetailScreen.tag, arguments: jsonData['post']);
      } else if (jsonData['type'] == 5) {
        App.navigatorKey.currentState!.pushNamed(MeetupDetailScreen.tag, arguments: jsonData['post']);
      } else if (jsonData['type'] == 6) {
        App.navigatorKey.currentState!.pushNamed(MeetupDetailScreen.tag, arguments: jsonData['post']);
      } else if (jsonData['type'] == 7 || jsonData['type'] == 9 || jsonData['type'] == 10) {
        App.navigatorKey.currentState!.pushNamed(BookingHistoryDetailScreen.tag, arguments: {'id': jsonData['post']});
      }
    }
  }
}

Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  print('background: ${message.data}');
  var androidInitialize = new AndroidInitializationSettings('ic_notification');
  var iOSInitialize = new IOSInitializationSettings();
  var initializationsSettings = new InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.initialize(initializationsSettings);
  //MyNotification.showNotification(message.data, flutterLocalNotificationsPlugin);
}
