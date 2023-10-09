import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rakwa/api/api_helper/api_helper.dart';
import 'package:rakwa/api/api_setting/api_setting.dart';
import 'package:rakwa/shared_preferences/shared_preferences.dart';

import '../../Core/utils/helpers.dart';

class CommentApiController with ApiHelper {
  Future<bool> createComment(
      {required String commentable_id,
      required String message,}) async {
    if(SharedPrefController().id != ""){
      Uri uri = Uri.parse(ApiKey.createComment);
      Map body = {
        "commentable_id" : commentable_id,
        "message" : message,
      };
      var response =
      await http.post(uri, headers: tokenKey, body: body);
      if (response.statusCode == 200) {
        ShowMySnakbar(
            title: 'تم اضافة تعليقك بنجاح',
            message: 'التعليق قيد المراجعة',
            backgroundColor: Colors.green.shade700);
        return true;
      }
      ShowMySnakbar(
          title: 'خطا',
          message: 'حدث خطا ما',
          backgroundColor: Colors.red.shade700);
      return false;

    }else{
      ShowMySnakbar(
          title: 'خطا',
          message: 'يجب عليك تسجيل الدخول اولاً',
          backgroundColor: Colors.red.shade700);
      return false;
    }

  }

  Future<bool> createReplayComment(
      {required String comment_id,
        required String message,}) async {
    Uri uri = Uri.parse(""
        "${ApiKey.createReplayComment}$comment_id");
    Map body = {
      "message" : message,
    };
    var response =
    await http.post(uri, headers: tokenKey, body: body);
    if (response.statusCode == 200) {
      ShowMySnakbar(
          title: 'تم اضافة تعليقك بنجاح',
          message: 'التعليق قيد المراجعة',
          backgroundColor: Colors.green.shade700);
      return true;
    }
    ShowMySnakbar(
        title: 'خطا',
        message: 'حدث خطا ما',
        backgroundColor: Colors.red.shade700);
    print("Response::: ${response.body}");
    return false;

  }

  Future<bool> createReport(
      {
        required String description,
         String? classified_id,
         String? item_id,
         String? question_id,
      }) async {
    Uri uri = Uri.parse(ApiKey.createReport);
    Map body = {};

    if(SharedPrefController().id  != ""){
      if(classified_id != null){
        body = {
          "description" : description,
          "classified_id" : classified_id ?? "",
        };
      }else if(item_id != null){
        body = {
          "description" : description,
          "item_id" : item_id ?? "",

        };
      }else{
        body = {
          "description" : description,
          "question_id" : question_id ?? "",
        };
      }
      print(body);
      var response =
      await http.post(uri, headers: tokenKey, body: body);
      if (response.statusCode == 200) {
        ShowMySnakbar(
            title: 'تم ارسال بلاغك بنجاح',
            message: 'البلاغ قيد المراجعة',
            backgroundColor: Colors.green.shade700);
        return true;
      }else{
        ShowMySnakbar(
            title: 'خطا',
            message: 'حدث خطا ما',
            backgroundColor: Colors.red.shade700);
        return false;
      }


    }else{
      ShowMySnakbar(
          title: 'خطا',
          message: 'يجب عليك تسجيل الدخول اولاً',
          backgroundColor: Colors.red.shade700);
      return false;
    }
    }


}
