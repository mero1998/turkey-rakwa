import 'dart:convert';
import 'dart:io';

import 'package:ensure_visible_when_focused/ensure_visible_when_focused.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rakwa/Core/utils/extensions.dart';
import 'package:rakwa/api/api_controllers/subscribtion_api_controller.dart';
import 'package:rakwa/controller/all_subscribtions_getx_controller.dart';
import 'package:rakwa/controller/search_item_controller.dart';
import 'package:rakwa/screens/order/payment_screen.dart';
import 'package:rakwa/shared_preferences/shared_preferences.dart';
import 'package:rakwa/widget/appbars/app_bars.dart';
import 'package:shimmer/shimmer.dart';
// import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';

import '../../app_colors/app_colors.dart';
import '../../controller/image_picker_controller.dart';
import '../../controller/list_controller.dart';
import '../../widget/ButtomSheets/base_bottom_sheet.dart';
import '../../widget/ButtomSheets/row_select_item.dart';
import '../../widget/TextFields/text_field_default.dart';
import '../../widget/TextFields/validator.dart';
import '../../widget/app_dialog.dart';
import '../../widget/main_elevated_button.dart';
import '../add_listing_screens/Widget/bottom_sheet_state.dart';
import 'package:http/http.dart' as http;

class AddAdScreen extends StatefulWidget {
  const AddAdScreen({Key? key}) : super(key: key);

  @override
  State<AddAdScreen> createState() => _AddAdScreenState();
}

class _AddAdScreenState extends State<AddAdScreen> {

  ListController listController = Get.put(ListController());
  VideoPlayerController?  videoPlayerController;
  XFile? image;
  XFile? video;
  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  TextEditingController stateController = TextEditingController();

  FocusNode websiteNode =FocusNode();
  FocusNode videoNode =FocusNode();
  FocusNode stateNode =FocusNode();
  Map<String, dynamic>? paymentIntent;

  // ScrollController _workaroundScrCntrToFixFocusIssue= ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  Get.put(AllSubscribtionsGetxController());
    AllSubscribtionsGetxController.to.selectedAdTypeStr.value = AllSubscribtionsGetxController.to.adTypes.first;
    AllSubscribtionsGetxController.to.selectedAdType.value = 0;

