import 'package:kroma_sport/models/user.dart';

class Discussion {
  Discussion({
    required this.id,
    required this.sender,
    required this.content,
    required this.createdAt,
    this.updatedAt,
    required this.target,
  });

  int id;
  User sender;
  String content;
  DateTime createdAt;
  DateTime? updatedAt;
  int target;

  factory Discussion.fromJson(Map<String, dynamic> json) => Discussion(
        id: json['id'],
        sender: User.fromJson(json['sender']),
        content: json['content'],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: json['updated_at'] != null
            ? DateTime.parse(json["updated_at"])
            : null,
        target: json['target'],
      );
}
