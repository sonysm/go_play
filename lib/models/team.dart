import 'package:kroma_sport/models/sport.dart';
import 'package:kroma_sport/models/user.dart';

class Team {
  TeamInfo teamInfo;
  User owner;
  List<TeamMember> members;

  Team({
    required this.teamInfo,
    required this.owner,
    required this.members,
  });

  factory Team.fromJson(Map<String, dynamic> json) => Team(
        teamInfo: TeamInfo.fromJson(json["team"]),
        owner: User.fromJson(json["owner"]),
        members: (json["members"] as List).map((e) => TeamMember.fromJson(e)).toList(),
      );
}

class TeamInfo {
  TeamInfo({
    required this.sport,
    required this.phone,
    this.email,
    required this.id,
    required this.name,
    required this.shortName,
    required this.gender,
  });

  Sport sport;
  String phone;
  String? email;
  int id;
  String name;
  String shortName;
  String gender;

  factory TeamInfo.fromJson(Map<String, dynamic> json) => TeamInfo(
        sport: Sport.fromJson(json["sport"]),
        phone: json["phone"],
        email: json["email"],
        id: json["id"],
        name: json["name"],
        shortName: json["short_name"],
        gender: json["gender"],
      );

  Map<String, dynamic> toJson() => {
        "sport": sport.toJson(),
        "phone": phone,
        "email": email,
        "id": id,
        "name": name,
        "short_name": shortName,
        "gender": gender,
      };
}

class TeamMember {
  TeamMember({
    required this.id,
    required this.member,
    required this.memberType,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.team,
  });

  int id;
  User member;
  int memberType;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  int team;

  factory TeamMember.fromJson(Map<String, dynamic> json) => TeamMember(
        id: json["id"],
        member: User.fromJson(json["member"]),
        memberType: json["member_type"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        team: json["team"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "member": member.toJson(),
        "member_type": memberType,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "team": team,
      };
}
