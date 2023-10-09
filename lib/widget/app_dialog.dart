

import 'dart:convert';
import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rakwa/api/api_controllers/menu_api_controller.dart';
import 'package:rakwa/api/api_controllers/order_api_controller.dart';
import 'package:rakwa/app_colors/app_colors.dart';
import 'package:rakwa/controller/all_cart_getx_controller.dart';
import 'package:rakwa/controller/all_menu_getx_controller.dart';
import 'package:rakwa/controller/all_subscribtions_getx_controller.dart';
import 'package:rakwa/controller/app_interface_getx_controller.dart';
import 'package:rakwa/controller/email_verified_getx_controller.dart';
import 'package:rakwa/controller/image_picker_controller.dart';
import 'package:rakwa/model/add_category.dart';
import 'package:rakwa/model/add_item.dart';
import 'package:rakwa/model/categories.dart';
import 'package:rakwa/screens/add_listing_screens/Controllers/add_work_controller.dart';
import 'package:rakwa/screens/personal_screens/Controllers/change_account_info_controller.dart';
import 'package:rakwa/widget/TextFields/text_field_default.dart';
import 'package:rakwa/widget/main_elevated_button.dart';
import 'package:rakwa/widget/my_text_field.dart';
import 'package:rakwa/widget/video_play.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../api/api_controllers/subscribtion_api_controller.dart';
import '../controller/error_message_controller_getx.dart';
import '../screens/personal_screens/acount_information_screen.dart';
import '../shared_preferences/shared_preferences.dart';
import 'ButtomSheets/base_bottom_sheet.dart';
import 'TextFields/validator.dart';
import 'package:http/http.dart' as http;
class AppDialog {
  Map<String, dynamic>? paymentIntent;

