import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakwa/app_colors/app_colors.dart';
import 'package:rakwa/widget/SVG_Widget/svg_widget.dart';


class CardMoreScreen extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback onTap;

  const CardMoreScreen({
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
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconSvg(
                  icon,
                  size: 20.w,
                  // color: Colors.transparent,
                ),
                 SizedBox(width: 16.w),
                Text(
                  title,
                  style: GoogleFonts.notoKufiArabic(
                    textStyle:  TextStyle(
                      color: Colors.black,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
             Icon(Icons.arrow_back_ios_new_outlined,color: AppColors().mainColor,size: 16.w,),

          ],
        ),
      ),
    );
  }
}