import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:rakwa/api/api_helper/api_helper.dart';
import 'package:rakwa/api/api_setting/api_setting.dart';
import 'package:rakwa/controller/email_verified_getx_controller.dart';
import 'package:rakwa/model/artical_model.dart';
import 'package:rakwa/model/category_items.dart';
import 'package:rakwa/model/item_details.dart';
import 'package:rakwa/model/menu.dart';
import 'package:rakwa/shared_preferences/shared_preferences.dart';

import '../../model/cart.dart';

class CartApiController with ApiHelper {


  var box= GetStorage();
  Future<bool> addToCart({required String quantity,required String resId,required String id, required String variantID, required List<int> extras, required String user_id}) async{
    Uri uri = Uri.parse("${ApiKey.addToCart}");
    try{
      var requset = http.MultipartRequest('POST', uri);

      print(uri);
      requset.headers.addAll(headers);

      print(resId);
      requset.fields.addAll({
        "id" : id,
        "quantity" : quantity,
        "user_id" : box.read("id").toString(),
        "users_id" : user_id,
        "restorant_id": resId
      });

      if(variantID.isNotEmpty){
        requset.fields.addAll({
          "variantID" : variantID,
        });
      }

      if(extras.isNotEmpty){

        for(int i = 0 ; i < extras.length; i++){
          requset.fields.addAll({
            "extras[]" : extras[i].toString(),
          });
        }
      }
      var response = await requset.send();
      var response2 = await http.Response.fromStream(response);
      var json = jsonDecode(response2.body);

      print("JSON:::::: ${json}");
      // var whatsapp = json['whatsapp'];
      // final respStr = await response.stream.bytesToString();
      // print(respStr);
      if(response.statusCode == 200 &&  json['status'] == true){
        return true;
      }else{
        return false;
      }
    }catch(e){
      print("Error::: ${e.toString()}");
      return false;
    }


  }
  Future<Cart?> getCart() async {
    Uri uri = Uri.parse("${ApiKey.getCart}${box.read("id")}");

    print("URL::: ${uri}");

    var response = await http.get(uri);
    print("Code::: ${response.statusCode}");
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return Cart.fromJson(jsonResponse);
    }
    return null;
  }

  Future<List<CategoryItems>> getItemsByCategory({required String categoryId}) async {
    Uri uri = Uri.parse("${ApiKey.baseUrl2}$categoryId${ApiKey.categoryItems}");
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var jsonArrayPostData = jsonResponse['data'] as List;
      return jsonArrayPostData.map((e) => CategoryItems.fromJson(e)).toList();
    }
    return [];
  }
  Future<ItemDetails?> getItemDetails({required String itemId}) async {
    Uri uri = Uri.parse("${ApiKey.baseUrl2}$itemId/item");
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var jsonArrayPostData = jsonResponse['data'];
      return ItemDetails.fromJson(jsonArrayPostData);
    }
    return null;
  }
  // Future<List<ArticalModel>> getArticalsWithPagnation({required int current_page}) async {
  //   Uri uri = Uri.parse("${ApiKey.artical}?page=$current_page");
  //   var response = await http.get(uri, headers: headers);
  //   if (response.statusCode == 200) {
  //     var jsonResponse = jsonDecode(response.body);
  //     var jsonArray = jsonResponse['data'];
  //     var jsonArrayPost = jsonArray['posts'];
  //     var jsonArrayPostData = jsonArrayPost['data'] as List;
  //     return jsonArrayPostData.map((e) => ArticalModel.fromJson(e)).toList();
  //   }
  //   return [];
  // }




}
