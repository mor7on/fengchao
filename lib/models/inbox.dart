class Inbox {
  int id;
  int receiveId;
  String message;
  String type;
  int state;
  String createTime;
  String title;
  String deleteTime;
  String userDeleteSys;

  Inbox({
    this.id,
    this.receiveId,
    this.message,
    this.type,
    this.state,
    this.createTime,
    this.title,
    this.deleteTime,
    this.userDeleteSys,
  });

  Inbox.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    receiveId = json['receive_id'];
    message = json['message'];
    type = json['type'];
    state = json['state'];
    createTime = json['create_time'];
    title = json['title'];
    deleteTime = json['delete_time'];
    userDeleteSys = json['user_delete_sys'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['receive_id'] = this.receiveId;
    data['message'] = this.message;
    data['type'] = this.type;
    data['state'] = this.state;
    data['create_time'] = this.createTime;
    data['title'] = this.title;
    data['delete_time'] = this.deleteTime;
    data['user_delete_sys'] = this.userDeleteSys;
    return data;
  }
}
