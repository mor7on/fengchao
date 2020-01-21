import 'package:fengchao/common/config/config.dart';

class TenderUser {
  int id;
  int taskId;
  int userId;
  int userState;
  String userNickname;
  String avatar;
  String signature;
  int tasks;
  int completeTasks;
  double rate;
  int publishTasks;
  String coin;

  TenderUser(
      {this.id,
      this.taskId,
      this.userId,
      this.userState,
      this.userNickname,
      this.avatar,
      this.signature,
      this.tasks,
      this.completeTasks,
      this.rate,
      this.publishTasks,
      this.coin});

  TenderUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user'] != null ? json['user']['id'] : null;
    userNickname = json['user'] != null ? json['user']['user_nickname'] : null;
    avatar = json['user'] != null && json['user']['avatar'] != '' ? CONFIG.BASE_URL + json['user']['avatar'] : CONFIG.USER_AVATAR;
    signature = json['user'] != null ? json['user']['signature'] : null;
    tasks = json['user'] != null ? json['user']['tasks'] : null;
    completeTasks = json['user'] != null ? json['user']['complete_tasks'] : null;
    rate = json['user'] != null ? json['user']['rate'] : null;
    publishTasks = json['user'] != null ? json['user']['publish_tasks'] : null;
    taskId = json['task_id'];
    userState = json['state'];
    coin = json['coin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['userNickname'] = this.userNickname;
    data['avatar'] = this.avatar;
    data['signature'] = this.signature;
    data['tasks'] = this.tasks;
    data['completeTasks'] = this.completeTasks;
    data['rate'] = this.rate;
    data['publishTasks'] = this.publishTasks;
    data['taskId'] = this.taskId;
    data['userState'] = this.userState;
    data['coin'] = this.coin;
    return data;
  }
}

