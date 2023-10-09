import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rakwa/Core/utils/extensions.dart';
import 'package:rakwa/api/api_helper/api_helper.dart';
import 'package:rakwa/api/api_setting/api_setting.dart';
import 'package:rakwa/model/details_calssified_model.dart';
import 'package:rakwa/model/details_model.dart';
import 'package:rakwa/model/nearby_model.dart';

import '../../Core/services/geolocation_services.dart';
import '../../shared_preferences/shared_preferences.dart';

class DetailsApiController with ApiHelper {
  Future<DetailsModel?> getDetails({required String id}) async {
    printDM("item id is $id");
    Uri uri = Uri.parse('${ApiKey.itemDetails}$id');
    try{
      var response = await http.get(uri, headers: tokenKey);
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        return DetailsModel.fromJson(jsonResponse);
      }
      return null;
    }catch(e){
      print("Error is $e");
    }

  }

  Future<DetailsClassifiedModel?> getClassifiedDetails(
      {required String id}) async {
    print("uri classifiedDetails is => ${ApiKey.classifiedDetails}$id");
    Uri uri = Uri.parse('${ApiKey.classifiedDetails}$id');
    var response = await http.get(uri, headers: tokenKey);
      print("response classifiedDetails is => ${response.statusCode}");
    if (response.statusCode == 200) {
      print("response classifiedDetails is => ${response.body}");
      var jsonResponse = jsonDecode(response.body);
      try{
      return DetailsClassifiedModel.fromJson(jsonResponse);
      }
      catch(e){
        printDM("e is => ${e}");
      }
    }
    return null;
  }

  Future<List<NearbyModel>> getNearbyItems(
      {required double lat, required double lng}) async {

    Uri uri =
        Uri.parse('${ApiKey.nearbyItems}?item_lat=$lat&item_lng=$lng');
        // Uri.parse('${ApiKey.nearbyItems}?item_lat=41.0224563&item_lng=28.6441209');
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var jsonArray = jsonResponse['nearby_items'] as List;

      return jsonArray.map((e) => NearbyModel.fromJson(e)).toList();
    }
    return [];
  }
}
