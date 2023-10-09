
class Categories {
  int? id;
  String? name;
  int? restorantId;
  String? createdAt;
  String? updatedAt;
  int? orderIndex;
  int? active;
  String? deletedAt;

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    restorantId = json['restorant_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    orderIndex = json['order_index'];
    active = json['active'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['restorant_id'] = this.restorantId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['order_index'] = this.orderIndex;
    data['active'] = this.active;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
