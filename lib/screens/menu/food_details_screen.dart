// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:easy_localization/easy_localization.dart';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
// import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:rakwa/api/api_controllers/menu_api_controller.dart';
import 'package:rakwa/controller/all_address_getx_controller.dart';
import 'package:rakwa/controller/all_cart_getx_controller.dart';
import 'package:rakwa/controller/all_menu_getx_controller.dart';
import 'package:rakwa/controller/email_verified_getx_controller.dart';
import 'package:rakwa/controller/image_picker_controller.dart';
import 'package:rakwa/model/address.dart';
import 'package:rakwa/model/time_prayer.dart';
import 'package:rakwa/screens/cart/cart_screen.dart';
import 'package:rakwa/screens/menu/edit_menu_Item_screen.dart';
import 'package:rakwa/shared_preferences/shared_preferences.dart';
import 'package:rakwa/widget/app_dialog.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart'as picker;
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../app_colors/app_colors.dart';
import '../../card_month_input_formater.dart';
import '../../controller/all_orders_getx_controller.dart';
import '../../model/payment_card.dart';
import '../../widget/SnackBar/custom_snack_bar.dart';
import '../../widget/appbars/app_bars.dart';
import '../../widget/main_elevated_button.dart';
import '../../widget/work_hour_widget.dart';
import '../add_listing_screens/Controllers/add_work_controller.dart';
// import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'package:http/http.dart' as http;

import '../address/map_screen.dart';
class FoodDetailsScreen extends StatefulWidget {

  int foodId;
  int resId;
  int userId;
  FoodDetailsScreen({required this.foodId, required this.resId,required this.userId});
  @override
  State<FoodDetailsScreen> createState() => _FoodDetailsScreenState();
}

class _FoodDetailsScreenState extends State<FoodDetailsScreen> {
  // CarouselController buttonCarouselController = CarouselController();
  List<DateTime> activeDates = [];
  List<String> dates = [];
  String title = "";
  List<DateTime> inactiveDates = [];
  XFile? image;

  FocusNode cardNumberNode = FocusNode();
  FocusNode expireNode = FocusNode();
  FocusNode cvvNode = FocusNode();
  FocusNode nameNode = FocusNode();
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


  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expireDateController = TextEditingController();
  TextEditingController cvvNumberController = TextEditingController();
  TextEditingController cardNameController = TextEditingController();
  int currentIndex = 0;
  int difference = 0;
  List<String> list2= [
    "الحجم",
    "Crust",
    "الاضافات",
  ];

  DateTime fromDate = DateTime.now(); // Replace with your 'from' date
  DateTime toDate = DateTime.now().add(Duration(days: 7)); // Replace with your 'to' date

  // controller.map controller.map = {};
  int m  = 89;
  // int vartiantId = -1;
  String selectedPayment = "";

  List<int> extras = [];
  List<String> list= [
    "توصيل",
    "استلام",
  ];

  String selectedTypeDelivery = "";

