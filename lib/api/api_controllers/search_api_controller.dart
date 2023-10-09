import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rakwa/Core/utils/extensions.dart';
import 'package:rakwa/api/api_helper/api_helper.dart';
import 'package:rakwa/api/api_setting/api_setting.dart';
import 'package:rakwa/model/paid_items_model.dart';
import 'package:rakwa/model/search_model.dart';
import 'package:rakwa/shared_preferences/shared_preferences.dart';

class SearchApiController with ApiHelper {
  Future<List<PaidItemsModel>> search(
      {String? searchQuery,
      required String cityId,
      required String stateId,
      required String category,
      required String sort,
      required String classifiedcategories,
        String? query,
      required bool isItem}) async {
    Uri uri;

    uri = Uri.parse(
        'https://rakwa.com/api/search?search_query=$searchQuery&filter_state=$stateId&search_query=$query&filter_city=$cityId&filter_sort_by=$sort&filter_categories%5B%5D=$category&filter_classifiedcategories%5B%5D=$classifiedcategories&paginate=200&lat=${SharedPrefController().lat}&lng=${SharedPrefController().lng}');



    var response = await http.get(uri, headers: tokenKey);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      List jsonArray;
      if (isItem) {
        jsonArray = jsonResponse['free_items']['data'] as List;
      } else {
        jsonArray = jsonResponse['free_classified']['data'] as List;
      }


      return jsonArray.map((e) => PaidItemsModel.fromJson(e)).toList();
    }
    return [];
  }

  Future<List<PaidItemsModel>> searchByName(
      {String? searchQuery,

        required bool isItem}) async {
    Uri uri;

    uri = Uri.parse(
        'https://rakwa.com/api/search?search_query=$searchQuery&filter_sort_by=7&paginate=200}');


    var response = await http.get(uri, headers: tokenKey);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      List jsonArray;
      if (isItem) {
        jsonArray = jsonResponse['free_items']['data'] as List;
      } else {
        jsonArray = jsonResponse['free_classified']['data'] as List;
      }


      return jsonArray.map((e) => PaidItemsModel.fromJson(e)).toList();
    }
    return [];
  }
}
