import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rakwa/model/order.dart';
import 'package:rakwa/screens/menu/food_details_screen.dart';
import 'package:rakwa/widget/appbars/app_bars.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../app_colors/app_colors.dart';

class OrderDetailsScreen extends StatefulWidget {

Orders order;
OrderDetailsScreen({required this.order});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    // تم قبولها من الادمن
    // 9 تم رفضها
    // 3 تم قبولها.
    // 5 تم التحضير
    // 7 تم التوصيل
    List<String> orderStatus = [
      "Accepted by admin",
      "Accepted",
      "Rejected",
      "Prepared",
      "Delivered",
    ];
    return Scaffold(

      appBar: AppBars.appBarDefault(title: "تفاصيل الطلب"),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40.h,),
              Center(
                child: SizedBox(
                  height: 120.h,
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemCount: orderStatus.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      physics: ScrollPhysics(),
                      itemBuilder: (context, index) {
                        return TimelineTile(
                          axis: TimelineAxis.horizontal,
                          alignment: TimelineAlign.end,
                          beforeLineStyle: LineStyle(
                              color: Colors.grey
                          ),
                          indicatorStyle: IndicatorStyle(
                              color: widget.order.lastStatus!.first.name == orderStatus[index] ? AppColors().mainColor : Colors.grey.shade700
                          ),
                          startChild: Align(
                            alignment: AlignmentDirectional.topStart,
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              children: [
                              Container(
                                  width: 80.w,
                                    margin: EdgeInsetsDirectional.only(end: 5.w),
                                    child: Text(orderStatus[index] == "Accepted by admin" ? "Pending" :orderStatus[index],style: GoogleFonts.notoKufiArabic(
                                    textStyle: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.black,
                                  height: 1.3
                                    ),),
                                  textAlign: TextAlign.center
                                  ))
                              ],
                              // color: Colors.amberAccent,
                              ),
                          ),
                        );
                      }
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsetsDirectional.only(top: 30.h, start: 16.w, end: 16.w,bottom: 24.h),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0,3),
                          blurRadius: 6,
                          color: Colors.black.withOpacity(0.16)
                      )
                    ]
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:  EdgeInsetsDirectional.only(start: 11.w, end: 9.w, top: 9.h, bottom: 16.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(text: TextSpan(
                              children: [
                                TextSpan(text: "رقم الطلب",  style: GoogleFonts.notoKufiArabic(
                textStyle: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black,
                ),
              ),),
                                TextSpan(text: " "),
                                TextSpan(text: "#", style: TextStyle(color: Color(0xff545454))),
                                TextSpan(text: ""),
                                // Color(0xff0F146D)
                                TextSpan(text: widget.order.id.toString(),
                                    style: GoogleFonts.notoKufiArabic(
                                      textStyle: TextStyle(
                                        fontSize: 14.sp,
                                        color: Color(0xff0F146D),
                                      ),
                                  ),)
                              ]
                          )),
                          // Text(text: orderController.showOrders.first.order!.createdAt!.substring(0,10), fontColor:Color(0xff545454), fontSize: 13)
                        ],
                      ),
                    ),
                    Padding(
                      padding:  EdgeInsetsDirectional.only(start: 10.w, end: 11.w, bottom: 2.h),
                      child:   Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFFF5F5F5)
                                  ),
                                  padding: EdgeInsets.all(6),
                                  child: Icon(Icons.store, size: 9.w, color: Color(0xFF0F146D),)),
                              Text(" طلب من  ${widget.order.restorant!.name ??" "}",style: GoogleFonts.notoKufiArabic(
                              textStyle: TextStyle(
                              fontSize: 11.sp,
                                color: Colors.black,
                              ),))
                            ],
                          ),
                          Container(
                              padding: EdgeInsetsDirectional.only(
                                  top: 2.h, bottom: 2.h , start: 17.w, end: 12.w
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors().mainColor,
                                ),
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: Text(widget.order.lastStatus!.first.name == "Accepted by admin" ? "Pending" : widget.order.lastStatus!.first.name ?? "",style: GoogleFonts.notoKufiArabic(
                                textStyle: TextStyle(
                                  fontSize: 13.sp,
                                  color: Colors.black,
                                ),)))


                        ],
                      ),
                    ),


                    // Padding(
                    //   padding:  EdgeInsetsDirectional.only(start: 33.w, end: 9.w, top: 9.h, bottom: 15.8.h),
                    //   child: Text("${widget.order.items!.length}عنصر,  مجموع المبلغ : ${widget.order.orderPrice} ${widget.order.restorant!.type == 4 || widget.order.restorant!.type == 5 ? "\$" : "ليرة"}  ",style: GoogleFonts.notoKufiArabic(
                    //     textStyle: TextStyle(
                    //       fontSize: 10.sp,
                    //       color: Colors.black,
                    //     ),)),
                    // ),
                    Padding(
                      padding:  EdgeInsetsDirectional.only(start: 33.w,top: 9.h, bottom: 9.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text( "تكلفة التوصيل :",style: GoogleFonts.notoKufiArabic(
                            textStyle: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.black,
                            ),)),
                          Text( " ${widget.order.delivery_price} ${widget.order.restorant!.type == 4 || widget.order.restorant!.type == 5 ? "\$" : "ليرة"}  ",style: GoogleFonts.notoKufiArabic(
                            textStyle: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.black,
                            ),)),

                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding:  EdgeInsetsDirectional.only(start: 33.w, end: 9.w, top: 9.h, bottom: 15.8.h),
                          child: Text("حالة الدفع:",style: GoogleFonts.notoKufiArabic(
                            textStyle: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.black,
                            ),)),
                        ),
                        Padding(
                          padding:  EdgeInsetsDirectional.only(end: 9.w, top: 9.h, bottom: 15.8.h),
                          child: Text('${widget.order.paymentMethod =='cod' ? " الدفع عند الاستلام" : "تم الدفع أونلاين"}',style: GoogleFonts.notoKufiArabic(
                            textStyle: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.black,
                            ),)),
                        ),
    widget.order.paymentMethod !='cod'  ? Padding(
                          padding:  EdgeInsetsDirectional.only(end: 9.w, top: 9.h, bottom: 15.8.h),
                          child: Text('${widget.order.partial_payment != null ? " مبلغ جزئي بقيمة ${widget.order.partial_payment}" : "${widget.order.orderPrice}"} \$',style: GoogleFonts.notoKufiArabic(
                            textStyle: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.black,
                            ),)),
                        ) : Container(),
                      ],
                    ),

                    Divider(),

                    Padding(
                      padding:  EdgeInsetsDirectional.only(end: 9.w, top: 9.h, bottom: 9.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text( "المجموع :",style: GoogleFonts.notoKufiArabic(
                        textStyle: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.black,
                        ),)),
                          Text( "${widget.order.items!.length} عنصر,  مجموع المبلغ : ${widget.order.orderPrice} ${widget.order.restorant!.type == 4 || widget.order.restorant!.type == 5 ? "\$" : "ليرة"} ",style: GoogleFonts.notoKufiArabic(
                            textStyle: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.black,
                            ),)),

                        ],
                      ),
                    ),



                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.only(top: 30.h, start: 16.w, end: 16.w,bottom: 10.h),
                child: Text("العناصر : ",style: GoogleFonts.notoKufiArabic(
                  textStyle: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black,
                  ),)),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: widget.order.items!.length,
                  itemBuilder: (context, index){
                    return InkWell(
                      onTap: (){

                        // Navigator.push(context, MaterialPageRoute(builder: (c) => FoodDetailsScreen(foodId: widget.order.items![index].id ?? -1, resId: widget.order.restorant!.id ?? -1,)));
                      },
                      child: Container(
                          margin: EdgeInsetsDirectional.only(top: 30.h, start: 16.w, end: 16.w,bottom: 10.h),
                          child: Row(
                              children: [
                                Container(
                                  width: 120.w,
                                  height: 120.h,
                                  // margin: EdgeInsetsDirectional.all(8),
                                  padding: EdgeInsetsDirectional.all(8),
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage("https://rakwa.me//${widget.order.items![index].logom ?? ""}"),
                                      ),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.16),
                                          offset: Offset(0,3),
                                          blurRadius: 6,
                                        )
                                      ]
                                  ),),
                                SizedBox(width: 30.w,),
                                Column(
                                  children: [
                                    Text(widget.order.items![index].name ?? "",style: GoogleFonts.notoKufiArabic(
                                      textStyle: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.black,
                                      ),)),
                                    SizedBox(height: 15.h,),
                                    Text("${widget.order.items![index].price.toString() } ${widget.order.restorant!.type == 4 || widget.order.restorant!.type == 5 ? "\$" : "ليرة"} "?? "",style: GoogleFonts.notoKufiArabic(
                                      textStyle: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.black,
                                      ),)),
                                  ],
                                )
                              ]
                          )
                      ),
                    );
                  }),
            ],
          ),
        )
    );
  }
}


