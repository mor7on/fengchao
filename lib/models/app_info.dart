import 'dart:convert';

class AppInfo {
  int id;
  int versioncode;
  String createTime;
  Map<String,dynamic> remarks;
  String versionname;
  String link;
  int state;

  AppInfo({
    this.id,
    this.versioncode,
    this.createTime,
    this.remarks,
    this.versionname,
    this.link,
    this.state,
  });

  AppInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    versioncode = json['versioncode'];
    createTime = json['create_time'];
    remarks = jsonDecode(json['remarks']);
    versionname = json['versionname'];
    link = json['link'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['versioncode'] = this.versioncode;
    data['create_time'] = this.createTime;
    data['remarks'] = this.remarks;
    data['versionname'] = this.versionname;
    data['link'] = this.link;
    data['state'] = this.state;
    return data;
  }
}
