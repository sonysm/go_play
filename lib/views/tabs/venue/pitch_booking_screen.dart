import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/main.dart';
import 'package:kroma_sport/widgets/ks_complete_dialog.dart';
import 'package:kroma_sport/widgets/ks_loading.dart';
import 'package:kroma_sport/widgets/ks_text_button.dart';
import 'package:kroma_sport/widgets/ks_widgets.dart';

class PitchBookingScreen extends StatefulWidget {
  static const tag = '/pitchBookingScreen';

  PitchBookingScreen({Key? key}) : super(key: key);

  @override
  _PitchBookingScreenState createState() => _PitchBookingScreenState();
}

class _PitchBookingScreenState extends State<PitchBookingScreen> {
  int? duration;
  String? timeAvailableString;

  DateTime selectedDate = DateTime.now();

  String? dateTimeString;

  DateFormat format = DateFormat('dd/MM/yyyy');

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
                timeAvailableString = null;
                dateTimeString = null;
                selectedDate = date;
                if (timeAvailableString != null) {
                  dateTimeString =
                      format.format(date) + ' - $timeAvailableString';
                }
                setState(() {});
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
                  'Select Duration',
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
                onPressed: selectDuration,
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
            16.height,
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: ElevatedButton(
                onPressed: duration != null ? selectAvailableTime : null,
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
                  opacity: duration != null ? 1 : 0.3,
                  child: Row(
                    children: [
                      Text(
                        timeAvailableString ?? 'Select Available Time',
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
            )
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
            width: 150.0,
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
                      data: 'Downtown Sport Club, Pitch A (5x5)'),
                  buildTextDetail(label: 'Date & Time', data: dateTimeString),
                  buildTextDetail(
                      label: 'Duration',
                      data:
                          duration != null ? duration.toString() + 'mn' : null),
                  buildTextDetail(
                      label: 'Total',
                      data: duration != null
                          ? '\$' + ((duration! * 8) / 60).toStringAsFixed(2)
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
        title: Text('Pitch A (5x5)'),
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
                  ),
                  child: Text(
                    'Book - \$16.00',
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

  void selectDuration() {
    showKSBottomSheet(
      context,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            'Choose Duration',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        KSTextButtonBottomSheet(
          title: '30 minutes',
          height: 40,
          titleTextStyle: Theme.of(context)
              .textTheme
              .bodyText1
              ?.copyWith(fontWeight: FontWeight.w600),
          onTab: () {
            duration = 30;
            dismissScreen(context);
          },
        ),
        KSTextButtonBottomSheet(
          title: '60 minutes',
          height: 40,
          titleTextStyle: Theme.of(context)
              .textTheme
              .bodyText1
              ?.copyWith(fontWeight: FontWeight.w600),
          onTab: () {
            duration = 60;
            dismissScreen(context);
          },
        ),
        KSTextButtonBottomSheet(
          title: '90 minutes',
          height: 40,
          titleTextStyle: Theme.of(context)
              .textTheme
              .bodyText1
              ?.copyWith(fontWeight: FontWeight.w600),
          onTab: () {
            duration = 90;
            dismissScreen(context);
          },
        ),
        KSTextButtonBottomSheet(
          title: '120 minutes',
          height: 40,
          titleTextStyle: Theme.of(context)
              .textTheme
              .bodyText1
              ?.copyWith(fontWeight: FontWeight.w600),
          onTab: () {
            duration = 120;
            dismissScreen(context);
          },
        ),
      ],
    ).then((value) {
      print('______callback! $value');
      setState(() {});
    });
  }

  void selectAvailableTime() {
    showKSBottomSheet(
      context,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            'Choose Available Time',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        KSTextButtonBottomSheet(
          title: '7:00 AM',
          height: 40,
          titleTextStyle: Theme.of(context)
              .textTheme
              .bodyText1
              ?.copyWith(fontWeight: FontWeight.w600),
          onTab: () {
            timeAvailableString = '7:00 AM';
            dismissScreen(context);
          },
        ),
        KSTextButtonBottomSheet(
          title: '8:00 AM',
          height: 40,
          titleTextStyle: Theme.of(context)
              .textTheme
              .bodyText1
              ?.copyWith(fontWeight: FontWeight.w600),
          onTab: () {
            timeAvailableString = '8:00 AM';
            dismissScreen(context);
          },
        ),
        KSTextButtonBottomSheet(
          title: '9:00 AM',
          height: 40,
          titleTextStyle: Theme.of(context)
              .textTheme
              .bodyText1
              ?.copyWith(fontWeight: FontWeight.w600),
          onTab: () {
            timeAvailableString = '9:00 AM';
            dismissScreen(context);
          },
        ),
        KSTextButtonBottomSheet(
          title: '10:00 AM',
          height: 40,
          titleTextStyle: Theme.of(context)
              .textTheme
              .bodyText1
              ?.copyWith(fontWeight: FontWeight.w600),
          onTab: () {
            timeAvailableString = '10:00 AM';
            dismissScreen(context);
          },
        ),
      ],
    ).then((value) {
      print('______callback! $value');
      if (timeAvailableString != null) {
        dateTimeString =
            format.format(selectedDate) + ' - $timeAvailableString';
      }
      setState(() {});
    });
  }

  void bookPitch() async {
    showKSLoading(context);
    await Future.delayed(Duration(milliseconds: 700));
    dismissScreen(context);
    showKSComplete(context, message: 'Book successfully!');
    await Future.delayed(Duration(milliseconds: 1200));
    dismissScreen(context);
    Navigator.popUntil(context, ModalRoute.withName(MainView.tag));
  }
}
