import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:kroma_sport/utils/constant.dart';
import 'package:path_provider/path_provider.dart';

class MyNotification {
  static Future<void> initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize =
        new AndroidInitializationSettings('ic_notification');
    var iOSInitialize = new IOSInitializationSettings();
    var initializationsSettings = new InitializationSettings(
        android: androidInitialize, iOS: iOSInitialize);
    flutterLocalNotificationsPlugin.initialize(initializationsSettings,
        onSelectNotification: (String? payload) {
      try {} catch (e) {}

      return Future.value(1);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onMessage: ${message.data}");
      MyNotification.showNotification(
          message.data, flutterLocalNotificationsPlugin);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("onMessageApp: ${message.data}");
    });
  }

  static Future<void> showNotification(
      Map<String, dynamic> message, FlutterLocalNotificationsPlugin fln) async {
    if (message['image'] != null && message['image'].isNotEmpty) {
      try {
        await showBigPictureNotificationHiddenLargeIcon(message, fln);
      } catch (e) {
        await showBigTextNotification(message, fln);
      }
    } else {
      await showBigTextNotification(message, fln);
    }
  }

  static Future<void> showTextNotification(
      Map<String, dynamic> message, FlutterLocalNotificationsPlugin fln) async {
    String _title = message['title'];
    String _body = message['body'];
    String _orderID = message['order_id'] ?? '';
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
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

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatform);
    await fln.show(0, _title, _body, platformChannelSpecifics,
        payload: _orderID);
  }

  static Future<void> showBigTextNotification(
      Map<String, dynamic> message, FlutterLocalNotificationsPlugin fln) async {
    String _title = message['title'] ?? '';
    String _body = message['body'] ?? '';
    String _orderID = message['order_id'] ?? '';
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      _body,
      htmlFormatBigText: true,
      contentTitle: _title,
      htmlFormatContentTitle: true,
    );
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
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

    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatform);
    await fln.show(0, _title, _body, platformChannelSpecifics,
        payload: _orderID);
  }

  static Future<void> showBigPictureNotificationHiddenLargeIcon(
      Map<String, dynamic> message, FlutterLocalNotificationsPlugin fln) async {
    String _title = message['title'];
    String _body = message['body'];
    String _orderID = message['order_id'] ?? '';
    String _image = message['image'].startsWith('http')
        ? message['image']
        : '$BASE_URL/storage/app/public/notification/${message['image']}';
    final String largeIconPath =
        await _downloadAndSaveFile(_image, 'largeIcon');
    final String bigPicturePath =
        await _downloadAndSaveFile(_image, 'bigPicture');
    final BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath),
      hideExpandedLargeIcon: true,
      contentTitle: _title,
      htmlFormatContentTitle: true,
      summaryText: _body,
      htmlFormatSummaryText: true,
    );
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
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

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatform);
    await fln.show(0, _title, _body, platformChannelSpecifics,
        payload: _orderID);
  }

  static Future<String> _downloadAndSaveFile(
      String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    // final Response response = await Dio().get(url, options: Options(responseType: ResponseType.bytes));
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }
}

Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  print('background: ${message.data}');
  var androidInitialize = new AndroidInitializationSettings('ic_notification');
  var iOSInitialize = new IOSInitializationSettings();
  var initializationsSettings = new InitializationSettings(
      android: androidInitialize, iOS: iOSInitialize);
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.initialize(initializationsSettings);
  // MyNotification.showNotification(
  //     message.data, flutterLocalNotificationsPlugin);
}
