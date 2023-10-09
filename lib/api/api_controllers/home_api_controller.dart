import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rakwa/Core/utils/extensions.dart';
import 'package:rakwa/api/api_helper/api_helper.dart';
import 'package:rakwa/api/api_setting/api_setting.dart';
import 'package:rakwa/model/all_categories_model.dart';
import 'package:rakwa/model/app_interface.dart';
import 'package:rakwa/model/user_login_model.dart';
import 'package:rakwa/shared_preferences/shared_preferences.dart';

import '../../model/ads.dart';
import '../../model/paid_items_model.dart';

class HomeApiController with ApiHelper {

  bool isExeption = false;

  Future<String?> getBackgroundImage() async {
    Uri uri = Uri.parse(ApiKey.backgroundImage);
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      String jsonArray = jsonResponse['data'];
      print(jsonArray);
      return jsonArray;
    }
    return null;
  }

  Future<UserLoginModel?> emailVerified() async {
    Uri uri = Uri.parse('${ApiKey.verifiedEmail}${SharedPrefController().id}');
    print(uri);
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      // String jsonArray = jsonResponse['data'];
      print(jsonResponse);
      print('++++++========++++++============++++++');
      return UserLoginModel.fromJson(jsonResponse);
    }
    return null;
  }

  Future<AppInterface?> HomeScreenConfig() async {
    Uri uri = Uri.parse(ApiKey.appInterface);
    print(uri);
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      // String jsonArray = jsonResponse['data'];
      print(jsonResponse);
      return AppInterface.fromJson(jsonResponse);
    }
    return null;
  }
  Future<List<AllCategoriesModel>> getCategory() async {
    Uri uri = Uri.parse(ApiKey.category);
    var response = await http.get(uri, headers: tokenKey);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var jsonArray = jsonResponse['category'] as List;
      return jsonArray
          // .where((element) => element['category_parent_id'] == null)
          .map((e) => AllCategoriesModel.fromJson(e))
          .toList();
    }
    return [];
  }

  Future<List<AllCategoriesModel>> getSubCategory({required int id}) async {
    Uri uri = Uri.parse(ApiKey.category);
    var response = await http.get(uri, headers: tokenKey);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var jsonArray = jsonResponse['category'] as List;
      return jsonArray
          .where((element) => element['category_parent_id'] == id)
          .map((e) => AllCategoriesModel.fromJson(e))
          .toList();
    }
    return [];
  }

  Future<List<AllCategoriesModel>> getAllCategories() async {
    Uri uri = Uri.parse(ApiKey.allCategories);
    var response = await http.get(uri, headers: tokenKey);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      // var jsonArray = jsonResponse['category'] as List;
      var jsonArray = jsonResponse['data'] as List;
      return jsonArray.map((e) => AllCategoriesModel.fromJson(e)).toList();
    }
    return [];
  }

  Future<List<AllCategoriesModel>> getAllClassifiedCategories() async {
    Uri uri = Uri.parse(ApiKey.allClassifiedCtegories);
    var response = await http.get(uri, headers: tokenKey);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var jsonArray = jsonResponse['data'] as List;
      return jsonArray.map((e) => AllCategoriesModel.fromJson(e)).toList();
    }
    return [];
  }

  Future<List<PaidItemsModel>> getPaidItems() async {
    Uri uri = Uri.parse(ApiKey.paidItems);
    var response = await http.get(uri, headers: tokenKey);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var jsonArray = jsonResponse['data']['data'] as List;
      return jsonArray.map((e) => PaidItemsModel.fromJson(e)).toList();
    }
    return [];
  }
  Future<List<PaidItemsModel>> getRes() async {
    Uri uri = Uri.parse(ApiKey.res);
    var response = await http.get(uri, headers: tokenKey);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var jsonArray = jsonResponse['restaurant']['data'] as List;
      return jsonArray.map((e) => PaidItemsModel.fromJson(e)).toList();
    }
    return [];
  }
  Future<List<PaidItemsModel>> getSupermarkets() async {
    Uri uri = Uri.parse(ApiKey.superMarkets);
    var response = await http.get(uri, headers: tokenKey);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var jsonArray = jsonResponse['supermarket']['data'] as List;
      return jsonArray.map((e) => PaidItemsModel.fromJson(e)).toList();
    }
    return [];
  }
  Future<List<PaidItemsModel>> getCandies() async {
    Uri uri = Uri.parse(ApiKey.candies);
    var response = await http.get(uri, headers: tokenKey);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var jsonArray = jsonResponse['candies']['data'] as List;
      return jsonArray.map((e) => PaidItemsModel.fromJson(e)).toList();
    }
    return [];
  }
  Future<List<PaidItemsModel>> getBakeries() async {
    Uri uri = Uri.parse(ApiKey.bakeries);
    var response = await http.get(uri, headers: tokenKey);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var jsonArray = jsonResponse['bakeries']['data'] as List;
      return jsonArray.map((e) => PaidItemsModel.fromJson(e)).toList();
    }
    return [];
  }
  Future<List<PaidItemsModel>> getPaidItemsWithPagenation({required int current_page}) async {
    Uri uri = Uri.parse("${ApiKey.paidItems}?page=$current_page");
    var response = await http.get(uri, headers: tokenKey);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var jsonArray = jsonResponse['data']['data'] as List;
      return jsonArray.map((e) => PaidItemsModel.fromJson(e)).toList();
    }
    return [];
  }

  //non-popup-ads-home-page?state=Yozgat
  Future<Ads?> getHomeAds({required String state}) async {
    Uri uri =
    Uri.parse("${ApiKey.baseUrl}non-popup-ads-home-page?state=${state}");
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

  Future<Ads?> getHomeAdsPopup({required String state}) async {
    Uri uri =
    Uri.parse("${ApiKey.baseUrl}popup-ads-home-page?state=${state}");
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
  Future<List<PaidItemsModel>> getNearestItems({required int type}) async {
    Uri uri =
    Uri.parse("${ApiKey.nearestItems}?lat=${SharedPrefController().lat}&lng=${SharedPrefController().lng}&type=$type");
    // Uri.parse('${ApiKey.nearbyItems}?lat=41.0224563&lng=28.6441209&type=0');
// Uri.parse("https://rakwa.com/api/nearby-items?lat=41.0224563&lng=28.6441209&type=$type");
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      printDM("uri in getNearestItems is ${uri}");
      printDM("response.body in getNearestItems is ${response.body}");
      var jsonResponse = jsonDecode(response.body);
      //   var jsonArray = jsonResponse['nearby_items'] as List;
      //   return jsonArray.map((e) => PaidItemsModel.fromJson(e)).toList();
      if(type==0){
        var jsonArray = jsonResponse['nearby_items'] as List;
        return jsonArray.map((e) => PaidItemsModel.fromJson(e)).toList();
      }else{
        var jsonArray = jsonResponse['nearby_items']['data'] as List;
        return jsonArray.map((e) => PaidItemsModel.fromJson(e)).toList();
      }

    }
    return [];
  }

  Future<List<PaidItemsModel>> getNearestItemsWithPagenation({required int current_page,required int type}) async{
    Uri uri =
    Uri.parse("${ApiKey.nearestItems}?lat=${SharedPrefController().lat}&lng=${SharedPrefController().lng}&type=$type&page=$current_page");
    // var url = Uri.parse(ApiSettings.CARS + "?page=$current_page&per_page=$perPage");
   print(uri);
   try{
     var response = await http.get(uri);

     if(response.statusCode == 200) {
       var jsonResponse = jsonDecode(response.body);
       if (type == 0) {
         var jsonArray = jsonResponse['nearby_items']['data'] as List;
         return jsonArray.map((e) => PaidItemsModel.fromJson(e)).toList();
       } else {
         var jsonArray = jsonResponse['nearby_items']['data'] as List;
         return jsonArray.map((e) => PaidItemsModel.fromJson(e)).toList();
       }

     }
     return [];
   }catch(e){
     print(e);
     isExeption = true;
     return [];
   }


  }
  Future<List<PaidItemsModel>> getResWithPagenation({required int current_page}) async{
    Uri uri =
    Uri.parse("${ApiKey.res}?page=$current_page");
    // var url = Uri.parse(ApiSettings.CARS + "?page=$current_page&per_page=$perPage");
    print(uri);
    try{
      var response = await http.get(uri);

      if(response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
          var jsonArray = jsonResponse['restaurant']['data'] as List;
          return jsonArray.map((e) => PaidItemsModel.fromJson(e)).toList();
      }else{
        return [];

      }
    }catch(e){
      print(e);
      isExeption = true;
      return [];
    }




  }
  Future<List<PaidItemsModel>> getSupermarketWithPagenation({required int current_page}) async{
    Uri uri =
    Uri.parse("${ApiKey.superMarkets}?page=$current_page");
    // var url = Uri.parse(ApiSettings.CARS + "?page=$current_page&per_page=$perPage");
    print(uri);
    try{
      var response = await http.get(uri);

      if(response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        var jsonArray = jsonResponse['supermarket']['data'] as List;
        return jsonArray.map((e) => PaidItemsModel.fromJson(e)).toList();
      }else{
        return [];

      }
    }catch(e){
      print(e);
      isExeption = true;
      return [];
    }
  }

  Future<List<PaidItemsModel>> getCandiesWithPagenation({required int current_page}) async{
    Uri uri =
    Uri.parse("${ApiKey.candies}?page=$current_page");
    // var url = Uri.parse(ApiSettings.CARS + "?page=$current_page&per_page=$perPage");
    print(uri);
    try{
      var response = await http.get(uri);

      if(response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        var jsonArray = jsonResponse['candies']['data'] as List;
        return jsonArray.map((e) => PaidItemsModel.fromJson(e)).toList();
      }else{
        return [];

      }
    }catch(e){
      print(e);
      isExeption = true;
      return [];
    }
  }
  Future<List<PaidItemsModel>> getMeatsWithPagenation({required int current_page}) async{
    Uri uri =
    Uri.parse("${ApiKey.meats}?page=$current_page");
    // var url = Uri.parse(ApiSettings.CARS + "?page=$current_page&per_page=$perPage");
    print(uri);
    try{
      var response = await http.get(uri);

      if(response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        var jsonArray = jsonResponse['restaurant']['data'] as List;
        return jsonArray.map((e) => PaidItemsModel.fromJson(e)).toList();
      }else{
        return [];

      }
    }catch(e){
      print(e);
      isExeption = true;
      return [];
    }
  }
  Future<List<PaidItemsModel>> getBakeriesWithPagenation({required int current_page}) async{
    Uri uri =
    Uri.parse("${ApiKey.bakeries}?page=$current_page");
    // var url = Uri.parse(ApiSettings.CARS + "?page=$current_page&per_page=$perPage");
    print(uri);
    try{
      var response = await http.get(uri);

      if(response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        var jsonArray = jsonResponse['bakeries']['data'] as List;
        return jsonArray.map((e) => PaidItemsModel.fromJson(e)).toList();
      }else{
        return [];

      }
    }catch(e){
      print(e);
      isExeption = true;
      return [];
    }
  }
  Future<List<PaidItemsModel>> getPaidClassified() async {
    Uri uri = Uri.parse(ApiKey.paidClassified);
    var response = await http.get(uri, headers: tokenKey);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var jsonArray = jsonResponse['data'] as List;
      return jsonArray.map((e) => PaidItemsModel.fromJson(e)).toList();
    }
    return [];
  }

  Future<List<PaidItemsModel>> getPopularItems() async {
    Uri uri = Uri.parse(ApiKey.popularItems);
    var response = await http.get(uri, headers: tokenKey);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var jsonArray = jsonResponse['data']['data'] as List;
      return jsonArray.map((e) => PaidItemsModel.fromJson(e)).toList();
    }
    return [];
  }
  Future<List<PaidItemsModel>> getPopularItemsWithPagenation({required int current_page}) async {
    Uri uri = Uri.parse("${ApiKey.popularItems}?page=$current_page");
    var response = await http.get(uri, headers: tokenKey);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var jsonArray = jsonResponse['data']['data'] as List;
      return jsonArray.map((e) => PaidItemsModel.fromJson(e)).toList();
    }
    return [];
  }

  Future<List<PaidItemsModel>> getPopularClassified() async {
    Uri uri = Uri.parse(ApiKey.popularClassified);
    var response = await http.get(uri, headers: tokenKey);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var jsonArray = jsonResponse['data']['data'] as List;
      return jsonArray.map((e) => PaidItemsModel.fromJson(e)).toList();
    }
    return [];
  }

  Future<List<PaidItemsModel>> getPopularClassifiedWithPagenation({required int current_page}) async {
    Uri uri = Uri.parse("${ApiKey.popularClassified}?page=$current_page");
  print(uri);
   try{
     var response = await http.get(uri, headers: tokenKey);

     if (response.statusCode == 200) {
       var jsonResponse = jsonDecode(response.body);
       var jsonArray = jsonResponse['data']['data'] as List;
       return jsonArray.map((e) => PaidItemsModel.fromJson(e)).toList();
     }
   }catch(e){
     print("Error :: $e");
     return [];
   }

    return [];
  }
  Future<List<PaidItemsModel>> getNearestClassified({required int type}) async {
    Uri uri = Uri.parse("${ApiKey.nearestClassified}?lat=${SharedPrefController().lat}&lng=${SharedPrefController().lng}&type=$type");
    var response = await http.get(uri, headers: tokenKey);
    if (response.statusCode == 200) {
      printDM("response.body in getNearestClassified is ${response.body}");
      var jsonResponse = jsonDecode(response.body);
      if(type==0){
        var jsonArray = jsonResponse['nearby_classified'] as List;
        return jsonArray.map((e) => PaidItemsModel.fromJson(e)).toList();
      }else{
        var jsonArray = jsonResponse['nearby_classified']['data'] as List;
        return jsonArray.map((e) => PaidItemsModel.fromJson(e)).toList();
      }
    }
    return [];
  }

  Future<List<PaidItemsModel>> getNearestClassifiedWithPagenation({required int type, required int current_page}) async {
    Uri uri = Uri.parse("${ApiKey.nearestClassified}?lat=${SharedPrefController().lat}&lng=${SharedPrefController().lng}&page=$current_page&type=$type");
    var response = await http.get(uri, headers: tokenKey);
    print("URLL::::: ${uri}");
    if (response.statusCode == 200) {
      printDM("response.body in getNearestClassified is ${response.body}");
      var jsonResponse = jsonDecode(response.body);
      if(type==0){
        var jsonArray = jsonResponse['nearby_classified']['data'] as List;
        return jsonArray.map((e) => PaidItemsModel.fromJson(e)).toList();
      }else{
        var jsonArray = jsonResponse['nearby_classified']['data'] as List;
        return jsonArray.map((e) => PaidItemsModel.fromJson(e)).toList();
      }
    }
    return [];
  }

  Future<List<PaidItemsModel>> getLatestItems() async {
    Uri uri = Uri.parse(ApiKey.latestItems);
    var response = await http.get(uri, headers: tokenKey);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var jsonArray = jsonResponse['data']['data'] as List;
      return jsonArray.map((e) => PaidItemsModel.fromJson(e)).toList();
    }
    return [];
  }
  Future<List<PaidItemsModel>> getLatestItemsWithPagenation({required int current_page}) async {
    Uri uri = Uri.parse("${ApiKey.latestItems}?page=$current_page");
    var response = await http.get(uri, headers: tokenKey);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var jsonArray = jsonResponse['data']['data'] as List;
      return jsonArray.map((e) => PaidItemsModel.fromJson(e)).toList();
    }
    return [];
  }

  Future<List<PaidItemsModel>> getLatestClassified() async {
    Uri uri = Uri.parse(ApiKey.latestClassified);
    var response = await http.get(uri, headers: tokenKey);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var jsonArray = jsonResponse['data']['data'] as List;
      return jsonArray.map((e) => PaidItemsModel.fromJson(e)).toList();
    }
    return [];
  }

  Future<List<PaidItemsModel>> getLatestClassifiedWithPagenation({required int current_page}) async {
    Uri uri = Uri.parse("${ApiKey.latestClassified}?page=$current_page");
    var response = await http.get(uri, headers: tokenKey);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var jsonArray = jsonResponse['data']['data'] as List;
      return jsonArray.map((e) => PaidItemsModel.fromJson(e)).toList();
    }
    return [];
  }
}
