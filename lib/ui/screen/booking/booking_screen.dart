/*
 * File: booking_screen.dart
 * Project: booking
 * -----
 * Created Date: Monday January 25th 2021
 * Author: Sony Sum
 * -----
 * Copyright (c) 2021 ERROR-DEV All rights reserved.
 */

import 'package:bloc/bloc.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:sport_booking/theme/color.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final SfRangeValues _dateValues = SfRangeValues(1, 24);
  double _sliverValue = 60.0;

  double _height;
  double _width;

  String _setTime, _setDate;

  String _hour, _minute, _time;

  String dateTime;

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  DurationCubit _durationCubit = DurationCubit();

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
      });
  }

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Roy7 sprt sclub'),
      ),
      body: Container(
        height: double.infinity,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 32.0),
                    child: SizedBox.fromSize(
                        size: Size(74, 84),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(width: 1, color: mainColor),
                          ),
                          child:
                              Icon(LineAwesomeIcons.basketball_ball, size: 32),
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 16.0, top: 32.0),
                    child: CalendarTimeline(
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 29)),

                      // showYears: true,
                      onDateSelected: (date) => print(date),
                      leftMargin: 20,
                      monthColor: Colors.blueGrey,
                      dayColor: Colors.teal[200],
                      activeDayColor: Colors.white,
                      activeBackgroundDayColor: mainColor,
                      dotsColor: Color(0xFF333A47),
                      selectableDayPredicate: (date) => date.day != 23,
                      locale: 'en_US',
                    ),
                  ),
                  SizedBox(height: 32),
                  Divider(),
                  Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              _selectTime(context);
                            },
                            child: Column(
                              children: [
                                Text('Time',
                                    style:
                                        Theme.of(context).textTheme.subtitle2),
                                Text('6:00 AM',
                                    style:
                                        Theme.of(context).textTheme.headline5),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.grey,
                          height: 64,
                          width: 1,
                        ),
                        // Expanded(
                        //   child: Column(
                        //     children: [
                        //       Text('Duration',
                        //           style: Theme.of(context).textTheme.subtitle1),
                        //       SizedBox(height: 16.0),
                        //       Text('60 MN',
                        //           style: Theme.of(context).textTheme.headline5),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  Divider(),
                  SizedBox(height: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Duration',
                          style: Theme.of(context).textTheme.subtitle2),
                      BlocProvider(
                        create: (context) => _durationCubit,
                        child: BlocBuilder<DurationCubit, int>(
                          builder: (context, state) {
                            return Text('$state MN',
                                style: Theme.of(context).textTheme.headline5);
                          },
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 32.0),
                    child: SfSlider(
                      min: 60.0,
                      max: 240.0,
                      value: _sliverValue,
                      interval: 60.0,
                      stepSize: 30,
                      showTicks: true,
                      showLabels: true,
                      showDivisors: true,
                      minorTicksPerInterval: 1,
                      activeColor: mainColor,
                      onChanged: (newValue) {
                        setState(() {
                          _sliverValue = newValue;
                          _durationCubit.update(newValue);
                        });
                      },
                    ),
                  ),
                  Divider(),
                ],
              ),
            ),
            Positioned(
              bottom: 16,
              left: 1,
              right: 1,
              child: Container(
                height: 44,
                child: Center(
                  child: FlatButton(
                    minWidth: 320,
                    color: mainColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    onPressed: () => _showConfrimSheet(),
                    child: Text('Next'),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _showConfrimSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        return SafeArea(
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  heightFactor: 2,
                  child: Text('Summary',
                      style: Theme.of(context).textTheme.subtitle1),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _itemConfrimTitle('Field type', 'Foot ball'),
                    ),
                    Expanded(
                      child: _itemConfrimTitle('Venue', 'Roy7 Sport Club TK'),
                    ),
                    // _itemConfrimTitle('Field type', 'Foot ball'),
                    // _itemConfrimTitle('Field type', 'Foot ball'),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _itemConfrimTitle('Time', '06 Feb 2021 (5:30 PM)'),
                    ),
                    Expanded(
                      child: _itemConfrimTitle('Duration', '120 MN'),
                    ),
                    // _itemConfrimTitle('Field type', 'Foot ball'),
                    // _itemConfrimTitle('Field type', 'Foot ball'),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('\$19 / hour   ',
                        style: Theme.of(context).textTheme.headline6),
                    FlatButton(
                      minWidth: 250,
                      height: 44,
                      color: mainColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      onPressed: () {},
                      child: Text('BOOK NOW'),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  ListTile _itemConfrimTitle(String title, String subTitle) {
    return ListTile(
      title: Text(title,
          style: Theme.of(context)
              .textTheme
              .bodyText2
              .apply(color: Theme.of(context).textTheme.caption.color)),
      subtitle: Text(subTitle, style: Theme.of(context).textTheme.bodyText1),
    );
  }
}

class DurationCubit extends Cubit<int> {
  DurationCubit() : super(60);

  update(double newValue) {
    emit(newValue.toInt());
  }
}
