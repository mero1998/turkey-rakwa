import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakwa/Core/utils/extensions.dart';
import 'package:rakwa/api/api_controllers/classified_api_controller.dart';
import 'package:rakwa/app_colors/app_colors.dart';
import 'package:rakwa/screens/details_screen/details_classified_screen.dart';
import 'package:rakwa/screens/main_screens/btm_nav_screens/Ads/Widgets/all_ads_categories_widget.dart';
import 'package:rakwa/screens/main_screens/btm_nav_screens/Ads/Widgets/shimmer_loading_slider_home_widget.dart';
import 'package:rakwa/screens/main_screens/btm_nav_screens/Ads/Widgets/slider_card_ads.dart';
import 'package:rakwa/screens/main_screens/btm_nav_screens/Ads/Widgets/slider_nearest_ads_widget.dart';
import 'package:rakwa/screens/main_screens/btm_nav_screens/Ads/Widgets/slider_new_ads_wisget.dart';
import 'package:rakwa/screens/main_screens/btm_nav_screens/Ads/Widgets/slider_popular_ads_widget.dart';
import 'package:rakwa/screens/main_screens/btm_nav_screens/Home/Widgets/search_widget.dart';
import 'package:rakwa/screens/search_screens/search_screen.dart';
import 'package:rakwa/screens/view_all_classified_screens/view_all_classified_categories_screen.dart';
import 'package:rakwa/screens/view_all_classified_screens/view_all_classified_subcategories_screen.dart';
import 'package:rakwa/screens/view_all_classified_screens/view_all_latest_classified_screen.dart';
import 'package:rakwa/screens/view_all_classified_screens/view_all_paid_classified_screen.dart';
import 'package:rakwa/screens/view_all_classified_screens/view_all_popular_classified_screen.dart';
import 'package:rakwa/Core/utils/helpers.dart';
import 'package:rakwa/screens/view_all_classified_screens/view_all_nearest_classified_screen.dart';
import 'package:rakwa/widget/TitleWidgets/title_and_see_all_widget.dart';
import 'package:rakwa/widget/category_widget.dart';
import 'package:rakwa/widget/my_drawer.dart';
import 'package:rakwa/widget/my_text_field.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../../api/api_controllers/home_api_controller.dart';
import '../../../../../api/api_controllers/save_api_controller.dart';
import '../../../../../api/api_controllers/subscribtion_api_controller.dart';
import '../../../../../controller/all_sub_item_getx_controller.dart';
import '../../../../../controller/home_getx_controller.dart';
import '../../../../../model/all_categories_model.dart';
import '../../../../../model/classified_by_id_model.dart';
import '../../../../../model/paid_items_model.dart';
import '../../../../../widget/ads_widget.dart';
import '../../../../../widget/home_widget.dart';
import '../../../../../widget/video_play.dart';

import 'package:http/http.dart' as http;

class AdsScreen extends StatefulWidget {
  const AdsScreen({super.key});

  @override
  State<AdsScreen> createState() => _AdsScreenState();
}

class _AdsScreenState extends State<AdsScreen> {
  String? videoId;
  // final Set<Marker> _marker = {};
  AllSubItemGetxController allItemGetxController =
  Get.put(AllSubItemGetxController());
  VideoPlayerController? videoPlayerController;

  YoutubePlayerController? _controller;

  getIsp() async{
    var response  = await http.get(Uri.parse("https://api.ipify.org",),headers: {
      "accept" : "application/json"
    });


    print("IP::: ${response.statusCode}");
    print("IP::: ${response}");
    print("IP::: ${response.body}");
    getLocationFromIp(response.body);
  }

