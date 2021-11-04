import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:kroma_sport/models/team.dart';
import 'package:kroma_sport/models/user.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/dimensions.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/account/team/player_screen.dart';
import 'package:kroma_sport/widgets/cache_image.dart';
import 'package:kroma_sport/widgets/ks_widgets.dart';
import 'package:share_plus/share_plus.dart';

class PlayerListScreen extends StatefulWidget {
  static const tag = '/playerListScreen';
  final Team team;
  PlayerListScreen({Key? key, required this.team}) : super(key: key);

  @override
  _PlayerListScreenState createState() => _PlayerListScreenState();
}

class _PlayerListScreenState extends State<PlayerListScreen> {
  late Team _team;
  List<TeamMember> teamMembers = [];

  @override
  void initState() {
    super.initState();
    _team = widget.team;
    teamMembers = _team.members.where((element) => element.member.id != _team.owner.id).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.3,
        title: Text(_team.teamInfo.name),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: MaterialButton(
              onPressed: showInvitationBottomSheet,
              child: Text('INVITE'),
              minWidth: 0,
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
                side: BorderSide(color: ColorResources.getSecondaryButtonBorderColor(context)),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8.0),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(
                left: Dimensions.PADDING_SIZE_DEFAULT,
                top: Dimensions.PADDING_SIZE_DEFAULT,
                right: Dimensions.PADDING_SIZE_DEFAULT,
                bottom: Dimensions.PADDING_SIZE_SMALL,
              ),
              child: Text(
                'Manager',
                style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            PlayerCell(user: _team.owner),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(
                left: Dimensions.PADDING_SIZE_DEFAULT,
                top: Dimensions.PADDING_SIZE_DEFAULT,
                right: Dimensions.PADDING_SIZE_DEFAULT,
                bottom: Dimensions.PADDING_SIZE_SMALL,
              ),
              child: Text(
                'Player ${teamMembers.isNotEmpty ? '(${teamMembers.length})' : ''}',
                style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            teamMembers.isEmpty
                ? Container(
                    height: 200,
                    color: ColorResources.getPrimary(context),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Invite your teammates to join your team on VPlay.'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: showInvitationBottomSheet,
                          child: Text('Add members'),
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0),
                            padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 12, horizontal: 12.0)),
                            backgroundColor: MaterialStateProperty.all(mainColor),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    color: ColorResources.getPrimary(context),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final user = teamMembers.elementAt(index).member;
                        return PlayerCell(user: user);
                      },
                      itemCount: teamMembers.length,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  void showInvitationBottomSheet() {
    final borderSide = BorderSide(width: 0.2, color: ColorResources.getSecondaryButtonBorderColor(context));
    final shareText = 'Join our team "${_team.teamInfo.name}" on VPlay by using this invitation code: ${_team.teamInfo.inviteCode}';
    showKSBottomSheet(
      context,
      title: 'Invite the member of your team',
      children: [
        /*Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 4.0),
          child: Text('Send Email', style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w600)),
        ),
        SizedBox(
          width: double.infinity,
          child: MaterialButton(
            onPressed: () {},
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
            child: Row(
              children: [
                Icon(LineIcons.addressBook),
                const SizedBox(width: 8.0),
                Text(
                  'Contact',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
            color: Colors.white,
            elevation: 0,
            highlightElevation: 0,
            shape: Border(top: borderSide, bottom: borderSide),
          ),
        ),*/
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0, bottom: 4.0),
          child:
              Text('Share the invitation code to your friend', style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w600)),
        ),
        SizedBox(
          width: double.infinity,
          child: MaterialButton(
            onPressed: () => onShare(context, shareText),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10.0),
            child: Text(_team.teamInfo.inviteCode, style: Theme.of(context).textTheme.headline6),
            color: ColorResources.getPrimary(context),
            elevation: 0,
            highlightElevation: 0,
            shape: Border(top: borderSide, bottom: borderSide),
          ),
        ),
        const SizedBox(height: 24.0),
      ],
    );
  }

  void onShare(BuildContext context, String text) async {
    final box = context.findRenderObject() as RenderBox?;
    await Share.share(text, sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  }
}

class PlayerCell extends StatelessWidget {
  final User user;
  const PlayerCell({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorResources.getPrimary(context),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => launchScreen(context, PlayerScreen.tag, arguments: user),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              children: [
                ClipOval(
                  child: CircleAvatar(
                    radius: 22,
                    child: CacheImage(url: user.photo ?? ''),
                  ),
                ),
                const SizedBox(width: 8.0),
                Text(user.getFullname(), style: Theme.of(context).textTheme.bodyText1)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
