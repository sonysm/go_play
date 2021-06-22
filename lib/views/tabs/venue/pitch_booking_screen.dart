import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/models/venue.dart';
import 'package:kroma_sport/models/venue_detail.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/main.dart';
import 'package:kroma_sport/views/tabs/venue/booking_history_screen.dart';
import 'package:kroma_sport/widgets/ks_complete_dialog.dart';
import 'package:kroma_sport/widgets/ks_confirm_dialog.dart';
import 'package:kroma_sport/widgets/ks_loading.dart';
import 'package:kroma_sport/widgets/ks_message_dialog.dart';
import 'package:kroma_sport/widgets/ks_text_button.dart';
import 'package:kroma_sport/widgets/ks_widgets.dart';

class PitchBookingScreen extends StatefulWidget {
  static const tag = '/pitchBookingScreen';

  final Venue venue;
  final VenueService venueService;

  PitchBookingScreen({
    Key? key,
    required this.venue,
    required this.venueService,
  }) : super(key: key);

  @override
  _PitchBookingScreenState createState() => _PitchBookingScreenState();
}

class _PitchBookingScreenState extends State<PitchBookingScreen> {
  late VenueService _venueService;

  String picthTitle = '';

  int? duration;
  String? timeAvailableString;

  DateTime selectedDate = DateTime.now();
  DateTime? selectedStartTime;

  String? dateTimeString;

  DateFormat format = DateFormat('dd/MM/yyyy');

  bool isLoaded = false;

  KSHttpClient ksClient = KSHttpClient();

  List<DateTime> availableTimeList = [];
  List<int> durationList = [];

