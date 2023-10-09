import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakwa/app_colors/app_colors.dart';
import 'package:rakwa/controller/all_cart_getx_controller.dart';
import 'package:rakwa/screens/order/create_order_screen.dart';
import 'package:rakwa/widget/appbars/app_bars.dart';
import 'package:rakwa/widget/main_elevated_button.dart';
import 'package:shimmer/shimmer.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {


  var box = GetStorage();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.put(AllCartsGetxController());
    //
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp)async {
    //  await AllCartsGetxController.to.getCart();
    // });

    // print("Token::: ${box.read("token")}");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBars.appBarDefault(title: "السلة"),
      body: GetX<AllCartsGetxController>(
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
          ) :
          controller.carts.isEmpty
              ? Center(child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_cart, size: 100.w, color: Colors.grey.shade500,),
              Text("السلة فارغة",
                style: GoogleFonts.notoKufiArabic(
                  textStyle:  TextStyle(
                    fontSize: 20.sp,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.bold,
                  ),),),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("يرجى اضافة عناصر حتى تتمكن من انشاء طلب جديد",
                  style: GoogleFonts.notoKufiArabic(
                    textStyle:  TextStyle(
                      fontSize: 13.sp,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.bold,
                    ),),),
              ),       ],
          ),) : ListView(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            padding: EdgeInsetsDirectional.only(
              start: 16.w,
              end: 16.w,
              bottom: 34.h
            ),
            children: [
              Text("تفاصيل السلة",
                style: GoogleFonts.notoKufiArabic(
                  textStyle:  TextStyle(
                    fontSize: 20.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),),),

              SizedBox(height: 16.h,),
              ListView.builder(
                  itemCount: controller.carts.first.data!.length,
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
                                  child: Image.network("https://rakwa.me/${controller.carts.first.data![index].attributes!.image}"  ?? "",fit: BoxFit.cover,
                                      errorBuilder: (BuildContext context, Object? exception, StackTrace? stackTrace) {
                                        return Image.asset("images/logo.jpg",
                                          width: Get.width,
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                        );
                                      }
                                  )),
                            ),

                            SizedBox(width: 8.w,),

                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(controller.carts.first.data![index].name ?? "",
                                    style: GoogleFonts.notoKufiArabic(
                                      textStyle:  TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),),
                                  overflow: TextOverflow.ellipsis,
                                  ),
                                  Text("${controller.carts.first.data![index].price! * controller.carts.first.data![index].quantity} ليرة",
                                    style: GoogleFonts.notoKufiArabic(
                                      textStyle:  TextStyle(
                                        fontSize: 11.sp,
                                        color: Color(0xFF6B7280),
                                        fontWeight: FontWeight.bold,
                                      ),),),
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
                            InkWell(
                              onTap: () async{
                              bool success = await controller.removeCartFromApi(productId: controller.carts.first.data![index].id!);
                                if(success){
                                  controller.getCart();
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,

                                    border: Border.all(
                                        color: Color(0xFFA3A3A3)
                                    )
                                ),
                                child: Icon(Icons.close,
                                  color: Color(0xFFA3A3A3),
                                  size: 15.w,
                                ),
                              ),
                            ),
                            SizedBox(height: 20.h,),
                            Row(
                              children: [

                                InkWell(
                                  onTap: (){
                                    print("click");
                                    if(controller.carts.first.data![index].quantity != null){
                                      setState(() {
                                        // controller.carts.first.data![index].quantity! + 20;
                                        //
                                        // controller.carts.refresh();
                                      });

                                      controller.updateCartFromApi(quantity: controller.carts.first.data![index].quantity++ + 1, itemId: controller.carts.first.data![index].id.toString());
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.3.w),

                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColors().mainColor
                                        ),
                                        borderRadius: BorderRadius.circular(7.r)
                                    ),
                                    child:   Text("+",
                                      style: GoogleFonts.notoKufiArabic(
                                        textStyle:  TextStyle(
                                          fontSize: 15.sp,
                                          color: AppColors().mainColor,
                                        ),),),
                                  ),
                                ),
                                SizedBox(width: 11.w,),
                                Text('${controller.carts.first.data![index].quantity}',
                                  style: GoogleFonts.notoKufiArabic(
                                    textStyle:  TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),),),
                                SizedBox(width: 11.w,),

                                InkWell(
                                  onTap: ()async{
                                    if(controller.carts.first.data![index].quantity <= 1){
                                      // controller.removeCartFromApi(productId: controller.carts.first.data![index].id!);
                                      // return null;

                                      bool success = await controller.removeCartFromApi(productId: controller.carts.first.data![index].id!);
                                      if(success){
                                        controller.getCart();
                                      }
                                    }else{
                                      controller.updateCartFromApi(quantity: controller.carts.first.data![index].quantity-- - 1, itemId: controller.carts.first.data![index].id.toString());

                                    }

                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.3.w),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColors().mainColor
                                        ),
                                        borderRadius: BorderRadius.circular(7.r)
                                    ),
                                    child:   Text("-",
                                      style: GoogleFonts.notoKufiArabic(
                                        textStyle:  TextStyle(
                                          fontSize: 15.sp,
                                          color: AppColors().mainColor,
                                        ),),),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )

                    ],
                  ),
                );
              }),

              Divider(thickness: 2,),
              SizedBox(height: 95.h,),
              Divider(),


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              // المبلغ الاجمالي
                  Text("مجموع العناصر",
                    style: GoogleFonts.notoKufiArabic(
                      textStyle:  TextStyle(
                        fontSize: 12.sp,
                        color: AppColors().mainColor,
                      ),),),
                  Text("${controller.carts.first.total} ليرة ",
                    style: GoogleFonts.notoKufiArabic(
                      textStyle:  TextStyle(
                        fontSize: 12.sp,
                        color: AppColors().mainColor,
                      ),),),
                ],
              ),
              SizedBox(height: 18.h,),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     // المبلغ الاجمالي
              //     Text("التوصيل",
              //       style: GoogleFonts.notoKufiArabic(
              //         textStyle:  TextStyle(
              //           fontSize: 12.sp,
              //           color: AppColors().mainColor,
              //         ),),),
              //
              //     Text("0 ₺",
              //       style: GoogleFonts.notoKufiArabic(
              //         textStyle:  TextStyle(
              //           fontSize: 12.sp,
              //           color: AppColors().mainColor,
              //         ),),),
              //   ],
              // ),
              SizedBox(height: 24.h,),

              // MySeparator(
              //   color: Color(0xFFC0C0C066).withOpacity(0.40),
              // ),
              //
              // SizedBox(height: 24.h,),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     // المبلغ الاجمالي
              //     Text("المجموع",
              //       style: GoogleFonts.notoKufiArabic(
              //         textStyle:  TextStyle(
              //           fontSize: 12.sp,
              //           color: AppColors().mainColor,
              //         ),),),
              //
              //     Text("${AllCartsGetxController.to.carts.first.total} ₺",
              //       style: GoogleFonts.notoKufiArabic(
              //         textStyle:  TextStyle(
              //           fontSize: 12.sp,
              //           color: AppColors().mainColor,
              //         ),),),
              //   ],
              // ),


              SizedBox(height: 66.h,),
              MainElevatedButton(child:
              Text("الاستمرار",
                style: GoogleFonts.notoKufiArabic(
                  textStyle:  TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white,
                  ),),), height: 48.h,
                  width: Get.width,
                  borderRadius: 4.r, onPressed: (){
                if(controller.times.isNotEmpty){

    if(controller.carts.first.total! >= controller.carts.first.data!.first.minimum!) {
      Get.to(CreateOrderScreen());

    }else{
        Fluttertoast.showToast(msg: "يجب إضافة منتجات أخرى للوصول لأدنى طلب مسموح به من المطعم، ${AllCartsGetxController.to.carts.first.data!.first.minimum!}  ليرة.", backgroundColor: Colors.black.withOpacity(0.64));

    }

                }else{
                  Fluttertoast.showToast(msg: "المطعم مغلق الأن، يرجى العودة اثناء اوقات عمل المطعم", backgroundColor: Colors.black.withOpacity(0.64));

                }
                  })
            ],
          );
        }
      ),
    );
  }
}

class MySeparator extends StatelessWidget {
  const MySeparator({Key? key, this.height = 1, this.color = Colors.black})
      : super(key: key);
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 10.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}