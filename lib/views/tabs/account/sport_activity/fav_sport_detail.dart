import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/models/sport.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/app_size.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/widgets/ks_confirm_dialog.dart';
import 'package:kroma_sport/widgets/ks_loading.dart';
import 'package:kroma_sport/widgets/ks_text_button.dart';
import 'package:kroma_sport/widgets/ks_widgets.dart';
import 'package:toggle_switch/toggle_switch.dart';

class FavoriteSportDetailScreen extends StatefulWidget {
  static const String tag = '/favoriteSportDetailScreen';

  final FavoriteSport favSport;

  FavoriteSportDetailScreen({
    Key? key,
    required this.favSport,
  }) : super(key: key);

  @override
  _FavoriteSportDetailScreenState createState() =>
      _FavoriteSportDetailScreenState();
}

class _FavoriteSportDetailScreenState extends State<FavoriteSportDetailScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  KSHttpClient ksClient = KSHttpClient();

  late FavoriteSport _favSport;
  late int skillLevel;

  Widget buildNavbar() {
    return SliverAppBar(
      elevation: 0.5,
      forceElevated: true,
      title: Text(widget.favSport.sport.name),
      // actions: [
      //   CupertinoButton(
      //     child: Icon(FeatherIcons.moreHorizontal,
      //         color: Theme.of(context).brightness == Brightness.light
      //             ? Colors.grey[600]
      //             : whiteColor),
      //     onPressed: () => showOptionActionBottomSheet(),
      //   ),
      // ],
    );
  }

  Widget emptyActivity() {
    return SliverToBoxAdapter(
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(
            top: (MediaQuery.of(context).size.height / 2) -
                AppBar().preferredSize.height),
        child: Text('No activity yet'),
      ),
    );
  }

  Widget buildContent() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          children: [
            Text(
              'Skill Level',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            8.height,
            ToggleSwitch(
              minHeight: 50,
              minWidth: AppSize(context).appWidth(90 / 3),
              fontSize: 16.0,
              initialLabelIndex: skillLevel,
              activeBgColor: [mainColor],
              activeFgColor: Colors.white,
              cornerRadius: 8.0,
              inactiveBgColor: Colors.grey[200],
              inactiveFgColor: Colors.grey[900],
              totalSwitches: 3,
              labels: ['Begineer', 'Intermediate', 'Advanced'],
              onToggle: (index) {
                print('switched to: $index');
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
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      body: CustomScrollView(
        slivers: [
          buildNavbar(),
          // emptyActivity(),
          buildContent(),
        ],
      ),
    );
  }

  

  @override
  void initState() {
    super.initState();
    _favSport = widget.favSport;
    skillLevel = widget.favSport.playLevel!;
  }

  void showOptionActionBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return SafeArea(
          maintainBottomViewPadding: true,
          child: Container(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                bottomSheetBar(context),
                KSTextButtonBottomSheet(
                  title: 'Remove from favorite sport',
                  icon: Feather.info,
                  onTab: () {
                    dismissScreen(context);
                    showKSConfirmDialog(
                      context,
                      message:
                          'Are you sure you want to remove this sport from your favorite?',
                      onYesPressed: () => removeFavSport(),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void removeFavSport() async {
    showKSLoading(context);
    var data = await ksClient
        .postApi('/user/remove/favorite/sport/${widget.favSport.sport.id}');
    if (data != null) {
      dismissScreen(context);
      if (data is! HttpResult) {
        dismissScreen(context, true);
      }
    }
  }
}
