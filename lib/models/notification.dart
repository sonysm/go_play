/*
 * File: notification.dart
 * Project: models
 * -----
 * Created Date: Monday January 11th 2021
 * Author: Sony Sum
 * -----
 * Copyright (c) 2021 ERROR-DEV All rights reserved.
 */
class SNotification {
  SNotification();

  String id;
  SNotification.fromJSON(json) {
    id = json['id'];
  }
}
