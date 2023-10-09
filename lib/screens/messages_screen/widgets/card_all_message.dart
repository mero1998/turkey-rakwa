
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakwa/Core/utils/extensions.dart';
import 'package:rakwa/app_colors/app_colors.dart';
import 'package:rakwa/model/all_messages_model.dart';
import 'package:rakwa/screens/messages_screen/show_messages_screen.dart';


class CardAllMessage extends StatelessWidget {
  final AllMessagesModel allMessages;

  const CardAllMessage({
    Key? key,
    required this.allMessages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 16.w),
      child: InkWell(
        onTap: () {
          Get.to(
                () => ShowMessagesScreen(
              messageId: allMessages.id.toString(),
              subject: allMessages.subject!,
            ),
          );
        },
        child: Container(
          padding:  EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      allMessages.subject!,
                      style: GoogleFonts.notoKufiArabic(
                        textStyle:  TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    allMessages.createdAt!.split(" ").elementAt(1),
                    style: GoogleFonts.notoKufiArabic(
                      textStyle:  TextStyle(
                          fontSize: 14.sp, color: AppColors.labelColor),
                    ),
                  ),
                ],
              ),
              6.ESH(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    allMessages.createdAt!.split(" ").elementAt(0),
                    style: GoogleFonts.notoKufiArabic(
                      textStyle:  TextStyle(
                          fontSize: 14.sp, color: AppColors.labelColor),
                    ),
                  ),
                  0.ESH(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
