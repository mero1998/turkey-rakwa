import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rakwa/api/api_controllers/activites_api_controller.dart';
import 'package:rakwa/api/api_controllers/home_api_controller.dart';
import 'package:rakwa/api/api_controllers/list_api_controller.dart';
import 'package:rakwa/api/api_controllers/subscribtion_api_controller.dart';
import 'package:rakwa/model/ads.dart';
import 'package:rakwa/model/all_categories_model.dart';
import 'package:rakwa/model/all_saved_items_model.dart';
import 'package:rakwa/model/city_model.dart';
import 'package:rakwa/model/country_model.dart';
import 'package:rakwa/model/details_calssified_model.dart';
import 'package:rakwa/model/details_model.dart';
import 'package:rakwa/model/last_activites.dart';
import 'package:rakwa/model/paid_items_model.dart';
import 'package:rakwa/widget/app_dialog.dart';
import 'package:video_player/video_player.dart';

import '../api/api_controllers/artical_api_controller.dart';
import '../api/api_controllers/classified_api_controller.dart';
import '../api/api_controllers/details_api_controller.dart';
import '../api/api_controllers/item_api_controller.dart';
import '../api/api_controllers/save_api_controller.dart';
import '../api/api_controllers/search_api_controller.dart';
import '../model/app_interface.dart';
import '../model/artical_model.dart';

class HomeGetxController extends GetxController{
  static HomeGetxController get to => Get.find();
  RxBool isLoading = true.obs;


  RxList<PaidItemsModel> nestedItems = <PaidItemsModel>[].obs;
  RxList<PaidItemsModel> nestedItemsMore = <PaidItemsModel>[].obs;
  RxList<PaidItemsModel> paidItems = <PaidItemsModel>[].obs;
  RxList<PaidItemsModel> res = <PaidItemsModel>[].obs;
  RxList<PaidItemsModel> popularItems = <PaidItemsModel>[].obs;
  RxList<PaidItemsModel> latestItems = <PaidItemsModel>[].obs;
  RxList<DetailsModel> itemsDetails = <DetailsModel>[].obs;
  RxList<DetailsClassifiedModel> adsDetails = <DetailsClassifiedModel>[].obs;
  RxList<SavedItems> savedItems = <SavedItems>[].obs;
  RxList<SavedItems> savedClassified = <SavedItems>[].obs;
  RxList<int> savedItemsIDS = <int>[].obs;
  RxList<int> days = <int>[].obs;
  RxList<int> savedClassifiedIDS = <int>[].obs;
  RxList<PaidItemsModel> popularClassified = <PaidItemsModel>[].obs;
  RxList<ArticalModel> articales = <ArticalModel>[].obs;
  RxList<LastActivites> activities = <LastActivites>[].obs;
  RxList<Ads> ads = <Ads>[].obs;
  RxList<Ads> popups = <Ads>[].obs;
  bool getFirstData = false;
  bool lastPage = false;
  RxBool loading = false.obs;
  int page = 1;
  RxList<AppInterface> configs = <AppInterface>[].obs;
  VideoPlayerController? videoPlayerController;

  @override
  void onInit() {
    super.onInit();

    getRes();
    getNestedItems();
    getPaidItems();
    getPopularItems();
    getLatestItems();
    getPopularClassified();
    getArticales();
    getSavedItems();
    getSavedClassified();
    getConfig();

    getActivities();
  }


