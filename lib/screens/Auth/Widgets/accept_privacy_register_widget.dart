import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakwa/app_colors/app_colors.dart';
import 'package:rakwa/screens/Auth/Controllers/sign_up_controller.dart';
import 'package:rakwa/screens/contact_about_screens/privacy_policy_screen.dart';



class AcceptPrivacyRegisterWidget extends StatelessWidget {
  const AcceptPrivacyRegisterWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool accept = false;
    return InkWell(
      onTap: () {
        Get.to(() => const PrivacyPolicyScreen());
      },
      borderRadius: BorderRadius.circular(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GetX<SignUpController>(
            builder: (c) {
              return Transform.scale(
                scale: 1.1.h,
                child: Checkbox(value: c.accept.value, onChanged: (value){
                  c.accept.value = value!;
                },activeColor: AppColors().mainColor,),
              );
            }
          ),
          Expanded(
            child: RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                text: 'هل انت موافق على ',
                style: GoogleFonts.notoKufiArabic(
                  textStyle:  TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.subTitleColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: ' شروط الخدمة وسياسة الخصوصية',
                    style: GoogleFonts.notoKufiArabic(
                      textStyle:  TextStyle(
                        fontSize: 12.sp,
                        color: AppColors().mainColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
