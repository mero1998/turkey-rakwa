class SubscriptionsAds {
  int? code;
  bool? status;
  List<Subscriptions>? subscriptions;
  List<double>? tRY;
  List<double>? eUR;



  SubscriptionsAds.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    if (json['subscriptions'] != null) {
      subscriptions = <Subscriptions>[];
      json['subscriptions'].forEach((v) {
        subscriptions!.add(new Subscriptions.fromJson(v));
      });
    }
    tRY = json['TRY'].cast<double>();
    eUR = json['EUR'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['status'] = this.status;
    if (this.subscriptions != null) {
      data['subscriptions'] =
          this.subscriptions!.map((v) => v.toJson()).toList();
    }
    data['TRY'] = this.tRY;
    data['EUR'] = this.eUR;
    return data;
  }
}

class Subscriptions {
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
  String? approved;
  String? description;

  Subscriptions(
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
        this.approved,
        this.description});

  Subscriptions.fromJson(Map<String, dynamic> json) {
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
    approved = json['approved'];
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
    data['approved'] = this.approved;
    data['description'] = this.description;
    return data;
  }
}
