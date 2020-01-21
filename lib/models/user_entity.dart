import 'package:fengchao/common/config/config.dart';

class User {
  int id;
  String birthday;
  int userStatus;
  String userEmail;
  String lastLoginTime;
  String createTime;
  int completeTasks;
  String signature;
  int sex;
  String modifyTime;
  int publishTasks;
  UserIndustry industry;
  String avatar;
  String token;
  int userType;
  int isfriend;
  int roleId;
  String skill;
  int userIndustryId;
  String userLogin;
  String userNickname;
  String introduction;
  int tasks;
  double rate;

  User({
    this.birthday,
    this.userStatus,
    this.userEmail,
    this.lastLoginTime,
    this.createTime,
    this.completeTasks,
    this.signature,
    this.sex,
    this.modifyTime,
    this.publishTasks,
    this.industry,
    this.avatar,
    this.token,
    this.userType,
    this.isfriend,
    this.roleId,
    this.skill,
    this.userIndustryId,
    this.userLogin,
    this.userNickname,
    this.id,
    this.introduction,
    this.tasks,
    this.rate,
  });

  User.fromJson(Map<String, dynamic> json) {
    birthday = json['birthday'];
    userStatus = json['user_status'];
    userEmail = json['user_email'];
    lastLoginTime = json['last_login_time'];
    createTime = json['create_time'];
    completeTasks = json['complete_tasks'];
    signature = json['signature'];
    sex = json['sex'];
    modifyTime = json['modify_time'];
    publishTasks = json['publish_tasks'];
    industry = json['industry'] != null ? new UserIndustry.fromJson(json['industry']) : null;
    avatar = json['avatar'] == null || json['avatar'] == '' ? CONFIG.USER_AVATAR : CONFIG.BASE_URL + json['avatar'];
    token = json['token'];
    userType = json['user_type'];
    isfriend = json['isfriend'];
    roleId = json['role_id'];
    skill = json['skill'];
    userIndustryId = json['user_industry_id'];
    userLogin = json['user_login'];
    userNickname = json['user_nickname'];
    id = json['id'];
    introduction = json['introduction'];
    tasks = json['tasks'];
    rate = json['rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['birthday'] = this.birthday;
    data['user_status'] = this.userStatus;
    data['user_email'] = this.userEmail;
    data['last_login_time'] = this.lastLoginTime;
    data['create_time'] = this.createTime;
    data['complete_tasks'] = this.completeTasks;
    data['signature'] = this.signature;
    data['sex'] = this.sex;
    data['modify_time'] = this.modifyTime;
    data['publish_tasks'] = this.publishTasks;
    if (this.industry != null) {
      data['industry'] = this.industry.toJson();
    }
    data['avatar'] = this.avatar;
    data['token'] = this.token;
    data['user_type'] = this.userType;
    data['isfriend'] = this.isfriend;
    data['role_id'] = this.roleId;
    data['skill'] = this.skill;
    data['user_industry_id'] = this.userIndustryId;
    data['user_login'] = this.userLogin;
    data['user_nickname'] = this.userNickname;
    data['id'] = this.id;
    data['introduction'] = this.introduction;
    data['tasks'] = this.tasks;
    data['rate'] = this.rate;
    return data;
  }
}

class UserIndustry {
  String code;
  dynamic parentId;
  String strName;
  int id;
  int status;

  UserIndustry({this.code, this.parentId, this.strName, this.id, this.status});

  UserIndustry.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    parentId = json['parent_id'];
    strName = json['str_name'];
    id = json['id'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['parent_id'] = this.parentId;
    data['str_name'] = this.strName;
    data['id'] = this.id;
    data['status'] = this.status;
    return data;
  }
}
