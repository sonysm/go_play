/*
 * File: profile_screen.dart
 * Project: profile
 * -----
 * Created Date: Monday January 11th 2021
 * Author: Sony Sum
 * -----
 * Copyright (c) 2021 ERROR-DEV All rights reserved.
 */
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:package_info/package_info.dart';
import 'package:sport_booking/theme/color.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future _onRefresh() {
    return Future.value();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        actions: [
          IconButton(
            padding: EdgeInsets.only(right: 8),
            icon: Icon(LineAwesomeIcons.plus),
            onPressed: () {},
          )
        ],
        title: Text('Profile', style: Theme.of(context).textTheme.headline6),
      ),
      body: FutureBuilder<PackageInfo>(
          future: PackageInfo.fromPlatform(),
          builder: (context, state) {
            if (state.connectionState == ConnectionState.done) {
              return EasyRefresh.custom(
                onRefresh: _onRefresh,
                header: ClassicalHeader(
                    infoText: '',
                    textColor: Theme.of(context).textTheme.bodyText1.color),
                slivers: [
                  _buildProfileHeader(context),
                  SliverToBoxAdapter(
                    child: Container(
                      alignment: Alignment.center,
                      child: Container(
                        width: 320,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Center(
                                child: FloatingActionButton.extended(
                                    heroTag: Random().nextInt(1000),
                                    onPressed: () {},
                                    elevation: 0,
                                    icon: Icon(LineAwesomeIcons.user),
                                    label: Text('Friends')),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: FloatingActionButton.extended(
                                    heroTag: Random().nextInt(1000),
                                    onPressed: () {},
                                    elevation: 0,
                                    icon: Icon(
                                        LineAwesomeIcons.facebook_messenger),
                                    label: Text('Messages')),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.only(bottom: 64),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          _buildMenu('My group', LineAwesomeIcons.users,
                              onTap: () {}),
                          _buildMenu(
                              'Message', LineAwesomeIcons.facebook_messenger,
                              onTap: () {}),
                          _buildMenu('Language', Icons.language, onTap: () {}),
                          _buildMenu('Invite and Earn', LineAwesomeIcons.share,
                              onTap: () {}),
                          _buildMenu('Version ${state.data.version}',
                              LineAwesomeIcons.code_branch,
                              onTap: () {}),
                          _buildMenu('Logout', Icons.power_settings_new,
                              onTap: () {}),
                        ],
                      ),
                    ),
                  )
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  ListTile _buildMenu(String title, IconData icon, {Function onTap}) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon),
      title: Align(
        child: new Text(title),
        alignment: Alignment(-1.1, 0),
      ),
    );
  }

  SliverPadding _buildProfileHeader(BuildContext context) {
    return SliverPadding(
        padding: EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 32.0),
        sliver: SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(8.0)),
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 48.0,
                      backgroundImage: CachedNetworkImageProvider(
                          'https://images.unsplash.com/photo-1466112928291-0903b80a9466?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1053&q=80'),
                    ),
                    Positioned(
                        right: 4,
                        bottom: 4,
                        child: Icon(
                          Icons.add_a_photo,
                        ))
                  ],
                ),
                SizedBox(height: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'HENG SENHLY',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 8.0),
                    Text('Phnom penh, Cambodia'),
                    SizedBox(height: 16.0),
                    Text(
                      'SKILLS',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FlatButton.icon(
                          icon: Icon(LineAwesomeIcons.baseball_ball),
                          label: Text('Football'),
                          onPressed: null,
                        ),
                        Container(height: 16, width: 1, color: Colors.grey),
                        FlatButton.icon(
                          icon: Icon(LineAwesomeIcons.basketball_ball),
                          label: Text('Volleyball'),
                          onPressed: null,
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
