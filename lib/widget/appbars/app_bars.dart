import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakwa/widget/SVG_Widget/svg_widget.dart';

class AppBars {
  static AppBar appBarDefault(
      {bool isBack = true,
      bool isLogo = false,
      TabBar? tabBar,
        Color titleColor = Colors.black,
      String title = '',
     // required   BuildContext context,
      Widget secondIconImage = const SizedBox(
        width: 0,
      ),
      VoidCallback? onTap}) {
    return AppBar(

      title: isLogo
          ?  IconJpg(
              'rakwaLogo',
              size: 42.w,
            )
          : Text(
              title,
              style: GoogleFonts.notoKufiArabic(
                textStyle:  TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                  color: titleColor,
                ),
              ),
            ),
      backgroundColor: Colors.transparent,
      centerTitle: true,
      elevation: 0.0,
      leading: isBack == false
          ? const SizedBox()
          : IconButton(
              onPressed: () {

                onTap != null ? onTap():
                Get.back(result: true,);
                // Navigator.pop(context,true);
              },
              icon: const Directionality(
                textDirection: TextDirection.ltr,
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black,
                ),
              ),
            ),
      actions: [
        secondIconImage,
      ],
      bottom: tabBar,
    );
  }
}
