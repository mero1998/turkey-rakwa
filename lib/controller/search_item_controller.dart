import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rakwa/api/api_controllers/list_api_controller.dart';
import 'package:rakwa/model/all_categories_model.dart';
import 'package:rakwa/model/city_model.dart';
import 'package:rakwa/model/country_model.dart';
import 'package:rakwa/model/paid_items_model.dart';

import '../api/api_controllers/classified_api_controller.dart';
import '../api/api_controllers/item_api_controller.dart';
import '../api/api_controllers/search_api_controller.dart';

class SearchItemController extends GetxController with StateMixin<List<PaidItemsModel>>, ScrollMixin{
  static SearchItemController get to => Get.find();

  RxBool isItem = true.obs;
  RxBool isLoading = true.obs;
  RxInt cityID = 0.obs;
  RxString categoryID = "".obs;
  RxInt stateID = 0.obs;
  RxInt subCategoryID = 0.obs;
  RxInt categoryClssifeidID = 0.obs;
  bool getFirstData = false;
  bool lastPage = false;
  RxBool loading = false.obs;
  int page = 1;

  String cityId2 = "";
  String stateId2 = "";
      String categoryId2 = "";
  String   subCategoryId2 = "";
  String query2 = "";
 String classifiedcategories2 = "";
  late TextEditingController stateController;
  late TextEditingController cityController;
  late TextEditingController categoryController;
  late TextEditingController subCategoryController;
  @override
  void onInit() {
    super.onInit();
    getCategory();
    getClassifiedCategory();
    selectedClassified.value = classified.first;
    selectedClassifiedID.value = "1";
    stateController = TextEditingController();
    cityController = TextEditingController();
    categoryController = TextEditingController();
    subCategoryController = TextEditingController();

  }

  RxList<AllCategoriesModel> category = <AllCategoriesModel>[].obs;
  RxList<AllCategoriesModel> clssifiedCategory = <AllCategoriesModel>[].obs;
  RxList<AllCategoriesModel> subCategory = <AllCategoriesModel>[].obs;

  RxList<PaidItemsModel> searchList = <PaidItemsModel>[].obs;
  List<String> classified = [
    "الأحدث",
    "الأقدم",
    "الأعلى تقيماً",
    "الأقل تقيماً",
    "الأقرب لديك",
  ];

  RxString selectedClassified = "".obs;
  RxString selectedClassifiedID = "".obs;

  Future<void> getCategory() async {
    category.value = await ListApiController().getCategory();
  }

  Future<void> getClassifiedCategory() async {
    clssifiedCategory.value = await ListApiController().getClassifiedCategory();
  }

  Future<void> getSubCategory({required String id}) async {
    isLoading.value = true;

    subCategory.value = await ListApiController().getSubCategory(id: id);
    isLoading.value = false;
    // if (data.isNotEmpty) {
    //   subCategory.addAll(data);
    //   isLoading.value = false;
    //
    // } else {
    //
    //   subCategory .value= [];
    //   isLoading.value = false;
    //
    //   // itemSubCategryStatus = 3;
    // }
  }
   search({
    required String cityId,
    required String stateId,
    required String category,
    required String classifiedcategories,
     String? query,
    required bool isItem}) async{
    print("Query Search:: ${query}");


    isLoading.value = true;


    searchList.value = await SearchApiController().search(
        isItem: isItem,
        searchQuery: query,
        stateId: stateId,
        category: category,
        cityId: cityId,
        classifiedcategories: classifiedcategories,
        sort:selectedClassifiedID.value,
      query: query,
    );
    isLoading.value = false;

  }


