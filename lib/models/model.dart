/*
 * File: model.dart
 * Project: models
 * -----
 * Created Date: Monday January 18th 2021
 * Author: Sony Sum
 * -----
 * Copyright (c) 2021 ERROR-DEV All rights reserved.
 */
class Model {
  String id;

  fromJSON(json) {
    id = json['id'];
  }
}
