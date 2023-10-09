import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:ensure_visible_when_focused/ensure_visible_when_focused.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rakwa/Core/utils/extensions.dart';
import 'package:rakwa/api/api_controllers/ads_api_controller.dart';
import 'package:rakwa/api/api_controllers/subscribtion_api_controller.dart';
import 'package:rakwa/controller/all_ads_getx_controller.dart';
import 'package:rakwa/controller/all_subscribtions_getx_controller.dart';
import 'package:rakwa/controller/search_item_controller.dart';
import 'package:rakwa/screens/ads/update_ad_screen.dart';
import 'package:rakwa/widget/app_dialog.dart';
import 'package:rakwa/widget/appbars/app_bars.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../app_colors/app_colors.dart';
import '../../controller/image_picker_controller.dart';
import '../../controller/list_controller.dart';
import '../../model/user_ads.dart';
import '../../shared_preferences/shared_preferences.dart';
import '../../widget/ButtomSheets/base_bottom_sheet.dart';
import '../../widget/ButtomSheets/row_select_item.dart';
import '../../widget/TextFields/text_field_default.dart';
import '../../widget/TextFields/validator.dart';
import '../../widget/main_elevated_button.dart';
import '../../widget/video_play.dart';
import '../add_listing_screens/Widget/bottom_sheet_state.dart';

class UserAdsDetailsScreen extends StatefulWidget {
  UserAds ads;
   UserAdsDetailsScreen({required this.ads});

  @override
  State<UserAdsDetailsScreen> createState() => _UserAdsDetailsScreenState();
}

class _UserAdsDetailsScreenState extends State<UserAdsDetailsScreen> {


  YoutubePlayerController? _controller;
  String? videoId;
  final GlobalKey webViewKey = GlobalKey();


  PullToRefreshController? pullToRefreshController;

