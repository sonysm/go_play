import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/models/team.dart';
import 'package:kroma_sport/models/user.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/dimensions.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/account/team/player_list_screen.dart';
import 'package:kroma_sport/views/tabs/account/team/player_screen.dart';
import 'package:kroma_sport/widgets/cache_image.dart';
import 'package:kroma_sport/widgets/ks_widgets.dart';
import 'package:line_icons/line_icons.dart';
import 'package:share_plus/share_plus.dart';

class TeamScreen extends StatefulWidget {
  static const tag = '/teamScreen';
  final Team team;
  TeamScreen({Key? key, required this.team}) : super(key: key);

  @override
  _TeamScreenState createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  late Team _team;
  List<TeamMember> teamMembers = [];
  double positionLeft = 0;

  @override
  void initState() {
    super.initState();
    _team = widget.team;
    teamMembers = _team.members.where((element) => element.member.id != _team.owner.id).toList();
  }

  Widget _buildTeamCell() {
    return Material(
      color: ColorResources.getPrimary(context),
      borderRadius: BorderRadius.circular(8.0),
      elevation: 5,
      shadowColor: Colors.black26,
      //shape: RoundedRectangleBorder(
      //  borderRadius: BorderRadius.circular(8.0),
      //),
      child: InkWell(
        onTap: () => launchScreen(context, PlayerListScreen.tag, arguments: _team),
        borderRadius: BorderRadius.circular(8.0),
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
          child: Row(
            children: [
              Text(
                _team.members.length.toString(),
                style: Theme.of(context).textTheme.headline4,
              ),
              16.width,
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Member in Team',
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    16.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              Positioned(left: 48.0, child: _buildMemberAvatar(KS.shared.user.photo!)),
                              Positioned(left: 24.0, child: _buildMemberAvatar(KS.shared.user.photo!)),
                              _buildMemberAvatar(KS.shared.user.photo!),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Colors.black87),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMemberAvatar(String url) {
    return CircleAvatar(
      radius: 18.0,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        radius: 16.0,
        backgroundImage: NetworkImage(url),
      ),
    );
  }

  Widget _buildCreateMatch() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () {},
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(5),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          shadowColor: MaterialStateProperty.all(Colors.black26),
          overlayColor: MaterialStateProperty.all(Colors.grey.shade200),
          padding: MaterialStateProperty.all(const EdgeInsets.all(16)),
        ),
        child: Text(
          'Create match',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.3,
        title: Text(_team.teamInfo.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTeamCell(),
              _buildCreateMatch(),
            ],
          ),
        ),
      ),
    );
  }
}
