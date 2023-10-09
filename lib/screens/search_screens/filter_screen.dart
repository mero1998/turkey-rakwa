import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakwa/api/api_controllers/search_api_controller.dart';
import 'package:rakwa/app_colors/app_colors.dart';
import 'package:rakwa/controller/list_controller.dart';
import 'package:rakwa/controller/search_ad_controller.dart';
import 'package:rakwa/controller/search_item_controller.dart';
import 'package:rakwa/model/all_categories_model.dart';
import 'package:rakwa/model/city_model.dart';
import 'package:rakwa/screens/add_listing_screens/Widget/bottom_sheet_city.dart';
import 'package:rakwa/screens/add_listing_screens/Widget/bottom_sheet_state.dart';
import 'package:rakwa/screens/search_screens/Widgets/bottom_sheet_classification.dart';
import 'package:rakwa/screens/search_screens/search_screen.dart';
import 'package:rakwa/widget/TextFields/text_field_default.dart';
import 'package:rakwa/widget/TextFields/validator.dart';
import 'package:rakwa/widget/appbars/app_bars.dart';
import 'package:rakwa/widget/home_widget.dart';
import 'package:rakwa/widget/main_elevated_button.dart';
import 'package:rakwa/widget/my_text_field.dart';
import 'package:shimmer/shimmer.dart';
import 'package:rakwa/model/paid_items_model.dart';

// typedef Filter = void Function(String cityId);

class FilterScreen extends StatefulWidget {
 int cityId;
 int stateId;
  int categoryId;
  int subCategoryId;
  int classifiedCategoryId;
  String query;
  final bool isItem;

