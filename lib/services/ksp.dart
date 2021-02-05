/*
 * File: kp.dart
 * Project: services
 * -----
 * Created Date: Monday February 1st 2021
 * Author: Sony Sum
 * -----
 * Copyright (c) 2021 ERROR-DEV All rights reserved.
 */

import 'package:flutter/material.dart';

class KSP {
  static KSP _singleton = KSP._internal();

  static KSP get shared {
    if (_singleton == null) {
      _singleton = KSP._internal();
    }
    return _singleton;
  }

  KSP._internal();

  GlobalKey mainKey;
}
