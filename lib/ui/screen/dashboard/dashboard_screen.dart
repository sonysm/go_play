/*
 * File: dashboard_screen.dart
 * Project: dashboard
 * -----
 * Created Date: Tuesday January 12th 2021
 * Author: Sony Sum
 * -----
 * Copyright (c) 2021 ERROR-DEV All rights reserved.
 */
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:sport_booking/ui/components/notification_cell.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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
                  SliverToBoxAdapter(
                    child: Container(
                      color: Theme.of(context).primaryColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 32.0),
                          Text(' New nenue',
                              style: Theme.of(context).textTheme.headline5),
                          Container(
                            height: 170,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 12,
                                itemBuilder: (context, index) {
                                  return Container(
                                    width: 120,
                                    height: 100,
                                    child: Column(
                                      children: [
                                        AspectRatio(
                                          aspectRatio: 16 / 9,
                                          child: CachedNetworkImage(
                                              imageUrl:
                                                  'https://www.sportsgrassturf.com/wp-content/uploads/2019/01/44909654664_553967be1c_o.jpg'),
                                        ),
                                        Text('Hello')
                                      ],
                                    ),
                                  );
                                }),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              );
            }));
  }
}
