import 'package:flutter/material.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/input_style.dart';

class JoinTeamScreen extends StatefulWidget {
  static const tag = '/joinTeam';
  JoinTeamScreen({Key? key}) : super(key: key);

  @override
  _JoinTeamScreenState createState() => _JoinTeamScreenState();
}

class _JoinTeamScreenState extends State<JoinTeamScreen> {
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
              SizedBox(height: 16.0),
              Text('To join a team, you need the team invitation code', style: Theme.of(context).textTheme.bodyText2,),
              SizedBox(height: 16.0),
              SizedBox(
                width: 300,
                child: TextField(
                  style: Theme.of(context).textTheme.bodyText1,
                  decoration: InputDecoration(
                    hintText: 'Your team code',
                    focusedBorder: InputStyles.inputUnderlineFocusBorder(),
                    enabledBorder: InputStyles.inputUnderlineEnabledBorder(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}