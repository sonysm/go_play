import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    required this.id,
    this.lastLogin,
    required this.firstName,
    required this.lastName,
    this.gender,
    this.birthDate,
    this.weight,
    this.height,
    this.password,
    this.phone,
    this.email,
    this.photo,
    this.facebookId,
    this.appleId,
    this.appVersion,
    this.buildNumber,
    this.os,
    this.deviceToken,
    this.createdAt,
    this.updatedAt,
    required this.followerCount,
    required this.followingCount,
  });

  int id;
  dynamic lastLogin;
  String firstName;
  String lastName;
  String? gender;
  String? birthDate;
  double? weight;
  double? height;
  String? password;
  String? phone;
  String? email;
  String? photo;
  String? facebookId;
  String? appleId;
  String? appVersion;
  int? buildNumber;
  String? os;
  List<dynamic>? deviceToken;
  DateTime? createdAt;
  DateTime? updatedAt;
  int followerCount;
  int followingCount;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        lastLogin: json["last_login"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        gender: json["gender"],
        birthDate: json["birth_date"],
        weight: json["weight"],
        height: json["height"],
        password: json["password"],
        phone: json["phone"],
        email: json["email"],
        photo: json["photo"],
        facebookId: json["facebook_id"],
        appleId: json["apple_id"],
        appVersion: json["app_version"],
        buildNumber: json["build_number"],
        os: json["os"],
        deviceToken: json["device_token"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        followerCount: json['follower_count'],
        followingCount: json['following_count'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "last_login": lastLogin,
        "first_name": firstName,
        "last_name": lastName,
        "gender": gender,
        "birth_date": birthDate,
        "weight": weight,
        "height": height,
        "password": password,
        "phone": phone,
        "email": email,
        "photo": photo,
        "facebook_id": facebookId,
        "apple_id": appleId,
        "app_version": appVersion,
        "build_number": buildNumber,
        "os": os,
        "device_token": deviceToken,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "follower_count": followerCount,
        "following_count": followingCount,
      };

  String getFullname() {
    return '${this.firstName} ${this.lastName}';
  }
}
