// class QuestionAnswers {
//   int? code;
//   bool? status;
//   Question? question;
//   List<Answer>? answer;
//   List<int>? countLike;
//   int? countAnswer;
//   List<User>? user;
//
//
//   QuestionAnswers(
//       {this.code,
//         this.status,
//         this.question,
//         this.answer,
//         this.countLike,
//         this.countAnswer});
//
//   QuestionAnswers.fromJson(Map<String, dynamic> json) {
//     code = json['code'];
//     status = json['status'];
//     question = json['question'] != null
//         ? new Question.fromJson(json['question'])
//         : null;
//     if (json['answer'] != null) {
//       answer = <Answer>[];
//       json['answer'].forEach((v) {
//         answer!.add(new Answer.fromJson(v));
//       });
//     }
//     countLike = json['count_like'].cast<int>();
//     countAnswer = json['count_answer'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['code'] = this.code;
//     data['status'] = this.status;
//     if (this.question != null) {
//       data['question'] = this.question!.toJson();
//     }
//     if (this.answer != null) {
//       data['answer'] = this.answer!.map((v) => v.toJson()).toList();
//     }
//     data['count_like'] = this.countLike;
//     data['count_answer'] = this.countAnswer;
//     return data;
//   }
// }
//
// class Question {
//   int? id;
//   int? userId;
//   int? questionStatus;
//   String? questionTitle;
//   String? questionSlug;
//   String? createdAt;
//   String? updatedAt;
//   User? user;
//
//   Question(
//       {this.id,
//         this.userId,
//         this.questionStatus,
//         this.questionTitle,
//         this.questionSlug,
//         this.createdAt,
//         this.updatedAt,
//         this.user});
//
//   Question.fromJson(Map<String, dynamic> json) {
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
//   int? userPreferCountryId;
//   String? apiToken;
//   int? phone;
//   String? deviceToken;
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
//         this.deviceToken});
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
//     return data;
//   }
// }
//
// class Answer {
//   int? id;
//   String? commenterId;
//   String? commenterType;
//   String? guestName;
//   String? guestEmail;
//   String? commentableType;
//   String? commentableId;
//   String? comment;
//   bool? approved;
//   int? childId;
//   String? deletedAt;
//   String? createdAt;
//   String? updatedAt;
//   User? commenter;
//
//   Answer(
//       {this.id,
//         this.commenterId,
//         this.commenterType,
//         this.guestName,
//         this.guestEmail,
//         this.commentableType,
//         this.commentableId,
//         this.comment,
//         this.approved,
//         this.childId,
//         this.deletedAt,
//         this.createdAt,
//         this.updatedAt,
//         this.commenter});
//
//   Answer.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     commenterId = json['commenter_id'];
//     commenterType = json['commenter_type'];
//     guestName = json['guest_name'];
//     guestEmail = json['guest_email'];
//     commentableType = json['commentable_type'];
//     commentableId = json['commentable_id'];
//     comment = json['comment'];
//     approved = json['approved'];
//     childId = json['child_id'];
//     deletedAt = json['deleted_at'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     commenter =
//     json['commenter'] != null ? new User.fromJson(json['commenter']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['commenter_id'] = this.commenterId;
//     data['commenter_type'] = this.commenterType;
//     data['guest_name'] = this.guestName;
//     data['guest_email'] = this.guestEmail;
//     data['commentable_type'] = this.commentableType;
//     data['commentable_id'] = this.commentableId;
//     data['comment'] = this.comment;
//     data['approved'] = this.approved;
//     data['child_id'] = this.childId;
//     data['deleted_at'] = this.deletedAt;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     if (this.commenter != null) {
//       data['commenter'] = this.commenter!.toJson();
//     }
//     return data;
//   }
//
// }
//
//
// class QuestionAnswers {
//   int? code;
//   bool? status;
//   Question? question;
//   List<Answer>? answer;
//   List<int>? countLike;
//   int? countAnswer;
//   List<List>? user;
//
//   QuestionAnswers({this.code, this.status, this.question, this.answer, this.countLike, this.countAnswer, this.user});
//
//   QuestionAnswers.fromJson(Map<String, dynamic> json) {
//     code = json['code'];
//     status = json['status'];
//     question = json['question'] != null ? new Question.fromJson(json['question']) : null;
//     if (json['answer'] != null) {
//       answer = <Answer>[];
//       json['answer'].forEach((v) { answer!.add(new Answer.fromJson(v)); });
//     }
//     countLike = json['count_like'].cast<int>();
//     countAnswer = json['count_answer'];
//     if (json['user'] != null) {
//       user = <List>[];
//       json['user'].forEach((v) { user!.add(new List.fromJson(v)); });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['code'] = this.code;
//     data['status'] = this.status;
//     if (this.question != null) {
//       data['question'] = this.question!.toJson();
//     }
//     if (this.answer != null) {
//       data['answer'] = this.answer!.map((v) => v.toJson()).toList();
//     }
//     data['count_like'] = this.countLike;
//     data['count_answer'] = this.countAnswer;
//     if (this.user != null) {
//       data['user'] = this.user!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Question {
//   int? id;
//   int? userId;
//   int? questionStatus;
//   String? questionTitle;
//   String? questionSlug;
//   String? createdAt;
//   String? updatedAt;
//   UserData? user;
//
//   Question({this.id, this.userId, this.questionStatus, this.questionTitle, this.questionSlug, this.createdAt, this.updatedAt, this.user});
//
//   Question.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     userId = json['user_id'];
//     questionStatus = json['question_status'];
//     questionTitle = json['question_title'];
//     questionSlug = json['question_slug'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     user = json['user'] != null ? new UserData.fromJson(json['user']) : null;
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
//   int? userPreferCountryId;
//   Null? apiToken;
//   Null? phone;
//   String? deviceToken;
//
//   User({this.id, this.name, this.email, this.emailVerifiedAt, this.roleId, this.userImage, this.userAbout, this.userSuspended, this.createdAt, this.updatedAt, this.userPreferLanguage, this.userPreferCountryId, this.apiToken, this.phone, this.deviceToken});
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
//     return data;
//   }
// }
//
// class Answer {
//   int? id;
//   String? commenterId;
//   String? commenterType;
//   Null? guestName;
//   Null? guestEmail;
//   String? commentableType;
//   String? commentableId;
//   String? comment;
//   bool? approved;
//   int? childId;
//   Null? deletedAt;
//   String? createdAt;
//   String? updatedAt;
//   Commenter? commenter;
//
//   Answer({this.id, this.commenterId, this.commenterType, this.guestName, this.guestEmail, this.commentableType, this.commentableId, this.comment, this.approved, this.childId, this.deletedAt, this.createdAt, this.updatedAt, this.commenter});
//
//   Answer.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     commenterId = json['commenter_id'];
//     commenterType = json['commenter_type'];
//     guestName = json['guest_name'];
//     guestEmail = json['guest_email'];
//     commentableType = json['commentable_type'];
//     commentableId = json['commentable_id'];
//     comment = json['comment'];
//     approved = json['approved'];
//     childId = json['child_id'];
//     deletedAt = json['deleted_at'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     commenter = json['commenter'] != null ? new Commenter.fromJson(json['commenter']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['commenter_id'] = this.commenterId;
//     data['commenter_type'] = this.commenterType;
//     data['guest_name'] = this.guestName;
//     data['guest_email'] = this.guestEmail;
//     data['commentable_type'] = this.commentableType;
//     data['commentable_id'] = this.commentableId;
//     data['comment'] = this.comment;
//     data['approved'] = this.approved;
//     data['child_id'] = this.childId;
//     data['deleted_at'] = this.deletedAt;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     if (this.commenter != null) {
//       data['commenter'] = this.commenter!.toJson();
//     }
//     return data;
//   }
// }
//
// class Commenter {
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
//   int? userPreferCountryId;
//   Null? apiToken;
//   int? phone;
//   String? deviceToken;
//
//   Commenter({this.id, this.name, this.email, this.emailVerifiedAt, this.roleId, this.userImage, this.userAbout, this.userSuspended, this.createdAt, this.updatedAt, this.userPreferLanguage, this.userPreferCountryId, this.apiToken, this.phone, this.deviceToken});
//
//   Commenter.fromJson(Map<String, dynamic> json) {
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
//     return data;
//   }
// }
//
// class UserData {
//
//   UserData.fromJson(Map<String, dynamic> json) {
// }
//
// Map<String, dynamic> toJson() {
//   final Map<String, dynamic> data = new Map<String, dynamic>();
//   return data;
// }
// }
class QuestionAnswers {
  int? code;
  bool? status;
  Question? question;
  List<Answer>? answer;
  List<dynamic>? countLike;
  int? countAnswer;
  List<UserData>? user;

