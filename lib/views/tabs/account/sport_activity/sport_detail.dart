import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/models/sport.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/widgets/ks_confirm_dialog.dart';
import 'package:kroma_sport/widgets/ks_loading.dart';

class SportDetailScreen extends StatefulWidget {
  static const String tag = '/sportDetailScreen';

  final Sport sport;

  SportDetailScreen({
    Key? key,
    required this.sport,
  }) : super(key: key);

  @override
  _SportDetailScreenState createState() => _SportDetailScreenState();
}

class _SportDetailScreenState extends State<SportDetailScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  KSHttpClient ksClient = KSHttpClient();

  Widget buildNavbar() {
    return SliverAppBar(
      title: Text(widget.sport.name),
      actions: [
        widget.sport.fav!
            ? CupertinoButton(
                child: Icon(FeatherIcons.moreHorizontal,
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.grey[600]
                        : whiteColor),
                onPressed: () => showOptionActionBottomSheet(),
              )
            : SizedBox()
      ],
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(horizontal: 0.0)),
                  ),
                  onPressed: () {
                    dismissScreen(context);
                    showKSConfirmDialog(
                      context,
                      message: 'Are you sure you want to remove this sport from your favorite?',
                      onYesPressed: () => removeFavSport(),
                    );
                  },
                  child: Container(
                    height: 54.0,
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Icon(
                            Feather.trash_2,
                            color: Colors.blueGrey[700],
                          ),
                        ),
                        Text(
                          'Remove from favorite sport',
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  ),
                ),
                30.height,
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
