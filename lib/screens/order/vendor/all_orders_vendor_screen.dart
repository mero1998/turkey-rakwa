import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakwa/app_colors/app_colors.dart';
import 'package:rakwa/controller/all_orders_getx_controller.dart';
import 'package:rakwa/controller/all_orders_vendor_getx_controller.dart';
import 'package:rakwa/screens/order/orders_details_screen.dart';
import 'package:rakwa/screens/order/vendor/order_vendor_details_screen.dart';
import 'package:rakwa/widget/appbars/app_bars.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
class AllOrdersVendorScreen extends StatefulWidget {
  const AllOrdersVendorScreen({Key? key}) : super(key: key);

  @override
  State<AllOrdersVendorScreen> createState() => _AllOrdersVendorScreenState();
}

class _AllOrdersVendorScreenState extends State<AllOrdersVendorScreen> {

  // "Accepted by admin",
  // "Accepted by restaurant",
  // "prepared",
  // "Delivered",
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  Get.put(AllOrdersVendorGetxController());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars.appBarDefault(title: "الطلبات"),
      body: GetX<AllOrdersVendorGetxController>(
        builder: (controller) {
          return controller.isLoading.value ? Shimmer.fromColors(
            baseColor: Colors.grey.shade100,
            highlightColor: Colors.grey.shade300,
            child:   ListView.builder(
                itemCount: 2,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemBuilder: (context , index){
                  return       Container(
                    margin: EdgeInsets.only(bottom: 16.h),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [

                          BoxShadow(
                              color: Color(0xFFC7C7C71F).withOpacity(0.11),
                              blurRadius: 36,
                              spreadRadius: 0,
                              offset: Offset(12, 6)
                          )
                        ]
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              Expanded(
                                  child: Container(
                                    width: 51.w,
                                    height: 51.h,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5.r)
                                    ),
                                  )),

                              SizedBox(width: 8.w,),

                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 51.w,
                                      height: 51.h,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5.r)
                                      ),
                                    ),
                                    Container(
                                      width: 51.w,
                                      height: 51.h,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5.r)
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),


                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                width: 20.w,
                                height: 20.h,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.r)
                                ),
                              ),
                              SizedBox(height: 20.h,),
                              // Row(
                              //   children: [
                              //
                              //     InkWell(
                              //       onTap: (){
                              //         print("click");
                              //         if(controller.carts.first.data![index].quantity != null){
                              //           setState(() {
                              //             // controller.carts.first.data![index].quantity! + 20;
                              //             //
                              //             // controller.carts.refresh();
                              //           });
                              //
                              //           controller.updateCartFromApi(quantity: controller.carts.first.data![index].quantity++ + 1, itemId: controller.carts.first.data![index].id.toString());
                              //         }
                              //       },
                              //       child: Container(
                              //         padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.3.w),
                              //
                              //         decoration: BoxDecoration(
                              //             border: Border.all(
                              //                 color: AppColors().mainColor
                              //             ),
                              //             borderRadius: BorderRadius.circular(7.r)
                              //         ),
                              //         child:   Text("+",
                              //           style: GoogleFonts.notoKufiArabic(
                              //             textStyle:  TextStyle(
                              //               fontSize: 15.sp,
                              //               color: AppColors().mainColor,
                              //             ),),),
                              //       ),
                              //     ),
                              //     SizedBox(width: 11.w,),
                              //     Text('${controller.carts.first.data![index].quantity}',
                              //       style: GoogleFonts.notoKufiArabic(
                              //         textStyle:  TextStyle(
                              //           fontSize: 16.sp,
                              //           color: Colors.black,
                              //           fontWeight: FontWeight.bold,
                              //         ),),),
                              //     SizedBox(width: 11.w,),
                              //
                              //     InkWell(
                              //       onTap: (){
                              //         controller.updateCartFromApi(quantity: controller.carts.first.data![index].quantity-- - 1, itemId: controller.carts.first.data![index].id.toString());
                              //
                              //       },
                              //       child: Container(
                              //         padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.3.w),
                              //         decoration: BoxDecoration(
                              //             border: Border.all(
                              //                 color: AppColors().mainColor
                              //             ),
                              //             borderRadius: BorderRadius.circular(7.r)
                              //         ),
                              //         child:   Text("-",
                              //           style: GoogleFonts.notoKufiArabic(
                              //             textStyle:  TextStyle(
                              //               fontSize: 15.sp,
                              //               color: AppColors().mainColor,
                              //             ),),),
                              //       ),
                              //     ),
                              //   ],
                              // )
                            ],
                          ),
                        )

                      ],
                    ),
                  );
                }),
          ) : controller.ordersVendor.isEmpty ? Center(child: Text(
            "لا يوجد لديك طلبات",
            style: GoogleFonts.notoKufiArabic(
              textStyle:  TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
                color: Colors.black,
              ),
            ),
          ),) : ListView(
            shrinkWrap: true,
            controller: controller.scroll,

            physics: ScrollPhysics(),
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  padding: EdgeInsets.all(16),
                  itemCount: controller.ordersVendor.length,
                  itemBuilder: (context , index){
                return   InkWell(
                  onTap: ()=> Get.to(OrderVendorDetailsScreen(order: controller.ordersVendor[index])),
                  
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 24.h),
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
                                    TextSpan(text: "رقم الطلب", style: TextStyle(color: Color(0xff545454),fontFamily: "TufuliArabicDEMO", fontSize: 14.sp)),
                                    TextSpan(text: " "),
                                    TextSpan(text: "#", style: TextStyle(color: Color(0xff545454))),
                                    TextSpan(text: ""),
                                    TextSpan(text: controller.ordersVendor[index].id.toString(), style: TextStyle(color: Color(0xff0F146D), fontFamily: "TufuliArabicDEMO", fontSize: 14.sp)),
                                  ]
                              )),
                              Text(getDate(createdDate: controller.ordersVendor[index].createdAt ?? "").toString().replaceAll(".000+0300", ""),)
                            ],
                          ),
                        ),
                        Padding(
                          padding:  EdgeInsetsDirectional.only(start: 10.w, end: 11.w, bottom: 2.h),
                          child:   Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Row(
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xFFF5F5F5)
                                        ),
                                        padding: EdgeInsets.all(6),
                                        child: Icon(Icons.store, size: 9.w, color: Color(0xFF0F146D),)),
                                    Text("طلب من ${controller.ordersVendor[index].restorant!.name}")
                                  ],
                                ),
                              ),
                              controller.ordersVendor[index].lastStatus!.isEmpty? Container() :  Expanded(
                                child: Container(
                                    padding: EdgeInsetsDirectional.only(
                                        top: 2.h, bottom: 2.h , start: 17.w, end: 12.w
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors().mainColor,
                                      ),
                                      borderRadius: BorderRadius.circular(9),
                                    ),
                                    child: Text(controller.ordersVendor[index].lastStatus!.first.name == "Accepted by admin"  ?  "Pending":  controller.ordersVendor[index].lastStatus!.first.name ?? "",)),
                              )


                            ],
                          ),
                        ),

                        Padding(
                          padding:  EdgeInsetsDirectional.only(start: 33.w, end: 9.w, top: 9.h, bottom: 15.8.h),
                          child: controller.ordersVendor[index].insurance != null ? Text( " مجموع المبلغ :${controller.ordersVendor[index].orderPrice} ليرة, ${controller.ordersVendor[index].type == 1 ?'المبلغ المدفوع ${controller.ordersVendor[index].partial_payment} ليرة ' : ""} ",style: GoogleFonts.notoKufiArabic(
                            textStyle: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.black,
                            ),)): Text(" مجموع العناصر: ${controller.ordersVendor[index].items!.length} عنصر ,  مجموع المبلغ :  ${controller.ordersVendor[index].orderPrice}",style: GoogleFonts.notoKufiArabic(
                            textStyle: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.black,
                            ),) ),
                        ),
                        Divider(),

                        // Padding(
                        //   padding:  EdgeInsetsDirectional.only(end: 9.w, top: 9.h, bottom: 9.h),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.end,
                        //     children: [
                        //       TextApp(text:  "المجموع :", fontColor: Color(0xff484848), fontSize: 14),
                        //       TextApp(text: "${orderController.orders.first.order![index].items!.length}عنصر,  مجموع المبلغ : ${orderController.orders.first.order![index].total} د.أ  ", fontColor: Color(0xff484848), fontSize: 12),
                        //
                        //     ],
                        //   ),
                        // )

                      ],
                    ),
                  ),
                );

              })
            ],
          );
        }
      ),
    );
  }

  getDate({required String createdDate}){

    // _getPSTTime();
    // print("Time::: ${_getPSTTime()}");
    tz.initializeTimeZones();

    final f = DateFormat('HH:mm a');
    final pacificTimeZone = tz.getLocation('Europe/Istanbul');

    var date = DateTime.parse(createdDate);
    String s = f.format(date);
    print(s);
    return tz.TZDateTime.from(date, pacificTimeZone);

  }
}
