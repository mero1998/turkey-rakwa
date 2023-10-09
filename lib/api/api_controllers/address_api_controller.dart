import 'dart:convert';
import 'dart:io';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:rakwa/api/api_helper/api_helper.dart';
import 'package:rakwa/api/api_setting/api_setting.dart';
import 'package:rakwa/model/artical_model.dart';
import 'package:rakwa/model/category_items.dart';
import 'package:rakwa/model/item_details.dart';
import 'package:rakwa/model/menu.dart';

import '../../model/address.dart';

class AddressApiController with ApiHelper {
  var box = GetStorage();

  Future<bool> addAddress({required String address,
    required String lat,
    required String lng,
    required String apartment,
    required String floor,
    required String buildNumber,
    required String buildName,
    required String block,

  }) async{

    Uri uri = Uri.parse("${ApiKey.add_address}");

    try{
      var response = await http.post(uri, body: {
        "address" :address,
        "user_id" :box.read("id").toString(),
        "lat" :lat,
        "lng" :lng,
        "apartment" : apartment,
        "floor" : floor,
        "build_name" : buildName,
        "build_number" : buildNumber,
        "block" : block,
      },
      headers: {
        HttpHeaders.authorizationHeader : "Bearer ${box.read("token")}"
      }
      );

      (response.statusCode);
      if (response.statusCode == 200) {
        return true;
      }else{
        return false;
      }
    }catch(e){
      ("Error::: ${e.toString()}");
      return false;
    }

  }


  Future<List<UserAddress>> getAddress({required int current_page}) async {
    Uri uri = Uri.parse("${ApiKey.add_address}/${box.read('id')}?page=$current_page");
    var response = await http.get(uri, headers: {
      HttpHeaders.authorizationHeader : 'Bearer ${box.read("token")}'
    });
    ("code:: ${response.statusCode}");
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      // var jsonArray = jsonResponse['data'];
      var jsonArrayPostData = jsonResponse['data'] as List;
      return jsonArrayPostData.map((e) => UserAddress.fromJson(e)).toList();
    }
    return [];
  }

  Future<bool> deleteAddress({required int addressId}) async {
    Uri uri = Uri.parse("${ApiKey.add_address}/delete");
    ("URL:::: ${uri}");
    var response = await http.post(uri, headers: {
      HttpHeaders.authorizationHeader : "Bearer ${box.read("token")}",
      "accept" : "application/json"
    },body: {
      "id" : addressId.toString()
    }
    );
    ("code:: ${response.statusCode}");
    (jsonDecode(response.body));
    if (response.statusCode == 200 && jsonDecode(response.body)['errMsg'] == 'Address successfully deactivated!') {
      // var jsonResponse = jsonDecode(response.body);
      // // var jsonArray = jsonResponse['data'];
      // var jsonArrayPostData = jsonResponse['data'] as List;
      // return jsonArrayPostData.map((e) => UserAddress.fromJson(e)).toList();
      return true;
    }
    return false;
  }

}
