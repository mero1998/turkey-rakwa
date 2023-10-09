class Notifications {
  int? code;
  List<Notification>? notification;

  Notifications({this.code, this.notification});

  Notifications.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['notification'] != null) {
      notification = <Notification>[];
      json['notification'].forEach((v) {
        notification!.add(new Notification.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.notification != null) {
      data['notification'] = this.notification!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Notification {
  int? id;
  int? userId;
  String? title;
  String? content;
  int? itemId;
  String? classifiedId;
  String? createdAt;
  String? updatedAt;

  Notification(
      {this.id,
        this.userId,
        this.title,
        this.content,
        this.itemId,
        this.classifiedId,
        this.createdAt,
        this.updatedAt});

  Notification.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    content = json['content'];
    itemId = json['item_id'];
    classifiedId = json['classified_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['content'] = this.content;
    data['item_id'] = this.itemId;
    data['classified_id'] = this.classifiedId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
