import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import '../widget/main_elevated_button.dart';

class AcceptTermsScreen extends StatefulWidget {

  @override
  State<AcceptTermsScreen> createState() => _AcceptTermsScreenState();
}

class _AcceptTermsScreenState extends State<AcceptTermsScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
    Get.put(AddWorkOrAdsController(isList: true));

    // final AddWorkOrAdsController addWordController =
    //     Get.put(AddWorkOrAdsController(isList: true));
    // printDM("addWordController.selectedCategoryId is ${addWordController.selectedCategoryId}");
    return Scaffold(
      appBar: AppBars.appBarDefault(
          title:  'إضافة عمل'
      ),
      // floatingActionButton: FloatingActionButtonNext(
      //   onTap: () {
      //     if(AddWorkOrAdsController.to.selectedCategoriesIds.isEmpty){
      //       ShowMySnakbar(
      //           title: 'خطا',
      //           message: 'يجب اختيار التصنيف الرئيسي',
      //           backgroundColor: Colors.red.shade700);
      //     }else{
      //       Get.to(AddListSubCategoryScreen(categoryId: AddWorkOrAdsController.to.selectedCategoryID.value));
      //     }
      //     // addWorkController.navigationAfterSelectSubCategories();
      //
      //
      //   },
      // ),
      body: GetX<AddWorkOrAdsController>(
        builder: (controller) {
          return ListView(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 16.w),
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: controller.terms.length,
                  itemBuilder: (context , index){
                return Text(controller.terms[index].description ?? "", style: GoogleFonts.notoKufiArabic(
                  textStyle:  TextStyle(
                    color: Colors.black,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),);
              }),

              MainElevatedButton(
                height: 48.h,
              width: Get.width,
              borderRadius: 5.r,
              onPressed: () async { 
                  
                  
                bool success = await ListApiController().acceptTerms(termId: controller.terms.first.id.toString());
                
                success ? Get.to(AddListTitleScreen(isList: true)) : null;
                
                },
             
     
              child: Text("موافق", style: GoogleFonts.notoKufiArabic(
                textStyle:  TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),),)
            ],
          );
        }
      )
    );
  }
}
