/*
 * File: profile_screen.dart
 * Project: profile
 * -----
 * Created Date: Monday January 11th 2021
 * Author: Sony Sum
 * -----
 * Copyright (c) 2021 ERROR-DEV All rights reserved.
 */
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:package_info/package_info.dart';

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
        centerTitle: true,
        title: Text('Profile'),
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
                  SliverList(
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
        padding:
            EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 32.0),
        sliver: SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(8.0)),
            child: Row(
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
                SizedBox(width: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('HENG SENHLY'),
                    SizedBox(height: 16.0),
                    Text('093401361'),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
