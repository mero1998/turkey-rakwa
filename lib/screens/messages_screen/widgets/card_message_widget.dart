import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakwa/app_colors/app_colors.dart';
import 'package:rakwa/model/messages_model.dart';
import 'package:rakwa/screens/details_screen/details_screen.dart';



class CardMessage extends StatelessWidget {
  final bool isMe;
  final Message message;
  final String itemId;

  const CardMessage({
    Key? key,
    required this.message,
    required this.isMe,
    required this.itemId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(left: 14.w, right: 14.w, top: 10.h, bottom: 10.h),
      child: Row(
        children: [
          InkWell(
            onTap: (){
              !isMe ? Get.to(DetailsScreen(id: itemId)) : null;
            },
            child: Align(
              alignment: isMe ? Alignment.topRight : Alignment.topLeft,

              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Image.network(
                  'https://www.rakwa.com/laravel_project/public/storage/user/${message.user.userImage}',
                  height: 50.h,
                  width: 50.w,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    "images/defoultAvatar.png",
                    height: 50.h,
                    width: 50.w,
                    fit: BoxFit.cover,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: isMe ? Alignment.topRight : Alignment.topLeft,
              child: Container(
                padding:  EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                // constraints: BoxConstraints(
                //   // maxWidth: Get.width * .6,
                // ),
                decoration: BoxDecoration(
                    gradient:isMe? AppColors.mainGradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                         Colors.grey.shade200,
                        Colors.grey.shade200,
                      ],
                    ),
                  borderRadius: BorderRadius.only(
                    bottomRight:  Radius.circular(30.r),
                    bottomLeft:  Radius.circular(30.r),
                    topRight: Radius.circular(isMe ? 0 : 30.r),
                    topLeft: Radius.circular(isMe ? 30.r : 0),
                  ),
                ),
                child: Align(
                  alignment: isMe ? Alignment.topRight : Alignment.topLeft,

                  child: Text(
                    message.body,
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: isMe ? TextAlign.start : TextAlign.end,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
