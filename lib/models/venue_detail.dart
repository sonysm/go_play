import 'package:kroma_sport/models/sport.dart';
import 'package:kroma_sport/models/venue.dart';

class VenueDetail {
  VenueDetail({
    required this.venue,
    required this.service,
  });

  Venue venue;
  List<VenueService> service;

  factory VenueDetail.fromJson(Map<String, dynamic> json) => VenueDetail(
        venue: Venue.fromJson(json['venue']),
        service: List.from(json['services'].map((x) => VenueService.fromJson(x))),
      );
}

class VenueService {
  VenueService({
    required this.id,
    required this.sport,
    required this.name,
    required this.serviceData,
    required this.hourPrice,
    required this.venue,
  });

  int id;
  Sport sport;
  String name;
  ServiceData serviceData;
  double hourPrice;
  int venue;

  factory VenueService.fromJson(Map<String, dynamic> json) => VenueService(
        id: json["id"],
        sport: Sport.fromJson(json["sport"]),
        name: json["name"],
        serviceData: ServiceData.fromJson(json["data"]),
        hourPrice: json["hour_price"],
        venue: json["venue"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sport": sport.toJson(),
        "name": name,
        "data": serviceData.toJson(),
        "hour_price": hourPrice,
        "venue": venue,
      };
}

class ServiceData {
  ServiceData({
    required this.width,
    required this.length,
    this.people,
  });

  String width;
  String length;
  int? people;

  factory ServiceData.fromJson(Map<String, dynamic> json) => ServiceData(
        width: json["width"],
        length: json["length"],
        people: json["people"],
      );

  Map<String, dynamic> toJson() => {
        "width": width,
        "length": length,
        "people": people,
      };
}
