import 'package:kroma_sport/models/user.dart';

class Member {
  int id;
  User user;
  String? reason;
  int status; /// 1: Joined, 2: Leave
  DateTime createdAt;
  DateTime? updatedAt;

  Member({
    required this.id,
    required this.user,
    this.reason,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        id: json['id'],
        user: User.fromJson(json['user']),
        reason: json['reason'],
        status: json['status'],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : null,
      );
}
