import 'dart:io';

import 'package:ensure_visible_when_focused/ensure_visible_when_focused.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rakwa/Core/utils/extensions.dart';
import 'package:rakwa/api/api_controllers/subscribtion_api_controller.dart';
import 'package:rakwa/controller/all_ads_getx_controller.dart';
import 'package:rakwa/controller/all_subscribtions_getx_controller.dart';
import 'package:rakwa/controller/search_item_controller.dart';
import 'package:rakwa/screens/ads/user_ads_details_screen.dart';
import 'package:rakwa/widget/appbars/app_bars.dart';
import 'package:shimmer/shimmer.dart';
// import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';

import '../../app_colors/app_colors.dart';
import '../../controller/image_picker_controller.dart';
import '../../controller/list_controller.dart';
import '../../widget/ButtomSheets/base_bottom_sheet.dart';
import '../../widget/ButtomSheets/row_select_item.dart';
import '../../widget/TextFields/text_field_default.dart';
import '../../widget/TextFields/validator.dart';
import '../../widget/main_elevated_button.dart';
import '../add_listing_screens/Widget/bottom_sheet_state.dart';


class UserAdsScreen extends StatefulWidget {
  const UserAdsScreen({Key? key}) : super(key: key);

  @override
  State<UserAdsScreen> createState() => _UserAdsScreenState();
}

class _UserAdsScreenState extends State<UserAdsScreen> {

  ListController listController = Get.put(ListController());
  VideoPlayerController?  videoPlayerController;
  XFile? image;
  XFile? video;
  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  TextEditingController stateController = TextEditingController();

  FocusNode websiteNode =FocusNode();
  FocusNode videoNode =FocusNode();
  FocusNode stateNode =FocusNode();
  // ScrollController _workaroundScrCntrToFixFocusIssue= ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  Get.put(AllAdsGetxController());

  // Get.put(ImagePickerController());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars.appBarDefault(title: "اعلاناتي"),
      body: GetX<AllAdsGetxController>(
        builder: (controller) {
          return controller.loading.value ? Shimmer.fromColors(
              baseColor: Colors.grey.shade100,
              highlightColor: Colors.grey.shade300,
              child:ListView.builder(
                  itemCount: 2,
                  itemBuilder: (context , index){
                return Container(
                  width: double.infinity,
                  height: 150.h,
                  color: Colors.grey,
                  margin: EdgeInsets.all(20),
                );
              }) ) : controller.userAds.isNotEmpty? ListView.separated(
                padding: const EdgeInsets.all(16),
            reverse: true,

            shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: controller.userAds.length,
                  itemBuilder: (context, index){
                    return InkWell(
                      onTap: (){

                        Get.to(UserAdsDetailsScreen(ads: controller.userAds[index]));
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 16.h),
                        decoration: BoxDecoration(
                            // border: Border.all(
                            //     color: controller.subscriptionId.value == controller.sub[index].id ?  AppColors().mainColor : Color(0xFFF4F4F4)
                            //   // color: Color(0xFFF4F4F4)
                            // )
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(controller.userAds[index].subscription!.name ?? "",
                                    style: GoogleFonts.notoKufiArabic(
                                      textStyle: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,

                                        color: Colors.black,
                                      ),),),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(controller.userAds[index].createdAt ?? "",
                                        style: GoogleFonts.notoKufiArabic(
                                          textStyle: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.bold,

                                            color: Colors.black,
                                          ),),),
                                      Row(
                                        children: [

                                          Text(controller.userAds[index].enabled == 0 ? 'قيد المراجعة' : controller.userAds[index].enabled== 1 ? "فعال" : controller.userAds[index].enabled == 2 ? "تم ايقافه من طرفك": controller.userAds[index].enabled == 4 ? "مرفوض" : "مكتمل",
                                            style: GoogleFonts.notoKufiArabic(
                                              textStyle: TextStyle(
                                                fontSize: 12.sp,
                                                // fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),),),

                                          // SizedBox(width: 10.w,),
                                          Container(
                                            width: 10.w,
                                            height: 10.h,
                                            margin: EdgeInsetsDirectional.only(start: 5.w),
                                            decoration: BoxDecoration(
                                                color: controller.userAds[index].enabled == 0 ? Colors.orange : controller.userAds[index].enabled== 1 ? Colors.green : controller.userAds[index].enabled == 2 ? Colors.grey: Colors.red,
                                                shape: BoxShape.circle
                                            ),
                                          )
                                        ],

                                      ),
                                    ],
                                  ),
                                ],
                              ),



                            ],
                          ),
                        ),
                      ),
                    );

                  }, separatorBuilder: (BuildContext context, int index) {
                  return Divider();
          },) : Center(child:   Text("لا يوجد لديك اعلانات",
            style: GoogleFonts.notoKufiArabic(
              textStyle: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,

                color: Colors.black,
              ),),),);
        }
      ),
    );
  }
}
