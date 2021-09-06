import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/models/venue.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/notification/notifitcation_screen.dart';
import 'package:kroma_sport/views/tabs/venue/booking_history_screen.dart';
import 'package:kroma_sport/views/tabs/venue/widget/venue_cell.dart';
import 'package:kroma_sport/widgets/ks_screen_state.dart';

class VenueScreen extends StatefulWidget {
  static const tag = '/venueScreen';

  VenueScreen({Key? key}) : super(key: key);

  @override
  _VenueScreenState createState() => _VenueScreenState();
}

class _VenueScreenState extends State<VenueScreen> with SingleTickerProviderStateMixin {
  List<String> venueImageList = [
    'https://images.unsplash.com/photo-1487466365202-1afdb86c764e?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1052&q=80',
    'https://images.unsplash.com/photo-1510526292299-20af3f62d453?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1014&q=80',
    'https://images.unsplash.com/photo-1511439664149-58b346f60448?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=675&q=80',
    'https://images.unsplash.com/photo-1596740327709-1645e2562a37?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=924&q=80',
    'https://images.unsplash.com/photo-1531861218190-f90c89febf69?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1050&q=80'
  ];

  List<String> venueNameList = [
    'XP Sport',
    'Downtown Sport Club',
    'Rooy7 Sport Club',
    'Emperial Sport Club',
    'Champion Sport Club',
  ];

  KSHttpClient ksClient = KSHttpClient();

  List<Venue> venueList = [];

  bool isConnection = false;

  bool isLoading = true;

  late AnimationController _animationController;
  late Animation<double> _animation;

  Widget buildVenueList() {
    if (isLoading) {
      return SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.greenAccent)),
        ),
      );
    }

    return venueList.isNotEmpty
        ? SliverFillRemaining(
            child: EasyRefresh(
            header: MaterialHeader(
              valueColor: AlwaysStoppedAnimation<Color>(mainColor),
            ),
            child: FadeTransition(
              opacity: _animation,
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1.3,
                  crossAxisCount: 2,
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                  // mainAxisExtent: 150
                ),
                padding: const EdgeInsets.all(8.0),
                itemCount: venueList.length,
                itemBuilder: (_, index) {
                  final venue = venueList[index];
                  return VenueCell(venue: venue);
                },
              ),
            ),
            onRefresh: () async {},
          )

            // ListView.separated(
            //   shrinkWrap: true,
            //   physics: NeverScrollableScrollPhysics(),
            //   padding: const EdgeInsets.only(bottom: 8.0),
            //   itemBuilder: (context, index) {
            //     final venue = venueList[index];
            //     return Padding(
            //       padding: EdgeInsets.only(top: index == 0 ? 8.0 : 0),
            //       child: VenueCell(venue: venue),
            //     );
            //   },
            //   separatorBuilder: (context, index) {
            //     return 8.height;
            //   },
            //   itemCount: venueList.length,
            // ),
            )
        : SliverFillRemaining(
            child: KSScreenState(
              icon: RotatedBox(
                quarterTurns: 3,
                child: SvgPicture.asset(
                  'assets/images/svg_football_field.svg',
                  color: Colors.grey,
                  height: 100,
                ),
              ),
              title: 'No any available venue',
              bottomPadding: AppBar().preferredSize.height,
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Venues'),
        elevation: 0.5,
        actions: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.history,
              color: ColorResources.getSecondaryIconColor(context),
            ),
            onPressed: () => launchScreen(context, BookingHistoryScreen.tag),
          ),
          CupertinoButton(
            child: Icon(
              FeatherIcons.bell,
              color: ColorResources.getSecondaryIconColor(context),
            ),
            onPressed: () => launchScreen(context, NotificationScreen.tag),
          ),
          SizedBox(),
        ],
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: CustomScrollView(
        slivers: [
          buildVenueList(),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 700));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController);

    getVenueList();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
        venueList = List<Venue>.from((res as List).map((e) => Venue.fromJson(e)));
      } else {
        if (res.code == -500) {
          isConnection = false;
        }
      }

      isLoading = false;
      await Future.delayed(Duration.zero);
      setState(() {});
      _animationController.forward();
    }
  }
}
