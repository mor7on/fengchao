
import 'package:fengchao/common/config/config.dart';

import 'user_entity.dart';

class ChatBox {
  int id;
  User fromuser;
  String message;
  int type;
  int state;
  User touser;
  String createTime;
  int isimg;
  String url;

  ChatBox({
    this.id,
    this.fromuser,
    this.message,
    this.type,
    this.state,
    this.touser,
    this.createTime,
    this.isimg,
    this.url,
  });

  ChatBox.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fromuser = json['fromuser'] != null ? new User.fromJson(json['fromuser']) : null;
    message = json['message'];
    type = json['type'];
    state = json['state'];
    touser = json['touser'] != null ? new User.fromJson(json['touser']) : null;
    createTime = json['create_time'];
    isimg = json['isimg'];
    url = json['url'] == null ? null : CONFIG.BASE_URL + json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.fromuser != null) {
      data['fromuser'] = this.fromuser.toJson();
    }
    data['message'] = this.message;
    data['type'] = this.type;
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
