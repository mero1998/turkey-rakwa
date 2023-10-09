import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rakwa/Core/services/dialogs.dart';
import 'package:rakwa/api/api_helper/api_helper.dart';
import 'package:rakwa/api/api_setting/api_setting.dart';
import 'package:rakwa/controller/questions_and_answer_getx_controller.dart';
import 'package:rakwa/model/artical_model.dart';
import 'package:rakwa/model/like.dart';
import 'package:rakwa/model/question_answers.dart';
import 'package:rakwa/model/questions.dart';

import '../../Core/utils/helpers.dart';

class QuestionAndAnswerApiController with ApiHelper {
  Future<Questions?> getQuestions({required int current_page}) async {
    Uri uri = Uri.parse(ApiKey.questions);
    ("URL:::: ${uri}");
    var response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
    ("Response::: ${jsonResponse}");
      // var jsonArrayPost = jsonArray['data'];
      // var jsonArrayPostData = jsonArrayPost['data'] as List;
      return Questions.fromJson(jsonResponse);
    }
    return null;
  }
  Future<QuestionAnswers?> getAnswers({required String questionId}) async {
    Uri uri = Uri.parse("${ApiKey.answers} $questionId");
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      // var jsonArray = jsonResponse['data'];
      // var jsonArrayPost = jsonArray['posts'];
      // var jsonArrayPostData = jsonArrayPost['data'] as List;
      (jsonResponse);
      return QuestionAnswers.fromJson(jsonResponse);
    }
    return null;
  }

  Future<void> createQuestion(BuildContext context,{required String question_title}) async {
    setLoading();

    Uri uri = Uri.parse(ApiKey.createQuestion);
    var response = await http.post(uri,body: {
      "question_title" : question_title
    },headers: tokenKey);
    Get.back();

    if (response.statusCode == 200) {
      // var jsonResponse = jsonDecode(response.body);
      // var jsonArray = jsonResponse['data'];
      // var jsonArrayPost = jsonArray['posts'];
      // var jsonArrayPostData = jsonArrayPost['data'] as List;
      ShowMySnakbar(
          title: "نجاح",
          message: "سؤالك قيد المراجعة",
          backgroundColor: Colors.green.shade700);

      Future.delayed(Duration(seconds: 1),(){
        Get.back();
Navigator.pop(context);
      });
    }else{
      var jsonResponse = jsonDecode(response.body);

      (jsonResponse);
      ShowMySnakbar(
          title: "فشل",
          message: "حدث خطأ غير متوقع",
          backgroundColor: Colors.red.shade700);
      // Get.back();

    }
  }
  Future<bool> createAnswer({required String message, required String questionId}) async {
    Uri uri = Uri.parse(ApiKey.createAnswer);
    var response = await http.post(uri,body: {
      "message" : message,
      "question_id" : questionId
    },headers: tokenKey);
    if (response.statusCode == 200) {
      // var jsonResponse = jsonDecode(response.body);
      // var jsonArray = jsonResponse['data'];
      // var jsonArrayPost = jsonArray['posts'];
      // var jsonArrayPostData = jsonArrayPost['data'] as List;
      ShowMySnakbar(
          title: "نجاح",
          message: "اجابتك قيد المراجعة",
          backgroundColor: Colors.green.shade700);
      return true;
    }else{

      ShowMySnakbar(
          title: "فشل",
          message: "حدث خطأ غير متوقع",
          backgroundColor: Colors.red.shade700);
    return false;
    }
  }
  Future<bool> updateAnswer({required String message, required String answerId}) async {
    ("Message::$message");
    Uri uri = Uri.parse("${ApiKey.updateAnswer} ${answerId}");
    var response = await http.put(uri,body: {
      "message" : message,
    },headers: tokenKey);
    if (response.statusCode == 200) {
      // var jsonResponse = jsonDecode(response.body);
      // var jsonArray = jsonResponse['data'];
      // var jsonArrayPost = jsonArray['posts'];
      // var jsonArrayPostData = jsonArrayPost['data'] as List;
      ShowMySnakbar(
          title: "نجاح",
          message: "تعديلك قيد المراجعة",
          backgroundColor: Colors.green.shade700);
      return true;
    }else{
      var jsonResponse = jsonDecode(response.body);

      (jsonResponse);
      ShowMySnakbar(
          title: "فشل",
          message: "حدث خطأ غير متوقع",
          backgroundColor: Colors.red.shade700);
      return false;
    }
  }
  Future<bool> deleteAnswer({required String answerId}) async {
    Uri uri = Uri.parse("${ApiKey.deleteAnswer} ${answerId}");
    var response = await http.delete(uri,headers: tokenKey);
    if (response.statusCode == 200) {
      // var jsonResponse = jsonDecode(response.body);
      // var jsonArray = jsonResponse['data'];
      // var jsonArrayPost = jsonArray['posts'];
      // var jsonArrayPostData = jsonArrayPost['data'] as List;
      ShowMySnakbar(
          title: "نجاح",
          message: "تم حذف الاجابة بنجاح",
          backgroundColor: Colors.green.shade700);

      return true;
    }else{
      var jsonResponse = jsonDecode(response.body);

      (jsonResponse);
      ShowMySnakbar(
          title: "فشل",
          message: "حدث خطأ غير متوقع",
          backgroundColor: Colors.red.shade700);
      return false;
    }
  }
  Future<bool> replyAnswer({required String message ,required String answerId}) async {
    Uri uri = Uri.parse("${ApiKey.replyAnswer} ${answerId}");
    var response = await http.post(uri,body: {
      "message" : message
    },headers: tokenKey);
    if (response.statusCode == 200) {
      // var jsonResponse = jsonDecode(response.body);
      // var jsonArray = jsonResponse['data'];
      // var jsonArrayPost = jsonArray['posts'];
      // var jsonArrayPostData = jsonArrayPost['data'] as List;
      ShowMySnakbar(
          title: "نجاح",
          message: "ردك قيد المراجعة",
          backgroundColor: Colors.green.shade700);

      return true;
    }else{
      var jsonResponse = jsonDecode(response.body);

      (jsonResponse);
      ShowMySnakbar(
          title: "فشل",
          message: "حدث خطأ غير متوقع",
          backgroundColor: Colors.red.shade700);
      return false;
    }
  }
  Future<bool> like({required String answerId}) async {
    Uri uri = Uri.parse(ApiKey.like);
    var response = await http.post(uri,body: {
      "answer_id" : answerId
    },headers: tokenKey);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      // var jsonArray = jsonResponse['data'];
      // var jsonArrayPost = jsonArray['posts'];
      // var jsonArrayPostData = jsonArrayPost['data'] as List;
      // Like like =
      // QuestionsAndAnswerGetxController.to.answers
      return true;
    }else{
return false;
      ("false");
    }
  }
  Future<bool> dislike({required String answerId}) async {
    ("we are here");
    Uri uri = Uri.parse("${ApiKey.dislike}$answerId");
    var response = await http.post(uri,headers: tokenKey);
    if (response.statusCode == 200) {
      // var jsonResponse = jsonDecode(response.body);
      // var jsonArray = jsonResponse['data'];
      // var jsonArrayPost = jsonArray['posts'];
      // var jsonArrayPostData = jsonArrayPost['data'] as List;
      ("true");
      return true;
    }else{
      var jsonResponse = jsonDecode(response.body);

      (jsonResponse);
      ("false");

      return false;
    }
  }
}
