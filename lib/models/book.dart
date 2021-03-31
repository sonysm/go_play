/*
 * File: book.dart
 * Project: models
 * -----
 * Created Date: Monday February 22nd 2021
 * Author: Sony Sum
 * -----
 * Copyright (c) 2021 ERROR-DEV All rights reserved.
 */

import 'dart:math';

import 'package:sport_booking/models/model.dart';
import 'package:sport_booking/models/venue.dart';
import 'package:sport_booking/utils/enum.dart';

class Book extends Model {
  DateTime playDate;
  Venue venue;
  BookStatus status;

  Book(this.status);

  @override
  fromJSON(json) {
    super.fromJSON(json);
    playDate = DateTime.now().add(Duration(days: Random().nextInt(15)));
    venue = Venue()
      ..name = 'Roy7 Sport club'
      ..id = '11'
      ..address = 'Np 1080 strret la';
    status = BookStatus.values[Random().nextInt(BookStatus.values.length)];
  }
}