    Get.put(ImagePickerController());

  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBars.appBarDefault(title: "انشاء اعلان"),
      body: GetX<AllSubscribtionsGetxController>(
        builder: (controller) {
          return controller.loading.value ? Shimmer.fromColors(
              baseColor: Colors.grey.shade100,
              highlightColor: Colors.grey.shade300,
              child:ListView.builder(
                  itemCount: 2,
                  itemBuilder: (context , index){
                return Container(
                  width: double.infinity,
                  height: 150.h,
                  color: Colors.grey,
                  margin: EdgeInsets.all(20),
                );
              }) ) :controller.sub.isNotEmpty ? Form(
            key: _globalKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                // shrinkWrap: true,
                // physics: ScrollPhysics(),
                // padding: EdgeInsets.all(16),
                  crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row(
                  //   children: [
                  //     Text("العملة",
                  //       style: GoogleFonts.notoKufiArabic(
                  //         textStyle: TextStyle(
                  //           fontSize: 12.sp,
                  //           color: Colors.black,
                  //         ),),),
                  //     SizedBox(width: 20.w,),
                  //     Container(
                  //       width: 120.w,
                  //       decoration: BoxDecoration(
                  //           border: Border.all(
                  //               color: Color(0xFFE4E4E4)
                  //           ),
                  //           borderRadius: BorderRadius.circular(4)
                  //       ),
                  //       padding: EdgeInsets.all(12),
                  //       child: DropdownButtonHideUnderline(
                  //
                  //         child: DropdownButton(
                  //
                  //             value: controller.selectedCurrency.value,
                  //             hint: Text("اختر العملة",
                  //               style: GoogleFonts.notoKufiArabic(
                  //                 textStyle:  TextStyle(
                  //                   fontSize: 12.sp,
                  //                   // fontWeight: FontWeight.bold,
                  //                   color: Color(0xFF3D3C42).withOpacity(0.4),
                  //                 ),
                  //               ),),
                  //             isDense: true,
                  //             isExpanded: true,
                  //             items: controller.currencies.map<DropdownMenuItem<String>>((value){
                  //               return
                  //                 DropdownMenuItem(
                  //                     value: value,
                  //
                  //                     child: Text(value,
                  //                         style: GoogleFonts.notoKufiArabic(
                  //                           textStyle:  TextStyle(
                  //                             fontSize: 12.sp,
                  //                             fontWeight: FontWeight.bold,
                  //                             color: Color(0xFF3D3C42),
                  //                           ),)));
                  //             }).toList(),
                  //             onChanged: (value) async{
                  //               // setState(() {
                  //
                  //                 controller.selectedCurrency.value = value!;
                  //                 controller.isLoading.value = true;
                  //
                  //               await controller.getSubscription2();
                  //
                  //               print( controller.isLoading.value);
                  //                 print(value);
                  //                 setState(() {
                  //
                  //                 });
                  //                   if(controller.sub.isNotEmpty){
                  //
                  //                     controller.isLoading.value = false;
                  //
                  //                     if(value == "EUR"){
                  //                       controller.loading.value = true;
                  //
                  //                       for(int i = 0; i < controller.sub.first.subscriptions!.length; i++){
                  //                         controller.sub.first.subscriptions![i].priceViews = await calculateAmount(controller.sub.first.subscriptions![i].priceViews.toString());
                  //                         controller.sub.first.subscriptions![i].priceClicks = await calculateAmount(controller.sub.first.subscriptions![i].priceClicks.toString());
                  //                         controller.sub.first.subscriptions![i].total = await calculateAmount(controller.sub.first.subscriptions![i].total.toString());
                  //                       //
                  //                       }
                  //
                  //                       setState(() {
                  //
                  //                       });
                  //                       controller.total.value = controller.sub.first.eUR!.first.round().toString();
                  //                       controller.loading.value = false;
                  //
                  //
                  //                     }
                  //                     else if(value == "TRY"){
                  //
                  //                       controller.loading.value = true;
                  //                       for(int i = 0; i < controller.sub.first.subscriptions!.length; i++){
                  //                         controller.sub.first.subscriptions![i].priceViews = await calculateAmount(controller.sub.first.subscriptions![i].priceViews.toString());
                  //                         controller.sub.first.subscriptions![i].priceClicks = await calculateAmount(controller.sub.first.subscriptions![i].priceClicks.toString());
                  //                         controller.sub.first.subscriptions![i].total = await calculateAmount(controller.sub.first.subscriptions![i].total.toString());
                  //                       }
                  //
                  //                       controller.total.value = controller.sub.first.tRY!.first.round().toString();
                  //                       controller.loading.value = false;
                  //
                  //                       setState(() {});
                  //                     }
                  //                   }
                  //
                  //
                  //
                  //
                  //                 // controller.sub.first
                  //                 // selectedTime = value;
                  //                 // AllOrdersGetxController.to.timeId.value = selectedTime!.id ?? "";
                  //               })
                  //             // }),
                  //       ),)
                  //   ],
                  // ),
                    SizedBox(height: 10.h,),

                    ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: controller.sub.first.subscriptions!.length,
                        itemBuilder: (context, index){
                          return InkWell(
                            onTap: (){

                              setState(() {
                                controller.subscriptionId.value = controller.sub.first.subscriptions![index].id ?? 0;
                                controller.subscriptionType.value = controller.sub.first.subscriptions![index].type ?? 0;
                                controller.total.value = double.parse(controller.sub.first.subscriptions![index].total ?? "").round().toString();

                              });
                              print("Total:: ${controller.total.value}");


                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 16.h),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: controller.subscriptionId.value == controller.sub.first.subscriptions![index].id ?  AppColors().mainColor : Color(0xFFF4F4F4)
                                    // color: Color(0xFFF4F4F4)
                                  )
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RadioListTile(

                                        activeColor: AppColors().mainColor,
                                        value: controller.sub.first.subscriptions![index].id,
                                        groupValue: controller.subscriptionId.value,
                                        title: Text(controller.sub.first.subscriptions![index].name ?? "",
                                          style: GoogleFonts.notoKufiArabic(
                                            textStyle: TextStyle(
                                              fontSize: 12.sp,
                                              color: Colors.black,
                                            ),),),
                                        onChanged: (value){
                                          setState(() {
                                            controller.subscriptionId.value = controller.sub.first.subscriptions![index].id?? 0;
                                            controller.total.value = double.parse(controller.sub.first.subscriptions![index].total ?? "").round().toString();

                                            // if(selectedTypeDelivery == list.first){
                                            //   AllOrdersGetxController.to.deliveryType.value = "delivery";
                                            //   if(AllOrdersGetxController.to.addressId.value != 0){
                                            //     AllOrdersGetxController.to.costDelivery.value =   AllOrdersGetxController.to.fees.where((p0) => p0.id == AllOrdersGetxController.to.addressId.value).first.costTotal.toString();
                                            //
                                            //   }
                                            //
                                            // }else{
                                            //   AllOrdersGetxController.to.deliveryType.value = "pickup";
                                            //   AllOrdersGetxController.to.costDelivery.value = "";
                                            // }
                                            // print( AllOrdersGetxController.to.deliveryType);
                                          });
                                          print("Total:: ${controller.total.value}");

                                        }),
                                    Padding(
                                      padding:  EdgeInsets.symmetric(horizontal: 16.w),
                                      child:  Text(controller.sub.first.subscriptions![index].description ?? "",
                                        style: GoogleFonts.notoKufiArabic(
                                          textStyle: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.black,

                                          ),),),
                                    ),
                                    Padding(
                                      padding:  EdgeInsets.symmetric(horizontal: 25.w),
                                      child: Column(
                                        children: [
                                          Align(
                                            alignment: AlignmentDirectional.topStart,
                                            child: Text("في هذا الاعلان سوف تحصل على: ",
                                              style: GoogleFonts.notoKufiArabic(
                                                textStyle: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: Colors.black,
                                                ),),),
                                          ),
                                          controller.sub.first.subscriptions![index].clicks != null ?    Row(
                                            children: [
                                              Text(" ${controller.sub.first.subscriptions![index].clicks.toString()} نقرة" ?? "",
                                                style: GoogleFonts.notoKufiArabic(
                                                  textStyle: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: Colors.black,
                                                  ),),),

                                              Text(" بتكلفة ${double.parse(controller.sub.first.subscriptions![index].priceClicks.toString()).round() } ${controller.selectedCurrency.value} " ?? "",
                                                style: GoogleFonts.notoKufiArabic(
                                                  textStyle: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: Colors.black,
                                                  ),),),
                                            ],
                                          ) : Container(),
                                          controller.sub.first.subscriptions![index].views != null ?    Row(
                                            children: [
                                              Text(" ${controller.sub.first.subscriptions![index].views.toString()} مشاهدة"?? "",
                                                style: GoogleFonts.notoKufiArabic(
                                                  textStyle: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: Colors.black,
                                                  ),),),

                                              Text(" بتكلفة ${double.parse(controller.sub.first.subscriptions![index].priceViews.toString()).round()} ${controller.selectedCurrency.value} " ?? "",
                                                style: GoogleFonts.notoKufiArabic(
                                                  textStyle: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: Colors.black,
                                                  ),),),
                                            ],
                                          ) : Container(),

                                          Align(
                                            alignment: AlignmentDirectional.bottomEnd,
                                            child: Text(" المجموع ${double.parse(controller.sub.first.subscriptions![index].total.toString()).round()} ${controller.selectedCurrency.value} " ?? "",
                                              style: GoogleFonts.notoKufiArabic(
                                                textStyle: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: Colors.black,
                                                ),),),
                                          ),
                                        ],
                                      ),
                                    )


                                  ],
                                ),
                              ),
                            ),
                          );

                        }),




                    Text("صورة/فيديو الاعلان",
                      style: GoogleFonts.notoKufiArabic(
                        textStyle: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.black,
                        ),),),
                    SizedBox(height: 15.h,),
                    GridView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        // scrollDirection: Axis.horizontal,
                        itemCount: controller.adTypes.length,
                        itemBuilder: (context, index){
                          return InkWell(
                            onTap: (){

                              setState(() {
                                controller.selectedAdTypeStr.value = controller.adTypes[index];

                                if(controller.selectedAdTypeStr.value == controller.adTypes.first){
                                  controller.selectedAdType.value = 0;
                                }else{
                                  controller.selectedAdType.value = 1;
                                }                        });

                            },
                            child: Container(
                              height: 150.h,
                              margin: EdgeInsets.only(bottom: 16.h),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: controller.selectedAdTypeStr.value == controller.adTypes[index] ?  AppColors().mainColor : Color(0xFFF4F4F4)
                                    // color: Color(0xFFF4F4F4)
                                  )
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: RadioListTile(

                                        activeColor: AppColors().mainColor,
                                        value: controller.adTypes[index],
                                        groupValue: controller.selectedAdTypeStr.value,
                                        title: Text(controller.adTypes[index],
                                          style: GoogleFonts.notoKufiArabic(
                                            textStyle: TextStyle(
                                              fontSize: 12.sp,
                                              color: Colors.black,
                                            ),),),
                                        onChanged: (value){
                                          setState(() {
                                            controller.selectedAdTypeStr.value = controller.adTypes[index];

                                            if(controller.selectedAdTypeStr.value == controller.adTypes.first){
                                              controller.selectedAdType.value = 0;
                                            }else{
                                              controller.selectedAdType.value = 1;
                                            }
                                            // controller.subscriptionId.value = controller.sub[index].type ?? 0;
                                            // if(selectedTypeDelivery == list.first){
                                            //   AllOrdersGetxController.to.deliveryType.value = "delivery";
                                            //   if(AllOrdersGetxController.to.addressId.value != 0){
                                            //     AllOrdersGetxController.to.costDelivery.value =   AllOrdersGetxController.to.fees.where((p0) => p0.id == AllOrdersGetxController.to.addressId.value).first.costTotal.toString();
                                            //
                                            //   }
                                            //
                                            // }else{
                                            //   AllOrdersGetxController.to.deliveryType.value = "pickup";
                                            //   AllOrdersGetxController.to.costDelivery.value = "";
                                            // }
                                            // print( AllOrdersGetxController.to.deliveryType);
                                          });
                                        }),
                                  ),
                                  SvgPicture.asset(
                                    'images/${controller.images[index]}.svg',
                                    // color: color == null ? AppColors().mainColor : color,
                                    width: 80.w,
                                    height: 80.h,
                                    // fit: fit,
                                    // matchTextDirection: true,
                                  )
                                ],
                              ),
                            ),
                          );

                        }, gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),),
          controller.selectedAdType.value == 1 ?
          TextFieldDefault(
              node: videoNode,
                upperTitle: "رابط الفيديو",
                hint: 'مثال: www.website.com',
                prefixIconPng: "Link",
                controller: controller.videoLinkController,
                keyboardType: TextInputType.url,
                validation: (v){
                  if(v!.isEmpty){
                    videoNode.requestFocus();
                    return "يرجى ادخال رابط صالح";
                  }else{
                    return null;
                  }
                },
                onComplete: () {
                  videoNode.unfocus();
                },
          )
