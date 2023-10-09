import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rakwa/api/api_helper/api_helper.dart';
import 'package:rakwa/api/api_setting/api_setting.dart';
import 'package:rakwa/model/artical_model.dart';
import 'package:rakwa/model/last_activites.dart';

class ActivitiesApiController with ApiHelper {
  Future<List<LastActivites>> getActivities() async {
    Uri uri = Uri.parse(ApiKey.lastActivites);
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var jsonArray = jsonResponse['lastactivity'];
      var jsonArrayPostData = jsonArray['data'] as List;
      return jsonArrayPostData.map((e) => LastActivites.fromJson(e)).toList();
    }
    return [];
  }

  Future<List<LastActivites>> getActivitiesWithPagnation({required int current_page}) async {
    Uri uri = Uri.parse("${ApiKey.lastActivites}?page=$current_page");
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var jsonArray = jsonResponse['lastactivity'];
      var jsonArrayPostData = jsonArray['data'] as List;
      return jsonArrayPostData.map((e) => LastActivites.fromJson(e)).toList();
    }
    return [];
  }
}
