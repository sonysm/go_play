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
    String? image;
    int type;
    int? activityLevel;
    dynamic activityDate;
    dynamic activityStartTime;
    dynamic activityEndTime;
    dynamic activityLocation;
    double? price;
    int? minPeople;
    int? maxPeople;
    int status;
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
        image: json["image"],
        type: json["type"],
        activityLevel: json["activity_level"],
        activityDate: json["activity_date"],
        activityStartTime: json["activity_start_time"],
        activityEndTime: json["activity_end_time"],
        activityLocation: json["activity_location"],
        price: json["price"],
        minPeople: json["min_people"],
        maxPeople: json["max_people"],
        status: json["status"],
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
