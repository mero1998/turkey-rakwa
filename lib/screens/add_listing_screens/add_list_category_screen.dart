import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakwa/Core/utils/extensions.dart';
import 'package:rakwa/api/api_controllers/list_api_controller.dart';
import 'package:rakwa/controller/custom_field_getx_controller.dart';
import 'package:rakwa/model/all_categories_model.dart';
import 'package:rakwa/model/create_item_model.dart';
import 'package:rakwa/screens/add_listing_screens/Controllers/add_work_controller.dart';
import 'package:rakwa/screens/add_listing_screens/add_list_subcategory_screen.dart';
import 'package:rakwa/screens/add_listing_screens/add_list_title_screen.dart';
import 'package:rakwa/Core/utils/helpers.dart';
import 'package:rakwa/widget/appbars/app_bars.dart';
import 'package:shimmer/shimmer.dart';

import '../../app_colors/app_colors.dart';
import '../../controller/list_controller.dart';
import '../../model/details_model.dart';
import '../../widget/next_step_button.dart';
import '../../widget/steps_widget.dart';

class AddListCategoryScreen extends StatefulWidget {
  DetailsModel? detailsModel;
   AddListCategoryScreen({ this.detailsModel});

  @override
  State<AddListCategoryScreen> createState() => _AddListCategoryScreenState();
}

