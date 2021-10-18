import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kroma_sport/models/team.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/dimensions.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/account/team/widget/item_option_widget.dart';
import 'package:kroma_sport/views/tabs/account/team/widget/team_button_textfield.dart';
import 'package:kroma_sport/views/tabs/account/team/widget/team_textfield.dart';
import 'package:kroma_sport/widgets/ks_widgets.dart';
import 'package:line_icons/line_icons.dart';

class TeamSettingScreen extends StatefulWidget {
  static const tag = '/teamSetting';
  final Team team;
  TeamSettingScreen({Key? key, required this.team}) : super(key: key);

  @override
  _TeamSettingScreenState createState() => _TeamSettingScreenState();
}

class _TeamSettingScreenState extends State<TeamSettingScreen> {
  late Team team;

  TextEditingController _teamNameController = TextEditingController();
  TextEditingController _shortNameController = TextEditingController();
  TextEditingController _teamGenderController = TextEditingController();
  TextEditingController _ageGroupController = TextEditingController();
  TextEditingController _praticeLevelController = TextEditingController();
  TextEditingController _teamTypeController = TextEditingController();
  TextEditingController _teamEmailController = TextEditingController();

  bool isEditing = false;

  String? selectedGender;

  @override
  void initState() {
    super.initState();
    team = widget.team;
    _teamNameController.text = team.teamInfo.name;
    _teamGenderController.text = team.teamInfo.gender.capitalize;
    _teamEmailController.text = team.teamInfo.email ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: mainColor,
        iconTheme: Theme.of(context).iconTheme.copyWith(color: whiteColor),
        leadingWidth: 70,
        leading: isEditing
            ? TextButton(
                onPressed: () {
                  setState(() => isEditing = false);
                },
                child: Text('Cancel', style: TextStyle(fontSize: 16)),
              )
            : MaterialButton(
                onPressed: () => dismissScreen(context),
                shape: CircleBorder(),
                child: Icon(
                  Icons.arrow_back,
                  color: whiteColor,
                ),
              ),
        actions: [
          isEditing
              ? TextButton(
                  onPressed: () {
                    setState(() => isEditing = false);
                  },
                  child: Text('Save', style: TextStyle(fontSize: 16)),
                )
              : CupertinoButton(
                  child: Icon(LineIcons.pen),
                  onPressed: () {
                    setState(() => isEditing = true);
                  },
                ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 100,
                color: mainColor,
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(team.teamInfo.name, style: Theme.of(context).textTheme.headline6?.copyWith(color: whiteColor)),
                          const SizedBox(height: 4.0),
                          Text(team.teamInfo.sport.name, style: Theme.of(context).textTheme.bodyText1?.copyWith(color: whiteColor)),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        height: 72.0,
                        width: 72.0,
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 90,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16)),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: Dimensions.PADDING_SIZE_DEFAULT,
                      top: Dimensions.PADDING_SIZE_DEFAULT,
                      right: Dimensions.PADDING_SIZE_DEFAULT,
                      bottom: 64.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Team info',
                          style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                        TeamTextField(
                          controller: _teamNameController,
                          labelText: 'Team name',
                          isEditing: isEditing,
                        ),
                        const SizedBox(height: 12.0),
                        TeamTextField(
                          labelText: 'Short name',
                          isEditing: isEditing,
                        ),
                        const SizedBox(height: 12.0),
                        TeamButtonTextField(
                          controller: _teamGenderController,
                          labelText: 'Gender',
                          isEditing: isEditing,
                          onTap: isEditing ? showGenderOption : null,
                        ),
                        const SizedBox(height: 12.0),
                        TeamTextField(
                          controller: _teamEmailController,
                          labelText: 'Email',
                          isEditing: isEditing,
                        ),
                        const SizedBox(height: 12.0),
                        TeamButtonTextField(
                          controller: _ageGroupController,
                          labelText: 'Age group',
                          isEditing: isEditing,
                          onTap: isEditing ? () {} : null,
                        ),
                        const SizedBox(height: 12.0),
                        TeamButtonTextField(
                          controller: _praticeLevelController,
                          labelText: 'Practice level',
                          isEditing: isEditing,
                          onTap: isEditing ? () {} : null,
                        ),
                        const SizedBox(height: 12.0),
                        TeamButtonTextField(
                          controller: _teamTypeController,
                          labelText: 'Team type',
                          isEditing: isEditing,
                          onTap: isEditing ? () {} : null,
                        ),
                        const SizedBox(height: 12.0),
                        TeamTextField(
                          labelText: 'Default format',
                          isEditing: isEditing,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showGenderOption() {
    showKSBottomSheet(
      context,
      title: 'Gender',
      children: [
        ItemOptionWidget(
          title: 'Male',
          onTap: () {
            selectedGender = 'male';
            _teamGenderController.text = 'Male';
          },
        ),
        ItemOptionWidget(
          title: 'Female',
          onTap: () {
            selectedGender = 'female';
            _teamGenderController.text = 'Female';
          },
        ),
        ItemOptionWidget(
          title: 'Other',
          onTap: () {
            selectedGender = 'other';
            _teamGenderController.text = 'Other';
          },
        ),
        SizedBox(height: 16.0),
      ],
    ).then((_) => FocusScope.of(context).requestFocus(new FocusNode()));
  }
}
