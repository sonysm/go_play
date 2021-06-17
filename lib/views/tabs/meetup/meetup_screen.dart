import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:kroma_sport/bloc/data_state.dart';
import 'package:kroma_sport/bloc/meetup.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/ks_images.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/meetup/widget/meetup_cell.dart';
import 'package:kroma_sport/views/tabs/notification/notifitcation_screen.dart';
import 'package:kroma_sport/widgets/ks_widgets.dart';

class MeetupScreen extends StatefulWidget {
  static const String tag = '/meetUpScreen';

  MeetupScreen({Key? key}) : super(key: key);

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<MeetupScreen> {
  Widget buildNavbar() {
    return SliverAppBar(
      title: Text('Meetup'),
    );
  }

  Widget emptyActivity() {
    return SliverFillRemaining(
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            border: Border(top: BorderSide(width: 0.1))),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imgEmptyActivity,
              width: 120.0,
            ),
            16.height,
            Text(
              'No Meetup',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(fontWeight: FontWeight.w600, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget loadingSliver() {
    return SliverFillRemaining(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget buildMeetupList(MeetupData meetupData) {
    return meetupData.status == DataState.Loading
        ? loadingSliver()
        : SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                var meetup = meetupData.data.elementAt(index);

                return Padding(
                  padding: EdgeInsets.only(top: (index == 0 ? 8.0 : 0)),
                  child: MeetupCell(post: meetup),
                );
              },
              childCount: meetupData.data.length,
            ),
          );
  }

  Widget noInternet() {
    return SliverFillRemaining(
      child: noConnection(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeetupCubit, MeetupData>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Meetup'),
            elevation: 0.5,
            actions: [
              CupertinoButton(
                child: Icon(FeatherIcons.bell,
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.grey[600]
                        : whiteColor),
                onPressed: () => launchScreen(context, NotificationScreen.tag),
              ),
            ],
          ),
          body: EasyRefresh.custom(
            header: MaterialHeader(
              valueColor: AlwaysStoppedAnimation<Color>(mainColor),
            ),
            footer: ClassicalFooter(
              enableInfiniteLoad: false,
              completeDuration: Duration(milliseconds: 1200),
            ),
            slivers: [
              state.status != DataState.ErrorSocket
                  ? buildMeetupList(state) : noInternet(),
            ],
            onRefresh: () async {
              BlocProvider.of<MeetupCubit>(context).onRefresh();
            },
            onLoad: () async {
              await Future.delayed(Duration(seconds: 2));
            },
          ),
        );
      },
    );
  }
}
