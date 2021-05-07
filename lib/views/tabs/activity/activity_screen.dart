import 'package:flutter/material.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/ks_images.dart';

class ActivityScreen extends StatefulWidget {
  static const String tag = '/activityScreen';

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

  Widget emptyActivity() {
    return SliverFillRemaining(
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            border: Border(top: BorderSide(width: 0.1))),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imgEmptyActivity,
              width: 120.0,
            ),
            16.height,
            Text(
              'No activity',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(fontWeight: FontWeight.w600, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Theme.of(context).primaryColor,
      body: CustomScrollView(
        slivers: [
          buildNavbar(),
          emptyActivity(),
        ],
      ),
    );
  }
}
