/*
 * File: news_detail_screen.dart
 * Project: news
 * -----
 * Created Date: Monday February 1st 2021
 * Author: Sony Sum
 * -----
 * Copyright (c) 2021 ERROR-DEV All rights reserved.
 */
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sport_booking/models/news.dart';

class NewDetailScreen extends StatefulWidget {
  NewDetailScreen(this.news);
  final News news;
  @override
  _NewDetailScreenState createState() => _NewDetailScreenState();
}

class _NewDetailScreenState extends State<NewDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text('News detail'),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 0),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  CachedNetworkImage(
                      imageUrl: 'https://img.rasset.ie/0016159e-600.jpg'),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Dallas Cowboys can\'t lose sight of what really caused 6-10 debacle Dallas Cowboys can\'t lose sight of what really caused 6-10 debacle Dallas Cowboys can\'t lose sight of what really caused 6-10 debacle Dallas Cowboys can\'t lose sight of what really caused 6-10 debacle Dallas Cowboys can\'t lose sight of what really caused 6-10 debacle Dallas Cowboys can\'t lose sight of what really caused 6-10 debacle Dallas Cowboys can\'t lose sight of what really caused 6-10 debacle Dallas Cowboys can\'t lose sight of what really caused 6-10 debacle Dallas Cowboys can\'t lose sight of what really caused 6-10 debacle Dallas Cowboys can\'t lose sight of what really caused 6-10 debacle Dallas Cowboys can\'t lose sight of what really caused 6-10 debacle Dallas Cowboys can\'t lose sight of what really caused 6-10 debacle Dallas Cowboys can\'t lose sight of what really caused 6-10 debacle Dallas Cowboys can\'t lose sight of what really caused 6-10 debacle Dallas Cowboys can\'t lose sight of what really caused 6-10 debacle Dallas Cowboys can\'t lose sight of what really caused 6-10 debacle Dallas Cowboys can\'t lose sight of what really caused 6-10 debacle Dallas Cowboys can\'t lose sight of what really caused 6-10 debacleDallas Cowboys can\'t lose sight of what really caused 6-10 debacle Dallas Cowboys can\'t lose sight of what really caused 6-10 debacle Dallas Cowboys can\'t lose sight of what really caused 6-10 debacleDallas Cowboys can\'t lose sight of what really caused 6-10 debacle Dallas Cowboys can\'t lose sight of what really caused 6-10 debacle Dallas Cowboys can\'t lose sight of what really caused 6-10 debacle Dallas Cowboys can\'t lose sight of what really caused 6-10 debacle Dallas Cowboys can\'t lose sight of what really caused 6-10 debacle Dallas Cowboys can\'t lose sight of what really caused 6-10 debacle Dallas Cowboys can\'t lose sight of what really caused 6-10 debacle Dallas Cowboys can\'t lose sight of what really caused 6-10 debacle Dallas Cowboys can\'t lose sight of what really caused 6-10 debacle',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
