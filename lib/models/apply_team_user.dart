import 'package:fengchao/models/user_entity.dart';

class ApplyTeamUser {
  int id;
  int teamId;
  int userId;
  int state;
  String createTime;
  String message;
  User user;

  ApplyTeamUser({
    this.id,
    this.teamId,
    this.userId,
    this.state,
    this.createTime,
    this.message,
    this.user,
  });

  ApplyTeamUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    teamId = json['team_id'];
    userId = json['user_id'];
    state = json['state'];
    createTime = json['create_time'];
    message = json['message'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['team_id'] = this.teamId;
    data['user_id'] = this.userId;
    data['state'] = this.state;
    data['create_time'] = this.createTime;
    data['message'] = this.message;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}
