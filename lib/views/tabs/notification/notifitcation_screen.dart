import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/bloc/data_state.dart';
import 'package:kroma_sport/bloc/notify.dart';
import 'package:kroma_sport/models/notification.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/tools.dart';
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

  // List<KSNotification> noticationList = [];

  // bool isLoading = true;
  // bool noInternet = false;

  late NotifyCubit _cubit;

  Widget buildNoticationList(NotifyData notify) {
    if (notify.status == DataState.ErrorSocket || notify.status == DataState.ErrorTimeOut) {
      return SliverFillRemaining(
        child: KSNoInternet(),
      );
    }

    return notify.status != DataState.Loading
        ? notify.data.isNotEmpty
            ? SliverList(
                delegate: SliverChildListDelegate(
                  List.generate(
                    notify.data.length,
                    (index) {
                      final notification = notify.data[index];
                      switch (notification.type) {
                        case KSNotificationType.invite:
                          return InviteNoticationCell(notification: notification, onClick: onClick);
                        case KSNotificationType.comment:
                          return CommentNoticationCell(notification: notification, onClick: onClick);
                        case KSNotificationType.like:
                          return LikeNoticationCell(notification: notification, onClick: onClick);
                        case KSNotificationType.followed:
                          return FollowingNoticationCell(notification: notification, onClick: onClick);
                        case KSNotificationType.bookAccepted:
                        case KSNotificationType.bookCanceled:
                        case KSNotificationType.bookRejected:
                          return BookingNotificationCell(notification: notification, onClick: onClick);
                        default:
                          return NotificationCell(notification: notification,);
                      }
                    },
                  ),
                ),
              )
            : SliverFillRemaining(
                child: KSScreenState(
                  icon: SvgPicture.asset('assets/icons/ic_bell.svg',
                      height: 150, color: isLight(context) ? Colors.blueGrey[700] : Colors.blueGrey[100]),
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
      body: BlocBuilder<NotifyCubit, NotifyData>(
        builder: (context, state) {
          return EasyRefresh.custom(
            topBouncing: false,
            bottomBouncing: false,
            header: MaterialHeader(valueColor: AlwaysStoppedAnimation<Color>(mainColor)),
            footer: state.data.isNotEmpty ? ClassicalFooter(enableInfiniteLoad: false, completeDuration: Duration(milliseconds: 700)) : null,
            slivers: [
              buildNoticationList(state),
            ],
            onRefresh: () async{
                NotifyData data = await _cubit.onRefresh();
                _cubit.emit(data);
            },
            onLoad: state.status != DataState.NoMore ? () async {
                NotifyData data = await _cubit.onLoadMore();
                _cubit.emit(data);
            } : null,
          );
        }
      ),
    );
  }

  @override
  void initState() {
    super.initState();
     _cubit = context.read<NotifyCubit>();
     _cubit.onLoad();
  }

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  void onClick(int id){
      _cubit.readNotify(id);
  }
}