  FilterScreen({
    super.key,
    required this.categoryId,
    required this.subCategoryId,
    required this.cityId,
    required this.classifiedCategoryId,
    required this.stateId,
   required this.query,
    required this.isItem,
  });

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {

  dynamic selectedCity;
  dynamic selectedState;
  dynamic selectedCategory;
  dynamic selectedSubCategory;
  dynamic selectedClssifiedCategory;

  ListController _listController = Get.put(ListController());
  SearchItemController _controller = Get.put(SearchItemController());

  late TextEditingController _searchController;
  // late TextEditingController _stateController;
  // late TextEditingController _cityController;
  // late TextEditingController _categoryController;
  // late TextEditingController _subCategoryController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    // _stateController = TextEditingController();
    // _cityController = TextEditingController();
    // _categoryController = TextEditingController();
    // _subCategoryController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    // _stateController.dispose();
    // _cityController.dispose();
    // _categoryController.dispose();
    // _subCategoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBars.appBarDefault(title: "فلترة"),
        body: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              const SizedBox(
                height: 24,
              ),
              InkWell(
                onTap: (){
                  SearchItemController.to.subCategoryController.text = "";
                  SearchItemController.to.categoryController.text = "";
                  SearchItemController.to.cityController.text = "";
                  SearchItemController.to.stateController.text = "";
                  SearchItemController.to.cityID.value = 0;
                  SearchItemController.to.stateID.value = 0;
                  SearchItemController.to.categoryID.value = "";
                  SearchItemController.to.subCategoryID.value = 0;

                  widget.categoryId == null
                      ? SearchItemController.to.search(
                    isItem: widget.isItem,
                    query: widget.query,
                    stateId: widget.stateId.toString(),
                    category: SearchItemController.to.subCategoryID != 0 ?  SearchItemController.to.subCategoryID.toString(): widget.categoryId.toString(),
                    cityId: widget.cityId.toString(),
                    classifiedcategories: widget.classifiedCategoryId.toString(),
                  )
                      : widget.isItem
                      ?

                  SearchItemController.to.searchItem(
                      categoryId: SearchItemController.to.subCategoryID != 0 ?  SearchItemController.to.subCategoryID.toString(): widget.categoryId.toString(),
                      stateId: widget.stateId.toString(),
                      cityId: widget.cityId.toString(),
                      classifiedcategories: widget.classifiedCategoryId.toString(),
                      query: widget.query,
                    current_page:1
                  )
                      :

                  SearchItemController.to.searchClassified(
                    stateId: widget.stateId.toString(),
                    category: widget.categoryId.toString(),
                    cityId: widget.cityId.toString(),
                    classifiedcategories: widget.classifiedCategoryId.toString(),
                    query: widget.query, current_page: 1
                  );

                },
                child: Align(
                    alignment: AlignmentDirectional.topEnd,
                    child: Text("اعادة ضبط الفلترة", style: GoogleFonts.notoKufiArabic(
                  textStyle:  TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w300,
                  ),),)),
              ),
               SizedBox(height: 16.h),
              GetBuilder<ListController>(
                builder: (controller) => GestureDetector(
                  onTap: () {
                    Get.bottomSheet(
                      BottomSheetState(
                        state: _listController.states,
                        bottomSheetTitle: "الولايات",
                        stateSelectedId: SearchItemController.to.stateID.value,
                        onSelect: (state) {
                          setState(() {
                            selectedState = state;
                            SearchItemController.to.stateController.text = state.stateName;
                            SearchItemController.to.stateID.value = state.id;
                            if (selectedCity != null) {
                              selectedCity = null;
                              SearchItemController.to.cityID.value= 0;
                            }
                          });

                          _listController.getCitys(id: SearchItemController.to.stateID.value.toString());
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
                        citySelectedId:  SearchItemController.to.cityID.value ,
                        onSelect: (city) {
                          setState(() {
                            selectedCity = city;
                            SearchItemController.to.cityController.text = city.cityName;
                            SearchItemController.to.cityID.value = city.id;
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

               SizedBox(height: 16.h),
              Visibility(
                visible: widget.isItem,
                child: GetBuilder<SearchItemController>(
                  builder: (controller) => GestureDetector(
                    onTap: () {
                      Get.bottomSheet(
                        BottomSheetClassification(
                          categories: _controller.category,
                          bottomSheetTitle: "التصنيفات",
                          categorySelectedId: controller.categoryID.value,
                          onSelect: (category) {
                            setState(() {
                              selectedCategory = category;
                              SearchItemController.to.categoryController.text = category.categoryName ?? "";
                              SearchItemController.to.subCategoryController.text = "";
                              controller.categoryID.value = category.id!.toString();
                              controller.subCategoryID.value = 0;
                            });
                          },
                        ),
                      );
                    },
                    child: TextFieldDefault(
                      enable: false,
                      upperTitle: "التصنيف",
                      hint: 'اختار التصنيف',
                      prefixIconSvg: "address2",
                      suffixIconData: Icons.arrow_drop_down_sharp,
                      controller:  SearchItemController.to.categoryController,
                      validation: locationValidator,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: widget.isItem,
                child: GetBuilder<SearchItemController>(
                  builder: (controller) => GestureDetector(
                    onTap: () async{
                     await controller.getSubCategory(id: controller.categoryID.value);
                await  Get.bottomSheet(
                        BottomSheetClassification(
                          categories: _controller.subCategory,
                          bottomSheetTitle: "التصنيفات الفرعية",
                          categorySelectedId: _controller.subCategoryID.value.toString(),
                          onSelect: (category) {
                            setState(() {
                              selectedSubCategory = category;
                              SearchItemController.to.subCategoryController.text = category.categoryName ?? "";
                              controller.subCategoryID.value = category.id!;
                            });
                          },
                        ),
                      );
                    },
                    child: TextFieldDefault(
                      enable: false,
                      upperTitle: "التصنيف الفرعي",
                      hint: ' اختار التصنيف الفرعي',
                      prefixIconSvg: "address2",
                      suffixIconData: Icons.arrow_drop_down_sharp,
                      controller:  SearchItemController.to.subCategoryController,
                      validation: locationValidator,
                    ),
                  ),
                ),
              ),
               SizedBox(height: 16.h),
              // Container(
              //   margin: const EdgeInsets.symmetric(horizontal: 16),
              //   width: Get.width,
              //   padding: const EdgeInsets.symmetric(horizontal: 16),
              //   decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(12),
              //       color: Colors.white,
              //       boxShadow: [
              //         BoxShadow(
              //             offset: const Offset(0, 0),
              //             color: AppColors.labelColor.withOpacity(0.2),
              //             spreadRadius: 2,
              //             blurRadius: 5),
              //       ]),
              //   child: GetBuilder<SearchController>(
              //     builder: (controller) {
              //       return DropdownButton(
              //         underline: const Divider(
              //           thickness: 0,
              //         ),
              //         isExpanded: true,
              //         hint: const Text('اختار تصنيف'),
              //         onChanged: (value) {
              //           value as AllCategoriesModel;
              //           setState(() {
              //             selectedCategory = value;
              //             categoryID = value.id;
              //           });
              //         },
              //         value: selectedCategory,
              //         items: _controller.category
              //             .map((e) => DropdownMenuItem(
              //                 value: e, child: Text(e.categoryName)))
              //             .toList(),
              //       );
              //     },
              //   ),
              // ),
              // const SizedBox(
              //   height: 12,
              // ),
              // Container(
              //   margin: const EdgeInsets.symmetric(horizontal: 16),
              //   width: Get.width,
              //   padding: const EdgeInsets.symmetric(horizontal: 16),
              //   decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(12),
              //       color: Colors.white,
              //       boxShadow: [
              //         BoxShadow(
              //             offset: const Offset(0, 0),
              //             color: AppColors.labelColor.withOpacity(0.2),
              //             spreadRadius: 2,
              //             blurRadius: 5),
              //       ]),
              //   child: GetBuilder<SearchController>(
              //     builder: (controller) {
              //       return DropdownButton(
              //         underline: const Divider(
              //           thickness: 0,
              //         ),
              //         isExpanded: true,
              //         hint: const Text('اختار تصنيف'),
              //         onChanged: (value) {
              //           value as AllCategoriesModel;
              //           setState(() {
              //             selectedClssifiedCategory = value;
              //             categoryClssifeidID = value.id;
              //           });
              //         },
              //         value: selectedClssifiedCategory,
              //         items: _controller.clssifiedCategory
              //             .map((e) => DropdownMenuItem(
              //                 value: e, child: Text(e.categoryName)))
              //             .toList(),
              //       );
              //     },
              //   ),
              // ),
              const Spacer(),
              MainElevatedButton(
                height: 60,
                width: Get.width * .9,
                borderRadius: 12,
                onPressed: () {
                  // widget.stateId(stateID==0||stateID==null?"": stateID.toString());
                  // widget.cityId(cityID==0||cityID==null?"":cityID.toString());
                  // widget.category(categoryID==0||categoryID==null?"":categoryID.toString());
                  // widget.subCategory(subCategoryID==0||subCategoryID==null?"":subCategoryID.toString());
                  // widget.classifiedCategory(categoryClssifeidID==0||categoryClssifeidID==null?"":categoryClssifeidID.toString());

                  // widget.categoryId == null
                  //     ? SearchController.to.search(
                  //   isItem: widget.isItem,
                  //   query: widget.query,
                  //   stateId: widget.stateId.toString(),
                  //   category: SearchController.to.subCategoryID != 0 ?  SearchController.to.subCategoryID.toString(): SearchController.to.categoryID.toString(),
                  //   cityId: widget.cityId.toString(),
                  //   classifiedcategories: widget.classifiedCategoryId.toString(),
                  // )
                  //     :

                  SearchItemController.to.searchList.clear();
                  widget.isItem
                      ?

                  SearchItemController.to.searchItem(
                    categoryId: SearchItemController.to.subCategoryID != 0 ?  "${SearchItemController.to.subCategoryID.toString()}": SearchItemController.to.categoryID.toString(),
                    stateId: SearchItemController.to.stateID.value.toString(),
                    cityId: SearchItemController.to.cityID.toString(),
                    classifiedcategories: widget.classifiedCategoryId.toString(),
                    query: widget.query,
                      current_page: 1

                  )
                      :

                  SearchItemController.to.searchClassified(
                    stateId:  SearchItemController.to.stateID.value.toString(),
                    category: widget.categoryId.toString(),
                    cityId: SearchItemController.to.cityID.toString(),
                    classifiedcategories: widget.classifiedCategoryId.toString(),
                    query:  widget.query, current_page: 1
                  );
                  Get.back(result: true);
                // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (c) => SearchScreen(isItem: widget.isItem, isFilter: true,)));
                },
                child: Text(
                  'فلترة',
                  style: GoogleFonts.notoKufiArabic(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 100,
              ),
            ],
          ),
        ));
  }
}
