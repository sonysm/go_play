/*
 * File: notification_screen.dart
 * Project: notification
 * -----
 * Created Date: Tuesday January 12th 2021
 * Author: Sony Sum
 * -----
 * Copyright (c) 2021 ERROR-DEV All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:sport_booking/ui/components/notification_cell.dart';
import 'package:sport_booking/ui/components/refresh_header.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EasyRefresh.builder(
        onRefresh: () async {},
        onLoad: () async {},
        header: RefreshHeader(context),
        footer: RefreshFooter(context),
        builder: (context, physics, header, footer) {
          return CustomScrollView(
            physics: physics,
            primary: true,
            slivers: [
              SliverAppBar(
                floating: true,
                title: Text('Notification'),
              ),
              header,
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index % 2 != 0) {
                      return Divider(
                          height: 8.0, thickness: 0, indent: 8, endIndent: 8);
                    }
                    return NotificationCell();
                  },
                  childCount: 24,
                ),
              ),
              footer
            ],
          );
        },
      ),
    );
  }
}
