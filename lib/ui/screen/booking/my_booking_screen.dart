/*
 * File: my_booking_screen.dart
 * Project: booking
 * -----
 * Created Date: Tuesday February 16th 2021
 * Author: Sony Sum
 * -----
 * Copyright (c) 2021 ERROR-DEV All rights reserved.
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:sport_booking/theme/color.dart';

class MyBookingScreen extends StatefulWidget {
  @override
  _MyBookingScreenState createState() => _MyBookingScreenState();
}

class _MyBookingScreenState extends State<MyBookingScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            heroTag: 'my_booking',
            largeTitle: Text('My Bookings'),
          ),
          SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Card(
                      margin: EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Container(
                            color: mainColor,
                            height: 32,
                            width: 4,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text('9',
                                    style:
                                        Theme.of(context).textTheme.headline4),
                                Text('Feb 2021',
                                    style:
                                        Theme.of(context).textTheme.bodyText1),
                                Text('06:00 PM',
                                    style:
                                        Theme.of(context).textTheme.subtitle1),
                              ],
                            ),
                          ),
                          Container(
                            color: Theme.of(context).primaryColorLight,
                            height: 32,
                            width: 1,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Roy7 Sport club',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(LineAwesomeIcons.map_marker,
                                          size: 16),
                                      Expanded(
                                        child: Text(
                                            'No 1080 street lam commune Phnom penh thmey commune, Phnom Penh',
                                            maxLines: 2,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(LineAwesomeIcons.clock_1, size: 16),
                                      Text('120 minuts',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Expanded(
                          //   child:
                          Text('Confirmed', textAlign: TextAlign.right),
                          // ),
                          SizedBox(width: 8),
                        ],
                      ),
                    );
                  },
                  childCount: 4,
                ),
              ))
        ],
      ),
    );
  }
}
