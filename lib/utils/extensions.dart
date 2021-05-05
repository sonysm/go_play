import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

extension StringExtension on String {
  /// Join two strings with a space
  String operator &(String other) => '$this $other';

  /// Change a word to start with capital letter
  String get capitalize {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
  
  /// Add string value with currency format
  String toCurrencyFormat({var format = '\$'}) {
    return format + this;
  }
  
  String get timeAgoString {
    final _dateTime = DateTime.parse(this);
    if (DateTime.now().difference(_dateTime).inDays < 10) {
      //timeago.setLocaleMessages('km', timeago.KmMessages());
      //timeago.setLocaleMessages('ja', timeago.JaMessages());
      return timeago.format(_dateTime, locale: 'en');
    }
    initializeDateFormatting();
    return DateFormat('MMM dd, y', 'en').format(_dateTime);
  }
}

extension IntExtensions on int {

  /// Leaves given height of space
  Widget get height => SizedBox(height: this.toDouble());

  /// Leaves given width of space
  Widget get width => SizedBox(width: this.toDouble());

  /// HTTP status code
  bool isSuccessful() {
    return this >= 200 && this <= 206;
  }
}

extension DateOnlyCompare on DateTime {
  /// Compare whether date is the same
  bool isSameDate(DateTime other) {
    return this.year == other.year &&
        this.month == other.month &&
        this.day == other.day;
  }
}
