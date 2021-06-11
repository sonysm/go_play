import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/views/tabs/notification/widget/notification_cell.dart';

class NotificationScreen extends StatefulWidget {
  static const String tag = '/notificationScreen';

  NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  KSHttpClient ksClient = KSHttpClient();

  List<String> noticationList = [];

  bool isLoading = true;

  Widget buildNoticationList() {
    return !isLoading
        ? noticationList.isNotEmpty
            ? SliverList(
                delegate: SliverChildListDelegate(
                  List.generate(
                    noticationList.length,
                    (index) {
                      return NotificationCell();
                    },
                  ),
                ),
              )
            : emptyNotification()
        : SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(top: 200),
              child: Center(
                  child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(mainColor),
              )),
            ),
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
          buildNoticationList(),
        ],
        onRefresh: () async {},
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getNotification();
  }

  void getNotification() async {
    var res = await ksClient.getApi('/user/my_notification');
    if (res != null) {
      if (res is! HttpResult) {
        Future.delayed(Duration(milliseconds: 500)).then((_) {
          isLoading = false;
          setState(() {});
        });
      }
    }
  }
}
