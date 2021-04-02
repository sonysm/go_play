import 'package:flutter/material.dart';

class ActivityScreen extends StatefulWidget {
  static String tag = '/activityScreen';

  ActivityScreen({Key? key}) : super(key: key);

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  Widget buildNavbar() {
    return SliverAppBar(
      title: Text('Activity'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          buildNavbar(),
        ],
      ),
    );
  }
}
