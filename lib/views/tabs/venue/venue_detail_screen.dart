import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/models/venue.dart';
import 'package:kroma_sport/models/venue_detail.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/app_size.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/venue/pitch_booking_screen.dart';
import 'package:kroma_sport/widgets/cache_image.dart';

class VenueDetailScreen extends StatefulWidget {
  static const tag = '/venueDetailScreen';

  final Venue venue;

  VenueDetailScreen({
    Key? key,
    required this.venue,
  }) : super(key: key);

  @override
  _VenueDetailScreenState createState() => _VenueDetailScreenState();
}

class _VenueDetailScreenState extends State<VenueDetailScreen> {
  List<String> facilityList = [
    'Parking',
    'Bath',
    'Changing Room',
    'Drinking Water Room'
  ];

  late Venue _venue;
  bool isMaploaded = false;
  List<VenueService> venueServiceList = [];

  KSHttpClient ksClient = KSHttpClient();

  Widget buildVenueNavbar() {
    return SliverPersistentHeader(
      pinned: true,
      floating: true,
      delegate: VenueDetailHeader(
        toolbarHeight: MediaQuery.of(context).padding.top - 4,
        openHeight: AppSize(context).appWidth(70),
        closeHeight: kToolbarHeight,
      ),
    );
  }

  Widget buildVenueTitle() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _venue.name,
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.amber[700],
                        ),
                        4.width,
                        Text(
                          '4.5',
                          style:
                              Theme.of(context).textTheme.bodyText1?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18.0,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Divider(),
            Text(
              'Sport type',
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color:
                      isLight(context) ? Colors.grey[600] : Colors.grey[100]),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Text('⚽️', style: TextStyle(fontSize: 24.0)),
                  16.width,
                  Text('🏀', style: TextStyle(fontSize: 24.0)),
                  16.width,
                  Text('🏐', style: TextStyle(fontSize: 24.0)),
                ],
              ),
            ),
            Divider(),
            8.height,
            Text(
              'Facilites',
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color:
                      isLight(context) ? Colors.grey[600] : Colors.grey[100]),
            ),
            8.height,
            Wrap(
              children: facilityList.map(
                (e) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: isLight(context)
                          ? Colors.grey[100]
                          : Colors.blueGrey[400],
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Text(
                      e,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  );
                },
              ).toList(),
              runSpacing: 8.0,
              spacing: 8.0,
            ),
            Divider(
              height: 32.0,
            ),
            Text(
              'Description',
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color:
                      isLight(context) ? Colors.grey[600] : Colors.grey[100]),
            ),
            8.height,
            Text(
              'Town class venue where you can meet many qualified team in town and have match to become a champion futsal leage.',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Divider(
              height: 32.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildVenueLocation() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
            child: Text(
              'Location',
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color:
                      isLight(context) ? Colors.grey[600] : Colors.grey[100]),
            ),
          ),
          Container(
            height: 200.0,
            color: Colors.grey[100],
            width: AppSize(context).appWidth(100),
            child: isMaploaded
                ? GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        double.parse(_venue.latitude),
                        double.parse(_venue.latitude),
                      ),
                      zoom: 15.0,
                    ),
                    onMapCreated: (controller) {},
                    zoomGesturesEnabled: false,
                    scrollGesturesEnabled: false,
                    markers: <Marker>{
                      Marker(
                        markerId: MarkerId('venue'),
                        position: LatLng(
                          double.parse(_venue.latitude),
                          double.parse(_venue.latitude),
                        ),
                      ),
                    },
                  )
                : SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget buildPitchCell(
      {required String pitchName,
      required String pitchPrice,
      required VenueService venueService}) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isLight(context) ? Colors.grey[100] : Colors.blueGrey[400],
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pitchName,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              4.height,
              Text(
                pitchPrice,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Spacer(),
          ElevatedButton(
            onPressed: () {
              launchScreen(
                context,
                PitchBookingScreen.tag,
                arguments: {
                  'venue': _venue,
                  'venueService': venueService,
                },
              );
            },
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              backgroundColor: MaterialStateProperty.all(
                  isLight(context) ? mainColor : Color(0xFF2ecc71)),
              minimumSize: MaterialStateProperty.all(Size(0, 0)),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: MaterialStateProperty.all(
                EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
              ),
            ),
            child: Text(
              'Book',
              style: TextStyle(
                color: whiteColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAvailablePitch() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select sport type',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            8.height,
            ElevatedButton(
              onPressed: showSportTypeOption,
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all(
                    isLight(context) ? Colors.grey[100] : Colors.blueGrey[400]),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  side: BorderSide(color: Colors.grey[200]!),
                )),
                padding: MaterialStateProperty.all(
                  EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    'Futsal / Football',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Spacer(),
                  Icon(FeatherIcons.chevronDown,
                      color: isLight(context) ? blackColor : whiteColor),
                ],
              ),
            ),
            16.height,
            Text(
              'Available pitches:',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            8.height,
            venueServiceList.isNotEmpty
                ? ListView.separated(
                    padding: EdgeInsets.only(bottom: 16.0),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final service = venueServiceList[index];
                      return buildPitchCell(
                        pitchName: service.name +
                            ' (${service.serviceData.people! ~/ 2}x${service.serviceData.people! ~/ 2})',
                        pitchPrice:
                            '\$${service.hourPrice.toStringAsFixed(2)}/h',
                        venueService: service,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return 8.height;
                    },
                    itemCount: venueServiceList.length)
                : SizedBox()
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: EasyRefresh.custom(
        header: MaterialHeader(
          valueColor: AlwaysStoppedAnimation<Color>(mainColor),
        ),
        slivers: [
          buildVenueNavbar(),
          buildVenueTitle(),
          buildVenueLocation(),
          buildAvailablePitch(),
        ],
        onRefresh: () async {},
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _venue = widget.venue;
    getVenueDetail();
  }

  void showSportTypeOption() {
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
            padding: EdgeInsets.only(bottom: 36.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(
                      top: 16.0, left: 16.0, bottom: 16.0),
                  child: Text(
                    'Choose sport type',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(horizontal: 0.0)),
                  ),
                  onPressed: () {
                    dismissScreen(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    decoration: BoxDecoration(
                      color: isLight(context)
                          ? Colors.grey[200]
                          : Colors.blueGrey[400],
                      // border: Border.all(color: isLight(context) ? Colors.grey[300]! : Colors.grey[200]!),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Row(
                      children: <Widget>[
                        Text(
                          '⚽️  Futsal / Football',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        Spacer(),
                        Icon(
                          Feather.check,
                          color:
                              isLight(context) ? mainColor : Colors.greenAccent,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void getVenueDetail() async {
    var res = await ksClient.getApi('/venue/detail/${_venue.id}');
    if (res != null) {
      if (res is! HttpResult) {
        var detail = VenueDetail.fromJson(res);
        _venue = detail.venue;
        venueServiceList = detail.service;

        Future.delayed(Duration(milliseconds: 300)).then((_) {
          isMaploaded = true;
          setState(() {});
        });
      }
    }
  }
}

class VenueDetailHeader extends SliverPersistentHeaderDelegate {
  double toolbarHeight;
  double closeHeight;
  double openHeight;

  VenueDetailHeader({
    required this.toolbarHeight,
    required this.closeHeight,
    required this.openHeight,
  });

  List<String> venueImageList = [
    'https://images.unsplash.com/photo-1487466365202-1afdb86c764e?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1052&q=80',
    'https://images.unsplash.com/photo-1510526292299-20af3f62d453?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1014&q=80',
    'https://images.unsplash.com/photo-1511439664149-58b346f60448?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=675&q=80',
    'https://images.unsplash.com/photo-1596740327709-1645e2562a37?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=924&q=80',
    'https://images.unsplash.com/photo-1531861218190-f90c89febf69?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1050&q=80'
  ];

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: openHeight,
      color: whiteColor,
      child: Stack(
        children: <Widget>[
          Container(
            width: AppSize(context).appWidth(100),
            height: openHeight,
            color: Colors.grey[200],
            child: Stack(
              children: [
                Swiper(
                  itemCount: venueImageList.length,
                  itemBuilder: (context, index) => Container(
                    child: CacheImage(
                      url: venueImageList[index],
                    ),
                  ),
                  curve: Curves.easeInOutCubic,
                  autoplay: true,
                  loop: false,
                  // autoplayDelay: 5000,
                  // duration: 850,
                  pagination: venueImageList.length > 1
                      ? SwiperPagination(
                          builder: DotSwiperPaginationBuilder(
                            activeColor: mainColor,
                            color: Colors.grey[100],
                            size: 8.0,
                            activeSize: 8.0,
                          ),
                        )
                      : null,

                  // onTap: (index) {},
                ),
              ],
            ),
          ),
          SizedBox(
            child: AppBar(
              leading: Container(
                alignment: Alignment.center,
                width: 38.0,
                height: 38.0,
                margin: EdgeInsets.only(left: 16.0, right: 8.0),
                decoration: BoxDecoration(
                  color: (1 - shrinkOffset / openHeight) > 0.7
                      ? blackColor.withOpacity(0.6)
                      : Theme.of(context)
                          .primaryColor
                          .withOpacity(backgroundOpacity(shrinkOffset)),
                  shape: BoxShape.circle,
                ),
                child: CupertinoButton(
                  onPressed: () => Navigator.pop(context, 1),
                  padding: EdgeInsets.zero,
                  child: Icon(
                    Icons.arrow_back,
                    color: (1 - shrinkOffset / openHeight) > 0.7
                        ? whiteColor
                        : mainColor,
                    size: 22.0,
                  ),
                ),
              ),
              title: Text(
                'Downtown Sport Club',
                style: TextStyle(
                  color: shrinkOffset < openHeight - 100
                      ? Colors.transparent
                      : isLight(context)
                          ? mainColor
                          : whiteColor,
                ),
              ),
              titleSpacing: 0,
              backgroundColor: shrinkOffset < openHeight - 100
                  ? Colors.transparent
                  : Theme.of(context).primaryColor,
              elevation: 0,
            ),
            height: MediaQuery.of(context).padding.top + 54.0,
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => openHeight;

  @override
  double get minExtent => toolbarHeight + closeHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;

  double backgroundOpacity(double shrinkOffset) =>
      (shrinkOffset / (openHeight - toolbarHeight)) < 1
          ? (shrinkOffset / (openHeight - toolbarHeight))
          : 1;
}
