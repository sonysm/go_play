/*
 * File: venue_detail_screen.dart
 * Project: dashboard
 * -----
 * Created Date: Tuesday January 19th 2021
 * Author: Sony Sum
 * -----
 * Copyright (c) 2021 ERROR-DEV All rights reserved.
 */
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:sport_booking/models/venue.dart';
import 'package:sport_booking/theme/color.dart';
import 'package:sport_booking/ui/screen/activities/activity_screen.dart';

class VenueDetailScreen extends StatefulWidget {
  final Venue venue;
  VenueDetailScreen(this.venue);

  @override
  _VenueDetailScreenState createState() => _VenueDetailScreenState();
}

class _VenueDetailScreenState extends State<VenueDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CustomScrollView(
            slivers: [
              CupertinoSliverNavigationBar(
                padding: EdgeInsetsDirectional.only(start: 0, bottom: 8),
                leading: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.keyboard_arrow_left, size: 32)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        icon: Icon(LineAwesomeIcons.heart), onPressed: () {}),
                    IconButton(
                        icon: Icon(LineAwesomeIcons.code_branch),
                        onPressed: () {})
                  ],
                ),
                largeTitle: Text(widget.venue.name,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline6),
              ),
              SliverToBoxAdapter(
                child: AspectRatio(
                  aspectRatio: 21 / 9,
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: widget.venue.image,
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.only(left: 8, right: 8, bottom: 64),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.0),
                      RatingBar.builder(
                        initialRating: 3,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 24,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        children: [
                          Icon(LineAwesomeIcons.alternate_map_marked),
                          SizedBox(width: 8.0),
                          Text(widget.venue.address)
                        ],
                      ),
                      FlatButton(
                        onPressed: () {},
                        child: Text(
                          'See Map',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2
                              .copyWith(color: Colors.amber),
                        ),
                      ),
                      SizedBox(height: 24.0),
                      Row(
                        children: [
                          Icon(LineAwesomeIcons.clock_1),
                          SizedBox(width: 8.0),
                          Text('Operation - 6am - 10pm')
                        ],
                      ),
                      SizedBox(height: 32.0),
                      RichText(
                          text: TextSpan(
                              text: 'Available Sports',
                              style: Theme.of(context).textTheme.subtitle1,
                              children: [
                            TextSpan(
                              text: '   (Tap on icon to see "Price Chart")',
                              style: Theme.of(context).textTheme.caption,
                            )
                          ])),
                      SizedBox(height: 8.0),
                      Row(
                        children: [
                          Icon(LineAwesomeIcons.basketball_ball, size: 44),
                          SizedBox(width: 8.0),
                          Icon(LineAwesomeIcons.football_ball, size: 44),
                        ],
                      ),
                      SizedBox(height: 32.0),
                      RichText(
                          text: TextSpan(
                        text: 'Activities',
                        style: Theme.of(context).textTheme.subtitle1,
                      )),
                      SizedBox(height: 8.0),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Container(width: 320, child: ActiviryCell()),
                            SizedBox(width: 8.0),
                            Container(width: 320, child: ActiviryCell())
                          ],
                        ),
                      ),
                      SizedBox(height: 32.0),
                      Text('About Venue',
                          style: Theme.of(context).textTheme.subtitle1),
                      SizedBox(height: 8.0),
                      Text(
                          'Our sport club accommodated with 6 football pitches; 3 for 7-aside and another 3 for 5-aside located in Toul Kork area well renowned for football pitch region. Reduce your stress by spend your time with sport and relax space allow you to sit and enjoy the view and the football game. Our sport club accommodated with 6 football pitches; 3 for 7-aside and another 3 for 5-aside located in Toul Kork area well renowned for football pitch region. Reduce your stress by spend your time with sport and relax space allow you to sit and enjoy the view and the football game.')
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            color: Theme.of(context).primaryColor,
            child: SafeArea(
              top: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 16),
                  Expanded(
                      child: RaisedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/create-activity');
                          },
                          child: Text('CREATE ACTIVITY'))),
                  SizedBox(width: 16),
                  Expanded(
                      child: RaisedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/book');
                          },
                          child: Text('BOOK NOW'))),
                  SizedBox(width: 16),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