  Future<void> getConfig() async {
    isLoading.value = true;
    AppInterface? appInterface = await HomeApiController().HomeScreenConfig();
    if(appInterface != null){
      configs.add(appInterface);
      isLoading.value = false;

    }
    isLoading.value = false;

  }
  Future<void> getNestedItems() async {
    isLoading.value = true;
    nestedItems.value = await HomeApiController().getNearestItems(type: 1);
    isLoading.value = false;
  }
  Future<void> getAds({required String state}) async {
    isLoading.value = true;
    ads.clear();
    Ads? ad = await HomeApiController().getHomeAds(state: state);

    if(ad != null){
      ads.add(ad);

      SubscriptionApiController().viewAd(adId: ads.first.id.toString(), click: false);
      isLoading.value = false;

    }

    print("Ads ::: ${ads.length}");

    isLoading.value = false;
  }
  Future<void> getPopupAds(BuildContext context, {required String state}) async {
    isLoading.value = true;
    popups.clear();
    Ads? ad = await HomeApiController().getHomeAdsPopup(state: state);
    // AppDialog.showEnterOtpDialog2(context);

    if(ad != null){
      popups.add(ad);

      AppDialog.popupAds(context, link: popups.first.image ?? "", type: popups.first.type ?? "", url: popups.first.url??"", id: popups.first.id.toString());

      SubscriptionApiController().viewAd(adId: popups.first.id.toString(), click: false);

      isLoading.value = false;

    }

    print("Pops:: ${popups.length}");
    isLoading.value = false;
  }
  Future<void> getPaidItems() async {
    isLoading.value = true;
    paidItems.value = await HomeApiController().getPaidItems();
    isLoading.value = false;

  }

  Future<void> getRes() async {
    isLoading.value = true;
    res.value = await HomeApiController().getRes();
    isLoading.value = false;

  }

  Future<void> getPopularItems() async {
    isLoading.value = true;
    popularItems.value = await HomeApiController().getPopularItems();
    isLoading.value = false;
  }

  Future<void> getLatestItems() async {
    isLoading.value = true;
    latestItems.value = await HomeApiController().getLatestItems();
    isLoading.value = false;
  }
  Future<void> getPopularClassified() async {
    isLoading.value = true;
    popularClassified.value = await HomeApiController().getPopularClassified();
    isLoading.value = false;
  }

  Future<void> getArticales() async {
    isLoading.value = true;
    articales.value = await ArticalApiController().getArticals();
    isLoading.value = false;
  }

  Future<void> getActivities() async {
    isLoading.value = true;
    activities.value = await ActivitiesApiController().getActivities();
    isLoading.value = false;
  }

  // SaveApiController().getSaveClassified()
  Future<void> getSavedItems() async {

    print("From get Saved ");
    // isLoading.value = true;
    savedItemsIDS.clear();
    savedItems.value = await SaveApiController().getSaveItems();
    for(int i = 0; i < savedItems.length; i++){
      savedItemsIDS.add(savedItems[i].id!);
    }
    print("Saved::: ${savedItemsIDS}");
  }
  Future<void> getSavedClassified() async {

    print("from get saved Class");
    savedClassifiedIDS.clear();
    savedClassified.value = await SaveApiController().getSaveClassified();
    for(int i = 0; i < savedClassified.length; i++){
      savedClassifiedIDS.add(savedClassified[i].id!);
    }

  }

  Future<void> getDetails(String id) async {
    isLoading.value = true;
    // itemsDetails.clear();
    days.clear();
    DetailsModel? detailsModel = await DetailsApiController().getDetails(id: id);
    if(detailsModel != null) {
      for (int i = 0; i < detailsModel.item!.itemHours!.length; i++) {
        if(!days.contains(detailsModel.item!.itemHours![i].itemHourDayOfWeek)){
          days.add(detailsModel.item!.itemHours![i].itemHourDayOfWeek);
        }else{
          detailsModel.item!.itemHours!.removeAt(i);

        }
        // print(detailsModel.item!.itemHours![i].itemHourDayOfWeek);

        // for(int m = 0; m < days.length; m++){
        //   if(days[m] != detailsModel.item!.itemHours![i].itemHourDayOfWeek){
        //     detailsModel.item!.itemHours!.removeAt(i);
        //   }
        // }
      }
      // print("Days:: ${days}");
      // print("Days:: ${ detailsModel.item!.itemHours!}");

      // detailsModel.item!.itemHours!.removeRange(
      //     7, detailsModel.item!.itemHours!.length);

      print(detailsModel.item!.itemHours!.length);
      itemsDetails.add(detailsModel);
    }
    isLoading.value = false;
  }

  Future<void> getDetailsAds(String id) async {
    isLoading.value = true;
    // itemsDetails.clear();
    DetailsClassifiedModel? detailsModel = await DetailsApiController().getClassifiedDetails(id: id);
    if(detailsModel != null){
      adsDetails.add(detailsModel);
    }
    isLoading.value = false;
  }


  // DetailsApiController().getDetails(id: widget.id.toString())
}
