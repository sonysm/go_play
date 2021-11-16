import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/models/user.dart';
import 'package:kroma_sport/repositories/user_repository.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/image_helper.dart';
import 'package:kroma_sport/utils/ks_images.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/main.dart';
import 'package:kroma_sport/widgets/ks_loading.dart';
import 'package:kroma_sport/widgets/ks_widgets.dart';

class RegisterScreen extends StatefulWidget {
  static const String tag = '/registerScreen';

  final String phoneNumber;

  RegisterScreen({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  File? _imageFile;

  TextEditingController _fnTextController = TextEditingController();
  TextEditingController _lnTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _genderTextController = TextEditingController();
  TextEditingController _heightTextController = TextEditingController();
  TextEditingController _weightTextController = TextEditingController();
  TextEditingController _dobController = TextEditingController();

  final userRepository = UserRepository();
  KSHttpClient ksClient = KSHttpClient();

  Widget _buildNavbar() {
    return SliverAppBar(
      elevation: 0.5,
      forceElevated: true,
      centerTitle: true,
      title: Text('Register'),
      pinned: true,
    );
  }

  Widget _buildProfileImage() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16.0),
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () async {
            FocusScope.of(context).unfocus();
            selectImage(context, (image) {
              if (image != null) {
                _imageFile = image;
                setState(() {});
              }
            });
          },
          child: Stack(
            children: [
              Container(
                width: 112.0,
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    //border: Border.all(width: 2, color: Colors.cyan[50]!),
                    shape: BoxShape.circle),
                child: _imageFile != null
                    ? ClipOval(child: Image.file(_imageFile!))
                    : ClipOval(
                        child: Image.asset(
                          imgUserPlaceholder,
                          color: mainColor,
                          colorBlendMode: BlendMode.softLight,
                        ),
                      ),
              ),
              Positioned(
                right: 0.0,
                bottom: 0.0,
                child: CircleAvatar(
                  maxRadius: 18.0,
                  backgroundColor: whiteColor,
                  child: CircleAvatar(
                    maxRadius: 16.0,
                    backgroundColor: Colors.grey,
                    child: Container(
                      child: Icon(
                        Icons.camera_alt,
                        color: whiteColor,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoTextWidget() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Text(
          'Please input your basic information here!',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
    );
  }

  Widget _firstnameTextField() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 4.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'First name',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            TextField(
              controller: _fnTextController,
              style: Theme.of(context).textTheme.bodyText1,
              decoration: InputDecoration(
                isDense: true,
                hintText: 'first name',
                hintStyle: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(color: Colors.grey),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: mainColor),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: mainColor),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(width: 0.5, color: Colors.grey[300]!),
                ),
              ),
              onChanged: (text) {
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _lastnameTextField() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(top: 16.0),
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 4.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Last name',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            TextField(
              controller: _lnTextController,
              style: Theme.of(context).textTheme.bodyText1,
              decoration: InputDecoration(
                isDense: true,
                hintText: 'last name',
                hintStyle: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(color: Colors.grey),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: mainColor),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: mainColor),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(width: 0.5, color: Colors.grey[300]!),
                ),
              ),
              onChanged: (text) {
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }

  /*Widget _emailTextField() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(top: 16.0),
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 4.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Email',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            TextField(
              controller: _emailTextController,
              style: Theme.of(context).textTheme.bodyText1,
              decoration: InputDecoration(
                isDense: true,
                hintText: 'Email',
                hintStyle: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(color: Colors.grey),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: mainColor),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: mainColor),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(width: 0.5, color: Colors.grey[300]!),
                ),
              ),
              onChanged: (text) {
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }*/

  Widget _genderField() {
    return SliverToBoxAdapter(
      child: InkWell(
        onTap: selectGender,
        child: Container(
          margin: EdgeInsets.only(top: 16.0),
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 4.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Gender',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              IgnorePointer(
                ignoring: true,
                child: TextField(
                  controller: _genderTextController,
                  style: Theme.of(context).textTheme.bodyText1,
                  readOnly: true,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Select gender',
                    hintStyle: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(width: 0.5, color: Colors.grey[300]!),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(width: 0.5, color: Colors.grey[300]!),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _birthdateField() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(top: 16.0),
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 4.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date of Birth',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            TextField(
              style: Theme.of(context).textTheme.bodyText1,
              controller: _dobController,
              readOnly: true,
              decoration: InputDecoration(
                isDense: true,
                hintText: 'Select date of birth',
                hintStyle: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(color: Colors.grey),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(width: 0.5, color: Colors.grey[300]!),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(width: 0.5, color: Colors.grey[300]!),
                ),
              ),
              onTap: selectDateOfBirth,
            ),
          ],
        ),
      ),
    );
  }

