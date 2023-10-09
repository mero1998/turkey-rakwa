import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rakwa/api/api_controllers/home_api_controller.dart';
import 'package:rakwa/api/api_controllers/list_api_controller.dart';
import 'package:rakwa/model/all_categories_model.dart';
import 'package:rakwa/model/all_saved_items_model.dart';
import 'package:rakwa/model/city_model.dart';
import 'package:rakwa/model/country_model.dart';
import 'package:rakwa/model/details_calssified_model.dart';
import 'package:rakwa/model/details_model.dart';
import 'package:rakwa/model/paid_items_model.dart';

import '../api/api_controllers/artical_api_controller.dart';
import '../api/api_controllers/classified_api_controller.dart';
import '../api/api_controllers/details_api_controller.dart';
import '../api/api_controllers/item_api_controller.dart';
import '../api/api_controllers/save_api_controller.dart';
import '../api/api_controllers/search_api_controller.dart';
import '../model/artical_model.dart';

class AllResGetxController extends GetxController  with StateMixin<List<PaidItemsModel>>, ScrollMixin{
  static AllResGetxController get to => Get.find();
  RxBool isLoading = true.obs;

  RxList<PaidItemsModel> resMore = <PaidItemsModel>[].obs;
  // RxList<PaidItemsModel> bakeriesMore = <PaidItemsModel>[].obs;
  // RxList<PaidItemsModel> candiesMore = <PaidItemsModel>[].obs;
  // RxList<PaidItemsModel> supermarketsMore = <PaidItemsModel>[].obs;

  RxString category  = "".obs;
  bool getFirstData = false;
  bool lastPage = false;
  RxBool loading = false.obs;
  int page = 1;

  @override
  void onInit() {
    super.onInit();

    getResWithPagenation(current_page: 1);
  }


  Future<void> getResWithPagenation({required int current_page,}) async {
    List<PaidItemsModel> items =   await HomeApiController().getResWithPagenation(current_page:current_page);
    final bool emptyRepositories = items.isEmpty;
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

      resMore.addAll(items);

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
  Future<void> getSupermarketsWithPagenation({required int current_page,}) async {
    List<PaidItemsModel> items =   await HomeApiController().getSupermarketWithPagenation(current_page:current_page);
    final bool emptyRepositories = items.isEmpty;
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

      resMore.addAll(items);

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
  Future<void> getBakeriesWithPagenation({required int current_page,}) async {
    List<PaidItemsModel> items =   await HomeApiController().getBakeriesWithPagenation(current_page:current_page);
    final bool emptyRepositories = items.isEmpty;
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

      resMore.addAll(items);

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
  Future<void> getCandiesWithPagenation({required int current_page,}) async {
    List<PaidItemsModel> items =   await HomeApiController().getCandiesWithPagenation(current_page:current_page);
    final bool emptyRepositories = items.isEmpty;
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

      resMore.addAll(items);

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

  Future<void> getMeatWithPagenation({required int current_page,}) async {
    List<PaidItemsModel> items =   await HomeApiController().getMeatsWithPagenation(current_page:current_page);
    final bool emptyRepositories = items.isEmpty;
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

      resMore.addAll(items);

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
  // SaveApiController().getSaveClassified()



  @override
  Future<void> onEndScroll() async{
    // TODO: implement onEndScroll
    print('onEndScroll');
    print(page);

    if (!lastPage) {
      page += 1;
      loading.value = true;
      //resMore
      // bakeriesMore
      // candiesMore
      // supermarketsMore
      // Get.dialog(Center(child: LinearProgressIndicator()));
      print(page);
      if(category.value == "bakeries"){
       await getBakeriesWithPagenation(current_page: page);
      }else if(category.value == "candies"){
        await getCandiesWithPagenation(current_page: page,);

      }else if(category.value == "supermarkets"){
        await getSupermarketsWithPagenation(current_page: page,);

      }else{
        await getResWithPagenation(current_page: page,);

      }
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
}
