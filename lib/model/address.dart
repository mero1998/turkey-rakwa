

class UserAddress {
  int? id;
  String? address;
  String? createdAt;
  String? updatedAt;
  String? lat;
  String? lng;
  int? active;
  int? userId;
  String? apartment;
  String? intercom;
  String? floor;
  String? entry;
  String? build_name;
  String? build_number;
  String? block;

  UserAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    address = json['address'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    lat = json['lat'];
    lng = json['lng'];
    active = json['active'];
    userId = json['user_id'];
    apartment = json['apartment'];
    intercom = json['intercom'];
    floor = json['floor'];
    entry = json['entry'];
    build_name = json['build_name'];
    build_number = json['build_number'];
    block = json['block'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['address'] = this.address;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['active'] = this.active;
    data['user_id'] = this.userId;
    data['apartment'] = this.apartment;
    data['intercom'] = this.intercom;
    data['floor'] = this.floor;
    data['entry'] = this.entry;
    return data;
  }
}

