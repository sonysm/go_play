import 'dart:async';

import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:package_info/package_info.dart';

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

  PackageInfo packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  Location locationService = Location();
  // StreamSubscription<LocationData> _positionStreamSubscription;
  LatLng? currentPosition;

  AppLocationCallback? onLocationChange;

  Future<LatLng?> setupLocationMintor() async {
    locationService.changeSettings(distanceFilter: 10);
    try {
      locationService.onLocationChanged.listen((LocationData result) async {
        var latlng = LatLng(result.latitude!, result.longitude!);
        if (onLocationChange != null) {
          onLocationChange!(latlng);
        }
        currentPosition = latlng;
      });
    } on PlatformException catch (_) {
      //print("Errr xxxxxx =  setupLocationMintor =$e");
    } catch (e) {
      //print("Errr xxxxxx = setupLocationMintor = $e");
    }

    return currentPosition;
  }

  Future<String> getFileData(String path) async {
    return await rootBundle.loadString(path);
  }
}

typedef void AppLocationCallback(LatLng latLng);
