import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:rakwa/api/api_controllers/home_api_controller.dart';
import 'package:rakwa/api/api_controllers/list_api_controller.dart';
import 'package:rakwa/model/all_categories_model.dart';
import 'package:rakwa/model/all_saved_items_model.dart';
import 'package:rakwa/model/categories.dart';
import 'package:rakwa/model/category_items.dart';
import 'package:rakwa/model/city_model.dart';
import 'package:rakwa/model/country_model.dart';
import 'package:rakwa/model/details_calssified_model.dart';
import 'package:rakwa/model/details_model.dart';
import 'package:rakwa/model/events.dart';
import 'package:rakwa/model/item_details.dart';
import 'package:rakwa/model/menu.dart';
import 'package:rakwa/model/paid_items_model.dart';
import 'package:rakwa/model/res_details.dart' as res;

import '../api/api_controllers/artical_api_controller.dart';
import '../api/api_controllers/classified_api_controller.dart';
import '../api/api_controllers/details_api_controller.dart';
import '../api/api_controllers/item_api_controller.dart';
import '../api/api_controllers/menu_api_controller.dart';
import '../api/api_controllers/save_api_controller.dart';
import '../api/api_controllers/search_api_controller.dart';
import '../model/artical_model.dart';
import '../screens/menu/menu_screen.dart';
import '../widget/TextFields/text_field_default.dart';
import '../widget/my_text_field.dart';

class AllMenusGetxController extends GetxController  with StateMixin<List<CategoryItems>>,ScrollMixin{
  static AllMenusGetxController get to => Get.find();
  RxBool isLoading = true.obs;
  RxBool isLoading2 = true.obs;

  RxList<MenuItems> menus = <MenuItems>[].obs;
  RxList<CategoryItems> itemsByCategory = <CategoryItems>[].obs;
  RxList<ItemDetails> itemDetails = <ItemDetails>[].obs;
  RxList<Categories> categories = <Categories>[].obs;
  RxList<res.ResDetails> resDetails = <res.ResDetails>[].obs;
  RxList<Events> events = <Events>[].obs;
  RxList<String> startBookingDates = <String>[].obs;
  RxList<String> endBookingDates = <String>[].obs;

  RxInt price = 0.obs;
  RxString fromTime = "08:30".obs;
  RxString toTime = "10:00".obs;
  RxString fromDate = "".obs;
  RxString toDate = "".obs;

  RxBool selectable = true.obs;
  RxBool back = false.obs;
  bool getFirstData = false;
  bool lastPage = false;
  RxBool loading = false.obs;
  List<String> optionsValues = [];
  List<String> optionsGroupValues = [];
  int page = 1;
  RxInt selectedItem = 0.obs;
  RxInt selectedItemID = 0.obs;

  RxList<int> optionsCount = <int>[].obs;
  RxList<String> optionsName = <String>[].obs;
  // RxList<TextEditingController> optionsController = <TextEditingController>[].obs;
  RxList<String> options = <String>[].obs;
  RxList<String> options2 = <String>[].obs;
  RxList<String> optionsIds = <String>[].obs;
  RxList<String> verIds = <String>[].obs;
  RxList<List<String>> options3 = <List<String>>[].obs;
  RxString selectedValue = "".obs;
  RxList<String> varents = <String>[].obs;
  RxList<String> varents2 = <String>[].obs;
  RxList<String> extras = <String>[].obs;
  RxList<String> extras2 = <String>[].obs;
  RxList<String> extrasIds = <String>[].obs;
  RxList<TextEditingController> controllers = <TextEditingController>[].obs;
  RxList<TextFieldDefault> textFields = <TextFieldDefault>[].obs;
  // RxMap<String, String> map = <String, String>{}.obs;
  RxInt count = 1.obs;
  RxInt indexOptions = (-1).obs;
  RxInt indexVarents = (-1).obs;
  RxInt indexExtra = (-1).obs;
  RxBool editOption = false.obs;
  RxBool editVarents = false.obs;
  RxBool editExtra = false.obs;
  Categories? selectedCategory;
  RxString map = "".obs;
  RxInt vartiantId = (-1).obs;
  RxInt userId = (-1).obs;
  RxInt check = 0.obs;

