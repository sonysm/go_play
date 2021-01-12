/*
 * File: news_cell.dart
 * Project: components
 * -----
 * Created Date: Tuesday January 12th 2021
 * Author: Sony Sum
 * -----
 * Copyright (c) 2021 ERROR-DEV All rights reserved.
 */
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NewsCell extends StatelessWidget {
  const NewsCell({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 150,
        padding: EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dallas Cowboys can\'t lose sight of what really caused 6-10 debacle Dallas Cowboys can\'t lose sight of what really caused 6-10 debacle Dallas Cowboys can\'t lose sight of what really caused 6-10 debacle',
                      maxLines: 3,
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(fontSize: 18),
                    ),
                    Spacer(),
                    Text('1 hour ago',
                        style: Theme.of(context).textTheme.caption)
                  ],
                ),
              ),
            ),
            SizedBox(width: 16.0),
            Container(
              width: 120,
              child: AspectRatio(
                aspectRatio: 2 / 2.5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl:
                          'https://images.unsplash.com/photo-1518611012118-696072aa579a?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80'),
                ),
              ),
            )
          ],
        ));
  }
}
