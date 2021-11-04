import 'package:flutter/material.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/input_style.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/account/team/team_list_screen.dart';
import 'package:kroma_sport/widgets/ks_loading.dart';
import 'package:kroma_sport/widgets/ks_message_dialog.dart';

class JoinTeamScreen extends StatefulWidget {
  static const tag = '/joinTeam';
  JoinTeamScreen({Key? key}) : super(key: key);

  @override
  _JoinTeamScreenState createState() => _JoinTeamScreenState();
}

class _JoinTeamScreenState extends State<JoinTeamScreen> {
  TextEditingController _invitationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      backgroundColor: ColorResources.getPrimary(context),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          color: Colors.transparent,
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('Join a team', style: Theme.of(context).textTheme.headline5),
              const SizedBox(height: 16.0),
              Text(
                'To join a team, you need the team invitation code',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: _invitationController,
                  style: Theme.of(context).textTheme.bodyText1,
                  decoration: InputDecoration(
                    hintText: 'Your team code',
                    focusedBorder: InputStyles.inputUnderlineFocusBorder(),
                    enabledBorder: InputStyles.inputUnderlineEnabledBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () => joinTeam(),
                style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    backgroundColor: MaterialStateProperty.all(ColorResources.getMainColor(context)),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    minimumSize: MaterialStateProperty.all(Size(150, 44))),
                child: Text('Join', style: Theme.of(context).textTheme.bodyText1?.copyWith(color: whiteColor)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  KSHttpClient _httpClient = KSHttpClient();

  void joinTeam() async {
    FocusScope.of(context).unfocus();
    if (_invitationController.text.isEmpty) {
      showKSMessageDialog(context, message: 'Please input invitation code to join a team!');
    }
    showKSLoading(context);
    await _httpClient.postApi('/user/join/team/invite_code', body: {"invite_code": _invitationController.text}).then((res) {
      dismissScreen(context);
      if (res != null && res is! HttpResult) {
        print('_____res: $res');

        Navigator.popUntil(context, (route) {
          if (route.settings.name == TeamListScreen.tag) {
            (route.settings.arguments as Map)['reload'] = true;
            return true;
          } else {
            return false;
          }
        });
      } else {
        if (res is HttpResult) {
          if (res.code == 0) {
            showKSMessageDialog(context, message: 'Invalid invitation code!\nPlease try again.', buttonTitle: 'OK');
          }
        }
      }
    });
  }
}
