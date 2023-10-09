import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rakwa/Core/services/dialogs.dart';
import 'package:rakwa/api/api_controllers/ads_api_controller.dart';
import 'package:rakwa/api/api_controllers/cart_api_controller.dart';
import 'package:rakwa/api/api_controllers/home_api_controller.dart';
import 'package:rakwa/api/api_controllers/list_api_controller.dart';
import 'package:rakwa/api/api_controllers/order_api_controller.dart';
import 'package:rakwa/api/api_setting/api_setting.dart';
import 'package:rakwa/controller/all_cart_getx_controller.dart';
import 'package:rakwa/controller/all_menu_getx_controller.dart';
import 'package:rakwa/model/all_categories_model.dart';
import 'package:rakwa/model/all_saved_items_model.dart';
import 'package:rakwa/model/cart.dart';
import 'package:rakwa/model/category_items.dart';
import 'package:rakwa/model/city_model.dart';
import 'package:rakwa/model/country_model.dart';
import 'package:rakwa/model/delivery_time.dart';
import 'package:rakwa/model/details_calssified_model.dart';
import 'package:rakwa/model/details_model.dart';
import 'package:rakwa/model/item_details.dart';
import 'package:rakwa/model/menu.dart';
import 'package:rakwa/model/order.dart';
import 'package:rakwa/model/orders_vendor.dart';
import 'package:rakwa/model/paid_items_model.dart';
import 'package:rakwa/model/subscriptions.dart';
import 'package:rakwa/model/user_ads.dart';
import 'package:rakwa/screens/order/send_order_whatsapp_screen.dart';

import '../api/api_controllers/artical_api_controller.dart';
import '../api/api_controllers/classified_api_controller.dart';
import '../api/api_controllers/details_api_controller.dart';
import '../api/api_controllers/item_api_controller.dart';
import '../api/api_controllers/menu_api_controller.dart';
import '../api/api_controllers/save_api_controller.dart';
import '../api/api_controllers/search_api_controller.dart';
import '../api/api_controllers/subscribtion_api_controller.dart';
import '../model/artical_model.dart';
import 'package:http/http.dart' as http;

import '../model/fees.dart';
class AllAdsGetxController extends GetxController {
  static AllAdsGetxController get to => Get.find();
  RxBool isLoading = true.obs;

  var box = GetStorage();

  RxList<UserAds> userAds = <UserAds>[].obs;

  RxInt statusAd = (-1).obs;
  RxList<String> selectedCategoriesId = <String>[].obs;
  RxInt subscriptionId = 0.obs;
  RxInt selectedAdType = 0.obs;
  RxString selectedAdTypeStr = "".obs;
  RxInt stateID = 0.obs;
  RxBool loading = true.obs;

  RxList<int> states = <int>[].obs;
  RxList<String> statesStr = <String>[].obs;
  List<String> adTypes = [
    'صورة',
    'فيديو',
  ];
  List<String> images = [
    'adimage',
    'advedio',
  ];
  @override
  // AllOrdersGetxController.to.deliveryType.value = "delivery";

  void onInit() {
    super.onInit();
    getAds();


  }



  Future<void> getAds() async {
    loading.value = true;
    userAds.value =   await AdsApiController().getUserAds();

    loading.value = false;
  }


   updateStatus({required String adId, required String  enabled})async {

     statusAd.value =  await AdsApiController().updateStatusAd(adId: adId, enabled: enabled);
  }
}
