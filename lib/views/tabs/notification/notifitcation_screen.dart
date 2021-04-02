import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  static String tag = '/notificationScreen';

  NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  Widget buildNavbar() {
    return SliverAppBar(
      title: Text('Notification'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [buildNavbar()],
      ),
    );
  }
}
