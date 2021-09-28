import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/models/venue.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/tools.dart';
import 'package:kroma_sport/views/tabs/venue/venue_detail_screen.dart';
import 'dart:ui' as ui;
import 'dart:io' show Platform;

import 'package:url_launcher/url_launcher.dart';

class VenueMapScreen extends StatefulWidget {
  static const tag = '/venueMapScreen';

  final List<Venue> venueList;
  VenueMapScreen({Key? key, required this.venueList}) : super(key: key);

  @override
  _VenueMapScreenState createState() => _VenueMapScreenState();
}

class _VenueMapScreenState extends State<VenueMapScreen> with SingleTickerProviderStateMixin {
  late GoogleMapController _mapController;
  late CameraPosition _initialCameraPosition;

  late LatLng _currentPosition;
  late LatLng _latLng;

  late AnimationController _animationController;
  late Animation<double> _animation;

  Map<MarkerId, Marker> venueMarker = {};
  List<Marker> allMarkers = [];
  Venue? _venue;

  int? bigIconWidth, smallIconWidth;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    // if (MediaQuery.of(context).size.width > 420) {
    //   bigIconWidth = 90;
    //   smallIconWidth = 50;
    // } else {
    //   bigIconWidth = 150;
    //   smallIconWidth = 80;
    // }

    return Scaffold(
      appBar: AppBar(
        elevation: 0.3,
        titleSpacing: 0,
        title: Text('Venue Explorer'),
      ),
      backgroundColor: theme.primaryColor,
      body: SizedBox.expand(
        child: Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            GoogleMap(
              onMapCreated: (controller) {
                _mapController = controller;
                KS.shared.getFileData('assets/style/custom_style.json').then((mapStyle) {
                  _mapController.setMapStyle(mapStyle);
                });
              },
              markers: Set.from(venueMarker.values),
              initialCameraPosition: _initialCameraPosition,
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              onTap: (_) {
                if (_selectedMarkerId != null) {
                  scaleMarker();
                  _selectedMarkerId = null;
                  _animationController.reverse();
                }
              },
            ),
            if (_venue != null)
              AnimatedBuilder(
                animation: _animation,
                builder: (_, child) {
                  return Positioned(
                    left: 0,
                    right: 0,
                    bottom: -270 + (_animation.value * 270),
                    child: VenueCardWidget(
                      venue: _venue!,
                      onDirectionClick: () => launchMaps(_venue!.latitude, _venue!.longitude),
                      onCardTap: () =>
                          launchScreen(context, VenueDetailScreen.tag, arguments: {'venue': _venue, 'heroTag': 'map_venue_profile${_venue!.id}'}),
                      onClose: () {
                        _animationController.reverse().then((_) {
                          _selectedMarkerId = null;
                          scaleMarker();
                        });
                      },
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _initialCameraPosition = CameraPosition(
      target: LatLng(11.556384814188409, 104.92820877581835),
      zoom: 16.0,
    );

    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController);

    if (KS.shared.currentPosition != null) {
      _initialCameraPosition = CameraPosition(
        target: LatLng(KS.shared.currentPosition!.latitude, KS.shared.currentPosition!.longitude),
        zoom: 12.0,
      );

      _latLng = LatLng(KS.shared.currentPosition!.latitude, KS.shared.currentPosition!.longitude);
      _currentPosition = _latLng;
    }

    // widget.venueList.forEach((element) {
    //   getMarker(element).then((value) => setState(() => venueMarker.addAll(value)));
    // });

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (MediaQuery.of(context).size.width > 420 && !Platform.isIOS) {
        bigIconWidth = 90;
        smallIconWidth = 50;
      } else {
        bigIconWidth = 150;
        smallIconWidth = 80;
      }

      widget.venueList.forEach((element) {
      getMarker(element).then((value) => setState(() => venueMarker.addAll(value)));
    });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  MarkerId? _selectedMarkerId;

  Future<Map<MarkerId, Marker>> getMarker(Venue v) async {
    Map<MarkerId, Marker> newMarker = {};
    final Uint8List markerIcon = await getBytesFromAsset('assets/images/ic_venue_marker.png', smallIconWidth!);
    final MarkerId markerId = MarkerId('marker${v.id}');

    final Marker marker = Marker(
      markerId: markerId,
      icon: BitmapDescriptor.fromBytes(markerIcon),
      onTap: () {
        print(v.name);
        _venue = v;
        _selectedMarkerId = markerId;
        _animationController.forward();
        scaleMarker(id: markerId);
      },
      position: LatLng(double.parse(v.latitude), double.parse(v.longitude)),
    );

    newMarker[markerId] = marker;

    return newMarker;
  }

  void scaleMarker({MarkerId? id}) async {
    final Uint8List bigicon = await getBytesFromAsset('assets/images/ic_venue_marker.png', bigIconWidth!);
    final Uint8List smallicon = await getBytesFromAsset('assets/images/ic_venue_marker.png', smallIconWidth!);

    if (id != null) {
      venueMarker.forEach((markerId, marker) {
        if (markerId == id) {
          venueMarker[markerId] = marker.copyWith(iconParam: BitmapDescriptor.fromBytes(bigicon));
        } else {
          venueMarker[markerId] = marker.copyWith(iconParam: BitmapDescriptor.fromBytes(smallicon));
        }
      });
    } else {
      venueMarker.forEach((markerId, marker) {
        venueMarker[markerId] = marker.copyWith(iconParam: BitmapDescriptor.fromBytes(smallicon));
      });
    }

    setState(() {});
  }

  launchMaps(String lat, String lng) async {
    if (Platform.isIOS) {
      var url =
          'comgooglemaps://maps.google.com/maps?daddr=$lat,$lng&view=transit&z=15&nav=1&nav=1&x-source=SourceApp&x-success=sourceapp://?resume=true';
      // var url2 = 'waze://waze.com/ul?ll=$lat,$lng&navigate=yes&zoom=19';
      if (await canLaunch('waze://')) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } else {
      await launch("https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving");
    }
  }
}

class VenueCardWidget extends StatelessWidget {
  final Venue venue;
  final VoidCallback onDirectionClick;
  final VoidCallback onCardTap;
  final VoidCallback onClose;

  VenueCardWidget({
    Key? key,
    required this.venue,
    required this.onDirectionClick,
    required this.onCardTap,
    required this.onClose,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 20),
      padding: EdgeInsets.only(top: 16.0),
      child: InkWell(
        onTap: onCardTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.1), blurRadius: 15, offset: Offset(0, 5)),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Hero(
                    tag: 'map_venue_profile${venue.id}',
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(venue.profilePhoto ?? ''),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                venue.name,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  venue.description ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: List.generate(5, (index) {
                                  return index < 4
                                      ? Icon(Icons.star, size: 18, color: Color(0xFFFFB24D))
                                      : Icon(Icons.star_border, size: 18, color: Color(0xFFFFB24D));
                                }),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: onDirectionClick,
                            child: Icon(Icons.directions, color: whiteColor),
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0),
                              padding: MaterialStateProperty.all(EdgeInsets.zero),
                              backgroundColor: MaterialStateProperty.all(mainColor),
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              top: -16,
              right: 0,
              child: ElevatedButton(
                onPressed: onClose,
                style: ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                    shape: MaterialStateProperty.all(CircleBorder()),
                    backgroundColor: MaterialStateProperty.all(whiteColor)),
                child: Icon(
                  Icons.close,
                  color: blackColor,
                  size: 24.0,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