  List<DateTime> getDateRange(DateTime startDate, DateTime endDate) {
    List<DateTime> dateRange = [];
    DateTime currentDate = startDate;

    // Loop through the dates and add them to the list until we reach the end date.
    while (currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
      dateRange.add(currentDate);
      currentDate = currentDate.add(Duration(days: 1));
    }

    return dateRange;
  }
  @override
  void initState() {
    // TODO: implement initState

    // inactiveDates.forEach((element) {
    //   print("Dates::: ${element.toLocal()}");
    // });
    Get.put(AllMenusGetxController());
    super.initState();
    // Get.put(AllCartsGetxController());
    // controller.map.clear();
    // vartiantId = -1;



    AllOrdersGetxController.to.typePay.value = "1";


    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
     await AllMenusGetxController.to.getItemDetails(itemId: widget.foodId.toString());


     if(AllMenusGetxController.to.itemDetails.first.data!.active_from != null){
       fromDate = DateTime(int.parse(AllMenusGetxController.to.itemDetails.first.data!.active_from!.split("-")[0]), int.parse(AllMenusGetxController.to.itemDetails.first.data!.active_from!.split("-")[1]), int.parse(AllMenusGetxController.to.itemDetails.first.data!.active_from!.split("-")[2]));
       toDate = DateTime(int.parse(AllMenusGetxController.to.itemDetails.first.data!.active_to!.split("-")[0]), int.parse(AllMenusGetxController.to.itemDetails.first.data!.active_to!.split("-")[1]), int.parse(AllMenusGetxController.to.itemDetails.first.data!.active_to!.split("-")[2]));

       // AllMenusGetxController.to.fromDate.value = "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
       // AllMenusGetxController.to.toDate.value = "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";

     }


     activeDates = getActiveDates(fromDate, toDate);
     // inactiveDates  = getInactiveDates(fromDate, toDate);



     activeDates.forEach((element) {
       dates.add(element.toLocal().toString().replaceAll('00:00:00.000', ''));
       // dates.add(element.toLocal());
     });

     AllMenusGetxController.to.getEvents(id: widget.foodId.toString());
     if(AllCartsGetxController.to.carts.isNotEmpty){
       int index = AllCartsGetxController.to.carts.first.data!.indexWhere((element) => element.itemId == AllMenusGetxController.to.itemDetails.first.data!.id);

       print("index:: $index");
     if(index != -1){
       AllMenusGetxController.to.count.value = AllCartsGetxController.to.carts.first.data![index].quantity;
       print(AllCartsGetxController.to.count.value);
     }

     }

     await  AllOrdersGetxController.to.getFees(resId: widget.resId.toString());



    });


 print(widget.foodId);
  }


  //  getTitle(){
  //    AllMenusGetxController.to.itemDetails.first.data!.active_from != null ?
  //     title = "تفاصيل الحجز": title = "تفاصيل الوجبة";
  // }
  List<DateTime> getActiveDates(DateTime fromDate, DateTime toDate) {
    List<DateTime> activeDates = [];
    DateTime currentDate = fromDate;

    while (currentDate.isBefore(toDate) || currentDate.isAtSameMomentAs(toDate)) {
      activeDates.add(currentDate);
      currentDate = currentDate.add(Duration(days: 1));
    }

    return activeDates;
  }

  List<DateTime> getInactiveDates(DateTime fromDate, DateTime toDate) {
    List<DateTime> inactiveDates = [];
    DateTime currentDate = fromDate;

    print("from inactive dates");
    while (currentDate.isBefore(toDate) || currentDate.isAtSameMomentAs(toDate)) {
      // Check if the date is not active (i.e., not in the active date list)
      if (!activeDates.contains(currentDate)) {
        inactiveDates.add(currentDate);
      }
      currentDate = currentDate.add(Duration(days: 1));
    }

    return inactiveDates;
  }

  @override
  Widget build(BuildContext context) {
    print("URI::::; ${AllMenusGetxController.to.fromDate.value}");
    print("URI::::; ${AllMenusGetxController.to.fromTime.value}");
    print("URI::::; ${AllMenusGetxController.to.toDate.value}");
    print("URI::::; ${AllMenusGetxController.to.toTime.value}");
    var box = GetStorage();
    if( AllOrdersGetxController.to.deliveryType.value == "delivery"){
      selectedTypeDelivery = list.first;
    }else{
      selectedTypeDelivery = list.last;
    }

    return GetX<AllMenusGetxController>(
      builder: (c2) {
        return Scaffold(
          resizeToAvoidBottomInset: true,

          appBar: AppBars.appBarDefault(title:  c2.title.value,
              secondIconImage: Visibility(
                visible: SharedPrefController().isLogined,
                child: InkWell(
                  onTap: () => Get.to(CartScreen()),
                  child: Stack(
                    children: [
                      Container(width: 120.w, height: 100.h,),
                      PositionedDirectional(
                          end: 20.w,
                          top: 10.h,
                          child: Icon(Icons.shopping_cart)),
                      PositionedDirectional(
                        end: 30.w,
                        child: GetX<AllCartsGetxController>(
                            builder: (c) {
                              return Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppColors().mainColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(c.carts.isEmpty ? "0" :c.carts.first.data!.length.toString()),
                              );
                            }
                        ),
                      )
                    ],
                  ),
                ),
              )
          ),
          body: GetX<AllMenusGetxController>(
            builder: (controller) {
              return controller.isLoading.value ? Shimmer.fromColors(
                  baseColor: Colors.grey.shade100,
                  highlightColor: Colors.grey.shade300,
                  child:  ListView(
                    padding: EdgeInsetsDirectional.only(
                        start: 16.w,
                        end: 16.w,
                        bottom: 34.h
                    ),
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    children: [
                      Container(
                        height: 336.h,
                        width: Get.width,
                          padding: EdgeInsets.symmetric(vertical: 4),

                          decoration:  BoxDecoration(color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                      ),
                      SizedBox(height: 18.h,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 90.w,
                            height: 30.h,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(4.r)
                            ),
                          ),

                          Container(
                            width: 90.w,
                            height: 30.h,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(4.r)
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h,),
                      Container(
                        width: 90.w,
                        height: 30.h,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(4.r)
                        ),
                      ),

                      SizedBox(height: 12.h,),
                      Container(
                        width: 90.w,
                        height: 90.h,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(4.r)
                        ),
                      ),
                      SizedBox(height: 8.h,),

                    ],
                  )

              ):
              KeyboardActions(
                bottomAvoiderScrollPhysics: ScrollPhysics(),

                tapOutsideBehavior: TapOutsideBehavior.opaqueDismiss,
                config: _buildConfig(context),
                tapOutsideToDismiss:true,
                overscroll: 30,
                autoScroll: true,
                child: ListView(
                  padding: EdgeInsetsDirectional.only(
                    start: 16.w,
                    end: 16.w,
                    bottom: 34.h
                  ),
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  children: [
                    Container(
                      height: 336.h,
                      width: Get.width,
                      clipBehavior: Clip.antiAlias,
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,


                      ),
                      child:
                      // CarouselSlider(
                      //   carouselController: buttonCarouselController,
                      //   options: CarouselOptions(
                      //
                      //     height: double.infinity,
                      //     // autoPlay: true,
                      //     viewportFraction: .96,
                      //     reverse: false,
                      //     autoPlayInterval: Duration(seconds: 3),
                      //     autoPlayAnimationDuration: Duration(milliseconds: 800),
                      //     autoPlayCurve: Curves.fastOutSlowIn,
                      //     enlargeCenterPage: true,
                      //     enlargeFactor: 0.4,
                      //     scrollDirection: Axis.horizontal,
                      //     onPageChanged: (int? index, x){
                      //       setState(() {
                      //         currentIndex = index!;
                      //         print(currentIndex);
                      //       });
                      //     }
                      //   ),
                      //   items: list.controller.map((i) {
                      //     return Builder(
                      //       builder: (BuildContext context) {
                      //         return Container(
                      //           padding: EdgeInsets.symmetric(vertical: 4),
                      //           width: double.infinity,
                      //           decoration: const BoxDecoration(color: Colors.white),
                      //           child: ClipRRect(
                      //             borderRadius: BorderRadius.circular(16),
                      //             child: Stack(
                      //               children: [
                      //
                      //                 Image.network(
                      //                      controller.itemDetails.first.image ?? "",
                      //                     fit: BoxFit.cover,
                      //                     width: Get.width,
                      //                     height: double.infinity,
                      //                     errorBuilder: (BuildContext context, Object? exception, StackTrace? stackTrace) {
                      //                       return Image.asset("images/logo.jpg",
                      //                         width: Get.width,
                      //                         height: double.infinity,
                      //                         fit: BoxFit.cover,
                      //                       );
                      //                     }
                      //                 ),
                      //
                      //
                      //                 Positioned.fill(
                      //                   child: Container(
                      //                     decoration:  BoxDecoration(
                      //                         gradient: LinearGradient(
                      //                             begin: Alignment.topCenter,
                      //                             end: Alignment.bottomCenter,
                      //                             colors: [
                      //                               Colors.black.withOpacity(0.10),
                      //                               Colors.black.withOpacity(0.66),
                      //                             ])),
                      //                   ),
                      //                 ),
                      //                 PositionedDirectional(
                      //                   start: 0,
                      //                   end: 0,
                      //                   bottom: 12.h,
                      //                   child: Row(
                      //                     mainAxisAlignment: MainAxisAlignment.center,
                      //                     children: list.controller.map((idx) {
                      //                       return Container(
                      //                           width: currentIndex == list.indexOf(idx) ? 24.w:  6.0.w,
                      //                           height: 6.0.h,
                      //                           margin: EdgeInsets.symmetric(horizontal: 6.0.w),
                      //                           decoration: currentIndex == list.indexOf(idx) ?  BoxDecoration(
                      //                               shape:  BoxShape.rectangle ,
                      //                               borderRadius:
                      //                               BorderRadius.circular(20.r) ,
                      //                               color: AppColors().mainColor) : BoxDecoration(
                      //                               shape:  BoxShape.circle,
                      //                               color:  Colors.white
                      //                           )
                      //                         // .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                      //                       );
                      //                     }).toList(),
                      //                   ),
                      //                 ),
                      //
                      //               ],
                      //             ),
                      //           ),
                      //         );
                      //       },
                      //     );
                      //   }).toList(),
                      // ),
                      Stack(
                        children: [

                          controller.itemDetails.isEmpty ? Container():   Image.network(
                             "https://rakwa.me//${controller.itemDetails.first.data!.logom }"?? "",
                              fit: BoxFit.cover,
                              width: Get.width,
                              height: double.infinity,
                              errorBuilder: (BuildContext context, Object? exception, StackTrace? stackTrace) {
                                return Image.asset("images/logo.jpg",
                                  width: Get.width,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
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
                        ],
                      ),
                    ),
                    SizedBox(height: 18.h,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(controller.itemDetails.first.data!.name ?? "",
                            style: GoogleFonts.notoKufiArabic(
                              textStyle:  TextStyle(
                                fontSize: 14.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),),),
                        ),
                        Text("${controller.itemDetails.first.data!.active_from != null ? "${controller.price.toString()} \$" :"${controller.itemDetails.first.data!.price ?? ""} ليرة"}  ",
                          style: GoogleFonts.notoKufiArabic(
                            textStyle:  TextStyle(
                              fontSize: 24.sp,
                              color: Color(0xFF6B7280),
                              fontWeight: FontWeight.bold,
                            ),),)
                      ],
                    ),
                    SizedBox(height: 24.h,),
                    Padding(
                      padding: EdgeInsetsDirectional.only(start: 3.w),
                      child: Text("التفاصيل",
                        style: GoogleFonts.notoKufiArabic(
                          textStyle:  TextStyle(
                            fontSize: 12.sp,
                            color: Colors.black,
                          ),),),
                    ),
                    SizedBox(height: 12.h,),

                    Padding(
                      padding: EdgeInsetsDirectional.only(start: 3.w),
                      child: Text(controller.itemDetails.first.data!.description ?? "",
                        style: GoogleFonts.notoKufiArabic(
                          textStyle:  TextStyle(
                            fontSize: 12.sp,
                            color: Colors.black,
                          ),),),
                    ),

                    SizedBox(height: 8.h,),

                    Divider(indent: 16.w, endIndent: 16.w),

                 ListView.builder(
                   shrinkWrap: true,
                     physics: ScrollPhysics(),
                     itemCount: controller.itemDetails.first.data!.options!.length,
                     itemBuilder: (context, index){
                   return  Column(
                   crossAxisAlignment: CrossAxisAlignment.start,

                   children: [
                   SizedBox(height: 24.h,),

                   Text(controller.itemDetails.first.data!.options![index].name ?? "",
                   style: GoogleFonts.notoKufiArabic(
                   textStyle: TextStyle(
                   fontSize: 14.sp,
                   color: Colors.black,
                   ),
                   ),
                   textAlign: TextAlign.start,
                   ),
                   SizedBox(height: 16.h,),
                   ListView(
                   shrinkWrap: true,
                   physics: ScrollPhysics(),
                   children:  controller.itemDetails.first.data!.options![index].options!.split(',').map<Container>((item) =>
                Container(
                margin: EdgeInsets.only(bottom: 16.h),
                decoration: BoxDecoration(
                border: Border.all(
                color: controller.optionsValues[index] == item? AppColors().mainColor
                : Color(0xFFF4F4F4)
                )
                ),
                child: RadioListTile(

                activeColor: AppColors().mainColor,
                value: item,
                groupValue: controller.optionsValues[index],
                title: Text(item,
                style: GoogleFonts.notoKufiArabic(
                textStyle: TextStyle(
                fontSize: 12.sp,
                color: Colors.black,
                ),),),
                onChanged: (value) {
                  setState(() {
                    controller.optionsValues[index] = value!;

                    print(item);
                    // controller.map.value = controller.itemDetails.first.data!.variants![controller.itemDetails.first.data!.variants!.indexWhere((element) => element.options!.contains(item))].options ?? "";
                    m = 89;
                    // controller.map.clear();
                    // int i = controller.itemDetails.first.options!.length;
                    // print(i);

                    for(int i = 0; i < controller.itemDetails.first.data!.variants!.length; i++){
                      //   controller.map.addAll({
                      //     controller.itemDetails.first.data!.options![i].id.toString(): "${controller.optionsValues[i].trimLeft().toLowerCase().replaceAll(" ", '-')}",
                      //   });
                      // controller.map.value = "{${controller.itemDetails.first.data!.variants![i].options.toString()}: $item}";

                      print(controller.itemDetails.first.data!.variants![i].options);
                    }
                    for(int i = 0; i < controller.itemDetails.first.data!.options!.length; i++){
                    //   controller.map.addAll({
                    //     controller.itemDetails.first.data!.options![i].id.toString(): "${controller.optionsValues[i].trimLeft().toLowerCase().replaceAll(" ", '-')}",
                    //   });
                      controller.map.value = "{${controller.itemDetails.first.data!.options![i].id.toString()}: ${item.replaceAll(" ", "")}}";

                    }
                    // controller.map controller.map = {
                    //   "89" :"${controller.optionsValues[0].trimLeft().toLowerCase().replaceAll(" ", '-')}",
                    //   "90" :"${controller.optionsValues[1].trimLeft().toLowerCase().replaceAll(" ", "-")}" ,
                    // };

// print(controller.map.toString().replaceAll("{", "").replaceAll("}", "").replaceAll(", ", ","));
                    print("controller.map::: ${controller.map}");
                    // "{\"89\":\"small\",\"90\":\"hand-tosset\"}"
                    // print(controller.itemDetails.first.variants!.first.options!.replaceAll("\\", "").toString().replaceAll("\"", "").replaceAll("{", "").replaceAll("}", "").replaceAll(":", ": "));
                 // print(   controller.itemDetails.first.data!.variants!.where((e) => e.options!.replaceAll("\\", "").toString().replaceAll("\"", "").replaceAll("{", "").replaceAll("}", "").replaceAll(":", ": ") == controller.map.toString().replaceAll("{", "").replaceAll("}", "").replaceAll(", ", ",").trim()).first.id);

                    // controller.vartiantId.value =   AllMenusGetxController.to.itemDetails.first.data!.variants!.where((e) => e.options == controller.map.value).first.id!;
                    controller.vartiantId.value =   controller.itemDetails.first.data!.variants!.where((e) => e.options! == controller.map.value).first.id!;
                    controller.itemDetails.first.data!.price =   controller.itemDetails.first.data!.variants!.where((e) => e.options! == controller.map.value).first.price!;
           print( controller.vartiantId.value);
                  });
                }),
                )
                ).toList(),
                ),

                // ListView.builder(
                //     shrinkWrap: true,
                //     physics: ScrollPhysics(),
                //     itemCount: 3,
                //     itemBuilder: (context, index){
                //       return  Container(
                //         margin: EdgeInsets.only(bottom: 16.h),
                //         decoration: BoxDecoration(
                //             border: Border.all(
                //                 // color: AppColors().mainColor
                //               color: Color(0xFFF4F4F4)
                //             )
                //         ),
                //         child:  RadioListTile(
                //
                //             activeColor: AppColors().mainColor,
                //             value: true,
                //             groupValue: true,
                //             title: Text(e.options!.split(",").controller.map((e) => e).toString(),
                //               style: GoogleFonts.notoKufiArabic(
                //                 textStyle: TextStyle(
                //                   fontSize: 12.sp,
                //                   color: Colors.black,
                //                 ),),),
                //             onChanged: (value){}),
                //       );
                //
                //     }),
                Divider(),
                ],
                );
                 }),
                 // Column(
                 //   children:  controller.itemDetails.first.options!.controller.map((e) {
                 //     return Column(
                 //       crossAxisAlignment: CrossAxisAlignment.start,
                 //
                 //       children: [
                 //         SizedBox(height: 24.h,),
                 //
                 //         Text(e.name ?? "",
                 //           style: GoogleFonts.notoKufiArabic(
                 //             textStyle: TextStyle(
                 //               fontSize: 14.sp,
                 //               color: Colors.black,
                 //             ),
                 //           ),
                 //         textAlign: TextAlign.start,
                 //         ),
                 //         SizedBox(height: 16.h,),
                 //        ListView(
                 //          shrinkWrap: true,
                 //          physics: ScrollPhysics(),
                 //          children:  e.options!.split(',').controller.map<Container>((item) =>
                 //        Container(
                 //              margin: EdgeInsets.only(bottom: 16.h),
                 //              decoration: BoxDecoration(
                 //                  border: Border.all(
                 //                    // color: AppColors().mainColor
                 //                      color: Color(0xFFF4F4F4)
                 //                  )
                 //              ),
                 //              child: RadioListTile(
                 //
                 //                  activeColor: AppColors().mainColor,
                 //                  value: controller.optionsValues.where((element) => element == item).first,
                 //                  groupValue: controller.optionsGroupValues,
                 //                  title: Text(item,
                 //                    style: GoogleFonts.notoKufiArabic(
                 //                      textStyle: TextStyle(
                 //                        fontSize: 12.sp,
                 //                        color: Colors.black,
                 //                      ),),),
                 //                  onChanged: (value) {}),
                 //            )
                 //         ).toList(),
                 //        ),
                 //
                 //         // ListView.builder(
                 //         //     shrinkWrap: true,
                 //         //     physics: ScrollPhysics(),
                 //         //     itemCount: 3,
                 //         //     itemBuilder: (context, index){
                 //         //       return  Container(
                 //         //         margin: EdgeInsets.only(bottom: 16.h),
                 //         //         decoration: BoxDecoration(
                 //         //             border: Border.all(
                 //         //                 // color: AppColors().mainColor
                 //         //               color: Color(0xFFF4F4F4)
                 //         //             )
                 //         //         ),
                 //         //         child:  RadioListTile(
                 //         //
                 //         //             activeColor: AppColors().mainColor,
                 //         //             value: true,
                 //         //             groupValue: true,
                 //         //             title: Text(e.options!.split(",").controller.map((e) => e).toString(),
                 //         //               style: GoogleFonts.notoKufiArabic(
                 //         //                 textStyle: TextStyle(
                 //         //                   fontSize: 12.sp,
                 //         //                   color: Colors.black,
                 //         //                 ),),),
                 //         //             onChanged: (value){}),
                 //         //       );
                 //         //
                 //         //     }),
                 //   Divider(height: 0,),
                 //       ],
                 //     );
                 //   }).toList(),
                 //
                 // ),
                  controller.itemDetails.first.data!.extras!.isNotEmpty ?
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Extras",
                          style: GoogleFonts.notoKufiArabic(
                            textStyle: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.black,
                            ),
                          ),
                          textAlign: TextAlign.start,
                        ),

                        SizedBox(height: 10.h,),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemCount: controller.itemDetails.first.data!.extras!.length,

                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            itemBuilder: (context , index){
                          return InkWell(
                            onTap: (){
                              print("Click");
                              setState(() {
                                if(!extras.contains(controller.itemDetails.first.data!.extras![index].id)){
                                  extras.add(controller.itemDetails.first.data!.extras![index].id!);
                                }else{
                                  extras.remove(controller.itemDetails.first.data!.extras![index].id);
                                }
                              });



                              print(extras);
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 10.h),
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: extras.contains(controller.itemDetails.first.data!.extras![index].id) ?
                                  AppColors().mainColor : Color(0xFFF4F4F4)
                                )
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                          value: extras.contains(controller.itemDetails.first.data!.extras![index].id),
                                          activeColor: AppColors().mainColor,
                                          onChanged: (value){
                                            setState(() {
                                              if(!extras.contains(controller.itemDetails.first.data!.extras![index].id)){
                                                extras.add(controller.itemDetails.first.data!.extras![index].id!);
                                              }else{
                                                extras.remove(controller.itemDetails.first.data!.extras![index].id);
                                              }
                                            });

                                          }),
                                      Text(controller.itemDetails.first.data!.extras![index].name ?? "",
                                        style: GoogleFonts.notoKufiArabic(
                                          textStyle: TextStyle(
                                            fontSize: 14.sp,
                                            color: Colors.black,
                                          ),
                                        ),

                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  ),

                              Text("${controller.itemDetails.first.data!.extras![index].price.toString()}+",
                                style: GoogleFonts.notoKufiArabic(
                                  textStyle: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.black,
                                  ),
                                ),
                              )
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ) : Container(),
                    // DateRangePickerWidget(
                    //   disabledDates: inactiveDates,
                    //   initialDisplayedDate: DateTime.now(),
                    //   onPeriodChanged: (Period value) {  },),
                    Visibility(
                      visible: controller.itemDetails.first.data!.active_from != null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          picker.SfDateRangePicker(

selectableDayPredicate: (d){

  print("Date:::::::::::::: ${d.year}-${d.month.toString().length == 1 ? '0${d.month}': d.month}-${d.day.toString().length == 1 ? '0${d.day}' :d.day}");
  print(controller.startBookingDates.contains("${d.year}-${d.month}-${d.day}"));
  return !controller.startBookingDates.contains("${d.year}-${d.month.toString().length == 1 ? '0${d.month}': d.month}-${d.day.toString().length == 1 ? '0${d.day}' :d.day}");
          // || controller.endBookingDates.contains("${d.year}-${d.month.toString().length == 1 ? '0${d.month}': d.month}-${d.day.toString().length == 1 ? '0${d.day}' :d.day}")  ? false:true ;
},

minDate: fromDate,
                            maxDate: toDate,
                              onSelectionChanged: (v){

                                // print(v.value.endDate.toString().replaceAll("00:00:00.000", ""));
                                // print(v.value.startDate.toString().replaceAll("00:00:00.000", ""));

                                // if(dates.contains(v.value.startDate.toString().replaceAll("00:00:00.000", "")) || dates.contains(v.value.endDate.toString().replaceAll("00:00:00.000", "")) ){
                                //   print("Yes");
                                //   controller.selectable.value = true;

                                  print(controller.fromDate.value);
                                  print(controller.toDate.value);
                                  DateTime? date;
                                  DateTime? date2;
                                  if( v.value.startDate != null){
                                    controller.fromDate.value = v.value.startDate.toString().replaceAll("00:00:00.000", "");

                                    if(v.value.endDate == null){
                                      controller.toDate.value = controller.fromDate.value;

                                    }
                                    print(controller.toDate.value);
                                    print(controller.fromDate.value);
                                    date  = DateTime(int.parse(controller.fromDate.value.split('-')[0]),int.parse(controller.fromDate.value.split('-')[1]),int.parse(controller.fromDate.value.split('-')[2]));
                                  }else{
                                    controller.fromDate.value = "";

                                  }


                                  if( v.value.endDate != null){
                                    controller.toDate.value = v.value.endDate.toString().replaceAll("00:00:00.000", "");

                                    date2 = DateTime(int.parse(controller.toDate.value.split('-')[0]),int.parse(controller.toDate.value.split('-')[1]),int.parse(controller.toDate.value.split('-')[2]));

                                  }else{
                                    controller.toDate.value = "";
                                  }
                                  if(date2 != null && date != null ){


                                    print("from not nulll");
                                    List<DateTime> dateRange = getDateRange(date, date2);
                                    List<String> dates = [];
                                     for (DateTime date in dateRange) {
                                       dates.add(
                                          date.toString().replaceAll(" 00:00:00.000", ""));
                                      print("Range::::${date.toString()}");
                                      print("List:::: ${dates}");

                                    }
                                    // print(dateRange);
                                    if(AllMenusGetxController.to.startBookingDates.isNotEmpty){
                                      for(int i = 0; i < AllMenusGetxController.to.startBookingDates.length; i++){
                                        print("from for");
                                        if(dates.contains(AllMenusGetxController.to.startBookingDates[i])){

                                          v.value.startDate  = null;
                                          v.value.endDate  = null;
                                          print("Result::: true");
                                          // if( v.value.endDate  != null){
                                          //   print("from end");
                                          //   v.value.startDate  =  v.value.endDate;
                                          // //   controller.fromDate.value = "";
                                          // }else{
                                          //   print("from start");
                                          //
                                          //   v.value.endDate  =  v.value.startDate ;
                                          //
                                          // }

                                        }
                                        else{
                                          print("Result::: false");
                                          difference = date2.difference(date).inDays;
                                          controller.price.value = difference * int.parse(controller.itemDetails.first.data!.price.toString());
                                          print("Diff:: ${difference}");
                                          if(difference == 0){
                                            controller.price.value = int.parse(controller.itemDetails.first.data!.price.toString());

                                            controller.toDate.value = controller.fromDate.value;

                                            controller.list.first =  "دفع 30% من المبلغ ${(( (AllMenusGetxController.to.price.value ) ) * 0.30).toInt()} \$ ";
                                            // controller.list.last =   "دفع المبلغ كامل ${(( (AllMenusGetxController.to.price.value ) )).toInt()} ليرة ";


                                            print(controller.fromDate.value);
                                            print(controller.toDate.value);
                                            setState(() {

                                            });
                                          }else{
                                            controller.list.first =  "دفع 30% من المبلغ ${(( (AllMenusGetxController.to.price.value ) ) * 0.30).toInt()} \$ ";
                                            // controller.list.last =   "دفع المبلغ كامل ${(( (AllMenusGetxController.to.price.value ) )).toInt()} ليرة ";
                                            print(controller.toDate.value);
                                            print(controller.fromDate.value);
                                            controller.selectedPayment = controller.list.first;
                                            setState(() {

                                            });
                                          }

                                        }
                                      }
                                    }else{
                                      difference = date2.difference(date).inDays;
                                      controller.price.value = difference * int.parse(controller.itemDetails.first.data!.price.toString());
                                      print("Diff:: ${difference}");
                                      if(difference == 0){
                                        controller.price.value = int.parse(controller.itemDetails.first.data!.price.toString());

                                        controller.toDate.value = controller.fromDate.value;

                                        controller.list.first =  "دفع 30% من المبلغ ${(( (AllMenusGetxController.to.price.value ) ) * 0.30).toInt()} \$ ";
                                        // controller.list.last =   "دفع المبلغ كامل ${(( (AllMenusGetxController.to.price.value ) )).toInt()} ليرة ";


                                        print(controller.fromDate.value);
                                        print(controller.toDate.value);
                                        setState(() {

                                        });
                                      }else{
                                        controller.list.first =  "دفع 30% من المبلغ ${(( (AllMenusGetxController.to.price.value ) ) * 0.30).toInt()} \$ ";
                                        // controller.list.last =   "دفع المبلغ كامل ${(( (AllMenusGetxController.to.price.value ) )).toInt()} ليرة ";
                                        print(controller.toDate.value);
                                        print(controller.fromDate.value);
                                        controller.selectedPayment = controller.list.first;
                                        setState(() {

                                        });
                                      }
                                    }






                                  }else{
                                    controller.price.value =  int.parse(controller.itemDetails.first.data!.price.toString());
                                    controller.list.first =  "دفع 30% من المبلغ ${(  AllMenusGetxController.to.price.value * 0.30).toInt()} \$ ";
                                    // controller.list.last =   "دفع المبلغ كامل ${  AllMenusGetxController.to.price.value} ليرة ";
                                    controller.selectedPayment = controller.list.first;

                                    setState(() {
                                    });
                                  }



                                // }else{
                                //   print("No");
                                //   controller.price.value = int.parse(controller.itemDetails.first.data!.price.toString());
                                //
                                //   controller.selectable.value = false;
                                // }
                              },

                              enablePastDates: false,
                              selectionMode: picker.DateRangePickerSelectionMode.range,

                              // initialSelectedRange: PickerDateRange(
                              //     fromDate,
                              //     toDate
                              //   // DateTime.now().subtract(const Duration(days: 4)),
                              //   // DateTime.now().add(const Duration(days: 3))),
                              // )
                          ),
                          controller.itemDetails.first.data!.insurance == null ? Container() :     Row(
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.only(start: 3.w),
                                child: Text("التأمين",
                                  style: GoogleFonts.notoKufiArabic(
                                    textStyle:  TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.black,
                                    ),),),
                              ),
                              SizedBox(width: 10.w,),
                              Text("${controller.itemDetails.first.data!.insurance.toString()} \$ ",
                                style: GoogleFonts.notoKufiArabic(
                                  textStyle:  TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.black,
                                  ),),),
                            ],
                          ),
                          controller.itemDetails.first.data!.clean == null  ? Container() :   Row(
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.only(start: 3.w),
                                child: Text("النظافة",
                                  style: GoogleFonts.notoKufiArabic(
                                    textStyle:  TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.black,
                                    ),),),
                              ),
                              SizedBox(width: 10.w,),
                              Text("${controller.itemDetails.first.data!.clean.toString()} \$ ",
                                style: GoogleFonts.notoKufiArabic(
                                  textStyle:  TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.black,
                                  ),),),
                            ],
                          ),
                          SizedBox(height: 40.h,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              Text("وقت الحجز", style: GoogleFonts.notoKufiArabic(
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),),

                              Text("يمكنك تغيير الوقت من خلال الضغط على الوقت", style: GoogleFonts.notoKufiArabic(
                                textStyle: const TextStyle(
                                  fontSize: 10,
                                  // fontWeight: FontWeight.w500,

                                ),
                              ),),
                            ],
                          ),
                          SizedBox(height: 10.h,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () async {
                                  TimeOfDay? newTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay(hour: 8, minute: 30),
                                    cancelText: 'الغاء',
                                    confirmText: 'تم',
                                    builder: (context, child) {
                                      return Theme(
                                          data: ThemeData.light().copyWith(
                                            colorScheme:  ColorScheme.light(
                                              // change the border color
                                              primary: AppColors().mainColor,
                                              // change the text color
                                              onSurface: Colors.black,
                                            ),
                                            // button colors
                                            buttonTheme:  ButtonThemeData(
                                              colorScheme: ColorScheme.light(
                                                primary: AppColors().mainColor,
                                              ),
                                            ),
                                          ),
                                          child: child!);
                                    },
                                  );
                                  if (newTime != null) {
                                    print(newTime.hour.toString().length);
                                    if(newTime.hour.toString().length == 1){
                                      if(newTime.hour == 0){
                                        if(newTime.minute.toString().length == 1){
                                          controller.fromTime.value = "12:0${newTime.minute}";
                                        }else{
                                          controller.fromTime.value = "12:${newTime.minute}";
                                        }
                                      }else{
                                        if(newTime.minute.toString().length == 1){
                                          controller.fromTime.value = "0${newTime.hour}:0${newTime.minute}";
                                        }else{
                                          controller.fromTime.value = "0${newTime.hour}:${newTime.minute}";
                                        }
                                      }

                                    }else{

                if(newTime.minute.toString().length == 1) {

                  controller.fromTime.value = "${newTime.hour}:0${newTime.minute}";
                }else{
                  controller.fromTime.value = "${newTime.hour}:${newTime.minute}";

                }

                                    }
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 48.h,
                                  width: 106.w,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: AppColors.subTitleColor.withOpacity(0.3))),
                                  child: Text(
                                    // 'من ${AddWorkOrAdsController.to.days[index][2].hour}:${AddWorkOrAdsController.to.days[index][2].minute}',
                                    // "from",
                                    "من ${  controller.fromTime.value}",
                                    style: GoogleFonts.notoKufiArabic(
                                      textStyle: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),),
                              ),
                              InkWell(
                                onTap: () async {
                                  TimeOfDay? newTime = await showTimePicker(
                                    context: context,
                                    initialTime: AddWorkOrAdsController.to.days[0][3],
                                    cancelText: 'الغاء',
                                    confirmText: 'تم',
                                    builder: (context, child) {
                                      return Theme(
                                          data: ThemeData.light().copyWith(
                                            colorScheme:  ColorScheme.light(
                                              // change the border color
                                              primary: AppColors().mainColor,
                                              // change the text color
                                              onSurface: Colors.black,
                                            ),
                                            // button colors
                                            buttonTheme:  ButtonThemeData(
                                              colorScheme: ColorScheme.light(
                                                primary: AppColors().mainColor,
                                              ),
                                            ),
                                          ),
                                          child: child!);
                                    },
                                  );
                                  if (newTime != null) {
                                    print(newTime.hour.toString().length);
                                    if(newTime.hour.toString().length == 1){
                                      if(newTime.hour == 0){
                                        if(newTime.minute.toString().length == 1){
                                          controller.toTime.value = "12:0${newTime.minute}";
                                        }else{
                                          controller.toTime.value = "12:${newTime.minute}";
                                        }
                                      }else{
                                        if(newTime.minute.toString().length == 1){
                                          controller.toTime.value = "0${newTime.hour}:0${newTime.minute}";
                                        }else{
                                          controller.toTime.value = "0${newTime.hour}:${newTime.minute}";
                                        }
                                      }

                                    }else{

                                      if(newTime.minute.toString().length == 1) {

                                        controller.toTime.value = "${newTime.hour}:0${newTime.minute}";
                                      }else{
                                        controller.toTime.value = "${newTime.hour}:${newTime.minute}";

                                      }

                                    }
                                  }
                                },
                                child: Container(
                                    alignment: Alignment.center,
                                    height: 48.h,
                                    width: 106.w,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: AppColors.subTitleColor.withOpacity(0.3))),
                                    child: Text(
                                      // 'الى ${AddWorkOrAdsController.to.days[index][3].hour}:${AddWorkOrAdsController.to.days[index][3].minute}',
                                      // "To",
                                      "الى ${  controller.toTime.value}",
                                      style: GoogleFonts.notoKufiArabic(
                                          textStyle: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          )),
                                    )),
                              ),
                            ],
                          ),
                          SizedBox(height: 15.h,),
                          Text("الدفع", style: GoogleFonts.notoKufiArabic(
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),),
                          SizedBox(height: 10.h,),


                          Visibility(
                            visible: controller.itemDetails.first.type == 4 || controller.itemDetails.first.type == 5,

                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemCount: AllMenusGetxController.to.list.length,
                                itemBuilder: (context, index){
                                  return Container(
                                    margin: EdgeInsets.only(bottom: 16.h),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color:  AllMenusGetxController.to.selectedPayment == AllMenusGetxController.to.list[index] ?  AppColors().mainColor
                                                : Color(0xFFF4F4F4)
                                        )
                                    ),
                                    child: RadioListTile(
                                        activeColor: AppColors().mainColor,
                                        value: AllMenusGetxController.to.list[index],
                                        groupValue:  AllMenusGetxController.to.selectedPayment,
                                        title: Text(AllMenusGetxController.to.list[index],
                                          style: GoogleFonts.notoKufiArabic(
                                            textStyle: TextStyle(
                                              fontSize: 12.sp,
                                              color: Colors.black,
                                            ),),),
                                        onChanged: (value){

                                          setState(() {
                                            AllMenusGetxController.to.selectedPayment = AllMenusGetxController.to.list[index];

                                          });
                                          print(selectedPayment);

                                          // if( AllMenusGetxController.to.selectedPayment == AllMenusGetxController.to.list.first){
                                          //   AllOrdersGetxController.to.typePay.value = "1";
                                          // }else{
                                          //   AllOrdersGetxController.to.typePay.value = "0";
                                          // }

                                        }),
                                  );

                                }),
                          ),


                          Visibility(
                            visible: controller.itemDetails.first.type == 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text("رخصة القيادة", style: GoogleFonts.notoKufiArabic(
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),),
                                SizedBox(height: 15.h,),

                                GetX<ImagePickerController>(
                                  builder: (pic) {
                                    print(pic.ldrive);
                                    return InkWell(
                                      onTap: ()async{
                                        ImagePicker picker = ImagePicker();
// Pick an image.
                                        image = await picker.pickImage(source: ImageSource.gallery);
                                        if(image != null){
                                          pic.ldrive.value = image!.path;
                                        }
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.upload_rounded),
                                              Text("ارفع رخصة القيادة من هنا", style: GoogleFonts.notoKufiArabic(
                                                textStyle: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),),
                                            ],
                                          ),
                                       image == null ? Container() :    Image.file(File(pic.ldrive.value),width: 70.w, height: 70.h,fit: BoxFit.cover,),

                                        ],
                                      ),
                                    );
                                  }
                                ),
                                SizedBox(height: 15.h,),
                                Visibility(
                                  // visible: controller.itemDetails.first.can_deliver == 1,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("الاستلام", style: GoogleFonts.notoKufiArabic(
                                        textStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),),
                                      SizedBox(height: 10.h,),
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
                                                    value: AllAddressGetxController.to.selectedAddress,
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
                                                    items: AllAddressGetxController.to.addresses.map<DropdownMenuItem<UserAddress>>((value){
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
                                                          AllAddressGetxController.to.selectedAddress = value;
                                                          AllOrdersGetxController.to.addressId.value = AllAddressGetxController.to.selectedAddress!.id ?? 0;
                                                          AllOrdersGetxController.to.address.value = AllAddressGetxController.to.selectedAddress!.address ?? "";

                                                          print(AllOrdersGetxController.to.fees.where((p0) => p0.address == AllOrdersGetxController.to.address.value).first.costTotal.toString());
                                                          AllOrdersGetxController.to.costDelivery.value =   AllOrdersGetxController.to.fees.where((p0) => p0.address == AllOrdersGetxController.to.address.value).first.costTotal.toString();
                                                        }else{
                                                          AppDialog.errorDialog(context, error: "موقعكم خارج نطاق التوصيل");
                                                          return null;
                                                        }


                                                        print("Cost::: ${AllOrdersGetxController.to.costDelivery.value}");

                                                        // print(selectedAddress!.id);

                                                      });
                                                    }),
                                              ),
                                            ),
                                            Visibility(
                                              visible: AllOrdersGetxController.to.costDelivery.value.isNotEmpty,
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

                                                  Text("${AllOrdersGetxController.to.costDelivery.value.isEmpty ? "" : '${AllOrdersGetxController.to.costDelivery.value }\$' }",
                                                    style: GoogleFonts.notoKufiArabic(
                                                      textStyle:  TextStyle(
                                                        fontSize: 12.sp,
                                                        color: AppColors().mainColor,
                                                      ),),),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                    ],
                                  ),
                                ),

                              ],
                            ),
                          ),


                          Column(
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
                        ],
                      ),
                    ),



                    // WorkHourWidget(
                    //   amChild: Text(
                    //     // 'من ${AddWorkOrAdsController.to.days[index][2].hour}:${AddWorkOrAdsController.to.days[index][2].minute}',
                    //   // "from",
                    //     style: GoogleFonts.notoKufiArabic(
                    //       textStyle: const TextStyle(
                    //         fontSize: 14,
                    //         fontWeight: FontWeight.w500,
                    //       ),
                    //     ),
                    //   ),
                    //   pmChild: Text(
                    //     // 'الى ${AddWorkOrAdsController.to.days[index][3].hour}:${AddWorkOrAdsController.to.days[index][3].minute}',
                    //    "To",
                    //     style: GoogleFonts.notoKufiArabic(
                    //         textStyle: const TextStyle(
                    //           fontSize: 14,
                    //           fontWeight: FontWeight.w500,
                    //         )),
                    //   ),
                    //   onTapAm: () async {
                    //     TimeOfDay? newTime = await showTimePicker(
                    //       context: context,
                    //       initialTime: AddWorkOrAdsController.to.days[0][2],
                    //       cancelText: 'الغاء',
                    //       confirmText: 'تم',
                    //       builder: (context, child) {
                    //         return Theme(
                    //             data: ThemeData.light().copyWith(
                    //               colorScheme:  ColorScheme.light(
                    //                 // change the border color
                    //                 primary: AppColors().mainColor,
                    //                 // change the text color
                    //                 onSurface: Colors.black,
                    //               ),
                    //               // button colors
                    //               buttonTheme:  ButtonThemeData(
                    //                 colorScheme: ColorScheme.light(
                    //                   primary: AppColors().mainColor,
                    //                 ),
                    //               ),
                    //             ),
                    //             child: child!);
                    //       },
                    //     );
                    //     if (newTime != null) {
                    //       // setState(() {
                    //       //   AddWorkOrAdsController.to.days[index][2] = newTime;
                    //       // });
                    //     }
                    //   },
                    //   onTapPm: () async {
                    //     TimeOfDay? newTime = await showTimePicker(
                    //       context: context,
                    //       initialTime: AddWorkOrAdsController.to.days[0][3],
                    //       cancelText: 'الغاء',
                    //       confirmText: 'تم',
                    //       builder: (context, child) {
                    //         return Theme(
                    //             data: ThemeData.light().copyWith(
                    //               colorScheme:  ColorScheme.light(
                    //                 // change the border color
                    //                 primary: AppColors().mainColor,
                    //                 // change the text color
                    //                 onSurface: Colors.black,
                    //               ),
                    //               // button colors
                    //               buttonTheme:  ButtonThemeData(
                    //                 colorScheme: ColorScheme.light(
                    //                   primary: AppColors().mainColor,
                    //                 ),
                    //               ),
                    //             ),
                    //             child: child!);
                    //       },
                    //     );
                    //     if (newTime != null) {
                    //       // setState(() {
                    //       //   AddWorkOrAdsController.to.days[index][3] = newTime;
                    //       // });
                    //     }
                    //   },
                    //   // day: "",
                    //   day: AddWorkOrAdsController.to.days[0][0],
                    //   isChecked: AddWorkOrAdsController.to.days[0][1],
                    //   // isC,
                    //   onChanged: (p0) {
                    //     setState(() {
                    //       AddWorkOrAdsController.to.days[0][1] = !AddWorkOrAdsController.to.days[0][1];
                    //
                    //       print(AddWorkOrAdsController.to.days);
                    //     });
                    //   },
                    // ),

                    controller.itemDetails.first.data!.active_from != null ?  SizedBox(height: 15.h,) : Container(),
                    controller.itemDetails.first.data!.active_from != null ?
                    MainElevatedButton(
                      height: 48.h,
                      width: Get.width,
                      borderRadius: 12.r,

                      // onPressed: () => null,
                      onPressed: () async{

                        // print("we are here");
                        // await   MenuApiController().createEvent(itemId: controller.itemDetails.first.data!.id.toString());
                        if( SharedPrefController().isLogined){
                          print(controller.selectable.value);
                          // if( controller.selectable.value){
                            print("Date::: ${controller.fromDate.value}");
                            // print(controller.toDate.value);
                            print(controller.startBookingDates);
                            print(controller.fromDate.value);
                            if(AllMenusGetxController.to.fromDate.value != ""){
                              if(AllMenusGetxController.to.toDate.value != ""){
                                if(controller.itemDetails.first.type == 5){
                                  if(ImagePickerController.to.ldrive.value != ""){

                                    if(selectedTypeDelivery == list.first){
                                      if(AllOrdersGetxController.to.addressId.value != 0){
                                        makePayment();
                                        // AllOrdersGetxController.to.createBookOrder(context,vendorId: widget.resId.toString(),
                                        //   itemID: widget.foodId.toString(), numberofDays: difference == 0 ? "1" : difference.toString(),
                                        //   assurnace: AllMenusGetxController.to.itemDetails.first.data!.insurance == null ? "0": AllMenusGetxController.to.itemDetails.first.data!.insurance.toString(), clean: AllMenusGetxController.to.itemDetails.first.data!.clean == null ? "0": AllMenusGetxController.to.itemDetails.first.data!.clean.toString(),);
                                      }
                                      else{
                                        Fluttertoast.showToast(msg: "يجب اختيار عنوان");
                                      }
                                    }else{
                                      makePayment();
                                      // AllOrdersGetxController.to.createBookOrder(context,vendorId: widget.resId.toString(),
                                      //   itemID: widget.foodId.toString(), numberofDays: difference == 0 ? "1" : difference.toString(),
                                      //   assurnace: AllMenusGetxController.to.itemDetails.first.data!.insurance == null ? "0": AllMenusGetxController.to.itemDetails.first.data!.insurance.toString(), clean: AllMenusGetxController.to.itemDetails.first.data!.clean == null ? "0": AllMenusGetxController.to.itemDetails.first.data!.clean.toString(),);
                                    }
                                  }else{
                                    Fluttertoast.showToast(msg: "يجب رفع رخصة القيادة");

                                  }
                                }else{
                                  makePayment();
                                  // AllOrdersGetxController.to.createBookOrder(context,vendorId: widget.resId.toString(),
                                  //   itemID: widget.foodId.toString(), numberofDays: difference == 0 ? "1" : difference.toString(),
                                  //   assurnace: AllMenusGetxController.to.itemDetails.first.data!.insurance == null ? "0": AllMenusGetxController.to.itemDetails.first.data!.insurance.toString(), clean: AllMenusGetxController.to.itemDetails.first.data!.clean == null ? "0": AllMenusGetxController.to.itemDetails.first.data!.clean.toString(),);
                                }
                              }else{
                                Fluttertoast.showToast(msg: "يرجى اختيار تاريخ نهاية الحجز");

                              }
                            }else{
                              Fluttertoast.showToast(msg: "يرجى اختيار تاريخ بداية الحجز");

                            }


                            // AllOrdersGetxController.to.createBookOrder(context,vendorId: widget.resId.toString(),
              // itemID: widget.foodId.toString(), numberofDays: difference == 0 ? "1" : difference.toString(),
              // assurnace: AllMenusGetxController.to.itemDetails.first.data!.insurance == null ? "0": AllMenusGetxController.to.itemDetails.first.data!.insurance.toString(), clean: AllMenusGetxController.to.itemDetails.first.data!.clean == null ? "0": AllMenusGetxController.to.itemDetails.first.data!.clean.toString(),);
              // }

                            // print(controller.endBookingDates);
                            // print(controller.toDate.value);
                //             if(
                //             /* controller.startBookingDates.any((element) => element == controller.fromDate) */
                //             controller.startBookingDates.contains(controller.fromDate)
                // ){
                //               Fluttertoast.showToast(msg: "عذراً، هذه الفترة محجوزة", backgroundColor: Colors.black.withOpacity(0.64));
                //             }else{
                //               await  controller.createEvent(itemId: controller.itemDetails.first.data!.id.toString());
                            // }
                         // await   MenuApiController().createEvent(itemId: controller.itemDetails.first.data!.id.toString());
                         //  }else{
                         //      Fluttertoast.showToast(msg: "لا يمكنك اختيار هذه الفترة لانها لا توجد ضمن نطاق الحجز", backgroundColor: Colors.black.withOpacity(0.64));
                         //    }
                          }else{
                          Fluttertoast.showToast(msg: "يجب عليك تسجيل الدخول اولاً", backgroundColor: Colors.black.withOpacity(0.64));

                        }

                      },
                      child: Text(
                        'حجز',
                        style: GoogleFonts.notoKufiArabic(
                          textStyle:  TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ) :   Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 48.w,
                            width: 64.h,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: AppColors().mainColor
                                ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Expanded(
                                      child: InkWell(

                                       onTap: (){
                                         controller.count.value++;
                                       },
                                        child: Container(
                                            decoration: BoxDecoration(
                color: AppColors().mainColor,
                border: Border.all(
                                                    color: AppColors().mainColor
                                                )
                                            ),
                                            child:Icon(Icons.keyboard_arrow_up_outlined, color: Colors.white,)),
                                      ),
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: (){
                                          if(controller.count.value != 1){
                                            controller.count.value--;

                                          }

                                        },
                                        child: Container( decoration: BoxDecoration(
                color: AppColors().mainColor,

                border: Border.all(
                                                color: AppColors().mainColor
                                            )
                                        ),
                                            child:Icon(Icons.keyboard_arrow_down_outlined,color: Colors.white,)),
                                      ),
                                    ),
                                  ],),

                                Padding(
                                  padding: EdgeInsetsDirectional.only(
                                      start: 12.w
                                  ),
                                  child: Text(controller.count.value.toString(),
                                    style: GoogleFonts.notoKufiArabic(
                                      textStyle: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.black,
                                      ),),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                // SfDateRangePicker(
                // onSelectionChanged: (v){},
                // selectionMode: DateRangePickerSelectionMode.range,
                // initialSelectedRange: PickerDateRange(
                // DateTime.now().subtract(const Duration(days: 4)),
                // DateTime.now().add(const Duration(days: 3))),
                // ),


                        SizedBox(width: 8.w,),
                      Expanded(
                          flex: 4,
                          child: MainElevatedButton(
                            height: 48.h,
                            width: Get.width,
                            borderRadius: 12.r,
                            onPressed: ()async {
                              // print(vartiantId);

                              // print(AllCartsGetxController.to.carts.first.data!.length);
                              //
                              // print(AllCartsGetxController.to.carts.first.data!.where((element) => element.id == controller.itemDetails.first.id).first);
                              // if(AllCartsGetxController.to.carts.first.data!.where((element) => element.id == controller.itemDetails.first.id).isNotEmpty){
                              //   print("here");
                              //
                              // }

                              // if(AllCartsGetxController.to.carts.first.data!.where((element) => element.id == controller.itemDetails.first.data!.id).isNotEmpty){
                              //   if(controller.count.value != 1){
                              //     print("from 1");
                              //     AllCartsGetxController.to.updateCartFromApi(quantity: controller.count.value, itemId: controller.itemDetails.first.data!.id.toString());
                              //   }else{
                              //     print("from 2");
                              //
                              //     AllCartsGetxController.to.updateCartFromApi(quantity: 3, itemId: controller.itemDetails.first.data!.id.toString());
                              //
                              //   }
                              //   // int q =  CartController.to.cart.first.cart!.where((e) => e.addproductId == ProductsController.to.productsAdmin.first.data![index].id).first.quantity!;
                              //   // q++;
                              // }else{


                              if( SharedPrefController().isLogined){
                                if(AllCartsGetxController.to.carts.isNotEmpty){
                                  if(AllCartsGetxController.to.carts.first.data!.first.attributes!.restorantId == widget.resId){

                                    bool success = await AllCartsGetxController.to.addToCart(
                                        quantity: controller.count.value.toString(),
                                        resId: widget.resId.toString(),
                                        id: controller.itemDetails.first.data!.id.toString(),
                                        user_id: widget.userId.toString(),
                                        variantID: controller.itemDetails.first.data!.options!.isNotEmpty ? controller.vartiantId.toString() : "",
                                        extras: extras);
                                    if(success){
                                      Fluttertoast.showToast(msg: "تم اضافة العنصر الي السلة", backgroundColor: Colors.black.withOpacity(0.64));
                                    }



                                    // else{
                                    //   Fluttertoast.showToast(msg: "عليك اضافة وجبات بقيمة ${AllCartsGetxController.to.carts.first.data!.first.minimum!}", backgroundColor: Colors.black.withOpacity(0.64));
                                    //
                                    // }

                                  }  else{
                                    AppDialog.removeAllCartDialog(context);
                                    // Fluttertoast.showToast(msg: "لا يمكنك الطلب من مطعم اخر ، يجب عليك اتمام الطلب الموجود بالسلة او افراغها ومن ثم الطلب من اي مطعم اخر", backgroundColor: Colors.black.withOpacity(0.64),toastLength: Toast.LENGTH_LONG);

                                  }
                                }else{
                                  bool success = await AllCartsGetxController.to.addToCart(
                                      quantity: controller.count.value.toString(),
                                      resId: widget.resId.toString(),
                                      id: controller.itemDetails.first.data!.id.toString(),
                                      user_id: widget.userId.toString(),
                                      variantID: controller.itemDetails.first.data!.options!.isNotEmpty ? controller.vartiantId.toString() : "",
                                      extras: extras);
                                  if(success){
                                    Fluttertoast.showToast(msg: "تم اضافة العنصر الي السلة", backgroundColor: Colors.black.withOpacity(0.64));
                                  }
                                }
                              }else{
                                Fluttertoast.showToast(msg: "يجب عليك تسجيل الدخول اولاً", backgroundColor: Colors.black.withOpacity(0.64));

                              }

                              // }
                            },
                            child: Text(
                              'اضف الى السلة',
                              style: GoogleFonts.notoKufiArabic(
                                textStyle:  TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // SizedBox(
                        //   width: 150.w,
                        //   child: ElevatedButton(onPressed: (){}, child: Text("اكسترا جبنة",
                        //     style: GoogleFonts.notoKufiArabic(
                        //       textStyle: TextStyle(
                        //         fontSize: 12.sp,
                        //         color: Colors.black,
                        //       ),),),
                        //   style: ElevatedButton.styleFrom(
                        //     backgroundColor: AppColors().mainColor,
                        //     minimumSize: Size(double.infinity, 48.h)
                        //   ),
                        //   ),
                        // ),

                      ],
                    )

                  ],
                ),
              );
            }
          ),
        );
      }
    );
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

    //     curl https://api.stripe.com/v1/tokens \
    //     -u sk_test_4eC39HqLyjWDarjtT1zdp7dc: \
    // -d "card[number]"=4242424242424242 \
    // -d "card[exp_month]"=8 \
    // -d "card[exp_year]"=2024 \
    // -d "card[cvc]"=314
    //     api.stripe.com/v1/tokens
    //     var response3 = await http.post(
    //       Uri.parse('https://api.stripe.com/v1/tokens'),
    //       headers: {
    //         'Authorization': 'Bearer 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',
    //         'Content-Type': 'application/x-www-form-urlencoded'
    //       },
    //       body: body2,
    //     );
    //     print("BODY:::: ${response3.body.toString()}");
        var response2 = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_methods'),
          headers: {
            'Authorization': 'Bearer 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',
            'Content-Type': 'application/x-www-form-urlencoded'
          },
          body: body2,
        );
        if(response2.body != null ){
          if(jsonDecode(response2.body)['livemode']== true){

            AllOrdersGetxController.to.stripeToken.value = jsonDecode(response2.body)['id'];
            print("From Payment:: ${response2.statusCode}");
            print("From Payment:: ${response2}");
            if(response2.statusCode == 200){
              AllOrdersGetxController.to.createBookOrder(context,vendorId: widget.resId.toString(),
                itemID: widget.foodId.toString(), numberofDays: difference == 0 ? "1" : difference.toString(),
                assurnace: AllMenusGetxController.to.itemDetails.first.data!.insurance == null ? "0": AllMenusGetxController.to.itemDetails.first.data!.insurance.toString(), clean: AllMenusGetxController.to.itemDetails.first.data!.clean == null ? "0": AllMenusGetxController.to.itemDetails.first.data!.clean.toString(),);
            }
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

}
class _DateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue prevText, TextEditingValue currText) {
    int selectionIndex;

