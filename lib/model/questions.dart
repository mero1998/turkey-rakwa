class Questions {
  int? code;
  bool? status;
  List<QuestionsData>? questions;
  List<int>? countComments;

  Questions({this.code, this.status, this.questions, this.countComments});

  Questions.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    if (json['questions'] != null) {
      questions = <QuestionsData>[];
      json['questions'].forEach((v) {
        questions!.add(new QuestionsData.fromJson(v));
      });
    }
    countComments = json['count_comments'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['status'] = this.status;
    if (this.questions != null) {
      data['questions'] = this.questions!.map((v) => v.toJson()).toList();
    }
    data['count_comments'] = this.countComments;
    return data;
  }
}

class QuestionsData {
  int? id;
  int? userId;
  int? questionStatus;
  String? questionTitle;
  String? questionSlug;
  String? createdAt;
  String? updatedAt;
  User? user;

  QuestionsData(
      {this.id,
        this.userId,
        this.questionStatus,
        this.questionTitle,
        this.questionSlug,
        this.createdAt,
        this.updatedAt,
        this.user});

  QuestionsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    questionStatus = json['question_status'];
    questionTitle = json['question_title'];
    questionSlug = json['question_slug'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['question_status'] = this.questionStatus;
    data['question_title'] = this.questionTitle;
    data['question_slug'] = this.questionSlug;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
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
  String? apiToken;
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
        this.apiToken,
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
    apiToken = json['api_token'];
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
    data['api_token'] = this.apiToken;
    data['device_token'] = this.deviceToken;
    return data;
  }
}

// class Questions {
//   List<Data>? data;
//   String? firstPageUrl;
//   int? from;
//   int? lastPage;
//   String? lastPageUrl;
//   String? nextPageUrl;
//   String? path;
//   int? perPage;
//   String? prevPageUrl;
//   int? to;
//   int? total;
//
//   Questions(
//       {
//         this.data,
//         this.firstPageUrl,
//         this.from,
//         this.lastPage,
//         this.lastPageUrl,
//         this.nextPageUrl,
//         this.path,
//         this.perPage,
//         this.prevPageUrl,
//         this.to,
//         this.total});
//
//   Questions.fromJson(Map<String, dynamic> json) {
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
//     data['next_page_url'] = this.nextPageUrl;
//     data['path'] = this.path;
//     data['per_page'] = this.perPage;
//     data['prev_page_url'] = this.prevPageUrl;
//     data['to'] = this.to;
//     data['total'] = this.total;
//     return data;
//   }
// }

// class Questions {
//   int? id;
//   int? userId;
//   int? questionStatus;
//   String? questionTitle;
//   String? questionSlug;
//   String? createdAt;
//   String? updatedAt;
//   User? user;
//
//   Questions(
//       {this.id,
//         this.userId,
//         this.questionStatus,
//         this.questionTitle,
//         this.questionSlug,
//         this.createdAt,
//         this.updatedAt,
//         this.user});
//
//   Questions.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     userId = json['user_id'];
//     questionStatus = json['question_status'];
//     questionTitle = json['question_title'];
//     questionSlug = json['question_slug'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     user = json['user'] != null ? new User.fromJson(json['user']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['user_id'] = this.userId;
//     data['question_status'] = this.questionStatus;
//     data['question_title'] = this.questionTitle;
//     data['question_slug'] = this.questionSlug;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     if (this.user != null) {
//       data['user'] = this.user!.toJson();
//     }
//     return data;
//   }
// }
//
// class User {
//   int? id;
//   String? name;
//   String? email;
//   String? emailVerifiedAt;
//   int? roleId;
//   String? userImage;
//   String? userAbout;
//   int? userSuspended;
//   String? createdAt;
//   String? updatedAt;
//   String? userPreferLanguage;
//   String? userPreferCountryId;
//   String? apiToken;
//   String? phone;
//   String? deviceToken;
//   String? firstName;
//   String? lastName;
//
//   User(
//       {this.id,
//         this.name,
//         this.email,
//         this.emailVerifiedAt,
//         this.roleId,
//         this.userImage,
//         this.userAbout,
//         this.userSuspended,
//         this.createdAt,
//         this.updatedAt,
//         this.userPreferLanguage,
//         this.userPreferCountryId,
//         this.apiToken,
//         this.phone,
//         this.deviceToken,
//         this.firstName,
//         this.lastName});
//
//   User.fromJson(Map<String, dynamic> json) {
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
//     phone = json['phone'];
//     deviceToken = json['device_token'];
//     firstName = json['first_name'];
//     lastName = json['last_name'];
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
//     data['phone'] = this.phone;
//     data['device_token'] = this.deviceToken;
//     data['first_name'] = this.firstName;
//     data['last_name'] = this.lastName;
//     return data;
//   }
// }
