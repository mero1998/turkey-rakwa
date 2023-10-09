//
// class Orders {
//   int? currentPage;
//   List<Data>? data;
//   String? firstPageUrl;
//   int? from;
//   int? lastPage;
//   String? lastPageUrl;
//   List<Links>? links;
//   Null? nextPageUrl;
//   String? path;
//   int? perPage;
//   Null? prevPageUrl;
//   int? to;
//   int? total;
//   Orders.fromJson(Map<String, dynamic> json) {
//     currentPage = json['current_page'];
//     if (json['data'] != null) {
//       data = <Data>[];
//       json['data'].forEach((v) {
//         data!.add(new Data.fromJson(v));
//       });
//     }
//     firstPageUrl = json['first_page_url'];
//     from = json['from'];
//     lastPage = json['last_page'];
//     lastPageUrl = json['last_page_url'];
//     if (json['links'] != null) {
//       links = <Links>[];
//       json['links'].forEach((v) {
//         links!.add(new Links.fromJson(v));
//       });
//     }
//     nextPageUrl = json['next_page_url'];
//     path = json['path'];
//     perPage = json['per_page'];
//     prevPageUrl = json['prev_page_url'];
//     to = json['to'];
//     total = json['total'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['current_page'] = this.currentPage;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     data['first_page_url'] = this.firstPageUrl;
//     data['from'] = this.from;
//     data['last_page'] = this.lastPage;
//     data['last_page_url'] = this.lastPageUrl;
//     if (this.links != null) {
//       data['links'] = this.links!.map((v) => v.toJson()).toList();
//     }
//     data['next_page_url'] = this.nextPageUrl;
//     data['path'] = this.path;
//     data['per_page'] = this.perPage;
//     data['prev_page_url'] = this.prevPageUrl;
//     data['to'] = this.to;
//     data['total'] = this.total;
//     return data;
//   }
// }

class Orders {
  int? id;
  String? createdAt;
  String? updatedAt;
  int? addressId;
  int? clientId;
  num? delivery_price;
  int? restorantId;
  String? driverId;
  int? deliveryPrice;
  num? orderPrice;
  String? paymentMethod;
  String? paymentStatus;
  String? comment;
  String? lat;
  String? lng;
  String? srtipePaymentId;
  int? fee;
  int? feeValue;
  int? staticFee;
  int? deliveryMethod;
  String? deliveryPickupInterval;
  num? vatvalue;
  num? paymentProcessorFee;
  String? timeToPrepare;
  String? tableId;
  String? phone;
  String? whatsappAddress;
  String? paymentLink;
  String? employeeId;
  String? deletedAt;
  String? md;
  String? coupon;
  int? discount;
  int? kdsFinished;
  int? partial_payment;

  String? idPerVendor;
  int? idFormated;
  num? orderPriceWithDiscount;
  String? timeCreated;
  String? timeFormated;
  List<LastStatus>? lastStatus;
  bool? isPrepared;
  Actions? actions;
  // List<Null>? configs;
  // List<Null>? tableassigned;
  Restorant? restorant;
  List<Items>? items;
  Address? address;



  Orders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    addressId = json['address_id'];
    clientId = json['client_id'];
    restorantId = json['restorant_id'];
    driverId = json['driver_id'];
    deliveryPrice = json['delivery_price'];
    orderPrice = json['order_price'];
    paymentMethod = json['payment_method'];
    paymentStatus = json['payment_status'];
    delivery_price = json['delivery_price'];
    comment = json['comment'];
    lat = json['lat'];
    lng = json['lng'];
    srtipePaymentId = json['srtipe_payment_id'];
    fee = json['fee'];
    feeValue = json['fee_value'];
    staticFee = json['static_fee'];
    deliveryMethod = json['delivery_method'];
    deliveryPickupInterval = json['delivery_pickup_interval'];
    vatvalue = json['vatvalue'];
    paymentProcessorFee = json['payment_processor_fee'];
    timeToPrepare = json['time_to_prepare'];
    tableId = json['table_id'];
    phone = json['phone'];
    whatsappAddress = json['whatsapp_address'];
    paymentLink = json['payment_link'];
    employeeId = json['employee_id'];
    deletedAt = json['deleted_at'];
    md = json['md'];
    coupon = json['coupon'];
    partial_payment = json['partial_payment'];
    discount = json['discount'];
    kdsFinished = json['kds_finished'];
    idPerVendor = json['id_per_vendor'];
    idFormated = json['id_formated'];
    orderPriceWithDiscount = json['order_price_with_discount'];
    timeCreated = json['time_created'];
    timeFormated = json['time_formated'];
    if (json['last_status'] != null) {
      lastStatus = <LastStatus>[];
      json['last_status'].forEach((v) {
        lastStatus!.add(new LastStatus.fromJson(v));
      });
    }
    isPrepared = json['is_prepared'];
    actions =
    json['actions'] != null ? new Actions.fromJson(json['actions']) : null;

