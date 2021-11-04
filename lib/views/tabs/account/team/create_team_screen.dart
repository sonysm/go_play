import 'package:flutter/material.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/models/sport.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/dimensions.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/input_style.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/account/team/team_list_screen.dart';
import 'package:kroma_sport/widgets/ks_loading.dart';
import 'package:kroma_sport/widgets/ks_message_dialog.dart';
import 'package:kroma_sport/widgets/ks_widgets.dart';

class CreateTeamScreen extends StatefulWidget {
  static const tag = '/createTeam';
  CreateTeamScreen({Key? key}) : super(key: key);

  @override
  _CreateTeamScreenState createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends State<CreateTeamScreen> {
  TextEditingController _teamNameController = TextEditingController();
  TextEditingController _sportController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _ageCategoryController = TextEditingController();
  TextEditingController _teamTypeController = TextEditingController();
  TextEditingController _practiceLevelController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  KSHttpClient _ksClient = KSHttpClient();
  List<Sport> sportList = [];

  bool isLoading = true;
  Sport? selectedSport;

  @override
  void initState() {
    super.initState();
    getSportList();
  }

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      backgroundColor: ColorResources.getPrimary(context),
      body: !isLoading
          ? GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Container(
                  color: Colors.transparent,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: Dimensions.PADDING_SIZE_DEFAULT,
                    horizontal: Dimensions.PADDING_SIZE_EXTRA_LARGE,
                  ),
                  child: Column(
                    children: [
                      Text('Create your team', style: Theme.of(context).textTheme.headline5),
                      SizedBox(height: 16.0),
                      TextField(
                        controller: _teamNameController,
                        style: Theme.of(context).textTheme.bodyText1,
                        decoration: InputDecoration(
                          labelText: 'What\'s your team name?',
                          isDense: true,
                          labelStyle: TextStyle(color: Colors.grey),
                          focusedBorder: InputStyles.inputUnderlineFocusBorder(),
                          enabledBorder: InputStyles.inputUnderlineEnabledBorder(),
                          contentPadding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                        ),
                      ),
                      8.height,
                      TextField(
                        readOnly: true,
                        controller: _sportController,
                        enableInteractiveSelection: false,
                        style: Theme.of(context).textTheme.bodyText1,
                        decoration: InputDecoration(
                          labelText: 'Sport',
                          isDense: true,
                          labelStyle: TextStyle(color: Colors.grey),
                          focusedBorder: InputStyles.inputUnderlineEnabledBorder(),
                          enabledBorder: InputStyles.inputUnderlineEnabledBorder(),
                          contentPadding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                          suffixIcon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
                        ),
                        onTap: showSportOption,
                      ),
                      8.height,
                      TextField(
                        readOnly: true,
                        controller: _genderController,
                        enableInteractiveSelection: false,
                        style: Theme.of(context).textTheme.bodyText1,
                        decoration: InputDecoration(
                          labelText: 'Gender',
                          isDense: true,
                          labelStyle: TextStyle(color: Colors.grey),
                          focusedBorder: InputStyles.inputUnderlineEnabledBorder(),
                          enabledBorder: InputStyles.inputUnderlineEnabledBorder(),
                          contentPadding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                          suffixIcon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
                        ),
                        onTap: showGenderOption,
                      ),
                      8.height,
                      TextField(
                        readOnly: true,
                        controller: _ageCategoryController,
                        enableInteractiveSelection: false,
                        style: Theme.of(context).textTheme.bodyText1,
                        decoration: InputDecoration(
                          labelText: 'Age Category',
                          isDense: true,
                          labelStyle: TextStyle(color: Colors.grey),
                          focusedBorder: InputStyles.inputUnderlineEnabledBorder(),
                          enabledBorder: InputStyles.inputUnderlineEnabledBorder(),
                          contentPadding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                          suffixIcon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
                        ),
                        onTap: showAgeCategoryOption,
                      ),
                      8.height,
                      TextField(
                        readOnly: true,
                        controller: _teamTypeController,
                        enableInteractiveSelection: false,
                        style: Theme.of(context).textTheme.bodyText1,
                        decoration: InputDecoration(
                          hintText: 'Team type',
                          labelText: 'Team type',
                          isDense: true,
                          labelStyle: TextStyle(color: Colors.grey),
                          focusedBorder: InputStyles.inputUnderlineEnabledBorder(),
                          enabledBorder: InputStyles.inputUnderlineEnabledBorder(),
                          contentPadding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                          suffixIcon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
                        ),
                        onTap: showTeamTypeOption,
                      ),
                      8.height,
                      TextField(
                        readOnly: true,
                        controller: _practiceLevelController,
                        enableInteractiveSelection: false,
                        style: Theme.of(context).textTheme.bodyText1,
                        decoration: InputDecoration(
                          labelText: 'Pratice level',
                          isDense: true,
                          labelStyle: TextStyle(color: Colors.grey),
                          focusedBorder: InputStyles.inputUnderlineEnabledBorder(),
                          enabledBorder: InputStyles.inputUnderlineEnabledBorder(),
                          contentPadding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                          suffixIcon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
                        ),
                        onTap: showPracticeLevelOption,
                      ),
                      8.height,
                      TextField(
                        controller: _emailController,
                        style: Theme.of(context).textTheme.bodyText1,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          isDense: true,
                          labelStyle: TextStyle(color: Colors.grey),
                          focusedBorder: InputStyles.inputUnderlineFocusBorder(),
                          enabledBorder: InputStyles.inputUnderlineEnabledBorder(),
                          contentPadding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                        ),
                      ),
                      //8.height,
                      //TextField(
                      //  readOnly: true,
                      //  controller: _cityController,
                      //  enableInteractiveSelection: false,
                      //  style: Theme.of(context).textTheme.bodyText1,
                      //  decoration: InputDecoration(
                      //    hintText: 'City',
                      //    focusedBorder: InputStyles.inputUnderlineEnabledBorder(),
                      //    enabledBorder: InputStyles.inputUnderlineEnabledBorder(),
                      //    prefix: SizedBox(width: 8.0),
                      //    suffixIcon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
                      //  ),
                      //  onTap: () => print('print_________city'),
                      //),
                      24.height,
                      ElevatedButton(
                        onPressed: checkTeamCreationAvailable() ? createTeam : null,
                        style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0),
                            backgroundColor: MaterialStateProperty.resolveWith((states) {
                              if (states.contains(MaterialState.disabled)) {
                                return Colors.green[200];
                              }
                              return ColorResources.getMainColor(context);
                            }),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            minimumSize: MaterialStateProperty.all(Size(0, 44))),
                        child: Text('Create my team', style: Theme.of(context).textTheme.bodyText1?.copyWith(color: whiteColor)),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(mainColor),
              ),
            ),
    );
  }

  void getSportList() async {
    var data = await _ksClient.getApi('/user/all/sport');
    if (data != null && data is! HttpResult) {
      isLoading = false;
      sportList = List.from((data as List).map((e) => Sport.fromJson(e)));
      setState(() {});
    }
  }

  Widget itemOption({required String title, VoidCallback? onTap}) {
    return InkWell(
      onTap: () {
        if (onTap != null) onTap();
        dismissScreen(context);
      },
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

  void showSportOption() async {
    showKSBottomSheet(context,
        title: 'Sport',
        children: List.generate(sportList.length, (index) {
          final sport = sportList.elementAt(index);
          return itemOption(
            title: sport.name,
            onTap: () {
              selectedSport = sport;
              _sportController.text = sport.name;
            },
          );
        })).then((_) => FocusScope.of(context).requestFocus(new FocusNode()));
  }

  void showGenderOption() {
    showKSBottomSheet(
      context,
      title: 'Gender',
      children: [
        itemOption(
          title: 'Male',
          onTap: () {
            _genderController.text = 'Male';
          },
        ),
        itemOption(
          title: 'Female',
          onTap: () {
            _genderController.text = 'Female';
          },
        ),
        itemOption(
          title: 'Other',
          onTap: () {
            _genderController.text = 'Other';
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
        itemOption(
          title: 'Adults',
          onTap: () {
            _ageCategoryController.text = 'Adults';
          },
        ),
        itemOption(
          title: 'Youth',
          onTap: () {
            _ageCategoryController.text = 'Youth';
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
        itemOption(
          title: 'Club',
          onTap: () {
            _teamTypeController.text = 'Club';
          },
        ),
        itemOption(
          title: 'Company',
          onTap: () {
            _teamTypeController.text = 'Company';
          },
        ),
        itemOption(
          title: 'Group of friends',
          onTap: () {
            _teamTypeController.text = 'Group of friends';
          },
        ),
        itemOption(
          title: 'Recreational team',
          onTap: () {
            _teamTypeController.text = 'Recreational team';
          },
        ),
        itemOption(
          title: 'School / University',
          onTap: () {
            _teamTypeController.text = 'School / University';
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
        itemOption(
          title: 'Competition',
          onTap: () {
            _practiceLevelController.text = 'Competition';
          },
        ),
        itemOption(
          title: 'Pickup games',
          onTap: () {
            _practiceLevelController.text = 'Pickup games';
          },
        ),
        itemOption(
          title: 'Recreational',
          onTap: () {
            _practiceLevelController.text = 'Recreational';
          },
        ),
        SizedBox(height: 16.0),
      ],
    ).then((_) => FocusScope.of(context).requestFocus(new FocusNode()));
  }

  bool checkTeamCreationAvailable() {
    if (_teamNameController.text.trim().length > 0 &&
        selectedSport != null &&
        _genderController.text.isNotEmpty &&
        _ageCategoryController.text.isNotEmpty &&
        _teamTypeController.text.isNotEmpty &&
        _practiceLevelController.text.isNotEmpty) {
      return true;
    }
    return false;
  }

  void createTeam() {
    if (_teamNameController.text.trim().length < 2) {
      showKSMessageDialog(context, message: 'Please set your team name properly!');
      return;
    }

    showKSLoading(context);
    _ksClient.postApi('/user/create/team', body: {
      'name': _teamNameController.text,
      'sport': selectedSport!.id.toString(),
      'gender': _genderController.text,
      'phone': KS.shared.user.phone,
      'email': _emailController.text,
      'age_group': _ageCategoryController.text,
      'type': _teamTypeController.text,
      'practice_level': _practiceLevelController.text,
    }).then((value) {
      dismissScreen(context);
      if (value != null && value is! HttpResult) {
        Navigator.popUntil(context, (route) {
          if (route.settings.name == TeamListScreen.tag) {
            (route.settings.arguments as Map)['reload'] = true;
            return true;
          } else {
            return false;
          }
        });
      }
    });
  }
}
