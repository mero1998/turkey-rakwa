import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakwa/widget/SVG_Widget/svg_widget.dart';
import '../app_colors/app_colors.dart';

class CategoryWidget extends StatelessWidget {
  final String categoryName;
  final String? image;
  final int index;
  final bool isMore;

  List colors = const [
    Color.fromARGB(255, 224, 20, 81),
    Color.fromARGB(255, 45, 106, 228),
    Color.fromARGB(255, 159, 6, 254),
    Color.fromARGB(255, 219, 242, 12),
    Color.fromARGB(255, 224, 20, 81),
    Color.fromARGB(255, 45, 106, 228),
    Color.fromARGB(255, 159, 6, 254),
    Color.fromARGB(255, 219, 242, 12)
  ];

  CategoryWidget(
      {required this.categoryName,
      required this.image,
      this.index = 1,
      this.isMore = false});

  @override
  Widget build(BuildContext context) {
    return Container(

      padding: EdgeInsets.zero,
      // alignment: Alignment.center,
      margin: EdgeInsetsDirectional.only(end: isMore ?  0 : 10.w,),
      // padding: EdgeInsets.all(5),
      decoration: BoxDecoration(

        // color: Colors.white,
        borderRadius: BorderRadius.circular(4),

      ),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          !isMore
              ? image != null && image!.isNotEmpty
                  ? Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                          'https://www.rakwa.com/laravel_project/public/storage/category/${image!}',
                          height: 10.h,
                          width: 50.w,
                        fit: BoxFit.contain,
                        errorBuilder:(context, error, stackTrace) =>  Icon(Icons.category,size: 15.w) ,
                        ),
                      ),
                  )
                  :  Icon(Icons.category,size: 16.w,)
              :  Expanded(
                child: IconSvg(
                  fit: BoxFit.contain,
                  height: 20.h,
                  width: 20.w,
                    "more",
                  ),
              ),
           SizedBox(
            height: 4.h,
          ),
          Text(
            categoryName,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.notoKufiArabic(
                textStyle:
                     TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w400)),
          )
        ],
      ),
    );
  }
}