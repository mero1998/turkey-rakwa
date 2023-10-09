import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakwa/Core/utils/extensions.dart';
import 'package:rakwa/app_colors/app_colors.dart';

class TitleAndSeeAllWidget extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAllTap;
  final bool avalibleSeeAll;

  const TitleAndSeeAllWidget({
    Key? key,
    required this.title,
     this.onSeeAllTap,
    this.avalibleSeeAll =true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.notoKufiArabic(
                textStyle:
                     TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
          ),
          avalibleSeeAll?
          InkWell(
            onTap: onSeeAllTap,
            borderRadius: BorderRadius.circular(4),
            child: Container(
              padding:  EdgeInsets.symmetric(vertical: 3, horizontal: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'مشاهدة الكل',
                style: GoogleFonts.notoKufiArabic(
                  textStyle:  TextStyle(
                    fontSize: 8.sp,
                    color: AppColors().mainColor,
                  ),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ):0.ESH()
        ],
      ),
    );
  }
}
