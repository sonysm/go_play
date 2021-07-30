import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/models/venue.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/notification/notifitcation_screen.dart';
import 'package:kroma_sport/views/tabs/venue/widget/venue_cell.dart';
import 'package:kroma_sport/widgets/ks_widgets.dart';

class VenueScreen extends StatefulWidget {
  static const tag = '/venueScreen';

  VenueScreen({Key? key}) : super(key: key);

  @override
  _VenueScreenState createState() => _VenueScreenState();
}

class _VenueScreenState extends State<VenueScreen> {
  List<String> venueImageList = [
    'https://images.unsplash.com/photo-1487466365202-1afdb86c764e?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1052&q=80',
    'https://images.unsplash.com/photo-1510526292299-20af3f62d453?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1014&q=80',
    'https://images.unsplash.com/photo-1511439664149-58b346f60448?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=675&q=80',
    'https://images.unsplash.com/photo-1596740327709-1645e2562a37?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=924&q=80',
    'https://images.unsplash.com/photo-1531861218190-f90c89febf69?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1050&q=80'
  ];

  List<String> venueNameList = [
    'Downtown Sport Club',
    'Rooy7 Sport Club',
    'Emperial Sport Club',
    'Rama Sport Club',
    'Champion Sport Club',
  ];

  KSHttpClient ksClient = KSHttpClient();

  List<Venue> venueList = [];

  bool isConnection = false;

  Widget buildVenueList() {
    return SliverToBoxAdapter(
      child: venueList.isNotEmpty
          ? ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 8.0),
              itemBuilder: (context, index) {
                final venue = venueList[index];
                return Padding(
                  padding: EdgeInsets.only(top: index == 0 ? 8.0 : 0),
                  child: VenueCell(venue: venue),
                );
              },
              separatorBuilder: (context, index) {
                return 8.height;
              },
              itemCount: venueList.length,
            )
          : Container(
              margin: const EdgeInsets.only(top: 100.0),
              child: Center(
                child: Text('No any available venue.'),
              ),
            ),
    );
  }

  Widget noInternet() {
    return SliverFillRemaining(
      child: noConnection(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Venues'),
        elevation: 0.0,
        actions: [
          //CupertinoButton(
          //  padding: EdgeInsets.zero,
          //  alignment: Alignment.centerRight,
          //  child: Icon(Icons.history,
          //      color: Theme.of(context).brightness == Brightness.light
          //          ? Colors.grey[600]
          //          : whiteColor),
          //  onPressed: () => launchScreen(context, BookingHistoryScreen.tag),
          //),
          CupertinoButton(
            child: Icon(FeatherIcons.bell,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey[600]
                    : whiteColor),
            onPressed: () => launchScreen(context, NotificationScreen.tag),
          ),
          SizedBox(),
        ],
      ),
      // backgroundColor: Theme.of(context).primaryColor,
      body: EasyRefresh.custom(
        header: MaterialHeader(
          valueColor: AlwaysStoppedAnimation<Color>(mainColor),
        ),
        slivers: [
          isConnection ? buildVenueList() : noInternet(),
        ],
        onRefresh: () async {
          getVenueList();
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getVenueList();
  }

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  void getVenueList() async {
    var res = await ksClient.getApi('/venue/list');
    if (res != null) {
      if (res is! HttpResult) {
        isConnection = true;
        venueList =
            List<Venue>.from((res as List).map((e) => Venue.fromJson(e)));
      } else {
        if (res.code == -500) {
          isConnection = false;
        }
      }
      setState(() {});
    }
  }
}
