import 'dart:convert';

import 'package:kroma_sport/models/user.dart';

Post postFromJson(String str) => Post.fromJson(json.decode(str));

String postToJson(Post data) => json.encode(data.toJson());

class Post {
  Post({
    required this.id,
    required this.owner,
    this.sport,
    this.reacted,
    this.photo,
    this.title,
    this.description,
    this.image,
    required this.type,
    this.activityLevel,
    this.activityDate,
    this.activityStartTime,
    this.activityEndTime,
    this.activityLocation,
    this.price,
    this.minPeople,
    this.maxPeople,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  User owner;
  dynamic sport;
  bool? reacted;
  String? photo;
  dynamic title;
  String? description;
  List<KSImage>? image;
  PostType type;
  int? activityLevel;
  dynamic activityDate;
  dynamic activityStartTime;
  dynamic activityEndTime;
  dynamic activityLocation;
  double? price;
  int? minPeople;
  int? maxPeople;
  PostStatus status;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["id"],
        owner: User.fromJson(json["owner"]),
        sport: json["sport"],
        reacted: json["reacted"],
        photo: json["photo"],
        title: json["title"],
        description: json["description"],
        image: List<KSImage>.from(json["image"].map((x) => KSImage.fromJson(x))),
        type: mapPostType((json["type"] as num).toInt()),
        activityLevel: json["activity_level"],
        activityDate: json["activity_date"],
        activityStartTime: json["activity_start_time"],
        activityEndTime: json["activity_end_time"],
        activityLocation: json["activity_location"],
        price: json["price"],
        minPeople: json["min_people"],
        maxPeople: json["max_people"],
        status: mapPostStatus((json["status"] as num).toInt()),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "owner": owner.toJson(),
        "sport": sport,
        "reacted": reacted,
        "photo": photo,
        "title": title,
        "description": description,
        "image": image,
        "type": type,
        "activity_level": activityLevel,
        "activity_date": activityDate,
        "activity_start_time": activityStartTime,
        "activity_end_time": activityEndTime,
        "activity_location": activityLocation,
        "price": price,
        "min_people": minPeople,
        "max_people": maxPeople,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class KSImage {
  KSImage({
    required this.id,
    required this.name,
  });

  String id;
  String name;

  factory KSImage.fromJson(Map<String, dynamic> json) => KSImage(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

enum PostStatus { active, done, expired, deleted }

enum PostType { meetUp, activity, feed }

PostStatus mapPostStatus(int status) {
  switch (status) {
    case 1:
      return PostStatus.active;
    case 2:
      return PostStatus.done;
    case 3:
      return PostStatus.expired;
    case 4:
      return PostStatus.deleted;
    default:
      return PostStatus.active;
  }
}

PostType mapPostType(int type) {
  switch (type) {
    case 1:
      return PostType.meetUp;
    case 2:
      return PostType.activity;
    case 3:
      return PostType.feed;
    default:
      return PostType.meetUp;
  }
}
