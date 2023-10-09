class UserAds {
  int? id;
  String? subscriptionId;
  String? userId;
  String? type;
  String? image;
  String? url;
  int? views;
  int? clicks;
  int? enabled;
  String? stripeId;
  String? subscriptionType;
  String? createdAt;
  String? updatedAt;
  Subscription? subscription;
  List<AllCategoriessmartads>? allCategoriessmartads;
  List<States>? states;



  UserAds.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subscriptionId = json['subscription_id'];
    userId = json['user_id'];
    type = json['type'];
    image = json['image'];
    url = json['url'];
    views = json['views'];
    clicks = json['clicks'];
    enabled = json['enabled'];
    stripeId = json['stripe_id'];
    subscriptionType = json['subscription_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    subscription = json['subscription'] != null
        ? new Subscription.fromJson(json['subscription'])
        : null;
    if (json['all_categoriessmartads'] != null) {
      allCategoriessmartads = <AllCategoriessmartads>[];
      json['all_categoriessmartads'].forEach((v) {
        allCategoriessmartads!.add(new AllCategoriessmartads.fromJson(v));
      });
    }
    if (json['states'] != null) {
      states = <States>[];
      json['states'].forEach((v) {
        states!.add(new States.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subscription_id'] = this.subscriptionId;
    data['user_id'] = this.userId;
    data['type'] = this.type;
    data['image'] = this.image;
    data['url'] = this.url;
    data['views'] = this.views;
    data['clicks'] = this.clicks;
    data['enabled'] = this.enabled;
    data['stripe_id'] = this.stripeId;
    data['subscription_type'] = this.subscriptionType;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.subscription != null) {
      data['subscription'] = this.subscription!.toJson();
    }
    if (this.allCategoriessmartads != null) {
      data['all_categoriessmartads'] =
          this.allCategoriessmartads!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Subscription {
  int? id;
  String? name;
  int? clicks;
  String? priceClicks;
  int? views;
  String? priceViews;
  String? createdAt;
  String? updatedAt;
  String? total;
  int? type;
  String? description;

  Subscription(
      {this.id,
        this.name,
        this.clicks,
        this.priceClicks,
        this.views,
        this.priceViews,
        this.createdAt,
        this.updatedAt,
        this.total,
        this.type,
        this.description});

  Subscription.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    clicks = json['clicks'];
    priceClicks = json['price_clicks'];
    views = json['views'];
    priceViews = json['price_views'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    total = json['total'];
    type = json['type'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['clicks'] = this.clicks;
    data['price_clicks'] = this.priceClicks;
    data['views'] = this.views;
    data['price_views'] = this.priceViews;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['total'] = this.total;
    data['type'] = this.type;
    data['description'] = this.description;
    return data;
  }
}
class States {
  int? id;
  int? countryId;
  String? stateName;
  String? stateAbbr;
  String? stateSlug;
  String? stateCountryAbbr;
  String? createdAt;
  String? updatedAt;
  Pivot? pivot;

  States(
      {this.id,
        this.countryId,
        this.stateName,
        this.stateAbbr,
        this.stateSlug,
        this.stateCountryAbbr,
        this.createdAt,
        this.updatedAt,
        this.pivot});

  States.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    countryId = json['country_id'];
    stateName = json['state_name'];
    stateAbbr = json['state_abbr'];
    stateSlug = json['state_slug'];
    stateCountryAbbr = json['state_country_abbr'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    pivot = json['pivot'] != null ? new Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['country_id'] = this.countryId;
    data['state_name'] = this.stateName;
    data['state_abbr'] = this.stateAbbr;
    data['state_slug'] = this.stateSlug;
    data['state_country_abbr'] = this.stateCountryAbbr;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.pivot != null) {
      data['pivot'] = this.pivot!.toJson();
    }
    return data;
  }
}

class AllCategoriessmartads {
  int? id;
  String? categoryName;
  String? categorySlug;
  String? categoryIcon;
  String? createdAt;
  String? updatedAt;
  int? categoryParentId;
  String? categoryDescription;
  String? categoryImage;
  int? categoryThumbnailType;
  int? categoryHeaderBackgroundType;
  String? categoryHeaderBackgroundColor;
  String? categoryHeaderBackgroundImage;
  String? categoryHeaderBackgroundYoutubeVideo;
  Pivot? pivot;

  AllCategoriessmartads(
      {this.id,
        this.categoryName,
        this.categorySlug,
        this.categoryIcon,
        this.createdAt,
        this.updatedAt,
        this.categoryParentId,
        this.categoryDescription,
        this.categoryImage,
        this.categoryThumbnailType,
        this.categoryHeaderBackgroundType,
        this.categoryHeaderBackgroundColor,
        this.categoryHeaderBackgroundImage,
        this.categoryHeaderBackgroundYoutubeVideo,
        this.pivot});

  AllCategoriessmartads.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    categorySlug = json['category_slug'];
    categoryIcon = json['category_icon'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    categoryParentId = json['category_parent_id'];
    categoryDescription = json['category_description'];
    categoryImage = json['category_image'];
    categoryThumbnailType = json['category_thumbnail_type'];
    categoryHeaderBackgroundType = json['category_header_background_type'];
    categoryHeaderBackgroundColor = json['category_header_background_color'];
    categoryHeaderBackgroundImage = json['category_header_background_image'];
    categoryHeaderBackgroundYoutubeVideo =
    json['category_header_background_youtube_video'];
    pivot = json['pivot'] != null ? new Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    data['category_slug'] = this.categorySlug;
    data['category_icon'] = this.categoryIcon;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['category_parent_id'] = this.categoryParentId;
    data['category_description'] = this.categoryDescription;
    data['category_image'] = this.categoryImage;
    data['category_thumbnail_type'] = this.categoryThumbnailType;
    data['category_header_background_type'] = this.categoryHeaderBackgroundType;
    data['category_header_background_color'] =
        this.categoryHeaderBackgroundColor;
    data['category_header_background_image'] =
        this.categoryHeaderBackgroundImage;
    data['category_header_background_youtube_video'] =
        this.categoryHeaderBackgroundYoutubeVideo;
    if (this.pivot != null) {
      data['pivot'] = this.pivot!.toJson();
    }
    return data;
  }
}

class Pivot {
  int? smartadsId;
  int? categoryId;
  String? createdAt;
  String? updatedAt;

  Pivot({this.smartadsId, this.categoryId, this.createdAt, this.updatedAt});

  Pivot.fromJson(Map<String, dynamic> json) {
    smartadsId = json['smartads_id'];
    categoryId = json['category_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['smartads_id'] = this.smartadsId;
    data['category_id'] = this.categoryId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
