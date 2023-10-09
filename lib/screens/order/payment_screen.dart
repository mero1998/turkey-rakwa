import 'dart:convert';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_credit_card/custom_card_type_icon.dart';
import 'package:flutter_credit_card/glassmorphism_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:rakwa/app_colors/app_colors.dart';
import 'package:rakwa/controller/all_address_getx_controller.dart';
import 'package:rakwa/controller/all_cart_getx_controller.dart';
import 'package:rakwa/controller/all_orders_getx_controller.dart';
import 'package:rakwa/widget/TextFields/text_field_default.dart';
import 'package:rakwa/widget/app_dialog.dart';
import 'package:rakwa/widget/appbars/app_bars.dart';
import 'package:rakwa/widget/main_elevated_button.dart';

import '../../card_month_input_formater.dart';
import '../../model/payment_card.dart';
import '../../widget/SVG_Widget/svg_widget.dart';
import 'package:http/http.dart' as http;

import '../../widget/SnackBar/custom_snack_bar.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {

  List<String> list= [
    "دفع اونلاين",
    "دفع عند الاستلام",
  ];
  List<String> list2= [
    "دفع كاش",
    "دفع بالبطاقة",
  ];

  String selectedPayment = "";
  String selectedPaymentMethod = "";
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  OutlineInputBorder? border;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  GlobalKey<FormFieldState<String>> cardNumberKey = GlobalKey<FormFieldState<String>>();
  GlobalKey<FormFieldState<String>> cvvCodeKey = GlobalKey<FormFieldState<String>>();
  GlobalKey<FormFieldState<String>> expiryDateKey = GlobalKey<FormFieldState<String>>();
  GlobalKey<FormFieldState<String>> cardHolderKey = GlobalKey<FormFieldState<String>>();
  Map<String, dynamic>? paymentIntent;
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expireDateController = TextEditingController();
  TextEditingController cvvNumberController = TextEditingController();
  TextEditingController cardNameController = TextEditingController();
  FocusNode cardNumberNode = FocusNode();
  FocusNode expireNode = FocusNode();
  FocusNode cvvNode = FocusNode();
  FocusNode nameNode = FocusNode();
