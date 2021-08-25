import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/models/booking.dart';
import 'package:kroma_sport/models/post.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/widgets/ks_confirm_dialog.dart';
import 'package:kroma_sport/widgets/ks_loading.dart';
import 'package:kroma_sport/widgets/ks_message_dialog.dart';

class ConnectBookingScreen extends StatefulWidget {
  static const tag = '/connectBookingScreen';

  ConnectBookingScreen({Key? key, required this.meetup}) : super(key: key);

  final Post meetup;

  @override
  _ConnectBookingScreenState createState() => _ConnectBookingScreenState();
}

class _ConnectBookingScreenState extends State<ConnectBookingScreen> {
  KSHttpClient ksClient = KSHttpClient();
  List<Booking> activeBookingList = [];
  bool isLoading = true;

  int? selectedBookingId;

  Widget bookingListView() {
    return !isLoading
        ? activeBookingList.isNotEmpty
            ? SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final activeBooking = activeBookingList[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 1.0),
                      child: BookingConnectCell(
                        selectedBookingId: selectedBookingId,
                        booking: activeBooking,
                        onConnect: () {
                          connectBooking(activeBooking);
                        },
                      ),
                    );
                  },
                  childCount: activeBookingList.length,
                ),
              )
            : SliverFillRemaining(
                child: Center(
                  child: Text('No Booking'),
                ),
              )
        : SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        dismissScreen(context, selectedBookingId);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Connect Booking'),
        ),
        body: CustomScrollView(
          slivers: [
            bookingListView(),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    selectedBookingId = widget.meetup.book;
    getMyBooking();
  }

  @override
  void setState(fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  void getMyBooking() async {
    DateFormat yMMddFormat = DateFormat('yyyy-MM-dd hh:mm:ss');
    var res = await ksClient.getApi('/booking/my');
    if (res != null) {
      if (res is! HttpResult) {
        activeBookingList = List.from(
          (res as List).map((e) => Booking.fromJson(e)).where((e) =>
              e.status == 'book' &&
              e.service.sport.id == widget.meetup.sport!.id &&
              DateTime.now()
                  .isBefore(yMMddFormat.parse(e.bookDate + ' ' + e.fromTime)) &&
              yMMddFormat
                  .parse(widget.meetup.activityDate! +
                      ' ' +
                      widget.meetup.activityStartTime!)
                  .isBefore(yMMddFormat.parse(e.bookDate + ' ' + e.fromTime))),
        );

        // activeBookingList = List.from(
        //   (res as List)
        //       .map((e) => Booking.fromJson(e))
        //       .where((e) => e.status == 'book'),
        // );

        Future.delayed(Duration(milliseconds: 300)).then((_) {
          isLoading = false;
          setState(() {});
        });
      }
    }
  }

  void connectBooking(Booking booking) {
    if (selectedBookingId == booking.id) {
      showKSConfirmDialog(
        context,
        message: 'Disconnect Meetup from this booking?',
        onYesPressed: () async {
          showKSLoading(context);
          var res = await ksClient
              .postApi('/booking/disconnect/meetup/${booking.id}');
          if (res != null) {
            if (res is! HttpResult) {
              dismissScreen(context);
              selectedBookingId = null;
              setState(() {});
            } else {
              dismissScreen(context);
              showKSMessageDialog(
                context,
                message: 'Cannot disconnect from this booking!',
                buttonTitle: 'OK',
              );
            }
          }
        },
      );
      return;
    }

    showKSConfirmDialog(
      context,
      message: 'Connect Meetup with this booking?',
      onYesPressed: () async {
        showKSLoading(context);
        var res = await ksClient.postApi(
            '/booking/connect/meetup/${booking.id}/${widget.meetup.id}');
        if (res != null) {
          if (res is! HttpResult) {
            dismissScreen(context);
            selectedBookingId = booking.id;
            setState(() {});
          } else {
            dismissScreen(context);
            showKSMessageDialog(
              context,
              message: 'Cannot book!',
              buttonTitle: 'OK',
            );
          }
        }
      },
    );
  }
}

class BookingConnectCell extends StatelessWidget {
  const BookingConnectCell({
    Key? key,
    this.selectedBookingId,
    required this.booking,
    required this.onConnect,
  }) : super(key: key);

  final Booking booking;
  final int? selectedBookingId;
  final VoidCallback onConnect;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 100.0,
        padding: const EdgeInsets.only(
            left: 16.0, top: 8.0, right: 16.0, bottom: 8.0),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          // borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              booking.venue.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            4.height,
                            Text(
                              booking.service.name,
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            Text(
                              booking.venue.address,
                              maxLines: 1,
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ],
                        ),
                      ),
                      // 8.width,
                      // Text(
                      //   booking.status.capitalize,
                      //   style: TextStyle(color: Colors.green),
                      // ),
                    ],
                  ),
                  Spacer(),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Time: ',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        TextSpan(
                          text: DateFormat('dd-MMM-yyyy - hh:mm a').format(
                              DateTime.parse(
                                  booking.bookDate + ' ' + booking.fromTime)),
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              ?.copyWith(color: Colors.amber[700]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: onConnect,
              style: ButtonStyle(
                  elevation: MaterialStateProperty.all(0.0),
                  backgroundColor: MaterialStateProperty.all(
                      selectedBookingId == booking.id
                          ? Theme.of(context).primaryColor
                          : mainColor),
                  foregroundColor: MaterialStateProperty.all(
                      selectedBookingId == booking.id ? mainColor : whiteColor),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      side: selectedBookingId == booking.id
                          ? BorderSide(color: mainColor)
                          : BorderSide.none))),
              child: Text(
                  selectedBookingId == booking.id ? 'Connected' : 'Connect'),
            )
          ],
        ),
      ),
    );
  }
}
