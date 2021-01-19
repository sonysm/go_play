/*
 * File: venue_cell.dart
 * Project: venue
 * -----
 * Created Date: Tuesday January 19th 2021
 * Author: Sony Sum
 * -----
 * Copyright (c) 2021 ERROR-DEV All rights reserved.
 */
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sport_booking/models/venue.dart';

class VenueCell extends StatelessWidget {
  const VenueCell({
    Key key,
    @required this.venue,
  }) : super(key: key);

  final Venue venue;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).primaryColor,
      margin: EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 8),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: 21 / 9,
            child: Container(
              color: Colors.red,
              width: double.infinity,
              child:
                  CachedNetworkImage(fit: BoxFit.cover, imageUrl: venue.image),
            ),
          ),
          SizedBox(height: 4.0),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(venue.name,
                      style: Theme.of(context).textTheme.subtitle1),
                  SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('6am - 10pm',
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(color: Colors.red)),
                      RatingBar.builder(
                        initialRating: 3,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 16,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
