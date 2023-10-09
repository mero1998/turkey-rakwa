import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakwa/app_colors/app_colors.dart';
import 'package:rakwa/controller/all_cart_getx_controller.dart';
import 'package:rakwa/controller/all_orders_getx_controller.dart';
import 'package:rakwa/model/delivery_time.dart';
import 'package:rakwa/screens/address/map_screen.dart';
import 'package:rakwa/screens/order/add_address_screen.dart';
import 'package:rakwa/screens/order/payment_screen.dart';
import 'package:rakwa/widget/TextFields/text_field_default.dart';
import 'package:rakwa/widget/app_dialog.dart';
import 'package:rakwa/widget/appbars/app_bars.dart';
import 'package:rakwa/widget/main_elevated_button.dart';
import 'package:shimmer/shimmer.dart';

import '../../api/api_controllers/location_controller.dart';
import '../../controller/all_address_getx_controller.dart';
import '../../model/address.dart';
import '../../widget/SnackBar/custom_snack_bar.dart';

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({Key? key}) : super(key: key);

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {

  List<String> list= [
    "توصيل",
    "استلام",
  ];
  // List<String> times= [
  //   "2:30 pm - 3:00pm",
  //   "1:30 pm - 3:00pm",
  //   "4:30 pm - 5:00pm",
  //   "5:30 pm - 6:00pm",
  // ];

  String selectedTypeDelivery = "";
  TimeSlots? selectedTime;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.put(AllAddressGetxController());


    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {

    await  AllOrdersGetxController.to.getFees(resId: AllCartsGetxController.to.carts.first.data!.first.attributes!.restorantId.toString());


      // setState(() {
      //   if(AllAddressGetxController.to.times.isNotEmpty){
      //     selectedTime = AllAddressGetxController.to.times.first.data!.timeSlots!.first;
      //     AllOrdersGetxController.to.timeId.value = AllAddressGetxController.to.times.first.data!.timeSlots!.first.id ?? "";
      //     print("Selected Time::: ${AllOrdersGetxController.to.timeId.value}");
      //
      //   }
        if(AllAddressGetxController.to.addresses.isNotEmpty){
          // selectedAddress = AllAddressGetxController.to.addresses.first;
        }
      // });

    });
    // AllOrdersGetxController.to.vendorsIds.clear();
    // print("Len:: ${AllCartsGetxController.to.carts.first.data!.length}");
    // for(int i = 0; i < AllCartsGetxController.to.carts.first.data!.length; i++){
    //   print("ID::: ${AllCartsGetxController.to.carts.first.data![i].attributes!.restorantId!}");
    //   if(!AllOrdersGetxController.to.vendorsIds.contains(AllCartsGetxController.to.carts.first.data![i].attributes!.restorantId!)){
    //     AllOrdersGetxController.to.vendorsIds.add(AllCartsGetxController.to.carts.first.data![i].attributes!.restorantId!);
    //   }
    // }
    // Future<void> initPaymentSheet() async {
    //   try {
    //     // 1. create payment intent on the server
    //     // final data = await _createTestPaymentSheet();
    //
    //     // 2. initialize the payment sheet
    //     await Stripe.instance.initPaymentSheet(
    //       paymentSheetParameters: SetupPaymentSheetParameters(
    //         // Enable custom flow
    //         customFlow: true,
    //         // Main params
    //         merchantDisplayName: 'Flutter Stripe Store Demo',
    //         paymentIntentClientSecret: data['paymentIntent'],
    //         // Customer keys
    //         customerEphemeralKeySecret: data['ephemeralKey'],
    //         customerId: data['customer'],
    //         // Extra options
    //         testEnv: true,
    //         applePay: true,
    //         googlePay: true,
    //         style: ThemeMode.dark,
    //         merchantCountryCode: 'DE',
    //       ),
    //     );
    //     setState(() {
    //       _ready = true;
    //     });
    //   } catch (e) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text('Error: $e')),
    //     );
    //     rethrow;
    //   }
    // }
  }
   @override
  Widget build(BuildContext context) {


     // print("Ids ::${ AllOrdersGetxController.to.vendorsIds}");
     // print("deliveryType ::${  AllOrdersGetxController.to.deliveryType.value}");
// print(AllOrdersGetxController.to.deliveryType.value);
     if( AllOrdersGetxController.to.deliveryType.value == "delivery"){
       selectedTypeDelivery = list.first;
     }else{
       selectedTypeDelivery = list.last;
     }
     return Scaffold(
      // backgroundColor: Color(0xFFF5F5F5),
      backgroundColor: Colors.white,
      appBar: AppBars.appBarDefault(title: "انشاء طلب"),
      body: GetX<AllAddressGetxController>(
        builder: (controller) {
          return
            controller.isLoading.value
            //
            //
              ? Shimmer.fromColors(
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

                    ),); })) :
                    // child: Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //
          //             children: [
          //               Expanded(
          //                 flex: 2,
          //                 child: Row(
          //                   children: [
          //                     Expanded(
          //                         child: Container(
          //                           width: 51.w,
          //                           height: 51.h,
          //                           clipBehavior: Clip.antiAlias,
          //                           decoration: BoxDecoration(
          //                               borderRadius: BorderRadius.circular(5.r)
          //                           ),
          //                         )),
          //
          //                     SizedBox(width: 8.w,),
          //
          //                     Expanded(
          //                       flex: 3,
          //                       child: Column(
          //                         crossAxisAlignment: CrossAxisAlignment.start,
          //                         children: [
          //                           Container(
          //                             width: 51.w,
          //                             height: 51.h,
          //                             clipBehavior: Clip.antiAlias,
          //                             decoration: BoxDecoration(
          //                                 borderRadius: BorderRadius.circular(5.r)
          //                             ),
          //                           ),
          //                           Container(
          //                             width: 51.w,
          //                             height: 51.h,
          //                             clipBehavior: Clip.antiAlias,
          //                             decoration: BoxDecoration(
          //                                 borderRadius: BorderRadius.circular(5.r)
          //                             ),
          //                           ),
          //                         ],
          //                       ),
          //                     )
          //                   ],
          //                 ),
          //               ),
          //
          //
          //               Expanded(
          //                 child: Column(
          //                   crossAxisAlignment: CrossAxisAlignment.end,
          //                   children: [
          //                     Container(
          //                       width: 20.w,
          //                       height: 20.h,
          //                       clipBehavior: Clip.antiAlias,
          //                       decoration: BoxDecoration(
          //                           borderRadius: BorderRadius.circular(5.r)
          //                       ),
          //                     ),
          //                     SizedBox(height: 20.h,),
          //                     // Row(
          //                     //   children: [
          //                     //
          //                     //     InkWell(
          //                     //       onTap: (){
          //                     //         print("click");
          //                     //         if(controller.carts.first.data![index].quantity != null){
          //                     //           setState(() {
          //                     //             // controller.carts.first.data![index].quantity! + 20;
          //                     //             //
          //                     //             // controller.carts.refresh();
          //                     //           });
          //                     //
          //                     //           controller.updateCartFromApi(quantity: controller.carts.first.data![index].quantity++ + 1, itemId: controller.carts.first.data![index].id.toString());
          //                     //         }
          //                     //       },
          //                     //       child: Container(
          //                     //         padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.3.w),
          //                     //
          //                     //         decoration: BoxDecoration(
          //                     //             border: Border.all(
          //                     //                 color: AppColors().mainColor
          //                     //             ),
          //                     //             borderRadius: BorderRadius.circular(7.r)
          //                     //         ),
          //                     //         child:   Text("+",
          //                     //           style: GoogleFonts.notoKufiArabic(
          //                     //             textStyle:  TextStyle(
          //                     //               fontSize: 15.sp,
          //                     //               color: AppColors().mainColor,
          //                     //             ),),),
          //                     //       ),
          //                     //     ),
          //                     //     SizedBox(width: 11.w,),
          //                     //     Text('${controller.carts.first.data![index].quantity}',
          //                     //       style: GoogleFonts.notoKufiArabic(
          //                     //         textStyle:  TextStyle(
          //                     //           fontSize: 16.sp,
          //                     //           color: Colors.black,
          //                     //           fontWeight: FontWeight.bold,
          //                     //         ),),),
          //                     //     SizedBox(width: 11.w,),
          //                     //
          //                     //     InkWell(
          //                     //       onTap: (){
          //                     //         controller.updateCartFromApi(quantity: controller.carts.first.data![index].quantity-- - 1, itemId: controller.carts.first.data![index].id.toString());
          //                     //
          //                     //       },
          //                     //       child: Container(
          //                     //         padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.3.w),
          //                     //         decoration: BoxDecoration(
          //                     //             border: Border.all(
          //                     //                 color: AppColors().mainColor
          //                     //             ),
          //                     //             borderRadius: BorderRadius.circular(7.r)
          //                     //         ),
          //                     //         child:   Text("-",
          //                     //           style: GoogleFonts.notoKufiArabic(
          //                     //             textStyle:  TextStyle(
          //                     //               fontSize: 15.sp,
          //                     //               color: AppColors().mainColor,
          //                     //             ),),),
          //                     //       ),
          //                     //     ),
          //                     //   ],
          //                     // )
          //                   ],
          //                 ),
          //               )
          //
          //             ],
          //           ),
          //         );
          //       }),
          // )
          //     :  AllCartsGetxController.to.carts.isNotEmpty ?
          ListView(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            padding: EdgeInsetsDirectional.only(
              top: 10.h,
              start: 16.w,
              end: 16.w,
              bottom: 34.h
            ),
            children: [
              Text("تفاصيل التسليم",
                style: GoogleFonts.notoKufiArabic(
                  textStyle:  TextStyle(
                    fontSize: 14.sp,
                      color: Color(0xFF3D3C42),
                      fontWeight: FontWeight.w500
                  ),),),
              //
              // SizedBox(height: 16.h,),
              // ListView.builder(
              //     itemCount: AllCartsGetxController.to.carts.first.data!.length,
              //     shrinkWrap: true,
              //     physics: ScrollPhysics(),
              //     itemBuilder: (context , index){
              //   return       Container(
              //     margin: EdgeInsets.only(bottom: 16.h),
              //     padding: EdgeInsets.all(12),
              //     decoration: BoxDecoration(
              //         color: Colors.white,
              //         boxShadow: [
              //
              //           BoxShadow(
              //               color: Color(0xFFC7C7C71F).withOpacity(0.11),
              //               blurRadius: 36,
              //               spreadRadius: 0,
              //               offset: Offset(12, 6)
              //           )
              //         ]
              //     ),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //
              //       children: [
              //         Expanded(
              //           flex: 2,
              //           child: Row(
              //             children: [
              //               Expanded(
              //                 child: Container(
              //                     width: 51.w,
              //                     height: 51.h,
              //                     clipBehavior: Clip.antiAlias,
              //                     decoration: BoxDecoration(
              //                         borderRadius: BorderRadius.circular(5.r)
              //                     ),
              //                     child: Image.network("https://rakwa.me/${AllCartsGetxController.to.carts.first.data![index].attributes!.image}" ?? "",fit: BoxFit.cover, errorBuilder: (BuildContext context, Object? exception, StackTrace? stackTrace) {
              //                       return Image.asset("images/logo.jpg",
              //                         width: Get.width,
              //                         height: double.infinity,
              //                         fit: BoxFit.cover,
              //                       );
              //                     })),
              //               ),
              //
              //               SizedBox(width: 8.w,),
              //
              //               Expanded(
              //                 flex: 4,
              //                 child: Column(
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   children: [
              //                     Text(AllCartsGetxController.to.carts.first.data![index].name ??"",
              //                       style: GoogleFonts.notoKufiArabic(
              //                         textStyle:  TextStyle(
              //                           fontSize: 14.sp,
              //                           color: Colors.black,
              //                           fontWeight: FontWeight.bold,
              //                         ),),
              //                     overflow: TextOverflow.ellipsis,
              //                     ),
              //                     Text("${int.parse(AllCartsGetxController.to.carts.first.data![index].price ?? "0") * AllCartsGetxController.to.carts.first.data![index].quantity} ₺",
              //                       style: GoogleFonts.notoKufiArabic(
              //                         textStyle:  TextStyle(
              //                           fontSize: 11.sp,
              //                           color: Color(0xFF6B7280),
              //                           fontWeight: FontWeight.bold,
              //                         ),),),
              //                   ],
              //                 ),
              //               )
              //             ],
              //           ),
              //         ),
              //
              //
              //         Expanded(
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.end,
              //             children: [
              //               InkWell(
              //                 onTap: ()async{
              //                   bool success = await  AllCartsGetxController.to.removeCartFromApi(productId:  AllCartsGetxController.to.carts.first.data![index].id!);
              //                   if(success){
              //                     AllCartsGetxController.to.getCart();
              //                   }
              //                   // AllCartsGetxController.to.removeCartFromApi(productId: AllCartsGetxController.to.carts.first.data![index].id!);
              //
              //                 },
              //                 child: Container(
              //                   decoration: BoxDecoration(
              //                       shape: BoxShape.circle,
              //
              //                       border: Border.all(
              //                           color: Color(0xFFA3A3A3)
              //                       )
              //                   ),
              //                   child: Icon(Icons.close,
              //                     color: Color(0xFFA3A3A3),
              //                     size: 15.w,
              //                   ),
              //                 ),
              //               ),
              //               SizedBox(height: 20.h,),
              //               Row(
              //                 children: [
              //
              //                   InkWell(
              //                     onTap: (){
              //                       AllCartsGetxController.to.updateCartFromApi(quantity: AllCartsGetxController.to.carts.first.data![index].quantity++ + 1, itemId: AllCartsGetxController.to.carts.first.data![index].id.toString());
              //
              //                     },
              //                     child: Container(
              //                       padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.3.w),
              //
              //                       decoration: BoxDecoration(
              //                           border: Border.all(
              //                               color: AppColors().mainColor
              //                           ),
              //                           borderRadius: BorderRadius.circular(7.r)
              //                       ),
              //                       child:   Text("+",
              //                         style: GoogleFonts.notoKufiArabic(
              //                           textStyle:  TextStyle(
              //                             fontSize: 15.sp,
              //                             color: AppColors().mainColor,
              //                           ),),),
              //                     ),
              //                   ),
              //                   SizedBox(width: 11.w,),
              //                   Text(AllCartsGetxController.to.carts.first.data![index].quantity.toString(),
              //                     style: GoogleFonts.notoKufiArabic(
              //                       textStyle:  TextStyle(
              //                         fontSize: 16.sp,
              //                         color: Colors.black,
              //                         fontWeight: FontWeight.bold,
              //                       ),),),
              //                   SizedBox(width: 11.w,),
              //
              //                   InkWell(
              //                     onTap: ()async{
              //                       if(AllCartsGetxController.to.carts.first.data![index].quantity <= 1){
              //                         // controller.removeCartFromApi(productId: controller.carts.first.data![index].id!);
              //                         // return null;
              //
              //                         bool success = await AllCartsGetxController.to.removeCartFromApi(productId: AllCartsGetxController.to.carts.first.data![index].id!);
              //                         if(success){
              //                           AllCartsGetxController.to.getCart();
              //                         }
              //                       }else{
              //                         AllCartsGetxController.to.updateCartFromApi(quantity: AllCartsGetxController.to.carts.first.data![index].quantity-- - 1, itemId: AllCartsGetxController.to.carts.first.data![index].id.toString());
              //
              //                       }
              //
              //                       AllCartsGetxController.to.updateCartFromApi(quantity: AllCartsGetxController.to.carts.first.data![index].quantity-- - 1, itemId: AllCartsGetxController.to.carts.first.data![index].id.toString());
              //
              //                     },
              //                     child: Container(
              //                       padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.3.w),
              //                       decoration: BoxDecoration(
              //                           border: Border.all(
              //                               color: AppColors().mainColor
              //                           ),
              //                           borderRadius: BorderRadius.circular(7.r)
              //                       ),
              //                       child:   Text("-",
              //                         style: GoogleFonts.notoKufiArabic(
              //                           textStyle:  TextStyle(
              //                             fontSize: 15.sp,
              //                             color: AppColors().mainColor,
              //                           ),),),
              //                     ),
              //                   ),
              //                 ],
              //               )
              //             ],
              //           ),
              //         )
              //
              //       ],
              //     ),
              //   );
              // }),

              SizedBox(height: 3.h,),
              // Divider(thickness: 2,),
              ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: list.length,
                  itemBuilder: (context, index){
                    return Container(
                      margin: EdgeInsets.only(bottom: 16.h),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: selectedTypeDelivery == list[index] ?  AppColors().mainColor : Color(0xFFF4F4F4)
                              // color: Color(0xFFF4F4F4)
                          )
                      ),
                      child: RadioListTile(

                          activeColor: AppColors().mainColor,
                          value: list[index],
                          groupValue: selectedTypeDelivery,
                          title: Text(list[index],
                            style: GoogleFonts.notoKufiArabic(
                              textStyle: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.black,
                              ),),),
                          onChanged: (value){
                         setState(() {
                           selectedTypeDelivery = list[index];
                           if(selectedTypeDelivery == list.first){
                             AllOrdersGetxController.to.deliveryType.value = "delivery";
                            if(AllOrdersGetxController.to.addressId.value != 0){
                              AllOrdersGetxController.to.costDelivery.value =   AllOrdersGetxController.to.fees.where((p0) => p0.id == AllOrdersGetxController.to.addressId.value).first.costTotal.toString();

                            }

                           }else{
                             AllOrdersGetxController.to.deliveryType.value = "pickup";
                             AllOrdersGetxController.to.costDelivery.value = "";
                           }
                           print( AllOrdersGetxController.to.deliveryType);
                         });
                          }),
                    );

                  }),
              Divider(),

              AllCartsGetxController.to.times.isNotEmpty ?     Text(selectedTypeDelivery == list.last ? 'توقيت الاستلام':  "توقيت التوصيل" ,
                style: GoogleFonts.notoKufiArabic(
                  textStyle:  TextStyle(
                    fontSize: 14.sp,
                    color: Color(0xFF3D3C42),
                    fontWeight: FontWeight.w500
                  ),),)  : Container(),
              SizedBox(height:8.h ,),
         AllCartsGetxController.to.times.isNotEmpty ?     Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xFFE4E4E4)
                ),
                borderRadius: BorderRadius.circular(4)
              ),
                padding: EdgeInsets.all(12),
                child: DropdownButtonHideUnderline(

                  child: DropdownButton(

                          value: selectedTime,
          hint: Text("اختر التوقيت",
          style: GoogleFonts.notoKufiArabic(
          textStyle:  TextStyle(
          fontSize: 12.sp,
          // fontWeight: FontWeight.bold,
          color: Color(0xFF3D3C42).withOpacity(0.4),
          ),
          ),),
                      isDense: true,
                      isExpanded: true,
                      items: AllCartsGetxController.to.times.first.data!.timeSlots!.map<DropdownMenuItem<TimeSlots>>((value){
                         return
                          DropdownMenuItem(
                              value: value,

                              child: Text(value.title ?? "",
                      style: GoogleFonts.notoKufiArabic(
                        textStyle:  TextStyle(
                          fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3D3C42),
                        ),)));
                      }).toList(),
                      onChanged: (value){
setState(() {
  selectedTime = value;
  AllOrdersGetxController.to.timeId.value = selectedTime!.id ?? "";
});
                      }),
                ),
              ) : Container(),

              // Divider(),
              SizedBox(height: 3.h,),
              Visibility(
                visible: selectedTypeDelivery == list.first,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("العنوان",
                            style: GoogleFonts.notoKufiArabic(
                              textStyle:  TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF3D3C42),
                              ),)),
                        InkWell(
                          onTap: (){
                            Get.to(MapScreen());
                          },
                          child: Text("اضافة",
                              style: GoogleFonts.notoKufiArabic(
                                textStyle:  TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color:AppColors().mainColor
                                ),)),
                        ),
                      ],
                    ),

                    SizedBox(height: 8.h,),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Color(0xFFE4E4E4)
                          ),
                          borderRadius: BorderRadius.circular(4)
                      ),
                      padding: EdgeInsets.all(12),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                            value: controller.selectedAddress,
                            hint: Text("اختر عنوان",
                            style: GoogleFonts.notoKufiArabic(
                            textStyle:  TextStyle(
                            fontSize: 12.sp,
                            // fontWeight: FontWeight.bold,
                            color: Color(0xFF3D3C42).withOpacity(0.4),
                            ),
                            ),
                            overflow: TextOverflow.ellipsis,
                            ),
                            isDense: true,
                            // isDense: true,
                            isExpanded: true,
                            items: controller.addresses.map<DropdownMenuItem<UserAddress>>((value){
                              return
                                DropdownMenuItem(
                                    value: value,

                                    child: SizedBox(
                                      width: Get.width / 1.3,
                                      child: Text(value.address ?? "",
                                        style: GoogleFonts.notoKufiArabic(
                                          textStyle:  TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF3D3C42),
                                          ),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),

                                    ));
                            }).toList(),
                            onChanged: (value){
                              setState(() {
                                if(AllOrdersGetxController.to.fees.where((p0) => p0.address == value!.address).first.inRadius!){
                                  controller.selectedAddress = value;
                                AllOrdersGetxController.to.addressId.value = controller.selectedAddress!.id ?? 0;
                                AllOrdersGetxController.to.address.value = controller.selectedAddress!.address ?? "";

                                print(AllOrdersGetxController.to.fees.where((p0) => p0.address == AllOrdersGetxController.to.address.value).first.costTotal.toString());
                                AllOrdersGetxController.to.costDelivery.value =   AllOrdersGetxController.to.fees.where((p0) => p0.address == AllOrdersGetxController.to.address.value).first.costTotal.toString();
                                }else{
                                  AppDialog.errorDialog(context, error: "موقعكم خارج نطاق توزيع المطعم");
                                  return null;
                                }


                                print("Cost::: ${AllOrdersGetxController.to.costDelivery.value}");

                                // print(selectedAddress!.id);

                              });
                            }),
                      ),
                    ),

                  ],
                ),
              ),
              SizedBox(height: 3.h,),

              // Divider(),
              Text("ملاحظات",
                  style: GoogleFonts.notoKufiArabic(
                    textStyle:  TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF3D3C42)
                    ),)),

              SizedBox(height: 8.h,),
              TextFieldDefault(
                hint: "اكتب ملاحظاتك هنا",maxLines: 4,controller: AllOrdersGetxController.to.noteController,
             keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done
              ),
              // Divider(),


              GetX<AllCartsGetxController>(builder: (c){
                return Column(
                  children: [
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
                        Text("${c.carts.first.total} ليرة ",
                          style: GoogleFonts.notoKufiArabic(
                            textStyle:  TextStyle(
                              fontSize: 12.sp,
                              color: AppColors().mainColor,
                            ),),),
                      ],
                    ),
                    SizedBox(height: 18.h,),
                    Visibility(
                     visible: selectedTypeDelivery == list.first,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // المبلغ الاجمالي
                          Text("التوصيل",
                            style: GoogleFonts.notoKufiArabic(
                              textStyle:  TextStyle(
                                fontSize: 12.sp,
                                color: AppColors().mainColor,
                              ),),),

                          Text("${AllOrdersGetxController.to.costDelivery.value.isEmpty ? "اختار عنوان حتى يتم احتساب التوصيل" : '${AllOrdersGetxController.to.costDelivery.value }ليرة' }",
                            style: GoogleFonts.notoKufiArabic(
                              textStyle:  TextStyle(
                                fontSize: 12.sp,
                                color: AppColors().mainColor,
                              ),),),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h,),

                    MySeparator(
                      color: Color(0xFFC0C0C066).withOpacity(0.40),
                    ),

                    SizedBox(height: 24.h,),
                AllOrdersGetxController.to.costDelivery.isNotEmpty ?
                Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("المجموع",
                          style: GoogleFonts.notoKufiArabic(
                            textStyle:  TextStyle(
                              fontSize: 12.sp,
                              color: AppColors().mainColor,
                            ),),),

                        Text("${num.parse(AllOrdersGetxController.to.costDelivery.value) + AllCartsGetxController.to.carts.first.total!} ليرة ",
                          style: GoogleFonts.notoKufiArabic(
                            textStyle:  TextStyle(
                              fontSize: 12.sp,
                              color: AppColors().mainColor,
                            ),),),
                        // المبلغ الاجمالي


                      ],
                    ) :Container(),

                  ],
                );
              }),


              SizedBox(height: 66.h,),
              MainElevatedButton(child:
              Text("التأكيد",
                style: GoogleFonts.notoKufiArabic(
                  textStyle:  TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white,
                  ),),), height: 48.h,
                  width: Get.width,
                  borderRadius: 4.r, onPressed: (){
                    // Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters());

                    if(AllCartsGetxController.to.times.isNotEmpty){
                      if(selectedTypeDelivery == list.first){
                        if(selectedTime == null){
                          customSnackBar(
                            title: "تحذير",
                            subtitle: "يرجى اختيار توقيت التوصيل",
                            isWarning: true,
                          );
                        }else if(controller.selectedAddress == null){
                          customSnackBar(
                            title: "تحذير",
                            subtitle: "يرجى اختيار العنوان",
                            isWarning: true,
                          );
                        }else{
                          Get.to(PaymentScreen());

                        }
                      }else{
                        if(selectedTime == null){
                          customSnackBar(
                            title: "تحذير",
                            subtitle: "يرجى اختيار توقيت الاستلام",
                            isWarning: true,
                          );
                        }else{
                          Get.to(PaymentScreen());
                        }

                      }
                    }else{
                      Get.to(PaymentScreen());

                    }



                  })
            ],
          // ) : Center(child: Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Icon(Icons.shopping_cart, size: 100.w, color: Colors.grey.shade500,),
          //     Text("السلة فارغة",
          //       style: GoogleFonts.notoKufiArabic(
          //         textStyle:  TextStyle(
          //           fontSize: 20.sp,
          //           color: Colors.grey.shade500,
          //           fontWeight: FontWeight.bold,
          //         ),),),
          //     Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Text("يرجى اضافة عناصر حتى تتمكن من انشاء طلب جديد",
          //         style: GoogleFonts.notoKufiArabic(
          //           textStyle:  TextStyle(
          //             fontSize: 13.sp,
          //             color: Colors.grey.shade500,
          //             fontWeight: FontWeight.bold,
          //           ),),
          //       textAlign: TextAlign.center,
          //       ),
          //     ),
          //   ],
          // ),
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