import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/models/user.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/views/tabs/account/team/widget/team_textfield.dart';
import 'package:kroma_sport/widgets/cache_image.dart';
import 'package:line_icons/line_icons.dart';

class PlayerScreen extends StatefulWidget {
  static const tag = '/playerScreen';
  final User player;
  PlayerScreen({Key? key, required this.player}) : super(key: key);

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late User _player;

  TextEditingController _roleController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _positionController = TextEditingController();
  TextEditingController _yearOfArrivalController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _jerseyNumberController = TextEditingController();
  TextEditingController _adminController = TextEditingController();

  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    setupData();
  }

  void setupData() {
    _player = widget.player;
    _emailController.text = _player.email ?? '';
    _phoneController.text = _player.phone!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          CupertinoButton(
            child: Icon(LineIcons.cog, color: ColorResources.getSecondaryIconColor(context)),
            onPressed: () {},
          )
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 180.0,
                color: ColorResources.getPrimary(context),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 56.0,
                      child: ClipOval(child: CacheImage(url: _player.photo!)),
                    ),
                    const SizedBox(height: 8.0),
                    Text(_player.getFullname(), style: Theme.of(context).textTheme.headline6),
                    const SizedBox(height: 4.0),
                    Text('Player-coach', style: Theme.of(context).textTheme.bodyText1),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0, bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('General information', style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w600, fontSize: 18)),
                    if (KS.shared.user.id == _player.id)
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        minSize: 32,
                        child: Icon(LineIcons.alternatePencil, color: Colors.black),
                        onPressed: () {},
                      ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                color: ColorResources.getPrimary(context),
                child: Column(
                  children: [
                    TeamTextField(
                      controller: _roleController,
                      labelText: 'Role',
                      isEditing: isEditing,
                    ),
                    const SizedBox(height: 8),
                    TeamTextField(
                      controller: _adminController,
                      labelText: 'Admin',
                      isEditing: isEditing,
                    ),
                    const SizedBox(height: 8),
                    TeamTextField(
                      controller: _emailController,
                      labelText: 'Email',
                      isEditing: isEditing,
                    ),
                    const SizedBox(height: 8),
                    TeamTextField(
                      controller: _phoneController,
                      labelText: 'Phone number',
                      isEditing: isEditing,
                    ),
                    const SizedBox(height: 8),
                    TeamTextField(
                      controller: _positionController,
                      labelText: 'Position',
                      isEditing: isEditing,
                    ),
                    const SizedBox(height: 8),
                    TeamTextField(
                      controller: _yearOfArrivalController,
                      labelText: 'Year of arrival',
                      isEditing: isEditing,
                    ),
                    const SizedBox(height: 8),
                    TeamTextField(
                      controller: _heightController,
                      labelText: 'Height',
                      isEditing: isEditing,
                    ),
                    const SizedBox(height: 8),
                    TeamTextField(
                      controller: _weightController,
                      labelText: 'Weight',
                      isEditing: isEditing,
                    ),
                    const SizedBox(height: 8),
                    TeamTextField(
                      controller: _jerseyNumberController,
                      labelText: 'Jersey number',
                      isEditing: isEditing,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
