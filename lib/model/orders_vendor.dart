

class OrdersVendor {
  int? id;
  String? createdAt;
  String? updatedAt;
  int? addressId;
  int? clientId;
  num? delivery_price;
  int? restorantId;
  String? driverId;
  num? deliveryPrice;
  num? orderPrice;
  int? insurance;
  int? clean;
  int? partial_payment;
  int? type;
  int? total;
  String? paymentMethod;
  String? paymentStatus;
  String? comment;
  String? lat;
  String? lng;
  String? image;
  String? logom;
  String? srtipePaymentId;
  int? fee;
  int? feeValue;
  int? staticFee;
  int? deliveryMethod;
  String? deliveryPickupInterval;
  num? vatvalue;
  num? paymentProcessorFee;
  String? timeToPrepare;
  String? phone;
  String? whatsappAddress;
  String? paymentLink;
  String? md;
  String? coupon;
  int? discount;
  int? kdsFinished;
  String? idPerVendor;
  int? tip;
  int? idFormated;
  num? orderPriceWithDiscount;
  String? timeCreated;
  String? timeFormated;
  List<LastStatus>? lastStatus;
  bool? isPrepared;
  List<Items>? items;
  // List<Status>? status;
  Restorant? restorant;
  Client? client;
  Address? address;
  Event? event;




  OrdersVendor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    addressId = json['address_id'];
    clientId = json['client_id'];
    restorantId = json['restorant_id'];
    insurance = json['insurance'];
    clean = json['clean'];
    partial_payment = json['partial_payment'];
    type = json['type'];
    total = json['total'];
    delivery_price = json['delivery_price'];
    driverId = json['driver_id'];
    deliveryPrice = json['delivery_price'];
    orderPrice = json['order_price'];
    paymentMethod = json['payment_method'];
    paymentStatus = json['payment_status'];
    comment = json['comment'];
    lat = json['lat'];
    lng = json['lng'];
    srtipePaymentId = json['srtipe_payment_id'];
    fee = json['fee'];
    image = json['image'];
    logom = json['logom'];
    feeValue = json['fee_value'];
    staticFee = json['static_fee'];
    deliveryMethod = json['delivery_method'];
    deliveryPickupInterval = json['delivery_pickup_interval'];
    vatvalue = json['vatvalue'];
    paymentProcessorFee = json['payment_processor_fee'];
    timeToPrepare = json['time_to_prepare'];
    phone = json['phone'];
    whatsappAddress = json['whatsapp_address'];
    paymentLink = json['payment_link'];
    md = json['md'];
    coupon = json['coupon'];
    discount = json['discount'];
    kdsFinished = json['kds_finished'];
    idPerVendor = json['id_per_vendor'];
    tip = json['tip'];
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
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    // if (json['status'] != null) {
    //   status = <Status>[];
    //   json['status'].forEach((v) {
    //     status!.add(new Status.fromJson(v));
    //   });
    // }
    restorant = json['restorant'] != null
        ? new Restorant.fromJson(json['restorant'])
        : null;
    client =
    json['client'] != null ? new Client.fromJson(json['client']) : null;
    address =
    json['address'] != null ? new Address.fromJson(json['address']) : null;
    event = json['event'] != null ? new Event.fromJson(json['event']) : null;
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
    if (this.pivot != null) {
      data['pivot'] = this.pivot!.toJson();
    }
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['status_id'] = this.statusId;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['comment'] = this.comment;
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
  int? qty;
  int? qtyManagement;
  String? logom;
  String? icon;
  String? shortDescription;
  PivotItems? pivot;



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
    qty = json['qty'];
    qtyManagement = json['qty_management'];
    logom = json['logom'];
    icon = json['icon'];
    shortDescription = json['short_description'];
    pivot = json['pivot'] != null ? new PivotItems.fromJson(json['pivot']) : null;
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
    data['qty'] = this.qty;
    data['qty_management'] = this.qtyManagement;
    data['logom'] = this.logom;
    data['icon'] = this.icon;
    data['short_description'] = this.shortDescription;
    if (this.pivot != null) {
      data['pivot'] = this.pivot!.toJson();
    }
    return data;
  }
}

class PivotItems {
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