  getLocationFromIp(String ip) async{
    var response  = await http.get(Uri.parse("http://ip-api.com/json/${ip}"));

    print("Location::: ${jsonDecode(response.body)['regionName']}");

    await HomeGetxController.to.getAds(state: jsonDecode(response.body)['regionName'].toString());

    // await allItemGetxController.getAds(state: jsonDecode(response.body)['regionName'].toString(),
    //     categoryId: widget.id.toString());
    // if(HomeGetxController.to.ads.isNotEmpty){
    //   print("we are here");
    //   if(HomeGetxController.to.ads.first.type == "1"){
    //     videoPlayerController!.setLooping(true);
    //
    //     videoPlayerController = VideoPlayerController.networkUrl(
    //         Uri.parse("${HomeGetxController.to.ads.first.image}"))..initialize().then((_) {
    //       setState(() {
    //         print("after init");
    //       });
    //
    //       videoPlayerController!.play();
    //     });
    //   }
    //
    // }
    // allItemGetxController.getPopupAds(context,state: jsonDecode(response.body)['regionName'].toString(), categoryId: widget.id.toString());


    if(allItemGetxController.ads.isNotEmpty){

      if(allItemGetxController.ads.first.type == "1"){
        videoId = YoutubePlayer.convertUrlToId(allItemGetxController.ads.first.image ?? "");
        // print("ID::: ${videoId}");
        if(videoId != null){
          _controller =  YoutubePlayerController(
              initialVideoId: videoId!,
              flags: const YoutubePlayerFlags(autoPlay: false, loop: false)

          );
        }
      }

    }

    // if(HomeGetxController.to.popups.isNotEmpty){
    //   // if(HomeGetxController.to.popups.first.type == "1"){
    //   //   videoPlayerController = VideoPlayerController.networkUrl(
    //   //       Uri.parse("https://www.rakwa.com/laravel_project/public/storage/item/${HomeGetxController.to.popups.first.image}"))..initialize().then((_) {
    //   //     setState(() {
    //   //
    //   //     });
    //   //
    //   //     videoPlayerController!.play();
    //   //   });
    //
    //   // }
    // }

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Get.put(HomeGetxController());

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{

      await getIsp();

    });
    if(allItemGetxController.ads.isNotEmpty){

      if(allItemGetxController.ads.first.type == "1"){
        videoId = YoutubePlayer.convertUrlToId(allItemGetxController.ads.first.image ?? "");
        // print("ID::: ${videoId}");
        if(videoId != null){
          _controller =  YoutubePlayerController(
              initialVideoId: videoId!,
              flags: const YoutubePlayerFlags(autoPlay: false, loop: false)

          );
        }
      }

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          children: [
            30.ESH(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SearchWidget(isItem: false),
            ),
            24.ESH(),
            TitleAndSeeAllWidget(
              title: "التصنيفات",
              onSeeAllTap: () {
                Get.to(() => const ViewAllClassififedCategoriesScreen());
              },
            ),
            const AllAdsCategoriesWidget(),
            24.ESH(),
            // Container(
            //   color: Colors.grey.shade400,
            //   width: double.infinity,
            //   height: 120.h,
            //   alignment: AlignmentDirectional.center,
            //   child: Text("مساحة اعلانية",style: TextStyle(
            //       color: Colors.white,
            //       fontWeight: FontWeight.bold,
            //       fontSize: 20.sp
            //   ),),
            // ),
            GetX<HomeGetxController>(builder: (c){
             print(c.ads.length);
             return c.isLoading.value ? Shimmer.fromColors(
             baseColor: Colors.grey.shade100,
             highlightColor: Colors.grey.shade300,
             child: Container(
             margin: const EdgeInsets.only(left: 8),
             height: 120.h,
             width: Get.width * 0.9,
             decoration: BoxDecoration(
             borderRadius: BorderRadius.circular(12),
             color: Colors.white,
             ),
             ) ) :
             c.ads.isNotEmpty ? Column(
             children: [
             SizedBox(height: 10.h,),
             Row(
             children: [
             Icon(Icons.laptop_chromebook, color: Colors.blue,size: 16,),
             SizedBox(width: 10.w,),
             InkWell(
             onTap: ()async{
             // if(controller.ads.first.url != null){
             String url = c.ads.first.url ?? "";
             if (await canLaunchUrl(Uri.parse(url))) {
             try{
             launchUrl(Uri.parse(url),mode:LaunchMode.externalApplication);

             }catch(e){
             print(e);
             }
             // .then((value) => SubscriptionApiController().clickAd(adId: controller.ads.first.id.toString()));
             }else{
             print("Not able");
             }
             // }

             },
             child: Text("زيارة موقع الويب",style: GoogleFonts.notoKufiArabic(
             textStyle:
             TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w400)),)),
             ],
             ),
             Container(
             color: Colors.white,
             width: double.infinity,
             height: 120.h,
             margin: EdgeInsets.only(top: 24.h),
             alignment: AlignmentDirectional.center,
             child:
             c.ads.first.type == "0" ?
             InkWell(
             onTap: ()async{
             print(c.ads.first.url);
             // if(controller.ads.first.url != null){
             String url = c.ads.first.url ?? "";
             // if (await canLaunchUrl(Uri.parse(url))) {
             launchUrl(Uri.parse(url),mode:LaunchMode.externalApplication).then((value) => SubscriptionApiController().clickAd(adId: c.ads.first.id.toString()));
             // }
             // }

             },
             child: Image.network("https://www.rakwa.com/laravel_project/public/storage/item/${c.ads.first.image}",fit: BoxFit.cover, width: double.infinity,height: double.infinity,)) :
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
             allItemGetxController.ads.first.image!.contains("youtube") || c.ads.first.image!.contains("youtu.be") ? YoutubePlayer(controller: _controller!) : VideoPlay(url: "${c.ads.first.image}",),
             ),
             ],
             ) : Container();
             }),
            24.ESH(),

            TitleAndSeeAllWidget(
              title: "الاقرب اليك",
              onSeeAllTap: () {
                Get.to(() => const ViewAllNearestClassifiedScreen());
              },
            ),
            12.ESH(),
            const SliderNearestAdsWidget(),
            24.ESH(),
            TitleAndSeeAllWidget(
              title: "الأشهر",
              onSeeAllTap: () {
                Get.to(() => const ViewAllPopularClassifiedScreen());
              },
            ),
            12.ESH(),
            const SliderPopularAdsWidget(),
            24.ESH(),
            TitleAndSeeAllWidget(
              title: "الأحدث",
              onSeeAllTap: () {
                Get.to(() => const ViewAllLatestClassifiedScreen());
              },
            ),
            12.ESH(),
            const SliderNewAdsWidget(),
            12.ESH(),

            // Container(
            //   color: Colors.grey.shade400,
            //   width: double.infinity,
            //   height: 120.h,
            //   alignment: AlignmentDirectional.center,
            //   child: Text("مساحة اعلانية",style: TextStyle(
            //       color: Colors.white,
            //       fontWeight: FontWeight.bold,
            //       fontSize: 20.sp
            //   ),),
            // ),
            12.ESH(),


          ],
        ),
    );
  }
}

Future<void> saveItem({required String id}) async {
  bool status = await SaveApiController().saveClassified(classifiedId: id);
  if (status) {
    ShowMySnakbar(
        title: 'تم العملية بنجاح',
        message: 'تم حفظ العنصر بنجاح',
        backgroundColor: Colors.green.shade700);
  } else {
    ShowMySnakbar(
        title: 'خطأ',
        message: 'حدث خطأ ما',
        backgroundColor: Colors.red.shade700);
  }
}

//TODO: MyAds Screen
