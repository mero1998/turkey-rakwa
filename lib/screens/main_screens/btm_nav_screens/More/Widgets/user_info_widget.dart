import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakwa/Core/utils/extensions.dart';
import 'package:rakwa/app_colors/app_colors.dart';
import 'package:rakwa/controller/email_verified_getx_controller.dart';
import 'package:rakwa/screens/main_screens/btm_nav_screens/personal_screen.dart';
import 'package:rakwa/shared_preferences/shared_preferences.dart';

class UserInfoWidget extends StatelessWidget {
  const UserInfoWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => const PersonalScreen()),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding:  EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors().mainColor.withOpacity(.06),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //
            //   ],
            // ),

        GetX<UserProfileGetxController>(
          builder: (controller) {
            return    controller.isLoading.value  ? Center(child: CircularProgressIndicator(),) :
            controller.profile.first.data!.userImage != ""  ? Expanded(
              flex: 0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      'https://www.rakwa.com/laravel_project/public/storage/user/${UserProfileGetxController.to.profile.first.data!.userImage}',
                      height: 80.h,
                      width: 72.w,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        "images/defoultAvatar.png",
                        height: 80.h,
                        width: 72.w,
                        fit: BoxFit.cover,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ) : Image.asset(
              "images/defoultAvatar.png",
              height: 80.h,
              width: 72.w,
              fit: BoxFit.cover,
            );
          }
        ),
             SizedBox(width: 7.w),
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    SharedPrefController().name,
                    style: GoogleFonts.notoKufiArabic(
                      textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    SharedPrefController().email,
                    style: GoogleFonts.notoKufiArabic(
                      textStyle:  TextStyle(
                        color: Colors.black,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
             Expanded(
               flex: 0,
               child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 16,
                child: Center(
                  child: Icon(
                    Icons.arrow_back_ios_new_outlined,
                    color: AppColors().mainColor,
                  ),
                ),
            ),
             )
          ],
        ),
      ),
    );
  }
}
