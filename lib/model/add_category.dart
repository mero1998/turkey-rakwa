
class AddCategory {
  String? name;
  String? restorantId;
  int? orderIndex;
  String? updatedAt;
  String? createdAt;
  int? id;


  AddCategory.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? "";
    restorantId = json['restorant_id'] ?? "";
    orderIndex = json['order_index'] ?? "";
    updatedAt = json['updated_at'] ?? "";
    createdAt = json['created_at'] ?? "";
    id = json['id'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['restorant_id'] = this.restorantId;
    data['order_index'] = this.orderIndex;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}
