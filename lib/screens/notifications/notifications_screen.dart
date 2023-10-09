import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakwa/api/api_controllers/item_api_controller.dart';
import 'package:rakwa/app_colors/app_colors.dart';
import 'package:rakwa/controller/notifcations_getx_controller.dart';
import 'package:rakwa/model/item_by_id_model.dart';
import 'package:rakwa/screens/details_screen/details_screen.dart';
import 'package:rakwa/widget/appbars/app_bars.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../../widget/home_widget.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  Get.put(NotificationsGetXController());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  Get.delete<NotificationsGetXController>();
  }
  @override
  Widget build(BuildContext context) {
    return GetX<NotificationsGetXController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBars.appBarDefault(title: "الاشعارات"),
          body: controller.isLoading.value ? Center(child: CircularProgressIndicator(),) : controller.notification.isEmpty ? Center(child: Text("لا يوجد اشعارات"),) :
          ListView.builder(
            reverse: true,
              itemCount: controller.notification.first.notification!.length,
              itemBuilder: (context, index){
            return Container(
              // height: 100.h,
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.kCTFEnableBorder,
                borderRadius: BorderRadius.circular(7.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: Offset(0,2),
                    blurRadius: 12,
                    // spreadRadius: 6
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                  width: 50.w,
                height: 40.h,
                child:  Image.asset("images/logo2.png"),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(7),
                    ),

                  ),

                  SizedBox(width: 10.w,),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.notification.first.notification![index].title ?? "",
                          style: GoogleFonts.notoKufiArabic(
                              color: AppColors.bottonNavBarColor),
                        ),
                        SizedBox(height: 7.h,),
                        Text(
                            controller.notification.first.notification![index].content?? "",
                          style: GoogleFonts.notoKufiArabic(
                              color: AppColors.drawerColor),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Text(
                       getDate(notificationDate: controller.notification.first.notification![index].createdAt ?? "",).toString().replaceAll(".000+0300", ""),
                      style: GoogleFonts.notoKufiArabic(
                          color: AppColors().mainColor,
                      fontSize: 10.sp),
                    ),
                  ),
                ],
              ),
            );
          })
        );
      }
    );
  }
  getDate({required String notificationDate}){

    // _getPSTTime();
    // print("Time::: ${_getPSTTime()}");
    tz.initializeTimeZones();

    final f = DateFormat('HH:mm a');
    final pacificTimeZone = tz.getLocation('Europe/Istanbul');

    var date = DateTime.parse(notificationDate);
    String s = f.format(date);
    print(s);
    return tz.TZDateTime.from(date, pacificTimeZone);

  }
}
