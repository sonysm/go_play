import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/models/team.dart';
import 'package:kroma_sport/utils/dimensions.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/account/team/delete_team_screen.dart';
import 'package:kroma_sport/views/tabs/account/team/team_cell.dart';
import 'package:kroma_sport/views/tabs/account/team/team_get_started_screen.dart';
import 'package:kroma_sport/views/tabs/account/team/team_setting_screen.dart';
import 'package:kroma_sport/widgets/ks_screen_state.dart';
import 'package:kroma_sport/widgets/ks_widgets.dart';
import 'package:line_icons/line_icons.dart';

class TeamListScreen extends StatefulWidget {
  static const tag = '/teamListScreen';
  TeamListScreen({Key? key}) : super(key: key);

  @override
  _TeamListScreenState createState() => _TeamListScreenState();
}

class _TeamListScreenState extends State<TeamListScreen> {
  List<Team> teamList = [];

  KSHttpClient _ksHttpClient = KSHttpClient();

  @override
  void initState() {
    super.initState();
    getTeamList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.3,
        title: Text('List of teams'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await launchScreen(context, TeamGetStartedScreen.tag);
          var arguments = ModalRoute.of(context)!.settings.arguments as Map;
          if (arguments['reload'] == true) {
            getTeamList();
          }
        },
        child: Icon(LineIcons.plus),
      ),
      body: teamList.length > 0
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      Dimensions.PADDING_SIZE_DEFAULT,
                      16.0,
                      Dimensions.PADDING_SIZE_DEFAULT,
                      0,
                    ),
                    child: Text(
                      'My teams',
                      style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                        Dimensions.PADDING_SIZE_DEFAULT, Dimensions.PADDING_SIZE_SMALL, Dimensions.PADDING_SIZE_DEFAULT, 16.0),
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final team = teamList.elementAt(index);
                      return TeamCell(team: team, onMoreTap: () => showMoreOption(team));
                    },
                    itemCount: teamList.length,
                  )
                ],
              ),
            )
          : Container(
              height: double.infinity,
              width: double.infinity,
              child: KSScreenState(
                icon: Icon(LineIcons.alternateShield, size: 150),
                title: 'No team',
              ),
            ),
    );
  }

  Widget itemOption({required String title, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 44.0,
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
        child: Row(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodyText1,
            )
          ],
        ),
      ),
    );
  }

  void showMoreOption(Team team) {
    showKSBottomSheet(
      context,
      children: [
        itemOption(
          title: 'See team setting',
          onTap: () {
            dismissScreen(context);
            launchScreen(context, TeamSettingScreen.tag, arguments: team);
          },
        ),
        itemOption(
          title: 'Delete team',
          onTap: () {
            dismissScreen(context);
            launchScreen(context, DeleteTeamScreen.tag);
          },
        ),
        SizedBox(height: 16.0),
      ],
    );
  }

  void getTeamList() async {
    var res = await _ksHttpClient.getApi('/user/my/team');
    if (res != null && res is! HttpResult) {
      print('______: $res');
      teamList = (res as List).map((e) => Team.fromJson(e)).toList();
      setState(() {});
    }
  }
}
