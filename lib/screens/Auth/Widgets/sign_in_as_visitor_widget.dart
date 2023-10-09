import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakwa/app_colors/app_colors.dart';

class SignInAsVisitor extends StatelessWidget {
  const SignInAsVisitor({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        overlayColor:
            MaterialStateColor.resolveWith((states) => AppColors().mainColor.withOpacity(.04)),
      ),
      onPressed: () {
        Get.toNamed('/main_screen');
      },
      child: Text(
        'الاستمرار كضيف',
        style: GoogleFonts.notoKufiArabic(
          textStyle: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: AppColors().mainColor,
          ),
        ),
      ),
    );
  }
}