  RxString title = "".obs;
  RxInt filterState = 0.obs;
  RxInt filterCity = 0.obs;

  RxBool filter = false.obs;
  RxInt type = 0.obs;

  RxList<String> list= <String>[].obs;
 String selectedPayment = "";
  @override
  void onInit() {
    super.onInit();
    // widgets.clear();
    // getItemsByCategory(categoryId: '', current_page: 1);
    // getAllItems();
    // getItemDetails(itemId: "298");
    // getArticalesPagenation(current_page: page);

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



  // @override
  // Future<void> onEndScroll() async{
  //   // TODO: implement onEndScroll
  //   print('onEndScroll');
  //   // if(selectedItem != 0){
  //     if (!lastPage) {
  //       page += 1;
  //       loading.value = true;
  //       List<CategoryItems> items = [];
  //       // Get.dialog(Center(child: LinearProgressIndicator()));
  //      // if(selectedItem.value == -1){
  //      //
  //      //   for(int i = 0; i <  AllMenusGetxController.to.menus.length; i++){
  //      //     if( AllMenusGetxController.to.menus[i].items!.isNotEmpty){
  //      //       for(int o = 0; o <  AllMenusGetxController.to.menus[i].items!.length; o++ ) {
  //      //         CategoryItems item = CategoryItems();
  //      //         item.id = AllMenusGetxController.to.menus[i].items![o].id ?? 0;
  //      //         item.name = AllMenusGetxController.to.menus[i].items![o].name ?? "";
  //      //         item.description =
  //      //             AllMenusGetxController.to.menus[i].items![o].description ?? "";
  //      //         item.logom =
  //      //             AllMenusGetxController.to.menus[i].items![o].logom ?? "";
  //      //         item.price =
  //      //             AllMenusGetxController.to.menus[i].items![o].price ?? 0;
  //      //         AllMenusGetxController.to.itemsByCategory.add(item);
  //      //       }
  //      //
  //      //       print("Len::: ${AllMenusGetxController.to.itemsByCategory.length}");
  //      //       AllMenusGetxController.to.isLoading.value= false;
  //      //
  //      //     }
  //      //   }
  //      // }else{
  //      items = await MenuApiController().getItemsByCategory(categoryId: selectedItemID.value.toString(), current_page: page);
  //      // }
  //       final bool emptyRepositories = items.isEmpty;
  //       if (!getFirstData && emptyRepositories) {
  //
  //         // change(null, status: RxStatus.empty());
  //       } else if (getFirstData && emptyRepositories) {
  //         lastPage = true;
  //
  //       } else {
  //         getFirstData = true;
  //
  //         // for(int i = 0; i < nestedItemsMore.length; i++){
  //         //   for(int m = 0; m < result.length; m++){
  //         //     if(nestedItemsMore)
  //
  //         // if(!nestedItemsMore.contains(result)){
  //
  //         itemsByCategory.addAll(items);
  //       }
  //         // Get.back();
  //       loading.value = false;
  //
  //     } else {
  //       loading.value = false;
  //
  //       Get.snackbar('تنبيه', 'لا يوجد عناصر بعد');
  //     }
  //   // }
  //
  // }
  Future<void> onEndScroll() async{
    // TODO: implement onEndScroll
    print('onEndScroll');
    // if(selectedItem != 0){
      if (!lastPage) {
        page += 1;
        loading.value = true;
        List<CategoryItems> items = [];
        // getMenus(resturentName: "246", current_page: page);
        // Get.dialog(Center(child: LinearProgressIndicator()));
       // if(selectedItem.value == -1){
       //
       //   for(int i = 0; i <  AllMenusGetxController.to.menus.length; i++){
       //     if( AllMenusGetxController.to.menus[i].items!.isNotEmpty){
       //       for(int o = 0; o <  AllMenusGetxController.to.menus[i].items!.length; o++ ) {
       //         CategoryItems item = CategoryItems();
       //         item.id = AllMenusGetxController.to.menus[i].items![o].id ?? 0;
       //         item.name = AllMenusGetxController.to.menus[i].items![o].name ?? "";
       //         item.description =
       //             AllMenusGetxController.to.menus[i].items![o].description ?? "";
       //         item.logom =
       //             AllMenusGetxController.to.menus[i].items![o].logom ?? "";
       //         item.price =
       //             AllMenusGetxController.to.menus[i].items![o].price ?? 0;
       //         AllMenusGetxController.to.itemsByCategory.add(item);
       //       }
       //
       //       print("Len::: ${AllMenusGetxController.to.itemsByCategory.length}");
       //       AllMenusGetxController.to.isLoading.value= false;
       //
       //     }
       //   }
       // }else{
       //  getMenus(resturentName: resId, current_page: current_page);
       // }

        items = await MenuApiController().getItemsByCategory(categoryId: selectedItemID.value.toString(), current_page: page);

        final bool emptyRepositories = items.isEmpty;
        if (!getFirstData && emptyRepositories) {

          // change(null, status: RxStatus.empty());
        } else if (getFirstData && emptyRepositories) {
          lastPage = true;

        } else {
          getFirstData = true;

          // for(int i = 0; i < nestedItemsMore.length; i++){
          //   for(int m = 0; m < result.length; m++){
          //     if(nestedItemsMore)

          // if(!nestedItemsMore.contains(result)){

          itemsByCategory.addAll(items);
        }
          // Get.back();
        loading.value = false;

      } else {
        loading.value = false;

        // Get.snackbar('تنبيه', 'لا يوجد عناصر بعد');
      }
    // }

  }

  @override
  Future<void> onTopScroll() {
    // TODO: implement onTopScroll
    throw UnimplementedError();
  }
// DetailsApiController().getDetails(id: widget.id.toString())

getMenus({required String resturentName, required int current_page})async{
    // isLoading2.value = true;
    page = current_page;
   menus.value = await MenuApiController().getMenu(resturantName: resturentName,current_page: page);
   // print("Items:::${menus.first.items}");
   //  MenuItems item = MenuItems();
   //  item.name = "كل التصنيفات";
   //  item.items = [];
   //  AllMenusGetxController.to.menus.insert(0,item);

    isLoading2.value = false;
}
getAllItems()async{
  isLoading.value = true;
  print("we are here from get all");
    itemsByCategory.clear();

      for(int i = 0; i < categories.length; i++){
        List<CategoryItems>  items = await MenuApiController().getItemsByCategory(categoryId: categories[i].id.toString(), current_page: 1);
        itemsByCategory.addAll(items);

        if(i == 1){
          isLoading.value = false;
        }
        if(selectedItem.value != -1){
          itemsByCategory.clear();
          break;
        }

        if(back.value){
          itemsByCategory.clear();
          break;
        }
      }

  print("LenL::: ${itemsByCategory.length}");
  print("LenL::: ${check.value}");

  // itemsByCategory.removeAt(0);


  isLoading.value = false;
}
  getItemsByCategory({required String categoryId,required int current_page})async{
    isLoading.value = true;
    page = current_page;
    itemsByCategory.clear();
  List<CategoryItems> items = await MenuApiController().getItemsByCategory(categoryId: categoryId, current_page: page);
  // print(itemsByCategory.first.description);
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
      lastPage = false;
      // for(int i = 0; i < nestedItemsMore.length; i++){
      //   for(int m = 0; m < result.length; m++){
      //     if(nestedItemsMore)

      // if(!nestedItemsMore.contains(result)){

      itemsByCategory.addAll(items);

      // }

      // if(itemsByCategory.isEmpty) {
      //   check.value = 1;
      // }else{
      //   check.value = 0;
      //
      // }

    }
  isLoading.value = false;

  }
  getMenuResCategories({required String resId})async{
    isLoading2.value = true;
    categories.clear();
  categories.value = await MenuApiController().getMenuResturentCategories(resturentId: resId,);

  if(categories.isNotEmpty){
    getAllItems();
    isLoading2.value = false;

  }
    isLoading2.value = false;

  }

