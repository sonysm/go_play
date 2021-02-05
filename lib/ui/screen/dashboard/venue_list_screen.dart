/*
 * File: venue_list_screen.dart
 * Project: dashboard
 * -----
 * Created Date: Tuesday January 19th 2021
 * Author: Sony Sum
 * -----
 * Copyright (c) 2021 ERROR-DEV All rights reserved.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:sport_booking/bloc/venue_list_cubit/venuelist_cubit.dart';
import 'package:sport_booking/models/venue.dart';
import 'package:sport_booking/theme/color.dart';
import 'package:sport_booking/ui/components/refresh_header.dart';
import 'package:sport_booking/ui/components/venue/venue_cell.dart';
import 'package:sport_booking/ui/screen/dashboard/search_venue_delegate.dart';

class VenueListScreen extends StatefulWidget {
  @override
  _VenueListScreenState createState() => _VenueListScreenState();
}

class _VenueListScreenState extends State<VenueListScreen> {
  List<Venue> _venues = [];
  final _cubit = VenueListCubit();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => _cubit,
        child: BlocConsumer<VenueListCubit, VenueListState>(
          listener: (context, state) {
            if (state is VenueListDidLoad) {
              _venues = state.venues;
            }
          },
          builder: (context, state) {
            if (state is VenueListInitial) {
              return Center(child: CircularProgressIndicator());
            }
            return EasyRefresh.builder(
              onRefresh: () async {},
              onLoad: () async {},
              header: RefreshHeader(context),
              footer: RefreshFooter(context),
              builder: (context, physics, header, footer) {
                return CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      floating: true,
                      title: Text('NearBy'),
                      actions: [
                        IconButton(
                            padding: EdgeInsets.all(8).copyWith(right: 16),
                            icon: Icon(LineAwesomeIcons.horizontal_sliders),
                            onPressed: () {})
                      ],
                      bottom: PreferredSize(
                        preferredSize: Size.fromHeight(64),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CupertinoTextField(
                                placeholder: 'Search',
                                style: TextStyle(color: whiteColor),
                                onTap: () {
                                  showSearch(
                                      context: context,
                                      delegate: VenueSearchDelegate());
                                },
                              ),
                              SizedBox(height: 8.0),
                              Row(
                                children: [
                                  Text('sort by   '),
                                  Icon(LineAwesomeIcons.sort_alphabetical_down)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    header,
                    _buildNearBySection(context, _venues),
                    footer
                  ],
                );
              },
            );
          },
        ),
      ),
    );
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
}
