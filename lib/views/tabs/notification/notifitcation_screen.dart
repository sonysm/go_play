import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/views/tabs/notification/widget/notification_cell.dart';

class NotificationScreen extends StatefulWidget {
  static const String tag = '/notificationScreen';

  NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  Widget buildNavbar() {
    return SliverAppBar(
      title: Text('Notification'),
      elevation: 0.5,
      forceElevated: true,
    );
  }

  Widget buildNoticationList() {
    return SliverList(
      delegate: SliverChildListDelegate(List.generate(1, (index) {
        return NotificationCell();
      })),
    );
  }

  Widget emptyNotification() {
    return SliverToBoxAdapter(
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(
            top: (MediaQuery.of(context).size.height / 2) -
                AppBar().preferredSize.height),
        child: Text('No notification'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
        elevation: 0.5,
      ),
      body: EasyRefresh.custom(
        header: MaterialHeader(
          valueColor: AlwaysStoppedAnimation<Color>(mainColor),
        ),
        slivers: [
          //buildNavbar(),
          buildNoticationList(),
        ],
        onRefresh: () async {},
      ),
    );
  }
}
