import 'package:flutter/material.dart';import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakwa/api/api_controllers/item_api_controller.dart';
import 'package:rakwa/api/api_controllers/qustion_and_answer_api_controller.dart';
import 'package:rakwa/app_colors/app_colors.dart';
import 'package:rakwa/controller/notifcations_getx_controller.dart';
import 'package:rakwa/controller/questions_and_answer_getx_controller.dart';
import 'package:rakwa/controller/time_prayer_controller_getx.dart';
import 'package:rakwa/model/item_by_id_model.dart';
import 'package:rakwa/model/like.dart';
import 'package:rakwa/screens/details_screen/details_screen.dart';
import 'package:rakwa/screens/question_and_answer/create_question_screen.dart';
import 'package:rakwa/shared_preferences/shared_preferences.dart';
import 'package:rakwa/widget/TextFields/text_field_default.dart';
import 'package:rakwa/widget/appbars/app_bars.dart';

import '../../widget/home_widget.dart';

class TimerPrayerScreen extends StatefulWidget {
  const TimerPrayerScreen({super.key});

  @override
  State<TimerPrayerScreen> createState() => _TimerPrayerScreenState();
}

class _TimerPrayerScreenState extends State<TimerPrayerScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.put(TimePrayerGetXController());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Get.delete<TimePrayerGetXController>();
  }
  @override
  Widget build(BuildContext context) {
    return GetX<TimePrayerGetXController>(
        builder: (controller) {
          return Scaffold(
            backgroundColor: Colors.white,
              appBar: AppBars.appBarDefault(title: "أوقات الصلاة"),

              body: controller.isLoading.value ?
              Center(child: CircularProgressIndicator(),)
                  : controller.timePrayer.isEmpty ? Center(child: Text("لا يوجد بيانات حول منطقتك"),)
                  : SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding:  EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                      Text("${controller.timePrayer.first.data!.date!.hijri!.weekday!.ar ?? ""}",style: GoogleFonts.notoKufiArabic(
                                        textStyle:  TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                          overflow: TextOverflow.ellipsis,
                                          color: Colors.black,
                                        ),),),
                                  SizedBox(width: 5.w,),
                                  Text("${controller.timePrayer.first.data!.date!.gregorian!.date ?? ""}",style: GoogleFonts.notoKufiArabic(
                                    textStyle:  TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis,
                                      color: Colors.black,
                                    ),),),
                                ],
                              ),
                              // Row(
                              //   children: [
                              //     Text("${controller.timePrayer.first.data!.date!.hijri!.day ?? ""}",style: GoogleFonts.notoKufiArabic(
                              //       textStyle: const TextStyle(
                              //         fontSize: 14,
                              //         fontWeight: FontWeight.bold,
                              //         overflow: TextOverflow.ellipsis,
                              //         color: Colors.black,
                              //       ),),),
                              //     SizedBox(width: 5.w,),
                              //
                              //     Text("${controller.timePrayer.first.data!.date!.hijri!.month!.ar ?? ""}",style: GoogleFonts.notoKufiArabic(
                              //       textStyle: const TextStyle(
                              //         fontSize: 14,
                              //         fontWeight: FontWeight.bold,
                              //         overflow: TextOverflow.ellipsis,
                              //         color: Colors.black,
                              //       ),),),
                              //     SizedBox(width: 5.w,),
                              //
                              //     Text("${controller.timePrayer.first.data!.date!.hijri!.year ?? ""}",style: GoogleFonts.notoKufiArabic(
                              //     textStyle: const TextStyle(
                              //       fontSize: 14,
                              //       fontWeight: FontWeight.bold,
                              //       overflow: TextOverflow.ellipsis,
                              //       color: Colors.black,
                              //     ),),)
                              //   ],
                              // ),
                            ],

                          ),
                        ),


                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(20.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Table(
                              border: TableBorder.all(color: AppColors().mainColor),
                              children: [
                                TableRow(
                                    children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('الفجر',style: GoogleFonts.notoKufiArabic(
                                      textStyle: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis,
                                        color: Colors.black,
                                      ),
                                    ),),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(controller.timePrayer.first.data!.timings!.fajr ?? "",style: GoogleFonts.notoKufiArabic(
                                      textStyle:  TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis,
                                        color: Colors.black,
                                      ),
                                    ),),
                                  ),
                                ]),
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('الضحى',style: GoogleFonts.notoKufiArabic(
                                      textStyle:  TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis,
                                        color: Colors.black,
                                      ),
                                    ),),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(controller.timePrayer.first.data!.timings!.sunrise ?? "",style: GoogleFonts.notoKufiArabic(
                                      textStyle:  TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis,
                                        color: Colors.black,
                                      ),
                                    ),),
                                  ),
                                ]),
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('الظهر',style: GoogleFonts.notoKufiArabic(
                                      textStyle: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis,
                                        color: Colors.black,
                                      ),
                                    ),),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(controller.timePrayer.first.data!.timings!.dhuhr ?? "",style: GoogleFonts.notoKufiArabic(
                                      textStyle:  TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis,
                                        color: Colors.black,
                                      ),
                                    ),),
                                  ),
                                ]),
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('العصر',style: GoogleFonts.notoKufiArabic(
                                      textStyle:  TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis,
                                        color: Colors.black,
                                      ),
                                    ),),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(controller.timePrayer.first.data!.timings!.asr ?? "",style: GoogleFonts.notoKufiArabic(
                                      textStyle:  TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis,
                                        color: Colors.black,
                                      ),
                                    ),),
                                  ),
                                ]),
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('المغرب',style: GoogleFonts.notoKufiArabic(
                                      textStyle:  TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis,
                                        color: Colors.black,
                                      ),
                                    ),),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(controller.timePrayer.first.data!.timings!.maghrib ?? "",style: GoogleFonts.notoKufiArabic(
                                      textStyle:  TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis,
                                        color: Colors.black,
                                      ),
                                    ),),
                                  ),
                                ]),
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('العشاء',style: GoogleFonts.notoKufiArabic(
                                      textStyle:  TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis,
                                        color: Colors.black,
                                      ),
                                    ),),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(controller.timePrayer.first.data!.timings!.isha ?? "",style: GoogleFonts.notoKufiArabic(
                                      textStyle:  TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis,
                                        color: Colors.black,
                                      ),
                                    ),),
                                  ),
                                ]),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
          );
        }
    );
  }
}
