/*
 * File: create_activity_screen.dart
 * Project: activities
 * -----
 * Created Date: Friday January 29th 2021
 * Author: Sony Sum
 * -----
 * Copyright (c) 2021 ERROR-DEV All rights reserved.
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:sport_booking/bloc/cubit/option_cubit.dart';
import 'package:sport_booking/bloc/cubit/switch_cubit.dart';
import 'package:sport_booking/theme/color.dart';
import 'package:sport_booking/ui/screen/dashboard/search_venue_delegate.dart';
import 'package:sport_booking/utils/enum.dart';
import 'package:sport_booking/utils/kp_loading.dart';

class CreateActivityScreen extends StatefulWidget {
  @override
  _CreateActivityScreenState createState() => _CreateActivityScreenState();
}

class _CreateActivityScreenState extends State<CreateActivityScreen> {
  final _sportCubit = OptionCubit<SportType>(SportType.football);
  final _pubCubit = SwitchCubit();
  final _bookCubit = SwitchCubit();

  TextStyle titleTextTheme(BuildContext context) {
    return Theme.of(context)
        .textTheme
        .bodyText2
        .apply(color: Theme.of(context).textTheme.caption.color);
  }

  TextStyle subTitletexTheme(BuildContext context) {
    return Theme.of(context).textTheme.subtitle1;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Text('Create Activity',
                    style: Theme.of(context).textTheme.headline6),
              ),
              SliverPadding(
                padding: EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Divider(height: 1),
                      _location(context),
                      Divider(height: 1),
                      BlocBuilder<OptionCubit, OptionState>(
                        cubit: _sportCubit,
                        builder: (context, state) {
                          SportType sp = state.value;
                          return ListTile(
                            contentPadding: EdgeInsets.all(0),
                            leading: Icon(Icons.sports),
                            title:
                                Text('Sport', style: titleTextTheme(context)),
                            subtitle: Text(sp.getSportName ?? 'No sport',
                                style: subTitletexTheme(context)),
                            trailing: Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              Navigator.pushNamed(context, '/choose-item',
                                  arguments: _sportCubit);
                            },
                          );
                        },
                      ),
                      Divider(height: 1),
                      ListTile(
                        contentPadding: EdgeInsets.all(0),
                        leading: Icon(Icons.date_range),
                        title: Text('Date', style: titleTextTheme(context)),
                        subtitle: Text('06 Feb 2021',
                            style: subTitletexTheme(context)),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          TimeOfDay selectedTime =
                              TimeOfDay(hour: 00, minute: 00);
                          showTimePicker(
                              context: context,
                              initialTime: selectedTime,
                              builder: (context, child) {
                                return Theme(
                                  data: ThemeData(
                                    primaryColor: Colors.red,
                                    buttonTheme: ButtonThemeData(
                                        buttonColor: Colors.red),
                                  ),
                                  child: child,
                                );
                              });
                        },
                      ),
                      Divider(height: 1),
                      ListTile(
                        contentPadding: EdgeInsets.all(0),
                        leading: Icon(LineAwesomeIcons.clock_1),
                        title: Text('Time', style: titleTextTheme(context)),
                        subtitle: Text('Day time from 6pm',
                            style: subTitletexTheme(context)),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                      Divider(height: 1),
                      SizedBox(height: 32.0),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('For Public',
                                style: subTitletexTheme(context)),
                            Row(
                              children: [
                                BlocBuilder<SwitchCubit, bool>(
                                  cubit: _pubCubit,
                                  builder: (context, state) {
                                    return CupertinoSwitch(
                                        activeColor: mainColor,
                                        value: state,
                                        onChanged: (newValue) {
                                          _pubCubit.change(newValue);
                                        });
                                  },
                                ),
                                Text('(Will visable for all user in app)',
                                    style: Theme.of(context).textTheme.caption),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Include booking',
                                  style: subTitletexTheme(context)),
                              Row(
                                children: [
                                  BlocBuilder<SwitchCubit, bool>(
                                    cubit: _bookCubit,
                                    builder: (context, state) {
                                      return CupertinoSwitch(
                                          activeColor: mainColor,
                                          value: state,
                                          onChanged: (newValue) {
                                            _bookCubit.change(newValue);
                                          });
                                    },
                                  ),
                                  Expanded(
                                    child: Text(
                                        'you check this it mean you will booking sport club at that time you have choose above',
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption),
                                  ),
                                ],
                              ),
                            ],
                          ))
                    ],
                    semanticIndexOffset: 1,
                  ),
                ),
              )
            ],
          ),
          SafeArea(
            minimum: const EdgeInsets.only(bottom: 8),
            child: Container(
              child: FlatButton(
                minWidth: 320,
                height: 44,
                color: mainColor,
                textColor: whiteColor,
                child: Text('Create Activity'),
                onPressed: () {
                  showLoading();
                  Future.delayed(Duration(seconds: 5), () {
                    hideLoading();
                  });
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Container _location(BuildContext context) {
    return Container(
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        leading: Icon(Icons.location_pin),
        title: Text('Location', style: titleTextTheme(context)),
        subtitle: Text('Roy7 Sport Club TK', style: subTitletexTheme(context)),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          showSearch(context: context, delegate: VenueSearchDelegate());
        },
      ),
    );
  }
}
