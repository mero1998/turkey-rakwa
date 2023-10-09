import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rakwa/Core/utils/extensions.dart';
import 'package:rakwa/api/api_helper/api_helper.dart';
import 'package:rakwa/api/api_setting/api_setting.dart';
import 'package:rakwa/model/classified_by_id_model.dart';
import 'package:rakwa/model/classified_with_category.dart';
import 'package:rakwa/model/item_with_category.dart';
import 'package:rakwa/model/paid_items_model.dart';
import 'package:rakwa/shared_preferences/shared_preferences.dart';

import '../../model/ads_model.dart';

class ClassifiedApiController with ApiHelper {
  Future<List<ClassifiedByIdModel>> getClassifiedById() async {
    Uri uri = Uri.parse(
        '${ApiKey.classifiedById}${SharedPrefController().id}/classified');
    var response = await http.get(uri, headers: tokenKey);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var jsonArray = jsonResponse['data'] as List;
      return jsonArray.map((e) => ClassifiedByIdModel.fromJson(e)).toList();
    }

    return [];
  }

   Future<AdsModel?> getClassifedWithCategory(
      {required String id}) async {
    printDM("classified-categorys is => $id");
    Uri uri = Uri.parse('${ApiKey.classifiedWithCategory}$id');
    var response;
    try{
     response = await http.get(uri, headers: tokenKey);
    }catch(e){
      printDM("e is => $e");
    }
    if (response.statusCode == 200) {
      printDM("response classified-categorys is => ${response.body}");

      var jsonResponse = jsonDecode(response.body);

      // if (jsonResponse['all_items'] != null) {
      //   var jsonArray = jsonResponse;
      // printDM("jsonArray classified-categorys is => ${jsonArray.length}");

      print("JSON::: ${jsonResponse}");
      return AdsModel.fromJson(jsonResponse);
      // }
    }

    return null;
  }


   Future<List<PaidItemsModel>> searchClassified(
      {required String cityId,
      required String stateId,
      required String category,
      required String sort,
      required String query,
      required String classifiedcategories,
     required int current_page,
      }) async {
        print("Category :: ${category}");
        print("Queryَ :: ${query}");
        print("Queryَ :: ${current_page}");
    Uri uri = Uri.parse(
        'https://rakwa.com/api/filter/classified?filter_categories[]=$category&search_query=$query&filter_state=$stateId&filter_city=$cityId&filter_sort_by=$sort&paginate=200&page=${current_page}');
  print(uri);
    var response = await http.get(uri, headers: tokenKey);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      print("Response::: ${jsonResponse}");
      var jsonArray = jsonResponse['free_classified']['data'] as List;

      return jsonArray.map((e) => PaidItemsModel.fromJson(e)).toList();
    }
    return [];
  }
}
