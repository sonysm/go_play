import 'package:kroma_sport/models/user.dart';

class Member {
  int id;
  User user;
  DateTime createDate;

  Member({
    required this.id,
    required this.user,
    required this.createDate,
  });

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        id: json['id'],
        user: User.fromJson(json['user']),
        createDate: DateTime.parse(json["created_at"]),
      );
}
