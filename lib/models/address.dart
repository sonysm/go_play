import 'package:google_maps_flutter/google_maps_flutter.dart';

class Address {
  Address({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  String name;
  String latitude;
  String longitude;

  LatLng get latLng {
    return LatLng(double.parse(latitude), double.parse(longitude));
  }

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        name: json['name'],
        latitude: json['latitude'],
        longitude: json['longitude'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;

    return data;
  }
}
