/*
 * File: post_image_cell.dart
 * Project: activities
 * -----
 * Created Date: Friday February 5th 2021
 * Author: Sony Sum
 * -----
 * Copyright (c) 2021 ERROR-DEV All rights reserved.
 */
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sport_booking/models/feed_model.dart';

class PostCell extends StatefulWidget {
  PostCell(this.feed);

  final FeedModel feed;
  @override
  _PostCellState createState() => _PostCellState(this.feed);
}

class _PostCellState extends State<PostCell> {
  _PostCellState(this.feed);

  final FeedModel feed;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8, left: 16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundImage: CachedNetworkImageProvider(feed.from.image),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: RichText(
                    text: TextSpan(
                        text: feed.from.name,
                        style: Theme.of(context).textTheme.subtitle1,
                        children: [
                          feed.group != null
                              ? TextSpan(
                                  text: ' ▶︎ ',
                                  style: Theme.of(context).textTheme.subtitle1,
                                  children: [
                                    TextSpan(
                                      text: feed.group.name,
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
                                    )
                                  ],
                                )
                              : TextSpan(),
                        ]),
                  ),
                ))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
            child: Text(feed.title),
          ),
          feed.image != null
              ? Container(
                  child: CachedNetworkImage(imageUrl: feed.image[0]),
                )
              : SizedBox(),
          Container(
            padding: EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(child: Text('1.2k likes')),
                Expanded(child: Center(child: Text('1.2k comments'))),
                Expanded(child: Center(child: Text('1.2k shares')))
              ],
            ),
          )
        ],
      ),
    );
  }
}
