class Cart {
  List<CartData>? data;
  num? total;
  bool? status;
  String? vat;

  Cart({this.data, this.total, this.status});

  Cart.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <CartData>[];
      json['data'].forEach((v) {
        data!.add(new CartData.fromJson(v));
      });
    }
    total = json['total'];
    status = json['status'];
    vat = json['vat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    data['status'] = this.status;
    return data;
  }
}

class CartData {
  int? id;
  // int? user_id;
  int? userId;
  num? price;
  String? name;
 late int quantity;
  String? createdAt;
  String? updatedAt;
  Attributes? attributes;
  int? itemId;
  num? minimum;

  CartData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    // userId = json['user_id'];
    price = json['price'];
    name = json['name'];
    quantity = json['quantity'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    attributes = json['attributes'] != null
        ? new Attributes.fromJson(json['attributes'])
        : null;
    itemId = json['item_id'];
    minimum = json['minimum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['price'] = this.price;
    data['name'] = this.name;
    data['quantity'] = this.quantity;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.attributes != null) {
      data['attributes'] = this.attributes!.toJson();
    }
    data['item_id'] = this.itemId;
    return data;
  }
}

class Attributes {
  int? id;
  String? variant;
  List<String>? extras;
  int? restorantId;
  String? image;
  String? friendlyPrice;

  Attributes(
      {this.id,
        this.variant,
        this.extras,
        this.restorantId,
        this.image,
        this.friendlyPrice});

  Attributes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    variant = json['variant'];
    // extras = json['extras'];
    if (json['extras'] != null) {
      extras = <String>[];
      json['extras'].forEach((v) {
        extras!.add(v);
      });
    }
    restorantId = json['restorant_id'];
    image = json['image'];
    friendlyPrice = json['friendly_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['variant'] = this.variant;
    data['extras'] = this.extras;
    data['restorant_id'] = this.restorantId;
    data['image'] = this.image;
    data['friendly_price'] = this.friendlyPrice;
    return data;
  }
}
