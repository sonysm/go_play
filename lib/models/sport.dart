import 'dart:convert';

import 'package:kroma_sport/models/user.dart';

class Sport {
  Sport({
    required this.id,
    required this.name,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
    this.fav
  });

  int id;
  String name;
  bool isActive;
  DateTime createdAt;
  DateTime? updatedAt;
  bool? fav;

  factory Sport.fromJson(Map<String, dynamic> json) => Sport(
        id: json["id"],
        name: json["name"],
        isActive: json["is_active"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        fav: json['fav'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "is_active": isActive,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

FavoriteSport favoriteSportFromJson(String str) =>
    FavoriteSport.fromJson(json.decode(str));

String favoriteSportToJson(FavoriteSport data) => json.encode(data.toJson());

class FavoriteSport {
  FavoriteSport({
    required this.id,
    required this.sport,
    required this.user,
    required this.createdAt,
  });

  int id;
  Sport sport;
  User user;
  DateTime createdAt;

  factory FavoriteSport.fromJson(Map<String, dynamic> json) => FavoriteSport(
        id: json["id"],
        sport: Sport.fromJson(json["sport"]),
        user: User.fromJson(json["user"]),
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sport": sport.toJson(),
        "user": user.toJson(),
        "created_at": createdAt.toIso8601String(),
      };
}
