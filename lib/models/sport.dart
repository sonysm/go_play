import 'dart:convert';

class Sport {
  Sport({
    required this.id,
    required this.name,
    this.icon,
    this.image,
    this.postImage,
    this.attribute,
    this.fav,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
  });

  int id;
  String name;
  String? icon;
  String? image;
  String? postImage;
  List<Attribute>? attribute;
  bool isActive;
  bool? fav;
  DateTime createdAt;
  DateTime? updatedAt;

  factory Sport.fromJson(Map<String, dynamic> json) => Sport(
        id: json["id"],
        name: json["name"],
        icon: json["icon"],
        image: json["image"],
        postImage: json["post_image"],
        fav: json["fav"],
        attribute: List<Attribute>.from(
            json["attribute"].map((x) => Attribute.fromJson(x))),
        isActive: json["is_active"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "icon": icon,
        "image": image,
        "post_image": postImage,
        "attribute": List<dynamic>.from(attribute!.map((x) => x.toJson())),
        "is_active": isActive,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}

class Attribute {
  Attribute({
    this.data,
    this.slug,
    this.title,
  });

  List<AttributeData>? data;
  String? slug;
  String? title;

  factory Attribute.fromJson(Map<String, dynamic> json) => Attribute(
        data: List<AttributeData>.from(
            json["data"].map((x) => AttributeData.fromJson(x))),
        slug: json["slug"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "slug": slug,
        "title": title,
      };
}

class AttributeData {
  AttributeData({
    this.slug,
    this.title,
  });

  String? slug;
  String? title;

  factory AttributeData.fromJson(Map<String, dynamic> json) => AttributeData(
        slug: json["slug"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "slug": slug,
        "title": title,
      };
}

FavoriteSport favoriteSportFromJson(String str) =>
    FavoriteSport.fromJson(json.decode(str));

String favoriteSportToJson(FavoriteSport data) => json.encode(data.toJson());

class FavoriteSport {
  FavoriteSport({
    required this.id,
    required this.sport,
    this.playLevel,
    this.playAttribute,
    required this.createdAt,
    required this.isDeleted,
  });

  int id;
  Sport sport;
  int? playLevel;
  PlayAttribute? playAttribute;
  DateTime createdAt;
  bool isDeleted;

  factory FavoriteSport.fromJson(Map<String, dynamic> json) => FavoriteSport(
        id: json["id"],
        sport: Sport.fromJson(json["sport"]),
        playLevel: json["play_level"],
        playAttribute: PlayAttribute.fromJson(json["play_attribute"]),
        createdAt: DateTime.parse(json["created_at"]),
        isDeleted: json["is_deleted"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sport": sport.toJson(),
        "play_level": playLevel,
        "play_attribute": playAttribute!.toJson(),
        "created_at": createdAt.toIso8601String(),
        "is_deleted": isDeleted,
      };
}

class PlayAttribute {
    PlayAttribute({
        this.type,
        this.positions,
    });

    List<String>? type;
    List<String>? positions;

    factory PlayAttribute.fromJson(Map<String, dynamic> json) => PlayAttribute(
        type: List<String>.from(json["type"].map((x) => x)),
        positions: List<String>.from(json["positions"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "type": List<dynamic>.from(type!.map((x) => x)),
        "positions": List<dynamic>.from(positions!.map((x) => x)),
    };
}