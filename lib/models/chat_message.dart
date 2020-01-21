class ChatMessage {
  int id;
  ChatUser fromuser;
  String message;
  int state;
  ChatUser touser;
  String createTime;
  int isimg;
  String url;

  ChatMessage(
      {this.id,
      this.fromuser,
      this.message,
      this.state,
      this.touser,
      this.createTime,
      this.isimg,
      this.url});

  ChatMessage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fromuser = json['fromuser'] != null
        ? new ChatUser.fromJson(json['fromuser'])
        : null;
    message = json['message'];
    state = json['state'];
    touser =
        json['touser'] != null ? new ChatUser.fromJson(json['touser']) : null;
    createTime = json['create_time'];
    isimg = json['isimg'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.fromuser != null) {
      data['fromuser'] = this.fromuser.toJson();
    }
    data['message'] = this.message;
    data['state'] = this.state;
    if (this.touser != null) {
      data['touser'] = this.touser.toJson();
    }
    data['create_time'] = this.createTime;
    data['isimg'] = this.isimg;
    data['url'] = this.url;
    return data;
  }
}

class ChatUser {
  int id;
  int userStatus;
  String userNickname;
  String avatar;
  String signature;
  int tasks;
  int completeTasks;
  double rate;
  int publishTasks;

  ChatUser(
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

  ChatUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userStatus = json['user_status'];
    userNickname = json['user_nickname'];
    avatar = json['avatar'];
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