    restorant = json['restorant'] != null
        ? new Restorant.fromJson(json['restorant'])
        : null;
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    address =
    json['address'] != null ? new Address.fromJson(json['address']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['address_id'] = this.addressId;
    data['client_id'] = this.clientId;
    data['restorant_id'] = this.restorantId;
    data['driver_id'] = this.driverId;
    data['delivery_price'] = this.deliveryPrice;
    data['order_price'] = this.orderPrice;
    data['payment_method'] = this.paymentMethod;
    data['payment_status'] = this.paymentStatus;
    data['comment'] = this.comment;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['srtipe_payment_id'] = this.srtipePaymentId;
    data['fee'] = this.fee;
    data['fee_value'] = this.feeValue;
    data['static_fee'] = this.staticFee;
    data['delivery_method'] = this.deliveryMethod;
    data['delivery_pickup_interval'] = this.deliveryPickupInterval;
    data['vatvalue'] = this.vatvalue;
    data['payment_processor_fee'] = this.paymentProcessorFee;
    data['time_to_prepare'] = this.timeToPrepare;
    data['table_id'] = this.tableId;
    data['phone'] = this.phone;
    data['whatsapp_address'] = this.whatsappAddress;
    data['payment_link'] = this.paymentLink;
    data['employee_id'] = this.employeeId;
    data['deleted_at'] = this.deletedAt;
    data['md'] = this.md;
    data['coupon'] = this.coupon;
    data['discount'] = this.discount;
    data['kds_finished'] = this.kdsFinished;
    data['id_per_vendor'] = this.idPerVendor;
    data['id_formated'] = this.idFormated;
    data['order_price_with_discount'] = this.orderPriceWithDiscount;
    data['time_created'] = this.timeCreated;
    data['time_formated'] = this.timeFormated;
    if (this.lastStatus != null) {
      data['last_status'] = this.lastStatus!.map((v) => v.toJson()).toList();
    }
    data['is_prepared'] = this.isPrepared;
    if (this.actions != null) {
      data['actions'] = this.actions!.toJson();
    }

    if (this.restorant != null) {
      data['restorant'] = this.restorant!.toJson();
    }

    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    return data;
  }
}

class LastStatus {
  int? id;
  String? name;
  String? alias;
  Pivot? pivot;

  LastStatus({this.id, this.name, this.alias, this.pivot});

  LastStatus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    alias = json['alias'];
    pivot = json['pivot'] != null ? new Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['alias'] = this.alias;

    return data;
  }
}

class Pivot {
  int? orderId;
  int? statusId;
  int? userId;
  String? createdAt;
  String? comment;

  Pivot(
      {this.orderId, this.statusId, this.userId, this.createdAt, this.comment});

  Pivot.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    statusId = json['status_id'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    comment = json['comment'];
  }

}

class Actions {
  List<String>? buttons;
  String? message;

  Actions({this.buttons, this.message});

  Actions.fromJson(Map<String, dynamic> json) {
    buttons = json['buttons'].cast<String>();
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['buttons'] = this.buttons;
    data['message'] = this.message;
    return data;
  }
}

class Restorant {
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
  Null? fbUsername;
  int? doCovertion;
  String? currency;
  int? type;
  String? paymentInfo;
  String? molliePaymentKey;
  Null? deletedAt;
  int? canDinein;
  String? alias;
  String? logom;
  String? icon;
  String? coverm;

  Restorant(
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
        this.coverm});

  Restorant.fromJson(Map<String, dynamic> json) {
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
    type = json['type'];
    description = json['description'];
    fee = json['fee'];
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
  Null? deletedAt;
  int? enableSystemVariants;
  int? discountedPrice;
  String? logom;
  String? icon;
  String? shortDescription;
  PivotOrder? pivot;

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
        this.shortDescription,
        this.pivot});

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
    pivot = json['pivot'] != null ? new PivotOrder.fromJson(json['pivot']) : null;
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
    if (this.pivot != null) {
      data['pivot'] = this.pivot!.toJson();
    }
    return data;
  }
}

class PivotOrder {
  int? orderId;
  int? itemId;
  int? qty;
  String? extras;
  int? vat;
  num? vatvalue;
  num? variantPrice;
  String? variantName;
  int? id;
  int? kdsFinished;


  PivotOrder.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    itemId = json['item_id'];
    qty = json['qty'];
    extras = json['extras'];
    vat = json['vat'];
    vatvalue = json['vatvalue'];
    variantPrice = json['variant_price'];
    variantName = json['variant_name'];
    id = json['id'];
    kdsFinished = json['kds_finished'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['item_id'] = this.itemId;
    data['qty'] = this.qty;
    data['extras'] = this.extras;
    data['vat'] = this.vat;
    data['vatvalue'] = this.vatvalue;
    data['variant_price'] = this.variantPrice;
    data['variant_name'] = this.variantName;
    data['id'] = this.id;
    data['kds_finished'] = this.kdsFinished;
    return data;
  }
}

class Address {
  int? id;
  String? address;
  String? createdAt;
  String? updatedAt;
  String? lat;
  String? lng;
  int? active;
  int? userId;



  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    address = json['address'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    lat = json['lat'];
    lng = json['lng'];
    active = json['active'];
    userId = json['user_id'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['address'] = this.address;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['active'] = this.active;
    data['user_id'] = this.userId;

    return data;
  }
}

class Links {
  String? url;
  String? label;
  bool? active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['label'] = this.label;
    data['active'] = this.active;
    return data;
  }
}
