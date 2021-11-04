import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/models/team.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/dimensions.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/image_helper.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/account/team/widget/item_option_widget.dart';
import 'package:kroma_sport/views/tabs/account/team/widget/team_button_textfield.dart';
import 'package:kroma_sport/views/tabs/account/team/widget/team_textfield.dart';
import 'package:kroma_sport/widgets/cache_image.dart';
import 'package:kroma_sport/widgets/ks_loading.dart';
import 'package:kroma_sport/widgets/ks_widgets.dart';
import 'package:line_icons/line_icons.dart';

class TeamSettingScreen extends StatefulWidget {
  static const tag = '/teamSetting';
  final Team team;
  final Function(Team)? onTeamUpdated;
  TeamSettingScreen({Key? key, required this.team, this.onTeamUpdated}) : super(key: key);

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
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    setupData();
  }

  void setupData() {
    team = widget.team;
    _teamNameController.text = team.teamInfo.name;
    _teamGenderController.text = team.teamInfo.gender.capitalize;
    _teamEmailController.text = team.teamInfo.email ?? '';
    _shortNameController.text = team.teamInfo.shortName ?? '';
    _ageGroupController.text = team.teamInfo.ageGroup ?? '';
    _praticeLevelController.text = team.teamInfo.practiceLevel ?? '';
    _teamTypeController.text = team.teamInfo.type ?? '';
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
        actions: KS.shared.user.id == team.owner.id
            ? [
                isEditing
                    ? TextButton(
                        onPressed: saveTeamSetting,
                        child: Text('Save', style: TextStyle(fontSize: 16)),
                      )
                    : CupertinoButton(
                        child: Icon(LineIcons.pen),
                        onPressed: () {
                          setState(() => isEditing = true);
                        },
                      ),
              ]
            : null,
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
                      //Container(
                      //  height: 72.0,
                      //  width: 72.0,
                      //  decoration: BoxDecoration(
                      //    color: Colors.white70,
                      //    shape: BoxShape.circle,
                      //  ),
                      //),
                      GestureDetector(
                        onTap: KS.shared.user.id == team.owner.id
                            ? () async {
                                FocusScope.of(context).unfocus();
                                selectImage(context, (image) {
                                  if (image != null) {
                                    _imageFile = image;
                                    isEditing = true;
                                    setState(() {});
                                  }
                                });
                              }
                            : null,
                        child: Stack(
                          children: [
                            Container(
                              width: 80.0,
                              height: 80.0,
                              decoration:
                                  BoxDecoration(color: Colors.grey[100], border: Border.all(width: 0.3, color: Colors.grey), shape: BoxShape.circle),
                              child: _imageFile != null
                                  ? ClipOval(child: Image.file(_imageFile!))
                                  : ClipOval(
                                      child: team.teamInfo.photo != null
                                          ? SizedBox(
                                              width: 112.0,
                                              height: 112.0,
                                              child: CacheImage(url: team.teamInfo.photo!),
                                            )
                                          : Padding(
                                              padding: const EdgeInsets.all(16.0),
                                              child: SvgPicture.asset(
                                                'assets/icons/ic_team.svg',
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                    ),
                            ),
                            if (KS.shared.user.id == team.owner.id)
                              Positioned(
                                right: 0.0,
                                bottom: 0.0,
                                child: CircleAvatar(
                                  maxRadius: 14.0,
                                  backgroundColor: mainColor,
                                  child: CircleAvatar(
                                    maxRadius: 12.0,
                                    backgroundColor: Colors.grey,
                                    child: Container(
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: whiteColor,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      )
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
                  color: ColorResources.getPrimary(context),
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
                          controller: _shortNameController,
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
                          onTap: isEditing ? showAgeCategoryOption : null,
                        ),
                        const SizedBox(height: 12.0),
                        TeamButtonTextField(
                          controller: _praticeLevelController,
                          labelText: 'Practice level',
                          isEditing: isEditing,
                          onTap: isEditing ? showPracticeLevelOption : null,
                        ),
                        const SizedBox(height: 12.0),
                        TeamButtonTextField(
                          controller: _teamTypeController,
                          labelText: 'Team type',
                          isEditing: isEditing,
                          onTap: isEditing ? showTeamTypeOption : null,
                        ),
                        //const SizedBox(height: 12.0),
                        //TeamTextField(
                        //  labelText: 'Default format',
                        //  isEditing: isEditing,
                        //),
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
            dismissScreen(context);
          },
        ),
        ItemOptionWidget(
          title: 'Female',
          onTap: () {
            selectedGender = 'female';
            _teamGenderController.text = 'Female';
            dismissScreen(context);
          },
        ),
        ItemOptionWidget(
          title: 'Other',
          onTap: () {
            selectedGender = 'other';
            _teamGenderController.text = 'Other';
            dismissScreen(context);
          },
        ),
        SizedBox(height: 16.0),
      ],
    ).then((_) => FocusScope.of(context).requestFocus(new FocusNode()));
  }

  void showAgeCategoryOption() {
    showKSBottomSheet(
      context,
      title: 'Age category',
      children: [
        ItemOptionWidget(
          title: 'Adults',
          onTap: () {
            _ageGroupController.text = 'Adults';
            dismissScreen(context);
          },
        ),
        ItemOptionWidget(
          title: 'Youth',
          onTap: () {
            _ageGroupController.text = 'Youth';
            dismissScreen(context);
          },
        ),
        SizedBox(height: 16.0),
      ],
    ).then((_) => FocusScope.of(context).requestFocus(new FocusNode()));
  }

  void showTeamTypeOption() {
    showKSBottomSheet(
      context,
      title: 'Team type',
      children: [
        ItemOptionWidget(
          title: 'Club',
          onTap: () {
            _teamTypeController.text = 'Club';
            dismissScreen(context);
          },
        ),
        ItemOptionWidget(
          title: 'Company',
          onTap: () {
            _teamTypeController.text = 'Company';
            dismissScreen(context);
          },
        ),
        ItemOptionWidget(
          title: 'Group of friends',
          onTap: () {
            _teamTypeController.text = 'Group of friends';
            dismissScreen(context);
          },
        ),
        ItemOptionWidget(
          title: 'Recreational team',
          onTap: () {
            _teamTypeController.text = 'Recreational team';
            dismissScreen(context);
          },
        ),
        ItemOptionWidget(
          title: 'School / University',
          onTap: () {
            _teamTypeController.text = 'School / University';
            dismissScreen(context);
          },
        ),
        SizedBox(height: 16.0),
      ],
    ).then((_) => FocusScope.of(context).requestFocus(new FocusNode()));
  }

  void showPracticeLevelOption() {
    showKSBottomSheet(
      context,
      title: 'Practice level',
      children: [
        ItemOptionWidget(
          title: 'Competition',
          onTap: () {
            _praticeLevelController.text = 'Competition';
            dismissScreen(context);
          },
        ),
        ItemOptionWidget(
          title: 'Pickup games',
          onTap: () {
            _praticeLevelController.text = 'Pickup games';
            dismissScreen(context);
          },
        ),
        ItemOptionWidget(
          title: 'Recreational',
          onTap: () {
            _praticeLevelController.text = 'Recreational';
            dismissScreen(context);
          },
        ),
        SizedBox(height: 16.0),
      ],
    ).then((_) => FocusScope.of(context).requestFocus(new FocusNode()));
  }

  KSHttpClient _httpClient = KSHttpClient();

  void saveTeamSetting() async {
    if (_teamNameController.text.isEmpty) return;

    showKSLoading(context);
    await Future.delayed(Duration(seconds: 1));

    Map<String, String> field = {};

    if (_shortNameController.text.trim().length > 1) {
      field["short_name"] = _shortNameController.text;
    }

    if (_teamEmailController.text.isNotEmpty) {
      field["email"] = _teamEmailController.text;
    }

    field.addAll({
      'name': _teamNameController.text,
      'gender': _teamGenderController.text,
      'age_group': _ageGroupController.text,
      'type': _teamTypeController.text,
      'practice_level': _praticeLevelController.text,
    });

    var image;

    if (_imageFile != null) {
      List<int> imageData = _imageFile!.readAsBytesSync();
      image = MultipartFile.fromBytes(
        'photo',
        imageData,
        filename: 'Team' + DateTime.now().millisecondsSinceEpoch.toString() + '.jpg',
      );
    }

    await _httpClient.postFile('/user/edit/team/${team.teamInfo.id}', image, fields: field).then((res) {
      if (res != null && res is! HttpResult) {
        print('_____res____: $res');
        team.teamInfo.name = _teamNameController.text;
        team.teamInfo.email = _teamEmailController.text;
        team.teamInfo.gender = _teamGenderController.text;
        team.teamInfo.shortName = _shortNameController.text;
        team.teamInfo.ageGroup = _ageGroupController.text;
        team.teamInfo.practiceLevel = _praticeLevelController.text;
        team.teamInfo.type = _teamTypeController.text;
        if (widget.onTeamUpdated != null) {
          widget.onTeamUpdated!(team);
        }

        setState(() => isEditing = false);
        dismissScreen(context);
      }
    });
  }
}
