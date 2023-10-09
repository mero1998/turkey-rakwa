
class Events {
  int? id;
  String? startTime;
  String? endTime;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? itemId;
  int? userId;
  Item? item;
  User? user;

  Events.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    itemId = json['item_id'];
    userId = json['user_id'];
    item = json['item'] != null ? new Item.fromJson(json['item']) : null;
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
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
    if (this.item != null) {
      data['item'] = this.item!.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class Item {
  int? id;
  String? name;
  String? description;
  String? image;
  int? price;
  int? categoryId;
  String? createdAt;
  String? updatedAt;
  int? available;
  int? hasVariants;
  int? vat;
  String? deletedAt;
  int? enableSystemVariants;
  int? discountedPrice;
  int? qty;
  int? qtyManagement;
  String? activeFrom;
  String? activeTo;
  int? insurance;
  int? clean;
  String? logom;
  String? icon;
  String? shortDescription;

  Item(
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
        this.qty,
        this.qtyManagement,
        this.activeFrom,
        this.activeTo,
        this.insurance,
        this.clean,
        this.logom,
        this.icon,
        this.shortDescription});

  Item.fromJson(Map<String, dynamic> json) {
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
    activeFrom = json['active_from'];
    activeTo = json['active_to'];
    insurance = json['insurance'];
    clean = json['clean'];
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
    data['qty'] = this.qty;
    data['qty_management'] = this.qtyManagement;
    data['active_from'] = this.activeFrom;
    data['active_to'] = this.activeTo;
    data['insurance'] = this.insurance;
    data['clean'] = this.clean;
    data['logom'] = this.logom;
    data['icon'] = this.icon;
    data['short_description'] = this.shortDescription;
    return data;
  }
}

class User {
  int? id;
  String? googleId;
  String? fbId;
  String? name;
  String? email;
  String? emailVerifiedAt;
  String? phone;
  String? createdAt;
  String? updatedAt;
  int? active;
  String? stripeId;
  String? cardBrand;
  String? cardLastFour;
  String? trialEndsAt;
  String? verificationCode;
  String? phoneVerifiedAt;
  String? planId;
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
  String? onorder;
  int? numorders;
  int? rejectedorders;
  String? paypalSubscribtionId;
  String? mollieCustomerId;
  String? mollieMandateId;
  String? taxPercentage;
  String? extraBillingInformation;
  String? mollieSubscribtionId;
  String? paystackSubscribtionId;
  String? paystackTransId;
  int? restaurantId;
  String? deletedAt;
  String? expotoken;
  String? pmType;
  String? pmLastFour;
  int? termsId;

  User(
      {this.id,
        this.googleId,
        this.fbId,
        this.name,
        this.email,
        this.emailVerifiedAt,
        this.phone,
        this.createdAt,
        this.updatedAt,
        this.active,
        this.stripeId,
        this.cardBrand,
        this.cardLastFour,
        this.trialEndsAt,
        this.verificationCode,
        this.phoneVerifiedAt,
        this.planId,
        this.planStatus,
        this.cancelUrl,
        this.updateUrl,
        this.checkoutId,
        this.subscriptionPlanId,
        this.stripeAccount,
        this.birthDate,
        this.lat,
        this.lng,
        this.working,
        this.onorder,
        this.numorders,
        this.rejectedorders,
        this.paypalSubscribtionId,
        this.mollieCustomerId,
        this.mollieMandateId,
        this.taxPercentage,
        this.extraBillingInformation,
        this.mollieSubscribtionId,
        this.paystackSubscribtionId,
        this.paystackTransId,
        this.restaurantId,
        this.deletedAt,
        this.expotoken,
        this.pmType,
        this.pmLastFour,
        this.termsId});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    googleId = json['google_id'];
    fbId = json['fb_id'];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    phone = json['phone'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    active = json['active'];
    stripeId = json['stripe_id'];
    cardBrand = json['card_brand'];
    cardLastFour = json['card_last_four'];
    trialEndsAt = json['trial_ends_at'];
    verificationCode = json['verification_code'];
    phoneVerifiedAt = json['phone_verified_at'];
    planId = json['plan_id'];
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
    onorder = json['onorder'];
    numorders = json['numorders'];
    rejectedorders = json['rejectedorders'];
    paypalSubscribtionId = json['paypal_subscribtion_id'];
    mollieCustomerId = json['mollie_customer_id'];
    mollieMandateId = json['mollie_mandate_id'];
    taxPercentage = json['tax_percentage'];
    extraBillingInformation = json['extra_billing_information'];
    mollieSubscribtionId = json['mollie_subscribtion_id'];
    paystackSubscribtionId = json['paystack_subscribtion_id'];
    paystackTransId = json['paystack_trans_id'];
    restaurantId = json['restaurant_id'];
    deletedAt = json['deleted_at'];
    expotoken = json['expotoken'];
    pmType = json['pm_type'];
    pmLastFour = json['pm_last_four'];
    termsId = json['terms_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['google_id'] = this.googleId;
    data['fb_id'] = this.fbId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['phone'] = this.phone;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['active'] = this.active;
    data['stripe_id'] = this.stripeId;
    data['card_brand'] = this.cardBrand;
    data['card_last_four'] = this.cardLastFour;
    data['trial_ends_at'] = this.trialEndsAt;
    data['verification_code'] = this.verificationCode;
    data['phone_verified_at'] = this.phoneVerifiedAt;
    data['plan_id'] = this.planId;
    data['plan_status'] = this.planStatus;
    data['cancel_url'] = this.cancelUrl;
    data['update_url'] = this.updateUrl;
    data['checkout_id'] = this.checkoutId;
    data['subscription_plan_id'] = this.subscriptionPlanId;
    data['stripe_account'] = this.stripeAccount;
    data['birth_date'] = this.birthDate;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['working'] = this.working;
    data['onorder'] = this.onorder;
    data['numorders'] = this.numorders;
    data['rejectedorders'] = this.rejectedorders;
    data['paypal_subscribtion_id'] = this.paypalSubscribtionId;
    data['mollie_customer_id'] = this.mollieCustomerId;
    data['mollie_mandate_id'] = this.mollieMandateId;
    data['tax_percentage'] = this.taxPercentage;
    data['extra_billing_information'] = this.extraBillingInformation;
    data['mollie_subscribtion_id'] = this.mollieSubscribtionId;
    data['paystack_subscribtion_id'] = this.paystackSubscribtionId;
    data['paystack_trans_id'] = this.paystackTransId;
    data['restaurant_id'] = this.restaurantId;
    data['deleted_at'] = this.deletedAt;
    data['expotoken'] = this.expotoken;
    data['pm_type'] = this.pmType;
    data['pm_last_four'] = this.pmLastFour;
    data['terms_id'] = this.termsId;
    return data;
  }
}
