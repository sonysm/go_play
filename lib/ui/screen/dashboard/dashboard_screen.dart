/*
 * File: dashboard_screen.dart
 * Project: dashboard
 * -----
 * Created Date: Tuesday January 12th 2021
 * Author: Sony Sum
 * -----
 * Copyright (c) 2021 ERROR-DEV All rights reserved.
 */
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:sport_booking/bloc/home_cubit/home_cubit.dart';
import 'package:sport_booking/models/venue.dart';
import 'package:sport_booking/theme/color.dart';
import 'package:sport_booking/ui/components/refresh_header.dart';
import 'package:sport_booking/ui/components/venue/venue_cell.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _homeCubit = HomeCubit();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Theme.of(context).primaryColor,
        body: EasyRefresh.builder(
            onRefresh: () async {},
            onLoad: () async {},
            header: RefreshHeader(context),
            footer: RefreshFooter(context),
            builder: (context, physics, header, footer) {
              return BlocProvider(
                create: (context) => _homeCubit,
                child: BlocConsumer<HomeCubit, HomeState>(
                  listener: (context, state) {
                    // TODO: implement listener
                  },
                  builder: (context, state) {
                    if (state is DidLoadDashboard) {
                      return CustomScrollView(
                        physics: physics,
                        primary: true,
                        slivers: [
                          SliverAppBar(
                            floating: true,
                            titleSpacing: 0.0,
                            centerTitle: false,
                            title: FlatButton(
                              onPressed: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(LineAwesomeIcons.map_marker, size: 16.0),
                                  Text(
                                    ' Sen Sok - Phnom penh ',
                                    style: Theme.of(context).textTheme.button,
                                  ),
                                  Icon(LineAwesomeIcons.angle_down, size: 16.0),
                                ],
                              ),
                            ),
                          ),
                          header,
                          _buildVenueSection(context, state.newList),
                          _buildVenueSection(context, state.newList,
                              title: 'Promotion'),
                          _buildNearBySection(context, state.nearByList),
                          footer
                        ],
                      );
                    } else {
                      return Container(
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                  },
                ),
              );
            }));
  }

  SliverPadding _buildNearBySection(BuildContext context, List<Venue> venues) {
    return SliverPadding(
      padding: EdgeInsets.only(top: 16.0),
      sliver: SliverToBoxAdapter(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('  Nearby',
                      style: Theme.of(context).textTheme.headline5),
                  Text('See All  ',
                      style: Theme.of(context).textTheme.bodyText2),
                ],
              ),
              Container(
                child: ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: venues.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      Venue venue = venues.elementAt(index);
                      return VenueCell(venue: venue);
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  SliverPadding _buildVenueSection(BuildContext context, List<Venue> venues,
      {String title = 'New Venue'}) {
    return SliverPadding(
      padding: EdgeInsets.only(top: 16.0),
      sliver: SliverToBoxAdapter(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.headline5),
                    FlatButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/venue-list'),
                        child: Text('See All')),
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(venues.length, (index) {
                    Venue venue = venues.elementAt(index);
                    return Container(
                      width: 290,
                      child: VenueCell(venue: venue),
                    );
                  }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
