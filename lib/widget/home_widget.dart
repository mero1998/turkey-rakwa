import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/parser.dart';
import 'package:rakwa/Core/utils/extensions.dart';
import 'package:rakwa/widget/rate_stars_widget.dart';

import '../app_colors/app_colors.dart';

class HomeWidget extends StatelessWidget {
  final String title;
  final String location;
  final String? image;
  final String? itemType;
  final String discount;
  final dynamic rate;
  final bool doMargin;
  final Widget saveIcon;
  void Function()? onTap;
  void Function()? saveOnPressed;
  final double percentCardWidth;
  final bool isList;

  HomeWidget({
    super.key,
    required this.discount,
    required this.image,
    required this.itemType,
    required this.location,
    required this.title,
    required this.rate,
    this.onTap,
    this.saveOnPressed,
    this.isList = false,
    this.percentCardWidth = 0.8,

    this.saveIcon = const Icon(
      Icons.bookmark_outline_sharp,
      color: Colors.white,
    ),
    this.doMargin = true,
  });

  BorderRadiusGeometry imageBorderRadius = BorderRadius.only(
      topLeft: Radius.circular(12.r), topRight: Radius.circular(12.r));

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Material(
          elevation: 1,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            height:270.h, //236
            width: Get.width * percentCardWidth,
            decoration: BoxDecoration(
              boxShadow: AppBoxShadow.main,
              borderRadius: BorderRadius.circular(12.r),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Stack(
                  children: [
                    image != null
                        ? ClipRRect(
                            borderRadius: imageBorderRadius,
                            child: Image.network(
                              'https://www.rakwa.com/laravel_project/public/storage/item/$image',
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: Get.width,
                              errorBuilder: (BuildContext context, Object? exception, StackTrace? stackTrace) {
                                return Image.asset("images/logo.jpg",   height: double.infinity,
                                  width: Get.width,);
                              },
                            ),
                          )
                        // : Image.network(
                        //     'https://rakwa.com/theme_assets/frontend_assets/lduruo10_dh_frontend_city_path/placeholder/',
                        //     fit: BoxFit.fill,
                        //     width: Get.width,
                        //   ),
                        : ClipRRect(
                            borderRadius: imageBorderRadius,
                            child: Image.asset(
                              'images/logo.jpg',
                              fit: BoxFit.cover,
                              width: Get.width,
                            ),
                          ),
                    Positioned(
                        left: 13.w,
                        top: 10.h,
                        child: CircleAvatar(
                          backgroundColor: Colors.black38.withOpacity(0.5),
                          child: IconButton(
                            onPressed: saveOnPressed,
                            icon: saveIcon,
                            color: Colors.white,
                            // Icons.bookmark_outline_sharp,
                            // Icons.bookmark_outlined,
                            // color: Colors.black,)
                          ),
                        )),
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0.15,
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(12),
                                topLeft: Radius.circular(12)),
                            color: Color(0xFF000000),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
                Expanded(
                  child: Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 12.w),
                    child: Column(
                      children: [
                   SizedBox(height: 6.h,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                width: 250.w,
                                child: Text(
                                  title,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.notoKufiArabic(
                                      textStyle:  TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                  )),
                                ),
                              ),
                            ),
                            rate != '100'
                                ? Row(
                                    children: [
                                      Text(
                                        rate ?? '0',
                                        style: GoogleFonts.notoKufiArabic(
                                          textStyle:  TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                       SizedBox(
                                        width: 5.w,
                                      ),
                                      DisplayRateWidget(
                                          size: 15.sp,
                                          isRated: rate == null
                                              ? false
                                              : double.parse(rate!) >= 1
                                                  ? true
                                                  : false)
                                    ],
                                  )
                                : SizedBox()
                          ],
                        ),
                         SizedBox(
                          height: 8.h,
                        ),
                        Expanded(

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                               Icon(
                                Icons.description_outlined,
                                size: 12.w,
                                color: AppColors().mainColor,
                              ),
                              8.ESW(),
                              Expanded(
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxWidth: Get.width * .60,
                                  ),
                                  child: Text(
                                   _parseHtmlString(location),
                                    style: GoogleFonts.tajawal(
                                      textStyle:  TextStyle(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.viewAllColor,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    maxLines: 2,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        //  SizedBox(
                        //   height: 10.h,
                        // ),
                        // Spacer(),
                        // Row(
                        //   children: [
                        //     // Container(
                        //     //   padding: const EdgeInsets.symmetric(
                        //     //       horizontal: 3, vertical: 1),
                        //     //   decoration: BoxDecoration(
                        //     //       borderRadius: BorderRadius.circular(50),
                        //     //       color: AppColors.discountColor),
                        //     //   child: Text(
                        //     //     'خصم $discount %',
                        //     //     style: GoogleFonts.notoKufiArabic(
                        //     //         textStyle: const TextStyle(
                        //     //       fontSize: 10,
                        //     //       fontWeight: FontWeight.w500,
                        //     //     )),
                        //     //   ),
                        //     // ),
                        //     // const SizedBox(
                        //     //   width: 8,
                        //     // ),
                        //     Expanded(
                        //       child:
                        //     ),
                        //   ],
                        // ),
                        Align(
                          alignment: AlignmentDirectional.topStart,
                          child: Container(
                            // constraints: BoxConstraints(
                            //   maxWidth: Get.width * .8,
                            // ),
                            // width:100,
                            // padding:  EdgeInsets.symmetric(
                            //   horizontal: 7.w,
                            //   vertical: 2.h,
                            // ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: AppColors.blueLightColor,
                            ),
                            child: Text(
                              itemType != null ?
                              itemType!.split(",").join("-") : "",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.tajawal(
                                  textStyle:  TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                  )),
                            ),
                          ),
                        ),
                         SizedBox(
                          height: 15.h,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
  }
}