  getItemDetails({required String itemId})async{
    isLoading.value = true;

    print("ID::: ${itemId}");
    // map.clear();
    vartiantId.value = -1;
    itemDetails.clear();
    count.value = 1;
    list.clear();
  ItemDetails? details = await MenuApiController().getItemDetails(itemId: itemId);
    endBookingDates.clear();
    if(details != null){
      itemDetails.add(details);
      itemDetails.first.data!.active_from != null ?
      title.value = "تفاصيل الحجز": title.value = "تفاصيل الوجبة";


      print("Vat :::${AllMenusGetxController.to.itemDetails.first.vat.toString()}");
      price.value = int.parse(AllMenusGetxController.to.itemDetails.first.data!.price.toString());

      if(itemDetails.first.data!.active_from != null){
        AllMenusGetxController.to.list.add( "دفع 30% من المبلغ ${((AllMenusGetxController.to.price.value ) * 0.30).toInt()} \$ ",);
        // AllMenusGetxController.to.list.add(    "دفع المبلغ كامل ${ (( (AllMenusGetxController.to.price.value ) )).toInt()} ليرة ");
        AllMenusGetxController.to.selectedPayment =   AllMenusGetxController.to.list.first;
      }


      optionsValues.clear();
      optionsGroupValues.clear();
      userId.value =itemDetails.first.userId ?? -1;
     optionsValues = List.generate(itemDetails.first.data!.options!.length, (index) => itemDetails.first.data!.options![index].options!.split(',').first);


     print("Values::: ${optionsValues}");


      if(AllMenusGetxController.to.itemDetails.first.data!.options!.isNotEmpty){
        if(AllMenusGetxController.to.itemDetails.first.data!.variants!.isNotEmpty){
          AllMenusGetxController.to.itemDetails.first.data!.price  = AllMenusGetxController.to.itemDetails.first.data!.variants!.first.price;
        }
        for(int i = 0; i < AllMenusGetxController.to.itemDetails.first.data!.options!.length; i++){
          print(AllMenusGetxController.to.itemDetails.first.data!.options![i].options);
          optionsGroupValues.addAll(itemDetails.first.data!.options![i].options!.split(',').toList());
        }

        // print("Map:: ${map}");
        print("Map:: ${AllMenusGetxController.to.itemDetails.first.data!.variants!.first.options}");
       // for(int m = 0; m <AllMenusGetxController.to.itemDetails.first.data!.variants!.length; m++){
         // print(jsonDecode(AllMenusGetxController.to.itemDetails.first.data!.variants![m].options!));
         map.value = AllMenusGetxController.to.itemDetails.first.data!.variants!.first.options ?? "";
         // map.addAll({
         //   AllMenusGetxController.to.itemDetails.first.data!.variants![m].options!.startsWith('{\\').toString().endsWith(":\\") : "TEST",
         // });
       // }
       print("MAP:::: ${map}");
        vartiantId.value =   AllMenusGetxController.to.itemDetails.first.data!.variants!.where((e) => e.options == map.value).first.id!;

        print(vartiantId);



      }


      // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //   isLoading.value = true;
      //   if(itemDetails.first.data!.active_from != null){
      //     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //       DateTime startDate2 = DateTime(
      //           int.parse(itemDetails.first.data!.active_from!.substring(0, 10).split('-')[0]),
      //           int.parse(itemDetails.first.data!.active_from!.substring(0, 10).split('-')[1]),
      //           int.parse(itemDetails.first.data!.active_from!.substring(0, 10).split('-')[2]));
      //       DateTime endDate2 = DateTime(
      //           int.parse(itemDetails.first.data!.active_to!.substring(0, 10).split('-')[0]),
      //           int.parse(itemDetails.first.data!.active_to!.substring(0, 10).split('-')[1]),
      //           int.parse(itemDetails.first.data!.active_to!.substring(0, 10).split('-')[2]));
      //       List<DateTime> dateRange = getDateRange(startDate2, endDate2);
      //
      //       for (DateTime date in dateRange) {
      //         endBookingDates.add(
      //             date.toString().replaceAll(" 00:00:00.000", ""));
      //         print("Range2222::::${date.toString()}");
      //
      //         print("List1:: ${endBookingDates}");
      //
      //       }
      //
      //
      //     });
      //     // isLoading.value = true;
      //
      //
      //   }
      //   else{
      //
      //   }
      // });

      // for(int i = 0; i < itemDetails.first.data!.options!.length; i++){
      //   optionsGroupValues.addAll(itemDetails.first.data!.options![i].options!.split(',').toList());
      // }


     //  print("VER::::: ${itemDetails.first.data!.variants!.first.options}");
     // print(optionsValues);
     // print(optionsGroupValues);
     // // optionsGroupValues[0] = true;
     //
     //  print(optionsValues);
     //  print(optionsGroupValues);

      // isLoading.value = false;

    }
    print("Category ::: ${itemDetails.first.data!.categoryId}");
    print(itemDetails.first.data!.description);
    isLoading.value = false;
  }



