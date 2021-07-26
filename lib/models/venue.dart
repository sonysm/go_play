// To parse this JSON data, do
//
//     final venue = venueFromJson(jsonString);

import 'dart:convert';

Venue venueFromJson(String str) => Venue.fromJson(json.decode(str));

String venueToJson(Venue data) => json.encode(data.toJson());

class Venue {
  Venue({
    required this.id,
    this.owner,
    this.schedule,
    required this.isActive,
    required this.name,
    required this.profilePhoto,
    this.coverPhoto,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.description,
  });

  int id;
  Owner? owner;
  List<Schedule>? schedule;
  bool isActive;
  String name;
  String? profilePhoto;
  String? coverPhoto;
  String address;
  String latitude;
  String longitude;
  String? description;

  factory Venue.fromJson(Map<String, dynamic> json) => Venue(
        id: json["id"],
        owner: (json["owner"] is Map) ? Owner.fromJson(json["owner"]) : null,
        schedule: json["schedule"] != null
            ? List<Schedule>.from(
                json["schedule"].map((x) => Schedule.fromJson(x)))
            : null,
        isActive: json["is_active"],
        name: json["name"],
        profilePhoto: json["profile_photo"],
        coverPhoto: json["cover_photo"],
        address: json["address"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "owner": owner!.toJson(),
        "schedule": List<dynamic>.from(schedule!.map((x) => x.toJson())),
        "is_active": isActive,
        "name": name,
        "profile_photo": profilePhoto,
        "cover_photo": coverPhoto,
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
        "description": description,
      };
}

class Owner {
  Owner({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.password,
    this.phone,
    this.email,
    this.profilePhoto,
  });

  int id;
  String firstName;
  String lastName;
  String? password;
  String? phone;
  String? email;
  dynamic? profilePhoto;

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        password: json["password"],
        phone: json["phone"],
        email: json["email"],
        profilePhoto: json["profile_photo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "password": password,
        "phone": phone,
        "email": email,
        "profile_photo": profilePhoto,
      };
}

class Schedule {
  Schedule({
    required this.id,
    required this.day,
    required this.openTime,
    required this.closeTime,
    required this.isOpen,
    required this.venue,
  });

  int id;
  String day;
  String openTime;
  String closeTime;
  bool isOpen;
  int venue;

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
        id: json["id"],
        day: json["day"],
        openTime: json["open_time"],
        closeTime: json["close_time"],
        isOpen: json["is_open"],
        venue: json["venue"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "day": day,
        "open_time": openTime,
        "close_time": closeTime,
        "is_open": isOpen,
        "venue": venue,
      };
}
