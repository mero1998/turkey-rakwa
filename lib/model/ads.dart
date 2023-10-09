class Ads {
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

  Ads.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}
