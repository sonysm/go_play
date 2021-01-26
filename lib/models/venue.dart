/*
 * File: venue.dart
 * Project: models
 * -----
 * Created Date: Monday January 18th 2021
 * Author: Sony Sum
 * -----
 * Copyright (c) 2021 ERROR-DEV All rights reserved.
 */
import 'package:sport_booking/models/model.dart';

class Venue extends Model {
  String id;
  String name;
  String image;
  String address;

  Venue.fromJSON(dynamic json) {
    name = json['name'];
    image = json['image'];
    address = json['address'];
  }
}
