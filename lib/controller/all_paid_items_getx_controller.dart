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

class AllPaidItemsGetxController extends GetxController  with StateMixin<List<PaidItemsModel>>, ScrollMixin{
  static AllPaidItemsGetxController get to => Get.find();
  RxBool isLoading = true.obs;

  RxList<PaidItemsModel> paidItemsMore = <PaidItemsModel>[].obs;

  bool getFirstData = false;
  bool lastPage = false;
  RxBool loading = false.obs;
  int page = 1;

  @override
  void onInit() {
    super.onInit();
    getPaidItemsPagenation(current_page: page);
  }


  Future<void> getPaidItemsPagenation({required int current_page}) async {
    List<PaidItemsModel> items =   await HomeApiController().getPaidItemsWithPagenation(current_page:current_page );
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

      paidItemsMore.addAll(items);

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
    if (!lastPage) {
      page += 1;
      loading.value = true;
      // Get.dialog(Center(child: LinearProgressIndicator()));
      await getPaidItemsPagenation(current_page: page);
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
