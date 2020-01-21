class Bill {
  int id;
  int userId;
  String coin;
  String createTime;
  int type;
  String operation;
  String behind;
  String number;

  Bill({
    this.id,
    this.userId,
    this.coin,
    this.createTime,
    this.type,
    this.operation,
    this.behind,
    this.number,
  });

  Bill.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    coin = json['coin'];
    createTime = json['create_time'];
    type = json['type'];
    operation = json['operation'];
    behind = json['behind'];
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['coin'] = this.coin;
    data['create_time'] = this.createTime;
    data['type'] = this.type;
    data['operation'] = this.operation;
    data['behind'] = this.behind;
    data['number'] = this.number;
    return data;
  }
}