@override
  void initState() {
    // TODO: implement initState
    super.initState();
  selectedPayment = list.first;
  selectedPaymentMethod = list2.first;
  AllOrdersGetxController.to.selectedPayment.value = "stripe";
  AllOrdersGetxController.to.selectedPaymentMethodCash.value = "cash";

  // AllOrdersGetxController.to..value = "stripe";
}
  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardBarElevation: 0,
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.transparent,

      nextFocus: true,
      actions: [

        KeyboardActionsItem(focusNode: cardNumberNode, toolbarButtons: [
              (node) {
            return GestureDetector(
              onTap: () => node.unfocus(),
              child: Text("Done",style: TextStyle(color: Colors.black),),
            );
          }
        ]),
        KeyboardActionsItem(focusNode: expireNode,
            toolbarButtons: [
                  (node) {
                return GestureDetector(
                  onTap: () => node.unfocus(),
                  child: Padding(
                    padding: EdgeInsets.all(15.w),
                    child: Text("Done",style: TextStyle(color: Colors.black),),
                  ),
                );
              }
            ]),
        // KeyboardActionsItem(
        //   focusNode: cvvNode,
        // ),
        KeyboardActionsItem(focusNode: nameNode, toolbarButtons: [
              (node) {
            return GestureDetector(
              onTap: () => node.unfocus(),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Done",style: TextStyle(color: Colors.black),),
              ),
            );
          }
        ]),
        KeyboardActionsItem(focusNode: cvvNode, toolbarButtons: [
              (node) {
            return GestureDetector(
              onTap: () {
                node.unfocus();
                // submitForm();
              },
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Done"),
              ),
            );
          }
        ]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

  print("Vat:: ${AllCartsGetxController.to.carts.first.vat }");

    return Scaffold(
      // backgroundColor: Color(0xFFF5F5F5),
      backgroundColor: Colors.white,
        resizeToAvoidBottomInset:true,
      appBar: AppBars.appBarDefault(title: "الدفع"),
      body: Obx(
          () =>
          // AllCartsGetxController.to.carts.isEmpty
          //     ? Center(child: Column(
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
          //           ),),),
          //     ),       ],
          // ),) :
          KeyboardActions(
            config: _buildConfig(context),
            tapOutsideToDismiss:true,
            overscroll: 30,
            autoScroll: true,bottomAvoiderScrollPhysics: ScrollPhysics(),
            tapOutsideBehavior: TapOutsideBehavior.opaqueDismiss,
            child: ListView(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              padding: EdgeInsetsDirectional.only(
                top: 10.h,
                  start: 16.w,
                  end: 16.w,
                  bottom: 34.h
              ),
              children: [
                Text("تفاصيل الدفع",
                  style: GoogleFonts.notoKufiArabic(
                    textStyle:  TextStyle(
                      fontSize: 14.sp,
                        color: Color(0xFF3D3C42),
                        fontWeight: FontWeight.w500
                    ),),),

                SizedBox(height: 3.h,),
                // ListView.builder(
                //     itemCount: AllCartsGetxController.to.carts.first.data!.length,
                //     shrinkWrap: true,
                //     physics: ScrollPhysics(),
                //     itemBuilder: (context , index){
                //       return       Container(
                //         margin: EdgeInsets.only(bottom: 16.h),
                //         padding: EdgeInsets.all(12),
                //         decoration: BoxDecoration(
                //             color: Colors.white,
                //             boxShadow: [
                //
                //               BoxShadow(
                //                   color: Color(0xFFC7C7C71F).withOpacity(0.11),
                //                   blurRadius: 36,
                //                   spreadRadius: 0,
                //                   offset: Offset(12, 6)
                //               )
                //             ]
                //         ),
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //
                //           children: [
                //             Expanded(
                //               flex: 2,
                //               child: Row(
                //                 children: [
                //                   Expanded(
                //                     child: Container(
                //                         width: 51.w,
                //                         height: 51.h,
                //                         clipBehavior: Clip.antiAlias,
                //                         decoration: BoxDecoration(
                //                             borderRadius: BorderRadius.circular(5.r)
                //                         ),
                //                         child: Image.network("https://rakwa.me/${AllCartsGetxController.to.carts.first.data![index].attributes!.image}" ?? "",fit: BoxFit.cover, errorBuilder: (BuildContext context, Object? exception, StackTrace? stackTrace) {
                //                           return Image.asset("images/logo.jpg",
                //                             width: Get.width,
                //                             height: double.infinity,
                //                             fit: BoxFit.cover,
                //                           );
                //                         })),
                //                   ),
                //
                //                   SizedBox(width: 8.w,),
                //
                //                   Expanded(
                //                     flex: 4,
                //                     child: Column(
                //                       crossAxisAlignment: CrossAxisAlignment.start,
                //                       children: [
                //                         Text(AllCartsGetxController.to.carts.first.data![index].name ??"",
                //                           style: GoogleFonts.notoKufiArabic(
                //                             textStyle:  TextStyle(
                //                               fontSize: 14.sp,
                //                               color: Colors.black,
                //                               fontWeight: FontWeight.bold,
                //                             ),),
                //                           overflow: TextOverflow.ellipsis,
                //                         ),
                //                         Text("${int.parse(AllCartsGetxController.to.carts.first.data![index].price ?? "0") * AllCartsGetxController.to.carts.first.data![index].quantity} ₺",
                //                           style: GoogleFonts.notoKufiArabic(
                //                             textStyle:  TextStyle(
                //                               fontSize: 11.sp,
                //                               color: Color(0xFF6B7280),
                //                               fontWeight: FontWeight.bold,
                //                             ),),),
                //                       ],
                //                     ),
                //                   )
                //                 ],
                //               ),
                //             ),
                //
                //
                //             Expanded(
                //               child: Column(
                //                 crossAxisAlignment: CrossAxisAlignment.end,
                //                 children: [
                //                   InkWell(
                //                     onTap: ()async{
                //                       bool success = await  AllCartsGetxController.to.removeCartFromApi(productId:  AllCartsGetxController.to.carts.first.data![index].id!);
                //                       if(success){
                //                         AllCartsGetxController.to.getCart();
                //                       }
                //                       // AllCartsGetxController.to.removeCartFromApi(productId: AllCartsGetxController.to.carts.first.data![index].id!);
                //
                //                     },
                //                     child: Container(
                //                       decoration: BoxDecoration(
                //                           shape: BoxShape.circle,
                //
                //                           border: Border.all(
                //                               color: Color(0xFFA3A3A3)
                //                           )
                //                       ),
                //                       child: Icon(Icons.close,
                //                         color: Color(0xFFA3A3A3),
                //                         size: 15.w,
                //                       ),
                //                     ),
                //                   ),
                //                   SizedBox(height: 20.h,),
                //                   Row(
                //                     children: [
                //
                //                       InkWell(
                //                         onTap: (){
                //                           AllCartsGetxController.to.updateCartFromApi(quantity: AllCartsGetxController.to.carts.first.data![index].quantity++ + 1, itemId: AllCartsGetxController.to.carts.first.data![index].id.toString());
                //
                //                         },
                //                         child: Container(
                //                           padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.3.w),
                //
                //                           decoration: BoxDecoration(
                //                               border: Border.all(
                //                                   color: AppColors().mainColor
                //                               ),
                //                               borderRadius: BorderRadius.circular(7.r)
                //                           ),
                //                           child:   Text("+",
                //                             style: GoogleFonts.notoKufiArabic(
                //                               textStyle:  TextStyle(
                //                                 fontSize: 15.sp,
                //                                 color: AppColors().mainColor,
                //                               ),),),
                //                         ),
                //                       ),
                //                       SizedBox(width: 11.w,),
                //                       Text(AllCartsGetxController.to.carts.first.data![index].quantity.toString(),
                //                         style: GoogleFonts.notoKufiArabic(
                //                           textStyle:  TextStyle(
                //                             fontSize: 16.sp,
                //                             color: Colors.black,
                //                             fontWeight: FontWeight.bold,
                //                           ),),),
                //                       SizedBox(width: 11.w,),
                //
                //                       InkWell(
                //                         onTap: ()async{
                //                           if(AllCartsGetxController.to.carts.first.data![index].quantity <= 1){
                //                             // controller.removeCartFromApi(productId: controller.carts.first.data![index].id!);
                //                             // return null;
                //
                //                             bool success = await AllCartsGetxController.to.removeCartFromApi(productId: AllCartsGetxController.to.carts.first.data![index].id!);
                //                             if(success){
                //                               AllCartsGetxController.to.getCart();
                //                             }
                //                           }else{
                //                             AllCartsGetxController.to.updateCartFromApi(quantity: AllCartsGetxController.to.carts.first.data![index].quantity-- - 1, itemId: AllCartsGetxController.to.carts.first.data![index].id.toString());
                //
                //                           }
                //                           // AllCartsGetxController.to.updateCartFromApi(quantity: AllCartsGetxController.to.carts.first.data![index].quantity-- - 1, itemId: AllCartsGetxController.to.carts.first.data![index].id.toString());
                //
                //                         },
                //                         child: Container(
                //                           padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.3.w),
                //                           decoration: BoxDecoration(
                //                               border: Border.all(
                //                                   color: AppColors().mainColor
                //                               ),
                //                               borderRadius: BorderRadius.circular(7.r)
                //                           ),
                //                           child:   Text("-",
                //                             style: GoogleFonts.notoKufiArabic(
                //                               textStyle:  TextStyle(
                //                                 fontSize: 15.sp,
                //                                 color: AppColors().mainColor,
                //                               ),),),
                //                         ),
                //                       ),
                //                     ],
                //                   )
                //                 ],
                //               ),
                //             )
                //
                //           ],
                //         ),
                //       );
                //     }),

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
                                color: selectedPayment == list[index] ?  AppColors().mainColor
                            : Color(0xFFF4F4F4)
                            )
                        ),
                        child: RadioListTile(
                            activeColor: AppColors().mainColor,
                            value: list[index],
                            groupValue: selectedPayment,
                            title: Text(list[index],
                              style: GoogleFonts.notoKufiArabic(
                                textStyle: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.black,
                                ),),),
                            onChanged: (value){

                              setState(() {
                                selectedPayment = list[index];

                              });
                              if(selectedPayment == list.first){
                                AllOrdersGetxController.to.selectedPayment.value = "stripe";
                              }else{
                                AllOrdersGetxController.to.selectedPayment.value = "cod";
                              }

                            }),
                      );

                    }),
                Visibility(
                  visible: selectedPayment == list.last,
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: list2.length,
                      itemBuilder: (context, index){
                        return Container(
                          margin: EdgeInsets.only(bottom: 16.h),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: selectedPaymentMethod == list2[index] ?  AppColors().mainColor
                              : Color(0xFFF4F4F4)
                              )
                          ),
                          child: RadioListTile(
                              activeColor: AppColors().mainColor,
                              value: list2[index],
                              groupValue: selectedPaymentMethod,
                              title: Text(list2[index],
                                style: GoogleFonts.notoKufiArabic(
                                  textStyle: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.black,
                                  ),),),
                              onChanged: (value){

                                setState(() {
                                  selectedPaymentMethod = list2[index];

                                });

                                if(selectedPaymentMethod == list2.first){
                                  AllOrdersGetxController.to.selectedPaymentMethodCash.value = "cash";


                                }else{
                                  AllOrdersGetxController.to.selectedPaymentMethodCash.value = "card";

                                }


                              }),
                        );

                      }),
                ),
                Divider(),

                // Text("توقيت التوصيل",
                //   style: GoogleFonts.notoKufiArabic(
                //     textStyle:  TextStyle(
                //         fontSize: 14.sp,
                //         color: Color(0xFF3D3C42),
                //         fontWeight: FontWeight.w500
                //     ),),),


                Divider(),


                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // المبلغ الاجمالي
                    Text("مبلغ العناصر",
                      style: GoogleFonts.notoKufiArabic(
                        textStyle:  TextStyle(
                          fontSize: 12.sp,
                          color: AppColors().mainColor,
                        ),),),
                    Text("${AllCartsGetxController.to.carts.first.total! ?? ""} ليرة ",
                      style: GoogleFonts.notoKufiArabic(
                        textStyle:  TextStyle(
                          fontSize: 12.sp,
                          color: AppColors().mainColor,
                        ),),),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // المبلغ الاجمالي
                    Text("service fee",
                      style: GoogleFonts.notoKufiArabic(
                        textStyle:  TextStyle(
                          fontSize: 12.sp,
                          color: AppColors().mainColor,
                        ),),),
                    Text("${(int.parse(AllCartsGetxController.to.carts.first.vat ?? "8") * 0.01)*100}%",
                      style: GoogleFonts.notoKufiArabic(
                        textStyle:  TextStyle(
                          fontSize: 12.sp,
                          color: AppColors().mainColor,
                        ),),),
                  ],
                ),
                SizedBox(height: 18.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // المبلغ الاجمالي
                    Text("التوصيل",
                      style: GoogleFonts.notoKufiArabic(
                        textStyle:  TextStyle(
                          fontSize: 12.sp,
                          color: AppColors().mainColor,
                        ),),),

                    AllOrdersGetxController.to.deliveryType == "pickup" ? Text("استلام من المطعم 0 ليرة",
                      style: GoogleFonts.notoKufiArabic(
                        textStyle:  TextStyle(
                          fontSize: 12.sp,
                          color: AppColors().mainColor,
                        ),),):    Text("${AllOrdersGetxController.to.costDelivery.value} ليرة ",
                      style: GoogleFonts.notoKufiArabic(
                        textStyle:  TextStyle(
                          fontSize: 12.sp,
                          color: AppColors().mainColor,
                        ),),),
                  ],
                ),
                SizedBox(height: 24.h,),

                MySeparator(
                  color: Color(0xFFC0C0C066).withOpacity(0.40),
                ),

                SizedBox(height: 24.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // المبلغ الاجمالي
                    Text("المجموع",
                      style: GoogleFonts.notoKufiArabic(
                        textStyle:  TextStyle(
                          fontSize: 12.sp,
                          color: AppColors().mainColor,
                        ),),),

                   AllOrdersGetxController.to.deliveryType == "pickup" ?  Text("${AllCartsGetxController.to.carts.first.total! +(AllCartsGetxController.to.carts.first.total!) * int.parse(AllCartsGetxController.to.carts.first.vat ?? "8") * 0.01 ?? ""} ليرة ",
                     style: GoogleFonts.notoKufiArabic(
                       textStyle:  TextStyle(
                         fontSize: 12.sp,
                         color: AppColors().mainColor,
                       ),),) : Text("${(num.parse(AllOrdersGetxController.to.costDelivery.value != "" ? AllOrdersGetxController.to.costDelivery.value: "0")) + (AllCartsGetxController.to.carts.first.total ?? 0) + (AllCartsGetxController.to.carts.first.total ?? 0) *int.parse(AllCartsGetxController.to.carts.first.vat ?? "8") * 0.01} ليرة ",
                      style: GoogleFonts.notoKufiArabic(
                        textStyle:  TextStyle(
                          fontSize: 12.sp,
                          color: AppColors().mainColor,
                        ),),),
                  ],
                ),

                SizedBox(height: 24.h,),

                DottedBorder(
                  dashPattern: [7,4],
                  color: Color(0xFFC0C0C0),
                  radius: Radius.circular(4),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [

                            // SvgPicture.asset(
                            //   'images/ticket-discount.svg',
                            //   // color: color == null ? AppColors().mainColor : color,
                            //   // width: width == null ? size.w : width!.w,
                            //   // height: height == null ? size.w : height!.h,
                            //   fit: BoxFit.cover,
                            //   width: 36.w,
                            //   height: 25.h,
                            //   // matchTextDirection: true,
                            // ),
                            // SizedBox(width: 8.w,),

                            Form(
                              key: formKey2,
                              child: SizedBox(
                                width: Get.width / 2,
                                child: TextFormField(
                                  controller: AllOrdersGetxController.to.couponController,
                                  validator: (value){
                                    if(value!.isEmpty){
                                      return "يرجى ادخال كوبون الخصم";
                                    }else{
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon:   SvgPicture.asset(
                                      'images/ticket-discount.svg',
                                      // color: color == null ? AppColors().mainColor : color,
                                      // width: width == null ? size.w : width!.w,
                                      // height: height == null ? size.w : height!.h,
                                      fit: BoxFit.cover,
                                      width: 36.w,
                                      height: 25.h,
                                      // matchTextDirection: true,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder:  OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                    errorBorder:  OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    )
                                  ),
                                ),
                              ),
                            ),
                            // Text("كوبون الخصم",
                            //   style: GoogleFonts.notoKufiArabic(
                            //     textStyle:  TextStyle(
                            //       fontSize: 12.sp,
                            //       color: Color(0xFF7A7A7A),
                            //     ),),)
                          ],
                        ),

                        MainElevatedButton(
                            backgroundColor: AppColors().mainColor,
                            child:
                            Text("اضافة",
                              style: GoogleFonts.notoKufiArabic(
                                textStyle:  TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.white,
                                ),),), height: 23.h,
                            width: 65.w,
                            borderRadius: 6.r, onPressed: (){
                              if(formKey2.currentState!.validate()){
                                AllOrdersGetxController.to.applyCoupon();
                              }
                        })

                      ],
                    ),
                  ),
                ),

                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Divider(),
                //     SizedBox(height: 15.h,),
                //
                //     Text("وسيلة الدفع",
                //       style: GoogleFonts.notoKufiArabic(
                //         textStyle:  TextStyle(
                //             fontSize: 16.sp,
                //             color: Colors.black,
                //             fontWeight: FontWeight.w500
                //         ),),),
                //     // IconSvg(
                //     //   "logo",
                //     //   size: 20.w,
                //     // ),
                //
                //
                //
                //     Padding(
                //       padding:  EdgeInsetsDirectional.all(16),
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //
                //         children: [
                //
                //           Row(
                //             children: [
                //               SvgPicture.asset(
                //                 'images/visa1.svg',
                //                 // color: color == null ? AppColors().mainColor : color,
                //                 // width: width == null ? size.w : width!.w,
                //                 // height: height == null ? size.w : height!.h,
                //                 fit: BoxFit.cover,
                //                 width: 36.w,
                //                 height: 25.h,
                //                 // matchTextDirection: true,
                //               ),
                //               SvgPicture.asset(
                //                 'images/visa2.svg',
                //                 width: 36.w,
                //                 height: 25.h,
                //                 // color: color == null ? AppColors().mainColor : color,
                //                 // width: width == null ? size.w : width!.w,
                //                 // height: height == null ? size.w : height!.h,
                //                 fit: BoxFit.cover,
                //                 // matchTextDirection: true,
                //               ),
                //               SizedBox(width: 20.w,),
                //
                //               Text("visa/master card",
                //                 style: GoogleFonts.notoKufiArabic(
                //                   textStyle:  TextStyle(
                //                       fontSize: 16.sp,
                //                       color: Colors.black,
                //                       fontWeight: FontWeight.w500
                //                   ),),),
                //             ],
                //           ),
                //
                //
                //
                //           Checkbox(
                //               activeColor: Colors.white,
                //               side: BorderSide(
                //                   color: Color(0xFF9D3FE7)
                //               ),
                //               checkColor: Color(0xFF9D3FE7),
                //               value: true, onChanged: (value){})
                //         ],
                //       ),
                //     ),
                //
                //     Divider(),
                //     Padding(
                //       padding:  EdgeInsets.all(16),
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Row(
                //             children: [
                //               SvgPicture.asset(
                //                 'images/paypal.svg',
                //                 // color: color == null ? AppColors().mainColor : color,
                //                 // width: width == null ? size.w : width!.w,
                //                 // height: height == null ? size.w : height!.h,
                //                 fit: BoxFit.fill,
                //                 width: 75.w,
                //                 height: 50.h,
                //                 // matchTextDirection: true,
                //               ),
                //               SizedBox(width: 42.w,),
                //               Text("paypal",
                //                 style: GoogleFonts.notoKufiArabic(
                //                   textStyle:  TextStyle(
                //                       fontSize: 16.sp,
                //                       color: Colors.black,
                //                       fontWeight: FontWeight.w500
                //                   ),),),
                //             ],
                //           ),
                //
                //
                //           Checkbox(
                //               value: true,
                //               activeColor: Colors.white,
                //               side: BorderSide(
                //                   color: Color(0xFF9D3FE7)
                //               ),
                //               checkColor: Color(0xFF9D3FE7),
                //               onChanged: (value){})
                //
                //         ],
                //       ),
                //     )
                //
                //   ],
                // ),
                Visibility(
                  visible: selectedPayment == list.first,

                  child: SizedBox(
                    height: 300.h,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10.h,),
                        Text("بيانات البطاقة",
                          style: GoogleFonts.notoKufiArabic(
                            textStyle:  TextStyle(
                              fontSize: 12.sp,
                              color: AppColors().mainColor,
                            ),),),
                        // Directionality(
                        //   textDirection: TextDirection.ltr,
                        //   child: CreditCardForm(
                        //
                        //
                        //
                        //     formKey: formKey, // Required
                        //     cardNumberKey: cardNumberKey,
                        //     cvvCodeKey: cvvCodeKey,
                        //     expiryDateKey: expiryDateKey,
                        //     cardHolderKey: cardHolderKey,
                        //     obscureCvv: true,
                        //     obscureNumber: false,
                        //
                        //     autovalidateMode: AutovalidateMode.always,
                        //     onCreditCardModelChange: (CreditCardModel data) {
                        //
                        //       setState(() {
                        //         cardNumber = data.cardNumber;
                        //         expiryDate = data.expiryDate;
                        //         cvvCode = data.cvvCode;
                        //         cardHolderName = data.cardHolderName;
                        //       });
                        //
                        //
                        //     }, // Required
                        //     themeColor: Colors.red,
                        //     isHolderNameVisible: true,
                        //     isCardNumberVisible: true,
                        //     isExpiryDateVisible: true,
                        //     enableCvv: true,
                        //     cardNumberValidator: (String? cardNumber){},
                        //     expiryDateValidator: (String? expiryDate){},
                        //     cvvValidator: (String? cvv){},
                        //     cardHolderValidator: (String? cardHolderName){},
                        //     onFormComplete: () {
                        //       // callback to execute at the end of filling card data
                        //     },
                        //     cardHolderDecoration: const InputDecoration(
                        //       border: OutlineInputBorder(),
                        //       labelText: 'اسم حامل البطاقة',
                        //       hintText: 'محمد أحمد',
                        //     ),
                        //
                        //
                        //     cardNumberDecoration: const InputDecoration(
                        //
                        //       border: OutlineInputBorder(),
                        //       labelText: 'رقم البطاقة',
                        //       hintText: '1234 4564 5432 5421',
                        //     ),
                        //     expiryDateDecoration: const InputDecoration(
                        //       border: OutlineInputBorder(),
                        //       labelText: 'تاريخ الانتهاء',
                        //       hintText: 'MM/YY',
                        //     ),
                        //     cvvCodeDecoration: const InputDecoration(
                        //       border: OutlineInputBorder(),
                        //       labelText: 'رمز cvv',
                        //       hintText: '452',
                        //     ),
                        //     // cardHolderDecoration: const InputDecoration(
                        //     //   border: OutlineInputBorder(),
                        //     //   labelText: 'Card Holder',
                        //     // ),
                        //     cardNumber: cardNumber,
                        //     expiryDate: expiryDate,
                        //     cardHolderName: cardHolderName,
                        //     cvvCode: cvvCode,
                        //   ),
                        // ),
                        Theme(
                          data: ThemeData(
                            primaryColor: AppColors().mainColor.withOpacity(0.8),
                            primaryColorDark: AppColors().mainColor,
                          ),
                          child: Form(
                            key: formKey,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  margin: const EdgeInsets.only(left: 16, top: 16, right: 16),
                                  child: TextFormField(
                                    key: cardNumberKey,
                                    maxLines: 1,

                                    obscureText: false,
                                    // maxLength: 16,
                                    textInputAction: TextInputAction.next,

                                    focusNode: cardNumberNode,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      new LengthLimitingTextInputFormatter(16),
                                      new CardNumberInputFormatter()
                                    ],
                                    controller: cardNumberController,
                                    onChanged: (String value) {
                                      setState(() {
                                        cardNumber = cardNumberController.text;
                                        // creditCardModel.cardNumber = cardNumber;
                                        // onCreditCardModelChange(creditCardModel);
                                      });
                                    },
                                    cursorColor: AppColors().mainColor,
                                    onEditingComplete: () {
                                      FocusScope.of(context).requestFocus(expireNode);
                                    },
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                    textDirection: TextDirection.ltr,
                                    decoration: InputDecoration(
                                      counterText: "",
                                      border: OutlineInputBorder(),
                                      hintText: "6546 6546 9888 8764",

                                    ),
                                    keyboardType: TextInputType.number,
                                    autofillHints: const <String>[AutofillHints.creditCardNumber],
                                    // autovalidateMode: widget.autovalidateMode,
                                    // validator: (String? value) {
                                    //       // Validate less that 13 digits +3 white spaces
                                    //       if (value!.isEmpty || value.length < 16) {
                                    //         return "يرجى ادخال رقم بطاقة صالح";
                                    //       }
                                    //       return null;
                                    //     },
                                    validator: CardUtils.validateCardNum,
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        margin:
                                        const EdgeInsets.only(left: 16, top: 8, right: 16),
                                        child: TextFormField(
                                          key: expiryDateKey,
                                          maxLines: 1,

                                          textDirection: TextDirection.ltr,

                                          controller: expireDateController,
                                          // inputFormatters: [
                                          //   FilteringTextInputFormatter.allow(RegExp("[0-9/]")),
                                          //   LengthLimitingTextInputFormatter(10),
                                          //   _DateFormatter(),
                                          // ],
                                          inputFormatters: [
                                            FilteringTextInputFormatter.digitsOnly,
                                            new LengthLimitingTextInputFormatter(4),
                                            new CardMonthInputFormatter()
                                          ],
                                          onChanged: (String value) {
                                            // if (expireDateController.text
                                            //     .startsWith(RegExp('[2-9]'))) {
                                            //   expireDateController.text =
                                            //       '0' + expireDateController.text;
                                            // }
                                            setState(() {
                                              expiryDate = expireDateController.text;
                                              // creditCardModel.expiryDate = expiryDate;
                                              // onCreditCardModelChange(creditCardModel);
                                            });
                                          },
                                          cursorColor: AppColors().mainColor,
                                          focusNode: expireNode,
                                          onEditingComplete: () {
                                            FocusScope.of(context).requestFocus(cvvNode);
                                          },
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            hintText: "09/24",

                                          ),
                                          keyboardType: TextInputType.number,
                                          textInputAction: TextInputAction.next,
                                          autofillHints: const <String>[
                                            AutofillHints.creditCardExpirationDate
                                          ],
                                          validator:  CardUtils.validateDate,
                                          // validator: (String? value) {
                                          //       if (value!.isEmpty) {
                                          //         return "يرجى ادخال تاريخ صلاحية البطاقة";
                                          //       }
                                          //       final DateTime now = DateTime.now();
                                          //       final List<String> date =
                                          //       value.split(RegExp(r'/'));
                                          //       final int month = int.parse(date.first);
                                          //       final int year = int.parse('20${date.last}');
                                          //       final int lastDayOfMonth = month < 12
                                          //           ? DateTime(year, month + 1, 0).day
                                          //           : DateTime(year + 1, 1, 0).day;
                                          //       final DateTime cardDate = DateTime(
                                          //           year, month, lastDayOfMonth, 23, 59, 59, 999);
                                          //
                                          //       if (cardDate.isBefore(now) ||
                                          //           month > 12 ||
                                          //           month == 0) {
                                          //         return  "يرجى ادخال تاريخ صالح";
                                          //       }
                                          //       return null;
                                          //     },
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        margin:
                                        const EdgeInsets.only(left: 16, top: 8, right: 16),
                                        child: TextFormField(
                                          maxLines: 1,

                                          textDirection: TextDirection.ltr,
                                          textInputAction: TextInputAction.next,

                                          key: cvvCodeKey,
                                          obscureText: true,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.digitsOnly,
                                            new LengthLimitingTextInputFormatter(4),
                                          ],
                                          focusNode: cvvNode,
                                          controller: cvvNumberController,
                                          cursorColor: AppColors().mainColor,
                                          onEditingComplete: () {
                                            FocusScope.of(context).requestFocus(nameNode);
                                            // else {
                                            //   FocusScope.of(context).unfocus();
                                            //   onCreditCardModelChange(creditCardModel);
                                            //   widget.onFormComplete?.call();
                                            // }
                                          },
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            hintText: "675",

                                          ),
                                          keyboardType: TextInputType.number,

                                          autofillHints: const <String>[
                                            AutofillHints.creditCardSecurityCode
                                          ],
                                          onChanged: (String text) {
                                            setState(() {
                                              cvvCode = text;
                                              // creditCardModel.cvvCode = cvvCode;
                                              // onCreditCardModelChange(creditCardModel);
                                            });
                                          },
                                          // validator: (String? value) {
                                          //       if (value!.isEmpty || value.length < 3) {
                                          //         return "يرجى ادخال رمز صالح";
                                          //       }
                                          //       return null;
                                          //     },
                                          validator: CardUtils.validateCVV,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
                                  child: TextFormField(
                                    maxLines: 1,

                                    textDirection: TextDirection.ltr,
                                    key: cardHolderKey,

                                    controller: cardNameController,
                                    onChanged: (String value) {
                                      setState(() {
                                        cardHolderName = cardNameController.text;
                                        // creditCardModel.cardHolderName = cardHolderName;
                                        // onCreditCardModelChange(creditCardModel);
                                      });
                                    },
                                    cursorColor: AppColors().mainColor,
                                    focusNode: nameNode,
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: "اسم حامل البطاقة",

                                    ),

                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.done,
                                    autofillHints: const <String>[AutofillHints.creditCardName],
                                    onEditingComplete: () {
                                      FocusScope.of(context).unfocus();
                                      // onCreditCardModelChange(creditCardModel);
                                      // widget.onFormComplete?.call();
                                    },
                                    validator: (String? value){

                                      if(value!.isEmpty){
                                        return "يرجى ادخال اسم حامل البطاقة";
                                      }else{
                                        return null;
                                      }

                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Image.asset("images/lock.png", width: 24.w, height: 24.h,),
                            SizedBox(width: 5.w,),
                            InkWell(
                              onTap: () => AppDialog.userSafePayment(context,),
                              child: Text("كيف نحمي بياناتك؟",
                                style: GoogleFonts.notoKufiArabic(
                                  textStyle:  TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.black,
                                  ),),),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Visibility(
                //  visible: selectedPayment == list.first,
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       SizedBox(height: 10.h,),
                //       Text("بيانات البطاقة",
                //         style: GoogleFonts.notoKufiArabic(
                //           textStyle:  TextStyle(
                //             fontSize: 12.sp,
                //             color: AppColors().mainColor,
                //           ),),),
                //       Directionality(
                //
                //         textDirection: TextDirection.ltr,
                //         child: CreditCardForm(
                //
                //           formKey: formKey, // Required
                //           cardNumberKey: cardNumberKey,
                //           cvvCodeKey: cvvCodeKey,
                //           expiryDateKey: expiryDateKey,
                //           cardHolderKey: cardHolderKey,
                //           obscureCvv: true,
                //           obscureNumber: false,
                //           autovalidateMode: AutovalidateMode.always,
                //           onCreditCardModelChange: (CreditCardModel data) {
                //
                //             setState(() {
                //               cardNumber = data.cardNumber;
                //               expiryDate = data.expiryDate;
                //               cvvCode = data.cvvCode;
                //               cardHolderName = data.cardHolderName;
                //             });
                //
                //
                //           }, // Required
                //           themeColor: Colors.red,
                //           isHolderNameVisible: true,
                //           isCardNumberVisible: true,
                //           isExpiryDateVisible: true,
                //           enableCvv: true,
                //           cardNumberValidator: (String? cardNumber){},
                //           expiryDateValidator: (String? expiryDate){},
                //           cvvValidator: (String? cvv){},
                //           cardHolderValidator: (String? cardHolderName){},
                //           onFormComplete: () {
                //             // callback to execute at the end of filling card data
                //           },
                //           cardHolderDecoration: const InputDecoration(
                //             border: OutlineInputBorder(),
                //             labelText: 'اسم حامل البطاقة',
                //             hintText: 'محمد أحمد',
                //           ),
                //           cardNumberDecoration: const InputDecoration(
                //             border: OutlineInputBorder(),
                //             labelText: 'رقم البطاقة',
                //             hintText: '1234 4564 5432 5421',
                //           ),
                //           expiryDateDecoration: const InputDecoration(
                //             border: OutlineInputBorder(),
                //             labelText: 'تاريخ الانتهاء',
                //             hintText: 'MM/YY',
                //           ),
                //           cvvCodeDecoration: const InputDecoration(
                //             border: OutlineInputBorder(),
                //             labelText: 'رمز cvv',
                //             hintText: '452',
                //           ),
                //           // cardHolderDecoration: const InputDecoration(
                //           //   border: OutlineInputBorder(),
                //           //   labelText: 'Card Holder',
                //           // ),
                //           cardNumber: cardNumber,
                //           expiryDate: expiryDate,
                //           cardHolderName: cardHolderName,
                //           cvvCode: cvvCode,
                //         ),
                //       ),
                //       Row(
                //         children: [
                //           Image.asset("images/lock.png", width: 24.w, height: 24.h,),
                //           SizedBox(width: 5.w,),
                //           InkWell(
                //             onTap: () => AppDialog.userSafePayment(context,),
                //             child: Text("كيف نحمي بياناتك؟",
                //               style: GoogleFonts.notoKufiArabic(
                //                 textStyle:  TextStyle(
                //                   fontSize: 12.sp,
                //                   color: Colors.black,
                //                 ),),),
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),

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
                  if(selectedPayment == list.first){
                    makePayment();
                  }else{
                    AllOrdersGetxController.to.createOrder(context);
                  }
                    })
              ],
            ),
          )
      ),
    );
  }


  Future<void> makePayment() async {
    // print(expiryDate);
    // print(expiryDate.split('\/').first);
    // print(expiryDate.split('\/').last);
    try {
      //Payment Sheet
      Map paymentIntent = await createPaymentIntent();

      // await Stripe.instance.initPaymentSheet(
      //     paymentSheetParameters: SetupPaymentSheetParameters(
      //         paymentIntentClientSecret: paymentIntent!['client_secret'],
      //         // applePay: const PaymentSheetApplePay(merchantCountryCode: '+92',),
      //         // googlePay: const PaymentSheetGooglePay(testEnv: true, currencyCode: "US", merchantCountryCode: "+92"),
      //         style: ThemeMode.dark,
      //
      //         merchantDisplayName: 'Adnan')).then((value)async{
      //
      //         });

      ///now finally display payment sheeet
      // CreateTokenParams params = CreateTokenParams(name: "Marwan");
      //         Stripe.instance.createToken(params).then((value) => print(value.id));
      // displayPaymentSheet();
      print("Success");
    } catch (e, s) {
      print('exception:$e$s');
AppDialog.paymentFailed(context);
      print("Canclled");

    }
  }

  displayPaymentSheet() async {

    try {

      await Stripe.instance.presentPaymentSheet(
      ).then((value){
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.check_circle, color: Colors.green,),
                      Text("Payment Successfull"),
                    ],
                  ),
                ],
              ),
            ));
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("paid successfully")));
        // AllOrdersGetxController.to.createOrder();


        paymentIntent = null;

      }).onError((error, stackTrace){
        print('Error is:--->$error $stackTrace');
      });


    } on StripeException catch (e) {
      print('Error is:---> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
            content: Text("Cancelled "),
          ));
    } catch (e) {
      print('$e');
    }
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent() async {




      if(cardNumber.isEmpty || expiryDate.isEmpty || cvvCode.isEmpty){
        customSnackBar(
          title: "تحذير",
          subtitle: "يرجى ملئ بيانات البطاقة لتتمكن من الدفع اونلاين",
          isWarning: true,
        );
      }else{
        try {
          Map<String, dynamic> body2 = {
            'type': "card",
            'card[number]': cardNumber,
            'billing_details[name]': cardHolderName,
            'card[exp_month]': expiryDate.split('\/').first,
            'card[exp_year]': expiryDate.split('\/').last,
            'card[cvc]': cvvCode,
          };

          var response2 = await http.post(
            Uri.parse('https://api.stripe.com/v1/payment_methods'),
            headers: {
              'Authorization': 'Bearer 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',
              'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: body2,
          );
          if(response2.body != null){
            AllOrdersGetxController.to.stripeToken.value = jsonDecode(response2.body)['id'];
            print("From Payment:: ${response2.statusCode}");
            print("From Payment:: ${response2}");
            if(response2.statusCode == 200){
              AllOrdersGetxController.to.createOrder(context, );
            }
          }




          //   curl https://api.stripe.com/v1/payment_methods \
          //   -u sk_test_51N7z6KIzeawi2iqgusVt0kG4EGKNy5F1ZJIfQbTI5dJnA9DGB5WXskSquYievlbMVyhiWQjJMpJA3HXp1bake13a00vKYnE5Sx: \
          // -d type=card \
          // -d "card[number]"=4242424242424242 \
          // -d "card[exp_month]"=8 \
          // -d "card[exp_year]"=2024 \
          // -d "card[cvc]"=314


          // v1/payment_methods
          // ignore: avoid_print
          print('Payment Intent Body->>> ${response2.body.toString()}');

          // if(response.statusCode == 200){
          //
          //   if(jsonDecode(response.body)['amount_received'] != "0"){
          //     AllOrdersGetxController.to.stripeToken.value = jsonDecode(response2.body)['id'];
          //     print(AllOrdersGetxController.to.stripeToken);
          return jsonDecode(response2.body);
          //   }
          // }else{
          //   Map map = {};
          //   return map;
          // }

        } catch (err) {
          // ignore: avoid_print
          print('err charging user: ${err.toString()}');
        }
      }

  }

  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 100 ;
    return calculatedAmout.toString();
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