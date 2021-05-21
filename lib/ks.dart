import 'dart:async';

import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'models/user.dart';

class KS {
  KS._internal();

  static KS _singleton = KS._internal();
  static KS get shared {
    //if (_singleton == null) {
    //  _singleton = KS._internal();
    //}

    return _singleton;
  }

  late User user;

  Location locationService = Location();
  // StreamSubscription<LocationData> _positionStreamSubscription;
  LatLng? currentPosition;

  AppLocationCallback? onLocationChange;

  Future<LatLng?> setupLocationMintor() async {
    try {
      locationService.onLocationChanged.listen((LocationData result) async {
        var latlng = LatLng(result.latitude!, result.longitude!);
        if (onLocationChange != null) {
          onLocationChange!(latlng);
        }
        currentPosition = latlng;
      });
    } on PlatformException catch (e) {
      print("Errr xxxxxx =  setupLocationMintor =$e");
    } catch (e) {
      print("Errr xxxxxx = setupLocationMintor = $e");
    }

    return currentPosition;
  }
}

typedef void AppLocationCallback(LatLng latLng);
