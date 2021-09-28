import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/bloc/theme.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/repositories/user_repository.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/app_size.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/auth/get_started_screen.dart';
import 'package:kroma_sport/views/tabs/account/setting/about_screen.dart';
import 'package:kroma_sport/views/tabs/account/setting/block_account_screen.dart';
import 'package:kroma_sport/widgets/ks_confirm_dialog.dart';
import 'package:kroma_sport/widgets/ks_loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  static const String tag = '/settingScreen';

  SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final userRepository = UserRepository();

  KSHttpClient _ksClient = KSHttpClient();

  Widget buildNavbar() {
    return SliverAppBar(
      title: Text('Settings & Privacy'),
      elevation: 0.3,
      forceElevated: true,
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
              onTap: () => launchScreen(context, BlockAccountScreen.tag),
              title: Text(
                'Blocked Accounts',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ),
          Container(
            color: Theme.of(context).primaryColor,
            margin: EdgeInsets.only(top: 4.0),
            child: ListTile(
              onTap: () => launchScreen(context, AboutScreen.tag),
              title: Text(
                'About',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ),
          Container(
            color: Theme.of(context).primaryColor,
            margin: EdgeInsets.only(top: 4.0),
            child: ListTile(
              onTap: () {
                showKSConfirmDialog(
                  context,
                  message: 'Are you sure you want to logout?',
                  onYesPressed: () {
                    showKSLoading(context);
                    _ksClient.postApi('/user/logout', body: {'device_id': KS.shared.deviceId}).then((value) {
                      if (value != null && value is! HttpResult) {
                        userRepository.deleteToken();
                        userRepository.deleteHeaderToken();
                        Future.delayed(Duration(seconds: 1)).then(
                          (value) {
                            Navigator.pushNamedAndRemoveUntil(context, GetStartedScreen.tag, (route) => false);
                          },
                        );
                      }
                    });
                  },
                );
              },
              title: Text(
                'Logout',
                style: Theme.of(context).textTheme.bodyText1?.copyWith(color: Colors.red),
              ),
            ),
          )
        ],
      ),
    );
  }

  late ThemeMode _themeSetting;

  @override
  Widget build(BuildContext context) {
    _themeSetting = ThemeCubit.themeMode;
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
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // BlocProvider.of<ThemeCubit>(context)
    //     .emitTheme(isLight(context) ? ThemeMode.dark : ThemeMode.light);

    // prefs.setString('theme', isLight(context) ? 'dark' : 'light');

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animaiton, secondaryAnimation) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor:
              Theme.of(context).brightness == Brightness.light ? Color.fromRGBO(113, 113, 113, 1) : Color.fromRGBO(15, 15, 15, 1),
        ),
        child: AlertDialog(
          backgroundColor: ColorResources.getPrimary(context),
          titlePadding: EdgeInsets.only(
            top: 20,
            left: 40,
            right: AppSize(context).appWidth(100) / 3,
          ),
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text('Theme Setting'),
          content: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  child: Material(
                    color: Colors.transparent,
                    child: RadioListTile(
                        title: Text(
                          'System Default',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        value: ThemeMode.system,
                        groupValue: _themeSetting,
                        onChanged: (value) {
                          BlocProvider.of<ThemeCubit>(context).emitTheme(ThemeMode.system);
                          prefs.setString('theme', 'system');
                          Navigator.of(context).pop();
                        }),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  child: Material(
                    color: Colors.transparent,
                    child: RadioListTile(
                        title: Text(
                          'Dark Mode',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        value: ThemeMode.dark,
                        groupValue: _themeSetting,
                        onChanged: (value) {
                          BlocProvider.of<ThemeCubit>(context).emitTheme(ThemeMode.dark);
                          prefs.setString('theme', 'dark');
                          Navigator.of(context).pop();
                        }),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  child: Material(
                    color: Colors.transparent,
                    child: RadioListTile(
                        title: Text(
                          'Light Mode',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        value: ThemeMode.light,
                        groupValue: _themeSetting,
                        onChanged: (value) {
                          BlocProvider.of<ThemeCubit>(context).emitTheme(ThemeMode.light);
                          prefs.setString('theme', 'light');
                          Navigator.of(context).pop();
                        }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
