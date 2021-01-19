/*
 * File: refresh_header.dart
 * Project: components
 * -----
 * Created Date: Monday January 18th 2021
 * Author: Sony Sum
 * -----
 * Copyright (c) 2021 ERROR-DEV All rights reserved.
 */
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class RefreshHeader extends ClassicalHeader {
  final BuildContext context;
  RefreshHeader(this.context);

  @override
  Color get textColor => Theme.of(context).textTheme.bodyText1.color;

  @override
  String get infoText => '';
}

class RefreshFooter extends ClassicalFooter {
  final BuildContext context;
  RefreshFooter(this.context);

  @override
  Color get textColor => Theme.of(context).textTheme.bodyText1.color;

  @override
  String get infoText => '';
}
