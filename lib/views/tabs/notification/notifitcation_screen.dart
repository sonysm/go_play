import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/models/notification.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/views/tabs/notification/widget/notification_cell.dart';
import 'package:kroma_sport/widgets/ks_screen_state.dart';

class NotificationScreen extends StatefulWidget {
  static const String tag = '/notificationScreen';

  NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  KSHttpClient ksClient = KSHttpClient();

  List<KSNotification> noticationList = [];

  bool isLoading = true;

  Widget buildNoticationList() {
    return !isLoading
        ? noticationList.isNotEmpty
            ? SliverList(
                delegate: SliverChildListDelegate(
                  List.generate(
                    noticationList.length,
                    (index) {
                      final notification = noticationList[index];
                      switch (notification.type) {
                        case KSNotificationType.invite:
                          return InviteNoticationCell(
                              notification: notification);
                        default:
                          return NotificationCell();
                      }
                    },
                  ),
                ),
              )
            : SliverFillRemaining(
                child: KSScreenState(
                  icon: SizedBox(
                    height: 100,
                    child: Image.asset(
                      'assets/images/img_emptybox.png',
                      color: Colors.grey,
                    ),
                  ),
                  title: 'No notification',
                  bottomPadding: AppBar().preferredSize.height + kToolbarHeight,
                ),
              )
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

  // Widget emptyNotification() {
  //   return SliverToBoxAdapter(
  //     child: Container(
  //       alignment: Alignment.center,
  //       margin: EdgeInsets.only(
  //           top: (MediaQuery.of(context).size.height / 2) -
  //               AppBar().preferredSize.height -
  //               200),
  //       child: Column(
  //         children: [
  //           SizedBox(
  //               height: 200,
  //               child: Image.asset(
  //                 'assets/images/img_emptybox.png',
  //                 color: Colors.grey,
  //               )),
  //           Text('No notification'),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
        elevation: 0.5,
      ),
      backgroundColor: ColorResources.getPrimary(context),
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

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  void getNotification() async {
    var res = await ksClient.getApi('/user/my_notification');
    if (res != null) {
      if (res is! HttpResult) {
        noticationList =
            List.from((res as List).map((e) => KSNotification.fromJson(e)));

        Future.delayed(Duration(milliseconds: 300)).then((_) {
          isLoading = false;
          setState(() {});
        });
      }
    }
  }
}
