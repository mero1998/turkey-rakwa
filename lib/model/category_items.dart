class CategoryItems {
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
  String? active_from;
  String? active_to;
  int? vat;
  String? deletedAt;
  int? enableSystemVariants;
  int? discountedPrice;
  String? logom;
  String? icon;
  String? shortDescription;
  List<Extras>? extras;
  List<Options>? options;
  List<Variants>? variants;


  CategoryItems();
  CategoryItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    image = json['image'];
    price = json['price'];
    categoryId = json['category_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    available = json['available'];
    active_from = json['active_from'];
    active_to = json['active_to'];
    hasVariants = json['has_variants'];
    vat = json['vat'];
    deletedAt = json['deleted_at'];
    enableSystemVariants = json['enable_system_variants'];
    discountedPrice = json['discounted_price'];
    logom = json['logom'];
    icon = json['icon'];
    shortDescription = json['short_description'];
    if (json['extras'] != null) {
      extras = <Extras>[];
      json['extras'].forEach((v) {
        extras!.add(new Extras.fromJson(v));
      });
    }
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(new Options.fromJson(v));
      });
    }
    if (json['variants'] != null) {
      variants = <Variants>[];
      json['variants'].forEach((v) {
        variants!.add(new Variants.fromJson(v));
      });
    }
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
    if (this.extras != null) {
      data['extras'] = this.extras!.map((v) => v.toJson()).toList();
    }
    if (this.options != null) {
      data['options'] = this.options!.map((v) => v.toJson()).toList();
    }
    if (this.variants != null) {
      data['variants'] = this.variants!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Extras {
  int? id;
  int? itemId;
  num? price;
  String? name;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? extraForAllVariants;

  Extras(
      {this.id,
        this.itemId,
        this.price,
        this.name,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.extraForAllVariants});

  Extras.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemId = json['item_id'];
    price = json['price'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    extraForAllVariants = json['extra_for_all_variants'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['item_id'] = this.itemId;
    data['price'] = this.price;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['extra_for_all_variants'] = this.extraForAllVariants;
    return data;
  }
}

class Options {
  int? id;
  int? itemId;
  String? name;
  String? options;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;

  Options(
      {this.id,
        this.itemId,
        this.name,
        this.options,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  Options.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemId = json['item_id'];
    name = json['name'];
    options = json['options'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['item_id'] = this.itemId;
    data['name'] = this.name;
    data['options'] = this.options;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}

class Variants {
  int? id;
  num? price;
  String? options;
  String? image;
  int? qty;
  int? enableQty;
  int? order;
  int? itemId;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? isSystem;

  Variants(
      {this.id,
        this.price,
        this.options,
        this.image,
        this.qty,
        this.enableQty,
        this.order,
        this.itemId,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.isSystem});

  Variants.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    options = json['options'];
    image = json['image'];
    qty = json['qty'];
    enableQty = json['enable_qty'];
    order = json['order'];
    itemId = json['item_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    isSystem = json['is_system'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['price'] = this.price;
    data['options'] = this.options;
    data['image'] = this.image;
    data['qty'] = this.qty;
    data['enable_qty'] = this.enableQty;
    data['order'] = this.order;
    data['item_id'] = this.itemId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['is_system'] = this.isSystem;
    return data;
  }
}
