import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakwa/Core/utils/extensions.dart';
import 'package:rakwa/api/api_controllers/home_api_controller.dart';
import 'package:rakwa/api/api_controllers/profile_api_controller.dart';
import 'package:rakwa/app_colors/app_colors.dart';
import 'package:rakwa/controller/email_verified_getx_controller.dart';
import 'package:rakwa/controller/home_getx_controller.dart';
import 'package:rakwa/controller/location_controller.dart';
import 'package:rakwa/screens/main_screens/btm_nav_screens/Home/Widgets/search_widget.dart';
import 'package:rakwa/screens/main_screens/btm_nav_screens/personal_screen.dart';
import 'package:rakwa/screens/nearby_screen/nearby_screen.dart';
import 'package:rakwa/screens/view_all_item_screens/view_all_nearest_item_screen.dart';
import 'package:rakwa/shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../widget/SVG_Widget/svg_widget.dart';
import '../../More/Widgets/card_more_screen.dart';

class TopHomeScreenWidget extends StatelessWidget {
  const TopHomeScreenWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      // height:  240.h,
      width: Get.width,
      child: Stack(
        children: [
          Positioned(
            bottom: 20.h,
            child: FutureBuilder<String?>(
              future: HomeApiController().getBackgroundImage(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Image.asset(
                    'images/hoem.png',
                    fit: BoxFit.cover,
                    width: Get.width,
                  );
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return Image.network(
                    snapshot.data!,
                    width: Get.width,
                    // height: 230.h,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      'images/hoem.png',
                      fit: BoxFit.contain,
                      width: Get.width,
                    ),
                  );
                } else {
                  return Image.asset(
                    'images/hoem.png',
                    fit: BoxFit.cover,
                    width: Get.width,
                  );
                }
              },
            ),
          ),

          Positioned.fill(
            bottom: 20.h,
            child: Opacity(
              opacity: 0.25,
              child: Container(
                color: const Color(0xFF000000),
              ),
            ),
          ),
          Positioned(
            top: 50.h,
            right: 16.w,
            child: Column(
              children: [
                Text(
                  'نحن نعرف المكان',
                  style: GoogleFonts.notoKufiArabic(
                      fontSize: 15.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
                // 6.ESH(),
                InkWell(
                  onTap: () async {
                    Get.to(
                      () => ViewAllNearestItemScreen(),
                    );
                  },
                  child: Container(
                    padding:
                         EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                        color: AppColors().mainColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'اعمال بالقرب منك',
                          style: GoogleFonts.notoKufiArabic(
                              fontSize: 10.sp,
                              color: Colors.white, fontWeight: FontWeight.w500),
                        ),
                        8.ESW(),
                         Icon(
                          Icons.location_on_rounded,
                          size: 15.w,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: (Get.height * .05),
            left: 24.w,
            child: GetX<UserProfileGetxController>(
              builder: (controller) {
                return InkWell(
                  onTap: () {
                    Get.to(() => const PersonalScreen());
                  },
                  child:  Visibility(
                    visible: SharedPrefController().isLogined,
                    child: Center(
      child: controller.isLoading.value  ? Center(child: CircularProgressIndicator(),) : controller.profile.first.data!.userImage != null ?
      CircleAvatar(
                              backgroundColor: AppColors.labelColor.withOpacity(0.4),
                              backgroundImage: NetworkImage(
                                  'https://www.rakwa.com/laravel_project/public/storage/user/${controller.profile.first.data!.userImage}'),
                              radius: 25.r,
                            ):  CircleAvatar(
      backgroundColor: Colors.transparent,
      backgroundImage: AssetImage('images/defoultAvatar.png'),
      radius: 25.r,
      ),
                    ),
                      )
                );
              }
            )
          ),
          Positioned(
            bottom: 0.h,
            left: 16.w,
            right: 16.w,
            child: SearchWidget(
              isItem: true,
            ),
          ),
        ],
      ),
    );
  }
}