    // Get the previous and current input strings
    String pText = prevText.text;
    String cText = currText.text;
    // Abbreviate lengths
    int cLen = cText.length;
    int pLen = pText.length;

    if (cLen == 1) {
      // Can only be 0, 1, 2 or 3
      if (int.parse(cText) > 3) {
        // Remove char
        cText = '';
      }
    } else if (cLen == 2 && pLen == 1) {
      // Days cannot be greater than 31
      int dd = int.parse(cText.substring(0, 2));
      if (dd == 0 || dd > 31) {
        // Remove char
        cText = cText.substring(0, 1);
      } else {
        // Add a / char
        cText += '/';
      }
    } else if (cLen == 4) {
      // Can only be 0 or 1
      if (int.parse(cText.substring(3, 4)) > 1) {
        // Remove char
        cText = cText.substring(0, 3);
      }
    } else if (cLen == 5 && pLen == 4) {
      // Month cannot be greater than 12
      int mm = int.parse(cText.substring(3, 5));
      if (mm == 0 || mm > 12) {
        // Remove char
        cText = cText.substring(0, 4);
      } else {
        // Add a / char
        cText += '/';
      }
    } else if ((cLen == 3 && pLen == 4) || (cLen == 6 && pLen == 7)) {
      // Remove / char
      cText = cText.substring(0, cText.length - 1);
    } else if (cLen == 3 && pLen == 2) {
      if (int.parse(cText.substring(2, 3)) > 1) {
        // Replace char
        cText = cText.substring(0, 2) + '/';
      } else {
        // Insert / char
        cText =
            cText.substring(0, pLen) + '/' + cText.substring(pLen, pLen + 1);
      }
    }
    // else if (cLen == 6 && pLen == 5) {
    //   // Can only be 1 or 2 - if so insert a / char
    //   int y1 = int.parse(cText.substring(5, 6));
    //   if (y1 < 1 || y1 > 2) {
    //     // Replace char
    //     cText = cText.substring(0, 5) + '/';
    //   } else {
    //     // Insert / char
    //     cText = cText.substring(0, 5) + '/' + cText.substring(5, 6);
    //   }
    // } else if (cLen == 7) {
    //   // Can only be 1 or 2
    //   int y1 = int.parse(cText.substring(6, 7));
    //   if (y1 < 1 || y1 > 2) {
    //     // Remove char
    //     cText = cText.substring(0, 6);
    //   }
    // } else if (cLen == 8) {
    //   // Can only be 19 or 20
    //   int y2 = int.parse(cText.substring(6, 8));
    //   if (y2 < 19 || y2 > 20) {
    //     // Remove char
    //     cText = cText.substring(0, 7);
    //   }
    // }

    selectionIndex = cText.length;
    return TextEditingValue(
      text: cText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}