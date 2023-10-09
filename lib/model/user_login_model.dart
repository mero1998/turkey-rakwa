// class UserLoginModel {
//   late int id;
//   late String name;
//   late String email;
//    String? first_name;
//    String? last_name;
//    String? phone;
//   late dynamic emailVerifiedAt;
//   late int roleId;
//   late String? userImage;
//   late dynamic userAbout;
//   late int userSuspended;
//   late String createdAt;
//   late String updatedAt;
//   late dynamic userPreferLanguage;
//   late dynamic userPreferCountryId;
//   late dynamic apiToken;
//
//   UserLoginModel();
//
//   UserLoginModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     email = json['email'];
//     emailVerifiedAt = json['email_verified_at'];
//     roleId = json['role_id'];
//     userImage = json['user_image'];
//     userAbout = json['user_about'];
//     userSuspended = json['user_suspended'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     userPreferLanguage = json['user_prefer_language'];
//     userPreferCountryId = json['user_prefer_country_id'];
//     apiToken = json['api_token'];
//     first_name = json['first_name'];
//     last_name = json['last_name'];
//     phone = json['phone'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['email'] = this.email;
//     data['email_verified_at'] = this.emailVerifiedAt;
//     data['role_id'] = this.roleId;
//     data['user_image'] = this.userImage;
//     data['user_about'] = this.userAbout;
//     data['user_suspended'] = this.userSuspended;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     data['user_prefer_language'] = this.userPreferLanguage;
//     data['user_prefer_country_id'] = this.userPreferCountryId;
//     data['api_token'] = this.apiToken;
//     data['first_name'] = this.first_name;
//     data['last_name'] = this.last_name;
//     data['phone'] = this.phone;
//     return data;
//   }
// }

class UserLoginModel {
  int? code;
  bool? status;
  Data? data;

  UserLoginModel({this.code, this.status, this.data});

  UserLoginModel.fromJson(Map<String, dynamic> json) {
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
  String? phone;
  String? deviceToken;
  String? firstName;
  String? lastName;
  String? vendor_id;
  Country? country;

  Data(
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
        this.deviceToken,
        this.firstName,
        this.lastName,
        this.country});

  Data.fromJson(Map<String, dynamic> json) {
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
    firstName = json['first_name'];
    lastName = json['last_name'];
    vendor_id = json['vendor_id'];
    country =
    json['country'] != null ? new Country.fromJson(json['country']) : null;
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
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    if (this.country != null) {
      data['country'] = this.country!.toJson();
    }
    return data;
  }
}

class Country {
  int? id;
  String? countryName;
  String? countryAbbr;
  String? countrySlug;
  String? createdAt;
  String? updatedAt;
  int? countryStatus;

  Country(
      {this.id,
        this.countryName,
        this.countryAbbr,
        this.countrySlug,
        this.createdAt,
        this.updatedAt,
        this.countryStatus});

  Country.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    countryName = json['country_name'];
    countryAbbr = json['country_abbr'];
    countrySlug = json['country_slug'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    countryStatus = json['country_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['country_name'] = this.countryName;
    data['country_abbr'] = this.countryAbbr;
    data['country_slug'] = this.countrySlug;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['country_status'] = this.countryStatus;
    return data;
  }
}