  Widget _heightField() {
    return SliverToBoxAdapter(
      child: InkWell(
        onTap: selectHeight,
        child: Container(
          margin: EdgeInsets.only(top: 16.0),
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 4.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Height',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              IgnorePointer(
                ignoring: true,
                child: TextField(
                  controller: _heightTextController,
                  style: Theme.of(context).textTheme.bodyText1,
                  readOnly: true,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Select Height (optional)',
                    hintStyle: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(width: 0.5, color: Colors.grey[300]!),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(width: 0.5, color: Colors.grey[300]!),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _weightField() {
    return SliverToBoxAdapter(
      child: InkWell(
        onTap: selectWeight,
        child: Container(
          margin: EdgeInsets.only(top: 16.0),
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 4.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Weight',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              IgnorePointer(
                ignoring: true,
                child: TextField(
                  controller: _weightTextController,
                  style: Theme.of(context).textTheme.bodyText1,
                  readOnly: true,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Select weight (optional)',
                    hintStyle: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(width: 0.5, color: Colors.grey[300]!),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(width: 0.5, color: Colors.grey[300]!),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _btnSaveProfileWidget() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.only(
          left: 24,
          right: 24.0,
          top: 32.0,
          bottom: 16.0,
        ),
        height: 48.0,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: hasName() ? onStart : null,
          style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              backgroundColor: MaterialStateProperty.all(
                hasName() ? mainColor : Colors.grey[400],
              ),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)))),
          child: Text(
            'Save Profile',
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                color: whiteColor,
                fontWeight: FontWeight.w600,
                fontFamily: 'ProximaNova'),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: CustomScrollView(
            slivers: <Widget>[
              _buildNavbar(),
              _buildProfileImage(),
              _infoTextWidget(),
              _firstnameTextField(),
              _lastnameTextField(),
              //_emailTextField(),
              _genderField(),
              _birthdateField(),
              _heightField(),
              _weightField(),
              _btnSaveProfileWidget(),
            ],
          ),
        ),
      ),
    );
  }

  bool hasName() {
    return _fnTextController.text.trim().isNotEmpty &&
            _lnTextController.text.trim().isNotEmpty &&
            _genderTextController.text.isNotEmpty &&
            _dobController.text.isNotEmpty &&
            selectedGender != null
        ? true
        : false;
  }

  void onStart() async {
    showKSLoading(context);
    Map<String, String> fields = Map<String, String>();
    fields['phone'] = widget.phoneNumber;
    if (_fnTextController.text.trim().length > 0) {
      fields['first_name'] = _fnTextController.text;
    }
    if (_lnTextController.text.trim().length > 0) {
      fields['last_name'] = _lnTextController.text;
    }
    if (_emailTextController.text.isNotEmpty) {
      fields['email'] = _emailTextController.text;
    }
    if (selectedHeight != null) {
      fields['height'] = selectedHeight.toString();
    }
    if (selectedWeight != null) {
      fields['weight'] = selectedWeight.toString();
    }

    fields['gender'] = selectedGender!;

    fields['birth_date'] = DateFormat('yyyy-MM-dd').format(birthDate!);

    var data = await ksClient.postFileNoAuth('/user/register', _imageFile,
        fields: fields);
    if (data != null) {
      if (data is! HttpResult) {
        ksClient.setToken(data['token']);
        userRepository.persistHeaderToken(data['token']);
        userRepository.persistToken(data['refresh_token']);
        KS.shared.user = User.fromJson(data['user']);
        Navigator.pushNamedAndRemoveUntil(
            context, MainView.tag, (route) => false);
      } else {
        dismissScreen(context);
      }
    }
  }

  String? selectedGender;

  void selectGender() {
    showKSBottomSheet(context, title: 'Choose Gender', children: [
      RadioListTile<String>(
        value: 'male',
        groupValue: selectedGender,
        toggleable: true,
        onChanged: (value) {
          _genderTextController.text = value != null ? 'Male' : '';
          setState(() => selectedGender = value);
          dismissScreen(context);
        },
        title: Text('Male', style: Theme.of(context).textTheme.bodyText1),
      ),
      RadioListTile<String>(
        value: 'female',
        groupValue: selectedGender,
        toggleable: true,
        onChanged: (value) {
          _genderTextController.text = value != null ? 'Female' : '';
          setState(() => selectedGender = value);
          dismissScreen(context);
        },
        title: Text('Female', style: Theme.of(context).textTheme.bodyText1),
      ),
      RadioListTile<String>(
        value: 'other',
        groupValue: selectedGender,
        toggleable: true,
        onChanged: (value) {
          _genderTextController.text = value != null ? 'Other' : '';
          setState(() => selectedGender = value);
          dismissScreen(context);
        },
        title: Text('Other', style: Theme.of(context).textTheme.bodyText1),
      ),
    ]);
  }

  int? selectedHeight;

  void selectHeight() {
    showKSBottomSheet(
      context,
      title: 'Choose Height',
      children: List.generate(
        71,
        (index) {
          return RadioListTile<int>(
            value: 130 + index,
            groupValue: selectedHeight,
            toggleable: true,
            onChanged: (value) {
              _heightTextController.text = value != null ? '$value\cm' : '';
              setState(() => selectedHeight = value);
              dismissScreen(context);
            },
            title: Text('${130 + index}\cm',
                style: Theme.of(context).textTheme.bodyText1),
          );
        },
      ),
    );
  }

  int? selectedWeight;

  void selectWeight() {
    showKSBottomSheet(
      context,
      title: 'Choose Weight',
      children: List.generate(
        71,
        (index) {
          return RadioListTile<int>(
            value: 30 + index,
            groupValue: selectedWeight,
            toggleable: true,
            onChanged: (value) {
              _weightTextController.text = value != null ? '$value\kg' : '';
              setState(() => selectedWeight = value);
              dismissScreen(context);
            },
            title: Text('${30 + index}\kg',
                style: Theme.of(context).textTheme.bodyText1),
          );
        },
      ),
    );
  }

  String birthDateText = '';
  DateTime? birthDate;

  void selectDateOfBirth() async {
    DatePicker.showPicker(
      context,
      // locale: LocaleType.km,
      theme: DatePickerTheme(
        backgroundColor: Theme.of(context).primaryColor,
        doneStyle: TextStyle(
          color: ColorResources.getMainColor(context),
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          fontFamily: "OpenSans",
        ),
        cancelStyle: Theme.of(context).textTheme.bodyText1!,
        itemStyle: Theme.of(context).textTheme.bodyText1!,
      ),
      // pickerModel: CustomPicker(
      //     // locale: LocaleType.km,
      //     currentTime: birthDate != null ? birthDate : DateTime.now()),
      onConfirm: (dateTime) {
        var formatter = DateFormat('dd-MMMM-yyyy');
        birthDateText = formatter.format(dateTime);
        birthDate = dateTime;
        _dobController.text = birthDateText;
        setState(() {});
      },
    );
  }
}
