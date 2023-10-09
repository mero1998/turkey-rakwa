import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakwa/widget/rate_stars_widget.dart';

import '../../app_colors/app_colors.dart';
import '../../widget/appbars/app_bars.dart';
import '../../widget/main_elevated_button.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({Key? key}) : super(key: key);

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen>{
  CarouselController buttonCarouselController = CarouselController();

  List<String> list= [
"https://i0.wp.com/images-prod.healthline.com/hlcmsresource/images/AN_images/healthy-eating-ingredients-1296x728-header.jpg?w=1155&h=1528",
    "https://www.eatingwell.com/thmb/m5xUzIOmhWSoXZnY-oZcO9SdArQ=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/article_291139_the-top-10-healthiest-foods-for-kids_-02-4b745e57928c4786a61b47d8ba920058.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/6/6d/Good_Food_Display_-_NCI_Visuals_Online.jpg"

  ];
  int currentIndex = 0;
  List<String> list2= [
    "الحجم",
    "Crust",
    "الاضافات",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars.appBarDefault(title: "التقييمات"),
      body: ListView(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        children: [
          Container(
            color: Colors.white,
            height: 336.h,
            width: Get.width,
            padding: EdgeInsets.zero,
            child: CarouselSlider(

              carouselController: buttonCarouselController,
              options: CarouselOptions(

                // padEnds: false,

                height: double.infinity,
                // autoPlay: true,
                viewportFraction: 1,
                reverse: false,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                enlargeFactor: 0.4,
                scrollDirection: Axis.horizontal,
                onPageChanged: (int? index, x){
                  setState(() {
                    currentIndex = index!;
                    print(currentIndex);
                  });
                }
              ),
              items: list.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      width: double.infinity,
                      decoration: const BoxDecoration(color: Colors.white),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          children: [

                            Image.network(
                                 i,
                                fit: BoxFit.cover,
                                width: Get.width,
                                height: double.infinity,
                                errorBuilder: (BuildContext context, Object? exception, StackTrace? stackTrace) {
                                  return Image.asset("images/logo.jpg",
                                    width: Get.width,
                                    height: double.infinity,
                                  );
                                }
                            ),


                            Positioned.fill(
                              child: Container(
                                decoration:  BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.black.withOpacity(0.10),
                                          Colors.black.withOpacity(0.66),
                                        ])),
                              ),
                            ),
                            PositionedDirectional(
                              start: 0,
                              end: 0,
                              bottom: 12.h,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: list.map((idx) {
                                  return Container(
                                      width: currentIndex == list.indexOf(idx) ? 24.w:  6.0.w,
                                      height: 6.0.h,
                                      margin: EdgeInsets.symmetric(horizontal: 6.0.w),
                                      decoration: currentIndex == list.indexOf(idx) ?  BoxDecoration(
                                          shape:  BoxShape.rectangle ,
                                          borderRadius:
                                          BorderRadius.circular(20.r) ,
                                          color: AppColors().mainColor) : BoxDecoration(
                                          shape:  BoxShape.circle,
                                          color:  Colors.white
                                      )
                                    // .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                                  );
                                }).toList(),
                              ),
                            ),

                          ],
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.only(
                start: 16.w,
                end: 16.w,
                bottom: 34.h
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 18.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("بيتزا",
                      style: GoogleFonts.notoKufiArabic(
                        textStyle:  TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),),),
                    Text("23 \$",
                      style: GoogleFonts.notoKufiArabic(
                        textStyle:  TextStyle(
                          fontSize: 24.sp,
                          color: Color(0xFF139878),
                          fontWeight: FontWeight.bold,
                        ),),)
                  ],
                ),

                SizedBox(height: 24.h,),

                // RateStarsWidget(
                //     rate: widget
                //         .detailsModel
                //         .similarItems![index]
                //         .itemAverageRating ==
                //         null
                //         ? null
                //         : double.parse(widget
                //         .detailsModel
                //         .similarItems![index]
                //         .itemAverageRating)),
                SizedBox(
                  width: 100.w,
                   child: RateStarsWidget(
                      rate: 3),
                ),
                SizedBox(height: 24.h,),

                Text("التقيمات",
                  style: GoogleFonts.notoKufiArabic(
                    textStyle:  TextStyle(
                      fontSize: 16.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),),),

                SizedBox(height: 16.h,),

               SizedBox(
                 height: 150.h,
                 child: ListView.builder(

                   shrinkWrap: true,
                     physics: ScrollPhysics(),
                     itemCount: 3,
                     itemBuilder: (context, index){
                   return  Container(
                     margin: EdgeInsets.only(bottom: 16.h),
                     child: Column(
                       children: [
                         Row(
                           children: [
                             Container(
                                 width: 48.w,
                                 height: 48.h,
                                 clipBehavior: Clip.antiAlias,
                                 decoration: BoxDecoration(
                                   shape: BoxShape.circle,
                                 ),
                                 child: Image.network(
                                   "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a0/Pierre-Person.jpg/800px-Pierre-Person.jpg",
                                   fit: BoxFit.cover,
                                 )),
                             SizedBox(width: 12.w,),
                             Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text("احمد محسن",
                                   style: GoogleFonts.notoKufiArabic(
                                     textStyle:  TextStyle(
                                       fontSize: 14.sp,
                                       color: Colors.black,
                                       fontWeight: FontWeight.w500,
                                     ),),),
                                 SizedBox(
                                   width: 100.w,
                                   child: RateStarsWidget(
                                       rate: 3),
                                 ),
                               ],
                             )
                           ],
                         ),
                         Text("هذا النص هو مثال لنص يمكن ان يستبدل في نفس المساحة لقد تم توليد هذا النص من مولد النص العربي",
                           style: GoogleFonts.notoKufiArabic(
                             textStyle:  TextStyle(
                               fontSize: 14.sp,
                               color: Colors.black,
                             ),),),
                       ],
                     ),
                   );
                 }),
               ),
                MainElevatedButton(
                  height: 48.h,
                  width: Get.width,
                  borderRadius: 12.r,
                  onPressed: () {
                    showModalBottomSheet<void>(
                      isScrollControlled: true,

                      constraints: BoxConstraints(
                        minHeight: Get.height * 0.4,
                      ),
                      context: context,
                      builder: (BuildContext context) {
                      return Container(
                      height:  Get.height * 0.4,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: DefaultTabController(
                          length: 2,
                          initialIndex: 0,
                          child: Column(
                            children: [
                              TabBar(
                                indicatorColor: AppColors().mainColor,

                                tabs: [
                                  Padding(
                                    padding:  EdgeInsets.only(bottom: 11.h, top: 11.h),
                                    child: Text("التوصيل",
                                      style: GoogleFonts.notoKufiArabic(
                                        textStyle:  TextStyle(
                                          fontSize: 12.sp,
                                          color: AppColors().mainColor,
                                        ),),),
                                  ),
                                  Padding(
                                    padding:  EdgeInsets.only(bottom: 11.h, top: 11.h),
                                    child: Text("استلام الاكل من المطعم",
                                      style: GoogleFonts.notoKufiArabic(
                                        textStyle:  TextStyle(
                                          fontSize: 12.sp,
                                          color: AppColors().mainColor,
                                        ),),),
                                  ),
                                ],

                              ),
                              Expanded(
                                child: Padding(
                                  padding:  EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
                                  child: TabBarView(children: [
                                    Container(
                                      height: 120.h,
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.location_on_rounded ,size: 14.h ,color: Color(0xFF7A7A7A3D).withOpacity(0.64),),
                                             SizedBox(width: 8.w,),
                                              Text("اضافة مكان التوصيل",
                                                style: GoogleFonts.notoKufiArabic(
                                                  textStyle:  TextStyle(
                                                    fontSize: 12.sp,
                                                    color: Color(0xFF7A7A7A3D).withOpacity(0.64),                                                ),),)
                                            ],
                                          ),

                                          Divider(),

                                          Row(
                                            children: [
                                              Icon(Icons.location_on_rounded ,size: 14.h ,color: Color(0xFF7A7A7A3D).withOpacity(0.64),),
                                              SizedBox(width: 8.w,),
                                             Column(
                                               crossAxisAlignment: CrossAxisAlignment.start,
                                               children: [
                                               Text("الموقع الحالي",
                                               style: GoogleFonts.notoKufiArabic(
                                                   textStyle:  TextStyle(
                                                     fontSize: 12.sp,
                                                     color: Color(0xFF7A7A7A3D),

                                             )
                                                                                     ),),

                                                 Text("غزة - الرمال - ملعب فلسطين",
                                                   style: GoogleFonts.notoKufiArabic(
                                                       textStyle:  TextStyle(
                                                         fontSize: 12.sp,
                                                         color: Color(0xFF7A7A7A3D).withOpacity(0.64),

                                                       )
                                                   ),)
                                               ])
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 120.h,

                                      color: Colors.red,),
                                  ]),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                      },
                    );
                  },
                  child: Text(
                    'ابدأ بالطلب الان',
                    style: GoogleFonts.notoKufiArabic(
                      textStyle:  TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )


        ],
      ),
    );
  }
}
