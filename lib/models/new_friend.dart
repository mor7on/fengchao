import 'package:fengchao/models/user_entity.dart';

class NewFriends {
  int id;
  String createTime;
  String message;
  User user;

  NewFriends({this.id, this.createTime, this.message, this.user});

  NewFriends.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createTime = json['create_time'];
    message = json['message'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['create_time'] = this.createTime;
    data['message'] = this.message;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

