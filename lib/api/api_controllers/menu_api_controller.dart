import 'dart:convert';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:rakwa/api/api_helper/api_helper.dart';
import 'package:rakwa/api/api_setting/api_setting.dart';
import 'package:rakwa/model/add_category.dart';
import 'package:rakwa/model/add_item.dart';
import 'package:rakwa/model/artical_model.dart';
import 'package:rakwa/model/categories.dart';
import 'package:rakwa/model/category_items.dart';
import 'package:rakwa/model/events.dart';
import 'package:rakwa/model/item_details.dart';
import 'package:rakwa/model/menu.dart';
import 'package:rakwa/model/res_details.dart' as res;
import 'package:rakwa/shared_preferences/shared_preferences.dart';

import '../../Core/utils/extensions.dart';
import '../../controller/all_menu_getx_controller.dart';
import '../../controller/image_picker_controller.dart';

class MenuApiController with ApiHelper {
  var box = GetStorage();
  Future<List<MenuItems>> getMenu({required String resturantName, required int current_page}) async {
    ("ID RES::${resturantName}");
    Uri uri = Uri.parse("${ApiKey.menu}$resturantName?page=$current_page");
  ("Menu::::; ${uri}");
   var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var jsonArrayPostData = jsonResponse['data']['data'] as List;
      return jsonArrayPostData.map((e) => MenuItems.fromJson(e)).toList();
    }
    return [];
  }


  Future<List<Events>> getEvents({required String id}) async {
    Uri uri = Uri.parse("${ApiKey.show_all_event}$id");
    print("uri::::; ${uri}");
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var jsonArrayPostData = jsonResponse['data'] as List;
      return jsonArrayPostData.map((e) => Events.fromJson(e)).toList();
    }
    return [];
  }
  // https://rakwa.me/api/v2/client/vendor/vandalburgers
  Future<List<CategoryItems>> getItemsByCategory({required String categoryId,required int current_page}) async {
    Uri uri = Uri.parse("${ApiKey.baseUrl2}$categoryId${ApiKey.categoryItems}?page=$current_page");
   print("URI::::${uri}");
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var jsonArrayPostData = jsonResponse['data']['data'] as List;
      return jsonArrayPostData.map((e) => CategoryItems.fromJson(e)).toList();
    }
    return [];
  }
  Future<res.ResDetails?> getResDetails({required String resName}) async {
    Uri uri = Uri.parse("${ApiKey.baseUrl2}${resName}");
    print("Details::: ${uri}");
    var response = await http.get(uri,);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      // var jsonArrayPostData = jsonResponse as List;
      return res.ResDetails.fromJson(jsonResponse);
    }else{
      return null;
    }
  }

  Future storeFcmTokenVendor({required String userId, required String token}) async {

    (token);
    (userId);
    Uri uri = Uri.parse("${ApiKey.baseUrl3}store");
    (uri);
    var response = await http.post(uri,body: {
      "user_id" : userId,
      "device_id" : "1",
      "fcm_token" : token,

    }, headers: headers);
    ("Store:: ${response.statusCode}");
    (response.body);
    if (response.statusCode == 200) {
      // var jsonResponse = jsonDecode(response.body);
      // var jsonArrayPostData = jsonResponse as List;
      // return res.ResDetails.fromJson(jsonResponse);


      ("stored:::");
    }else{
      // return null;
    }
  }
  Future<int> createEvent({required String itemId}) async {

    Uri uri = Uri.parse('https://rakwa.me/api/v2/client/event');
    print("URI::::; ${uri}");
    print("URI::::; ${itemId}");
    print("URI::::; ${box.read("id")}");
    print("URI::::; ${AllMenusGetxController.to.fromDate.value}");
    print("URI::::; ${AllMenusGetxController.to.fromTime.value}");
    print("URI::::; ${AllMenusGetxController.to.toDate.value}");
    print("URI::::; ${AllMenusGetxController.to.toTime.value}");
    print("${AllMenusGetxController.to.fromDate.value}${AllMenusGetxController.to.fromTime.value}");
    print("${AllMenusGetxController.to.toDate.value}${AllMenusGetxController.to.toTime.value}");
 try{
   var response = await http.post(uri,body: {
     "user_id" : box.read("id").toString(),
     "start_time" : "${AllMenusGetxController.to.fromDate.value}${AllMenusGetxController.to.fromTime.value}",
     "end_time" : "${AllMenusGetxController.to.toDate.value}${AllMenusGetxController.to.toTime.value}",
     "item_id" : itemId,
     "recurring_until" : AllMenusGetxController.to.toDate.value,

   },headers: {
     "Accept" : "application/json"
   });
   // (response.body);
   print(response.statusCode);
   print(response.body);
   if (response.statusCode == 200 && jsonDecode(response.body)['errMsg'] == "") {
     // var jsonResponse = jsonDecode(response.body);
     // var jsonArrayPostData = jsonResponse as List;
     // return res.ResDetails.fromJson(jsonResponse);

     return jsonDecode(response.body)['data']['id'];
     ("stored:::");
   }else if(response.statusCode == 200 && jsonDecode(response.body)['errMsg'] == "This item is not available at the time you have chosen"){
     // This item is not available at the time you have chosen
     Fluttertoast.showToast(msg: "عذراً هذه الفترة محجوزة");

     return -1;

   }
   else{
     return -1;
     // return null;
   }
 }catch(e){
   print("Error:::  ${e}");
  return -1;
 }

  }
  Future<bool> updateOrderEvent({required String orderId,required String eventId}) async {

    Uri uri = Uri.parse('https://rakwa.me/api/v2/vendor/update-order-event/${orderId}');

 try{
   var response = await http.post(uri,body: {
     "event_id" : eventId,


   },headers: {
     "Accept" : "application/json"
   });
   // (response.body);
   print(response.statusCode);
   print(response.body);
   if (response.statusCode == 200) {
     // var jsonResponse = jsonDecode(response.body);
     // var jsonArrayPostData = jsonResponse as List;
     // return res.ResDetails.fromJson(jsonResponse);

     return true;
     ("stored:::");
   }
   else{
     return false;
     // return null;
   }
 }catch(e){
   print("Error:::  ${e}");
  return false;
 }

  }
  //https://rakwa.me/api/v2/client/auth/registers-vendor

  Future<Map> registerVendor({required String phone, required String vendorName}) async {
    Uri uri = Uri.parse("https://rakwa.me/api/v2/client/auth/registers-vendor");
    (uri);
    var box = GetStorage();
    var response = await http.post(uri,
        body: {
          "user_id" : box.read("id").toString(),
          "vendor_name" : vendorName,
          "phone" : phone,
        });

    // ("from creare categories :: ${response.statusCode}");
    ("Response from register res:::${response.body}");
    ("Response from register res:::${response.statusCode}");
    // ("Response:::${ jsonDecode(response.body)['id']}");
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      Map map = {
        "id" : jsonResponse['id'].toString(),
        "url" : jsonResponse['url'].toString(),
      };
      // var jsonArrayPostData = jsonResponse['data'];
      return map;
    }
    return {};
  }
  Future<AddCategory?> createCategories({required String resturentId, required String categoryName}) async {
    Uri uri = Uri.parse("https://rakwa.me/api/v2/client/categories");
    (uri);
    var response = await http.post(uri,
     body: {
      "category_name" : categoryName,
      "restaurant_id" : resturentId,
    });

    ("from creare categories :: ${response.statusCode}");
    ("Response:::${response.body}");
    ("Response:::${ jsonDecode(response.body)}");
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var jsonArrayPostData = jsonResponse['data'];
      return AddCategory.fromJson(jsonArrayPostData);
    }
    return null;
  }


  Future<String> createOption({required String itemId,
    required String optionName, required List<String> options}) async {
    Uri uri = Uri.parse("https://rakwa.me/api/v2/client/options/$itemId");
    (uri);
    var response = await http.post(uri,
        body: {
          "name" : optionName,
          "options" : options.toString().replaceAll("[", "").replaceAll("]", "").toString(),
        });

    ("from creare options :: ${response.statusCode}");
    ("Response:::${response.body}");
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      String id = jsonResponse['data']["id"].toString();
      if(AllMenusGetxController.to.varents.isNotEmpty){
        for(int z = 0; z < AllMenusGetxController.to.varents.length; z++){
          MenuApiController().createVariants(itemId: itemId, price: AllMenusGetxController.to.varents[z], option: AllMenusGetxController.to.varents2[z], optionId: id);
          AllMenusGetxController.to.varents.removeAt(z);
        }
      }
      // return AddCategory.fromJson(jsonArrayPostData);
      return id;
    }
    return "";
  }

  Future<String> updateOption({required String optionId,
    required String optionName, required List<String> options}) async {
    Uri uri = Uri.parse("https://rakwa.me/api/v2/client/options/$optionId");
    (uri);
    var response = await http.put(uri,
        body: {
          "name" : optionName,
          "options" : options.toString().replaceAll("[", "").replaceAll("]", "").toString(),
        });

    ("from update option :: ${response.statusCode}");
    ("Response:::${response.body}");
    ("Response:::${ jsonDecode(response.body)}");
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      String id = jsonResponse['data']["id"].toString();
      // return AddCategory.fromJson(jsonArrayPostData);
      return id;
    }
    return "";
  }

  Future deleteOption({required String optionId,}) async {
    Uri uri = Uri.parse("https://rakwa.me/api/v2/client/options/del/$optionId");
    (uri);
    var response = await http.get(uri,);

    ("from delete option:: ${response.statusCode}");
    ("Response:::${response.body}");
    ("Response:::${ jsonDecode(response.body)}");
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      // String id = jsonResponse['data']["id"].toString();
      // return AddCategory.fromJson(jsonArrayPostData);
      // return id;
    }
    // return "";
  }
  Future<bool> createVariants({required String itemId,
    required String price, required String option, required optionId}) async {
    Uri uri = Uri.parse("https://rakwa.me/api/v2/client/variants/$itemId");
    (uri);

    // var requset = http.MultipartRequest('POST', uri);
    // Map<String, String> headers = {
    //   "Content-type": "multipart/form-data",
    //   "Accept": "application/json"
    // };
    // requset.headers.addAll(headers);
    //
    // requset.fields.addAll({
    //   "price" :  price
    // });
    var response = await http.post(uri,
        body: {
            "price" :  price,
          "option[$optionId]" : option,
        });

    ("from creare Ver :: ${response.statusCode}");
    ("Response:::${response.body}");
    if (response.statusCode == 200) {
      // var jsonResponse = jsonDecode(response.body);
      // var jsonArrayPostData = jsonResponse['data'];
      // return AddCategory.fromJson(jsonArrayPostData);
      return true;
    }
    return false;
  }

  Future<bool> updateVariants({required String verId,
    required String price, required String option, required optionId}) async {
    Uri uri = Uri.parse("https://rakwa.me/api/v2/client/variants/$verId");
    (uri);

    // var requset = http.MultipartRequest('POST', uri);
    // Map<String, String> headers = {
    //   "Content-type": "multipart/form-data",
    //   "Accept": "application/json"
    // };
    // requset.headers.addAll(headers);
    //
    // requset.fields.addAll({
    //   "price" :  price
    // });
    var response = await http.put(uri,
        body: {
          "price" :  price,
          "option[$optionId]" : option,
        });

    ("from creare categories :: ${response.statusCode}");
    ("Response:::${response.body}");
    ("Response:::${ jsonDecode(response.body)}");
    if (response.statusCode == 200) {
      // var jsonResponse = jsonDecode(response.body);
      // var jsonArrayPostData = jsonResponse['data'];
      // return AddCategory.fromJson(jsonArrayPostData);
      return true;
    }
    return false;
  }
  Future<bool> createExtra({required String itemId,
    required String price, required String extraName}) async {
    Uri uri = Uri.parse("https://rakwa.me/api/v2/client/$itemId/extras");
    (uri);

    // var requset = http.MultipartRequest('POST', uri);
    // Map<String, String> headers = {
    //   "Content-type": "multipart/form-data",
    //   "Accept": "application/json"
    // };
    // requset.headers.addAll(headers);
    //
    // requset.fields.addAll({
    //   "price" :  price
    // });
    var response = await http.post(uri,
        body: {
          "extras_name" :  extraName,
          "extras_price" : price,
        });

    ("from creare extra :: ${response.statusCode}");
    ("Response:::${response.body}");
    if (response.statusCode == 200) {
      // var jsonResponse = jsonDecode(response.body);
      // var jsonArrayPostData = jsonResponse['data'];
      // return AddCategory.fromJson(jsonArrayPostData);
      return true;
    }
    return false;
  }
  Future<bool> updateExtra({required String itemId,
    required String price, required String extraName, required String extraId}) async {
    Uri uri = Uri.parse("https://rakwa.me/api/v2/client/$itemId/extras/edit");
    (uri);
    ("From request::: ${price}");
    (extraName);
    (extraId);

    // var requset = http.MultipartRequest('POST', uri);
    // Map<String, String> headers = {
    //   "Content-type": "multipart/form-data",
    //   "Accept": "application/json"
    // };
    // requset.headers.addAll(headers);
    //
    // requset.fields.addAll({
    //   "price" :  price
    // });
    var response = await http.post(uri,
        body: {
          "extras_name_edit" :  extraName,
          "extras_price_edit" : price,
          "extras_id" : extraId,
        });

    ("from creare categories :: ${response.statusCode}");
    ("Response Extra:::${response.body}");
    ("Response:::${ jsonDecode(response.body)}");
    if (response.statusCode == 200) {
      // var jsonResponse = jsonDecode(response.body);
      // var jsonArrayPostData = jsonResponse['data'];
      // return AddCategory.fromJson(jsonArrayPostData);
      return true;
    }
    return false;
  }
  Future<String> createMenuItem({required AddItem item, required String categoryId}) async {
    Uri uri = Uri.parse("https://rakwa.me/api/v2/client/items");
    (uri);
    var requset = http.MultipartRequest('POST', uri);
    Map<String, String> headers = {
      "Content-type": "multipart/form-data",
      "Accept": "application/json"
    };
    requset.headers.addAll(headers);

    requset.fields.addAll({
      "item_name" : item.itemName ?? "",
      "item_description" : item.itemDesc ?? "",
      "item_price" : item.item_price.toString(),
      "category_id" : categoryId,
    });
    // var response = await http.post(uri, body: {
    //
    //   "item_name" : item.itemName,
    //   "item_description" : item.itemDesc,
    //   "item_price" : item.item_price.toString(),
    //   "category_id" : categoryId,
    // });

    Image? image_temp = decodeImage(
        await XFile(item.item_image ?? "").readAsBytes());

    Image resized_img = copyResize(
        image_temp!, width: 800, height: 800);

    File resized_file = File(item.item_image ?? "")
      ..writeAsBytesSync(encodeJpg(resized_img));

    var stream = new http.ByteStream(resized_file.openRead());
    var length = await resized_file.length();
    requset.files.add(
        http.MultipartFile('item_image', stream, length,
            filename: basename("item_image"))
    );

    var response = await requset.send();
    ("from creare item :: ${response.statusCode}");

    if (response.statusCode == 200) {

      ("Add Menu Item");

      var response2 = await http.Response.fromStream(response);
      var json = jsonDecode(response2.body);
      (json);
      String id = json['data']['id'].toString();
      ("Menu Item:: ${id}");
      if(AllMenusGetxController.to.extras2.isNotEmpty){
        for(int z = 0; z < AllMenusGetxController.to.extras2.length; z++){
          MenuApiController().createExtra(itemId: id, price: AllMenusGetxController.to.extras[z], extraName: AllMenusGetxController.to.extras2[z]);
          AllMenusGetxController.to.extras2.removeAt(z);
        }
      }
      for(int m = 0; m < AllMenusGetxController.to.optionsName.length ; m++){
        (AllMenusGetxController.to.optionsName[m]);
        await MenuApiController().createOption(itemId: id, optionName: AllMenusGetxController.to.optionsName[m], options: AllMenusGetxController.to.options3[m]);
        ("Options::::: ${AllMenusGetxController.to.optionsName}");
        (AllMenusGetxController.to.options3);
        AllMenusGetxController.to.optionsName.removeAt(m);
        AllMenusGetxController.to.options3.removeAt(m);
        (AllMenusGetxController.to.optionsName);
        (AllMenusGetxController.to.options3);

      }
      // var jsonResponse = jsonDecode(response.body);
      // var jsonArrayPostData = jsonResponse['data'];
      // return AddCategory.fromJson(jsonArrayPostData);
   return id;
    }else{
      return "";
    }
    // return null;
  }
  Future updateMenuItem({required AddItem item ,required String categoryId, required String resId}) async {
    Uri uri = Uri.parse("https://rakwa.me/api/v2/client/items/$resId");
    (uri);
    var requset = http.MultipartRequest('PUT', uri);
    Map<String, String> headers = {
      "Content-type": "multipart/form-data",
      "Accept": "application/json"
    };
    requset.headers.addAll(headers);

    requset.fields.addAll({
      "item_name" : item.itemName ?? "",
      "item_description" : item.itemDesc ?? "",
      "item_price" : item.item_price.toString(),
      "category_id" : categoryId,
    });
    // var response = await http.post(uri, body: {
    //
    //   "item_name" : item.itemName,
    //   "item_description" : item.itemDesc,
    //   "item_price" : item.item_price.toString(),
    //   "category_id" : categoryId,
    // });

    if(item.item_image != null){
      Image? image_temp = decodeImage(
          await XFile(item.item_image ?? "").readAsBytes());

      Image resized_img = copyResize(
          image_temp!, width: 800, height: 800);

      File resized_file = File(item.item_image ?? "")
        ..writeAsBytesSync(encodeJpg(resized_img));

      var stream = new http.ByteStream(resized_file.openRead());
      var length = await resized_file.length();
      requset.files.add(
          http.MultipartFile('item_image', stream, length,
              filename: basename("item_image"))
      );
    }


    var response = await requset.send();
    ("from creare item :: ${response.statusCode}");

    if (response.statusCode == 200) {

      ("Add Menu Item");

      var response2 = await http.Response.fromStream(response);
      var json = jsonDecode(response2.body);
      (json);
      String id = json['data']['id'].toString();
      ("Menu Item:: ${id}");

      for(int m = 0; m < AllMenusGetxController.to.optionsName.length ; m++) {
        // String optionId = await MenuApiController().createOption(itemId: itemID,
        //     optionName: AllMenusGetxController.to.optionsName[m],
        //     options: AllMenusGetxController.to.options3[m]);
    String optionId  = await  updateOption(
            optionId: AllMenusGetxController.to.optionsIds[m], optionName: AllMenusGetxController.to.optionsName[m], options:  AllMenusGetxController.to.options3[m]);

        if (AllMenusGetxController.to.varents.isNotEmpty) {
          for (int z = 0; z < AllMenusGetxController.to.varents.length; z++) {
            if(AllMenusGetxController.to.itemDetails.first.data!.variants!.where((element) => element.id == int.parse(AllMenusGetxController.to.verIds[z])).isNotEmpty){
              updateVariants(
                  verId: AllMenusGetxController.to.verIds[z], price: AllMenusGetxController.to.varents[z], option: AllMenusGetxController.to.varents2[z], optionId: optionId);
            }else{
              createVariants(itemId: resId, price: AllMenusGetxController.to.varents[z], option: AllMenusGetxController.to.varents2[z], optionId: optionId);
            }
            // MenuApiController().createVariants(itemId: itemID,
            //     price: AllMenusGetxController.to.varents[z],
            //     option: AllMenusGetxController.to.varents2[z],
            //     optionId: optionId);

          }
        }
      }

      if (AllMenusGetxController.to.extras2.isNotEmpty) {
        for (int z = 0; z < AllMenusGetxController.to.extras2.length; z++) {
          // MenuApiController().createExtra(itemId: AllMenusGetxController.to.extrasIds[z],
          //     price: AllMenusGetxController.to.extras[z],
          //     extraName: AllMenusGetxController.to.extras2[z]);

          ("Extra UPDATE ${AllMenusGetxController.to.extras[z]}");
          ("Extra UPDATE ${AllMenusGetxController.to.extras2[z]}");
          ("Extra UPDATE ${AllMenusGetxController.to.extrasIds[z]}");
          if(AllMenusGetxController.to.itemDetails.first.data!.extras!.where((element) => element.id == int.parse(AllMenusGetxController.to.extrasIds[z])).isNotEmpty){

           ("we are here update");
            updateExtra(itemId: resId, price: AllMenusGetxController.to.extras[z], extraName: AllMenusGetxController.to.extras2[z], extraId: AllMenusGetxController.to.extrasIds[z]);
          }else{
            ("we are here create");

            createExtra(itemId: resId, price: AllMenusGetxController.to.extras[z], extraName:  AllMenusGetxController.to.extras2[z]);
          }
        }
      }
      // var jsonResponse = jsonDecode(response.body);
      // var jsonArrayPostData = jsonResponse['data'];
      // return AddCategory.fromJson(jsonArrayPostData);



      AllMenusGetxController.to.getItemDetails(itemId: resId);
      AllMenusGetxController.to.varents2.clear();
      AllMenusGetxController.to.varents.clear();
      Get.back();
    }else{
      // return "";
      var response2 = await http.Response.fromStream(response);
      var json = jsonDecode(response2.body);

      // var whatsapp = json['whatsapp'];
      // ("Whatsapp:: ${whatsapp}");

      // ("JSON::: ${json}");

    }
    // return null;
  }
  Future<List<Categories>> getMenuResturentCategories({required String resturentId}) async {
    Uri uri = Uri.parse("https://rakwa.me/api/v2/client/$resturentId/categories");
    (uri);
    var response = await http.get(uri);
    (jsonDecode(response.body));
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var jsonArrayPostData = jsonResponse['data'] as List;
      return jsonArrayPostData.map((e) => Categories.fromJson(e)).toList();
    }
    return [];
  }
  Future<ItemDetails?> getItemDetails({required String itemId}) async {
    Uri uri = Uri.parse("${ApiKey.baseUrl2}$itemId/item");
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var jsonArrayPostData = jsonResponse;
      return ItemDetails.fromJson(jsonArrayPostData);
    }else{
      return null;

    }
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

  Future<List<CategoryItems>> searchItem(
      {
        required String vendorId,
        required String categoryId,
        required String query,
        required String filter_state,
        required String filter_city,
        required int current_page
      }) async {


    ("Query2:: $query");
    Uri uri = Uri.parse('https://rakwa.me/api/v2/client/search?name=${query}&category_id=${categoryId}&vendor_id=${vendorId}&filter_state=${filter_state}&filter_city=${filter_city}&page=${current_page}');
   print(uri);
    var response = await http.get(uri);
    if (response.statusCode == 200 && jsonDecode(response.body)['status'] == true) {
     // if(jsonDecode(response.body)['data'] != ""){
       var jsonResponse = jsonDecode(response.body);
       var jsonArray = jsonResponse['data']['data'] as List;
       return jsonArray.map((e) => CategoryItems.fromJson(e)).toList();
     // }
     // else{
     //   return [];
     // }


    }
    return [];
  }
}