  getResDetails({required String resName}) async{
    resDetails.clear();
    res.ResDetails?  detail = await MenuApiController().getResDetails(resName: resName);
        if(detail != null){
          resDetails.add(detail);
          type.value = resDetails.first.data!.type ?? 0;
          print(detail.data!.id);
        }
  }
  List<DateTime> getDateRange(DateTime startDate, DateTime endDate) {
    List<DateTime> dateRange = [];
    DateTime currentDate = startDate;

    // Loop through the dates and add them to the list until we reach the end date.
    while (currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
      dateRange.add(currentDate);
      currentDate = currentDate.add(Duration(days: 1));
    }

    return dateRange;
  }
  getEvents({required String id}) async{
    isLoading.value = true;
    startBookingDates.clear();

    // endBookingDates.clear();
    events.value = await MenuApiController().getEvents(id: id);
    if(events.isNotEmpty){
      events.forEach((element) {
        if(element.startTime != null) {
          // startBookingDates.add(element.startTime!.substring(0,10));
          // startBookingDates.add(element.endTime!.substring(0,10));

          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            DateTime startDate = DateTime(
                int.parse(element.startTime!.substring(0, 10).split('-')[0]),
                int.parse(element.startTime!.substring(0, 10).split('-')[1]),
                int.parse(element.startTime!.substring(0, 10).split('-')[2]));
            DateTime endDate = DateTime(
                int.parse(element.endTime!.substring(0, 10).split('-')[0]),
                int.parse(element.endTime!.substring(0, 10).split('-')[1]),
                int.parse(element.endTime!.substring(0, 10).split('-')[2]));
            // DateTime endDate = DateTime(2023, 8, 10);

            List<DateTime> dateRange = getDateRange(startDate, endDate);

            for (DateTime date in dateRange) {
              startBookingDates.add(
                  date.toString().replaceAll(" 00:00:00.000", ""));
              print("Range::::${date.toString()}");
              print("List:::: ${startBookingDates}");

            }

            isLoading.value = false;

          });

        }
      });



    }else{
      isLoading.value = false;

    }
  }

  createEvent({required String itemId,required String orderId}) async{
    int eventId = await MenuApiController().createEvent(itemId: itemId);
    if(eventId != -1){
      // resDetails.add(detail);
      await MenuApiController().updateOrderEvent(orderId: orderId, eventId: eventId.toString());
      Fluttertoast.showToast(msg: "تم حجز الفترة بنجاح");
      print("success");
    }else{

    }
  }
  searchItem(
      {
    required String categoryId,
    required String vendorId,
    required String query,
     required   String filter_state,
      required  String filter_city,
    required int current_page}) async{
    isLoading.value = true;
    page = current_page;

    //  loading.value  = true;
    itemsByCategory.clear();

    List<CategoryItems> list = [];
    list.clear();
    list = await MenuApiController().searchItem(
      categoryId: categoryId,
        vendorId: vendorId,
        query: query,
        filter_city: filter_city,
        filter_state: filter_state,
        current_page: current_page
    );

    // if(list.isEmpty){
    //   check.value = 1;
    // }else{
    //   check.value = 0;
    //
    // }
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

      itemsByCategory.value = list;

      // }

    }
    // }
    isLoading.value = false;
  }
}
