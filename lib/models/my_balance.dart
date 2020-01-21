class Balance {
  double all;
  double count; //提现次数
  double bail;

  Balance({this.all, this.count, this.bail});

  Balance.fromJson(Map<String, dynamic> json) {
    all = double.tryParse(json['all']);
    count = double.tryParse(json['count']);
    bail = double.tryParse(json['bail']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['all'] = this.all;
    data['count'] = this.count;
    data['bail'] = this.bail;
    return data;
  }
}