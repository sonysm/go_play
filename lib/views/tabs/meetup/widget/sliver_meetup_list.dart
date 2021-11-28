import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:kroma_sport/bloc/data_state.dart';
import 'package:kroma_sport/bloc/meetup.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/meetup/widget/meetup_cell.dart';
import 'package:kroma_sport/widgets/ks_screen_state.dart';

class SliverMeetupListView extends StatelessWidget {
  final MeetupData meetupData;
  const SliverMeetupListView({Key? key, required this.meetupData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return meetupData.status == DataState.Loading
        ? SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : meetupData.data.isNotEmpty
            ? SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    var meetup = meetupData.data.elementAt(index);

                    return Padding(
                      padding: EdgeInsets.only(top: (index == 0 ? 8.0 : 0)),
                      child: MeetupCell(
                        key: Key(meetup.id.toString()),
                        post: meetup,
                        index: index,
                      ),
                    );
                  },
                  childCount: meetupData.data.length,
                ),
              )
            : SliverFillRemaining(
                child: KSScreenState(
                  icon: Icon(FeatherIcons.activity, size: 150, color: isLight(context) ? Colors.blueGrey[700] : Colors.blueGrey[100]),
                  title: 'No Meetup Found',
                  subTitle: 'It seems there no meetup around you. You should try again later.',
                ),
              );
  }
}
