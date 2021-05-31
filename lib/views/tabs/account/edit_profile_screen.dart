import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:http/http.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/app_size.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/image_helper.dart';
import 'package:kroma_sport/utils/ks_images.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/widgets/cache_image.dart';
import 'package:kroma_sport/widgets/ks_message_dialog.dart';
import 'package:kroma_sport/widgets/ks_widgets.dart';
import 'package:line_icons/line_icons.dart';
import 'package:toggle_switch/toggle_switch.dart';

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

  KSHttpClient ksClient = KSHttpClient();

  String gender = 'Male';

  Widget _buildNavbar() {
    return SliverAppBar(
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
                  color: mainColor,
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

  Widget _genderWidget() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.only(top: 16.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 4.0),
              alignment: Alignment.centerLeft,
              child: Text(
                'Gender',
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              height: 54.0,
              child: ToggleSwitch(
                minWidth: AppSize(context).appWidth(50),
                cornerRadius: 4,
                activeBgColor: mainColor,
                activeFgColor: Colors.white,
                inactiveBgColor: Colors.grey[350],
                inactiveFgColor: Colors.white,
                fontSize: 16.0,
                labels: ['Male', 'Female'],
                initialLabelIndex: 0,
                icons: [LineIcons.mars, LineIcons.venus],
                onToggle: (index) {
                  switch (index) {
                    case 0:
                      gender = 'Male';
                      break;
                    case 1:
                      gender = 'Female';
                      break;
                    default:
                      gender = 'Female';
                  }
                },
              ),
            ),
            16.height,
          ],
        ),
      ),
    );
  }

  Widget _phoneWidget() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.only(top: 16.0),
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
                Icon(Feather.phone),
                8.width,
                Text(
                  KS.shared.user.phone!,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(fontSize: 18),
                ),
              ],
            ),
            16.height,
            Row(
              children: <Widget>[
                Icon(Feather.mail),
                8.width,
                Text(
                  KS.shared.user.lastName.toLowerCase() + '@example.com',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(fontSize: 18),
                ),
              ],
            ),
            16.height,
            Row(
              children: <Widget>[
                Icon(Feather.map_pin),
                8.width,
                Text(
                  'Phnom Penh, Cambodia',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(fontSize: 18),
                ),
              ],
            ),
          ],
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
              _genderWidget(),
              sliverDivider(context, height: 4.0),
              _phoneWidget(),
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
  }

  void saveProfile() async {
    Map<String, String> fields = Map<String, String>();
    var image;
    if (_fnTextController.text.trim().length < 3) {
      showKSMessageDialog(
          context, 'Please set your first name properly!', () {});
      return;
    }

    if (_lnTextController.text.trim().length < 3) {
      showKSMessageDialog(
          context, 'Please set your last name properly!', () {});
      return;
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

    dismissScreen(context);

    // var result = await ksClient.postFile('url', image);
  }
}