  QuestionAnswers(
      {this.code,
        this.status,
        this.question,
        this.answer,
        this.countLike,
        this.countAnswer,
        this.user});

  QuestionAnswers.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    question = json['question'] != null
        ? new Question.fromJson(json['question'])
        : null;
    if (json['answer'] != null) {
      answer = <Answer>[];
      json['answer'].forEach((v) {
        answer!.add(new Answer.fromJson(v));
      });
    }
    if(json['count_like'] != null){
      countLike = json['count_like'];
    }
    countAnswer = json['count_answer'];
    if (json['user'] != null) {
      user = <UserData>[];
      json['user'].forEach((v) {
        user!.add(new UserData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['status'] = this.status;
    if (this.question != null) {
      data['question'] = this.question!.toJson();
    }
    if (this.answer != null) {
      data['answer'] = this.answer!.map((v) => v.toJson()).toList();
    }
    data['count_like'] = this.countLike;
    data['count_answer'] = this.countAnswer;
    if (this.user != null) {
      data['user'] = this.user!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Question {
  int? id;
  int? userId;
  int? questionStatus;
  String? questionTitle;
  String? questionSlug;
  String? createdAt;
  String? updatedAt;
  Commenter? user;

  Question(
      {this.id,
        this.userId,
        this.questionStatus,
        this.questionTitle,
        this.questionSlug,
        this.createdAt,
        this.updatedAt,
        this.user});

  Question.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    questionStatus = json['question_status'];
    questionTitle = json['question_title'];
    questionSlug = json['question_slug'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? new Commenter.fromJson(json['user']) : null;
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
  int? userPreferCountryId;
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

class Answer {
  int? id;
  String? commenterId;
  String? commenterType;
  String? guestName;
  String? guestEmail;
  String? commentableType;
  String? commentableId;
  String? comment;
  bool? approved;
  int? childId;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  Commenter? commenter;

  Answer(
      {this.id,
        this.commenterId,
        this.commenterType,
        this.guestName,
        this.guestEmail,
        this.commentableType,
        this.commentableId,
        this.comment,
        this.approved,
        this.childId,
        this.deletedAt,
        this.createdAt,
        this.updatedAt,
        this.commenter});

  Answer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    commenterId = json['commenter_id'];
    commenterType = json['commenter_type'];
    guestName = json['guest_name'];
    guestEmail = json['guest_email'];
    commentableType = json['commentable_type'];
    commentableId = json['commentable_id'];
    comment = json['comment'];
    approved = json['approved'];
    childId = json['child_id'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    commenter = json['commenter'] != null
        ? new Commenter.fromJson(json['commenter'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['commenter_id'] = this.commenterId;
    data['commenter_type'] = this.commenterType;
    data['guest_name'] = this.guestName;
    data['guest_email'] = this.guestEmail;
    data['commentable_type'] = this.commentableType;
    data['commentable_id'] = this.commentableId;
    data['comment'] = this.comment;
    data['approved'] = this.approved;
    data['child_id'] = this.childId;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.commenter != null) {
      data['commenter'] = this.commenter!.toJson();
    }
    return data;
  }
}

class Commenter {
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

  Commenter(
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

  Commenter.fromJson(Map<String, dynamic> json) {
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

class UserData {
  int? id;
  int? userId;
  int? commentId;
  String? updatedAt;
  String? createdAt;
  Commenter? user;

  UserData(
      {this.id,
        this.userId,
        this.commentId,
        this.updatedAt,
        this.createdAt,
        this.user});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    commentId = json['comment_id'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    user = json['user'] != null ? new Commenter.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['comment_id'] = this.commentId;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}
