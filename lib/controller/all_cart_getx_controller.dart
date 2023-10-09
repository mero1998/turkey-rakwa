import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rakwa/api/api_controllers/cart_api_controller.dart';
import 'package:rakwa/api/api_controllers/home_api_controller.dart';
import 'package:rakwa/api/api_controllers/list_api_controller.dart';
import 'package:rakwa/api/api_setting/api_setting.dart';
import 'package:rakwa/model/all_categories_model.dart';
import 'package:rakwa/model/all_saved_items_model.dart';
import 'package:rakwa/model/cart.dart';
import 'package:rakwa/model/category_items.dart';
import 'package:rakwa/model/city_model.dart';
import 'package:rakwa/model/country_model.dart';
import 'package:rakwa/model/details_calssified_model.dart';
import 'package:rakwa/model/details_model.dart';
import 'package:rakwa/model/item_details.dart';
import 'package:rakwa/model/menu.dart';
import 'package:rakwa/model/paid_items_model.dart';

import '../api/api_controllers/artical_api_controller.dart';
import '../api/api_controllers/classified_api_controller.dart';
import '../api/api_controllers/details_api_controller.dart';
import '../api/api_controllers/item_api_controller.dart';
import '../api/api_controllers/menu_api_controller.dart';
import '../api/api_controllers/order_api_controller.dart';
import '../api/api_controllers/save_api_controller.dart';
import '../api/api_controllers/search_api_controller.dart';
import '../model/artical_model.dart';
import 'package:http/http.dart' as http;

import '../model/delivery_time.dart';
class AllCartsGetxController extends GetxController{
  static AllCartsGetxController get to => Get.find();
  RxBool isLoading = true.obs;
  RxBool isLoading2 = true.obs;

  var box = GetStorage();
  RxList<DeliveryTime> times = <DeliveryTime>[].obs;

  RxList<Cart> carts = <Cart>[].obs;
  // RxList<CategoryItems> itemsByCategory = <CategoryItems>[].obs;
  // RxList<ItemDetails> itemDetails = <ItemDetails>[].obs;

  bool getFirstData = false;
  bool lastPage = false;
  RxBool loading = false.obs;
  List<String> optionsValues = [];
  List<String> optionsGroupValues = [];
  int page = 1;
  RxInt selectedItem = 0.obs;

  RxInt count = 1.obs;

  @override
  void onInit() {
    super.onInit();
    getCart();



    // getItemsByCategory(categoryId: "67");
    // getItemDetails(itemId: "298");
    // getArticalesPagenation(current_page: page);
  }

