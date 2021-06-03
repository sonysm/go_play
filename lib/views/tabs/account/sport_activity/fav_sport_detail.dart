import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/models/sport.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/widgets/ks_confirm_dialog.dart';
import 'package:kroma_sport/widgets/ks_loading.dart';
import 'package:kroma_sport/widgets/ks_text_button.dart';
import 'package:kroma_sport/widgets/ks_widgets.dart';

class FavoriteSportDetailScreen extends StatefulWidget {
  static const String tag = '/favoriteSportDetailScreen';

  final Sport sport;

  FavoriteSportDetailScreen({
    Key? key,
    required this.sport,
  }) : super(key: key);

  @override
  _FavoriteSportDetailScreenState createState() =>
      _FavoriteSportDetailScreenState();
}

class _FavoriteSportDetailScreenState extends State<FavoriteSportDetailScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  KSHttpClient ksClient = KSHttpClient();

  Widget buildNavbar() {
    return SliverAppBar(
      title: Text(widget.sport.name),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: CustomScrollView(
        slivers: [
          buildNavbar(),
          emptyActivity(),
        ],
      ),
    );
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
                      'Are you sure you want to remove this sport from your favorite?',
                      () => removeFavSport(),
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
        .postApi('/user/remove/favorite/sport/${widget.sport.id}');
    if (data != null) {
      dismissScreen(context);
      if (data is! HttpResult) {
        dismissScreen(context, true);
      }
    }
  }
}
