import 'package:kroma_sport/models/user.dart';

class KSNotification {
  int id;
  User? actor;
  User? to;
  String? title;
  String? subTitle;
  dynamic body;
  KSNotificationType type;
  bool isDeleted;
  bool unRead;
  DateTime createdAt;
  DateTime updatedAt;
  int? post;
  int? otherId;
  bool? isTap;

  KSNotification({
    required this.id,
    this.actor,
    this.to,
    this.title,
    this.subTitle,
    this.body,
    required this.type,
    required this.isDeleted,
    required this.unRead,
    required this.createdAt,
    required this.updatedAt,
    this.post,
    this.otherId,
    this.isTap
  });

  factory KSNotification.fromJson(Map<String, dynamic> json) => KSNotification(
        id: json["id"],
        actor: User.fromJson(json["actor"]),
        to: User.fromJson(json["to"]),
        title: json["title"],
        subTitle: json["sub_title"],
        body: json["body"],
        type: mapNotificaitonType((json["type"] as num).toInt()),
        isDeleted: json["is_deleted"],
        unRead: json["unread"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        post: json["post"],
        otherId: json['other_id'],
        isTap: json['tap_view']
      );
}

enum KSNotificationType { none, like, comment, invite, cancel, joined, left, bookAccepted, bookRejected, bookCanceled, followed }

KSNotificationType mapNotificaitonType(int type) {
  switch (type) {
    case 1:
      return KSNotificationType.like;
    case 2:
      return KSNotificationType.comment;
    case 3:
      return KSNotificationType.invite;
    case 4:
      return KSNotificationType.cancel;
    case 5:
      return KSNotificationType.joined;
    case 6:
      return KSNotificationType.left;
    case 7:
      return KSNotificationType.bookAccepted;
    case 8:
      return KSNotificationType.followed;
    case 9:
      return KSNotificationType.bookCanceled;
    case 10:
      return KSNotificationType.bookRejected;

    default:
      return KSNotificationType.none;
  }
}