  getTimes({required String resturantId})async{
    isLoading.value = true;
    DeliveryTime? time = await OrderApiController().getTime(resturantId: resturantId);
    if(time != null){
      if(time.data!.timeSlots!.isNotEmpty){
        times.add(time);
        print("Times::: ${times.first.data!.timeSlots!.length}");
        isLoading.value = false;
      }
    }else{
      isLoading.value = false;

    }
    isLoading.value = false;
  }
 Future<bool> addToCart({required String quantity, required String resId,required String id,required String variantID, required List<int> extras,required String user_id}) async{
   print("q:: ${quantity}");
   if(carts.isNotEmpty){
     if(carts.first.data!.where((element) => element.itemId == int.parse(id)).isNotEmpty){

       print("we are here");
       int index = carts.first.data!.indexWhere((element) => element.itemId == int.parse(id));
       print("Index:: ${index}");

       if(carts.first.data![index].attributes!.variant == variantID){
         int q = carts.first.data![index].quantity;
         if(int.parse(quantity) != 1 && int.parse(quantity) != q){
           q = int.parse(quantity);
         }else{
           q++;
         }
         print("From if: $q");
         updateCartFromApi(quantity: q, itemId: carts.first.data![index].id.toString());
         // Get.snackbar("نجاح", "هذا المنتج مضاف مسبقاً، تم تحديث الكمية", backgroundColor: Colors.green);
       }else{
         bool success = await CartApiController().addToCart(quantity: quantity, resId: resId,id: id, variantID: variantID, extras: extras, user_id: user_id);
         if(success){

           getCart();
           print("success");
           return success;
         }
       }

       return true;
     }else{
       bool success = await CartApiController().addToCart(quantity: quantity, resId: resId,id: id, variantID: variantID, extras: extras, user_id: user_id);
       if(success){

         getCart();
         print("success");
         return success;
       }
       return success;

     }
   }else{
     bool success = await CartApiController().addToCart(quantity: quantity,resId: resId , id: id, variantID: variantID, extras: extras, user_id: user_id);
     if(success){

       getCart();
       print("success");
       return success;
     }
     return success;
   }


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


  //
  // @override
  // Future<void> onEndScroll() async{
  //   // TODO: implement onEndScroll
  //   print('onEndScroll');
  //   if (!lastPage) {
  //     page += 1;
  //     loading.value = true;
  //     // Get.dialog(Center(child: LinearProgressIndicator()));
  //     await getArticalesPagenation(current_page: page);
  //     // Get.back();
  //     loading.value = false;
  //
  //   } else {
  //     loading.value = false;
  //
  //     Get.snackbar('تنبيه', 'لا يوجد عناصر بعد');
  //   }
  // }
  //
  // @override
  // Future<void> onTopScroll() {
  //   // TODO: implement onTopScroll
  //   throw UnimplementedError();
  // }
// DetailsApiController().getDetails(id: widget.id.toString())

getCart()async{
    isLoading.value = true;
    carts.clear();
  Cart? cart = await CartApiController().getCart();
  if(cart != null){
    if(cart.data!.isNotEmpty){
      carts.add(cart);
      print("Carts::: ${carts.first.data!.length}");
      print( "Res ID:: ${carts.first.data!.first.attributes!.restorantId.toString()}");
        if(carts.isNotEmpty){
          await getTimes(resturantId: carts.first.data!.first.attributes!.restorantId.toString());
          // await getTimes(resturantId: "15");

        }
      isLoading.value = false;
    }
  }else{
    isLoading.value = false;

  }
    isLoading.value = false;
}
  Future<bool> removeCartFromApi({required int productId}) async{
    print("tapped");
    print(productId);
    var url = Uri.parse("${ApiKey.destroyCart}$productId");
    print(url);
    var response = await http.delete(url,);
    print("Status Code: ${response.statusCode}");
    if (response.statusCode == 200) {
      print("Deleted");
      carts.first.data!.removeWhere((element) => element.id == productId);
      //
      if(carts.first.data!.isEmpty){
        carts.clear();
      }
      carts.refresh();
      return true;
    }else{
      return false;
    }

  }
  Future<bool> removeAllCartFromApi() async{
    print("tapped");
    var url = Uri.parse("${ApiKey.destroyAllCart}${box.read("id")}");
    print(url);
    var response = await http.get(url,);
    print("Status Code: ${response.statusCode}");
    if (response.statusCode == 200) {
      print("Deleted");
      carts.clear();
      Get.back();
      carts.refresh();
      return true;
    }else{
      return false;
    }

  }

  Future<bool?> updateCartFromApi({required int quantity,required String itemId}) async{
    var url = Uri.parse("${ApiKey.baseUrl2}${box.read("id")}/update-cart/$itemId");
    print(url);
    print("From UI: ${quantity}");
    var response = await http.post(url, body: {
      "quantity" : quantity.toString()
    });
    print(response.statusCode);
    print("Response::: ${response.body}");

    if (response.statusCode == 200) {
      print("True");
      print(response.body);

      // carts.first.total  = jsonDecode(response.body)['data']['quantity'];
      carts.first.total  = jsonDecode(response.body)['total'];
      carts.first.data!.where((element) => element.id == int.parse(itemId)).first.quantity = int.parse(jsonDecode(response.body)['data']['quantity']);
      carts.refresh();
      // Get.snackbar("نجاح", "المنتج مضاف حاليا، تم تحديث الكمية بنجاح", backgroundColor: Colors.green);

      // print("Total:: ${cart.first.total}");
      // print("QUNATITY:: ${cart.first.cart!.where((element) => element.addproductId == int.parse(productId)).first.quantity}");
      return true;
    }else{
      return false;
    }

  }

}
