import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakwa/api/api_controllers/auth_api_controller.dart';
import 'package:rakwa/app_colors/app_colors.dart';
import 'package:rakwa/screens/add_listing_screens/add_list_category_screen.dart';
import 'package:rakwa/shared_preferences/shared_preferences.dart';
import 'package:rakwa/Core/utils/helpers.dart';
import 'package:rakwa/widget/SnackBar/custom_snack_bar.dart';
import 'package:rakwa/widget/main_elevated_button.dart';

class CardAddWork extends StatefulWidget {
  const CardAddWork({Key? key}) : super(key: key);

  @override
  State<CardAddWork> createState() => _CardAddWorkState();
}

class _CardAddWorkState extends State<CardAddWork> with Helpers {
  bool hide = false;

  @override
  Widget build(BuildContext context) {

    print("hide;; ${hide}");
    return SharedPrefController().verifiedEmail != 'null' && SharedPrefController().roleId == 1
        ? Visibility(
      visible: !hide,
      child: Container(
              height: 116.h,
              margin:  EdgeInsets.symmetric(horizontal: 16.w,vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColors().mainColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding:  EdgeInsets.only(right: 25.0.w),
                        child: Text(
                          'أضف عملك الآن بشكل مجاني',
                          style: GoogleFonts.notoKufiArabic(
                            textStyle:  TextStyle(
                          fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            hide = true;
                          });

                          print("Hide: ${hide}");
                        },
                        icon: const Icon(
                          Icons.cancel_outlined,
                          color: AppColors.describtionLabel,
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding:  EdgeInsets.only(right: 25.0.w),
                    child: MainElevatedButton(
                      height: 44.h,
                      width: 180.w,
                      borderRadius: 4.r,
                      onPressed: () async {
                        if (SharedPrefController().roleId == 3) {
                          Get.to(() =>  AddListCategoryScreen());
                        } else if (SharedPrefController().roleId == 2) {
                          alertDialogRoleAuthUser(context);
                        } else {
                          AlertDialogUnAuthUser(context);
                        }

                        // bool state =
                        //     await AuthApiController().emailVerification();
                        // if (state) {
                        //   setState(() {});
                        // }
                      },
                      child: Text(
                        'أضف عملك الآن',
                        style: GoogleFonts.notoKufiArabic(
                          textStyle:  TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
    fontSize: 12.sp
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
        )
        : SharedPrefController().verifiedEmail != 'null' ? Container() : Visibility(
      visible: !hide,
      child: Container(
              height: 116.h,
              margin:  EdgeInsets.symmetric(horizontal: 16,vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColors().mainColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding:  EdgeInsets.only(right: 25.w),
                        child: Text(
                          'يجب عليك تاكيد حسابك',
                          style: GoogleFonts.notoKufiArabic(
                              textStyle:  TextStyle(
                                  fontSize: 14.sp, fontWeight: FontWeight.w700)),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            hide = true;
                          });
                        },
                        icon: const Icon(
                          Icons.cancel_outlined,
                          color: AppColors.describtionLabel,
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding:  EdgeInsets.only(right: 25.0.w),
                    child: MainElevatedButton(
                      height: 44.h,
                      width: 180.w,
                      borderRadius: 4.r,
                      onPressed: () async {
                        bool state =
                            await AuthApiController().emailVerification();

                        if (state) {
                          // bool status = await AuthApiController().logout();
                          customSnackBar(
                            title: 'تمت العملية بنجاح',
                            subtitle:
                                'يرجى مراجعة بريدك الالكتروني وتسجيل الدخول مره اخرى',
                          );

                        } else {
                          customSnackBar(
                            title: 'خطا',
                            subtitle: 'يرجى المحاولة لاحقا',
                            isWarning: true,
                          );
                        }
                      },
                      child: Text(
                        'قم بتاكيد حسابك',
                        style: GoogleFonts.notoKufiArabic(
                            textStyle:  TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500)),
                      ),
                    ),
                  )
                ],
              ),
            ),
        );
  }
}