  static confirmPhone(BuildContext context, ) {

    TextEditingController phoneController = TextEditingController();
    FocusNode node = FocusNode();
    String code = '+90';
    print("code::::: ${code}");
    Dialog foodEnlargeDialog = Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      //this right here
      child: Container(
        height: 190.0.h,
        width: 100.0.w,
        padding: EdgeInsets.all(8),
        // color:CustomColors.primaryColor:CustomColors.unselectedColor,

        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Align(alignment: AlignmentDirectional.topEnd,child: IconButton(onPressed: ()=> Get.back(), icon: Icon(Icons.close, color: Colors.black,)))),
              Expanded(
                flex: 3,
                child: Text(
                  "لضمان حصولك على جميع المميزات بالتطبيق ، يرجى إدخال رقم هاتفك للتأكيد",
                  style: GoogleFonts.notoKufiArabic(
                    textStyle:  TextStyle(
                      color: Colors.black,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5.h,),
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        width: Get.width / 1.45,
                        child: TextFieldDefault(

                          // upperTitle: "رقم الهاتف",
                          hint: '0587654634',
                          prefixIconSvg: "TFPhone",
                          // prefixIconData: Icons.phone_outlined,
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          validation: phoneValidator,
                          onComplete: () {
                            node.nextFocus();
                          },
                        ),
                      ),
                    ),
                    CountryCodePicker(
                      onChanged: (v){
                        print(v);
                        code = v.toString();
                        // _.codeCountry.value = v.toString();
                      },

                      // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                      initialSelection: "TR",
                      // favorite: ['+39','FR'],
                      // optional. Shows only country name and flag
                      showCountryOnly: false,
                      // optional. Shows only country name and flag when popup is closed.
                      showOnlyCountryWhenClosed: false,
                      // optional. aligns the flag and the Text left
                      alignLeft: false,
                    ),

                  ],
                ),
              ),
              SizedBox(height: 15.h,),
              Expanded(
                child: InkWell(
                  onTap: ()async{

             bool success   = await ChangeAccountInfoController().updatePhoneNumber(phone: "${code}${phoneController.text}");
             if(success){
                 OrderApiController().verifyPhone(context,);
             }
                    print("${code}${phoneController.text}");
                    // Navigator.pop(context);
                    // AuthConsumer().sendOtpCodeCivil(context, civilId, false, "forget");
                  },
                  child: Text(
                    "تأكيد الأن",
                    style: GoogleFonts.notoKufiArabic(
                      textStyle:  TextStyle(
                        color: Colors.black,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),),
              ),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     SizedBox(width: 10.w,),
              //     InkWell(
              //       onTap: (){
              //         Navigator.pop(context);
              //         Get.to(AccountInformationScreen());
              //         // AuthConsumer().sendOtpCodeCivil(context, civilId, false, "forget");
              //       },
              //       child: Text(
              //         "تغيير الرقم",
              //         style: GoogleFonts.notoKufiArabic(
              //           textStyle:  TextStyle(
              //             color: Colors.black,
              //             fontSize: 12.sp,
              //             fontWeight: FontWeight.w600,
              //           ),
              //         ),
              //       ),),
              //
              //   ],
              // )

            ],
          ),
        ),
      ),
    );
    showDialog(
        context: context,
        barrierColor: Colors.white.withOpacity(0.61),
        builder: (BuildContext context) => foodEnlargeDialog);
  }
  static popupAds(BuildContext context,{required String link, required String type, required String url, required String id }) {
    // VideoPlayerController? videoPlayerController;
    YoutubePlayerController? _controller;
    String? videoId;
    // print("${link}");
    // videoPlayerController = VideoPlayerController.networkUrl(
    //     Uri.parse("https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8"))..initialize().then((_) {


    if(type == "1"){
      videoId = YoutubePlayer.convertUrlToId(link);
      // print("ID::: ${videoId}");
      if(videoId != null){
        _controller =  YoutubePlayerController(
            initialVideoId: videoId!,
            flags: const YoutubePlayerFlags(autoPlay: true, loop: false)

        );
      }
    }

      // videoPlayerController!.play();
    // });
    Dialog foodEnlargeDialog = Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      //this right here
      child: Container(
        height: 190.0.h,
        width: 100.0.w,
        padding: EdgeInsets.all(8),
        // color:CustomColors.primaryColor:CustomColors.unselectedColor,

        // child: link.isNotEmpty && type == "0" ?Image.network("https://www.rakwa.com/laravel_project/public/storage/item/${link}") :
      // child:  videoPlayerController != null  ?
      //   videoPlayerController!.value.isInitialized ? SizedBox(
      //     height: 120.h,
      //     child: AspectRatio(
      //       aspectRatio:  videoPlayerController!.value.aspectRatio,
      //       child: VideoPlayer(videoPlayerController!),
      //     ),
      //   )
      //       : Container()
      //         : Container()
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap: ()async{
                      print("Click");
                      if (await canLaunchUrl(Uri.parse("${url}"))) {
                        try {

                          launchUrl(Uri.parse("${url}"), mode: LaunchMode
                              .externalApplication).then((value) =>   SubscriptionApiController().clickAd(adId: id));

                        } catch (e) {
                          print(e);
                        }
                        //
                      } else {
                        print("Not able");
                      }
                    },
                    child: Text("زيارة موقع الويب")),
                InkWell(
                    onTap: () => Get.back(),
                  child: Container(
                      margin: EdgeInsets.only(bottom: 3.h),
                      decoration: BoxDecoration(
                          border: Border.all(),
                          shape: BoxShape.circle
                      ),
                      child: Icon(Icons.close)),
                ),


              ],
            ),
            type == "0" ?
            Expanded(child: InkWell(
                onTap: ()async{
                  // print(controller.ads.first.url);
                  // if(controller.ads.first.url != null){
                  // String url2 = url ?? "";
                  // if (await canLaunchUrl(Uri.parse(url))) {
                  // launchUrl(Uri.parse(url),mode:LaunchMode.externalApplication)
                  //     .then((value) => SubscriptionApiController().clickAd(adId: id));
                  // // }
                  // // }
                    // if(controller.ads.first.url != null){
                    // String url = url ?? "";

                  if (await canLaunchUrl(Uri.parse("${url}"))) {
                    try {
                      launchUrl(Uri.parse("${url}"), mode: LaunchMode
                          .externalApplication).then((value) => SubscriptionApiController().clickAd(adId: id));
                    } catch (e) {
                      print(e);
                    }
                    // .then((value) => SubscriptionApiController().clickAd(adId: controller.ads.first.id.toString()));
                  } else {
                    print("Not able");
                  }


                },child: Image.network("https://www.rakwa.com/laravel_project/public/storage/item/${link}",fit: BoxFit.cover, width: double.infinity ,height: double.infinity/2,))) :
            // videoPlayerController != null  ?
            //   _controller!.value.isInitialized ?
            //   SizedBox(
            // height: 120.h,
            //   child: AspectRatio(
            //       aspectRatio:  _controller!.value.aspectRatio,
            //   child: VideoPlayer(_controller!),
            //   ),
            // )
            //     // VideoPlayerController.file(File(pic.adVideo.value))..initialize())
            //     :   Container(
            //     color: Colors.blue,
            //   ),
            // ),
            link.contains("youtube") || link.contains("youtu.be") ? YoutubePlayer(controller:  _controller!) :   VideoPlay(url: link,),
          ],
        )


      )
    );
    showDialog(
        context: context,
        barrierColor: Colors.white.withOpacity(0.61),
        builder: (BuildContext context) => foodEnlargeDialog);
  }
   rePromotionAd(BuildContext context,{required String adId}) {


    Get.put(AllSubscribtionsGetxController());
    AllSubscribtionsGetxController.to.getSubscription();
    AllSubscribtionsGetxController.to.selectedCurrency.value = "USD";
    Dialog foodEnlargeDialog = Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        //this right here
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.6,
                padding: EdgeInsets.all(8),
                // color:CustomColors.primaryColor:CustomColors.unselectedColor,

                // child: link.isNotEmpty && type == "0" ?Image.network("https://www.rakwa.com/laravel_project/public/storage/item/${link}") :
                // child:  videoPlaoyerController != null  ?
                //   videoPlayerController!.value.isInitialized ? SizedBox(
                //     height: 120.h,
                //     child: AspectRatio(
                //       aspectRatio:  videoPlayerController!.value.aspectRatio,
                //       child: VideoPlayer(videoPlayerController!),
                //     ),
                //   )
                //       : Container()
                //         : Container()
                child: GetX<AllSubscribtionsGetxController>(
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
                            }) ) : SingleChildScrollView(
                      child: Column(
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
                          //           child: DropdownButton(
                          //
                          //               value: controller.selectedCurrency.value,
                          //               hint: Text("اختر العملة",
                          //                 style: GoogleFonts.notoKufiArabic(
                          //                   textStyle:  TextStyle(
                          //                     fontSize: 12.sp,
                          //                     // fontWeight: FontWeight.bold,
                          //                     color: Color(0xFF3D3C42).withOpacity(0.4),
                          //                   ),
                          //                 ),),
                          //               isDense: true,
                          //               isExpanded: true,
                          //               items: controller.currencies.map<DropdownMenuItem<String>>((value){
                          //                 return
                          //                   DropdownMenuItem(
                          //                       value: value,
                          //
                          //                       child: Text(value,
                          //                           style: GoogleFonts.notoKufiArabic(
                          //                             textStyle:  TextStyle(
                          //                               fontSize: 12.sp,
                          //                               fontWeight: FontWeight.bold,
                          //                               color: Color(0xFF3D3C42),
                          //                             ),)));
                          //               }).toList(),
                          //               onChanged: (value) async{
                          //                 // setState(() {
                          //
                          //                 controller.selectedCurrency.value = value!;
                          //                 controller.isLoading.value = true;
                          //
                          //                 await controller.getSubscription2();
                          //
                          //                 print( controller.isLoading.value);
                          //                 print(value);
                          //
                          //                 if(controller.sub.isNotEmpty){
                          //
                          //                   controller.isLoading.value = false;
                          //
                          //                   if(value == "EUR"){
                          //                     controller.loading.value = true;
                          //
                          //                     for(int i = 0; i < controller.sub.first.subscriptions!.length; i++){
                          //                       controller.sub.first.subscriptions![i].priceViews = await calculateAmount(controller.sub.first.subscriptions![i].priceViews.toString());
                          //                       controller.sub.first.subscriptions![i].priceClicks = await calculateAmount(controller.sub.first.subscriptions![i].priceClicks.toString());
                          //                       controller.sub.first.subscriptions![i].total = await calculateAmount(controller.sub.first.subscriptions![i].total.toString());
                          //                       //
                          //                     }
                          //
                          //
                          //                     controller.total.value = double.parse(controller.sub.first.eUR!.first.toString()).round().toString();
                          //                     controller.loading.value = false;
                          //
                          //                     setState(() =>{});
                          //
                          //                   }
                          //                   else if(value == "TRY"){
                          //
                          //                     controller.loading.value = true;
                          //                     for(int i = 0; i < controller.sub.first.subscriptions!.length; i++){
                          //                       controller.sub.first.subscriptions![i].priceViews = await calculateAmount(controller.sub.first.subscriptions![i].priceViews.toString());
                          //                       controller.sub.first.subscriptions![i].priceClicks = await calculateAmount(controller.sub.first.subscriptions![i].priceClicks.toString());
                          //                       controller.sub.first.subscriptions![i].total = await calculateAmount(controller.sub.first.subscriptions![i].total.toString());
                          //                     }
                          //
                          //                     controller.total.value = double.parse(controller.sub.first.tRY!.first.toString()).round().toString();
                          //                     controller.loading.value = false;
                          //
                          //                     setState(() =>{});
                          //                   }else{
                          //                     controller.total.value = controller.sub.first.subscriptions!.first.total ?? "";
                          //                     setState(() =>{});
                          //
                          //                   }
                          //                 }
                          //
                          //
                          //
                          //
                          //                 // controller.sub.first
                          //                 // selectedTime = value;
                          //                 // AllOrdersGetxController.to.timeId.value = selectedTime!.id ?? "";
                          //               })
                          //         // }),
                          //       ),)
                          //   ],
                          // ),

                          ListView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemCount: controller.sub.first.subscriptions!.length,
                              itemBuilder: (context, index){
                                return GetX<AllSubscribtionsGetxController>(
                                  builder: (c) {
                                    return InkWell(
                                      onTap: (){
                                          c.subscriptionId.value = c.sub.first.subscriptions![index].id ?? 0;
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 16.h),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: c.subscriptionId.value == c.sub.first.subscriptions![index].id ?  AppColors().mainColor : Color(0xFFF4F4F4)
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
                                                  value: c.sub.first.subscriptions![index].id,
                                                  groupValue: c.subscriptionId.value,
                                                  title: Text(c.sub.first.subscriptions![index].name ?? "",
                                                    style: GoogleFonts.notoKufiArabic(
                                                      textStyle: TextStyle(
                                                        fontSize: 12.sp,
                                                        color: Colors.black,
                                                      ),),),
                                                  onChanged: (value){
                                                      c.subscriptionId.value = c.sub.first.subscriptions![index].id?? 0;
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

                                                        Expanded(
                                                          child: Text(" بتكلفة ${double.parse(controller.sub.first.subscriptions![index].priceClicks.toString()).round() } ${controller.selectedCurrency.value} " ?? "",
                                                            style: GoogleFonts.notoKufiArabic(
                                                              textStyle: TextStyle(
                                                                fontSize: 12.sp,
                                                                color: Colors.black,
                                                              ),),),
                                                        ),
                                                      ],
                                                    ) : Container(),
                                                    controller.sub.first.subscriptions![index].views != null ?    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [

                                                        Text(" ${controller.sub.first.subscriptions![index].views.toString()} مشاهدة"?? "",
                                                          style: GoogleFonts.notoKufiArabic(
                                                            textStyle: TextStyle(
                                                              fontSize: 12.sp,
                                                              color: Colors.black,
                                                            ),),),
                                                        Expanded(
                                                          child: Text(" بتكلفة ${double.parse(controller.sub.first.subscriptions![index].priceViews.toString()).round()} ${controller.selectedCurrency.value} " ?? "",
                                                            style: GoogleFonts.notoKufiArabic(
                                                              textStyle: TextStyle(
                                                                fontSize: 12.sp,
                                                                color: Colors.black,
                                                              ),),),
                                                        ),
                                                      ],
                                                    ) : Container(),

                                                    Align(
                                                      alignment: AlignmentDirectional.bottomEnd,
                                                      child: Text(" المجموع ${double.parse(controller.sub.first.subscriptions![index].total.toString()).round()} ${controller.selectedCurrency.value} ",
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
                                  }
                                );

                              }),
                          MainElevatedButton(child:   Text("اعادة الترويج",style: GoogleFonts.notoKufiArabic(
                            textStyle:  TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),)), height: 48, width: double.infinity, borderRadius: 4, onPressed: (){

                            makePayment(context);
                          })
                        ],
                      ),
                    );
                  }
                ),



            );
          }
        )
    );
    showDialog(
        context: context,
        barrierColor: Colors.white.withOpacity(0.61),
        builder: (BuildContext context) => foodEnlargeDialog);
  }

  Future<void> makePayment(BuildContext context) async {
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
      displayPaymentSheet(context);
    } catch (err) {
      throw Exception(err);
    }
  }


  createPaymentIntent(String amount, String currency) async {
    print("Amount ${amount}");
    print("Amount ${(double.parse(amount)).round().toString()}");
   ;
    try {
      //Request body
      Map<String, dynamic> body = {
        'amount':   (double.parse(amount) * 100).round().toString(),
        'currency': currency,
      };

      //Make post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          // 'Authorization': 'Bearer sk_test_51MyGdi2jXjU2QVGMv1Ud4oBwwg5VzwZFJBwZlNhkG4ayZaeLsZOrPyA7wFnJrddIHdXSphfi1q5Ou340FNUGHD6l00rh7kMTX8',
          'Authorization': 'Bearer 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',
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
  displayPaymentSheet(BuildContext context) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        // SubscriptionApiController().createSmartAds(context,);

        SubscriptionApiController().newStoreAd();
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
  static showEnterOtpDialog2(BuildContext context,) {
    String code1= "";

    Get.put(ErrorsMessageControllerGetx());
    ErrorsMessageControllerGetx.to.otpError.value = "";
    // if(newUser){
    //   AuthConsumer().sendOtpCodeCivil(context, civilId, newUser);
    // }

    GlobalKey<FormState> key= GlobalKey<FormState>();
    Dialog foodEnlargeDialog = Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      //this right here
      child: Container(
        height: 150.0.h,
        width: 100.0.w,
        // color:CustomColors.primaryColor:CustomColors.unselectedColor,

        child: GetX<ErrorsMessageControllerGetx>(
            builder: (controller) {
              print(controller.otpError.value);
              return Padding(
                padding:  EdgeInsets.all(8.0.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 10.h,),
                    Text("أدخل الكود المرسل لك",style: GoogleFonts.notoKufiArabic(
                        textStyle:  TextStyle(
                          color: Colors.black,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),)),
                    SizedBox(height: 10.h,),

                    PinFieldAutoFill(
                      // decoration: UnderlineDecoration(
                      //   textStyle: TextStyle(fontSize: 20, color: Colors.black),
                      //   colorBuilder: FixedColorBuilder(Colors.black.withOpacity(0.3)),
                      //   bgColorBuilder: FixedColorBuilder(Colors.white),
                      // ),
                      key: key,
                      decoration: BoxLooseDecoration(
                        strokeColorBuilder: FixedColorBuilder(Colors.black.withOpacity(0.3)),
                        textStyle: TextStyle(fontSize: 20.sp, color: Colors.black),
                        // colorBuilder: FixedColorBuilder(Colors.black.withOpacity(0.3)),
                        bgColorBuilder: FixedColorBuilder(Colors.white),

                      ),
                      cursor: Cursor(
                        width: 2.w,
                        height: 40.h,
                        color: AppColors().mainColor,
                        radius: Radius.circular(1),
                        enabled: true,
                      ),
                      currentCode: code1,
                      autoFocus: true,
                      onCodeSubmitted: (code) {
                        code1 = code;

                        OrderApiController().verifyOTPCode(context, code);
                      },
                      onCodeChanged: (code) {
                        // ErrorsMessageControllerGetx.to.otpError.value = "";

                        code1 = code!;
                        if (code!.length == 6) {
                          // FocusScope.of(context).requestFocus(FocusNode());
                          // AuthConsumer().verfiyOtpCodeCivil(context ,civilId ,code1,newUser, fromWhere,phone: phone);

                          OrderApiController().verifyOTPCode(context, code);

                        }
                      },
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Text("لم يصلك كود تحقق؟",style: GoogleFonts.notoKufiArabic(
                            textStyle:  TextStyle(
                              color: Colors.black,
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w600,
                            ),)),
                          InkWell(
                            onTap: (){
                              OrderApiController().verifyPhone(context);
                            },
                            child: Text("أرسله مرة اخرى",style: GoogleFonts.notoKufiArabic(
                              textStyle:  TextStyle(
                                color: Colors.black,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w700,
                              ),)),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Visibility(
                        visible: controller.otpError.value.isNotEmpty,
                        child: Column(
                          children: [
                            Align(
                                alignment: AlignmentDirectional.topStart,
                                child: Text(controller.otpError.value,
                                    style: GoogleFonts.notoKufiArabic(
                                    textStyle:  TextStyle(
                                      color: Colors.red,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                    ),))),
                          ],
                        ),
                      ),
                    ),
                    // ElevatedButton(onPressed: () {
                    //
                    //   AuthConsumer().verfiyOtpCodeCivil(context ,civilId ,code1,newUser, fromWhere,phone: phone);
                    // }, child: Text("Enter",style: TextStyle(color: Colors.black),), style: ElevatedButton.styleFrom(
                    //   primary: Colors.white,
                    // ),)
                  ],
                ),
              );
            }
        ),
      ),
    );
    showDialog(
        context: context
        , barrierColor: Colors.white.withOpacity(0.61)
        ,
        builder: (BuildContext context) => foodEnlargeDialog);
  }

  static verifyPhoneSuccess(BuildContext context) {
    Dialog foodEnlargeDialog = Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      //this right here
      child: Container(
        height: 130.0.h,
        width: 100.0.w,
        padding: EdgeInsets.all(8),
        // color:CustomColors.primaryColor:CustomColors.unselectedColor,

        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
"تم التحقق بنجاح",
                style: GoogleFonts.notoKufiArabic(
                  textStyle:  TextStyle(
                    color: Colors.black,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 15.h,),

              InkWell(
                onTap: (){
                  Navigator.pop(context);
                  // AuthConsumer().sendOtpCodeCivil(context, civilId, false, "forget");
                },
                child: Text(
                  "موافق",
                  style: GoogleFonts.notoKufiArabic(
                    textStyle:  TextStyle(
                      color: Colors.black,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),),
            ],
          ),
        ),
      ),
    );
    showDialog(
        context: context,
        barrierColor: Colors.white.withOpacity(0.61),
        builder: (BuildContext context) => foodEnlargeDialog);
  }
  static errorDialog(BuildContext context, { required String error}) {
    Dialog foodEnlargeDialog = Dialog(
      backgroundColor: AppColors().mainColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      //this right here
      child: Container(
        height: 130.0.h,
        width: 100.0.w,
        padding: EdgeInsets.all(8),
        // color:CustomColors.primaryColor:CustomColors.unselectedColor,

        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
            error,
                style: GoogleFonts.notoKufiArabic(
                  textStyle:  TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 15.h,),

              InkWell(
                onTap: (){
                  Navigator.pop(context);
                  // AuthConsumer().sendOtpCodeCivil(context, civilId, false, "forget");
                },
                child: Text(
                  "إغلاق",
                  style: GoogleFonts.notoKufiArabic(
                    textStyle:  TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),),
            ],
          ),
        ),
      ),
    );
    showDialog(
        context: context,
        barrierColor: Colors.white.withOpacity(0.61),
        builder: (BuildContext context) => foodEnlargeDialog);
  }
  static newUpdateAndroid(BuildContext context,) {
    Dialog foodEnlargeDialog = Dialog(
      backgroundColor: Colors.white,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      //this right here
      child: Padding(
        padding:  EdgeInsets.all(8.0.w),
        child: SingleChildScrollView(
          child: Center(
            // padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "تحديث جديد متوفر",
                  style: GoogleFonts.notoKufiArabic(
                    textStyle:  TextStyle(
                      color: Colors.black,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 10.h,),
                Text(
                 AppInterfaceGetx.to.messageUpdate.value,
                  style: GoogleFonts.notoKufiArabic(
                    textStyle:  TextStyle(
                      color: Colors.black,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 15.h,),

                InkWell(
                  onTap: (){
                    launchUrl(Uri.parse("https://play.google.com/store/apps/details?id=rakwa.turkey.com"),mode: LaunchMode.externalApplication);

                    // Navigator.pop(context);
                    // AuthConsumer().sendOtpCodeCivil(context, civilId, false, "forget");
                  },
                  child: Text(
                    " تحديث الآن",
                    style: GoogleFonts.notoKufiArabic(
                      textStyle:  TextStyle(
                        color: Colors.black,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),),
              ],
            ),
          ),
        ),
      ),
    );
    showDialog(
        context: context,
        barrierColor: Colors.white.withOpacity(0.61),
        barrierDismissible: false,
        builder: (BuildContext context) => foodEnlargeDialog);
  }
  static openSittingsAndroid(BuildContext context,) {
    Dialog foodEnlargeDialog = Dialog(
      backgroundColor: Colors.white,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      //this right here
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Center(
            // padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "تنبيه",
                  style: GoogleFonts.notoKufiArabic(
                    textStyle:  TextStyle(
                      color: Colors.black,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 10.h,),
                Text(
                 'يجب عليك تفعيل صلاحية تحديد الموقع للحصول على نتائج صحيحة',
                  style: GoogleFonts.notoKufiArabic(
                    textStyle:  TextStyle(
                      color: Colors.black,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 15.h,),

                InkWell(
                  onTap: ()async{
                    // launchUrl(Uri.parse("https://play.google.com/store/apps/details?id=rakwa.turkey.com"),mode: LaunchMode.externalApplication);
// openAppSettings();
                    // Navigator.pop(context);
                    // AuthConsumer().sendOtpCodeCivil(context, civilId, false, "forget");
                    await Geolocator.openLocationSettings();

                  },
                  child: Text(
                    "اذهب للاعدادات",
                    style: GoogleFonts.notoKufiArabic(
                      textStyle:  TextStyle(
                        color: Colors.black,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),),
              ],
            ),
          ),
        ),
      ),
    );
    showDialog(
        context: context,
        barrierColor: Colors.white.withOpacity(0.61),
        barrierDismissible: true,
        builder: (BuildContext context) => foodEnlargeDialog);
  }
  static openSittingIOS(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('تنبيه'),
        content: const Text('يجب عليك تفعيل صلاحية تحديد الموقع للحصول على نتائج صحيحة'),
        actions: <CupertinoDialogAction>[
          // CupertinoDialogAction(
          //   /// This parameter indicates this action is the default,
          //   /// and turns the action's text to bold text.
          //   isDefaultAction: true,
          //   onPressed: () {
          //     Navigator.pop(context);
          //   },
          //   child: const Text('موافق'),
          // ),
          CupertinoDialogAction(
            /// This parameter indicates the action would perform
            /// a destructive action such as deletion, and turns
            /// the action's text color to red.
            isDestructiveAction: false,
            onPressed: () async{
              Navigator.pop(context);

              // openAppSettings();
              await Geolocator.openLocationSettings();
            },
            child: const Text('اذهب للاعدادات'),
          ),
        ],
      ),
    );
  }
  static userSafePayment(BuildContext context,) {
    Dialog foodEnlargeDialog = Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      //this right here
      child: Container(
        height: Get.height / 1.3,
        // width: 100.0.w,
        padding: EdgeInsets.all(8),
        // color:CustomColors.primaryColor:CustomColors.unselectedColor,

        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                    alignment: AlignmentDirectional.topEnd,
                    child: IconButton(onPressed: () => Get.back(), icon: Icon(Icons.clear))),
                Text(
                  "نود أن نلفت انتباهك إلى أن معلومات بطاقتك الائتمانية مؤمنة تمامًا على منصة ركوة. نحن نضع سلامتك وأمان معلوماتك الشخصية في صدارة أولوياتنا، ولذلك فإننا نتخذ جميع التدابير الضرورية لحماية معلوماتك الشخصية."

                      " يرجى ملاحظة أننا لا نقوم بالاحتفاظ بأي بيانات تتعلق بالبطاقة المستخدمة بعد اكتمال عملية الشراء الخاصة بك. هذا يعني أننا لا نقوم بتخزين معلومات البطاقة الائتمانية الخاصة بك على منصتنا بأي شكل من الأشكال."

                      "كإجراء إضافي لضمان أمان حسابك، ستتلقى رسالة نصية على رقم هاتفك المسجل معنا بعد اكتمال طلبك. سيتم إرسال كود خاص بالأمان إلى رقم هاتفك المسجل. يُطلب منك إدخال هذا الرمز للتحقق من هويتك وضمان أنه أنت الشخص الذي يقوم بالمعاملة."

                      "في حالة وجود أي استفسارات أو مخاوف بخصوص أمان المعلومات أو أي جانب آخر، يرجى عدم التردد في الاتصال بفريق خدمة العملاء لدينا. سيكون فريق الدعم متاحًا لمساعدتك وتقديم أية معلومات إضافية تحتاجها."

                      "شكرًا لاختيارك منصة ركوة، ونتطلع إلى خدمتك مرة أخرى في المستقبل."

                      "مع خالص التحية",
                  style: GoogleFonts.notoKufiArabic(
                    textStyle:  TextStyle(
                      color: Colors.black,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 15.h,),

                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                    // AuthConsumer().sendOtpCodeCivil(context, civilId, false, "forget");
                  },
                  child: Text(
                    "موافق",
                    style: GoogleFonts.notoKufiArabic(
                      textStyle:  TextStyle(
                        color: Colors.black,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),),
              ],
            ),
          ),
        ),
      ),
    );
    showDialog(
        context: context,
        barrierColor: Colors.white.withOpacity(0.61),
        builder: (BuildContext context) => foodEnlargeDialog);
  }
  static removeAllCartDialog(BuildContext context,) {
    Dialog foodEnlargeDialog = Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      //this right here
      child: Container(
        height: 160.0.h,
        // width: 100.0.w,
        padding: EdgeInsets.all(8),
        // color:CustomColors.primaryColor:CustomColors.unselectedColor,

        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
"يوجد بالسلة عناصر من مطعم آخر. هل ترغب بحذفها؟",
                style: GoogleFonts.notoKufiArabic(
                  textStyle:  TextStyle(
                    color: Colors.black,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 15.h,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MainElevatedButton(child: Text(
                    "افراغ",
                    style: GoogleFonts.notoKufiArabic(
                      textStyle:  TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ), height: 48.h, width: 120.w,
                      borderRadius: 4.r, onPressed: ()=> AllCartsGetxController.to.removeAllCartFromApi(),),
                  MainElevatedButton(child: Text(
                    "أغلق",
                    style: GoogleFonts.notoKufiArabic(
                      textStyle:  TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ), height: 48.h, width: 120.w,
                      borderRadius: 4.r, onPressed: ()=> Get.back(),backgroundColor: Colors.grey.shade400,),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    showDialog(
        context: context,
        barrierColor: Colors.white.withOpacity(0.61),
        builder: (BuildContext context) => foodEnlargeDialog);
  }
  static addNewCategoryBox(BuildContext context, {String? category, int? index, String? resturentId}) {
    TextEditingController controller = TextEditingController();

    if(category != null){
      controller.text = category;
    }
    Dialog foodEnlargeDialog = Dialog(
      backgroundColor: AppColors().mainColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      //this right here
      child: Container(
        height: 180.0.h,
        width: 100.0.w,
        padding: EdgeInsets.all(8),
        // color:CustomColors.primaryColor:CustomColors.unselectedColor,

        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "اضافة قسم جديد",
                style: GoogleFonts.notoKufiArabic(
                  textStyle:  TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 15.h,),
Padding(
                padding:  EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                child: TextFieldDefault(
                  controller: controller,
                  upperFontSize: 12,
                  upperTitle: "اسم القسم",
                  upperTitleColor: Colors.white,
                  hint: "مشاوي",
                ),
              ),
              InkWell(
                onTap: () async{
                  if(resturentId != null){
                  AddCategory?  add = await MenuApiController().createCategories(resturentId: resturentId, categoryName: controller.text);
                  if(add != null){
                   AllMenusGetxController.to.isLoading.value = false;
                    await AllMenusGetxController.to.getMenuResCategories(resId: resturentId);

                    AllMenusGetxController.to.selectedCategory = AllMenusGetxController.to.categories.where((p0) => p0.id == AllMenusGetxController.to.itemDetails.first.data!.categoryId).first;

                  }

                    Navigator.pop(context);

                  }else{
                    category != null ? AddWorkOrAdsController.to.categories[index!] =  controller.text :   AddWorkOrAdsController.to.categories.add(controller.text);
                    Navigator.pop(context);
                  }

                  // AuthConsumer().sendOtpCodeCivil(context, civilId, false, "forget");
                },
                child: Text(
                category != null ? "تعديل" : "اضافة",
                  style: GoogleFonts.notoKufiArabic(
                    textStyle:  TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),),
            ],
          ),
        ),
      ),
    );
    showDialog(
        context: context,
        barrierColor: Colors.white.withOpacity(0.61),
        builder: (BuildContext context) => foodEnlargeDialog);
  }
  static addNewItemBox(BuildContext context, {String? category, int? index}) {
    print(category);
    TextEditingController name = TextEditingController();
    TextEditingController desc = TextEditingController();
    TextEditingController price = TextEditingController();
    TextEditingController price2 = TextEditingController();
    TextEditingController optionName = TextEditingController();
    TextEditingController options = TextEditingController();
    TextEditingController extraName = TextEditingController();
    TextEditingController extraPrice = TextEditingController();
     XFile? image;


     Get.put(ImagePickerController());
     Get.put(AllMenusGetxController());

     int option = 0;
    AllMenusGetxController.to.optionsCount.clear();
    AllMenusGetxController.to.optionsName.clear();
    // AllMenusGetxController.to.optionsController.clear();
    AllMenusGetxController.to.options.clear();
    AllMenusGetxController.to.options2.clear();
    AllMenusGetxController.to.varents.clear();
    AllMenusGetxController.to.varents2.clear();
    AllMenusGetxController.to.extras2.clear();
    AllMenusGetxController.to.extras.clear();
    AllMenusGetxController.to.selectedValue.value = "";
    // if(category != null){
    //   controller.text = category;
    // }
    Dialog foodEnlargeDialog = Dialog(
      backgroundColor: AppColors().mainColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      //this right here
      child: GetX<ImagePickerController>(
        builder: (pic) {
          print(pic.path);
          return Container(
            height: 360.0.h,
            width: 100.0.w,
            padding: EdgeInsets.all(8),
            // color:CustomColors.primaryColor:CustomColors.unselectedColor,

            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "اضافة عنصر جديد",
                      style: GoogleFonts.notoKufiArabic(
                        textStyle:  TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 15.h,),
                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                      child: TextFieldDefault(
                        controller: name,
                        upperFontSize: 12,
                        upperTitle: "اسم العنصر",
                        upperTitleColor: Colors.white,
                        hint: "مشاوي",
                      ),
                    ),
                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                      child: TextFieldDefault(
                        controller: desc,
                        upperFontSize: 12,
                        upperTitle: "وصف العنصر",
                        upperTitleColor: Colors.white,
                        hint: "مشاوي",
                      ),
                    ),
                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                      child: TextFieldDefault(
                        controller: price,
                        upperFontSize: 12,
                        upperTitle: "سعر العنصر",
                        upperTitleColor: Colors.white,
                        hint: "12",
                      ),
                    ),
                    Text(
                      "صورة العنصر",
                      style: GoogleFonts.notoKufiArabic(
                        textStyle:  TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      textAlign: TextAlign.start,
                    ),
                    InkWell(
                      onTap: () async{
                        ImagePicker picker = ImagePicker();
// Pick an image.
                        image = await picker.pickImage(source: ImageSource.gallery);
                        if(image != null){
                         pic.path.value = image!.path;
                        }
                      },
                      child: Container(
                        width: 120.w,
                        height: 120.h,
                        color: Colors.grey.shade400,
                        child: image != null ? Image.file(File(pic.path.value,),fit: BoxFit.cover,) : Icon(Icons.add),
                      ),
                    ),

                    Row(
                      children: [
                        Switch(value: pic.value.value,
                            onChanged: (v){
              pic.value.value = v;
              }),


                        Text(
                          "هل يوجد متغيرات؟",
                          style: GoogleFonts.notoKufiArabic(
                            textStyle:  TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),

                    GetX<AllMenusGetxController>(
                      builder: (c) {
                        return Visibility(
                          visible: ImagePickerController.to.value.value,
                          child: Column(
                            children: [

                              // InkWell(
                              //   onTap: (){
                              //
                              //     TextEditingController c1= TextEditingController();
                              //     TextEditingController c2= TextEditingController();
                              //     AllMenusGetxController.to.optionsCount.add(option);
                              //     AllMenusGetxController.to.optionsNameController.add(c1);
                              //     AllMenusGetxController.to.optionsController.add(c2);
                              //     AllMenusGetxController.to.options.add("");
                              //     option++;
                              //     print(AllMenusGetxController.to.optionsCount);
                              //     print(AllMenusGetxController.to.optionsController);
                              //   },
                              //   child: Text(
                              //     "اضافة خيارات",
                              //     style: GoogleFonts.notoKufiArabic(
                              //       textStyle:  TextStyle(
                              //         color: Colors.white,
                              //         fontSize: 12.sp,
                              //         fontWeight: FontWeight.w600,
                              //       ),
                              //     ),
                              //     textAlign: TextAlign.start,
                              //   ),
                              // ),
                          Column(
                          children: [
                          Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Column(
                                  children: [
                                    MyTextField(hint: "الاحجام", controller: optionName),
                                    SizedBox(height: 10.h,),
                                    MyTextField(hint: "صغير،كبير،متوسط", controller: options),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10.w,),
                              InkWell(
                                onTap: (){
                                  // AllMenusGetxController.to.map.addAll({
                                  //   "name" : "test",
                                  //   "options" : "tets 223",
                                  // });
                                  //
                                  // if(!AllMenusGetxController.to.options.contains(c.optionsController[index].text)){
                                  //   AllMenusGetxController.to.options.removeAt(index);
                                  //   // c.options2.clear();
                                  //   AllMenusGetxController.to.options.add(c.optionsController[index].text);
                                  // }else{
                                  //   // AllMenusGetxController.to.options.removeAt(index);
                                  //   c.options[index] = c.optionsController[index].text;
                                  // }

                                  // c.options2.clear();
                                  // c.options2.addAll(c.options);

                                  // print(AllMenusGetxController.to.options.splitList((item) => false));

                                  // print( AllMenusGetxController.to.options);

                                  // c.options.clear();
                                  // for(int i = 0; i < c.optionsController.length; i++){
                                    c.options.addAll(options.text.split(','));
                                    c.options2.add(options.text);
                                    c.optionsName.add(optionName.text);
                                  // }

                                  c.selectedValue.value = c.options.first;
                                  options.clear();
                                  optionName.clear();

                                  // for(int o = 0; o < c.options.length; )
                                  // // c.options.value = c.optionsController.expand((element) => element.text).toList() as List<String>;
                                  // // c.options.add(c.optionsController[]);
                                  // print(AllMenusGetxController.to.options);
                                  // print( AllMenusGetxController.to.optionsNameController[index].text);
                                  // print( AllMenusGetxController.to.optionsController[index].text);

                                },
                                child: Text(
                                  "اضف",
                                  style: GoogleFonts.notoKufiArabic(
                                    textStyle:  TextStyle(
                                      color: Colors.white,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),

                            ],
                          ),
                          SizedBox(width: 10.w,),
                          Divider(),
                          // DropdownButton(items: c.optionsNameController.map((e) => DropdownMenuItem(child: Text("we sdds"))).toList(), onChanged: (value){})
                          ],
                          ),

                              ListView.builder(
                                  itemCount: c.options2.length,
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  itemBuilder: (context, index){
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(c.optionsName[index], style: GoogleFonts.notoKufiArabic(
                                          textStyle:  TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),),
                                        Text(c.options2[index], style: GoogleFonts.notoKufiArabic(
                                          textStyle:  TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),),
                                        // Text(c.varents2[index]),
                                      ],
                                    );
                                  }),

                              // ListView.builder(
                              //     itemCount: c.optionsCount.length,
                              //     shrinkWrap: true,
                              //     physics: ScrollPhysics(),
                              //     itemBuilder: (context, index){
                              //       return  Column(
                              //         children: [
                              //           Row(
                              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //             children: [
                              //               Expanded(
                              //                 flex: 3,
                              //                 child: Column(
                              //                   children: [
                              //                     MyTextField(hint: "الاحجام", controller: c.optionsNameController[index]),
                              //                     SizedBox(height: 10.h,),
                              //                     MyTextField(hint: "صغير،كبير،متوسط", controller: c.optionsController[index]),
                              //                   ],
                              //                 ),
                              //               ),
                              //               SizedBox(width: 10.w,),
                              //               InkWell(
                              //                 onTap: (){
                              //                   // AllMenusGetxController.to.map.addAll({
                              //                   //   "name" : "test",
                              //                   //   "options" : "tets 223",
                              //                   // });
                              //                   //
                              //                   // if(!AllMenusGetxController.to.options.contains(c.optionsController[index].text)){
                              //                   //   AllMenusGetxController.to.options.removeAt(index);
                              //                   //   // c.options2.clear();
                              //                   //   AllMenusGetxController.to.options.add(c.optionsController[index].text);
                              //                   // }else{
                              //                   //   // AllMenusGetxController.to.options.removeAt(index);
                              //                   //   c.options[index] = c.optionsController[index].text;
                              //                   // }
                              //
                              //                   // c.options2.clear();
                              //           // c.options2.addAll(c.options);
                              //
                              //                   // print(AllMenusGetxController.to.options.splitList((item) => false));
                              //
                              //                   // print( AllMenusGetxController.to.options);
                              //
                              //                   c.options.clear();
                              //                   for(int i = 0; i < c.optionsController.length; i++){
                              //                     c.options.addAll(c.optionsController[i].text.split(','));
                              //                   }
                              //
                              //                   c.selectedValue.value = c.options.first;
                              //                   // for(int o = 0; o < c.options.length; )
                              //                   // // c.options.value = c.optionsController.expand((element) => element.text).toList() as List<String>;
                              //                   // // c.options.add(c.optionsController[]);
                              //                   // print(AllMenusGetxController.to.options);
                              //                   // print( AllMenusGetxController.to.optionsNameController[index].text);
                              //                   // print( AllMenusGetxController.to.optionsController[index].text);
                              //
                              //                 },
                              //                 child: Text(
                              //                   "اضف",
                              //                   style: GoogleFonts.notoKufiArabic(
                              //                     textStyle:  TextStyle(
                              //                       color: Colors.white,
                              //                       fontSize: 10.sp,
                              //                       fontWeight: FontWeight.w600,
                              //                     ),
                              //                   ),
                              //                   textAlign: TextAlign.start,
                              //                 ),
                              //               ),
                              //
                              //             ],
                              //           ),
                              //           SizedBox(width: 10.w,),
                              //           Divider(),
                              //           // DropdownButton(items: c.optionsNameController.map((e) => DropdownMenuItem(child: Text("we sdds"))).toList(), onChanged: (value){})
                              //         ],
                              //       );
                              //     }),
                              // GetX<AllMenusGetxController>(
                              //   builder: (con) {
                              //     print(con.options);
                              //     return SizedBox(
                              //       height: 120.h,
                              //       child: ListView.builder(
                              //         itemCount: con.optionsController.length,
                              //         shrinkWrap: true,
                              //         physics: ScrollPhysics(),
                              //         itemBuilder: (context, index) {
                              //           return Row(
                              //             children: [
                              //               MyTextField(hint: "السعر", controller: con.optionsController[index]),
                              //               DropdownButton<String>(items: con.options.map((e) => DropdownMenuItem<String>(child: Text(e),value: e,)).toList(), onChanged: (value){}),
                              //             ],
                              //           );
                              //         }
                              //       ),
                              //     );
                              //   }
                              // ),
                              Visibility(
                               visible: c.selectedValue.isNotEmpty,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                                width:90.w,
                                                child: MyTextField(hint: "السعر", controller: price2)),
                                            SizedBox(width: 20.w,),
                                            DropdownButton<String>(

                                              dropdownColor: Colors.black,
                                              items: c.options.map((e) => DropdownMenuItem<String>(child: Text(e, style: GoogleFonts.notoKufiArabic(
                                                textStyle:  TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),),value: e,),).toList(), onChanged: (value){
                                              c.selectedValue.value = value!;
                                            },hint: Text("اختار", style: GoogleFonts.notoKufiArabic(
                                              textStyle:  TextStyle(
                                                color: Colors.white,
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),),
                                              value: c.selectedValue.value,),
                                          ],
                                        ),


                                        InkWell(
                                          onTap: (){
                                            c.varents.add(price2.text);
                                            c.varents2.add(c.selectedValue.value);
                                            price2.text = "";
                                          },
                                          child: Text(
                                            "اضف",
                                            style: GoogleFonts.notoKufiArabic(
                                              textStyle:  TextStyle(
                                                color: Colors.white,
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                        ),


                                      ],
                                    ),
                                    ListView.builder(
                                        itemCount: c.varents.length,
                                        shrinkWrap: true,
                                        physics: ScrollPhysics(),
                                        itemBuilder: (context, index){
                                          return Row(
                                            children: [
                                              Text("₺ ${c.varents[index]}", style: GoogleFonts.notoKufiArabic(
                                                textStyle:  TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),),
                                              SizedBox(width: 10.w,),
                                              Text(c.varents2[index], style: GoogleFonts.notoKufiArabic(
                                                textStyle:  TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),),
                                            ],
                                          );
                                        })
                                  ],
                                ),
                              ),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Text(
                                    "اضافات على الوجبة",
                                    style: GoogleFonts.notoKufiArabic(
                                      textStyle:  TextStyle(
                                        color: Colors.white,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          children: [
                                            MyTextField(hint: "اسم الاضافة", controller: extraName),
                                            SizedBox(height: 10.h,),
                                            MyTextField(hint: "السعر", controller: extraPrice),
                                          ],
                                        ),
                                      ),

                                      SizedBox(width: 10.w,),

                                      InkWell(
                                        onTap: (){
                                          c.extras.add(extraPrice.text);
                                          c.extras2.add(extraName.text);
                                          extraPrice.text = "";
                                          extraName.text = "";
                                        },
                                        child: Text(
                                          "اضف",
                                          style: GoogleFonts.notoKufiArabic(
                                            textStyle:  TextStyle(
                                              color: Colors.white,
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),


                                    ],
                                  ),
                                  ListView.builder(
                                      itemCount: c.extras2.length,
                                      shrinkWrap: true,
                                      physics: ScrollPhysics(),
                                      itemBuilder: (context, index){
                                        return Row(
                                          children: [
                                            Text("₺ ${c.extras[index]}", style: GoogleFonts.notoKufiArabic(
                                              textStyle:  TextStyle(
                                                color: Colors.white,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),),
                                            SizedBox(width: 10.w,),
                                            Text(c.extras2[index], style: GoogleFonts.notoKufiArabic(
                                              textStyle:  TextStyle(
                                                color: Colors.white,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),),
                                          ],
                                        );
                                      })
                                ],
                              )

                            ],
                          ),
                        );
                      }
                    ),
                    
                    InkWell(
                      onTap: (){
                        AddItem item = AddItem();
                        item.categoryName = category;
                        item.itemName = name.text;
                        item.item_price = int.parse(price.text);
                        item.itemDesc = desc.text;
                        item.item_image= pic.path.value;
                        AddWorkOrAdsController.to.items.add(item);
                        // category != null ? AddWorkOrAdsController.to.categories[index!] =  controller.text :   AddWorkOrAdsController.to.categories.add(controller.text);
                        Navigator.pop(context);
                        // AuthConsumer().sendOtpCodeCivil(context, civilId, false, "forget");
                      },
                      child: Text(
                        "اضافة",
                        style: GoogleFonts.notoKufiArabic(
                          textStyle:  TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),),
                  ],
                ),
              ),
            ),
          );
        }
      )

    );
    showDialog(
        context: context,
        barrierColor: Colors.white.withOpacity(0.61),
        builder: (BuildContext context) => foodEnlargeDialog);
  }

  static verifyPhoneFailed(BuildContext context) {
    Dialog foodEnlargeDialog = Dialog(
      backgroundColor: AppColors().mainColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      //this right here
      child: Container(
        height: 130.0.h,
        width: 100.0.w,
        padding: EdgeInsets.all(8),
        // color:CustomColors.primaryColor:CustomColors.unselectedColor,

        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                " حدث خطأ غير متوقع يرجى \n التواصل معنا لحل المشكلة",
                style: GoogleFonts.notoKufiArabic(
                  textStyle:  TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 15.h,),

              InkWell(
                onTap: () async{
                  var url = Uri.parse('https://wa.me/message/USXSIMWMUFBOJ1');
                  if (await canLaunchUrl(url)) {
                  launchUrl(url,mode:LaunchMode.externalApplication);
                  }                  // AuthConsumer().sendOtpCodeCivil(context, civilId, false, "forget");
                },
                child: Text(
                  "تواصل الان",
                  style: GoogleFonts.notoKufiArabic(
                    textStyle:  TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),),
            ],
          ),
        ),
      ),
    );
    showDialog(
        context: context,
        barrierColor: Colors.white.withOpacity(0.61),
        builder: (BuildContext context) => foodEnlargeDialog);
  }
  static paymentFailed(BuildContext context) {
    Dialog foodEnlargeDialog = Dialog(
      backgroundColor: AppColors().mainColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      //this right here
      child: Container(
        height: 130.0.h,
        width: 100.0.w,
        padding: EdgeInsets.all(8),
        // color:CustomColors.primaryColor:CustomColors.unselectedColor,

        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "حدث خطأ في عملية الدفع",
                style: GoogleFonts.notoKufiArabic(
                  textStyle:  TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 15.h,),

              InkWell(
                onTap: () async{
                  Get.back();
                },
                child: Text(
                  "المحاولة مرة أخرى",
                  style: GoogleFonts.notoKufiArabic(
                    textStyle:  TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),),
            ],
          ),
        ),
      ),
    );
    showDialog(
        context: context,
        barrierColor: Colors.white.withOpacity(0.61),
        builder: (BuildContext context) => foodEnlargeDialog);
  }


  showBottomSheet(BuildContext context){
   return BaseBottomSheet(widget: Container(child: Text("Test"),), bottomSheetTitle: 'اضافة عنصر جديد',);
  }


 static Future<T?> showCupertinoDialog<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    String? barrierLabel,
    bool useRootNavigator = true,
    bool barrierDismissible = false,
    RouteSettings? routeSettings,
    Offset? anchorPoint,
  }) {

    return Navigator.of(context, rootNavigator: useRootNavigator).push<T>(CupertinoDialogRoute<T>(
      builder: builder,
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      barrierColor: CupertinoDynamicColor.resolve(kCupertinoModalBarrierColor, context),
      settings: routeSettings,
      anchorPoint: anchorPoint,
    ));
  }
  // Future<String> calculateAmountEUR(String amount) async {
  //   Uri uri = Uri.parse("https://api.exchangerate.host/latest?base=USD&amount=$amount&symbols=${AllSubscribtionsGetxController.to.selectedCurrency.value}");
  //   var response = await http.get(uri);
  //   if(response.statusCode == 200){
  //     // print(jsonDecode(response.body)['rates']['EUR']);
  //     return jsonDecode(response.body)['rates']['EUR'].toString();
  //   }
  //
  //   return "";
  //   // final calculatedAmout = (int.parse(amount)) * 100;
  //   // return calculatedAmout.toString();
  // }

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
}
