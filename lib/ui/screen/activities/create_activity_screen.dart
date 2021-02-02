/*
 * File: create_activity_screen.dart
 * Project: activities
 * -----
 * Created Date: Friday January 29th 2021
 * Author: Sony Sum
 * -----
 * Copyright (c) 2021 ERROR-DEV All rights reserved.
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sport_booking/theme/color.dart';

class CreateActivityScreen extends StatefulWidget {
  @override
  _CreateActivityScreenState createState() => _CreateActivityScreenState();
}

class _CreateActivityScreenState extends State<CreateActivityScreen> {
  TextStyle titletexTheme(BuildContext context) {
    return Theme.of(context)
        .textTheme
        .bodyText2
        .apply(color: Theme.of(context).textTheme.caption.color);
  }

  TextStyle subTitletexTheme(BuildContext context) {
    return Theme.of(context).textTheme.subtitle1;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Text('Create Activity',
                    style: Theme.of(context).textTheme.headline6),
              ),
              SliverPadding(
                padding: EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Divider(height: 1),
                      ListTile(
                        contentPadding: EdgeInsets.all(0),
                        leading: Icon(Icons.sports),
                        title: Text('Sport', style: titletexTheme(context)),
                        subtitle:
                            Text('Food ball', style: subTitletexTheme(context)),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.pushNamed(context, '/choose-item');
                        },
                      ),
                      Divider(height: 1),
                      ListTile(
                        contentPadding: EdgeInsets.all(0),
                        leading: Icon(Icons.location_pin),
                        title: Text('Location', style: titletexTheme(context)),
                        subtitle: Text('Roy7 Sport Club TK',
                            style: subTitletexTheme(context)),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                      Divider(height: 1),
                      ListTile(
                        contentPadding: EdgeInsets.all(0),
                        leading: Icon(Icons.date_range),
                        title: Text('Date', style: titletexTheme(context)),
                        subtitle: Text('06 Feb 2021',
                            style: subTitletexTheme(context)),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                      Divider(height: 1),
                      ListTile(
                        contentPadding: EdgeInsets.all(0),
                        leading: Icon(Icons.sports),
                        title: Text('Time', style: titletexTheme(context)),
                        subtitle: Text('Day time from 6pm',
                            style: subTitletexTheme(context)),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                      Divider(height: 1),
                      SizedBox(height: 32.0),
                      Container(
                          child: Row(
                        children: [
                          Text('For Public', style: subTitletexTheme(context)),
                          CupertinoSwitch(
                              activeColor: mainColor,
                              value: true,
                              onChanged: (newVal) {}),
                          Text('   (Will visable for all user in app)',
                              style: Theme.of(context).textTheme.caption),
                        ],
                      ))
                    ],
                    semanticIndexOffset: 1,
                  ),
                ),
              )
            ],
          ),
          SafeArea(
            child: Container(
              child: FlatButton(
                minWidth: 320,
                height: 44,
                color: mainColor,
                child: Text('Create Activity'),
                onPressed: () {},
              ),
            ),
          )
        ],
      ),
    );
  }
}
