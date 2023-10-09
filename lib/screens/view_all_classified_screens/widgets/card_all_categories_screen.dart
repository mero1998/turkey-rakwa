import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakwa/app_colors/app_colors.dart';


class CardAllCategoriesScreen extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback onTap;

  const CardAllCategoriesScreen({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 24.r,
                  child: Center(
                    child: Image.network(
                      'https://www.rakwa.com/laravel_project/public/storage/category/$icon',
                      height: 40.h,
                      width: 40.w,
                    ),
                  ),
                ),
                 SizedBox(width: 16.h),
                Text(
                  title,
                  style: GoogleFonts.notoKufiArabic(
                    textStyle:  TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
             Icon(Icons.arrow_back_ios_new_outlined,color: AppColors().mainColor,size: 18.sp,),
          ],
        ),
      ),
    );
  }
}