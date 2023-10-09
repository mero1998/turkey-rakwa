class Like {
  int? code;
  bool? status;
  Review? review;
  List<User>? user;

  Like({this.code, this.status, this.review, this.user});

  Like.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    review =
    json['review'] != null ? new Review.fromJson(json['review']) : null;
    if (json['user'] != null) {
      user = <User>[];
      json['user'].forEach((v) {
        user!.add(new User.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['status'] = this.status;
    if (this.review != null) {
      data['review'] = this.review!.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Review {
  int? userId;
  String? commentId;
  String? updatedAt;
  String? createdAt;
  int? id;

  Review(
      {this.userId, this.commentId, this.updatedAt, this.createdAt, this.id});

  Review.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    commentId = json['comment_id'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['comment_id'] = this.commentId;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? email;
  String? emailVerifiedAt;
  int? roleId;
  String? userImage;
  String? userAbout;
  int? userSuspended;
  String? createdAt;
  String? updatedAt;
  String? userPreferLanguage;
  String? userPreferCountryId;
  String? apiToken;
  int? phone;
  String? deviceToken;

  User(
      {this.id,
        this.name,
        this.email,
        this.emailVerifiedAt,
        this.roleId,
        this.userImage,
        this.userAbout,
        this.userSuspended,
        this.createdAt,
        this.updatedAt,
        this.userPreferLanguage,
        this.userPreferCountryId,
        this.apiToken,
        this.phone,
        this.deviceToken});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    roleId = json['role_id'];
    userImage = json['user_image'];
    userAbout = json['user_about'];
    userSuspended = json['user_suspended'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userPreferLanguage = json['user_prefer_language'];
    userPreferCountryId = json['user_prefer_country_id'];
    apiToken = json['api_token'];
    phone = json['phone'];
    deviceToken = json['device_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['role_id'] = this.roleId;
    data['user_image'] = this.userImage;
    data['user_about'] = this.userAbout;
    data['user_suspended'] = this.userSuspended;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['user_prefer_language'] = this.userPreferLanguage;
    data['user_prefer_country_id'] = this.userPreferCountryId;
    data['api_token'] = this.apiToken;
    data['phone'] = this.phone;
    data['device_token'] = this.deviceToken;
    return data;
  }
}
