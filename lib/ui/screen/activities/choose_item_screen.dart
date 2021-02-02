/*
 * File: choose_item_screen.dart
 * Project: activities
 * -----
 * Created Date: Tuesday February 2nd 2021
 * Author: Sony Sum
 * -----
 * Copyright (c) 2021 ERROR-DEV All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:sport_booking/theme/color.dart';

class ChooseItemScreen extends StatefulWidget {
  @override
  _ChooseItemScreenState createState() => _ChooseItemScreenState();
}

class _ChooseItemScreenState extends State<ChooseItemScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Choose Sport', style: Theme.of(context).textTheme.headline6),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 16),
        child: Column(
          children: [
            ListTile(
              leading: Icon(LineAwesomeIcons.baseball_ball, size: 32),
              title: Text('Football'),
              trailing: Icon(LineAwesomeIcons.check, color: mainColor),
            ),
            Divider(indent: 16, endIndent: 16),
            ListTile(
              leading: Icon(LineAwesomeIcons.volleyball_ball, size: 32),
              title: Text('Volleyball'),
              trailing: Icon(LineAwesomeIcons.check, color: mainColor),
            )
          ],
        ),
      ),
    );
  }
}
