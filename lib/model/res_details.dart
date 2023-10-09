class ResDetails {
  Data? data;
  String? token;
  bool? status;
  String? errMsg;

  ResDetails({this.data, this.token, this.status, this.errMsg});

  ResDetails.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    token = json['token'];
    status = json['status'];
    errMsg = json['errMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['token'] = this.token;
    data['status'] = this.status;
    data['errMsg'] = this.errMsg;
    return data;
  }
}

class Data {
  int? id;
  String? createdAt;
  String? updatedAt;
  String? name;
  String? subdomain;
  String? logo;
  String? cover;
  int? active;
  int? userId;
  String? lat;
  String? lng;
  String? address;
  String? phone;
  String? minimum;
  String? description;
  int? fee;
  int? staticFee;
  List<Radius>? radius;
  int? isFeatured;
  int? cityId;
  int? views;
  int? canPickup;
  int? canDeliver;
  int? selfDeliver;
  int? freeDeliver;
  String? whatsappPhone;
  String? fbUsername;
  int? doCovertion;
  int? type;
  String? currency;
  String? paymentInfo;
  String? molliePaymentKey;
  String? deletedAt;
  int? canDinein;
  String? alias;
  String? logom;
  String? icon;
  String? coverm;
  List<Categories>? categories;

  Data(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.name,
        this.subdomain,
        this.logo,
        this.cover,
        this.active,
        this.userId,
        this.lat,
        this.lng,
        this.address,
        this.phone,
        this.minimum,
        this.description,
        this.fee,
        this.staticFee,
        this.radius,
        this.isFeatured,
        this.cityId,
        this.views,
        this.canPickup,
        this.canDeliver,
        this.selfDeliver,
        this.freeDeliver,
        this.whatsappPhone,
        this.fbUsername,
        this.doCovertion,
        this.currency,
        this.paymentInfo,
        this.molliePaymentKey,
        this.deletedAt,
        this.canDinein,
        this.alias,
        this.logom,
        this.icon,
        this.coverm,
        this.categories});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    name = json['name'];
    subdomain = json['subdomain'];
    logo = json['logo'];
    cover = json['cover'];
    active = json['active'];
    userId = json['user_id'];
    lat = json['lat'];
    lng = json['lng'];
    address = json['address'];
    phone = json['phone'];
    minimum = json['minimum'];
    description = json['description'];
    fee = json['fee'];
    type = json['type'];
    staticFee = json['static_fee'];
    if (json['radius'] != null) {
      radius = <Radius>[];
      json['radius'].forEach((v) {
        radius!.add(new Radius.fromJson(v));
      });
    }
    isFeatured = json['is_featured'];
    cityId = json['city_id'];
    views = json['views'];
    canPickup = json['can_pickup'];
    canDeliver = json['can_deliver'];
    selfDeliver = json['self_deliver'];
    freeDeliver = json['free_deliver'];
    whatsappPhone = json['whatsapp_phone'];
    fbUsername = json['fb_username'];
    doCovertion = json['do_covertion'];
    currency = json['currency'];
    paymentInfo = json['payment_info'];
    molliePaymentKey = json['mollie_payment_key'];
    deletedAt = json['deleted_at'];
    canDinein = json['can_dinein'];
    alias = json['alias'];
    logom = json['logom'];
    icon = json['icon'];
    coverm = json['coverm'];
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(new Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['name'] = this.name;
    data['subdomain'] = this.subdomain;
    data['logo'] = this.logo;
    data['cover'] = this.cover;
    data['active'] = this.active;
    data['user_id'] = this.userId;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['address'] = this.address;
    data['phone'] = this.phone;
    data['minimum'] = this.minimum;
    data['description'] = this.description;
    data['fee'] = this.fee;
    data['static_fee'] = this.staticFee;
    if (this.radius != null) {
      data['radius'] = this.radius!.map((v) => v.toJson()).toList();
    }
    data['is_featured'] = this.isFeatured;
    data['city_id'] = this.cityId;
    data['views'] = this.views;
    data['can_pickup'] = this.canPickup;
    data['can_deliver'] = this.canDeliver;
    data['self_deliver'] = this.selfDeliver;
    data['free_deliver'] = this.freeDeliver;
    data['whatsapp_phone'] = this.whatsappPhone;
    data['fb_username'] = this.fbUsername;
    data['do_covertion'] = this.doCovertion;
    data['currency'] = this.currency;
    data['payment_info'] = this.paymentInfo;
    data['mollie_payment_key'] = this.molliePaymentKey;
    data['deleted_at'] = this.deletedAt;
    data['can_dinein'] = this.canDinein;
    data['alias'] = this.alias;
    data['logom'] = this.logom;
    data['icon'] = this.icon;
    data['coverm'] = this.coverm;
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Radius {
  double? lat;
  double? lng;

  Radius({this.lat, this.lng});

  Radius.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}

class Categories {
  int? id;
  String? name;
  int? restorantId;
  String? createdAt;
  String? updatedAt;
  int? orderIndex;
  int? active;
  String? deletedAt;
  List<Items>? items;

  Categories(
      {this.id,
        this.name,
        this.restorantId,
        this.createdAt,
        this.updatedAt,
        this.orderIndex,
        this.active,
        this.deletedAt,
        this.items});

  Categories.fromJson(Map<String, dynamic> json) {
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
