/*
 * File: play
 * Project: activities
 * -----
 * Created Date: Thursday January 21st 2021
 * Author: Sony Sum
 * -----
 * Copyright (c) 2021 ERROR-DEV All rights reserved.
 */
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:sport_booking/theme/color.dart';

class ActivityCell extends StatelessWidget {
  const ActivityCell({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Card(
        elevation: 0.0,
        margin: EdgeInsets.all(16),
        color: Theme.of(context).primaryColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                CircleAvatar(
                  radius: 32.0,
                  backgroundImage: CachedNetworkImageProvider(
                      'https://images.unsplash.com/photo-1466112928291-0903b80a9466?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1053&q=80'),
                ),
                SizedBox(height: 8),
                Text('Sony sum'),
                SizedBox(height: 8),
                Text('Advanced', style: Theme.of(context).textTheme.caption),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(LineAwesomeIcons.heartbeat, size: 16),
                    SizedBox(width: 8),
                    Text(
                      'Warming Up',
                      style: Theme.of(context)
                          .textTheme
                          .button
                          .copyWith(color: mainColor),
                    )
                  ],
                )
              ],
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(LineAwesomeIcons.clock),
                      SizedBox(width: 8.0),
                      Text('22 jan - 9-12am'),
                      Spacer(),
                      Icon(LineAwesomeIcons.basketball_ball, color: Colors.grey)
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(LineAwesomeIcons.map_marker),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: RichText(
                            text: TextSpan(
                                text: 'ROY7 STORT CLUB\n',
                                style: Theme.of(context).textTheme.button,
                                children: [
                              TextSpan(
                                text: 'Street 598, Phnom Penh Thmey, Sen Sok',
                                style: Theme.of(context).textTheme.bodyText2,
                              )
                            ])),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('127 Going'),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: FlatButton(
                            color: Theme.of(context).canvasColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text('Join'),
                            onPressed: () {}),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