   searchItem( {required String cityId,
    required String stateId,
    required String categoryId,
     String? subCategoryId,
    required String query,
    required String classifiedcategories,
 required int current_page}) async{
    isLoading.value = true;
    page = current_page;

    //  loading.value  = true;
     searchList.clear();

    cityId2 = cityId;
    stateId2 = stateId;
    categoryId2 =  categoryId;
    if(subCategoryId != null){
      subCategoryId2 = subCategoryId;
    }
        query2 = query;
        classifiedcategories2 =classifiedcategories;
    List<PaidItemsModel> list = [];
    list.clear();
    list = await ItemApiController().searchItem(
        cityId: cityId,
        stateId: stateId,
        categoryId: categoryId,
        classifiedcategories: classifiedcategories,
        subCategoryId:subCategoryId,
        sort: selectedClassifiedID.value,
      query: query,
      current_page: current_page
    );
    isLoading.value = false;
     // loading.value  = true;
    final bool emptyRepositories = list.isEmpty;
    if (!getFirstData && emptyRepositories) {
      isLoading.value = false;

      // change(null, status: RxStatus.empty());
    } else if (getFirstData && emptyRepositories) {
      lastPage = true;
      isLoading.value = false;

    } else {
      isLoading.value = true;
      lastPage = false;

      getFirstData = true;

      // for(int i = 0; i < nestedItemsMore.length; i++){
      //   for(int m = 0; m < result.length; m++){
      //     if(nestedItemsMore)

      // if(!nestedItemsMore.contains(result)){

      searchList.value = list;

      // }

    }
    // }
    isLoading.value = false;
  }


  searchClassified({
    required String cityId,
    required String stateId,
    required String category,
    required String query,
    required String classifiedcategories,
   required int current_page
    })async{
    print("page:: ${current_page}");
    page = current_page;
    isLoading.value = true;
    // searchList.clear();

    cityId2 = cityId;
    stateId2 = stateId;
    categoryId2 =  category;
    if(category != null){
      subCategoryId2 = category;
    }
    query2 = query;
    classifiedcategories2 =classifiedcategories;
    List<PaidItemsModel> list = [];
   list  = await ClassifiedApiController().searchClassified(
        cityId: cityId,
        stateId: stateId,
        category: category,
        classifiedcategories: category,
        query: query,
        sort: selectedClassifiedID.value,
      current_page: current_page
    );
    final bool emptyRepositories = list.isEmpty;
    if (!getFirstData && emptyRepositories) {
      isLoading.value = false;

      // change(null, status: RxStatus.empty());
    } else if (getFirstData && emptyRepositories) {
      lastPage = true;
      isLoading.value = false;

    } else {
      isLoading.value = true;
      lastPage = false;
      getFirstData = true;

      // for(int i = 0; i < nestedItemsMore.length; i++){
      //   for(int m = 0; m < result.length; m++){
      //     if(nestedItemsMore)

      // if(!nestedItemsMore.contains(result)){

      searchList.value = list;

      // }

    }
    // }
    isLoading.value = false;

  }

  @override
  Future<void> onEndScroll()async {
    // TODO: implement onEndScroll


    print("from scroll");
    if (!lastPage) {
      page += 1;
      loading.value = true;
      // Get.dialog(Center(child: LinearProgressIndicator()));
      // await searchItem(current_page: page, cityId: cityId2, stateId: stateId2, categoryId: categoryId2, query: query2, classifiedcategories: classifiedcategories2);
      // Get.back();
      // await ItemApiController().searchItem(
      //     cityId: cityId2,
      //     stateId: stateId2,
      //     categoryId: categoryId2,
      //     classifiedcategories: classifiedcategories2,
      //     subCategoryId:subCategoryId2,
      //     sort: selectedClassifiedID.value,
      //     query: query2,
      //     current_page: page
      // );
      List<PaidItemsModel> list = [];
      if(isItem.value){

        list  = await ItemApiController().searchItem(
            cityId: cityId2,
            stateId: stateId2,
            categoryId: categoryId2,
            classifiedcategories: classifiedcategories2,
            subCategoryId:subCategoryId2,
            sort: selectedClassifiedID.value,
            query: query2,
            current_page: page
        );
        isLoading.value = false;
      }else{

  list =   await ClassifiedApiController().searchClassified(
            cityId: cityId2,
            stateId: stateId2,
            category: categoryId2,
            classifiedcategories: categoryId2,
            query: query2,
            sort: selectedClassifiedID.value,
          current_page: page
        );
      }

      // loading.value  = true;




      final bool emptyRepositories = list.isEmpty;
      if (!getFirstData && emptyRepositories) {
        isLoading.value = false;

        // change(null, status: RxStatus.empty());
      } else if (getFirstData && emptyRepositories) {
        lastPage = true;
        isLoading.value = false;

      } else {
        isLoading.value = false;
        getFirstData = true;
        searchList.addAll(list);

        // for(int i = 0; i < nestedItemsMore.length; i++){
        //   for(int m = 0; m < result.length; m++){
        //     if(nestedItemsMore)

        // if(!nestedItemsMore.contains(result)){
        // }

      }
      isLoading.value = false;

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
