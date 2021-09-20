import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/models/sport.dart';
import 'package:kroma_sport/models/venue.dart';
import 'package:kroma_sport/models/venue_detail.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/app_size.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/venue/pitch_booking_screen.dart';
import 'package:kroma_sport/widgets/cache_image.dart';
import 'package:kroma_sport/widgets/ks_widgets.dart';
import 'package:marquee/marquee.dart';

class VenueDetailScreen extends StatefulWidget {
  static const tag = '/venueDetailScreen';

  final Venue venue;
  final String heroTag;

  VenueDetailScreen({
    Key? key,
    required this.venue,
    this.heroTag = '',
  }) : super(key: key);

  @override
  _VenueDetailScreenState createState() => _VenueDetailScreenState();
}

class _VenueDetailScreenState extends State<VenueDetailScreen> {
  late Venue _venue;
  bool isMaploaded = false;
  List<VenueService> venueServiceList = [];
  List<VenueService> venueServiceBySportType = [];

  KSHttpClient ksClient = KSHttpClient();

  Sport? sportTypeSelected;

  List<VenueCover> venueCoverList = [];

  Widget buildVenueNavbar() {
    return SliverPersistentHeader(
      pinned: true,
      floating: true,
      delegate: VenueDetailHeader(
        toolbarHeight: MediaQuery.of(context).padding.top - 4,
        openHeight: AppSize(context).appWidth(70),
        closeHeight: kToolbarHeight,
        venue: _venue,
        heroTag: widget.heroTag,
        coverList: venueCoverList,
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _venue.name,
                        style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      4.height,
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber[700],
                          ),
                          4.width,
                          Text(
                            '4.5',
                            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18.0,
                                ),
                            strutStyle: StrutStyle(fontSize: 18.0, height: 1.3),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(),
            if (_venue.venueService != null && _venue.venueService!.isNotEmpty && _venue.venueService!.any((element) => element.status == 1)) ...[
              Text(
                'Sport type',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: isLight(context) ? Colors.grey[600] : Colors.grey[100]),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Wrap(
                  children: _venue.venueService!
                      .where((element) => element.status != 0)
                      .map(
                        (venueService) => InkWell(
                          onTap: () => showSportTypeTitle(venueService.sport.name),
                          child: SizedBox(width: 32.0, height: 32.0, child: CacheImage(url: venueService.sport.icon!)),
                        ),
                      )
                      .toList(),
                  runSpacing: 16.0,
                  spacing: 24.0,
                ),
              ),
              Divider(),
            ],
            if (_venue.venueFacility != null && _venue.venueFacility!.isNotEmpty && _venue.venueFacility!.any((element) => element.status == 1)) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Facilites',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: isLight(context) ? Colors.grey[600] : Colors.grey[100]),
                ),
              ),
              // 8.height,
              Wrap(
                children: _venue.venueFacility!.where((element) => element.status != 0).map(
                  (venueFacility) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: isLight(context) ? Colors.grey[100] : Colors.blueGrey[400],
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Text(
                        venueFacility.facility.name,
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
            ],
            if (_venue.description != null) ...[
              Text(
                'Description',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: isLight(context) ? Colors.grey[600] : Colors.grey[100]),
              ),
              8.height,
              Text(
                _venue.description!,
                style: Theme.of(context).textTheme.bodyText2,
              ),
              Divider(
                height: 32.0,
              ),
            ]
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
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: isLight(context) ? Colors.grey[600] : Colors.grey[100]),
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
                        double.parse(_venue.longitude),
                      ),
                      zoom: 15.0,
                    ),
                    onMapCreated: (controller) {},
                    zoomGesturesEnabled: false,
                    scrollGesturesEnabled: false,
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                    myLocationEnabled: false,
                    markers: <Marker>{
                      Marker(
                        markerId: MarkerId('venue'),
                        position: LatLng(
                          double.parse(_venue.latitude),
                          double.parse(_venue.longitude),
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

  Widget buildPitchCell({required String pitchName, required String pitchPrice, required VenueService venueService}) {
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
                style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w600),
              ),
              4.height,
              Text(
                pitchPrice,
                style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w600),
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
              backgroundColor: MaterialStateProperty.all(isLight(context) ? mainColor : Color(0xFF2ecc71)),
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
        child: _venue.venueService!.where((e) => e.status != 0).toList().isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select sport type',
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  8.height,
                  ElevatedButton(
                    onPressed: showSportTypeOption,
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor: MaterialStateProperty.all(isLight(context) ? Colors.grey[100] : Colors.blueGrey[400]),
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
                        SizedBox(width: 16.0, height: 16.0, child: CacheImage(url: sportTypeSelected!.icon!)),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            sportTypeSelected!.name,
                            style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        Icon(FeatherIcons.chevronDown, color: isLight(context) ? blackColor : whiteColor),
                      ],
                    ),
                  ),
                  if (venueServiceBySportType.isNotEmpty) ...[
                    16.height,
                    Text(
                      'Available pitches:',
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    8.height,
                    ListView.separated(
                      padding: EdgeInsets.only(bottom: 16.0),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final service = venueServiceBySportType[index];

                        if (service.serviceData != null && service.serviceData!.people != null) {
                          return buildPitchCell(
                            pitchName: service.name! + ' (${service.serviceData!.people! ~/ 2}x${service.serviceData!.people! ~/ 2})',
                            pitchPrice: '\$${service.hourPrice!.toStringAsFixed(2)}/h',
                            venueService: service,
                          );
                        }

                        return SizedBox();
                      },
                      separatorBuilder: (context, index) {
                        return 8.height;
                      },
                      itemCount: venueServiceBySportType.length,
                    )
                  ] else ...[
                    Container(
                      height: 150.0,
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Text('No any available pitch'),
                      ),
                    )
                  ],
                ],
              )
            : SizedBox(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    scaffold = ScaffoldMessenger.of(context);
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
        onRefresh: () async {
          Future.delayed(Duration.zero, () {
            getVenueDetail();
          });
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _venue = widget.venue;
    venueCoverList = [...widget.venue.venueCover!];
    if (_venue.profilePhoto != null) {
      venueCoverList = venueCoverList.where((element) => element.isShow != 0).toList();
      venueCoverList.insert(0, VenueCover(id: -1, photo: _venue.profilePhoto!, venueId: _venue.id, isShow: 1));
    }
    if (_venue.venueService != null && _venue.venueService!.where((e) => e.status != 0).toList().isNotEmpty) {
      sportTypeSelected = _venue.venueService!.where((e) => e.status != 0).first.sport;
    }
    getVenueDetail();
  }

  @override
  void dispose() {
    scaffold.clearSnackBars();
    super.dispose();
  }

  void showSportTypeOption() {
    var sportTypeList = _venue.venueService!.where((e) => e.status != 0).toList();

    showKSBottomSheet(
      context,
      title: 'Choose sport type',
      hasTopbar: false,
      children: List.generate(
        sportTypeList.length,
        (index) {
          VenueService s = sportTypeList.elementAt(index);
          return sportTypeButton(s.sport);
        },
      ),
    );
  }

  Widget sportTypeButton(Sport s) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 16.0, right: 16.0),
      child: TextButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 4.0)),
          overlayColor: MaterialStateProperty.all(isLight(context) ? Colors.grey.shade100 : Colors.blueGrey.shade400),
        ),
        onPressed: () {
          sportTypeSelected = s;
          venueServiceBySportType = venueServiceList.where((e) => e.sport.id == s.id).toList();
          setState(() {});
          dismissScreen(context);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 24.0,
                height: 24.0,
                child: CacheImage(url: s.icon!),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  s.name,
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              Spacer(),
              if (sportTypeSelected!.id == s.id)
                Icon(
                  Feather.check,
                  color: isLight(context) ? mainColor : Colors.greenAccent,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void getVenueDetail() async {
    var res = await ksClient.getApi('/venue/detail/${_venue.id}');
    if (res != null) {
      if (res is! HttpResult) {
        VenueDetail detail = VenueDetail.fromJson(res);
        _venue = detail.venue;

        venueServiceList = detail.service.where((e) => e.sport.id == sportTypeSelected!.id).toList();
        venueCoverList = detail.venue.venueCover!.where((element) => element.isShow != 0).toList();
        if (_venue.profilePhoto != null) {
          venueCoverList.insert(0, VenueCover(id: -1, photo: _venue.profilePhoto!, venueId: _venue.id, isShow: 1));
        }

        if (sportTypeSelected != null) {
          venueServiceBySportType = venueServiceList.where((e) => e.sport.id == sportTypeSelected!.id).toList();
        }

        if (_venue.venueService != null && _venue.venueService!.where((e) => e.status != 0).toList().isNotEmpty) {
          sportTypeSelected = _venue.venueService!.where((e) => e.status != 0).first.sport;
        }

        Future.delayed(Duration(milliseconds: 300)).then((_) {
          isMaploaded = true;
          setState(() {});
        });
      }
    }
  }

  late ScaffoldMessengerState scaffold;

  void showSportTypeTitle(String title) {
    scaffold.removeCurrentSnackBar();

    scaffold.showSnackBar(
      SnackBar(
        elevation: 0,
        width: 150,
        backgroundColor: Colors.blueGrey[400],
        behavior: SnackBarBehavior.floating,
        content: Text(title, style: Theme.of(context).textTheme.bodyText2?.copyWith(color: whiteColor), textAlign: TextAlign.center),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      ),
    );
  }
}

class VenueDetailHeader extends SliverPersistentHeaderDelegate {
  double toolbarHeight;
  double closeHeight;
  double openHeight;
  Venue venue;
  String heroTag;
  List<VenueCover> coverList;

  VenueDetailHeader({
    required this.toolbarHeight,
    required this.closeHeight,
    required this.openHeight,
    required this.venue,
    required this.heroTag,
    required this.coverList,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    Size _textSize(String text, TextStyle style) {
      final TextPainter textPainter = TextPainter(text: TextSpan(text: text, style: style), maxLines: 1, textDirection: TextDirection.ltr)
        ..layout(minWidth: 0, maxWidth: double.infinity);
      return textPainter.size;
    }

    final textWidth = _textSize(venue.name, Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.w500)).width;
    final appbarTitleWidth = AppSize(context).appWidth(100) - 56;

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
                Hero(
                  tag: heroTag,
                  child: Swiper(
                    itemCount: coverList.length,
                    itemBuilder: (context, index) => Container(
                      child: CacheImage(
                        url: coverList[index].photo,
                      ),
                    ),
                    curve: Curves.easeInOutCubic,
                    autoplay: true,
                    loop: false,
                    // autoplayDelay: 5000,
                    // duration: 850,
                    pagination: coverList.length > 1
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
                      : Theme.of(context).primaryColor.withOpacity(backgroundOpacity(shrinkOffset)),
                  shape: BoxShape.circle,
                ),
                child: CupertinoButton(
                  onPressed: () => Navigator.pop(context, 1),
                  padding: EdgeInsets.zero,
                  child: Icon(
                    Icons.arrow_back,
                    color: (1 - shrinkOffset / openHeight) > 0.7
                        ? whiteColor
                        : isLight(context)
                            ? mainColor
                            : whiteColor,
                    size: 22.0,
                  ),
                ),
              ),
              title: textWidth > appbarTitleWidth
                  ? SizedBox(
                      height: 44.0,
                      child: Marquee(
                        text: venue.name,
                        blankSpace: 50.0,
                        startAfter: Duration(milliseconds: 1500),
                        pauseAfterRound: Duration(seconds: 1),
                        accelerationDuration: Duration(seconds: 2),
                        style: TextStyle(
                          color: shrinkOffset < openHeight - 100
                              ? Colors.transparent
                              : isLight(context)
                                  ? mainColor
                                  : whiteColor,
                        ),
                      ),
                    )
                  : Text(
                      venue.name,
                      style: TextStyle(
                        color: shrinkOffset < openHeight - 100
                            ? Colors.transparent
                            : isLight(context)
                                ? mainColor
                                : whiteColor,
                      ),
                    ),
              titleTextStyle: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.w500),
              titleSpacing: 0,
              backgroundColor: shrinkOffset < openHeight - 100 ? Colors.transparent : Theme.of(context).primaryColor,
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
      (shrinkOffset / (openHeight - toolbarHeight)) < 1 ? (shrinkOffset / (openHeight - toolbarHeight)) : 1;
}
