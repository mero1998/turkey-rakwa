import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rakwa/Core/utils/extensions.dart';
import 'package:rakwa/api/api_helper/api_helper.dart';
import 'package:rakwa/api/api_setting/api_setting.dart';
import 'package:rakwa/model/item_by_id_model.dart';
import 'package:rakwa/model/item_with_category.dart';
import 'package:rakwa/model/paid_items_model.dart';
import 'package:rakwa/shared_preferences/shared_preferences.dart';

import '../../model/ads.dart';
import '../../model/item_model.dart';
import '../../model/items_category_by_location.dart';

class ItemApiController with ApiHelper {
  Future<List<ItemsCategoryByLocation>> getItemWithCategory(
      {required String id, required String cuttrent_page}) async {
    Uri uri = Uri.parse('${ApiKey.itemWithCategory}${id}?lat=${SharedPrefController().lat}&lng=${SharedPrefController().lng}&page=${cuttrent_page}');
    print(uri);

    var response = await http.get(uri, headers: tokenKey);
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var jsonArray = jsonResponse['category']['data'] as List;
      return jsonArray.map((e) => ItemsCategoryByLocation.fromJson(e)).toList();
      }
      // return ItemsCategoryByLocation.fromJson(jsonResponse);
    return [];
  }

  Future<List<ItemByIdModel>> getItemById() async {
    Uri uri = Uri.parse('${ApiKey.user}${SharedPrefController().id}/item');
    var response = await http.get(uri, headers: tokenKey);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var jsonArray = jsonResponse['data'] as List;
      return jsonArray.map((e) => ItemByIdModel.fromJson(e)).toList();
    }

    return [];
  }

  Future<Ads?> getSectionAds({required String state, required String categoryId}) async {
    Uri uri =
    Uri.parse("${ApiKey.baseUrl}popup-ads-sections?category_id=$categoryId&state=${state}");
    var response = await http.get(uri);
    if (response.statusCode == 200 && jsonDecode(response.body)['non_popup_ads_sections'] != null) {
      printDM("uri in getNearestItems is ${uri}");
      var jsonResponse = jsonDecode(response.body)['non_popup_ads_sections'];
      //   var jsonArray = jsonResponse['nearby_items'] as List;
      //   return jsonArray.map((e) => PaidItemsModel.fromJson(e)).toList();

      // var jsonArray = jsonResponse['nearby_items']['data'] as List;
      return  Ads.fromJson(jsonResponse);
    }
    return null;
  }

  Future<Ads?> getSectionAdsPopup({required String state, required String categoryId}) async {
    Uri uri =
    Uri.parse("${ApiKey.baseUrl}non-popup-ads-sections?category_id=$categoryId&state=${state}");
    var response = await http.get(uri);
    if (response.statusCode == 200 && jsonDecode(response.body)['non_popup_ads_sections'] != null) {
      printDM("uri in getNearestItems is ${uri}");
      var jsonResponse = jsonDecode(response.body)['non_popup_ads_sections'];
      //   var jsonArray = jsonResponse['nearby_items'] as List;
      //   return jsonArray.map((e) => PaidItemsModel.fromJson(e)).toList();

      // var jsonArray = jsonResponse['nearby_items']['data'] as List;
      return  Ads.fromJson(jsonResponse);
    }
    return null;
  }
  Future<List<PaidItemsModel>> searchItem(
      {required String cityId,
      required String stateId,
      required String categoryId,
       String? subCategoryId,
      required String sort,
      required String query,
      required String classifiedcategories,
      required int current_page
      }) async {

    // required String cityId,
    // required String stateId,
    // required String categoryId,
    // required String classifiedcategories

    Uri uri = Uri.parse(
        'https://rakwa.com/api/search?'
            'filter_categories[]=$categoryId&'
            'filter_classifiedcategories=$classifiedcategories&'
            'search_query=$query&'
            'filter_state=$stateId&'
            'filter_city=$cityId&'
            'filter_sort_by=$sort&paginate=200&lat=${SharedPrefController().lat}&lng=${SharedPrefController().lng}&page=${current_page}');
    var response = await http.get(uri, headers: tokenKey);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var jsonArray = jsonResponse['free_items']['data'] as List;
      return jsonArray.map((e) => PaidItemsModel.fromJson(e)).toList();
    }
    return [];
  }
}
