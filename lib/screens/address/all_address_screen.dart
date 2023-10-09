import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakwa/app_colors/app_colors.dart';
import 'package:rakwa/controller/all_address_getx_controller.dart';
import 'package:rakwa/controller/all_orders_getx_controller.dart';
import 'package:rakwa/screens/order/orders_details_screen.dart';
import 'package:rakwa/widget/appbars/app_bars.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
class AllAddressScreen extends StatefulWidget {
  const AllAddressScreen({Key? key}) : super(key: key);

  @override
  State<AllAddressScreen> createState() => _AllAddressScreenState();
}

class _AllAddressScreenState extends State<AllAddressScreen> {

  // "Accepted by admin",
  // "Accepted by restaurant",
  // "prepared",
  // "Delivered",
  @override
  void initState() {
    // TODO: implement initState
    Get.put(AllAddressGetxController());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars.appBarDefault(title: "العناوين"),
      body: GetX<AllAddressGetxController>(
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
          ) : controller.addresses.isEmpty ? Center(child: Text(
            "لا يوجد لديك عناوين",
            style: GoogleFonts.notoKufiArabic(
              textStyle:  TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
                color: Colors.black,
              ),
            ),
          ),) :
              ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  padding: EdgeInsets.all(16),
                  itemCount: controller.addresses.length,
                  itemBuilder: (context , index){
                return   InkWell(
                  // onTap: ()=> Get.to(OrderDetailsScreen(order: controller.orders[index])),
                  
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
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
                    child:Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text(controller.addresses[index].address ?? "")),
                            IconButton(onPressed: (){
                              controller.deleteAddress(id: controller.addresses[index].id ?? -1);
                            }, icon: Icon(Icons.delete)),
                          ],
                        ),
                        Row(
                          children: [
                            controller.addresses[index].build_name != null ?
                            Expanded(
                              child: Row(
                                children: [
                                  Text("اسم المبنى: "),
                                  Text(controller.addresses[index].build_name ?? ""),
                                ],
                              ),
                            ) : Container(),
                            controller.addresses[index].build_number != null ?     Expanded(
                              child: Row(
                                children: [
                                  Text("رقم المبنى: "),
                                  Text(controller.addresses[index].build_number ?? ""),
                                ],
                              ),
                            ) : Container(),
                            // Expanded(child: Text(controller.addresses[index].build_name ?? "")),
                            // Expanded(child: Text(controller.addresses[index].address ?? "")),
                          ],
                        ),
                        Row(
                          children: [
                            controller.addresses[index].floor != null ?
                            Expanded(
                              child: Row(
                                children: [
                                  Text("الطابق: "),
                                  Text(controller.addresses[index].floor ?? ""),
                                ],
                              ),
                            ) : Container(),
                            controller.addresses[index].apartment != null ?     Expanded(
                              child: Row(
                                children: [
                                  Text("رقم الشقة: "),
                                  Text(controller.addresses[index].apartment ?? ""),
                                ],
                              ),
                            ) : Container(),
                            // Expanded(child: Text(controller.addresses[index].build_name ?? "")),
                            // Expanded(child: Text(controller.addresses[index].address ?? "")),
                          ],
                        ),
                        controller.addresses[index].block != null ?     Row(
                          children: [
                            Text("البلوك: "),
                            Text(controller.addresses[index].block ?? ""),
                          ],
                        ) : Container(),
                      ],
                    ),
                  ),
                );
              });

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
