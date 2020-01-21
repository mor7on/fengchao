class CustomEntity {
  String label;
  int value;
  bool selected;

  CustomEntity({this.label, this.value, this.selected});

  CustomEntity.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    value = json['value'];
    selected = json['selected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['value'] = this.value;
    data['selected'] = this.selected;
    return data;
  }
}