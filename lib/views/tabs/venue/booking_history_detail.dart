import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/models/booking.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/widgets/ks_confirm_dialog.dart';
import 'package:kroma_sport/widgets/ks_loading.dart';
import 'package:kroma_sport/widgets/ks_reason_dialog.dart';
import 'package:kroma_sport/widgets/ks_text_button.dart';
import 'package:kroma_sport/widgets/ks_widgets.dart';

class BookingHistoryDetailScreen extends StatefulWidget {
  static const tag = '/bookingHistoryDetail';

  final Booking? booking;
  final int? bookingId;

  BookingHistoryDetailScreen({
    Key? key,
    this.booking,
    this.bookingId,
  }) : super(key: key);

  @override
  _BookingHistoryDetailScreenState createState() =>
      _BookingHistoryDetailScreenState();
}

class _BookingHistoryDetailScreenState
    extends State<BookingHistoryDetailScreen> {
  late Booking _booking;
  late bool isLoading;
  String title = '';

  KSHttpClient ksClient = KSHttpClient();

  Widget buildTextInfo({required String data}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 10.0,
            width: 10.0,
            margin: const EdgeInsets.only(top: 6.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isLight(context) ? Colors.grey[600] : Colors.grey[200],
            ),
          ),
          8.width,
          Expanded(
            child: Text(
              data,
              style: TextStyle(
                  color:
                      isLight(context) ? Colors.grey[600] : Colors.grey[200]),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfo() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        margin: const EdgeInsets.only(top: 16.0),
        child: Column(
          children: [
            buildTextInfo(
                data:
                    'You as the organizer will need to invite to other player to the match.'),
            buildTextInfo(
                data:
                    'Your name and booking details will be shared to the field owners.'),
            buildTextInfo(
                data:
                    'Cancellation fee: \$0 if cancelled 2 or more days before booking, 50% of your payment if cancelled 1 day before, 100% of your payment if cancelled 12 hours before'),
          ],
        ),
      ),
    );
  }

  Widget buildBookingInfo() {
    var startTime = DateTime.parse(_booking.bookDate + ' ' + _booking.fromTime);
    var endTime = DateTime.parse(_booking.bookDate + ' ' + _booking.toTime);
    var duration =
        endTime.difference(startTime).inMinutes.toString() + ' minutes';

    return SliverToBoxAdapter(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          children: [
            SizedBox(
              height: 54.0,
              child: ListTile(
                dense: true,
                leading: Icon(Feather.map_pin, size: 20.0),
                horizontalTitleGap: 0,
                title: Text(_booking.venue.name,
                    style: Theme.of(context).textTheme.bodyText1),
                subtitle: Text(_booking.venue.address,
                    style: Theme.of(context).textTheme.headline2),
              ),
            ),
            SizedBox(
              height: 48.0,
              child: ListTile(
                dense: true,
                leading: SizedBox(width: 20.0),
                horizontalTitleGap: 0,
                title: Text(
                    _booking.service.name +
                        ' (${_booking.service.serviceData.people! ~/ 2}x${_booking.service.serviceData.people! ~/ 2})',
                    style: Theme.of(context).textTheme.bodyText1),
              ),
            ),
            SizedBox(
              height: 48.0,
              child: ListTile(
                dense: true,
                leading: Icon(Feather.calendar, size: 20.0),
                horizontalTitleGap: 0,
                title: Text(
                    DateFormat('dd/MM/yyyy - hh:mm a').format(DateTime.parse(
                        _booking.bookDate + ' ' + _booking.fromTime)),
                    style: Theme.of(context).textTheme.bodyText1),
              ),
            ),
            SizedBox(
              height: 48.0,
              child: ListTile(
                dense: true,
                leading: Icon(Feather.clock, size: 20.0),
                horizontalTitleGap: 0,
                title: Text(duration,
                    style: Theme.of(context).textTheme.bodyText1),
              ),
            ),
            SizedBox(
              height: 48.0,
              child: ListTile(
                dense: true,
                leading: Icon(Feather.dollar_sign, size: 20.0),
                horizontalTitleGap: 0,
                title: Text(_booking.price.toString(),
                    style: Theme.of(context).textTheme.bodyText1),
              ),
            ),
            SizedBox(
              height: 48.0,
              child: ListTile(
                dense: true,
                leading: Icon(Feather.pocket, size: 20.0),
                horizontalTitleGap: 0,
                title: Text(mapStatusTitle(),
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(color: mapStatusColor())),
              ),
            ),
            Divider(
              indent: 16.0,
              endIndent: 16.0,
            ),
          ],
        ),
      ),
    );
  }

  String mapStatusTitle() {
    if (isMeetupAvailable()) {
      return _booking.status.capitalize;
    }

    return 'Finished';
  }

  Color mapStatusColor() {
    if (isMeetupAvailable()) {
      return mainColor;
    }

    return blackColor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ID - KS$title'),
        actions: [
          !isLoading ? isMeetupAvailable()
              ? CupertinoButton(
                  child: Icon(FeatherIcons.moreVertical,
                      color: isLight(context) ? Colors.grey[600] : whiteColor),
                  onPressed: cancelBooking,
                )
              : SizedBox() : SizedBox()
        ],
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: !isLoading
          ? EasyRefresh.custom(
              header: MaterialHeader(
                valueColor: AlwaysStoppedAnimation<Color>(mainColor),
              ),
              slivers: [
                buildBookingInfo(),
                buildInfo(),
              ],
              onRefresh: () async {},
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.booking != null) {
      isLoading = false;
      _booking = widget.booking!;
      title = widget.booking!.id.toString();
    } else {
      title = widget.bookingId.toString();
      isLoading = true;
      getBookingDetail();
    }
  }

  void getBookingDetail() async {
    var res = await ksClient.getApi('/booking/detail/${widget.bookingId}');
    if (res != null) {
      if (res is! HttpResult) {
        _booking = Booking.fromJson(res);
      }
    }

    Future.delayed(Duration(milliseconds: 300)).then((_) {
      isLoading = false;
      setState(() {});
    });
  }

  void cancelBooking() {
    showKSBottomSheet(
      context,
      children: [
        KSTextButtonBottomSheet(
          title: 'Cancel Booking',
          titleTextStyle: Theme.of(context).textTheme.bodyText1?.copyWith(
                color: isLight(context) ? Colors.red : Colors.red[300],
                fontWeight: FontWeight.w600,
              ),
          height: 44.0,
          onTab: () {
            dismissScreen(context);
            confirmCancel();
          },
        ),
      ],
    );
  }

  void confirmCancel() {
    showKSConfirmDialog(
      context,
      message: 'Are you sure you want to cancel booking?',
      onYesPressed: () async {
        showKSReasonDialog(
          context,
          title: 'Tell the reason why you want to cancel booking:',
          onSubmit: () async {
            showKSLoading(context);
            dismissScreen(context);
            dismissScreen(context);
          },
        );
      },
    );
  }

  bool isMeetupAvailable() {
    var bookDate = DateFormat('yyyy-MM-dd hh:mm:ss')
        .parse(_booking.bookDate + ' ' + _booking.fromTime);
    if (DateTime.now().isAfter(bookDate)) {
      return false;
    }

    return true;
  }
}
