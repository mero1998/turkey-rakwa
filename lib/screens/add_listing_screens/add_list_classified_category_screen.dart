import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakwa/api/api_controllers/list_api_controller.dart';
import 'package:rakwa/controller/custom_field_getx_controller.dart';
import 'package:rakwa/model/all_categories_model.dart';
import 'package:rakwa/model/create_item_model.dart';
import 'package:rakwa/model/details_calssified_model.dart';
import 'package:rakwa/screens/add_listing_screens/Controllers/add_work_controller.dart';
import 'package:rakwa/screens/add_listing_screens/add_list-classified_subcategory_screen.dart';
import 'package:rakwa/screens/add_listing_screens/add_list_category_screen.dart';
import 'package:rakwa/screens/add_listing_screens/add_list_subcategory_screen.dart';
import 'package:rakwa/screens/add_listing_screens/add_list_title_screen.dart';
import 'package:rakwa/Core/utils/helpers.dart';
import 'package:rakwa/widget/appbars/app_bars.dart';
import 'package:shimmer/shimmer.dart';

import '../../app_colors/app_colors.dart';
import '../../controller/list_controller.dart';
import '../../widget/next_step_button.dart';
import '../../widget/steps_widget.dart';

class AddListClassifiedCategoryScreen extends StatefulWidget {
  DetailsClassifiedModel? detailsModel;
   AddListClassifiedCategoryScreen({this.detailsModel});

  @override
  State<AddListClassifiedCategoryScreen> createState() => _AddListClassifiedCategoryScreenState();
}

class _AddListClassifiedCategoryScreenState extends State<AddListClassifiedCategoryScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Get.put(AddWorkOrAdsController(isList: false));
    if(AddWorkOrAdsController.to.edit.value){
      // websiteController
      // facebookController
      // instagramController
      // twitterController
      // linkedInController
      for(int i  = 0; i < widget.detailsModel!.classified!.allCategories!.length; i++){
        AddWorkOrAdsController.to.selectedCategoriesIds.add(widget.detailsModel!.classified!.allCategories![i].id ?? -1);
      }

      print(AddWorkOrAdsController.to.selectedCategoriesIds);
      AddWorkOrAdsController.to.adId.value = widget.detailsModel!.classified!.id.toString() ?? "";
      AddWorkOrAdsController.to.titleController.text = widget.detailsModel!.classified!.itemTitle ?? "";
      AddWorkOrAdsController.to.descriptionController.text = widget.detailsModel!.classified!.itemDescription ?? "";
      AddWorkOrAdsController.to.locationController.text = widget.detailsModel!.classified!.itemAddress ?? "";
      AddWorkOrAdsController.to.countryController.text = widget.detailsModel!.classified!.country!.countryName ?? "";
      AddWorkOrAdsController.to.countryID = widget.detailsModel!.classified!.country!.id ?? -1;
      AddWorkOrAdsController.to.stateID = widget.detailsModel!.classified!.state!.id ?? -1;
      AddWorkOrAdsController.to.cityID = widget.detailsModel!.classified!.city!.id ?? -1;
      AddWorkOrAdsController.to.stateController.text = widget.detailsModel!.classified!.state!.stateName ?? "";
      AddWorkOrAdsController.to.cityController.text = widget.detailsModel!.classified!.city!.cityName ?? "";
      AddWorkOrAdsController.to.priceController.text = widget.detailsModel!.classified!.itemPrice ?? "";
      AddWorkOrAdsController.to.featureImage = widget.detailsModel!.classified!.itemImage ?? "";
      AddWorkOrAdsController.to.phoneController.text = widget.detailsModel!.classified!.itemPhone ?? "";
      AddWorkOrAdsController.to.websiteController.text = widget.detailsModel!.classified!.itemWebsite ?? "";
      AddWorkOrAdsController.to.facebookController.text = widget.detailsModel!.classified!.itemSocialFacebook ?? "";
      AddWorkOrAdsController.to.instagramController.text = widget.detailsModel!.classified!.itemSocialInstagram ?? "";
      AddWorkOrAdsController.to.twitterController.text = widget.detailsModel!.classified!.itemSocialTwitter ?? "";
      AddWorkOrAdsController.to.linkedInController.text = widget.detailsModel!.classified!.itemSocialLinkedin ?? "";

      // AddWorkOrAdsController.to.featureImage = "https://www.rakwa.com/laravel_project/public/storage/item/alaarby-llaaod-2022-12-15-639ab9f68697e.jpg";
      AddWorkOrAdsController.to.featureImage = "https://www.rakwa.com/laravel_project/public/storage/item/${widget.detailsModel!.classified!.itemImage}";

      print("Image:: ${AddWorkOrAdsController.to.featureImage}");
      for(int i = 0;i < widget.detailsModel!.classified!.galleries!.length; i++){
        AddWorkOrAdsController.to.imageGallery.add("https://www.rakwa.com/laravel_project/public/storage/item/gallery/${widget.detailsModel!.classified!.galleries![i].itemImageGalleryName ?? ""}");

      }

    }

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
    Get.put(ListController());
    final AddWorkOrAdsController addWordController =
    Get.put(AddWorkOrAdsController(isList: false));
    return Scaffold(
      appBar: AppBars.appBarDefault(title: AddWorkOrAdsController.to.edit.value  ? "تعديل اعلان" : "إضافة اعلان"),
      floatingActionButton: AddWorkOrAdsController.to.edit.value ? FloatingActionButtonNext(
        onTap: () {
          Get.to(
                  () => AddListClassifiedSubCategoryScreen(
                categoryId: addWordController
                    .parentCategory,
              ));

        },
      ) : null,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Expanded(
              child: FutureBuilder<List<AllCategoriesModel>>(
                future: ListApiController().getClassifiedCategory(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Shimmer.fromColors(
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
                        ));
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          GridView.builder(
                            padding: EdgeInsets.zero,

                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.length,
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
                                  addWordController.setParentCategory(
                                    snapshot.data![index].id ?? -1,
                                  );
                                  addWordController.setCategoriesIds(
                                      snapshot.data![index].id ?? -1);
                                  AddWorkOrAdsController.to.edit.value ? null :  Get.to(
                                        () => AddListClassifiedSubCategoryScreen(
                                      categoryId: addWordController
                                          .parentCategory,
                                    ),
                                  );
                                  },
                                borderRadius: BorderRadius.circular(8),
                                child: GetBuilder<AddWorkOrAdsController>(
                                  id: 'update_Classified_categories_ids',
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
                                          color: _.selectedCategoriesIds
                                              .contains(snapshot
                                              .data![index]
                                              .id)
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
                                          snapshot.data![index]
                                                      .categoryImage !=
                                                  null
                                              ? Image.network(
                                                  'https://www.rakwa.com/laravel_project/public/storage/category/${snapshot.data![index].categoryImage}',
                                                  height: 50,
                                                  width: 50,
                                                )
                                              : SizedBox(),
                                          Text(
                                            snapshot.data![index]
                                                .categoryName ?? "",
                                            textAlign: TextAlign.center,
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
                                }),
                              );
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const Center(child: Text('لا توجد تصنيفات'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}