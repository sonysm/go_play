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
import 'package:kroma_sport/views/tabs/venue/booking_history_screen.dart';
import 'package:kroma_sport/views/tabs/venue/venue_map_screen.dart';
import 'package:kroma_sport/views/tabs/venue/widget/venue_cell.dart';
import 'package:kroma_sport/widgets/ks_screen_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VenueScreen extends StatefulWidget {
  static const tag = '/venueScreen';

  VenueScreen({Key? key}) : super(key: key);

  @override
  _VenueScreenState createState() => _VenueScreenState();
}

class _VenueScreenState extends State<VenueScreen> with SingleTickerProviderStateMixin {
  KSHttpClient ksClient = KSHttpClient();

  List<Venue> venueList = [];

  bool isConnection = false;

  bool isLoading = true;

  late AnimationController _animationController;
  late Animation<double> _animation;

  int? _crossAxisCount;
  double? _childAspectRatio;

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
                    childAspectRatio: _childAspectRatio ?? 1.3,
                    crossAxisCount: _crossAxisCount ?? 2,
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
            ),
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
            // alignment: Alignment.centerRight,
            child: Icon(
              FeatherIcons.map,
              color: ColorResources.getSecondaryIconColor(context),
              size: 20.0,
            ),
            onPressed: () => launchScreen(context, VenueMapScreen.tag, arguments: venueList),
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            // alignment: Alignment.centerRight,
            child: Icon(
              (_crossAxisCount != null && _crossAxisCount == 2) ? FeatherIcons.list : FeatherIcons.grid,
              color: ColorResources.getSecondaryIconColor(context),
              size: 20.0,
            ),
            onPressed: changeVenueView,
          ),
          // CupertinoButton(
          //   padding: EdgeInsets.zero,
          //   child: Icon(
          //     Icons.history,
          //     color: ColorResources.getSecondaryIconColor(context),
          //   ),
          //   onPressed: () => launchScreen(context, BookingHistoryScreen.tag),
          // ),
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
    getListviewSetting();
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

  void getListviewSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getBool('isGrid') != null) {
      if (prefs.getBool('isGrid')!) {
        _crossAxisCount = 2;
        _childAspectRatio = 1.3;
      } else {
        _crossAxisCount = 1;
        _childAspectRatio = 1.7;
      }
    } else {
      _crossAxisCount = 2;
      _childAspectRatio = 1.3;
    }

    setState(() {});
  }

  void changeVenueView() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getBool('isGrid') != null) {
      prefs.setBool('isGrid', !prefs.getBool('isGrid')!);
    } else {
      prefs.setBool('isGrid', false);
    }
    getListviewSetting();
  }
}
