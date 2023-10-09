import 'dart:io';

import 'package:ensure_visible_when_focused/ensure_visible_when_focused.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rakwa/Core/utils/extensions.dart';
import 'package:rakwa/api/api_controllers/subscribtion_api_controller.dart';
import 'package:rakwa/controller/all_subscribtions_getx_controller.dart';
import 'package:rakwa/controller/search_item_controller.dart';
import 'package:rakwa/model/user_ads.dart';
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
import '../../widget/main_elevated_button.dart';
import '../add_listing_screens/Widget/bottom_sheet_state.dart';


class UpdateAdScreen extends StatefulWidget {
  UserAds ads;
   UpdateAdScreen({required this.ads});

  @override
  State<UpdateAdScreen> createState() => _UpdateAdScreenState();
}

class _UpdateAdScreenState extends State<UpdateAdScreen> {

  ListController listController = Get.put(ListController());
  VideoPlayerController?  videoPlayerController;
  XFile? image;
  XFile? video;
  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  TextEditingController stateController = TextEditingController();

  FocusNode websiteNode =FocusNode();
  FocusNode videoNode =FocusNode();
  FocusNode stateNode =FocusNode();
  // ScrollController _workaroundScrCntrToFixFocusIssue= ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.put(AllSubscribtionsGetxController());
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      print("Type::: ${widget.ads.type }");
      AllSubscribtionsGetxController.to.selectedAdType.value = int.parse( widget.ads.type ?? "0");
print(  AllSubscribtionsGetxController.to.selectedAdType.value);


if( AllSubscribtionsGetxController.to.selectedAdType.value == 0){
  AllSubscribtionsGetxController.to.selectedAdTypeStr.value = AllSubscribtionsGetxController.to.adTypes.first;
}else{
  AllSubscribtionsGetxController.to.selectedAdTypeStr.value = AllSubscribtionsGetxController.to.adTypes.last;
}

      AllSubscribtionsGetxController.to.websiteController.text = widget.ads.url ?? "";
      // .text = widget.ads.url ?? "";
      widget.ads.states!.forEach((element) {
        AllSubscribtionsGetxController.to.states.add(element.id ?? -1);
        AllSubscribtionsGetxController.to.statesStr.add(element.stateName ?? "");
      });

      widget.ads.allCategoriessmartads!.forEach((element) {
        AllSubscribtionsGetxController.to.selectedCategoriesId.add(element.id.toString());
      });

      stateController.text =  AllSubscribtionsGetxController.to.statesStr.toString().replaceAll("[", "").replaceAll("]", "");

      if(widget.ads.type == "1"){
        AllSubscribtionsGetxController.to.videoLinkController.text = widget.ads.image ?? "";
      }
      setState(() {

});

print(  AllSubscribtionsGetxController.to.selectedAdTypeStr.value );
    });
    Get.put(ImagePickerController());
  }
  @override
  Widget build(BuildContext context) {
    print(  AllSubscribtionsGetxController.to.selectedAdTypeStr.value );

    return Scaffold(
      appBar: AppBars.appBarDefault(title: "تعديل الاعلان"),
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
              }) ) : Form(
            key: _globalKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                // shrinkWrap: true,
                // physics: ScrollPhysics(),
                // padding: EdgeInsets.all(16),
                children: [
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
                                }
                              });

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
                            image == null ? widget.ads.image!.isNotEmpty && !widget.ads.image!.contains("youtu.be") && !widget.ads.image!.contains("youtube") ? Image.network("https://www.rakwa.com/laravel_project/public/storage/item/${widget.ads.image}", width: 150.w, height: 150.h,): Container():
                            
                            Image.file(File(pic.adImage.value),width: 150.w, height: 150.h,fit: BoxFit.cover,),

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
                                      child: ListView.separated(
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

                    Text("مواضع الاعلان",
                      style: GoogleFonts.notoKufiArabic(
                        textStyle: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.black,
                        ),),),
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

                        if(_globalKey.currentState!.validate()){
                          if(AllSubscribtionsGetxController.to.selectedAdType.value == 0){
                            if(ImagePickerController.to.adImage.value != "" || widget.ads.image!.isNotEmpty){
                              if(controller.selectedCategoriesId.isNotEmpty){
                                SubscriptionApiController().updateSmartAds(context,widget.ads.id.toString());

                              }else{
                                Fluttertoast.showToast(msg: "يجب تحديد مواضع الاعلان", backgroundColor: Colors.black.withOpacity(0.64));

                              }

                            }else{
                              Fluttertoast.showToast(msg: "يرجى رفع صورة الاعلان", backgroundColor: Colors.black.withOpacity(0.64));

                            }
                          }else{
                            if(controller.selectedCategoriesId.isNotEmpty){
                              SubscriptionApiController().updateSmartAds(context,widget.ads.id.toString());

                            }else{
                              Fluttertoast.showToast(msg: "يجب تحديد مواضع الاعلان", backgroundColor: Colors.black.withOpacity(0.64));

                            }
                          }
                          // else{
                          //   if(ImagePickerController.to.adVideo.value != ""){

                            // }else{
                            //   Fluttertoast.showToast(msg: "يرجى رفع فيديو الاعلان", backgroundColor: Colors.black.withOpacity(0.64));
                            //
                            // }
                          // }


                        }
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
              );
        }
      ),
    );
  }
}
