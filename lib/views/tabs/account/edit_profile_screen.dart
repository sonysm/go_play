import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/bloc/user.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/models/user.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/image_helper.dart';
import 'package:kroma_sport/utils/ks_images.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/widgets/cache_image.dart';
import 'package:kroma_sport/widgets/ks_loading.dart';
import 'package:kroma_sport/widgets/ks_message_dialog.dart';
import 'package:kroma_sport/widgets/ks_widgets.dart';

class EditProfileScreen extends StatefulWidget {
  static const tag = '/editProfileScreen';

  EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _imageFile;

  TextEditingController _fnTextController = TextEditingController();
  TextEditingController _lnTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _genderTextController = TextEditingController();
  TextEditingController _heightTextController = TextEditingController();
  TextEditingController _weightTextController = TextEditingController();
  TextEditingController _dobController = TextEditingController();

  KSHttpClient ksClient = KSHttpClient();

  String gender = 'Male';
  String selectedGender = '';

  Widget _buildNavbar() {
    return SliverAppBar(
      pinned: true,
      elevation: 0.5,
      forceElevated: true,
      centerTitle: true,
      title: Text('Edit profile'),
      actions: [
        TextButton(
          onPressed: saveProfile,
          child: Text(
            'Save',
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  color: isLight(context) ? mainColor : Colors.greenAccent,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ],
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
                        child: KS.shared.user.photo != null
                            ? SizedBox(
                                width: 112.0,
                                height: 112.0,
                                child: CacheImage(url: KS.shared.user.photo!),
                              )
                            : Image.asset(
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

  Widget _firstnameTextField() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
        margin: EdgeInsets.only(top: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Basic Info',
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            8.height,
            Text(
              'First name',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            4.height,
            TextField(
              controller: _fnTextController,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.grey[400]!)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: mainColor)),
                fillColor: Colors.white,
                labelStyle: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(fontWeight: FontWeight.w500),
                counterStyle: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        // controller: _firstnameController,
      ),
    );
  }

  Widget _lastnameTextField() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
        margin: EdgeInsets.only(top: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                'Last name',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            TextField(
              controller: _lnTextController,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.grey[400]!)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: mainColor)),
                fillColor: Colors.white,
                labelStyle: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(fontWeight: FontWeight.w500),
                counterStyle: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        // controller: _firstnameController,
      ),
    );
  }

  Widget _emailTextField() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
        margin: EdgeInsets.only(top: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                'Email',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            TextField(
              controller: _emailTextController,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                hintText: 'Email',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.grey[400]!)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: mainColor)),
                fillColor: Colors.white,
                labelStyle: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(fontWeight: FontWeight.w500),
                counterStyle: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _contactWidget() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.only(top: 16.0, bottom: 32.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact Info',
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            16.height,
            Row(
              children: <Widget>[
                Icon(Feather.phone, size: 18.0),
                8.width,
                Text(
                  KS.shared.user.phone!,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(fontSize: 18),
                  strutStyle: StrutStyle(fontSize: 18.0),
                ),
              ],
            ),
            if (KS.shared.user.email != null) ...[
              8.height,
              Row(
                children: <Widget>[
                  Icon(Feather.mail, size: 18.0),
                  8.width,
                  Text(
                    KS.shared.user.email!,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(fontSize: 18),
                    strutStyle: StrutStyle(fontSize: 18.0),
                  ),
                ],
              ),
            ],
            /*8.height,
            Row(
              children: <Widget>[
                Icon(Feather.map_pin, size: 18.0),
                8.width,
                Text(
                  'Phnom Penh, Cambodia',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(fontSize: 18),
                  strutStyle: StrutStyle(fontSize: 18.0),
                ),
              ],
            ),*/
          ],
        ),
      ),
    );
  }

  Widget _genderField() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
        margin: EdgeInsets.only(top: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gender',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            4.height,
            InkWell(
              onTap: selectGender,
              borderRadius: BorderRadius.circular(8.0),
              child: IgnorePointer(
                ignoring: true,
                child: TextField(
                  controller: _genderTextController,
                  style: Theme.of(context).textTheme.bodyText1,
                  readOnly: true,
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.keyboard_arrow_down_rounded),
                    hintText: 'Select gender',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.grey[400]!)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.grey[400]!)),
                    fillColor: Colors.white,
                    labelStyle: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(fontWeight: FontWeight.w500),
                    counterStyle: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _birthdateField() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
        margin: EdgeInsets.only(top: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                'Date of Birth',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            TextField(
              style: Theme.of(context).textTheme.bodyText1,
              controller: _dobController,
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'Choose date of birth',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.grey[400]!)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.grey[400]!)),
                fillColor: Colors.white,
                labelStyle: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(fontWeight: FontWeight.w500),
                counterStyle: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(fontWeight: FontWeight.w500),
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
          padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
          margin: EdgeInsets.only(top: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Height',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              IgnorePointer(
                ignoring: true,
                child: TextField(
                  controller: _heightTextController,
                  style: Theme.of(context).textTheme.bodyText1,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: 'Choose Height',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.grey[400]!)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.grey[400]!)),
                    fillColor: Colors.white,
                    labelStyle: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(fontWeight: FontWeight.w500),
                    counterStyle: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(fontWeight: FontWeight.w500),
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
          padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
          margin: EdgeInsets.only(top: 8.0, bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  'Weight',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              IgnorePointer(
                ignoring: true,
                child: TextField(
                  controller: _weightTextController,
                  style: Theme.of(context).textTheme.bodyText1,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: 'Choose weight',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.grey[400]!)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.grey[400]!)),
                    fillColor: Colors.white,
                    labelStyle: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(fontWeight: FontWeight.w500),
                    counterStyle: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
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
              _firstnameTextField(),
              _lastnameTextField(),
              _emailTextField(),
              _genderField(),
              _birthdateField(),
              _heightField(),
              _weightField(),
              sliverDivider(context, height: 4.0),
              _contactWidget(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fnTextController.text = KS.shared.user.firstName;
    _lnTextController.text = KS.shared.user.lastName;
    if (KS.shared.user.email != null) {
      _emailTextController.text = KS.shared.user.email!;
    }
    if (KS.shared.user.gender!.isNotEmpty) {
      selectedGender = KS.shared.user.gender!;
    }
    if (KS.shared.user.birthDate != null) {
      _dobController.text = DateFormat('dd-MMMM-yyyy')
          .format(DateTime.parse(KS.shared.user.birthDate!));
    }
    if (KS.shared.user.weight != null) {
      _weightTextController.text =
          KS.shared.user.weight!.toStringAsFixed(0) + 'kg';
    }
    if (KS.shared.user.height != null) {
      _heightTextController.text =
          KS.shared.user.height!.toStringAsFixed(0) + 'cm';
    }
    mapGender();
  }

  void saveProfile() async {
    Map<String, String> fields = Map<String, String>();
    var image;
    if (_fnTextController.text.trim().length < 3) {
      showKSMessageDialog(
          context, 'Please set your first name properly!', () {});
      return;
    }
    fields['first_name'] = _fnTextController.text;

    if (_lnTextController.text.trim().length < 3) {
      showKSMessageDialog(
          context, 'Please set your last name properly!', () {});
      return;
    }
    fields['last_name'] = _lnTextController.text;

    if (_emailTextController.text.isNotEmpty) {
      fields['email'] = _emailTextController.text;
    }
    if (selectedHeight != null) {
      fields['height'] = selectedHeight.toString();
    }
    if (selectedWeight != null) {
      fields['weight'] = selectedWeight.toString();
    }

    if (selectedGender.isNotEmpty) {
      fields['gender'] = selectedGender;
    }
    if (birthDate != null) {
      fields['birth_date'] = DateFormat('yyyy-MM-dd').format(birthDate!);
    }

    if (_imageFile != null) {
      List<int> imageData = _imageFile!.readAsBytesSync();
      image = MultipartFile.fromBytes(
        'photo',
        imageData,
        filename:
            'PF' + DateTime.now().millisecondsSinceEpoch.toString() + '.jpg',
      );
    }

    showKSLoading(context);
    // Future.delayed(Duration(seconds: 1)).then((value) {
    //   dismissScreen(context);
    //   dismissScreen(context);
    // });

    var result =
        await ksClient.postFile('/user/profile/update', image, fields: fields);
    if (result != null) {
      if (result is! HttpResult) {
        var user = User.fromJson(result);
        KS.shared.user = user;
        BlocProvider.of<UserCubit>(context).emitUser(user);
        dismissScreen(context);
        dismissScreen(context);
      }
    }
  }

  void selectGender() {
    showKSBottomSheet(context, title: 'Choose Gender', children: [
      RadioListTile<String>(
        value: 'male',
        activeColor: mainColor,
        groupValue: selectedGender,
        onChanged: (value) {
          _genderTextController.text = 'Male';
          setState(() => selectedGender = value!);
          dismissScreen(context);
        },
        title: Text('Male', style: Theme.of(context).textTheme.bodyText1),
      ),
      RadioListTile<String>(
        value: 'female',
        activeColor: mainColor,
        groupValue: selectedGender,
        onChanged: (value) {
          _genderTextController.text = 'Female';
          setState(() => selectedGender = value!);
          dismissScreen(context);
        },
        title: Text('Female', style: Theme.of(context).textTheme.bodyText1),
      ),
      RadioListTile<String>(
        value: 'other',
        activeColor: mainColor,
        groupValue: selectedGender,
        onChanged: (value) {
          _genderTextController.text = 'Other';
          setState(() => selectedGender = value!);
          dismissScreen(context);
        },
        title: Text('Other', style: Theme.of(context).textTheme.bodyText1),
      ),
    ]);
  }

  void mapGender() {
    switch (selectedGender) {
      case 'male':
        _genderTextController.text = 'Male';
        break;
      case 'female':
        _genderTextController.text = 'Female';
        break;
      case 'other':
        _genderTextController.text = 'Other';
        break;
      default:
        _genderTextController.text = '';
    }
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
            onChanged: (value) {
              _heightTextController.text = '$value\cm';
              setState(() => selectedHeight = value!);
              dismissScreen(context);
            },
            title: Text(
              '${130 + index}\cm',
              style: Theme.of(context).textTheme.bodyText1,
            ),
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
            onChanged: (value) {
              _weightTextController.text = '$value\kg';
              setState(() => selectedWeight = value!);
              dismissScreen(context);
            },
            title: Text(
              '${30 + index}\kg',
              style: Theme.of(context).textTheme.bodyText1,
            ),
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
        doneStyle: TextStyle(
          color: mainColor,
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          fontFamily: "OpenSans",
        ),
        itemStyle: TextStyle(
          color: blackColor,
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          fontFamily: "OpenSans",
        ),
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
