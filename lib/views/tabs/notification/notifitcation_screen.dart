import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  bool noInternet = false;

  Widget buildNoticationList() {
    if (!isLoading && noInternet) {
      return SliverFillRemaining(
        child: KSNoInternet(),
      );
    }

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
                          return InviteNoticationCell(notification: notification);
                        default:
                          return NotificationCell();
                      }
                    },
                  ),
                ),
              )
            : SliverFillRemaining(
                child: KSScreenState(
                  icon: SvgPicture.asset('assets/icons/ic_bell.svg', height: 150, color: Colors.blueGrey[700]),
                  title: 'No Notification',
                  subTitle: 'We\'ll notify you when someting arrives.',
                ),
              )
        : SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(top: 200),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(mainColor),
                ),
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
        elevation: 0.3,
      ),
      body: EasyRefresh.custom(
        topBouncing: false,
        bottomBouncing: false,
        header: MaterialHeader(valueColor: AlwaysStoppedAnimation<Color>(mainColor)),
        footer: noticationList.isNotEmpty ? ClassicalFooter(enableInfiniteLoad: false, completeDuration: Duration(milliseconds: 700)) : null,
        slivers: [
          buildNoticationList(),
        ],
        onRefresh: () async => getNotification(),
        onLoad: noticationList.isNotEmpty ? () async {} : null,
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
        noticationList = List.from((res as List).map((e) => KSNotification.fromJson(e)));

        Future.delayed(Duration(milliseconds: 300)).then((_) {
          isLoading = false;
          noInternet = false;
          setState(() {});
        });
      } else {
        if (res.code == -500) {
          isLoading = false;
          noInternet = true;
          setState(() {});
        }
      }
    }
  }
}
