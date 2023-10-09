class AppInterface {
  int? code;
  bool? status;
  Data? data;

  AppInterface({this.code, this.status, this.data});

  AppInterface.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? itemNumberPaid;
  String? itemNumberLatest;
  String? itemNumberNearby;
  String? itemNumberPopular;
  String? classifiedNumberLatest;
  String? classifiedNumberPopular;
  String? classifiedNumberNearby;
  String? hideItemNumberPaid;
  String? hideItemNumberLatest;
  String? hideItemNumberNearby;
  String? hideItemNumberPopular;
  String? hideClassifiedNumberLatest;
  String? hideClassifiedNumberPopular;
  String? hideClassifiedNumberNearby;
  String? blogNumber;
  String? categoryItem;
  String? categoryClassified;
  String? advertisingCode1;
  String? advertisingCode2;
  String? advertisingCode3;
  String? advertisingCode4;
  String? application_review;
  String? last_activity;
  String? createdAt;
  String? updatedAt;


  Data(
      {this.id,
        this.itemNumberPaid,
        this.itemNumberLatest,
        this.itemNumberNearby,
        this.itemNumberPopular,
        this.classifiedNumberLatest,
        this.classifiedNumberPopular,
        this.classifiedNumberNearby,
        this.hideItemNumberPaid,
        this.hideItemNumberLatest,
        this.hideItemNumberNearby,
        this.hideItemNumberPopular,
        this.hideClassifiedNumberLatest,
        this.hideClassifiedNumberPopular,
        this.hideClassifiedNumberNearby,
        this.blogNumber,
        this.categoryItem,
        this.categoryClassified,
        this.advertisingCode1,
        this.advertisingCode2,
        this.advertisingCode3,
        this.advertisingCode4,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemNumberPaid = json['item_number_paid'];
    itemNumberLatest = json['item_number_latest'];
    itemNumberNearby = json['item_number_nearby'];
    itemNumberPopular = json['item_number_popular'];
    classifiedNumberLatest = json['classified_number_latest'];
    classifiedNumberPopular = json['classified_number_popular'];
    classifiedNumberNearby = json['classified_number_nearby'];
    hideItemNumberPaid = json['hide_item_number_paid'];
    hideItemNumberLatest = json['hide_item_number_latest'];
    hideItemNumberNearby = json['hide_item_number_nearby'];
    hideItemNumberPopular = json['hide_item_number_popular'];
    hideClassifiedNumberLatest = json['hide_classified_number_latest'];
    hideClassifiedNumberPopular = json['hide_classified_number_popular'];
    hideClassifiedNumberNearby = json['hide_classified_number_nearby'];
    blogNumber = json['blog_number'];
    categoryItem = json['category_item'];
    categoryClassified = json['category_classified'];
    advertisingCode1 = json['advertising_code1'];
    advertisingCode2 = json['advertising_code2'];
    advertisingCode3 = json['advertising_code3'];
    advertisingCode4 = json['advertising_code4'];
    application_review = json['application_review'];
    last_activity = json['last_activity'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['item_number_paid'] = this.itemNumberPaid;
    data['item_number_latest'] = this.itemNumberLatest;
    data['item_number_nearby'] = this.itemNumberNearby;
    data['item_number_popular'] = this.itemNumberPopular;
    data['classified_number_latest'] = this.classifiedNumberLatest;
    data['classified_number_popular'] = this.classifiedNumberPopular;
    data['classified_number_nearby'] = this.classifiedNumberNearby;
    data['hide_item_number_paid'] = this.hideItemNumberPaid;
    data['hide_item_number_latest'] = this.hideItemNumberLatest;
    data['hide_item_number_nearby'] = this.hideItemNumberNearby;
    data['hide_item_number_popular'] = this.hideItemNumberPopular;
    data['hide_classified_number_latest'] = this.hideClassifiedNumberLatest;
    data['hide_classified_number_popular'] = this.hideClassifiedNumberPopular;
    data['hide_classified_number_nearby'] = this.hideClassifiedNumberNearby;
    data['blog_number'] = this.blogNumber;
    data['category_item'] = this.categoryItem;
    data['category_classified'] = this.categoryClassified;
    data['advertising_code1'] = this.advertisingCode1;
    data['advertising_code2'] = this.advertisingCode2;
    data['advertising_code3'] = this.advertisingCode3;
    data['advertising_code4'] = this.advertisingCode4;
    data['application_review'] = this.application_review;
    data['last_activity'] = this.last_activity;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
