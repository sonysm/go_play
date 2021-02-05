/*
 * File: feed_model.dart
 * Project: models
 * -----
 * Created Date: Friday February 5th 2021
 * Author: Sony Sum
 * -----
 * Copyright (c) 2021 ERROR-DEV All rights reserved.
 */
import 'package:flutter/material.dart';
import 'package:sport_booking/models/group_model.dart';
import 'package:sport_booking/models/model.dart';
import 'package:sport_booking/models/user.dart';
import 'package:sport_booking/utils/enum.dart';

class FeedModel extends Model {
  FeedType type = FeedType.userPost;
  String title;
  List<String> image;
  User from;
  GroupModel group;

  @override
  fromJSON(json) {
    super.fromJSON(json);
  }

  FeedModel.dummy() {
    title = 'Hello today evening all friends anyone free join my football?';

    image = [
      'https://media.newyorker.com/photos/5f441cfeaf580809467117ad/4:3/w_2452,h_1839,c_limit/Thomas-CollegeFootball.jpg'
    ];
  }

  FeedModel.dummyNoImage() {
    title =
        'Hello today evening all friends anyone free join my football?\n#FOOTBALL_CAMBODIA\n😀😘🥰😜😍';
  }
}
