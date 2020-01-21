import 'package:fengchao/common/config/config.dart';

class FriendGroup {
  int id;
  int userId;
  String name;
  String createTime;
  List<Friend> friendList;

  FriendGroup({this.id, this.userId, this.name, this.createTime, this.friendList});

  FriendGroup.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    createTime = json['create_time'];
    if (json['friend'] != null) {
      friendList = new List<Friend>();
      json['friend'].forEach((v) {
        friendList.add(new Friend.fromJson(v['friend']));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['create_time'] = this.createTime;
    if (this.friendList != null) {
      data['friend'] = this.friendList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class Friend {
  int id;
  int userStatus;
  String userNickname;
  String avatar;
  String signature;
  int tasks;
  int completeTasks;
  double rate;
  int publishTasks;

  Friend(
      {this.id,
      this.userStatus,
      this.userNickname,
      this.avatar,
      this.signature,
      this.tasks,
      this.completeTasks,
      this.rate,
      this.publishTasks,
      });

  Friend.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userStatus = json['user_status'];
    userNickname = json['user_nickname'];
    avatar = json['avatar'] != null && json['avatar'] != '' ? CONFIG.BASE_URL + json['avatar'] : CONFIG.BASE_URL + 'h5/asset/avatar.png';
    signature = json['signature'];
    tasks = json['tasks'];
    completeTasks = json['complete_tasks'];
    rate = json['rate'];
    publishTasks = json['publish_tasks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_status'] = this.userStatus;
    data['user_nickname'] = this.userNickname;
    data['avatar'] = this.avatar;
    data['signature'] = this.signature;
    data['tasks'] = this.tasks;
    data['complete_tasks'] = this.completeTasks;
    data['rate'] = this.rate;
    data['publish_tasks'] = this.publishTasks;
    return data;
  }
}

