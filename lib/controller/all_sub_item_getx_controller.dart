import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rakwa/Core/utils/extensions.dart';
import 'package:rakwa/api/api_controllers/classified_api_controller.dart';
import 'package:rakwa/api/api_controllers/item_api_controller.dart';
import 'package:rakwa/api/api_controllers/list_api_controller.dart';
import 'package:rakwa/model/all_categories_model.dart';
import 'package:rakwa/model/classified_with_category.dart';
import 'package:rakwa/model/item_model.dart';
import 'package:rakwa/model/item_with_category.dart';
import 'package:rakwa/widget/app_dialog.dart';

import '../api/api_controllers/subscribtion_api_controller.dart';
import '../model/ads.dart';
import '../model/ads_model.dart';
import '../model/items_category_by_location.dart';

class AllSubItemGetxController extends GetxController with StateMixin<List<ItemsCategoryByLocation>>, ScrollMixin {
  RxList<ItemsCategoryByLocation> subItemWithCategory = <ItemsCategoryByLocation>[].obs;
  List<AllCategoriesModel> subCategory = [];
  List<AllCategoriesModel> classifeidSubCategory = [];
  List<AdsModel> classifiedWithCategory = [];
  int classifiedStatus = 1;
  int itemStatus = 1;
  int classifiedSubCategryStatus = 1;
  int itemSubCategryStatus = 1;

  RxString id = "".obs;
  RxBool isLoading = true.obs;
  List<Marker> marker = [];
  List<Marker> markerClassified = [];

  List<Marker> list = [];
  List<Marker> listClassifeid = [];

  RxList<Ads> ads = <Ads>[].obs;
  RxList<Ads> popups = <Ads>[].obs;
  bool getFirstData = false;
  bool lastPage = false;
  RxBool loading = false.obs;
  int page = 1;

  RxBool visiableItems = true.obs;
  addMarkers() {
    for (int i = 0; i < subItemWithCategory.length; i++) {
      list.add(Marker(
          markerId: MarkerId(
            i.toString(),
          ),
          position: LatLng(
              double.parse(
                  subItemWithCategory[i].itemLat ?? '41.0082'),
              double.parse(
                  subItemWithCategory[i].itemLng ?? '28.9784')),
          infoWindow: InfoWindow(
              title:
              subItemWithCategory[i].itemAddress ?? 'İstanbul')));
    }
    marker.addAll(list);

    print("Marker:: ${marker}");
    update();
  }


  Future<void> getAds({required String state, required String categoryId}) async {
   ads.clear();
    // isLoading.value = true;
   itemSubCategryStatus = 1;
   update();
    Ads? ad = await ItemApiController().getSectionAds(state: state, categoryId: categoryId);

    if(ad != null){
      ads.add(ad);

      SubscriptionApiController().viewAd(adId: ads.first.id.toString(), click: false);
      itemSubCategryStatus = 2;
      update();
    }else{
      itemSubCategryStatus = 3;
    update();
    }


    print("Ads ::: ${ads.length}");

  }
  Future<void> getPopupAds(BuildContext context,{required String state,required String categoryId}) async {
   popups.clear();
    isLoading.value = true;
    Ads? ad = await ItemApiController().getSectionAdsPopup(state: state,categoryId: categoryId);
    // AppDialog.showEnterOtpDialog2(context);

    if(ad != null){
      popups.add(ad);
      isLoading.value = false;
      itemSubCategryStatus = 2;
      update();

      SubscriptionApiController().viewAd(adId: popups.first.id.toString(), click: false);

      AppDialog.popupAds(context, link: popups.first.image ??"", type: popups.first.type ?? "",url: popups.first.url ?? "", id: popups.first.id.toString());
    }
   itemSubCategryStatus = 3;
   update();
    isLoading.value = false;
  }
  addClassifiedMarkers() {
    for (int i = 0; i <= classifiedWithCategory.length - 1; i++) {
      listClassifeid.add(Marker(
          markerId: MarkerId(
            i.toString(),
          ),
          position: LatLng(
              double.parse(
                  classifiedWithCategory.first.classifiedCategory![i].itemLat ?? '41.0082'),
              double.parse(
                  classifiedWithCategory.first.classifiedCategory![i].itemLng ?? '28.9784')),
          infoWindow: InfoWindow(
              title: classifiedWithCategory.first.classifiedCategory![i].itemAddress ??
                  'İstanbul')));
    }
    markerClassified.addAll(listClassifeid);
    update();
  }

  Future<void> getItem({required String id, required int current_page}) async {

    this.id.value = id;
    // itemWithCategory = [];
    marker = [];
    itemStatus = 1;
    page = current_page;
    List<ItemsCategoryByLocation> items = await ItemApiController().getItemWithCategory(id: id,cuttrent_page: current_page.toString());
    // if (items.isNotEmpty) {
      //   // itemWithCategory.add(data!.category!.data!);
      //   classifiedStatus = 2;
      // addMarkers();
    // }
    // } else {
    //   // itemWithCategory = [];
    //   itemStatus = 3;
    //
    // }

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

        subItemWithCategory.addAll(items);
      if(subItemWithCategory.isNotEmpty){
        addMarkers();
      }
      // }

    }
    update();
  }

  Future<void> getSubCategory({required String id}) async {
    subCategory = [];
    itemSubCategryStatus = 1;
    update();
    var data = await ListApiController().getSubCategory(id: id);
    if (data.isNotEmpty) {
      subCategory.addAll(data);
      itemSubCategryStatus = 2;
      update();

    } else {
      subCategory = [];
      itemSubCategryStatus = 3;
update();
    }

    update();
  }

  Future<void> getClassifiedSubCategory({required int id}) async {
    classifeidSubCategory = [];
    classifiedSubCategryStatus = 1;
    update();
    var data = await ListApiController().getClassifiedSubCategory(id: id);
    if (data.isNotEmpty) {
      classifeidSubCategory.addAll(data);
      classifiedSubCategryStatus = 2;
      update();
    } else {
      classifeidSubCategory = [];
      classifiedSubCategryStatus = 3;
      update();

    }

    update();
  }

  Future<void> getClassified({required String id}) async {
    classifiedWithCategory = [];
    // classifeidSubCategory = [];
    markerClassified = [];

    classifiedStatus = 1;
    print("from get Classified::::${id}");
    AdsModel? data = await ClassifiedApiController().getClassifedWithCategory(id: id);


    // printDM("data[0].allItems classified-categorys is => ${data!.classifiedCategory!.first.id}");


    if (data!.classifiedCategory!.isNotEmpty) {
      classifiedWithCategory.add(data);
      print("Classs ${classifiedWithCategory.first.classifiedCategory!.first.id}");
      // classifiedWithCategory.addAll(data);
      classifiedStatus = 2;
      addClassifiedMarkers();
    } else {
      classifiedWithCategory = [];
      classifiedStatus = 3;
    }


    print("List::::: ${classifiedWithCategory}");


    update();
  }


  @override
  Future<void> onEndScroll() async{
    // TODO: implement onEndScroll
    print('onEndScroll');
    if (!lastPage) {
      page += 1;
      loading.value = true;
      // Get.dialog(Center(child: LinearProgressIndicator()));
      await getItem(id: id.value,current_page: page);
      // Get.back();
      visiableItems.value = false;
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
}