  InAppWebViewController? webViewController;
  // VideoPlayerController _videoPlayerController = VideoPlayerController.networkUrl(
  //  Uri.parse("https://www.facebook.com/watch/?v=570624101946205") ,
  // );
  ChewieController? _chewieController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // _chewieController = ChewieController(
    //   videoPlayerController: _videoPlayerController,
    //   autoPlay: true,  // Optional, set to true if you want the video to play automatically
    //   looping: true,   // Optional, set to true if you want the video to loop
    // );
    Get.put(AllSubscribtionsGetxController());
    AllAdsGetxController.to.statusAd.value = widget.ads.enabled ?? -1;
    AllSubscribtionsGetxController.to.adID.value = widget.ads.id.toString();
    if(widget.ads.type == "1"){
      videoId = YoutubePlayer.convertUrlToId(widget.ads.image ?? "");
      // print("ID::: ${videoId}");
      if(videoId != null){
        _controller =  YoutubePlayerController(
            initialVideoId: videoId!,
            flags: const YoutubePlayerFlags(autoPlay: false, loop: false)

        );
      }
      //

    }
  }
  @override
  Widget build(BuildContext context) {
  print(widget.ads.id);
    return GetX<AllAdsGetxController>(
      builder: (co) {
        print(co.statusAd.value);
        return Scaffold(
          appBar: AppBars.appBarDefault(title: widget.ads.subscription!.name ?? "", secondIconImage: Visibility(
            visible: co.statusAd.value == 1 || co.statusAd.value == 2 ||  co.statusAd.value == 4,
            child: IconButton(onPressed: (){
              Get.to(UpdateAdScreen(ads: widget.ads));
            }, icon: Icon(Icons.edit)),
          )),
          body: ListView(
            padding: EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Text(" تصنيف الاعلان: ",
                    style: GoogleFonts.notoKufiArabic(
                      textStyle: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.black,
                      ),),),
                  Text(widget.ads.subscription!.name ?? "",
                    style: GoogleFonts.notoKufiArabic(
                      textStyle: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),),),
                ],

              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(" وصف الاعلان: ",
                    style: GoogleFonts.notoKufiArabic(
                      textStyle: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.black,
                      ),),),
                  Expanded(
                    child: Text(widget.ads.subscription!.description ?? "",
                      style: GoogleFonts.notoKufiArabic(
                        textStyle: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),),),
                  ),
                ],

              ),

              //0 بحتاج موافقة من الادمن
              // 1 فعال
              // 2 معطل من المستخدم بقدر يفعله او يوقفه
              // 3 منتهي بقدري المستخدم يعمل اعادة تفعيل
              GetX<AllAdsGetxController>(
                builder: (c) {
                  return Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(" حالة الاعلان: ",
                            style: GoogleFonts.notoKufiArabic(
                              textStyle: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.black,
                              ),),),
                          Text(c.statusAd.value == 0 ? 'قيد المراجعة' : c.statusAd.value== 1 ? "فعال" : c.statusAd.value == 2 ? "تم ايقافه من طرفك": c.statusAd.value == 4 ? "مرفوض" : "مكتمل",
                            style: GoogleFonts.notoKufiArabic(
                              textStyle: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),),),

                          // SizedBox(width: 10.w,),
                          Container(
                            width: 10.w,
                            height: 10.h,
                            margin: EdgeInsetsDirectional.only(start: 5.w),
                            decoration: BoxDecoration(
                                color: c.statusAd.value == 0 ? Colors.orange : c.statusAd.value== 1 ? Colors.green :c.statusAd.value== 2 ? Colors.grey: Colors.red,
                                shape: BoxShape.circle
                            ),
                          ),
                        ],
                      ),

                      Visibility(
                        visible: c.statusAd.value != 0,
                        child: Visibility(
                          visible: c.statusAd.value != 4,
                          child: Row(
                            children: [
                              MainElevatedButton(child:   Text(c.statusAd.value== 1 ? "ايقاف" :c.statusAd.value == 2 ? "استئناف": "اعادة الترويج",
        style: GoogleFonts.notoKufiArabic(
        textStyle: TextStyle(
        fontSize: 12.sp,
        color: Colors.white,
        ),),), height: 40, width: 120, borderRadius: 4, onPressed: ()async{

                                if(c.statusAd.value== 1){
                               await c.updateStatus(adId: widget.ads.id.toString(), enabled: "2");

                                }else if(c.statusAd.value== 2){
                               await   c.updateStatus(adId: widget.ads.id.toString(), enabled: "1");

                                }else{
                                  AppDialog().rePromotionAd(context, adId: widget.ads.id.toString());
                                }


                                print("Enabled::: ${c.statusAd.value}");

                              },backgroundColor: c.statusAd.value== 1 ?Colors.red : c.statusAd.value == 2 ? Colors.green: Colors.blue,)
                            ],
                          ),
                        ),
                      )
                    ],

                  );
                }
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(" نتائج الاعلان: ",
                    style: GoogleFonts.notoKufiArabic(
                      textStyle: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.black,
                      ),),),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text("مشاهدات ",
                            style: GoogleFonts.notoKufiArabic(
                              textStyle: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.black,
                              ),),),
                          Text(widget.ads.views ==0 ? "لا يوجد مشاهدات" :widget.ads.views.toString() ?? "",
                            style: GoogleFonts.notoKufiArabic(
                              textStyle: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),),),
                        ],
                      ),
                      Row(children: [
                        Text("نقرات ",
                          style: GoogleFonts.notoKufiArabic(
                            textStyle: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.black,
                            ),),),
                        Text(widget.ads.clicks ==0 ? "لا يوجد نقرات" :widget.ads.clicks.toString() ?? "",
                          style: GoogleFonts.notoKufiArabic(
                            textStyle: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),),),
                      ],
                      )
                    ],
                  )

                ],

              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(" صورة الاعلان: ",
                    style: GoogleFonts.notoKufiArabic(
                      textStyle: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.black,
                      ),),),
                widget.ads.type == "0" ?
                Expanded(child: Image.network("https://www.rakwa.com/laravel_project/public/storage/item/${widget.ads.image}",fit: BoxFit.cover, width: 170.w, height: 170.h,))
                    : widget.ads.image!.contains("youtube") ||  widget.ads.image!.contains("youtu.be") ? Expanded(child: YoutubePlayer(controller:  _controller!)) :
                    // : widget.ads.image!.contains("tiktok")  || widget.ads.image!.contains("facebook") || widget.ads.image!.contains("instagram")?

        //         Expanded(
        //           child: SizedBox(
        //               height: 300.h,
        //
        //               child:
        //               // InAppWebView(initialUrlRequest: URLRequest(url: Uri.parse("https://www.facebook.com/RakwaTurkey/videos/570624101946205"))
        //               // )
        //               InAppWebView(
        //                 key: webViewKey,
        //                 initialUrlRequest:
        //                 URLRequest(url: Uri.parse('https://www.facebook.com/RakwaTurkey/videos/570624101946205')),
        //                 // initialUrlRequest:
        //                 // URLRequest(url: WebUri(Uri.base.toString().replaceFirst("/#/", "/") + 'page.html')),
        //                 // initialFile: "assets/index.html",
        //                 initialUserScripts: UnmodifiableListView<UserScript>([]),
        //                 // contextMenu: contextMenu,
        //                 // pullToRefreshController: pullToRefreshController,
        //                 onWebViewCreated: (controller) async {
        //                   webViewController = controller;
        //                 },
        //                 // onLoadStart: (controller, url) async {
        //                 //   setState(() {
        //                 //     this.url = url.toString();
        //                 //     urlController.text = this.url;
        //                 //   });
        //                 // },
        //
        //                 shouldOverrideUrlLoading:
        //                     (controller, navigationAction) async {
        //                   var uri = navigationAction.request.url!;
        //
        //                   if (![
        //                     "http",
        //                     "https",
        //                     "file",
        //                     "chrome",
        //                     "data",
        //                     "javascript",
        //                     "about"
        //                   ].contains(uri.scheme)) {
        //                     if (await canLaunchUrl(uri)) {
        //                       // Launch the App
        //                       await launchUrl(
        //                         uri,
        //                       );
        //                       // and cancel the request
        //                       return NavigationActionPolicy.CANCEL;
        //                     }
        //                   }
        //
        //                   return NavigationActionPolicy.ALLOW;
        //                 },
        //                 onConsoleMessage: (controller, consoleMessage) {
        //                   print(consoleMessage);
        //                 },
        //               )
        // ),
        //         ) :
        //         Expanded(
        //           child: SizedBox(
        //             height: 150.h,
        //             child: Chewie(
        //               controller: _chewieController!,
        //             ),
        //           ),
        //         ) :
                Expanded(child: VideoPlay(url: "${widget.ads.image}",)) ,
                ],

              ),

              Row(
                children: [
                  Text(" موقع الاعلان: ",
                    style: GoogleFonts.notoKufiArabic(
                      textStyle: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.black,
                      ),),),
                  Expanded(
                    child: Text(widget.ads.states!.map((e) => e.stateName).toList().toString().replaceAll("[", "").replaceAll("]", ""),
                      style: GoogleFonts.notoKufiArabic(
                        textStyle: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),),),
                  ),
                ],

              ),


              widget.ads.allCategoriessmartads!.isNotEmpty ?   Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(" مواضع الاعلان: ",
                    style: GoogleFonts.notoKufiArabic(
                      textStyle: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.black,
                      ),),),

                      Expanded(
                        child: Text(widget.ads.allCategoriessmartads!.isNotEmpty ? widget.ads.allCategoriessmartads!.map((e) => e.categoryName).toList().toString().replaceAll("[", "").replaceAll("]", "") : "",
                    style: GoogleFonts.notoKufiArabic(
                        textStyle: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,

                          color: Colors.black,
                        ),),),
                      ),
                ],

              ) : Container(),

              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Text("الانفاقات: ",
              //       style: GoogleFonts.notoKufiArabic(
              //         textStyle: TextStyle(
              //           fontSize: 12.sp,
              //           color: Colors.black,
              //         ),),),
              //     Padding(
              //       padding:  EdgeInsets.symmetric(horizontal: 25.w),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Align(
              //             alignment: AlignmentDirectional.topStart,
              //             child: Text("في هذا الاعلان سوف تحصل على: ",
              //               style: GoogleFonts.notoKufiArabic(
              //                 textStyle: TextStyle(
              //                   fontSize: 12.sp,
              //                   color: Colors.black,
              //                 ),),),
              //           ),
              //           widget.ads.clicks != null ?    Row(
              //             children: [
              //               Text(" ${ widget.ads.clicks.toString()} نقرة" ?? "",
              //                 style: GoogleFonts.notoKufiArabic(
              //                   textStyle: TextStyle(
              //                     fontSize: 12.sp,
              //                     color: Colors.black,
              //                   ),),),
              //
              //               Text(" بتكلفة ${ widget.ads.subscription!.priceClicks.toString()} ليرة " ?? "",
              //                 style: GoogleFonts.notoKufiArabic(
              //                   textStyle: TextStyle(
              //                     fontSize: 12.sp,
              //                     color: Colors.black,
              //                   ),),),
              //             ],
              //           ) : Container(),
              //           widget.ads.views != null ?    Row(
              //             children: [
              //               Text(" ${ widget.ads.views.toString()} مشاهدة"?? "",
              //                 style: GoogleFonts.notoKufiArabic(
              //                   textStyle: TextStyle(
              //                     fontSize: 12.sp,
              //                     color: Colors.black,
              //                   ),),),
              //
              //               Text(" بتكلفة ${ widget.ads.subscription!.priceViews.toString()} ليرة " ?? "",
              //                 style: GoogleFonts.notoKufiArabic(
              //                   textStyle: TextStyle(
              //                     fontSize: 12.sp,
              //                     color: Colors.black,
              //                   ),),),
              //             ],
              //           ) : Container(),
              //
              //           Align(
              //             alignment: AlignmentDirectional.bottomEnd,
              //             child: Text(" المجموع ${widget.ads.subscription!.total.toString()} ليرة " ?? "",
              //               style: GoogleFonts.notoKufiArabic(
              //                 textStyle: TextStyle(
              //                   fontSize: 12.sp,
              //                   color: Colors.black,
              //                 ),),),
              //           ),
              //         ],
              //       ),
              //     )
              //
              //   ],
              // )
            ],
          ),
        );
      }
    );
  }


}
