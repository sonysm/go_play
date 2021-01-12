/*
 * File: news_screen.dart
 * Project: news
 * -----
 * Created Date: Tuesday January 12th 2021
 * Author: Sony Sum
 * -----
 * Copyright (c) 2021 ERROR-DEV All rights reserved.
 */
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:sport_booking/ui/components/news_cell.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: EasyRefresh.builder(
            onRefresh: () async {},
            header: ClassicalHeader(
                textColor: Theme.of(context).textTheme.bodyText1.color,
                infoText: ''),
            builder: (context, physic, header, footer) {
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    floating: true,
                    title: Text('Notification'),
                  ),
                  header,
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return NewsCell();
                      },
                      childCount: 12,
                    ),
                  ),
                ],
              );
            }));
  }
}
