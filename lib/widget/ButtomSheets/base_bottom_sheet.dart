

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakwa/app_colors/app_colors.dart';

class BaseBottomSheet extends StatelessWidget {
   Widget widget;
   double height;
   String bottomSheetTitle;
   BaseBottomSheet({required this.widget,
     this.height =480,
     required this.bottomSheetTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.r),
          topLeft: Radius.circular(20.r),
        ),
      ),
      child: Column(
        children: [
          const DividerBottomSheet(),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 16.h),
            child: Align(
              alignment: Alignment.topRight,
              child: Text(
                  bottomSheetTitle,
                  style: GoogleFonts.notoKufiArabic(
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )
              ),
            ),
          ),
          widget,
        ],
      ),
    );
  }
}

class DividerBottomSheet extends StatelessWidget {
  const DividerBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(bottom: 12.h,top: 14.h),
      child: Center(
        child: Container(
          height: 3.h,
          width: 50.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
