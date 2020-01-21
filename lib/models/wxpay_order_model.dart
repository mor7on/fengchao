class WxPayOrderModel {
  String package;
  String appid;
  String sign;
  String partnerid;
  String prepayid;
  String noncestr;
  int timestamp;

  WxPayOrderModel({
    this.package,
    this.appid,
    this.sign,
    this.partnerid,
    this.prepayid,
    this.noncestr,
    this.timestamp,
  });

  WxPayOrderModel.fromJson(Map<String, dynamic> json) {
    package = json['package'];
    appid = json['appid'];
    sign = json['sign'];
    partnerid = json['partnerid'];
    prepayid = json['prepayid'];
    noncestr = json['noncestr'];
    timestamp = int.parse(json['timestamp']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['package'] = this.package;
    data['appid'] = this.appid;
    data['sign'] = this.sign;
    data['partnerid'] = this.partnerid;
    data['prepayid'] = this.prepayid;
    data['noncestr'] = this.noncestr;
    data['timestamp'] = this.timestamp;
    return data;
  }
}
