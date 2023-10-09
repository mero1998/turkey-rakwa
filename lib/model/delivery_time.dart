class DeliveryTime {
  Data? data;
  bool? status;
  String? errMsg;

  DeliveryTime({this.data, this.status, this.errMsg});

  DeliveryTime.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    status = json['status'];
    errMsg = json['errMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['status'] = this.status;
    data['errMsg'] = this.errMsg;
    return data;
  }
}

class Data {
  List<TimeSlots>? timeSlots;
  String? openingTime;
  String? closingTime;

  Data({this.timeSlots, this.openingTime, this.closingTime});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['timeSlots'] != null) {
      timeSlots = <TimeSlots>[];
      json['timeSlots'].forEach((v) {
        timeSlots!.add(new TimeSlots.fromJson(v));
      });
    }
    openingTime = json['openingTime'];
    closingTime = json['closingTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.timeSlots != null) {
      data['timeSlots'] = this.timeSlots!.map((v) => v.toJson()).toList();
    }
    data['openingTime'] = this.openingTime;
    data['closingTime'] = this.closingTime;
    return data;
  }
}

class TimeSlots {
  String? id;
  String? title;

  TimeSlots({this.id, this.title});

  TimeSlots.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    return data;
  }
}
