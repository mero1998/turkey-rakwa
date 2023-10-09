import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rakwa/Core/services/dialogs.dart';
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
class AllSubscribtionsGetxController extends GetxController {
  static AllSubscribtionsGetxController get to => Get.find();
  RxBool isLoading = true.obs;

  var box = GetStorage();

  RxList<SubscriptionsAds> sub = <SubscriptionsAds>[].obs;
  RxList<AllCategoriesModel> category = <AllCategoriesModel>[].obs;

  RxList<String> selectedCategoriesId = <String>[].obs;
  RxInt subscriptionId = 0.obs;
  RxInt subscriptionType= 0.obs;
  RxInt selectedAdType = 0.obs;
  RxString selectedAdTypeStr = "".obs;
  RxString adID = "".obs;
  RxInt stateID = 0.obs;
  RxBool loading = true.obs;

  TextEditingController websiteController = TextEditingController();
  TextEditingController videoLinkController = TextEditingController();

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
  List<String> currencies = [
    'USD',
    'TRY',
    'EUR'
  ];

  RxString selectedCurrency = "USD".obs;
  RxString total = "".obs;
  RxString stripeId = "".obs;
  RxString priceView = "".obs;
  RxString  priceClick = "".obs ;
  RxBool selectedAllCategories = false.obs;
  RxBool selectedAllStates = false.obs;

  @override
  // AllOrdersGetxController.to.deliveryType.value = "delivery";

  void onInit() {
    super.onInit();
    getSubscription();


  }


  // createOrder(BuildContext context,) async{
  //
  //   // setLoading();
  //     bool success = await OrderApiController().createOrder(context ,vendorId: vendorsIds.toString(),
  //     data: AllCartsGetxController.to.carts.first.data!
  //     );
  //     if(success){
  //       print("success");
  //
  //       coupon.value = "";
  //       stripeToken.value = "";
  //       costDelivery.value = "";
  //       // stripeToken.value = "";
  //     // Get.back();
  //     }else{
  //       // Get.back();
  //       // Get.back();
  //     Fluttertoast.showToast(msg: "حدث خطأ غير متوقع", backgroundColor: Colors.black.withOpacity(0.64));
  //
  //     }
  // }

// DetailsApiController().getDetails(id: widget.id.toString())

  Future<void> getCategory() async {
    category.value = await ListApiController().getCategory();
  }
  Future<void> getSubscription() async {
    loading.value = true;
    sub.clear();
    SubscriptionsAds? subscriptionsAds =   await SubscriptionApiController().getSubscriptions();

    if(subscriptionsAds != null){
      sub.add(subscriptionsAds);
      getCategory();
      subscriptionId.value = sub.first.subscriptions!.first.id ?? 0;
      subscriptionType.value = sub.first.subscriptions!.first.type ?? 0;
      loading.value = false;

      total.value = sub.first.subscriptions!.first.total.toString();
      priceClick.value = sub.first.subscriptions!.first.priceClicks.toString();
      priceView.value = sub.first.subscriptions!.first.priceViews.toString();

      print("total ${total}");
    }


    loading.value = false;
  }
  Future<void> getSubscription2() async {
    loading.value = true;
    sub.clear();
    SubscriptionsAds? subscriptionsAds =   await SubscriptionApiController().getSubscriptions();

    if(subscriptionsAds != null){
      sub.add(subscriptionsAds);
      subscriptionId.value = sub.first.subscriptions!.first.id ?? 0;

      total.value =       num.parse(sub.first.subscriptions!.first.total.toString()).toStringAsFixed(2);
      priceClick.value = sub.first.subscriptions!.first.priceClicks.toString();
      priceView.value = sub.first.subscriptions!.first.priceViews.toString();
      loading.value = false;

      print("total ${total}");
    }

    loading.value = false;

  }


}
