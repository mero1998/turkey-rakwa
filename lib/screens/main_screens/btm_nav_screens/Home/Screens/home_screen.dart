import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rakwa/Core/utils/extensions.dart';
import 'package:rakwa/Core/utils/helpers.dart';
import 'package:rakwa/api/api_controllers/order_api_controller.dart';
import 'package:rakwa/api/api_controllers/subscribtion_api_controller.dart';
import 'package:rakwa/controller/app_interface_getx_controller.dart';
import 'package:rakwa/screens/main_screens/btm_nav_screens/Ads/Widgets/list-popular_ads_widget.dart';
import 'package:rakwa/screens/main_screens/btm_nav_screens/Home/Screens/order_now_categories.dart';
import 'package:rakwa/screens/main_screens/btm_nav_screens/Home/Widgets/card_add_work.dart';
import 'package:rakwa/screens/main_screens/btm_nav_screens/Home/Widgets/home_lists/list_blog_widget.dart';
import 'package:rakwa/screens/main_screens/btm_nav_screens/Home/Widgets/home_lists/list_nearest_items.dart';
import 'package:rakwa/screens/main_screens/btm_nav_screens/Home/Widgets/home_lists/list_popular_items.dart';
import 'package:rakwa/screens/main_screens/btm_nav_screens/Home/Widgets/home_lists/list_res.dart';
import 'package:rakwa/screens/main_screens/btm_nav_screens/Home/Widgets/home_lists/list_special_items.dart';
import 'package:rakwa/screens/main_screens/btm_nav_screens/Home/Widgets/home_lists/lsit_new_items.dart';
import 'package:rakwa/screens/main_screens/btm_nav_screens/Home/Widgets/home_sliver_app_bar.dart';
import 'package:rakwa/screens/main_screens/btm_nav_screens/Home/Widgets/slider_home_categories.dart';
import 'package:rakwa/screens/view_all_classified_screens/view_all_paid_classified_screen.dart';
import 'package:rakwa/screens/view_all_item_screens/view_all_latest_item_screen.dart';
import 'package:rakwa/screens/view_all_item_screens/view_all_nearest_item_screen.dart';
import 'package:rakwa/screens/view_all_item_screens/view_all_paid_item_screen.dart';
import 'package:rakwa/screens/view_all_item_screens/view_all_popular_item_screen.dart';
import 'package:rakwa/screens/view_all_item_screens/view_all_res_screen.dart';
import 'package:rakwa/shared_preferences/shared_preferences.dart';
import 'package:rakwa/widget/TitleWidgets/title_and_see_all_widget.dart';
import 'package:rakwa/widget/app_dialog.dart';
import 'package:rakwa/widget/video_play.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../../Core/services/geolocation_services.dart';
import '../../../../../api/api_controllers/home_api_controller.dart';
import '../../../../../app_colors/app_colors.dart';
import '../../../../../controller/all_last_activites_getx_controller.dart';
import '../../../../../controller/home_getx_controller.dart';
import '../../../../all_last_activities/all_last_activities_screen.dart';
import '../../../../details_screen/details_screen.dart';
import 'package:http/http.dart' as http;

