/*
 * File: choose_item_screen.dart
 * Project: activities
 * -----
 * Created Date: Tuesday February 2nd 2021
 * Author: Sony Sum
 * -----
 * Copyright (c) 2021 ERROR-DEV All rights reserved.
 */

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:sport_booking/bloc/cubit/option_cubit.dart';
import 'package:sport_booking/theme/color.dart';
import 'package:sport_booking/utils/enum.dart';

abstract class OptionType {
  int lengh;
}

class OptionTypeSport extends OptionType {}

class OptionTypeField extends OptionType {
  @override
  int get lengh => SportType.values.length;
}

class ChooseItemScreen extends StatefulWidget {
  ChooseItemScreen(this.optionType, this.opTionCubit);
  final OptionCubit opTionCubit;
  final OptionType optionType;
  @override
  _ChooseItemScreenState createState() => _ChooseItemScreenState();
}

class _ChooseItemScreenState extends State<ChooseItemScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OptionCubit, OptionState>(
      cubit: widget.opTionCubit,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Choose Sport',
                style: Theme.of(context).textTheme.headline6),
          ),
          body: Container(
            padding: EdgeInsets.only(top: 16),
            child: _buildSportList(),
          ),
        );
      },
    );
  }

  Widget getView() {
    if (widget.optionType is OptionTypeSport) {
      return _buildSportList();
    } else {
      return Container();
    }
  }

  Widget _buildSportList() {
    return ListView.separated(
        itemBuilder: (context, index) {
          var sport = SportType.values[index];
          return ListTile(
            leading: Icon(LineAwesomeIcons.baseball_ball, size: 32),
            title: Text(sport.getSportName),
            trailing: _getSelected(sport)
                ? Icon(LineAwesomeIcons.check, color: mainColor)
                : null,
            onTap: () {
              widget.opTionCubit.change(sport);
              Navigator.pop(context);
            },
          );
        },
        separatorBuilder: (context, index) {
          return Divider(height: 1);
        },
        itemCount: SportType.values.length);
  }

  bool _getSelected(SportType type) {
    return widget.opTionCubit.currentValue == type;
  }
}