  PivotItems.fromJson(Map<String, dynamic> json) {
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
  int? type;
  String? lat;
  String? lng;
  String? address;
  String? phone;
  String? minimum;
  String? description;
  int? fee;
  int? staticFee;
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
  String? currency;
  String? paymentInfo;
  String? molliePaymentKey;
  String? deletedAt;
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
    type = json['type'];
    lat = json['lat'];
    lng = json['lng'];
    address = json['address'];
    phone = json['phone'];
    minimum = json['minimum'];
    description = json['description'];
    fee = json['fee'];
    staticFee = json['static_fee'];

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

class Client {
  int? id;
  // Null? googleId;
  // Null? fbId;
  String? name;
  String? email;
  // Null? emailVerifiedAt;
  String? phone;
  String? createdAt;
  String? updatedAt;
  int? active;
  String? stripeId;
  // Null? cardBrand;
  // Null? cardLastFour;
  // Null? trialEndsAt;
  String? verificationCode;
  String? phoneVerifiedAt;
  // Null? planId;
  String? planStatus;
  String? cancelUrl;
  String? updateUrl;
  String? checkoutId;
  String? subscriptionPlanId;
  String? stripeAccount;
  String? birthDate;
  String? lat;
  String? lng;
  int? working;
  // Null? onorder;
  int? numorders;
  int? rejectedorders;
  // Null? paypalSubscribtionId;
  // Null? mollieCustomerId;
  // Null? mollieMandateId;
  String? taxPercentage;
  // Null? extraBillingInformation;
  // Null? mollieSubscribtionId;
  // Null? paystackSubscribtionId;
  // Null? paystackTransId;
  // Null? restaurantId;
  // Null? deletedAt;
  // Null? expotoken;
  // Null? pmType;
  // Null? pmLastFour;
  // int? termsId;



  Client.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    // googleId = json['google_id'];
    // fbId = json['fb_id'];
    name = json['name'];
    email = json['email'];
    // emailVerifiedAt = json['email_verified_at'];
    phone = json['phone'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    active = json['active'];
    stripeId = json['stripe_id'];
    // cardBrand = json['card_brand'];
    // cardLastFour = json['card_last_four'];
    // trialEndsAt = json['trial_ends_at'];
    verificationCode = json['verification_code'];
    phoneVerifiedAt = json['phone_verified_at'];
    // planId = json['plan_id'];
    planStatus = json['plan_status'];
    cancelUrl = json['cancel_url'];
    updateUrl = json['update_url'];
    checkoutId = json['checkout_id'];
    subscriptionPlanId = json['subscription_plan_id'];
    stripeAccount = json['stripe_account'];
    birthDate = json['birth_date'];
    lat = json['lat'];
    lng = json['lng'];
    working = json['working'];
    // onorder = json['onorder'];
    numorders = json['numorders'];
    rejectedorders = json['rejectedorders'];
    // paypalSubscribtionId = json['paypal_subscribtion_id'];
    // mollieCustomerId = json['mollie_customer_id'];
    // mollieMandateId = json['mollie_mandate_id'];
    taxPercentage = json['tax_percentage'];
    // extraBillingInformation = json['extra_billing_information'];
    // mollieSubscribtionId = json['mollie_subscribtion_id'];
    // paystackSubscribtionId = json['paystack_subscribtion_id'];
    // paystackTransId = json['paystack_trans_id'];
    // restaurantId = json['restaurant_id'];
    // deletedAt = json['deleted_at'];
    // expotoken = json['expotoken'];
    // pmType = json['pm_type'];
    // pmLastFour = json['pm_last_four'];
    // termsId = json['terms_id'];
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
  String? apartment;
  String? block;
  String? intercom;
  String? floor;
  String? entry;

  Address(
      {this.id,
        this.address,
        this.createdAt,
        this.updatedAt,
        this.lat,
        this.lng,
        this.active,
        this.userId,
        this.apartment,
        this.intercom,
        this.floor,
        this.entry});

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    address = json['address'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    lat = json['lat'];
    lng = json['lng'];
    active = json['active'];
    userId = json['user_id'];
    apartment = json['apartment'];
    intercom = json['intercom'];
    block = json['block'];
    floor = json['floor'];
    entry = json['entry'];
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
    data['apartment'] = this.apartment;
    data['intercom'] = this.intercom;
    data['floor'] = this.floor;
    data['entry'] = this.entry;
    return data;
  }
}
class Event {
  int? id;
  String? startTime;
  String? endTime;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? itemId;
  int? userId;

  Event(
      {this.id,
        this.startTime,
        this.endTime,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.itemId,
        this.userId});

  Event.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    itemId = json['item_id'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['item_id'] = this.itemId;
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
