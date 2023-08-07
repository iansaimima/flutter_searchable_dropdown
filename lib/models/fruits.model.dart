class Fruit {
  String? name;
  String? color;

  Fruit({this.name, this.color});

  @override
  String toString() {
    return name ?? "";
  }

  Fruit.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['color'] = color;
    return data;
  }
}
