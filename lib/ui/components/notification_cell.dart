/*
 * File: notification_cell.dart
 * Project: components
 * -----
 * Created Date: Tuesday January 12th 2021
 * Author: Sony Sum
 * -----
 * Copyright (c) 2021 ERROR-DEV All rights reserved.
 */
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sport_booking/models/news.dart';

class NotificationCell extends StatelessWidget {
  const NotificationCell({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      onTap: () {
        Navigator.pushNamed(context, '/news-detail', arguments: News());
      },
      leading: CircleAvatar(
        radius: 32.0,
        backgroundColor: Color(Random().nextInt(0xffffffff)),
      ),
      title: Text('Awesome!'),
      subtitle:
          Text('Your booking has been confirmed. Click for more detail...'),
      trailing: Column(
        children: [Text('1 Jan')],
      ),
    );
  }
}
