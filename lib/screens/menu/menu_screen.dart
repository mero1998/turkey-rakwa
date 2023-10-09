import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakwa/app_colors/app_colors.dart';
import 'package:rakwa/controller/all_menu_getx_controller.dart';
import 'package:rakwa/model/category_items.dart';
import 'package:rakwa/model/menu.dart';
import 'package:rakwa/screens/menu/food_details_screen.dart';
import 'package:rakwa/shared_preferences/shared_preferences.dart';
import 'package:rakwa/widget/appbars/app_bars.dart';
import 'package:rakwa/widget/main_elevated_button.dart';
import 'package:shimmer/shimmer.dart';

import '../../controller/all_cart_getx_controller.dart';
import '../../controller/list_controller.dart';
import '../../controller/search_item_controller.dart';
import '../../widget/TextFields/text_field_default.dart';
import '../add_listing_screens/Widget/bottom_sheet_city.dart';
import '../add_listing_screens/Widget/bottom_sheet_state.dart';
import '../cart/cart_screen.dart';

class MenuScreen extends StatefulWidget {

  String resName;
  int userId;

  MenuScreen({required  this.resName ,required this.userId});
  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {

  List<String> categories = [
    "كل التصنيفات",
    "Taco",
    "Burrito",
    "Burrito In A Bowl",
    "Quesadilla",
  ];

  TextEditingController searchController =  TextEditingController();

  ListController _listController = Get.put(ListController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Get.put(AllCartsGetxController());

    Get.put(AllMenusGetxController());

    WidgetsBinding.instance.addPostFrameCallback((timeStamp)async {
      AllMenusGetxController.to.selectedItem.value = -1;
      AllMenusGetxController.to.categories.clear();
      AllMenusGetxController.to.itemsByCategory.clear();
      AllMenusGetxController.to.back.value = false;
      await AllMenusGetxController.to.getResDetails(resName: widget.resName,);

      // await  AllMenusGetxController.to.getMenus(resturentName: widget.resId, current_page: 1);
    await  AllMenusGetxController.to.getMenuResCategories(resId: AllMenusGetxController.to.resDetails.first.data!.id.toString());

    // AllMenusGetxController.to.resId.value = widget.resId;
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
    //     }
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBars.appBarDefault(title: "القائمة", onTap: (){

        AllMenusGetxController.to.back.value = true;
        Get.back(result: true);
        print("TAP");
      },
        secondIconImage: Visibility(
          visible: SharedPrefController().isLogined,
          child: InkWell(
            onTap: () => Get.to(CartScreen()),
            child: Stack(
              children: [
                Container(width: 120.w, height: 100.h,),
                PositionedDirectional(
                    end: 20.w,
                    top: 10.h,
                    child: Icon(Icons.shopping_cart)),
                PositionedDirectional(
                  end: 30.w,
                  child: GetX<AllCartsGetxController>(
                      builder: (c) {
                        return Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors().mainColor,
                            shape: BoxShape.circle,
                          ),
                          child: Text(c.carts.isEmpty ? "0" :c.carts.first.data!.length.toString()),
                        );
                      }
                  ),
                )
              ],
            ),
          ),
        )
      ),
      body: GetX<AllMenusGetxController>(
        builder: (controller) {
          return ListView(
            controller: controller.scroll,

            shrinkWrap: true,
            physics: ScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFieldDefault(
                      enable: true,
                      hint: 'ابحث عن...',
                      hintColor: Colors.black,
                      hintSize: 10,
                      hintWeight: FontWeight.w400,
                      prefixIconData: Icons.search,
                      controller: searchController,
                      // suffixIconData: Icons.filter_list,
                      suffixColor: Colors.black,
                      onChanged: (value)async{
                        if(value.isEmpty){
                          // controller.itemsByCategory.clear();
                          controller.check.value = 0;

                          if(AllMenusGetxController.to.selectedItem.value == -1){
                            //
                            // await  AllMenusGetxController.to.getMenus(resturentName: widget.resId,current_page: 1);
                            //
                            // for(int i = 0; i <  AllMenusGetxController.to.menus.length; i++){
                            //   if( AllMenusGetxController.to.menus[i].items!.isNotEmpty){
                            //     for(int o = 0; o <  AllMenusGetxController.to.menus[i].items!.length; o++ ) {
                            //       CategoryItems item = CategoryItems();
                            //       item.id = AllMenusGetxController.to.menus[i].items![o].id ?? 0;
                            //       item.name = AllMenusGetxController.to.menus[i].items![o].name ?? "";
                            //       item.description =
                            //           AllMenusGetxController.to.menus[i].items![o].description ?? "";
                            //       item.logom =
                            //           AllMenusGetxController.to.menus[i].items![o].logom ?? "";
                            //       item.price =
                            //           AllMenusGetxController.to.menus[i].items![o].price ?? 0;
                            //       AllMenusGetxController.to.itemsByCategory.add(item);
                            //     }
                            //     AllMenusGetxController.to.isLoading.value= false;
                            //
                            //   }}

                            controller.getAllItems();

                            controller.check.value = 0;
                          }else{
                            controller.check.value = 0;


                            controller.getItemsByCategory(categoryId: AllMenusGetxController.to.selectedItemID.value.toString(),current_page: 1);

                          }
                        }else{
                          if(AllMenusGetxController.to.selectedItem.value == -1){
                            controller.searchItem(categoryId:"",
                                query: value.trim(),
                                current_page: 1,
                                filter_city: AllMenusGetxController.to.filterCity.value == 0 ? "" :AllMenusGetxController.to.filterCity.value.toString(),
                                filter_state: AllMenusGetxController.to.filterState.value== 0 ? "" :AllMenusGetxController.to.filterState.value.toString(),
                                vendorId: AllMenusGetxController.to.resDetails.first.data!.id.toString());
                          }else{
                            controller.searchItem(categoryId: controller.selectedItemID.value.toString(),
                                query: value.trim(),
                                current_page: 1,
                                filter_city: AllMenusGetxController.to.filterCity.value == 0 ? "" :AllMenusGetxController.to.filterCity.value.toString(),
                                filter_state: AllMenusGetxController.to.filterState.value== 0 ? "" :AllMenusGetxController.to.filterState.value.toString(),
                                vendorId: AllMenusGetxController.to.resDetails.first.data!.id.toString());
                          }

                        }
                      },
                    ),
                  ),
                  Visibility(
                    visible: controller.type.value == 5 ||  controller.type.value == 4,
                    child: IconButton(
                      color: Colors.white,
                      onPressed: () {

                        AllMenusGetxController.to.filter.value =   !AllMenusGetxController.to.filter.value;
                        // node.unfocus();
                        // Get.to(() => FilterScreen(
                        //   isItem: widget.isItem,
                        //   categoryId: widget.categoryId == null ? 0: int.parse(widget.categoryId!),
                        //   cityId: 0,
                        //   classifiedCategoryId: 0,
                        //   stateId: 0,
                        //   subCategoryId: 0,
                        //   query: _searchController.text,
                        // ))!.then((value) {
                        //   print("Value:: ${value}");
                        //   isFilter = value;
                        //
                        // });
                      },
                      icon: const Icon(
                        Icons.filter_list_sharp,
                        color: Colors.black,

                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: AllMenusGetxController.to.filter.value,
                child: Column(
                  children: [
                    SizedBox(height: 10.h,),
                    GetBuilder<ListController>(
                      builder: (controller) => GestureDetector(
                        onTap: () {
                          Get.bottomSheet(
                            BottomSheetState(
                              state: _listController.states,
                              bottomSheetTitle: "الولايات",
                              stateSelectedId: AllMenusGetxController.to.filterState.value,
                              onSelect: (state) {
                                setState(() {
                                  // selectedState = state;
                                  SearchItemController.to.stateController.text = state.stateName;
                                  AllMenusGetxController.to.filterState.value = state.id;
                                  // if (selectedCity != null) {
                                  //   selectedCity = null;
                                  //   SearchItemController.to.cityID.value= 0;
                                  // }
                                });

                                _listController.getCitys(id: AllMenusGetxController.to.filterState.value.toString());
                              },
                            ),
                          );
                        },
                        child: TextFieldDefault(
                          enable: false,
                          upperTitle: "الولاية",
                          hint: 'اختار ولاية',
                          prefixIconSvg: "state",
                          suffixIconData: Icons.arrow_drop_down_sharp,
                          controller: SearchItemController.to.stateController,
                          validation: locationValidator,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    GetBuilder<ListController>(
                      builder: (controller) => GestureDetector(
                        onTap: () {
                          Get.bottomSheet(
                            BottomSheetCity(
                              cities: _listController.citys,
                              bottomSheetTitle: "المدن",
                              citySelectedId: AllMenusGetxController.to.filterCity.value,
                              onSelect: (city) {
                                setState(() {
                                  // selectedCity = city;
                                  SearchItemController.to.cityController.text = city.cityName;
                                  AllMenusGetxController.to.filterCity.value = city.id;
                                });
                              },
                            ),
                          );
                        },
                        child: TextFieldDefault(
                          enable: false,
                          upperTitle: "المدينة",
                          hint: 'اختار المدينة',
                          prefixIconSvg: "city",
                          suffixIconData: Icons.arrow_drop_down_sharp,
                          controller: SearchItemController.to.cityController,
                          validation: locationValidator,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MainElevatedButton(child: Text("فلترة",
                          style: GoogleFonts.notoKufiArabic(
                            textStyle:  TextStyle(
                                fontSize: 12.sp,
                                color: Colors.white ,
                                fontWeight: FontWeight.w500
                            ),),), height: 36.h, width: 60.w, borderRadius: 4, onPressed: ()=> controller.searchItem(categoryId:"",
                            query: searchController.text,
                            current_page: 1,
                            filter_city: AllMenusGetxController.to.filterCity.value == 0 ? "" :AllMenusGetxController.to.filterCity.value.toString(),
                            filter_state: AllMenusGetxController.to.filterState.value== 0 ? "" :AllMenusGetxController.to.filterState.value.toString(),
                            vendorId: AllMenusGetxController.to.resDetails.first.data!.id.toString())),
                        SizedBox(width: 20.w,),
                        InkWell(
                          onTap: () {
                            AllMenusGetxController.to.filterCity.value = 0;
                            AllMenusGetxController.to.filterState.value = 0;
                            AllMenusGetxController.to.check.value = 0;
                            AllMenusGetxController.to.selectedItem.value = -1;
                            SearchItemController.to.cityController.text = "";
                            SearchItemController.to.stateController.text = "";
                            searchController.text = "";
                            AllMenusGetxController.to.getAllItems();

                          },
                          child: Text("اعادة ضبط",
                            style: GoogleFonts.notoKufiArabic(
                              textStyle:  TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.black ,
                                  fontWeight: FontWeight.w500
                              ),),),
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 24.h),
            controller.isLoading2.value ? Shimmer.fromColors(
                baseColor: Colors.grey.shade100,
                highlightColor: Colors.grey.shade300,
                child:   SizedBox(
                  height: 26.h,
                  child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: ScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (context , index){
          return Container(
    margin:  EdgeInsetsDirectional.only(end: 8.w),
    height: 26.h,
    width: 120.w,
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(12),
    color: Colors.white,
    ),
    );}),
                ))  :
            SizedBox(
                height: 30.h,
                child: ListView(

                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: [
                    Row(
                      children: [
                       Visibility(
                         visible: controller.categories.isNotEmpty,
                         child: InkWell(
          onTap: (){
          setState(() {
            controller.selectedItem.value = -1;
            controller.isLoading.value= true;
          //   controller.itemsByCategory.clear();
          // for(int i = 0; i < controller.menus.length; i++){
          // if(controller.menus[i].items!.isNotEmpty){
          // for(int o = 0; o < controller.menus[i].items!.length; o++ ){
          // CategoryItems item = CategoryItems();
          // item.id = AllMenusGetxController.to.menus[i].items![o].id ?? 0;
          // item.name = controller.menus[i].items![o].name ?? "";
          // item.description = controller.menus[i].items![o].description ?? "";
          // item.logom = controller.menus[i].items![o].logom ?? "";
          // item.price = controller.menus[i].items![o].price ?? 0;
          // controller.itemsByCategory.add(item);
          //
          // }
          // }


          // }
            controller.getAllItems();
            controller.isLoading.value= false;


          });
          },
          child: Container(
          height: 26.h,
          padding: EdgeInsets.symmetric(horizontal: 8.w,),
          margin: EdgeInsetsDirectional.only(end: 10.w,),
          decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.r),
          color:controller.selectedItem.value == -1 ?AppColors().mainColor : Colors.white
          ),
          alignment: Alignment.center,
          child: Text("كل التصنيفات",
          style: GoogleFonts.notoKufiArabic(
          textStyle:  TextStyle(
          fontSize: 12.sp,
          color: controller.selectedItem.value == -1 ?  Colors.white : AppColors().mainColor ,
          fontWeight: FontWeight.w500
          ),),)),
          ),
                       ),
                        ListView.builder(
                          padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.categories.length,
                            itemBuilder: (context , index){
                          return InkWell(
                            onTap: (){
                              setState(() {
                               controller.selectedItem.value = index;
                               controller.selectedItemID.value = controller.categories[index].id!;
                               // controller.itemsByCategory.clear();

                               controller.getItemsByCategory(categoryId: controller.categories[index].id.toString(),current_page: 1);

                               // List<CategoryItems> list = controller.itemsByCategory.where((p0) => p0.categoryId == controller.categories[index].id).toList();
                               // controller.itemsByCategory.value = list;
                              });
                            },
                            child: Container(
                              height: 26.h,
                              padding: EdgeInsets.symmetric(horizontal: 8.w,),
                              margin: EdgeInsetsDirectional.only(end: 10.w,),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.r),
                                color: controller.selectedItem.value == index ?  AppColors().mainColor : Colors.white
                              ),
                              alignment: Alignment.center,
                              child: Text(controller.categories[index].name ?? "",
                                style: GoogleFonts.notoKufiArabic(
                                textStyle:  TextStyle(
                                fontSize: 12.sp,
                                color:controller.selectedItem.value == index  ? Colors.white : AppColors().mainColor,
                                  fontWeight: FontWeight.w500
                                ),),)),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              controller.isLoading.value ? Shimmer.fromColors(
                  baseColor: Colors.grey.shade100,
                  highlightColor: Colors.grey.shade300,
                  child:  GridView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: 6,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 18.w , mainAxisSpacing: 16.h),
                      itemBuilder: (context, index){
                        return Container(
                          alignment: Alignment.center,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  height: 108.h,
                                  width: 162.w,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.r),
                                    color: Colors.grey,
                                  ),
                                ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 5.h,),
                                      Container(
                                        height: 20.w,
                                        width: 80.h,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8.r),
                                          color: Colors.grey,
                                        ),

                                      ),
                                      SizedBox(height: 5.h,),
                                      Container(
                                        height: 20.w,
                                        width: 80.h,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8.r),
                                          color: Colors.grey,
                                        ),

                                      )

                                    ],
                                  ),
                                  Container(
                                    height: 20.w,
                                    width: 30.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.r),
                                      color: Colors.grey,
                                    ),

                                  )
                                ],
                              )

                            ],
                          ),
                        );

                      })
              ) : controller.check.value == 1 ? Center(child: Text("لا توجد عناصر متطابقة مع البحث",style: GoogleFonts.notoKufiArabic(
          textStyle:  TextStyle(
          fontSize: 14.sp,
          color:Colors.black,
          fontWeight: FontWeight.w500
          ),),),):
              SingleChildScrollView(
                child: Column(
                  children: [
                    GridView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: controller.itemsByCategory.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 18.w , mainAxisSpacing: 16.h),
                        itemBuilder: (context, index){
                          print("https://rakwa.me/${controller.itemsByCategory[index].logom}");
                      return InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (c) => FoodDetailsScreen(foodId: controller.itemsByCategory[index].id ?? -1, resId: int.parse(AllMenusGetxController.to.resDetails.first.data!.id.toString()),userId: widget.userId,),));
                        },
                        child: Container(
                          alignment: Alignment.center,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  height: 108.h,
                                  width: 162.w,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.r)
                                  ),
                                  child: Image.network("https://rakwa.me/${controller.itemsByCategory[index].logom}" ??"",fit: BoxFit.cover,
                                      // errorBuilder: (BuildContext context, Object? exception, StackTrace? stackTrace) {
                                      //   return Image.asset("images/logo.jpg",
                                      //     width: Get.width,
                                      //     height: double.infinity,
                                      //     fit: BoxFit.cover,
                                      //   );
                                      // }
                                  )),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(controller.itemsByCategory[index].name ??"",
                                          style: GoogleFonts.notoKufiArabic(
                                            textStyle:  TextStyle(
                                                fontSize: 14.sp,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500
                                            ),),
                                        overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(controller.itemsByCategory[index].description ?? "",
                                          style: GoogleFonts.notoKufiArabic(
                                            textStyle:  TextStyle(
                                                fontSize: 10.sp,
                                                color: Colors.black.withOpacity(0.55),
                                                fontWeight: FontWeight.w500
                                            ),),
                                        overflow: TextOverflow.ellipsis,
                                        )
                                      ],
                                    ),
                                  ),
                                  Text('${controller.itemsByCategory[index].price} ${controller.itemsByCategory[index].active_from != null ? '\$': 'ليرة'} ',
                                    style: GoogleFonts.notoKufiArabic(
                                      textStyle:  TextStyle(
                                          fontSize: 12.sp,
                                          color: Color(0xFF6B7280),
                                          fontWeight: FontWeight.w500
                                      ),),)
                                ],
                              )

                            ],
                          ),
                        ),
                      );

                    }),
                    Visibility(
                        visible: controller.loading.value,
                        child: Center(child: CircularProgressIndicator(),))

                  ],
                ),
              )
            ],
          );
        }
      ),
    );
  }
  String? locationValidator(String? text) {
    if (text!.isNotEmpty) {
      return null;
    } else {
      return 'يجب ادخال الموقع';
    }
  }
}
