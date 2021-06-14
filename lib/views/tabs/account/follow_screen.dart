import 'package:flutter/material.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/themes/colors.dart';

class FollowScreen extends StatefulWidget {
  static const tag = '/followScreen';

  FollowScreen({Key? key}) : super(key: key);

  @override
  _FollowScreenState createState() => _FollowScreenState();
}

class _FollowScreenState extends State<FollowScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('${KS.shared.user.getFullname()}'),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size(double.infinity, 30),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                labelStyle: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Metropolis',
                ),
                indicatorColor: mainColor,
                indicatorWeight: 1.0,
                tabs: [
                  Tab(text: 'Followers'),
                  Tab(text: 'Following'),
                ],
                onTap: (index) {
                  // if (index == 1) {
                  //   scrollToBottom();
                  // }
                },
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Container(),
            Container(),
          ],
        ),
      ),
    );
  }
}
