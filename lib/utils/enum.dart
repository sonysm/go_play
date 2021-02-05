/*
 * File: enum.dart
 * Project: utils
 * -----
 * Created Date: Wednesday February 3rd 2021
 * Author: Sony Sum
 * -----
 * Copyright (c) 2021 ERROR-DEV All rights reserved.
 */

enum FeedType {
  activityPost,
  userPost,
  groupPost,
}

enum SportType { football, vallayball }

extension SportTypeExtension on SportType {
  String get getSportName {
    switch (this) {
      case SportType.football:
        return 'Football';
        break;

      case SportType.vallayball:
        return 'Vallay ball';
        break;

      default:
        return '';
        break;
    }
  }

  void talk() {
    print('meow');
  }
}