class _AddListCategoryScreenState extends State<AddListCategoryScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.put(ListController());
    Get.put(AddWorkOrAdsController(isList: true));
    if(AddWorkOrAdsController.to.edit.value){
      // websiteController
      // facebookController
      // instagramController
      // twitterController
      // linkedInController
      for(int i  = 0; i < widget.detailsModel!.item!.allCategories!.length; i++){
        AddWorkOrAdsController.to.selectedCategoriesIds.add(widget.detailsModel!.item!.allCategories![i].id ?? -1);
      }
      AddWorkOrAdsController.to.selectedCategory.value = widget.detailsModel!.item!.allCategories!.first.categoryName ?? "";
      for(int i  = 0; i < widget.detailsModel!.item!.allCategories!.length; i++){
        AddWorkOrAdsController.to.categoriesIds.add(widget.detailsModel!.item!.allCategories![i].id ?? -1);
      }
      if(widget.detailsModel!.item!.itemHours != null || widget.detailsModel!.item!.itemHours!.isNotEmpty){
        for(int i = 0; i < widget.detailsModel!.item!.itemHours!.length; i++){

          // print(AddWorkOrAdsController.to.days[i][2]);
          print(widget.detailsModel!.item!.itemHours![i].itemHourOpenTime!);
          print(widget.detailsModel!.item!.itemHours![i].itemHourOpenTime!.substring(3, 5));
         // print(TimeOfDay(hour: int.parse(widget.detailsModel!.item!.itemHours![i].itemHourOpenTime!.substring(2,4)), minute: int.parse(widget.detailsModel!.item!.itemHours![i].itemHourOpenTime!.substring(4,5))));
          if( AddWorkOrAdsController.to.days.where((p0) => p0[4] == widget.detailsModel!.item!.itemHours![i].itemHourDayOfWeek.toString()).first[0] != null){
            AddWorkOrAdsController.to.days[AddWorkOrAdsController.to.days.indexWhere((element) => element[4] == widget.detailsModel!.item!.itemHours![i].itemHourDayOfWeek.toString())][0] = AddWorkOrAdsController.to.days.where((p0) => p0[4] == widget.detailsModel!.item!.itemHours![i].itemHourDayOfWeek.toString()).first[0];
            AddWorkOrAdsController.to.days[AddWorkOrAdsController.to.days.indexWhere((element) => element[4] == widget.detailsModel!.item!.itemHours![i].itemHourDayOfWeek.toString())][1] = true;
            AddWorkOrAdsController.to.days[AddWorkOrAdsController.to.days.indexWhere((element) => element[4] == widget.detailsModel!.item!.itemHours![i].itemHourDayOfWeek.toString())][2] = TimeOfDay(hour: int.parse(widget.detailsModel!.item!.itemHours![i].itemHourOpenTime!.substring(0, 2)), minute: int.parse(widget.detailsModel!.item!.itemHours![i].itemHourOpenTime!.substring(3,5)));
            AddWorkOrAdsController.to.days[AddWorkOrAdsController.to.days.indexWhere((element) => element[4] == widget.detailsModel!.item!.itemHours![i].itemHourDayOfWeek.toString())][3] = TimeOfDay(hour: int.parse(widget.detailsModel!.item!.itemHours![i].itemHourCloseTime!.substring(0,2)), minute: int.parse(widget.detailsModel!.item!.itemHours![i].itemHourCloseTime!.substring(3,5)));
            AddWorkOrAdsController.to.days[AddWorkOrAdsController.to.days.indexWhere((element) => element[4] == widget.detailsModel!.item!.itemHours![i].itemHourDayOfWeek.toString())][4] = widget.detailsModel!.item!.itemHours![i].itemHourDayOfWeek;
          }
        }

        // for(int i = 0; i < AddWorkOrAdsController.to.days.length; i++){
        //   if(AddWorkOrAdsController.to.days)
        // }
        print(AddWorkOrAdsController.to.days);
      }
      AddWorkOrAdsController.to.selectedCategoryID.value = widget.detailsModel!.item!.allCategories!.first.id;
      print("Categories ::: ${AddWorkOrAdsController.to.selectedCategoriesIds}");
      print("Categories ::: ${AddWorkOrAdsController.to.selectedCategoryID}");
      AddWorkOrAdsController.to.wodkId.value = widget.detailsModel!.item!.id.toString() ?? "";
      if(widget.detailsModel!.item!.vendor_id != null){
        AddWorkOrAdsController.to.wodkId.value = widget.detailsModel!.item!.vendor_id.toString();
      }
      AddWorkOrAdsController.to.titleController.text = widget.detailsModel!.item!.itemTitle ?? "";
      AddWorkOrAdsController.to.descriptionController.text = widget.detailsModel!.item!.itemDescription ?? "";
      AddWorkOrAdsController.to.locationController.text = widget.detailsModel!.item!.itemAddress ?? "";
      AddWorkOrAdsController.to.countryController.text = widget.detailsModel!.item!.country!.countryName ?? "";
      AddWorkOrAdsController.to.countryID = widget.detailsModel!.item!.country!.id ?? -1;
      AddWorkOrAdsController.to.stateID = widget.detailsModel!.item!.state!.id ?? -1;
      AddWorkOrAdsController.to.cityID = widget.detailsModel!.item!.city != null ?
      AddWorkOrAdsController.to.cityID = widget.detailsModel!.item!.city!.id : 0;
      AddWorkOrAdsController.to.stateController.text = widget.detailsModel!.item!.state!.stateName ?? "";
      AddWorkOrAdsController.to.cityController.text = widget.detailsModel!.item!.city != null ?
      AddWorkOrAdsController.to.cityController.text = widget.detailsModel!.item!.city!.cityName!
          :
       "";
      AddWorkOrAdsController.to.priceController.text = widget.detailsModel!.item!.itemPrice.toString();
      AddWorkOrAdsController.to.featureImage = widget.detailsModel!.item!.itemImage ?? "";
      AddWorkOrAdsController.to.phoneController.text = widget.detailsModel!.item!.itemPhone ?? "";
      AddWorkOrAdsController.to.websiteController.text = widget.detailsModel!.item!.itemWebsite ?? "";
      AddWorkOrAdsController.to.facebookController.text = widget.detailsModel!.item!.itemSocialFacebook ?? "";
      AddWorkOrAdsController.to.instagramController.text = widget.detailsModel!.item!.itemSocialInstagram ?? "";
      AddWorkOrAdsController.to.twitterController.text = widget.detailsModel!.item!.itemSocialTwitter ?? "";
      AddWorkOrAdsController.to.linkedInController.text = widget.detailsModel!.item!.itemSocialLinkedin ?? "";

      // AddWorkOrAdsController.to.featureImage = "https://www.rakwa.com/laravel_project/public/storage/item/alaarby-llaaod-2022-12-15-639ab9f68697e.jpg";
      AddWorkOrAdsController.to.featureImage = "https://www.rakwa.com/laravel_project/public/storage/item/${widget.detailsModel!.item!.itemImage ?? ""}";

      print("Image:: ${AddWorkOrAdsController.to.featureImage}");
      for(int i = 0;i < widget.detailsModel!.item!.galleries!.length; i++){
        AddWorkOrAdsController.to.imageGallery.add("https://www.rakwa.com/laravel_project/public/storage/item/gallery/${widget.detailsModel!.item!.galleries![i].itemImageGalleryName ?? ""}");

      }

    }
    // AddWorkOrAdsController.to.setSubCategoriesIds(id);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    Get.delete<AddWorkOrAdsController>();
    Get.delete<GetCustomFieldController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final AddWorkOrAdsController addWordController =
    //     Get.put(AddWorkOrAdsController(isList: true));
    // printDM("addWordController.selectedCategoryId is ${addWordController.selectedCategoryId}");
    return Scaffold(
      appBar: AppBars.appBarDefault(
          title: AddWorkOrAdsController.to.edit.value ? "تعديل العمل" : 'إضافة عمل'

      ),
      floatingActionButton: FloatingActionButtonNext(
        onTap: () {
          if(AddWorkOrAdsController.to.selectedCategoriesIds.isEmpty){
            ShowMySnakbar(
                title: 'خطا',
                message: 'يجب اختيار التصنيف الرئيسي',
                backgroundColor: Colors.red.shade700);
          }else{
            Get.to(AddListSubCategoryScreen(categoryId: AddWorkOrAdsController.to.selectedCategoryID.value));
          }
          // addWorkController.navigationAfterSelectSubCategories();


        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 24,
              ),


              GetX<AddWorkOrAdsController>(
                  builder: (controller){
                return controller.isLoading.value ? Shimmer.fromColors(
                    baseColor: Colors.grey.shade100,
                    highlightColor: Colors.grey.shade300,
                    child: GridView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: 18,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 12,
                        // mainAxisExtent: 60,
                      ),
                      itemBuilder: (context, index) {
                        return Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey,
                              border: Border.all(
                                width: 1,
                                color: AppColors.subTitleColor,
                              )),
                        );
                      },
                    )) :
                controller.category.isNotEmpty ? SingleChildScrollView(
                  child: Column(
                    children: [
                     GridView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemCount: controller.category.length,
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 12,
                            // mainAxisExtent: 60,
                          ),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                // controller.setParentCategory(
                                //   controller.category[index].id ?? -1,
                                // );
                                // if(controller.selectedCategoriesIds.contains(controller.category[index].id)){
                                //   controller.selectedCategoriesIds.indexWhere((element) => element == controller.category[index].id);
                                //   controller.selectedCategoriesIds.removeAt(index);
                                // }else{
                                //   controller.setCategoriesIds(
                                //       controller.category[index].id ?? -1);
                                //   controller.selectedCategory.value = controller.category[index].categoryName!;
                                // }

                                // if(controller.selectedCategoriesIds.isNotEmpty){
                                //   controller.selectedCategoriesIds.removeAt(0);
                                //
                                // }
                                //
                                // controller.setCategoriesIds(
                                //       controller.category[index].id ?? -1);
                                //   controller.selectedCategory.value = controller.category[index].categoryName!;
                              // if(!controller.edit.value){

                                setState(() {
                                  controller.selectedCategoryID.value = controller.category[index].id!;
                                });
                                controller.selectedCategory.value = controller.category[index].categoryName ?? "";
                                print("ID LLLL ${controller.selectedCategoryID.value}");
                                if(controller.categoriesIds.contains(controller.selectedCategoryID.value)){
                                  controller.selectedCategoriesIds.clear();
                                  for(int i  = 0; i < widget.detailsModel!.item!.allCategories!.length; i++){
                                    // if(!controller.selectedCategoriesIds.contains( widget.detailsModel!.item!.allCategories![i].id)){
                                    controller.selectedCategoriesIds.add( widget.detailsModel!.item!.allCategories![i].id);
                                    // }
                                    // controller.setCategoriesIds(
                                    //             widget.detailsModel!.item!.allCategories![i].id);
                                  }
                                }else{
                                  controller.selectedCategoriesIds.clear();
                                }
                                // if(controller.selectedCategoryID.value != controller.category[index].id){
                                //   controller.selectedCategoriesIds.clear();
                                // }

                                // controller.setCategoriesIds(controller.selectedCategoryID.value);
                                if(!AddWorkOrAdsController.to.selectedCategoriesIds.contains(controller.selectedCategoryID.value)){
                                  AddWorkOrAdsController.to.selectedCategoriesIds.add(controller.selectedCategoryID.value);

                                }
                                print(" Selected :::${controller.selectedCategoriesIds}");
                                  // Get.to(
                                  //         () => AddListSubCategoryScreen(
                                  //       categoryId: controller.selectedCategoryID.value,
                                  //     ));

                              // }
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: GetBuilder<AddWorkOrAdsController>(
                                id: 'update_categories_ids',
                                builder: (_) {
                                  return Material(
                                    elevation: 1,
                                    color: Colors.transparent,
                                    borderRadius:
                                    BorderRadius.circular(8),
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 2,
                                          color: _.category[index].id == _.selectedCategoryID.value
                                              ? AppColors().mainColor
                                              : Colors.transparent,
                                        ),
                                        color: Colors.white,
                                        borderRadius:
                                        BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          controller.category[index]
                                              .categoryImage !=
                                              null
                                              ? Image.network(
                                            'https://www.rakwa.com/laravel_project/public/storage/category/${controller.category[index].categoryImage}',
                                            height: 50,
                                            width: 50,
                                          )
                                              : SizedBox(),
                                          Text(
                                            controller.category[index]
                                                .categoryName ?? '',
                                            textAlign:
                                            TextAlign.center,
                                            style: GoogleFonts
                                                .notoKufiArabic(
                                              textStyle:
                                              const TextStyle(
                                                fontSize: 16,
                                                fontWeight:
                                                FontWeight.w500,
                                              ),
                                            ),
                                            maxLines: 3,
                                            overflow:
                                            TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      16.ESH(),
                    ],
                  ),
                ) : Center(child: Text('لا توجد تصنيفات'));
              })
              // Expanded(
              //   child: FutureBuilder<List<AllCategoriesModel>>(
              //     future: ListApiController().getCategory(),
              //     builder: (context, snapshot) {
              //       if (snapshot.connectionState == ConnectionState.waiting) {
              //         return Shimmer.fromColors(
              //             baseColor: Colors.grey.shade100,
              //             highlightColor: Colors.grey.shade300,
              //             child: GridView.builder(
              //               padding: EdgeInsets.zero,
              //               itemCount: 18,
              //               gridDelegate:
              //                   const SliverGridDelegateWithFixedCrossAxisCount(
              //                 crossAxisCount: 2,
              //                 crossAxisSpacing: 16,
              //                 mainAxisSpacing: 12,
              //                 // mainAxisExtent: 60,
              //               ),
              //               itemBuilder: (context, index) {
              //                 return Container(
              //                   alignment: Alignment.center,
              //                   decoration: BoxDecoration(
              //                       borderRadius: BorderRadius.circular(8),
              //                       color: Colors.white,
              //                       border: Border.all(
              //                         width: 1,
              //                         color: AppColors.subTitleColor,
              //                       )),
              //                 );
              //               },
              //             ));
              //       } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              //         return SingleChildScrollView(
              //           physics: const BouncingScrollPhysics(),
              //           child: Column(
              //             children: [
              //               AnimationLimiter(
              //                 child: GridView.builder(
              //                   padding: EdgeInsets.zero,
              //                   shrinkWrap: true,
              //                   physics: const NeverScrollableScrollPhysics(),
              //                   itemCount: snapshot.data!.length,
              //                   gridDelegate:
              //                       const SliverGridDelegateWithFixedCrossAxisCount(
              //                     crossAxisCount: 2,
              //                     crossAxisSpacing: 16,
              //                     mainAxisSpacing: 12,
              //                     // mainAxisExtent: 60,
              //                   ),
              //                   itemBuilder: (context, index) {
              //                     return AnimationConfiguration.staggeredGrid(
              //                       position: index,
              //                       duration: const Duration(milliseconds: 500),
              //                       columnCount: snapshot.data!.length,
              //                       child: ScaleAnimation(
              //                         child: FadeInAnimation(
              //                           child: InkWell(
              //                             onTap: () {
              //                               addWordController.setParentCategory(
              //                                 snapshot.data![index].id ?? -1,
              //                               );
              //                               addWordController.setCategoriesIds(
              //                                   snapshot.data![index].id ?? -1);
              //                               Get.to(
              //                                 () => AddListSubCategoryScreen(
              //                                   categoryId: addWordController
              //                                       .parentCategory,
              //                                 ),
              //                               );
              //                             },
              //                             borderRadius: BorderRadius.circular(8),
              //                             child: GetBuilder<AddWorkOrAdsController>(
              //                               id: 'update_categories_ids',
              //                               builder: (_) {
              //                                 return Material(
              //                                   elevation: 1,
              //                                   color: Colors.transparent,
              //                                   borderRadius:
              //                                       BorderRadius.circular(8),
              //                                   child: Container(
              //                                     alignment: Alignment.center,
              //                                     decoration: BoxDecoration(
              //                                       border: Border.all(
              //                                         width: 2,
              //                                         color: _.selectedCategoriesIds
              //                                                 .contains(snapshot
              //                                                     .data![index]
              //                                                     .id)
              //                                             ? AppColors.mainColor
              //                                             : Colors.transparent,
              //                                       ),
              //                                       color: Colors.white,
              //                                       borderRadius:
              //                                           BorderRadius.circular(8),
              //                                     ),
              //                                     child: Column(
              //                                       mainAxisAlignment:
              //                                           MainAxisAlignment.center,
              //                                       children: [
              //                                         snapshot.data![index]
              //                                                     .categoryImage !=
              //                                                 null
              //                                             ? Image.network(
              //                                                 'https://www.rakwa.com/laravel_project/public/storage/category/${snapshot.data![index].categoryImage}',
              //                                                 height: 50,
              //                                                 width: 50,
              //                                               )
              //                                             : SizedBox(),
              //                                         Text(
              //                                           snapshot.data![index]
              //                                               .categoryName ?? '',
              //                                           textAlign:
              //                                               TextAlign.center,
              //                                           style: GoogleFonts
              //                                               .notoKufiArabic(
              //                                             textStyle:
              //                                                 const TextStyle(
              //                                               fontSize: 16,
              //                                               fontWeight:
              //                                                   FontWeight.w500,
              //                                             ),
              //                                           ),
              //                                           maxLines: 3,
              //                                           overflow:
              //                                               TextOverflow.ellipsis,
              //                                         ),
              //                                       ],
              //                                     ),
              //                                   ),
              //                                 );
              //                               },
              //                             ),
              //                           ),
              //                         ),
              //                       ),
              //                     );
              //                   },
              //                 ),
              //               ),
              //               16.ESH(),
              //             ],
              //           ),
              //         );
              //       } else {
              //         return const Center(child: Text('لا توجد تصنيفات'));
              //       }
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