  Widget buildSelectDate() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.only(
          left: 16.0,
          top: 16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Feather.calendar,
                  size: 18.0,
                  color: isLight(context) ? Colors.grey[600] : Colors.grey[100],
                ),
                8.width,
                Text(
                  'Select Date',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: isLight(context)
                          ? Colors.grey[600]
                          : Colors.grey[100]),
                ),
              ],
            ),
            8.height,
            DatePicker(
              DateTime.now(),
              initialSelectedDate: DateTime.now(),
              selectionColor: mainColor,
              selectedTextColor: Colors.white,
              monthTextStyle:
                  Theme.of(context).textTheme.caption!.copyWith(fontSize: 11.0),
              dayTextStyle:
                  Theme.of(context).textTheme.caption!.copyWith(fontSize: 11.0),
              dateTextStyle: Theme.of(context).textTheme.headline5!,
              height: 90,
              daysCount: 14,
              activeDates: List.generate(
                  14, (index) => DateTime.now().add(Duration(days: index))),
              onDateChange: (date) {
                if (date != selectedDate) {
                  onSelectDate(date);
                }
              },
            ),
            16.height,
            Row(
              children: [
                Icon(
                  Feather.clock,
                  size: 18.0,
                  color: isLight(context) ? Colors.grey[600] : Colors.grey[100],
                ),
                8.width,
                Text(
                  'Select Start Time',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: isLight(context)
                          ? Colors.grey[600]
                          : Colors.grey[100]),
                ),
              ],
            ),
            8.height,
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: ElevatedButton(
                onPressed: isLoaded ? selectAvailableTime : null,
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(0),
                  backgroundColor: MaterialStateProperty.all(isLight(context)
                      ? Colors.grey[100]
                      : Colors.blueGrey[300]),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    side: BorderSide(color: Colors.grey[200]!),
                  )),
                  padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  ),
                ),
                child: Opacity(
                  opacity: isLoaded ? 1 : 0.3,
                  child: Row(
                    children: [
                      Text(
                        timeAvailableString ?? 'Select Start Time',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      Spacer(),
                      Icon(FeatherIcons.chevronDown,
                          color: isLight(context) ? blackColor : whiteColor),
                    ],
                  ),
                ),
              ),
            ),
            16.height,
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: ElevatedButton(
                onPressed: timeAvailableString != null ? selectDuration : null,
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(0),
                  backgroundColor: MaterialStateProperty.all(isLight(context)
                      ? Colors.grey[100]
                      : Colors.blueGrey[300]),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    side: BorderSide(color: Colors.grey[200]!),
                  )),
                  padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  ),
                ),
                child: Opacity(
                  opacity: timeAvailableString != null ? 1 : 0.3,
                  child: Row(
                    children: [
                      Text(
                        duration != null
                            ? '$duration minutes'
                            : 'Select Duration',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      Spacer(),
                      Icon(FeatherIcons.chevronDown,
                          color: isLight(context) ? blackColor : whiteColor),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextDetail({required String label, String? data}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 130.0,
            child: Text(
              label + ':',
              style: TextStyle(
                  fontSize: 16.0,
                  color:
                      isLight(context) ? Colors.grey[700] : Colors.grey[100]),
            ),
          ),
          Expanded(
            child: Text(
              data ?? '------',
              textAlign: TextAlign.right,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBookingDetail() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.only(top: 16.0),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Booking Details',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: isLight(context) ? Colors.grey[600] : Colors.grey[100],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 8.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color:
                    isLight(context) ? Colors.grey[200] : Colors.blueGrey[300],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: [
                  buildTextDetail(
                      label: 'Organizer', data: KS.shared.user.getFullname()),
                  buildTextDetail(label: 'Phone', data: KS.shared.user.phone),
                  buildTextDetail(
                      label: 'Place',
                      data: '${widget.venue.name}, $picthTitle'),
                  buildTextDetail(label: 'Date & Time', data: dateTimeString),
                  buildTextDetail(
                      label: 'Duration',
                      data:
                          duration != null ? duration.toString() + 'mn' : null),
                  buildTextDetail(
                      label: 'Total',
                      data: duration != null
                          ? '\$' +
                              ((duration! * _venueService.hourPrice) / 60)
                                  .toStringAsFixed(2)
                          : null),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

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
        margin: const EdgeInsets.only(bottom: 84.0),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Text(picthTitle),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              buildSelectDate(),
              buildBookingDetail(),
              buildInfo(),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 64.0,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, -1),
                    blurRadius: 4.0,
                    color: Colors.black.withOpacity(0.1),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Opacity(
                opacity:
                    duration != null && timeAvailableString != null ? 1 : 0.5,
                child: ElevatedButton(
                  onPressed: duration != null && timeAvailableString != null
                      ? bookPitch
                      : null,
                  style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      backgroundColor: MaterialStateProperty.all(mainColor),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)))),
                  child: Text(
                    'Book' +
                        (duration != null
                            ? ' - \$' +
                                ((duration! * _venueService.hourPrice) / 60)
                                    .toStringAsFixed(2)
                            : ''),
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _venueService = widget.venueService;
    picthTitle = _venueService.name +
        ' (${_venueService.serviceData.people! ~/ 2}x${_venueService.serviceData.people! ~/ 2})';

    getUnavailableTime();
  }

  void onSelectDate(DateTime date) {
    timeAvailableString = null;
    dateTimeString = null;
    duration = null;
    selectedDate = date;
    if (timeAvailableString != null) {
      dateTimeString = format.format(date) + ' - $timeAvailableString';
    }

    setState(() {});
    getUnavailableTime(showLoading: true);
  }

  void selectDuration() {
    showKSBottomSheet(
      context,
      title: 'Choose Duration',
      children: List.generate(durationList.length, (index) {
        return KSTextButtonBottomSheet(
          title: '${durationList[index]} minutes',
          height: 40,
          titleTextStyle: Theme.of(context)
              .textTheme
              .bodyText1
              ?.copyWith(fontWeight: FontWeight.w600),
          onTab: () {
            duration = durationList[index];
            dismissScreen(context);
          },
        );
      }),
    ).then((value) {
      // print('______callback! $value');
      setState(() {});
    });
  }

  void selectAvailableTime() {
    showKSBottomSheet(
      context,
      title: 'Choose Start Time',
      children: List.generate(availableTimeList.length, (index) {
        final time = availableTimeList[index];
        return KSTextButtonBottomSheet(
          title: DateFormat('hh:mm a').format(time),
          height: 40,
          titleTextStyle: Theme.of(context)
              .textTheme
              .bodyText1
              ?.copyWith(fontWeight: FontWeight.w600),
          onTab: () {
            selectedStartTime = time;
            timeAvailableString = DateFormat('hh:mm a').format(time);

            var dur = 60;
            durationList.clear();

            for (var i = index; i < availableTimeList.length; i++) {
              if (i + 1 < availableTimeList.length) {
                if (availableTimeList[i].add(Duration(hours: 1)) ==
                    availableTimeList[i + 1]) {
                  durationList.add(dur);
                  dur += 60;
                } else {
                  durationList.add(dur);
                  break;
                }
              } else if (i == availableTimeList.length - 1) {
                durationList.add(dur);
              }
            }

            dismissScreen(context);
          },
        );
      }),
    ).then((value) {
      if (timeAvailableString != null) {
        dateTimeString =
            format.format(selectedDate) + ' - $timeAvailableString';
      }
      setState(() {});
    });
  }

  void bookPitch() async {
    showKSConfirmDialog(
      context,
      message: 'You are about to book a pitch.\n\nPlease confirm!',
      onYesPressed: () async {
        showKSLoading(context);
        // await Future.delayed(Duration(milliseconds: 700));

        Map<String, dynamic> fields = {
          'book_date': DateFormat('yyyy-MM-dd').format(selectedDate),
          'from_time': DateFormat('HH:mm:ss').format(selectedStartTime!),
          'to_time': DateFormat('HH:mm:ss')
              .format(selectedStartTime!.add(Duration(minutes: duration!))),
          'price': (duration! * _venueService.hourPrice) / 60
        };

        var res = await ksClient.postApi('/booking/service/${_venueService.id}',
            body: fields);
        if (res != null) {
          if (res is! HttpResult) {
            dismissScreen(context);
            showKSComplete(context, message: 'Book successfully!');
            await Future.delayed(Duration(milliseconds: 1200));
            dismissScreen(context);
            Navigator.pushNamedAndRemoveUntil(context, BookingHistoryScreen.tag,
                ModalRoute.withName(MainView.tag));
          } else {
            dismissScreen(context);
            showKSMessageDialog(
                context, 'Booking failed. Please try again!', () {});
          }
        }

        // dismissScreen(context);
        // showKSComplete(context, message: 'Book successfully!');
        // await Future.delayed(Duration(milliseconds: 1200));
        // dismissScreen(context);
        // Navigator.pushNamedAndRemoveUntil(
        //     context, BookingHistoryScreen.tag, ModalRoute.withName(MainView.tag));
      },
    );
  }

  void getUnavailableTime({bool showLoading = false}) async {
    if (showLoading) {
      showKSLoading(context);
    }
    availableTimeList.clear();
    var queryDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    List<DateTime> unAvailableTimeList = [];

    var res = await ksClient.getApi(
        '/venue/service/unavailable/time/${_venueService.id}',
        queryParameters: {'date': queryDate});
    if (res != null) {
      if (res is! HttpResult) {
        for (var e in (res as List)) {
          List<DateTime> tempDate = [];
          var fromTime = DateFormat('yyyy-MM-dd HH:mm:ss')
              .parse('${e['date']} ${e['from_time']}');
          var toTime = DateFormat('yyyy-MM-dd HH:mm:ss')
              .parse('${e['date']} ${e['to_time']}');
          var amt = toTime.difference(fromTime).inHours;
          for (var i = 0; i < amt; i++) {
            var date = fromTime.add(Duration(hours: i));
            tempDate.add(date);
          }
          unAvailableTimeList.addAll(tempDate);
        }
        generateAvailableTime(unAvailableTimeList, showLoading: showLoading);
      }
    }
  }

  void generateAvailableTime(List<DateTime> unAvailableTimes,
      {bool showLoading = false}) {
    var day = DateFormat('EEE').format(selectedDate).toLowerCase();

    var oTime = DateFormat("yyyy-MM-dd hh:mm:ss").parse(
        '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day} ${widget.venue.schedule!.firstWhere((e) => e.day == day).openTime}');
    var cTime = DateFormat("yyyy-MM-dd hh:mm:ss").parse(
        '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day} ${widget.venue.schedule!.firstWhere((e) => e.day == day).closeTime}');

    var amtHour = cTime.difference(oTime).inHours;

    for (var i = 0; i < amtHour; i++) {
      var date = oTime.add(Duration(hours: i));
      availableTimeList.add(date);
    }

    DateTime tempDate = DateTime(2021, 1, 1);
    availableTimeList = List.from(availableTimeList.where((x) {
      return x.hour !=
          unAvailableTimes
              .firstWhere((e) => e.hour == x.hour, orElse: () => tempDate)
              .hour;
    }));

    Future.delayed(Duration(milliseconds: 300)).then((_) {
      isLoaded = true;
      setState(() {});

      if (showLoading) {
        dismissScreen(context);
      }
    });
  }
}