import '../Widgets/shimmer_card_home_loading.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // VideoPlayerController? _controller;
  // Future<void>? _initializeVideoPlayerFuture;
  // VideoPlayerController? videoPlayerController;
  YoutubePlayerController? _controller;
  String? videoId;

  @override
  void initState() {
    // TODO: implement initState
    // _controller = VideoPlayerController.networkUrl(
    //     Uri.parse('https://www.youtube.com/watch?v=Nz-XWAwvTUM'));
    // _initializeVideoPlayerFuture = _controller!.initialize();
    // _controller!.setLooping(true);
    // _controller!.setVolume(1.0);
    // // try{
    // //   videoPlayerController =  VideoPlayerController.networkUrl(
    // //       Uri.parse("https://www.youtube.com/watch?v=Nz-XWAwvTUM"))..initialize().then((_) {
    // //     setState(() {
    // //
    // //     });
    // //
    // //     videoPlayerController!.play();
    // //   });
    // // }catch(e){
    // //   print("Error: $e");
    // // }

    HomeGetxController.to.isLoading.value = true;


  Get.put(HomeGetxController());

  WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
    // if(HomeGetxController.to.ads.first.type == "1"){
    //   print(HomeGetxController.to.ads.first.image);

    // }

     await getIsp();






  });


  // if(SharedPrefController().isLogined){
  //   OrderApiController().checkVerifiyPhone(context);
  // }
    super.initState();

  }



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
    HomeGetxController.to.getPopupAds(context,state: jsonDecode(response.body)['regionName'].toString());



    if(HomeGetxController.to.ads.isNotEmpty){

      if(HomeGetxController.to.ads.first.type == "1"){
        videoId = YoutubePlayer.convertUrlToId(HomeGetxController.to.ads.first.image ?? "");
        // print("ID::: ${videoId}");
        if(videoId != null){
          _controller =  YoutubePlayerController(
              initialVideoId: videoId!,
              flags: const YoutubePlayerFlags(autoPlay: false, loop: false)

          );
        }
      }

    }



    if(HomeGetxController.to.popups.isNotEmpty){
      // if(HomeGetxController.to.popups.first.type == "1"){
      //   videoPlayerController = VideoPlayerController.networkUrl(
      //       Uri.parse("https://www.rakwa.com/laravel_project/public/storage/item/${HomeGetxController.to.popups.first.image}"))..initialize().then((_) {
      //     setState(() {
      //
      //     });
      //
      //     videoPlayerController!.play();
      //   });

      // }
    }

  }

  @override
  Widget build(BuildContext context) {


    var box = GetStorage();
    print("ID:::${box.read("id")}");
    return Scaffold(
      body: CustomScrollView(
          physics: BouncingScrollPhysics(),
        slivers: [
          CupertinoSliverRefreshControl(

            onRefresh: () async{
              HomeGetxController.to.getRes();
              HomeGetxController.to.getNestedItems();
              HomeGetxController.to.getPaidItems();
              HomeGetxController.to.getPopularItems();
              HomeGetxController.to.getLatestItems();
              HomeGetxController.to.getPopularClassified();
              HomeGetxController.to.getArticales();
              HomeGetxController.to.getActivities();
              AppInterfaceGetx.to.getRemoteConfig();
              return Future.value(true);
            },

          ),
          HomeSliverAppBar(),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                GetX<HomeGetxController>(
                  builder: (controller) {
                    return controller.configs.isNotEmpty ? Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                          children: [

                            SizedBox(height: 10.h,),
                            // controller.ads.isNotEmpty ?
                      controller.isLoading.value ? const ShimmerCardHomeLoading()  :
                      controller.ads.isNotEmpty ?    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.laptop_chromebook, color: Colors.blue,size: 16,),
SizedBox(width: 10.w,),
                              InkWell(
                                  onTap: ()async{
                                    // if(controller.ads.first.url != null){
                                    String url = controller.ads.first.url ?? "";
                                    if (await canLaunchUrl(Uri.parse(url))) {
                                      try{
                                        launchUrl(Uri.parse(url),mode:LaunchMode.externalApplication).then((value) => SubscriptionApiController().clickAd(adId: controller.ads.first.id.toString()));

                                      }catch(e){
                                        print(e);
                                      }
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
                                  margin: EdgeInsets.only(top: 15.h),
                                  alignment: AlignmentDirectional.center,
                                  child:
                              controller.ads.first.type == "0" ?
                                  InkWell(
                                      onTap: ()async{
                                        // if(controller.ads.first.url != null){
                                          String url = controller.ads.first.url ?? "";
                                          if (await canLaunchUrl(Uri.parse(url))) {
                                        try{
                                          launchUrl(Uri.parse(url),mode:LaunchMode.externalApplication)
                                           .then((value) => SubscriptionApiController().clickAd(adId: controller.ads.first.id.toString()));
                                              ;

                                        }catch(e){
                                          print(e);
                                        }
                                          }else{
                                            print("Not able");
                                          }
                                        // }

                                      },
                                      child: Image.network("https://www.rakwa.com/laravel_project/public/storage/item/${controller.ads.first.image}",fit: BoxFit.cover, width: double.infinity,height: double.infinity,)) :
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
                                  controller.ads.first.image!.contains("youtube") ||  controller.ads.first.image!.contains("youtu.be") ? YoutubePlayer(controller:  _controller!) :   VideoPlay(url: "${controller.ads.first.image}",)

                                ),
                        ],
                      ) : Container(),
                                // : Container(),
                            // 24.ESH(),
                             CardAddWork(),
                            // const CardAddWork(),

                            // ElevatedButton(onPressed: ()async{
                            //
                            //  await getIsp();
                            //  // await getLocationFromIp();
                            // }, child: Text("test")),
                            15.ESH(),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SliderHomeCategories(),

                                10.ESH(),
                                Image.asset("images/home-banner.jpeg"),
                                Column(
                                  children: [
                                    15.ESH(),
                                    TitleAndSeeAllWidget(
                                      title: 'اطلب الآن',
                                      avalibleSeeAll: true,
                                      onSeeAllTap: () {
                                        Get.to(() => OrderNowCategoriesScreen());
                                      },
                                    ),
                                    12.ESH(),
                                    const Resturants(),
                                  ],
                                ),
                                Visibility(
                                  visible: controller.configs.first.data!.hideItemNumberNearby == "no",
                                  child: Column(
                                    children: [
                                      15.ESH(),
                                      TitleAndSeeAllWidget(
                                        title: 'الاعمال الاقرب اليك',
                                        avalibleSeeAll: false,
                                        // onSeeAllTap: () {
                                        //   Get.to(() => const ViewAllNearestItemScreen());
                                        // },
                                      ),
                                      12.ESH(),
                                      const NearestItems(),
                                      Visibility(
                                          visible: controller.configs.first.data!.advertisingCode1 != null,
                                          child: VideoWidget(url: controller.configs.first.data!.advertisingCode1 ?? "", play: false))
                                    ],
                                  ),
                                ),

                                Visibility(
                                  visible: controller.configs.first.data!.hideItemNumberPaid == "no",
                                  child: Column(
                                    children: [
                                      24.ESH(),
                                      TitleAndSeeAllWidget(
                                        title: 'العناصر المميزة',
                                        onSeeAllTap: () {
                                          Get.to(() => const ViewAllPaidItemScreen());
                                        },
                                      ),
                                      12.ESH(),
                                      const SpecialItems(),
                                      Visibility(
                                          visible: controller.configs.first.data!.advertisingCode2 != null,
                                          child: VideoWidget(url: controller.configs.first.data!.advertisingCode2 ?? "", play: false))

                                    ],
                                  ),
                                ),


                                Visibility(
                                  visible: controller.configs.first.data!.hideItemNumberPopular == "no",
                                  child: Column(
                                    children: [
                                      24.ESH(),
                                      TitleAndSeeAllWidget(
                                          title: 'الأشهر',
                                          onSeeAllTap: () {
                                            Get.to(
                                                    () => const ViewAllPopularItemScreen());
                                          }),
                                      12.ESH(),
                                      const PopularItems(),
                                      Visibility(
                                          visible: controller.configs.first.data!.advertisingCode3 != null,

                                          child: VideoWidget(url: controller.configs.first.data!.advertisingCode3 ?? "", play: false))

                                    ],
                                  ),
                                ),

                                Visibility(
                                 visible: controller.configs.first.data!.hideItemNumberLatest == "no",
                                  child: Column(
                                    children: [
                                      24.ESH(),
                                      TitleAndSeeAllWidget(
                                        title: 'الأحدث',
                                        onSeeAllTap: () {
                                          Get.to(() => const ViewAllLatestItemScreen());
                                        },
                                      ),
                                      12.ESH(),
                                      const NewItems(),
                                      Visibility(
                                                 visible: controller.configs.first.data!.advertisingCode4 != null,
                                          child: VideoWidget(url: controller.configs.first.data!.advertisingCode4 ?? "", play: false))

                                    ],
                                  ),
                                ),

                                TitleAndSeeAllWidget(
                                  title: 'أخر الأنشطة',
                                  onSeeAllTap: () {
                                    Get.to(() => const AllLastActivtiesScreen());
                                  },
                                ),
                                controller.isLoading.value ? SizedBox(
                                  height: 160.h,
                                  child: Shimmer.fromColors(
                                      baseColor: Colors.grey.shade100,
                                      highlightColor: Colors.grey.shade300,
                                      child: ListView.separated(
                                        padding: EdgeInsets.zero,
                                        separatorBuilder: (context, index) {
                                          return const SizedBox(
                                            height: 12,
                                          );
                                        },
                                        itemCount: 9,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            margin: const EdgeInsets.only(left: 8),
                                            height: 153.h,
                                            width: Get.width * 0.9,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(12),
                                              color: Colors.white,
                                            ),
                                          );
                                        },
                                      )),
                                ) :
                                controller.activities.isNotEmpty ?
                                SizedBox(
                                  height: 160.h,
                                  // width: 150,
                                  child: AnimationLimiter(
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      padding: EdgeInsets.all(16),
                                      shrinkWrap: true,
                                      // physics: ScrollPhysics(),
                                      physics: const BouncingScrollPhysics(),
                                      separatorBuilder: (context, index) {
                                        return  SizedBox(
                                          height: 24.h,
                                        );
                                      },

                                      itemCount: controller.activities.length,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: (){
                                            Get.to(
                                                DetailsScreen(id: controller.activities[index].itemId ?? "")
                                            );
                                          },
                                          child: Container(
                                            width: 250.w,
                                            margin: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                                color:     controller.activities[index].commentId != null ?
                                                AppColors.blueLightColor : AppColors.discountColor
                                            ),
                                            padding: EdgeInsets.all(8),
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Wrap(
                                                          children: [
                                                            controller.activities[index].commentId != null ?
                                                            Icon(Icons.comment,color: AppColors().mainColor,)
                                                                :                            Icon(Icons.star,color: AppColors().mainColor,),


                                                            Text(" قام ", style: GoogleFonts.notoKufiArabic(
                                                              textStyle: const TextStyle(
                                                                color: Colors.black,
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w600,
                                                              ),)),
                                                            Text(controller.activities[index].user!.name ?? "", style: GoogleFonts.notoKufiArabic(
                                                              textStyle: const TextStyle(
                                                                color: Colors.black,
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.bold,
                                                              ),)),
                                                            Text("${controller.activities[index].commentId != null ? ' بالتعليق على ' : ' بالتقييم على '}", style: GoogleFonts.notoKufiArabic(
                                                              textStyle: const TextStyle(
                                                                color: Colors.black,
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w600,
                                                              ),)),
                                                            Text(controller.activities[index].item!.itemTitle ?? "", style: GoogleFonts.notoKufiArabic(
                                                              textStyle: const TextStyle(
                                                                color: Colors.black,
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w600,
                                                              ),)),
                                                            SizedBox(width: 5.w,),

                                                            Text("${controller.activities[index].commentId != null ? '' : 'ب  ${controller.activities[index].ratingReview ?? ""} نجوم'}", style: GoogleFonts.notoKufiArabic(
                                                              textStyle: const TextStyle(
                                                                color: Colors.black,
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w600,
                                                              ),)),

                                                          ],
                                                        ),
                                                      )

                                                    ],

                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                )
                                    : const Text('لا توجد أنشطة'),
                                Visibility(
                                  visible: controller.configs.first.data!.hideClassifiedNumberPopular == "no",
                                  child: Column(
                                    children: [
                                      24.ESH(),
                                      TitleAndSeeAllWidget(
                                        title: 'الاعلانات',
                                        onSeeAllTap: () {
                                          Get.to(() => const ViewAllPaidClassifiedScreen());
                                        },
                                      ),
                                      12.ESH(),
                                      const ListPopularAdsWidget(),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  // visible: controller.configs.first.data!.bl == "no",
                                  child: Column(
                                    children: [
                                      24.ESH(),
                                      const TitleAndSeeAllWidget(
                                        title: 'المقالات',
                                        avalibleSeeAll: false,
                                      ),
                                      12.ESH(),
                                      const BlogWidget(),
                                      24.ESH(),
                                    ],
                                  ),
                                ),





                              ],
                            )
                          ],
                        ),
                      ) : Center(
                        child: Container(child: Column(
                          children: [
                            Text("حدث خطأ غير متوقع يرجى اعادة المحاولة",style: GoogleFonts.notoKufiArabic(
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),)),
                            IconButton(onPressed: (){
                              // HomeGetxController.to.getNestedItems();
                              // HomeGetxController.to.getPaidItems();
                              // HomeGetxController.to.getPopularItems();
                              // HomeGetxController.to.getLatestItems();
                              // HomeGetxController.to.getPopularClassified();
                              // HomeGetxController.to.getArticales();
                              // HomeGetxController.to.getActivities();
                              HomeGetxController.to.getConfig();
                              // AppInterfaceGetx.to.getRemoteConfig();

                            }, icon: Icon(Icons.refresh))
                          ],
                        ),));

                  }
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class VideoWidget extends StatefulWidget {

  final bool play;
  final String url;

  const VideoWidget({ required this.url, required this.play});

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}


class _VideoWidgetState extends State<VideoWidget> {
  YoutubePlayerController? _controller;
  Future<void>? _initializeVideoPlayerFuture;

  String? videoId;
  @override
  void initState() {
    super.initState();
    videoId = YoutubePlayer.convertUrlToId(widget.url);
    print("ID::: ${videoId}");
    if(videoId != null){
      _controller =  YoutubePlayerController(
          initialVideoId: videoId!,
          flags: const YoutubePlayerFlags(autoPlay: false, loop: false)
      );
    }else{
      _controller =  YoutubePlayerController(
        initialVideoId: widget.url.replaceAll("//www.youtube.com/embed/", ""),
      );
    }


  } // This closing tag was missing

  @override
  void dispose() {
    //    widget.videoPlayerController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return FittedBox(
      fit: BoxFit.cover,
      child: Card(
        margin: EdgeInsets.all(20),
        key: new PageStorageKey(widget.url),
        elevation: 5.0,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: YoutubePlayer(

            controller: _controller!,
          ),
        ),
      ),
    );


  }


}
