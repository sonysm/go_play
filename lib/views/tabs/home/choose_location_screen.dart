import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geoCoding;
import 'package:kroma_sport/ks.dart';
import 'package:kroma_sport/models/address.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:location/location.dart';

class SetAddressScreen extends StatefulWidget {
  static const tag = '/setAddressScreen';

  const SetAddressScreen({Key? key}) : super(key: key);

  @override
  _SetAddressScreenState createState() => _SetAddressScreenState();
}

class _SetAddressScreenState extends State<SetAddressScreen>
    with TickerProviderStateMixin {
  late GoogleMapController _mapController;
  late CameraPosition _initialCameraPosition;

  late AnimationController _dropDownController;
  late Animation<double> _dropDownAnimation;

  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  late LatLng _currentPosition;
  late LatLng _latLng;

  bool isFirstIdle = false;

  List<String> _addressLabels = [
    "Home",
    "Office",
    "Other",
  ];

  var _titleAs = "Home";

  Widget _googleMap() {
    return GoogleMap(
      initialCameraPosition: _initialCameraPosition,
      myLocationButtonEnabled: false,
      onMapCreated: (controller) {
        _mapController = controller;
        //_mapController
        //    .getAddressFromCoordinate(_latLng.latitude, _latLng.longitude)
        //    .then((result) async {
        //  _addressController.text = result;
        //});
        geoCoding
            .placemarkFromCoordinates(_latLng.latitude, _latLng.longitude)
            .then((value) {
          if (value != null) {
            var placeMark = value[0];
            var locationName =
                '${placeMark.name} ${placeMark.subAdministrativeArea} ${placeMark.administrativeArea}';
            _addressController.text = locationName;
          }
        });
        // if (widget.oldAddress == null) {
        //   _mapController
        //       .getAddressFromCoordinate(_latLng.latitude, _latLng.longitude)
        //       .then((result) async {
        //     _addressController.text = result;
        //   });
        // }
      },
      onCameraMove: (latlng) {
        _latLng = latlng.target;
      },
      onCameraMoveStarted: () {
        FocusScope.of(context).unfocus();
        _dropDownController.forward();
      },
      onCameraIdle: () {
        if (isFirstIdle) {
          _dropDownController.reverse();
          geoCoding
              .placemarkFromCoordinates(_latLng.latitude, _latLng.longitude)
              .then((value) {
            if (value != null) {
              var placeMark = value[0];
              var locationName =
                  '${placeMark.name}, ${placeMark.subAdministrativeArea}, ${placeMark.administrativeArea}';
              _addressController.text = locationName;
            }
          });
          // if (placeVM == null) {
          //   _mapController
          //       .getAddressFromCoordinate(_latLng.latitude, _latLng.longitude)
          //       .then(
          //     (result) async {
          //       _addressController.text = result;
          //     },
          //   );
          // }
          // placeVM = null;
        }
        isFirstIdle = true;
      },
      zoomControlsEnabled: false,
    );
  }

  Widget _dropDownMarker() {
    return AnimatedBuilder(
      animation: _dropDownAnimation,
      builder: (context, child) {
        return IgnorePointer(
          child: Container(
            padding: EdgeInsets.only(bottom: 45.0),
            child: Center(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  Image.asset('assets/icons/bottom-shadow.png'),
                  Transform.translate(
                    offset: Offset(0, _dropDownAnimation.value),
                    child: Image.asset('assets/icons/ic_location_red.png',
                        height: 70.0),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _btnBack() {
    return Positioned(
      top: 10.0,
      left: 10.0,
      right: 10.0,
      child: SafeArea(
        child: Row(children: <Widget>[
          FloatingActionButton(
            heroTag: 'btnback',
            elevation: 0,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.keyboard_backspace,
              color: blackColor,
              size: 28.0,
            ),
            backgroundColor: whiteColor,
            mini: true,
          ),
        ]),
      ),
    );
  }

  Widget _btnCurrentLocation() {
    return Positioned(
      right: 12.0,
      bottom: MediaQuery.of(context).size.height / 2,
      child: FloatingActionButton(
        heroTag: 'btnCurrentLocation',
        onPressed: gotoCurrentLocation,
        child: Icon(
          Icons.location_searching,
          color: Color(0xFF2e3131),
          size: 18.0,
        ),
        backgroundColor: Colors.white,
        mini: true,
      ),
    );
  }

  Widget _addressResult() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        border: Border.all(width: 0.5, color: Colors.black.withOpacity(0.2)),
      ),
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
      margin: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
      child: TextField(
        style: TextStyle(
          fontSize: 16.0,
          color: mainColor,
          fontWeight: FontWeight.w500,
        ),
        readOnly: true,
        decoration: InputDecoration(
            disabledBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            border: InputBorder.none,
            fillColor: Colors.transparent,
            hintStyle: TextStyle(
              color: Colors.grey[700],
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
            ),
            counterStyle: TextStyle(
              fontSize: 16.0,
              color: blackColor,
              fontWeight: FontWeight.w500,
            ),
            hintText: '',
            icon: Icon(
              Feather.map_pin,
              color: mainColor,
            )),
        controller: _addressController,
      ),
    );
  }

  Widget _btnBottomView() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          color: Colors.transparent,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                      width: 0.5, color: Colors.black.withOpacity(0.2)),
                ),
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
                margin: EdgeInsets.only(left: 12.0, right: 12.0, bottom: 16.0),
                child: TextField(
                  style: TextStyle(
                    fontSize: 16.0,
                    color: blackColor,
                    fontWeight: FontWeight.w500,
                  ),
                  readOnly: true,
                  decoration: InputDecoration(
                    disabledBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    border: InputBorder.none,
                    fillColor: Colors.transparent,
                    hintStyle: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                    ),
                    counterStyle: TextStyle(
                      fontSize: 16.0,
                      color: blackColor,
                      fontWeight: FontWeight.w500,
                    ),
                    hintText: '',
                  ),
                  controller: _addressController,
                ),
              ),
              // Container(
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     border: Border.all(
              //         width: 0.5, color: Colors.black.withOpacity(0.2)),
              //   ),
              //   padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
              //   margin: EdgeInsets.only(bottom: 16.0),
              //   child: TextField(
              //     style: TextStyle(
              //       fontSize: 16.0,
              //       color: blackColor,
              //       fontWeight: FontWeight.w500,
              //     ),
              //     // readOnly: true,
              //     decoration: InputDecoration(
              //       border: InputBorder.none,
              //       fillColor: Colors.white,
              //       hintStyle: TextStyle(
              //         color: Colors.grey[700],
              //         fontSize: 16.0,
              //         fontWeight: FontWeight.w400,
              //       ),
              //       counterStyle: TextStyle(
              //         fontSize: 16.0,
              //         color: blackColor,
              //         fontWeight: FontWeight.w500,
              //       ),
              //       hintText: 'Phone number',
              //     ),
              //     controller: _phoneController,
              //   ),
              // ),

              // Container(
              //   height: 44.0,
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     border: Border.all(
              //         width: 0.5, color: Colors.black.withOpacity(0.2)),
              //   ),
              //   padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
              //   margin: EdgeInsets.only(bottom: 16.0),
              //   child: TextField(
              //     // focusNode: _addressNoteFocusNode,
              //     style: TextStyle(
              //       fontSize: 16.0,
              //       color: blackColor,
              //       fontWeight: FontWeight.w400,
              //     ),
              //     maxLines: 4,
              //     decoration: InputDecoration(
              //       border: InputBorder.none,
              //       fillColor: Colors.white,
              //       hintStyle: TextStyle(
              //         color: Colors.grey.withOpacity(0.4),
              //         fontSize: 14.0,
              //         fontWeight: FontWeight.w400,
              //       ),
              //       hintText: 'Phone number',
              //     ),
              //     controller: _noteController,
              //   ),
              // ),

              // Text('Label as'),
              // SizedBox(height: 8.0),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: List.generate(_addressLabels.length, (index) {
              //     return ActionChip(
              //       label: Text(
              //         _addressLabels.elementAt(index),
              //         style: TextStyle(
              //             color: _addressLabels.elementAt(index) != _titleAs
              //                 ? Colors.grey[400]
              //                 : mainColor),
              //       ),
              //       padding: EdgeInsets.symmetric(horizontal: 24.0),
              //       // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              //       backgroundColor: whiteColor,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(4.0),
              //         side: BorderSide(
              //             color: _addressLabels.elementAt(index) != _titleAs
              //                 ? Colors.grey[400]
              //                 : mainColor),
              //       ),
              //       onPressed: () {
              //         _titleAs = _addressLabels.elementAt(index);
              //         setState(() {});
              //       },
              //     );
              //   }),
              // ),

              Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, bottom: 16.0),
                child: Container(
                  height: 48.0,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0.5),
                      backgroundColor: MaterialStateProperty.all(mainColor),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                    child: Text(
                      'Select Address',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: whiteColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void setState(fn) {
    if (!mounted) {
      return;
    }
    super.setState(fn);
  }

  @override
  void initState() {
    // _checkGps();

    _initialCameraPosition = CameraPosition(
      target: LatLng(11.556384814188409, 104.92820877581835),
      zoom: 16.0,
    );

    _latLng = LatLng(11.556384814188409, 104.92820877581835);

    if (KS.shared.currentPosition != null) {
      _initialCameraPosition = CameraPosition(
        target: LatLng(KS.shared.currentPosition!.latitude,
            KS.shared.currentPosition!.longitude),
        zoom: 16.0,
      );

      _latLng = LatLng(KS.shared.currentPosition!.latitude,
          KS.shared.currentPosition!.longitude);
      _currentPosition = _latLng;
    }

    _dropDownController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _dropDownAnimation = Tween(begin: 0.0, end: -45.0).animate(
      CurvedAnimation(
        parent: _dropDownController,
        curve: Curves.easeIn,
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    _dropDownController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Text('Set Location'),
        actions: [
          TextButton(
            onPressed: applyLocation,
            child: Text(
              'Apply',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(color: mainColor, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: Stack(
                  children: <Widget>[
                    _googleMap(),
                    _dropDownMarker(),
                    // _btnBack(),
                    _btnCurrentLocation(),
                    _addressResult(),
                  ],
                ),
              ),
              // _btnBottomView(),
            ],
          ),
        ],
      ),
    );
  }

  // _checkGps() async {
  //   Location location = Location();

  //   bool serviceEnabled = await location.serviceEnabled();
  //   if (!serviceEnabled) {
  //     serviceEnabled = await location.requestService();
  //     if (!serviceEnabled) {
  //       print('____LOCATION___ERVICE__DISABLE_________');
  //     }
  //   }

  //   try {
  //     PermissionStatus permissionStatus = await location.hasPermission();
  //     if (permissionStatus == PermissionStatus.denied) {
  //       permissionStatus = await location.requestPermission();
  //       if (permissionStatus != PermissionStatus.granted) {
  //         _showLocationAlert();
  //         return;
  //       }
  //     }

  //     LocationData data = await location.getLocation();
  //     if (data.latitude != null && data.longitude != null) {
  //       _currentPosition = LatLng(data.latitude!, data.longitude!);
  //       gotoCurrentLocation();
  //       // KFood.shared.currentPosition = LatLng(data.latitude, data.longitude);
  //       // KFood.shared.locationService = location;
  //       // KFood.shared.setupLocationMintor();

  //       // if (widget.oldAddress == null) {
  //       //   gotoCurrentLocation();
  //       // }
  //     }
  //   } catch (e) {
  //     _showLocationAlert();
  //     print('____ERROR____GET___LOCATION_________$e');
  //   }
  // }

  // _showLocationAlert() {
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text('Alert'),
  //           content: Text('Location disable message'),
  //           actions: <Widget>[
  //             TextButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                   // openAppSettings();
  //                 },
  //                 child: Text('Open setting')),
  //             TextButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //                 child: Text('Not now'))
  //           ],
  //         );
  //       });
  // }

  gotoCurrentLocation() {
    _mapController
        .animateCamera(CameraUpdate.newLatLngZoom(_currentPosition, 16));
  }

  void applyLocation() {
    Address location = Address(
      name: _addressController.text,
      latitude: _latLng.latitude.toString(),
      longitude: _latLng.longitude.toString(),
    );

    Navigator.pop(context, location);
  }

  // addAddress() {
  //   // showLoading(context);
  //   Address newAddress = Address(
  //     phone: _phoneController.text,
  //     name: _titleAs,
  //     latitude: _latLng.latitude.toString(),
  //     longitude: _latLng.longitude.toString(),
  //     address: _addressController.text,
  //     note: '',
  //   );

  //   Navigator.pop(context, newAddress);

  //   // TmsService().addAddress(newAddress).then((value) {
  //   //   Navigator.pop(context);
  //   //   if (value != null) {
  //   //     Navigator.pop(context);
  //   //   }
  //   // });
  // }

  // saveChangedAddress() {
  //   showLoading(context);
  //   Address editAddress = Address(
  //     id: widget.oldAddress.id,
  //     phone: _phoneController.text,
  //     name: _titleAs,
  //     latitude: '',
  //     longitude: '',
  //     address: _addressController.text,
  //     note: '',
  //   );

  //   // ApiService.editShippingAddress(editAddress).then((addresses) {
  //   //   Navigator.pop(context);
  //   //   Navigator.pop(context, addresses);
  //   // });
  // }
}
