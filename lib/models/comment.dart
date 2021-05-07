import 'dart:convert';

import 'package:kroma_sport/models/user.dart';

Comment commentFromJson(String str) => Comment.fromJson(json.decode(str));

String commentToJson(Comment data) => json.encode(data.toJson());

class Comment {
  Comment({
    required this.id,
    required this.user,
    required this.type,
    required this.comment,
    required this.createdAt,
    required this.post,
    this.parent,
  });

  int id;
  User user;
  String type;
  String comment;
  DateTime createdAt;
  int post;
  dynamic parent;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["id"],
        user: User.fromJson(json["user"]),
        type: json["type"],
        comment: json["comment"],
        createdAt: DateTime.parse(json["created_at"]),
        post: json["post"],
        parent: json["parent"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user.toJson(),
        "type": type,
        "comment": comment,
        "created_at": createdAt.toIso8601String(),
        "post": post,
        "parent": parent,
      };
}
