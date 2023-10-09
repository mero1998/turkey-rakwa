import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rakwa/api/api_helper/api_helper.dart';
import 'package:rakwa/api/api_setting/api_setting.dart';
import 'package:rakwa/model/artical_model.dart';
import 'package:rakwa/model/notifications.dart';
import 'package:rakwa/shared_preferences/shared_preferences.dart';

class NotificationsApiController with ApiHelper {
  Future<Notifications?> getNotifications() async {
    Uri uri = Uri.parse("${ApiKey.baseUrl}user/${SharedPrefController().id}/notification");
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return   Notifications.fromJson(jsonResponse);
    }
    return null;
  }
}
