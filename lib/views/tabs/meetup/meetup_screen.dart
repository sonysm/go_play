import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:kroma_sport/api/api_checker.dart';
import 'package:kroma_sport/bloc/data_state.dart';
import 'package:kroma_sport/bloc/meetup.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/meetup/widget/sliver_meetup_list.dart';
import 'package:kroma_sport/views/tabs/search/search_screen.dart';
import 'package:kroma_sport/widgets/ks_screen_state.dart';

class MeetupScreen extends StatefulWidget {
  static const String tag = '/meetUpScreen';

  MeetupScreen({Key? key}) : super(key: key);

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<MeetupScreen> {

  @override
  Widget build(BuildContext context) {
    return BlocListener<MeetupCubit, MeetupData>(
      listener: (context, state) {
        ApiChecker.checkApi(context, state.status);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Meetup'),
          elevation: 0.3,
          actions: [
            CupertinoButton(
              padding: EdgeInsets.only(right: 16.0),
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isLight(context) ? Colors.blueGrey[50] : Colors.blueGrey,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  FeatherIcons.search,
                  size: 20.0,
                  color: Theme.of(context).brightness == Brightness.light ? Colors.grey[600] : whiteColor,
                ),
              ),
              onPressed: () => launchScreen(context, SearchScreen.tag),
            ),
            SizedBox(),
          ],
        ),
        body: BlocBuilder<MeetupCubit, MeetupData>(
          builder: (context, state) {
            return EasyRefresh.custom(
              bottomBouncing: state.status != DataState.ErrorSocket,
              header: MaterialHeader(
                valueColor: AlwaysStoppedAnimation<Color>(mainColor),
              ),
              footer: ClassicalFooter(
                enableInfiniteLoad: false,
                completeDuration: Duration(milliseconds: 1200),
              ),
              slivers: [
                state.status != DataState.ErrorSocket
                    ? SliverMeetupListView(meetupData: state)
                    : SliverFillRemaining(
                        child: KSNoInternet(),
                      ),
              ],
              onRefresh: () async {
                  final cub =BlocProvider.of<MeetupCubit>(context);
                  var data = await cub.onRefresh();
                  cub.emit(data);
              },
              onLoad: state.status != DataState.NoMore ? () async {
                  final cub =BlocProvider.of<MeetupCubit>(context);
                  var data = await cub.onLoadMore();
                  cub.emit(data);
              } : null,
            );
          },
        ),
      ),
    );
  }
}
