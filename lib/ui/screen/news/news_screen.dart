/*
 * File: news_screen.dart
 * Project: news
 * -----
 * Created Date: Tuesday January 12th 2021
 * Author: Sony Sum
 * -----
 * Copyright (c) 2021 ERROR-DEV All rights reserved.
 */
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:sport_booking/ui/components/news_cell.dart';
import 'package:sport_booking/ui/components/refresh_header.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: EasyRefresh.builder(
            onRefresh: () async {},
            onLoad: () async {},
            header: RefreshHeader(context),
            footer: RefreshFooter(context),
            builder: (context, physics, header, footer) {
              return CustomScrollView(
                physics: physics,
                primary: true,
                slivers: [
                  _buildSliverAppBar(),
                  header,
                  _buildTopCell(context),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index % 2 == 0) {
                          return Divider();
                        }
                        return NewsCell();
                      },
                      addSemanticIndexes: true,
                      childCount: 12,
                    ),
                  ),
                  footer
                ],
              );
            }));
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      floating: true,
      title: Text('News'),
    );
  }

  SliverPadding _buildTopCell(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
      sliver: SliverToBoxAdapter(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl:
                      'https://d2gg9evh47fn9z.cloudfront.net/800px_COLOURBOX42666248.jpg',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    'Dallas Cowboys can\'t lose sight of what really caused 6-10 debacle Dallas Cowboys can\'t lose sight of what really caused 6-10 debacle Dallas Cowboys can\'t lose sight of what really caused 6-10 debacle',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(fontSize: 18)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
