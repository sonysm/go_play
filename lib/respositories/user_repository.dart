/*
 * File: repos
 * Project: respositories
 * -----
 * Created Date: Monday January 18th 2021
 * Author: Sony Sum
 * -----
 * Copyright (c) 2021 ERROR-DEV All rights reserved.
 */

import 'dart:convert';

import 'package:sport_booking/respositories/api_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

class UserRepository {
  final _api = ApiProvider();

  Future<dynamic> getDashboard() async {
    String jsonString =
        await rootBundle.loadString("assets/dummy/venue_list.json");
    return jsonDecode(jsonString);
  }
}
