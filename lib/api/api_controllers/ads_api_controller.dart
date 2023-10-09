import 'dart:convert';
import 'dart:io';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:rakwa/Core/services/dialogs.dart';
import 'package:rakwa/api/api_controllers/profile_api_controller.dart';
import 'package:rakwa/api/api_helper/api_helper.dart';
import 'package:rakwa/api/api_setting/api_setting.dart';
import 'package:rakwa/controller/all_cart_getx_controller.dart';
import 'package:rakwa/controller/all_menu_getx_controller.dart';
import 'package:rakwa/controller/all_orders_getx_controller.dart';
import 'package:rakwa/controller/all_orders_vendor_getx_controller.dart';
import 'package:rakwa/controller/all_subscribtions_getx_controller.dart';
import 'package:rakwa/controller/email_verified_getx_controller.dart';
import 'package:rakwa/controller/error_message_controller_getx.dart';
import 'package:rakwa/controller/image_picker_controller.dart';
import 'package:rakwa/model/artical_model.dart';
import 'package:rakwa/model/cart.dart';
import 'package:rakwa/model/category_items.dart';
import 'package:rakwa/model/delivery_time.dart';
import 'package:rakwa/model/item_details.dart';
import 'package:rakwa/model/menu.dart';

import 'package:flutter/material.dart';
import 'package:rakwa/model/subscriptions.dart';
import 'package:rakwa/model/user_ads.dart';
import 'package:rakwa/screens/main_screens/btm_nav_screens/Home/Screens/home_screen.dart';
import 'package:rakwa/screens/main_screens/main_screen.dart';
import 'package:rakwa/screens/order/confirm_order_book_screen.dart';
import 'package:rakwa/screens/order/send_order_whatsapp_screen.dart';
import 'package:rakwa/shared_preferences/shared_preferences.dart';
import 'package:rakwa/widget/SnackBar/custom_snack_bar.dart';
import 'package:rakwa/widget/app_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:video_compress/video_compress.dart';
import '../../app_colors/app_colors.dart';
import '../../model/fees.dart';
import '../../model/order.dart';
import '../../model/orders_vendor.dart';
import '../../screens/order/send_order_book_succeess_screen.dart';

class AdsApiController with ApiHelper {

  // var box = GetStorage();
  Future<List<UserAds>> getUserAds() async {
    Uri uri = Uri.parse("${ApiKey.baseUrl}show-ads/${SharedPrefController().id}");
    ("Hour:: ${uri}");
    var response = await http.get(uri, headers: headers);
    (jsonDecode(response.body));
    if (response.statusCode == 200) {

      var jsonResponse = jsonDecode(response.body)["add"] as List;
      return jsonResponse.map((e) => UserAds.fromJson(e)).toList();
    }
    return [];
  }



  Future<int> updateStatusAd({required String adId, required String enabled }) async {
    Uri uri = Uri.parse("${ApiKey.baseUrl}update-status/${adId}");
   print ("Hour:: ${uri}");
    var response = await http.post(uri, headers: headers, body: {
      "enabled" : enabled,
    });
    print(jsonDecode(response.body));
    if (response.statusCode == 200) {

      // if(enabled == "1"){
      //   return 2;
      // }else{
      //   return 1;
      // }
     return int.parse(jsonDecode(response.body)['smartads']['enabled']) ;
      // var jsonResponse = jsonDecode(response.body)["add"] as List;
      // return jsonResponse.map((e) => UserAds.fromJson(e)).toList();
    // return true;
    }
    return -1;
  }









}
