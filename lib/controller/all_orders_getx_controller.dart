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
import 'package:rakwa/screens/order/send_order_whatsapp_screen.dart';

import '../api/api_controllers/artical_api_controller.dart';
import '../api/api_controllers/classified_api_controller.dart';
import '../api/api_controllers/details_api_controller.dart';
import '../api/api_controllers/item_api_controller.dart';
import '../api/api_controllers/menu_api_controller.dart';
import '../api/api_controllers/save_api_controller.dart';
import '../api/api_controllers/search_api_controller.dart';
import '../model/artical_model.dart';
import 'package:http/http.dart' as http;

import '../model/fees.dart';
class AllOrdersGetxController extends GetxController with StateMixin<List<Orders>>,ScrollMixin{
  static AllOrdersGetxController get to => Get.find();
  RxBool isLoading = true.obs;

  var box = GetStorage();

  // RxList<CategoryItems> itemsByCategory = <CategoryItems>[].obs;
  // RxList<ItemDetails> itemDetails = <ItemDetails>[].obs;

  bool getFirstData = false;
  bool lastPage = false;
  RxBool loading = false.obs;
  List<String> optionsValues = [];
  List<String> optionsGroupValues = [];
  int page = 1;
  RxInt selectedItem = 0.obs;

  RxString whatsappLink = "".obs;
  RxString typePay = "".obs;

  RxInt count = 1.obs;

  TextEditingController noteController = TextEditingController();
  TextEditingController couponController = TextEditingController();

  RxInt addressId = 0.obs;
  RxString address = "".obs;
  RxString costDelivery = "".obs;
  RxString coupon = "".obs;
  RxString timeId = "".obs;
  RxString deliveryType = "delivery".obs;
  RxString selectedPayment = "".obs;
  RxString selectedPaymentMethodCash = "".obs;
  RxString stripeToken = "".obs;
  RxInt vendorsIds = 0.obs;
  RxList<Orders> orders = <Orders>[].obs;
  RxList<Fees> fees = <Fees>[].obs;
  @override
  // AllOrdersGetxController.to.deliveryType.value = "delivery";

  void onInit() {
    super.onInit();
    getOrders(current_page: page);
    // getItemsByCategory(categoryId: "67");
    // getItemDetails(itemId: "298");
    // getArticalesPagenation(current_page: page);
  }


  createOrder(BuildContext context,) async{

    // setLoading();
      bool success = await OrderApiController().createOrder(context ,vendorId: vendorsIds.toString(),
      data: AllCartsGetxController.to.carts.first.data!
      );
      if(success){
        print("success");

        coupon.value = "";
        stripeToken.value = "";
        costDelivery.value = "";
        // stripeToken.value = "";
      // Get.back();
      }else{
        // Get.back();
        // Get.back();
      Fluttertoast.showToast(msg: "حدث خطأ غير متوقع", backgroundColor: Colors.black.withOpacity(0.64));

      }
  }
  createBookOrder(BuildContext context, {required String vendorId,
    required String itemID,
    required String numberofDays,
    required String assurnace ,
    required String clean,}) async{

    // setLoading();
      int orderId = await OrderApiController().createBookOrder(context ,vendorId: vendorId,
      itemID: itemID,
      numberofDays: numberofDays,
      assurnace: assurnace,
      clean: clean,
      );
      if(orderId != -1){
        print("success");
        stripeToken.value = "";
        typePay.value = "";

        AllMenusGetxController.to.createEvent(itemId: itemID, orderId: orderId.toString());
      }else{

      Fluttertoast.showToast(msg: "حدث خطأ غير متوقع", backgroundColor: Colors.black.withOpacity(0.64));

      }
  }
  applyCoupon() async{

    int? success = await OrderApiController().applyCoupon(code: couponController.text,);
    if(success != null){
      print("success");
     coupon.value = couponController.text;

     print(success);
     AllCartsGetxController.to.carts.value.first.total = success;
     AllCartsGetxController.to.carts.refresh();
      // AllCartsGetxController.to.getCart();
    }else{
      // Fluttertoast.showToast(msg: "حدث خطأ غير متوقع", backgroundColor: Colors.black.withOpacity(0.64));
    }
    couponController.text = "";
  }

  // Future<void> getArticalesPagenation({required int current_page}) async {
  //   print("we are here");
  //   List<ArticalModel> items =   await ArticalApiController().getArticalsWithPagnation(current_page:current_page );
  //   final bool emptyRepositories = items.isEmpty;
  //   if (!getFirstData && emptyRepositories) {
  //     isLoading.value = false;
  //
  //     // change(null, status: RxStatus.empty());
  //   } else if (getFirstData && emptyRepositories) {
  //     lastPage = true;
  //     isLoading.value = false;
  //
  //   } else {
  //     isLoading.value = true;
  //     getFirstData = true;
  //
  //     // for(int i = 0; i < nestedItemsMore.length; i++){
  //     //   for(int m = 0; m < result.length; m++){
  //     //     if(nestedItemsMore)
  //
  //     // if(!nestedItemsMore.contains(result)){
  //
  //     menus.addAll(items);
  //
  //     // }
  //
  //   }
  //   // }
  //   isLoading.value = false;
  //
  //   // change(repositories, status: RxStatus.success());
  //   // }
  //   // }, onError: (err) {
  //   //   isLoading.value = false;
  //   //
  //   //   // change(null, status: RxStatus.error(err.toString()));
  //   // });
  // }

  // SaveApiController().getSaveClassified()



  @override
  Future<void> onEndScroll() async{
    // TODO: implement onEndScroll
    print('onEndScroll');
    if (!lastPage) {
      page += 1;
      loading.value = true;
      // Get.dialog(Center(child: LinearProgressIndicator()));
      await getOrders(current_page: page);
      // Get.back();
      loading.value = false;

    } else {
      loading.value = false;

      Get.snackbar('تنبيه', 'لا يوجد عناصر بعد');
    }
  }

  @override
  Future<void> onTopScroll() {
    // TODO: implement onTopScroll
    throw UnimplementedError();
  }
// DetailsApiController().getDetails(id: widget.id.toString())


  Future<void> getOrders({required int current_page}) async {
    print("we are here");
    if(current_page == 1){
      orders.clear();
    }
    List<Orders> order =   await OrderApiController().getOrders(current_page:current_page );
    final bool emptyRepositories = order.isEmpty;
    if (!getFirstData && emptyRepositories) {
      isLoading.value = false;

      // change(null, status: RxStatus.empty());
    } else if (getFirstData && emptyRepositories) {
      lastPage = true;
      isLoading.value = false;

    } else {
      isLoading.value = true;
      getFirstData = true;

      // for(int i = 0; i < nestedItemsMore.length; i++){
      //   for(int m = 0; m < result.length; m++){
      //     if(nestedItemsMore)

      // if(!nestedItemsMore.contains(result)){

      orders.addAll(order);

      // }

    }
    // }
    isLoading.value = false;

    // change(repositories, status: RxStatus.success());
    // }
    // }, onError: (err) {
    //   isLoading.value = false;
    //
    //   // change(null, status: RxStatus.error(err.toString()));
    // });
  }
  Future<void> getFees({required String resId}) async {
    print("we are here");
    // costDelivery.value = "";
    fees.value =   await OrderApiController().getDeliveryCost(resId: resId);
    if(fees.isNotEmpty){
      // AllOrdersGetxController.to.costDelivery.value = fees.first.costTotal.toString();
      print("First Addresss: ${fees.first.address}");
    }
    }
}
