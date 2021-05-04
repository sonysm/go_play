import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/models/user.dart';
import 'package:kroma_sport/repositories/user_repository.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/image_helper.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/main.dart';
import 'package:kroma_sport/widgets/ks_loading.dart';

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

  final userRepository = UserRepository();

  Widget _buildNavbar() {
    return SliverAppBar(
      elevation: 0.5,
      forceElevated: true,
      centerTitle: true,
      title: Text('Register'),
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
                          'assets/images/user.jpg',
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Text(
          'Please input your first name and last name here!',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
    );
  }

  Widget _firstnameTextField() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
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
          horizontal: 16.0,
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
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: hasName() ? onStart : null,
        backgroundColor: hasName() ? mainColor : Colors.grey[400],
        child: Icon(
          Feather.chevron_right,
          size: 32.0,
          color: whiteColor,
        ),
      ),
    );
  }

  bool hasName() {
    return _fnTextController.text.trim().length > 2 ||
            _lnTextController.text.trim().length > 2
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
    var data = await KSHttpClient()
        .postFileNoAuth('/user/register', _imageFile, fields: fields);
    if (data != null) {
      if (data is! HttpResult) {
        userRepository.persistHeaderToken(data['token']);
        userRepository.persistToken(data['refresh_token']);
        KS.shared.user = userFromJson(data['user']);
        Navigator.pushNamedAndRemoveUntil(
            context, MainView.tag, (route) => false);
      } else {
        dismissScreen(context);
      }
    }
  }
}
