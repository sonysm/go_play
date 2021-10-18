import 'package:flutter/material.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/dimensions.dart';
import 'package:kroma_sport/utils/ks_images.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/account/team/create_team_screen.dart';
import 'package:kroma_sport/views/tabs/account/team/join_team_screen.dart';
import 'package:line_icons/line_icons.dart';

class TeamGetStartedScreen extends StatelessWidget {
  static const tag = '/teamGetStarted';
  const TeamGetStartedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                imgWaterMark,
                repeat: ImageRepeat.repeat,
                color: isLight(context) ? Colors.black.withOpacity(0.03) : Colors.white.withOpacity(0.03),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Welcome', style: Theme.of(context).textTheme.headline4),
                  SizedBox(height: 32.0),
                  Text('You wish to:', style: Theme.of(context).textTheme.bodyText2),
                  SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: () => launchScreen(context, CreateTeamScreen.tag),
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        backgroundColor: MaterialStateProperty.all(ColorResources.getMainColor(context)),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        minimumSize: MaterialStateProperty.all(Size(0, 44))),
                    child: Text('Create a team', style: Theme.of(context).textTheme.bodyText1?.copyWith(color: whiteColor)),
                  ),
                  SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: () => launchScreen(context, JoinTeamScreen.tag),
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        backgroundColor: MaterialStateProperty.all(whiteColor),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        side: MaterialStateProperty.all(BorderSide(width: 0.5, color: mainColor))),
                    child: Text('Join a team', style: Theme.of(context).textTheme.bodyText1?.copyWith(color: blackColor)),
                  ),
                  SizedBox(height: 48.0),
                ],
              ),
              Positioned(
                left: 16.0,
                top: 8.0,
                child: ElevatedButton(
                  onPressed: () => dismissScreen(context),
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    backgroundColor: MaterialStateProperty.all(Colors.grey.shade200),
                    foregroundColor: MaterialStateProperty.all(Colors.grey),
                    shape: MaterialStateProperty.all(CircleBorder()),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: MaterialStateProperty.all(EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL)),
                    minimumSize: MaterialStateProperty.all(Size.zero),
                  ),
                  child: Icon(LineIcons.times),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
