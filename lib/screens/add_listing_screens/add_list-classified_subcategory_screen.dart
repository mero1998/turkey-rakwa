import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakwa/Core/utils/extensions.dart';
import 'package:rakwa/controller/list_controller.dart';
import 'package:rakwa/screens/add_listing_screens/Controllers/add_work_controller.dart';
import 'package:rakwa/screens/add_listing_screens/add_list_subcategory_screen.dart';
import 'package:rakwa/widget/appbars/app_bars.dart';
import 'package:shimmer/shimmer.dart';

import '../../api/api_controllers/list_api_controller.dart';
import '../../app_colors/app_colors.dart';
import '../../model/all_categories_model.dart';
import '../../model/create_item_model.dart';
import '../../widget/next_step_button.dart';
import '../../widget/steps_widget.dart';
import 'add_list_title_screen.dart';

class AddListClassifiedSubCategoryScreen extends StatefulWidget {
  final int categoryId;

  const AddListClassifiedSubCategoryScreen(
      {super.key, required this.categoryId});

  @override
  State<AddListClassifiedSubCategoryScreen> createState() =>
      _AddListClassifiedSubCategoryScreenState();
}

class _AddListClassifiedSubCategoryScreenState
    extends State<AddListClassifiedSubCategoryScreen> {
  List<String>? selectedSubID = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
     await AddWorkOrAdsController.to.getSubClassfiedCategory(id: widget.categoryId);

      print( "Sub Category :::  ${ AddWorkOrAdsController.to.subClssifiedCategory.length}");

      if(AddWorkOrAdsController.to.subClssifiedCategory.isEmpty){
        Future.delayed(
                              const Duration(milliseconds: 1),
                              () {
                                ///
                                Get.off(
                                  () => AddListTitleScreen(
                                    isList: false,
                                  ),
                                );
                              },
                            );

      }
    });
  }
  @override
  Widget build(BuildContext context) {
    AddWorkOrAdsController addWorkController = Get.find();
    return Scaffold(
      appBar: AppBars.appBarDefault(title: AddWorkOrAdsController.to.edit.value ? "تعديل اعلان" : 'إضافة اعلان'),
      floatingActionButton: FloatingActionButtonNext(
        onTap: () {
          ///
          addWorkController.navigationAfterSelectSubCategories();

        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          24.ESH(),
          StepsWidget(selectedStep: 0),
          32.ESH(),

          Expanded(
            child: GetX<AddWorkOrAdsController>(
                builder: (controller){
              return controller.isLoading.value ?Shimmer.fromColors(
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
                  ))
                  : controller.subClssifiedCategory.isEmpty ?

              Center(child: Text('لا توجد تصنيفات')) :
              GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 12,
                ),
                itemCount: controller.subClssifiedCategory.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      ///
                      setState(() {
                        controller.setCategoriesIds(
                            controller.subClssifiedCategory[index].id ?? -1);
                      });

                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Material(
                      elevation: 1,
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: controller.selectedCategoriesIds
                                .contains(controller.subClssifiedCategory[index].id)
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
                            controller.subClssifiedCategory[index]
                                .categoryImage !=
                                null
                                ? Image.network(
                              'https://www.rakwa.com/laravel_project/public/storage/category/${controller.subClssifiedCategory[index].categoryImage}',
                              height: 50,
                              width: 50,
                            )
                                : SizedBox(),
                            Text(
                              controller.subClssifiedCategory[index].categoryName ?? "",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.notoKufiArabic(
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ) ]));
    //       Expanded(
    //         child: Padding(
    //           padding: const EdgeInsets.symmetric(horizontal: 16),
    //           child: FutureBuilder<List<AllCategoriesModel>>(
    //             future: ListApiController()
    //                 .getClassifiedSubCategory(id: widget.categoryId),
    //             builder: (context, snapshot) {
    //               if (snapshot.connectionState == ConnectionState.waiting) {
    //                 return const Center(
    //                   child: CircularProgressIndicator(
    //                     color: AppColors.mainColor,
    //                   ),
    //                 );
    //               } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
    //                 return GetBuilder<AddWorkOrAdsController>(
    //                   id: "update_Classified_categories_ids",
    //                   builder: (_) => AnimationLimiter(
    //                     child: GridView.builder(
    //                       physics: const BouncingScrollPhysics(),
    //                       gridDelegate:
    //                           const SliverGridDelegateWithFixedCrossAxisCount(
    //                         crossAxisCount: 2,
    //                         crossAxisSpacing: 16,
    //                         mainAxisSpacing: 12,
    //                       ),
    //                       itemCount: snapshot.data!.length,
    //                       itemBuilder: (context, index) {
    //                         return AnimationConfiguration.staggeredGrid(
    //                           position: index,
    //                           duration: const Duration(milliseconds: 500),
    //                           columnCount: snapshot.data!.length,
    //                           child: ScaleAnimation(
    //                             child: FadeInAnimation(
    //                               child: InkWell(
    //                                 onTap: () {
    //                                   ///
    //                                   _.setCategoriesIds(
    //                                       snapshot.data![index].id ?? -1);
    //                                 },
    //                                 borderRadius: BorderRadius.circular(8),
    //                                 child: Material(
    //                                   elevation: 1,
    //                                   color: Colors.transparent,
    //                                   borderRadius: BorderRadius.circular(8),
    //                                   child: Container(
    //                                     alignment: Alignment.center,
    //                                     decoration: BoxDecoration(
    //                                       border: Border.all(
    //                                         width: 2,
    //                                         color: _.selectedCategoriesIds
    //                                                 .contains(snapshot
    //                                                     .data![index].id)
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
    //                                           snapshot
    //                                               .data![index].categoryName ?? "",
    //                                           textAlign: TextAlign.center,
    //                                           style: GoogleFonts.notoKufiArabic(
    //                                             textStyle: const TextStyle(
    //                                               fontSize: 16,
    //                                               fontWeight: FontWeight.w500,
    //                                             ),
    //                                           ),
    //                                           maxLines: 3,
    //                                           overflow: TextOverflow.ellipsis,
    //                                         ),
    //                                       ],
    //                                     ),
    //                                   ),
    //                                 ),
    //                               ),
    //                             ),
    //                           ),
    //                         );
    //                       },
    //                     ),
    //                   ),
    //                 );
    //               } else {
    //                 Future.delayed(
    //                   const Duration(milliseconds: 1),
    //                   () {
    //                     ///
    //                     Get.off(
    //                       () => AddListTitleScreen(
    //                         isList: false,
    //                       ),
    //                     );
    //                   },
    //                 );
    //                 return const Center(child: Text('لا توجد تصنيفات'));
    //               }
    //             },
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }

  CreateItemModel getCreateItemModel({required List<int>? subCategory}) {
    CreateItemModel createItemModel = CreateItemModel();
    createItemModel.itemType = '1';
    createItemModel.itemFeatured = '0';
    createItemModel.itemPostalCode = '34515';
    createItemModel.itemHourShowHours = '1';
    createItemModel.category.add(widget.categoryId);
    if (subCategory != null) {
      createItemModel.category.addAll(subCategory);
    }

    return createItemModel;
  }
}
