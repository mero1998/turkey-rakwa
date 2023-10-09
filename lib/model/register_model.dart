import 'package:flutter/material.dart';

class RegisterModel {
   String? name;
   String? email;
   String? password;
   String? phone;


  RegisterModel();

  RegisterModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    password = json['password'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map<String, dynamic>();
    json['name'] = this.name;
    json['email'] = this.email;
    json['password'] = this.password;
    json['phone'] = this.phone;
    return json;
  }
}