//           GetX<ImagePickerController>(
//                     builder: (pic) {
//                       print(pic.ldrive);
//                       return InkWell(
//                         onTap: ()async{
//                           ImagePicker picker = ImagePicker();
// // Pick an image.
//                           video = await picker.pickVideo(source: ImageSource.gallery,);
//                           if(video != null){
//                             pic.adVideo.value = video!.path;
//                             videoPlayerController = VideoPlayerController.file(File(video!.path))..initialize().then((_) {
//                               setState(() {
//
//                               });
//
//                               videoPlayerController!.play();
//                             });
//
//
//                             // pic.adVideo.value = video!.path;
//                           }
//                         },
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Row(
//                               children: [
//                                 Icon(Icons.upload_rounded),
//                                 Text("ارفع الفيديو من هنا", style: GoogleFonts.notoKufiArabic(
//                                   textStyle: const TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),),
//                               ],
//                             ),
//                             videoPlayerController != null  ?  videoPlayerController!.value.isInitialized ? SizedBox(
//                             height: 120.h,
//                               child: AspectRatio(
//                                   aspectRatio:  videoPlayerController!.value.aspectRatio,
//                               child: VideoPlayer(videoPlayerController!),
//                               ),
//                             )
//                                 // VideoPlayerController.file(File(pic.adVideo.value))..initialize())
//                                 : Container() :   Container(),
//
//                           ],
//                         ),
//                       );
//                     }
//                 )

                  :  GetX<ImagePickerController>(
                    builder: (pic) {
                      print(pic.ldrive);
                      return InkWell(
                        onTap: ()async{
                          ImagePicker picker = ImagePicker();
// Pick an image.
                          image = await picker.pickImage(source: ImageSource.gallery,);
                          if(image != null){
                            setState(() {
                              pic.adImage.value = image!.path;

                            });
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.upload_rounded),
                                Text("ارفع الصورة من هنا", style: GoogleFonts.notoKufiArabic(
                                  textStyle: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),),
                              ],
                            ),
                            image == null ? Container() :    Image.file(File(pic.adImage.value),width: 70.w, height: 70.h,fit: BoxFit.cover,),

                          ],
                        ),
                      );
                    }
          ),
                    SizedBox(height: 10.h,),

                  TextFieldDefault(
                    upperTitle: "رابط موقعك الإلكتروني",
                    hint: 'مثال: www.website.com',
                    prefixIconPng: "Link",
                    node: websiteNode,

                    controller: controller.websiteController,
                    keyboardType: TextInputType.url,
                    validation: (v){
                      if(v!.isEmpty){
                        // setState(() {

                          // FocusManager.instance.primaryFocus!.unfocus();
                          // FocusScope.of(context).requestFocus(websiteNode);
                        // });                      // FocusManager.instance.primaryFocus!.unfocus();
                        // FocusScope.of(context).requestFocus(websiteNode);
                        websiteNode.requestFocus();
                        return "يرجى ادخال رابط صالح";
                      }else{
                        return null;
                      }
                    },
                    onComplete: () {
                      websiteNode.unfocus();
                    },
                  ),
                    // TextFieldDefault(
                    //   enable: true,
                    //   upperTitle: "رابط الاعلان",
                    //   hint: 'مثال: www.facebook.com',
                    //   prefixIconSvg: "Link",
                    //   // controller: stateController,
                    //   validation: locationValidator,
                    // ),
                    Text("تحديد الجمهور ",
                      style: GoogleFonts.notoKufiArabic(
                        textStyle: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.black,
                        ),),),
                    SizedBox(height: 10.h,),
                    GetBuilder<ListController>(
                      builder: (c) => GestureDetector(
                        onTap: () {
                          Get.bottomSheet(
                              GetX<AllSubscribtionsGetxController>(
                                builder: (co) {
                                  print(co.states.length);
                                  return BaseBottomSheet(
                                    height: 400.h,
                                    bottomSheetTitle:"الولايات",
                                    widget: Expanded(
                                      child: Column(
                                        children: [
                                          RowSelectItem(
                                            onTap: () {
                                              if(co.states.isNotEmpty){
                                                co.states.clear();
                                                co.statesStr.clear();
                                                co.selectedAllStates.value = false;

                                              }else{
                                                for(int i = 0; i < c.states.length; i++){
                                                  co.states.add(c.states[i].id);
                                                  co.statesStr.add(c.states[i].stateName);
                                                }

                                                co.selectedAllStates.value = true;
                                              }
                                              // if(!co.states.contains(c.states[index].id)){
                                              //   co.states.add(c.states[index].id );
                                              // }else{
                                              //   co.states.remove(c.states[index].id);
                                              // }
                                              //
                                              // if(!co.statesStr.contains(c.states[index].stateName)){
                                              //   co.statesStr.add(c.states[index].stateName );
                                              // }else{
                                              //   print("from remove str");
                                              //   co.statesStr.remove(c.states[index].stateName);
                                              //
                                              // }
                                              stateController.text = co.statesStr.toString().replaceAll("[", "").replaceAll("]", "");
                                              // onSelect(state[index]);
                                              // Get.back();
                                              print(co.states);
                                              print(co.statesStr);
                                            },
                                            title:"Select all",
                                            active: co.selectedAllStates.value,
                                          ),
                                          Expanded(
                                            child: ListView.separated(
                                              shrinkWrap: true,
                                                physics: ScrollPhysics(),
                                                padding: EdgeInsets.zero,
                                                itemBuilder: (context, index) => RowSelectItem(
                                                  onTap: () {
                                                    if(!co.states.contains(c.states[index].id)){
                                                      co.states.add(c.states[index].id );
                                                    }else{
                                                      co.states.remove(c.states[index].id);
                                                    }

                                                    if(!co.statesStr.contains(c.states[index].stateName)){
                                                      co.statesStr.add(c.states[index].stateName );
                                                    }else{
                                                      print("from remove str");
                                                      co.statesStr.remove(c.states[index].stateName);

                                                    }
                                                    stateController.text = co.statesStr.toString().replaceAll("[", "").replaceAll("]", "");
                                                    // onSelect(state[index]);
                                                    // Get.back();
                                                    print(co.states);
                                                    print(co.statesStr);
                                                  },
                                                  title:c.states[index].stateName ?? "",
                                                  active: co.states.contains(c.states[index].id),
                                                ),
                                                separatorBuilder: (context, index) => 16.ESW(),
                                                itemCount: c.states.length),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              )
                          );
                        },
                        child: TextFieldDefault(
                          enable: false,
                          node: stateNode,
                          upperTitle: "",
                          hint: 'اختار ولاية',
                          prefixIconSvg: "state",
                          suffixIconData: Icons.arrow_drop_down_sharp,
                          controller: stateController,
                          validation: (v){
                            if (v!.isNotEmpty) {
                              return null;
                            } else {
                              // FocusNode.of(context).requestfocus(stateNode);
                              FocusScope.of(context).requestFocus(stateNode);

                              // stateNode.requestFocus();
                              return 'يجب ادخال الموقع';
                            }
                          },
                        ),
                      ),
                    ),

                    Visibility(
                      visible: controller.subscriptionType.value ==0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text("مواضع الاعلان",
                            style: GoogleFonts.notoKufiArabic(
                              textStyle: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.black,
                              ),),),
                          SizedBox(height: 10.h,),

                          Row(
                            children: [
                              Checkbox(
                                  activeColor: AppColors().mainColor,
                                  value: controller.selectedAllCategories.value,
                                  onChanged: (value){

                                    if(controller.selectedCategoriesId.isNotEmpty){
                                      controller.selectedCategoriesId.clear();
                                      controller.selectedAllCategories.value = false;
                                    }else{
                                      for(int i = 0; i < controller.category.length; i++){
                                        controller.selectedCategoriesId.add(controller.category[i].id.toString());

                                      }

                                      controller.selectedAllCategories.value = true;

                                    }
                                    // if(!controller.selectedCategoriesId.contains(controller.category[index].id.toString())){
                                    //   controller.selectedCategoriesId.add(controller.category[index].id.toString());
                                    // }else{
                                    //   controller.selectedCategoriesId.remove(controller.category[index].id.toString());
                                    //
                                    // }


                                    print(   controller.selectedCategoriesId);
                                    setState(() {

                                    });
                                  }),
                              Text("تحديد الكل",
                                style: GoogleFonts.notoKufiArabic(
                                  textStyle: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.black,
                                  ),),),
                            ],
                          ),
                          SizedBox(height: 10.h,),
                          GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 2,
                              mainAxisSpacing: 2,
                              // mainAxisExtent: 23,
                              childAspectRatio:6
                          ),
                              shrinkWrap: true,
                              itemCount: controller.category.length,
                              physics: ScrollPhysics(),
                              itemBuilder: (context, index){
                                return Row(
                                  children: [
                                    Checkbox(
                                        activeColor: AppColors().mainColor,
                                        value: controller.selectedCategoriesId.contains(controller.category[index].id.toString()), onChanged: (value){

                                      if(!controller.selectedCategoriesId.contains(controller.category[index].id.toString())){
                                        controller.selectedCategoriesId.add(controller.category[index].id.toString());
                                      }else{
                                        controller.selectedCategoriesId.remove(controller.category[index].id.toString());

                                      }


                                      print(   controller.selectedCategoriesId);
                                      setState(() {

                                      });
                                    }),
                                    Expanded(
                                      flex: 4,
                                      child: Text(controller.category[index].categoryName ?? "",
                                        style: GoogleFonts.notoKufiArabic(
                                          textStyle: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.black,
                                          ),),),
                                    ),
                                  ],
                                );
                              }),
                        ],
                      ),
                    ),

                    SizedBox(height: 10.h,),
                    MainElevatedButton(
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


                        // if( SharedPrefController().isLogined){
                        //   if(AllCartsGetxController.to.carts.isNotEmpty){
                        //     if(AllCartsGetxController.to.carts.first.data!.first.attributes!.restorantId == widget.resId){
                        //
                        //       bool success = await AllCartsGetxController.to.addToCart(
                        //           quantity: controller.count.value.toString(),
                        //           resId: widget.resId.toString(),
                        //           id: controller.itemDetails.first.data!.id.toString(),
                        //           user_id: widget.userId.toString(),
                        //           variantID: controller.itemDetails.first.data!.options!.isNotEmpty ? controller.vartiantId.toString() : "",
                        //           extras: extras);
                        //       if(success){
                        //         Fluttertoast.showToast(msg: "تم اضافة العنصر الي السلة", backgroundColor: Colors.black.withOpacity(0.64));
                        //       }
                        //
                        //
                        //
                        //       // else{
                        //       //   Fluttertoast.showToast(msg: "عليك اضافة وجبات بقيمة ${AllCartsGetxController.to.carts.first.data!.first.minimum!}", backgroundColor: Colors.black.withOpacity(0.64));
                        //       //
                        //       // }
                        //
                        //     }  else{
                        //       AppDialog.removeAllCartDialog(context);
                        //       // Fluttertoast.showToast(msg: "لا يمكنك الطلب من مطعم اخر ، يجب عليك اتمام الطلب الموجود بالسلة او افراغها ومن ثم الطلب من اي مطعم اخر", backgroundColor: Colors.black.withOpacity(0.64),toastLength: Toast.LENGTH_LONG);
                        //
                        //     }
                        //   }else{
                        //     bool success = await AllCartsGetxController.to.addToCart(
                        //         quantity: controller.count.value.toString(),
                        //         resId: widget.resId.toString(),
                        //         id: controller.itemDetails.first.data!.id.toString(),
                        //         user_id: widget.userId.toString(),
                        //         variantID: controller.itemDetails.first.data!.options!.isNotEmpty ? controller.vartiantId.toString() : "",
                        //         extras: extras);
                        //     if(success){
                        //       Fluttertoast.showToast(msg: "تم اضافة العنصر الي السلة", backgroundColor: Colors.black.withOpacity(0.64));
                        //     }
                        //   }
                        // }else{
                        //   Fluttertoast.showToast(msg: "يجب عليك تسجيل الدخول اولاً", backgroundColor: Colors.black.withOpacity(0.64));
                        //
                        // }

                        // }
                        // //=============================
                        if(_globalKey.currentState!.validate()){
                          if(AllSubscribtionsGetxController.to.selectedAdType.value == 0){
                            if(ImagePickerController.to.adImage.value != ""){
                              if(controller.subscriptionType.value == 0){
                                if(controller.selectedCategoriesId.isNotEmpty){
                                  makePayment();

                                }else{
                                  Fluttertoast.showToast(msg: "يجب تحديد مواضع الاعلان", backgroundColor: Colors.black.withOpacity(0.64));

                                }
                              }else{
                                makePayment();
                              }

                            }else{
                              Fluttertoast.showToast(msg: "يرجى رفع صورة الاعلان", backgroundColor: Colors.black.withOpacity(0.64));
                            }


                          }
                          else{
                          //   if(ImagePickerController.to.adVideo.value != ""){
                            makePayment();


                            // }else{
                            //   Fluttertoast.showToast(msg: "يرجى رفع فيديو الاعلان", backgroundColor: Colors.black.withOpacity(0.64));
                            //
                            }
                          // }


                        }
                      //  ===============================

                        // makePayment();
                      },
                      child: Text(
                        'التالي',
                        style: GoogleFonts.notoKufiArabic(
                          textStyle:  TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                ],
          ),
              ),
            ),
              ) : Center(
            child: Text("لا يوجد خطط للاشتراك",  style: GoogleFonts.notoKufiArabic(
              textStyle: TextStyle(
                fontSize: 12.sp,
                color: Colors.black,
              ),),),
          );
        }
      ),
    );
  }



  Future<void> makePayment() async {
    try {
      // paymentIntent = null;
      //STEP 1: Create Payment Intent
      paymentIntent = await createPaymentIntent(AllSubscribtionsGetxController.to.total.value, AllSubscribtionsGetxController.to.selectedCurrency.value);

      //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(

          paymentSheetParameters: SetupPaymentSheetParameters(

              primaryButtonLabel: "${AllSubscribtionsGetxController.to.total.value} ${AllSubscribtionsGetxController.to.selectedCurrency}",
              paymentIntentClientSecret: paymentIntent![
              'client_secret'], //Gotten from payment intent
              style: ThemeMode.light,
              merchantDisplayName:  SharedPrefController().name))
          .then((value) {});

      //STEP 3: Display Payment sheet
      displayPaymentSheet();
    } catch (err) {
      throw Exception(err);
    }
  }


  createPaymentIntent(String amount, String currency) async {
    print("Amount ${amount}");
    try {
      //Request body
      Map<String, dynamic> body = {
        'amount':   (int.parse(amount) * 100).floor().toString(),
        'currency': currency,
      };

      //Make post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer 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',
          // 'Authorization': 'Bearer sk_test_51MyGdi2jXjU2QVGMv1Ud4oBwwg5VzwZFJBwZlNhkG4ayZaeLsZOrPyA7wFnJrddIHdXSphfi1q5Ou340FNUGHD6l00rh7kMTX8',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      print("JSON:::: ${jsonDecode(response.body)}");
      if(response.statusCode == 200 && jsonDecode(response.body)['id'] != null){
        // jsonDecode(response.body)['id'];
        AllSubscribtionsGetxController.to.stripeId.value = jsonDecode(response.body)['id'].toString();

        print( "Stripe:: ${ AllSubscribtionsGetxController.to.stripeId.value}");
        return jsonDecode(response.body);

      }
    } catch (err) {
      throw Exception(err.toString());
    }
  }
  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        SubscriptionApiController().createSmartAds(context,);

        //Clear paymentIntent variable after successful payment
        paymentIntent = null;

      })
          .onError((error, stackTrace) {

        throw Exception(error);
      });
    }
    on StripeException catch (e) {

      print('Error is:---> $e');
    }
    catch (e) {

      print('$e');
    }
  }

 // Future<String> calculateAmountEUR(String amount) async {
 //    Uri uri = Uri.parse("https://api.exchangerate.host/latest?base=USD&amount=$amount&symbols=${AllSubscribtionsGetxController.to.selectedCurrency.value}");
 //   var response = await http.get(uri);
 //    if(response.statusCode == 200){
 //      // print(jsonDecode(response.body)['rates']['EUR']);
 //    return jsonDecode(response.body)['rates']['EUR'].toString();
 //    }
 //
 //    return "";
 //    // final calculatedAmout = (int.parse(amount)) * 100;
 //    // return calculatedAmout.toString();
 //  }

  calculateAmount(String amount) async {
    // Uri uri = Uri.parse("https://api.exchangerate.host/latest?base=USD&amount=$amount&symbols=${AllSubscribtionsGetxController.to.selectedCurrency.value}");
    Uri uri = Uri.parse("http://api.exchangerate.host/convert?from=USD&amount=$amount&to=${AllSubscribtionsGetxController.to.selectedCurrency.value}&access_key=c8d0578470f7b39ce569b8adf7b5bf15");
    var response = await http.get(uri);
    if(response.statusCode == 200){
     return jsonDecode(response.body)['result'].toString();
    }
    // final calculatedAmout = (int.parse(amount)) * 100;
    // return calculatedAmout.toString();
  }


  // getAmount(){
  //   if(AllSubscribtionsGetxController.to.selectedCurrency.value == "EUR"){
  //     // AllSubscribtionsGetxController.to.sub.first.subscriptions.f
  //   }else if(AllSubscribtionsGetxController.to.selectedCurrency.value == "TRY"){
  //
  //   }
  // }
}

