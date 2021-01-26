/*
 * File: booking_screen.dart
 * Project: booking
 * -----
 * Created Date: Monday January 25th 2021
 * Author: Sony Sum
 * -----
 * Copyright (c) 2021 ERROR-DEV All rights reserved.
 */
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:sport_booking/theme/color.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final SfRangeValues _dateValues = SfRangeValues(1, 24);

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
                      locale: 'en',
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 32.0, bottom: 32.0),
                    child: SfSlider(
                      min: 1.0,
                      max: 10.0,
                      value: 5.0,
                      interval: 1.0,
                      showTicks: true,
                      showLabels: true,
                      activeColor: mainColor,
                      onChanged: (newValue) {},
                    ),
                  ),
                  Divider(),
                  Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text('Time',
                                  style: Theme.of(context).textTheme.subtitle1),
                              SizedBox(height: 16.0),
                              Text('6:00 AM',
                                  style: Theme.of(context).textTheme.headline5),
                            ],
                          ),
                        ),
                        Container(
                          color: Colors.grey,
                          height: 64,
                          width: 1,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text('Duration',
                                  style: Theme.of(context).textTheme.subtitle1),
                              SizedBox(height: 16.0),
                              Text('60 MN',
                                  style: Theme.of(context).textTheme.headline5),
                            ],
                          ),
                        )
                      ],
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
                    onPressed: () {},
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
}
