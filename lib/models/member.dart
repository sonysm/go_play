import 'package:kroma_sport/models/user.dart';

class Member {
  int id;
  User owner;
  DateTime createDate;

  Member({
    required this.id,
    required this.owner,
    required this.createDate,
  });

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        id: json['id'],
        owner: User.fromJson(json['user']),
        createDate: DateTime.parse(json["created_at"]),
      );
}
