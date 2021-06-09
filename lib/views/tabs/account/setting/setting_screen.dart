import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kroma_sport/bloc/theme.dart';
import 'package:kroma_sport/repositories/user_repository.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/auth/login_screen.dart';
import 'package:kroma_sport/widgets/ks_complete_dialog.dart';
import 'package:kroma_sport/widgets/ks_confirm_dialog.dart';
import 'package:kroma_sport/widgets/ks_loading.dart';

class SettingScreen extends StatefulWidget {
  static const String tag = '/settingScreen';

  SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final userRepository = UserRepository();

  Widget buildNavbar() {
    return SliverAppBar(
      title: Text('Settings'),
      titleSpacing: 0,
    );
  }

  Widget settingList() {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Container(
            color: Theme.of(context).primaryColor,
            margin: EdgeInsets.only(top: 4.0),
            child: ListTile(
              onTap: changeTheme,
              title: Text(
                'Change Theme',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ),
          Container(
            color: Theme.of(context).primaryColor,
            margin: EdgeInsets.only(top: 4.0),
            child: ListTile(
              title: Text(
                'version 1.0.2',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ),
          Container(
            color: Theme.of(context).primaryColor,
            margin: EdgeInsets.only(top: 4.0),
            child: ListTile(
              onTap: () {
                showKSConfirmDialog(context, 'Are you sure you want to logout?',
                    () {
                  showKSLoading(context);
                  userRepository.deleteToken();
                  userRepository.deleteHeaderToken();
                  Future.delayed(Duration(seconds: 1)).then((value) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, LoginScreen.tag, (route) => false);
                  });
                });
              },
              title: Text(
                'Logout',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(color: Colors.red),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          buildNavbar(),
          settingList(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void changeTheme() async {
    // showKSLoading(context);
    // await Future.delayed(Duration(milliseconds: 700));
    BlocProvider.of<ThemeCubit>(context)
        .emitTheme(isLight(context) ? ThemeMode.dark : ThemeMode.light);
    await Future.delayed(Duration(milliseconds: 1200));
    // dismissScreen(context);
    if (mounted) {
      showKSComplete(context, message: 'Theme changed!');
      await Future.delayed(Duration(milliseconds: 1500));
      dismissScreen(context);
    }
  }
}
