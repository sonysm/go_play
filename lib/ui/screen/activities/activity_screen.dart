/*
 * File: activity_screen.dart
 * Project: activities
 * -----
 * Created Date: Thursday January 21st 2021
 * Author: Sony Sum
 * -----
 * Copyright (c) 2021 ERROR-DEV All rights reserved.
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:sport_booking/theme/color.dart';
import 'package:sport_booking/ui/components/activities/activity_cell.dart';
import 'package:sport_booking/ui/components/notification_cell.dart';
import 'package:sport_booking/ui/components/refresh_header.dart';

class ActivityScreen extends StatefulWidget {
  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
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
                title: Text('Activities',
                    style: Theme.of(context).textTheme.headline6),
                actions: [
                  IconButton(
                      icon: Icon(LineAwesomeIcons.edit_1, color: mainColor),
                      onPressed: () {
                        Navigator.pushNamed(context, '/create-activity');
                      })
                ],
              ),
              header,
              SliverPadding(
                padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Container(
                          padding: EdgeInsets.only(bottom: 16),
                          child: ActivityCell());
                    },
                    childCount: 12,
                  ),
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
