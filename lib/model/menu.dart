

class MenuItems {
  int? id;
  String? name;
  int? restorantId;
  String? createdAt;
  String? updatedAt;
  int? orderIndex;
  int? active;
  String? deletedAt;
  List<Items>? items;


  MenuItems();
  MenuItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    restorantId = json['restorant_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    orderIndex = json['order_index'];
    active = json['active'];
    deletedAt = json['deleted_at'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
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
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  int? id;
  String? name;
  String? description;
  String? image;
  num? price;
  int? categoryId;
  String? createdAt;
  String? updatedAt;
  int? available;
  int? hasVariants;
  int? vat;
  String? deletedAt;
  int? enableSystemVariants;
  int? discountedPrice;
  String? logom;
  String? icon;
  String? shortDescription;

  Items(
      {this.id,
        this.name,
        this.description,
        this.image,
        this.price,
        this.categoryId,
        this.createdAt,
        this.updatedAt,
        this.available,
        this.hasVariants,
        this.vat,
        this.deletedAt,
        this.enableSystemVariants,
        this.discountedPrice,
        this.logom,
        this.icon,
        this.shortDescription});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    image = json['image'];
    price = json['price'];
    categoryId = json['category_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    available = json['available'];
    hasVariants = json['has_variants'];
    vat = json['vat'];
    deletedAt = json['deleted_at'];
    enableSystemVariants = json['enable_system_variants'];
    discountedPrice = json['discounted_price'];
    logom = json['logom'];
    icon = json['icon'];
    shortDescription = json['short_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['image'] = this.image;
    data['price'] = this.price;
    data['category_id'] = this.categoryId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['available'] = this.available;
    data['has_variants'] = this.hasVariants;
    data['vat'] = this.vat;
    data['deleted_at'] = this.deletedAt;
    data['enable_system_variants'] = this.enableSystemVariants;
    data['discounted_price'] = this.discountedPrice;
    data['logom'] = this.logom;
    data['icon'] = this.icon;
    data['short_description'] = this.shortDescription;
    return data;
  }
}
