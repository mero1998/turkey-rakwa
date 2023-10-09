import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rakwa/api/api_controllers/item_api_controller.dart';
import 'package:rakwa/controller/all_item_getx_controller.dart';
import 'package:rakwa/model/item_with_category.dart';
import 'package:rakwa/screens/details_screen/details_screen.dart';
import 'package:rakwa/screens/search_screens/search_screen.dart';
import 'package:rakwa/screens/view_all_item_screens/view_all_items_screen.dart';
import 'package:rakwa/widget/appbars/app_bars.dart';
import 'package:rakwa/widget/category_widget.dart';
import 'package:rakwa/widget/home_widget.dart';
import 'package:rakwa/widget/my_text_field.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../api/api_controllers/list_api_controller.dart';
import '../../api/api_controllers/subscribtion_api_controller.dart';
import '../../app_colors/app_colors.dart';
import '../../controller/all_sub_item_getx_controller.dart';
import '../../model/all_categories_model.dart';
import 'package:http/http.dart' as http;

import '../../widget/app_dialog.dart';
import '../../widget/video_play.dart';
import '../main_screens/btm_nav_screens/Home/Widgets/shimmer_card_home_loading.dart';
class ViewAllSubCategoriesScreen extends StatefulWidget {
  final int id;
  final String title;
  const ViewAllSubCategoriesScreen({super.key, required this.id, required this.title});

  @override
  State<ViewAllSubCategoriesScreen> createState() =>
      _ViewAllSubCategoriesScreenState();
}

class _ViewAllSubCategoriesScreenState
    extends State<ViewAllSubCategoriesScreen> {
  List colors = const [
    Color.fromARGB(255, 224, 20, 81),
    Color.fromARGB(255, 45, 106, 228),
    Color.fromARGB(255, 159, 6, 254),
    Color.fromARGB(255, 219, 242, 12),
    Color.fromARGB(255, 224, 20, 81),
    Color.fromARGB(255, 45, 106, 228),
    Color.fromARGB(255, 159, 6, 254),
    Color.fromARGB(255, 219, 242, 12)
  ];
  late TextEditingController _searchController;
  YoutubePlayerController? _controller;
  String? videoId;
  // final Set<Marker> _marker = {};
  AllSubItemGetxController allItemGetxController =
      Get.put(AllSubItemGetxController());
  VideoPlayerController? videoPlayerController;

  List<Marker> marker = const[
     Marker(markerId: MarkerId('1'), position: LatLng(41.0082, 28.9784)),
    Marker(markerId: MarkerId('2'), position: LatLng(41.0082, 26.9784)),
    Marker(markerId: MarkerId('3'), position: LatLng(49.0082, 28.9784)),
  ];

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

    // await allItemGetxController.getAds(state: jsonDecode(response.body)['regionName'].toString(), categoryId: widget.id.toString());
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
   allItemGetxController.getPopupAds(context,state: jsonDecode(response.body)['regionName'].toString(), categoryId: widget.id.toString());


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

   ScrollController _scrollController  = ScrollController();
  @override
  void initState() {
    super.initState();
    print(widget.id);
    _searchController = TextEditingController();

    allItemGetxController.isLoading.value = true;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    await  getIsp();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {

    allItemGetxController.subItemWithCategory.clear();

    allItemGetxController.getSubCategory(id: widget.id.toString());
    allItemGetxController.getItem(id: widget.id.toString(),current_page: 1);

    // marker.clear();
    // for(int i =0; i < allItemGetxController.subItemWithCategory.length; i++){
    //   marker.add(Marker(markerId: MarkerId(i.toString()), position:  LatLng(double.parse(allItemGetxController.subItemWithCategory[i].itemLat ?? ""), double.parse(allItemGetxController.subItemWithCategory[i].itemLng ?? ""))));
    // }

    print(marker.length);
    // addMarkers();
    return Scaffold(
        appBar: AppBars.appBarDefault(title: widget.title,),
        body: Stack(
          children: [
            GetBuilder<AllSubItemGetxController>(
              builder: (controller) {
                return Column(
                  children: [
                    SizedBox(height: 10.h,),
                    Expanded(
                      child: GoogleMap(
                        markers: Set<Marker>.of(controller.marker),
                        mapType: MapType.normal,
                        myLocationEnabled: true,
                        initialCameraPosition:
                            const CameraPosition(target: LatLng(34.817411, 34.615960),zoom: 5),
                      ),
                    ),
                  ],
                );
              },
            ),
            DraggableScrollableSheet(
              maxChildSize: 0.9,
              minChildSize: 0.2,

              initialChildSize: 0.7,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding:
                         EdgeInsets.only(left: 16.w, right: 16.w, top: 5.h),
                    child: ListView(
                      physics: NeverScrollableScrollPhysics(),

                        // physics: ScrollPhysics(),
                        shrinkWrap: true,
                        controller: _scrollController,
                        // controller: allItemGetxController.scroll,

                        children: [
                    InkWell(
                    onTap: () {
                      print(widget.id.toString());
                      Get.to(() => SearchScreen(
                        categoryId: widget.id.toString(),
                        isItem: true,
                      ));
                    },
                    child: MyTextField(
                        enabled: false,
                        onChanged: (p0) {
                          setState(() {});
                        },
                        hint: 'ابحث عن',
                        controller: _searchController,
                        suffixIcon: IconButton(
                          onPressed: () {
                            // _focusNode.requestFocus();
                          },
                          icon: const Icon(
                            Icons.filter_list_sharp,
                            color: Colors.black,
                          ),
                        ),
                        prefixIcon:  Icon(
                          Icons.search,
                          color: AppColors().mainColor,
                        )),

                          ),
                          //  SizedBox(
                          //   height: 24.h,
                          // ),


                          // const SizedBox(
                          //   height: 24,
                          // ),

                          SizedBox(
                            height: 50.h,
                            child: GetBuilder<AllSubItemGetxController>(
                                    builder: (controller) {
                                      print("Leng:::${controller
                                          .subCategory.length}");
                                      return allItemGetxController.itemSubCategryStatus ==1
                                          ? Shimmer.fromColors(
                                              baseColor: Colors.grey.shade100,
                                              highlightColor: Colors.grey.shade300,
                                              child: ListView.builder(
                                                itemCount: 8,
                                                scrollDirection: Axis.horizontal,
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                    onTap: () {},
                                                    child: CategoryWidget(
                                                      image: '',
                                                      categoryName: '',
                                                    ),
                                                  );
                                                },
                                              ))
                                          :   // : allItemGetxController.itemSubCategryStatus == 3 ?
                                      // Container(width: 70.w, height: 70.h, )
                                      //     :
                                      controller
                                          .subCategory.length != 0 ?   ListView.builder(
                                            shrinkWrap: true,

                                            scrollDirection: Axis.horizontal,
                                            physics:  ScrollPhysics(),

                                            itemCount: controller
                                                .subCategory.length,
                                            itemBuilder: (context, index) {
                                              return controller
                                                  .subCategory.length == 0 ? Container(height: 0,) : InkWell(
                                                onTap: () {
                                                  print(allItemGetxController
                                                      .subCategory[index].id);
                                                  Get.to(() => ViewAllItems(
                                                    id: allItemGetxController
                                                        .subCategory[index].id ?? -1,
                                                    categoryId: widget.id,
                                                    title: allItemGetxController
                                                        .subCategory[index].categoryName ?? "",
                                                  ))!.then((value) => value ?    allItemGetxController.getItem(id: widget.id.toString(),current_page: 1)
                                                      :null);
                                                },
                                                child: CategoryWidget(
                                                  image:  allItemGetxController
                                                      .subCategory[index]
                                                      .categoryImage,
                                                  index: index,
                                                  categoryName:
                                                  allItemGetxController
                                                      .subCategory[index]
                                                      .categoryName ?? "",
                                                ),
                                              );
                                            },
                                          )
                                          : Container(height: 0,);
                                    },
    ),
                          ),
                          // Column(
                          //   children: [
                          //     GetX<AllSubItemGetxController>(builder: (c){
                          //       print(c.ads.length);
                          //       return   allItemGetxController.itemSubCategryStatus ==1 ? Shimmer.fromColors(
                          //           baseColor: Colors.grey.shade100,
                          //           highlightColor: Colors.grey.shade300,
                          //           child: Container(
                          //             margin: const EdgeInsets.only(left: 8),
                          //             height: 180.h,
                          //             width: Get.width * 0.9,
                          //             decoration: BoxDecoration(
                          //               borderRadius: BorderRadius.circular(12),
                          //               color: Colors.white,
                          //             ),
                          //           ) ) :
                          //       allItemGetxController.ads.isNotEmpty ?   Column(
                          //         children: [
                          //           SizedBox(height: 10.h,),
                          //           Row(
                          //             children: [
                          //               Icon(Icons.laptop_chromebook, color: Colors.blue,size: 16,),
                          //               SizedBox(width: 10.w,),
                          //               InkWell(
                          //                   onTap: ()async{
                          //                     // if(controller.ads.first.url != null){
                          //                     String url = allItemGetxController.ads.first.url ?? "";
                          //                     if (await canLaunchUrl(Uri.parse(url))) {
                          //                       try{
                          //                         launchUrl(Uri.parse(url),mode:LaunchMode.externalApplication);
                          //
                          //                       }catch(e){
                          //                         print(e);
                          //                       }
                          //                       // .then((value) => SubscriptionApiController().clickAd(adId: controller.ads.first.id.toString()));
                          //                     }else{
                          //                       print("Not able");
                          //                     }
                          //                     // }
                          //
                          //                   },
                          //                   child: Text("زيارة موقع الويب",style: GoogleFonts.notoKufiArabic(
                          //                       textStyle:
                          //                       TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w400)),)),
                          //             ],
                          //           ),
                          //           Container(
                          //             color: Colors.white,
                          //             width: double.infinity,
                          //             height: 140.h,
                          //             margin: EdgeInsets.only(top: 24.h),
                          //             alignment: AlignmentDirectional.center,
                          //             child:
                          //             allItemGetxController.ads.first.type == "0" ?
                          //             InkWell(
                          //                 onTap: ()async{
                          //                   print(allItemGetxController.ads.first.url);
                          //                   // if(controller.ads.first.url != null){
                          //                   String url = allItemGetxController.ads.first.url ?? "";
                          //                   // if (await canLaunchUrl(Uri.parse(url))) {
                          //                   launchUrl(Uri.parse(url),mode:LaunchMode.externalApplication).then((value) => SubscriptionApiController().clickAd(adId: allItemGetxController.ads.first.id.toString()));
                          //                   // }
                          //                   // }
                          //
                          //                 },
                          //                 child: Image.network("https://www.rakwa.com/laravel_project/public/storage/item/${allItemGetxController.ads.first.image}",fit: BoxFit.cover, width: double.infinity,height: double.infinity,)) :
                          //             // videoPlayerController != null  ?
                          //             //   _controller!.value.isInitialized ?
                          //             //   SizedBox(
                          //             // height: 120.h,
                          //             //   child: AspectRatio(
                          //             //       aspectRatio:  _controller!.value.aspectRatio,
                          //             //   child: VideoPlayer(_controller!),
                          //             //   ),
                          //             // )
                          //             //     // VideoPlayerController.file(File(pic.adVideo.value))..initialize())
                          //             //     :   Container(
                          //             //     color: Colors.blue,
                          //             //   ),
                          //             // ),
                          //             allItemGetxController.ads.first.image!.contains("youtube") ||  allItemGetxController.ads.first.image!.contains("youtu.be") ? YoutubePlayer(controller:  _controller!) :   VideoPlay(url: "${allItemGetxController.ads.first.image}",),
                          //           ),
                          //         ],
                          //       ) : Container();
                          //     }),
                          //
                          //     GetBuilder<AllSubItemGetxController>(
                          //       builder: (controller) {
                          //         print("Leng:::${controller
                          //             .subCategory.length}");
                          //         return allItemGetxController.itemSubCategryStatus ==1
                          //             ? SizedBox(
                          //           height: 70.h,
                          //           child: Shimmer.fromColors(
                          //               baseColor: Colors.grey.shade100,
                          //               highlightColor: Colors.grey.shade300,
                          //               child: ListView.builder(
                          //                 itemCount: 8,
                          //                 scrollDirection: Axis.horizontal,
                          //                 itemBuilder: (context, index) {
                          //                   return InkWell(
                          //                     onTap: () {},
                          //                     child: CategoryWidget(
                          //                       image: '',
                          //                       categoryName: '',
                          //                     ),
                          //                   );
                          //                 },
                          //               )),
                          //         )
                          //             :   // : allItemGetxController.itemSubCategryStatus == 3 ?
                          //         // Container(width: 70.w, height: 70.h, )
                          //         //     :
                          //         controller
                          //             .subCategory.length != 0 ?   SizedBox(
                          //           height: 70.h,
                          //           child: ListView.builder(
                          //             shrinkWrap: true,
                          //
                          //             scrollDirection: Axis.horizontal,
                          //             physics:  ScrollPhysics(),
                          //
                          //             itemCount: controller
                          //                 .subCategory.length,
                          //             itemBuilder: (context, index) {
                          //               return controller
                          //                   .subCategory.length == 0 ? Container(height: 0,) : InkWell(
                          //                 onTap: () {
                          //                   print(allItemGetxController
                          //                       .subCategory[index].id);
                          //                   Get.to(() => ViewAllItems(
                          //                     id: allItemGetxController
                          //                         .subCategory[index].id ?? -1,
                          //                     categoryId: widget.id,
                          //                     title: allItemGetxController
                          //                         .subCategory[index].categoryName ?? "",
                          //                   ))!.then((value) => value ?    allItemGetxController.getItem(id: widget.id.toString(),current_page: 1)
                          //                       :null);
                          //                 },
                          //                 child: CategoryWidget(
                          //                   image:  allItemGetxController
                          //                       .subCategory[index]
                          //                       .categoryImage,
                          //                   index: index,
                          //                   categoryName:
                          //                   allItemGetxController
                          //                       .subCategory[index]
                          //                       .categoryName ?? "",
                          //                 ),
                          //               );
                          //             },
                          //           ),
                          //         )
                          //             : Container(height: 0,);
                          //       },
                          //     ),
                          //   ],
                          // ),


                          SizedBox(
                            height: Get.height * 0.8,
                            child: GetBuilder<AllSubItemGetxController>(
                              builder: (controller) {
                                return controller
                                    .subItemWithCategory.isEmpty
                                    ?  Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors().mainColor,
                                  ),)
                                    : ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  controller: controller.scroll,

                                  itemCount: allItemGetxController
                                      .subItemWithCategory
                                      .length,
                                  itemBuilder: (context, index) {
                                    return  Padding(
                                      padding:  EdgeInsets.only(bottom: 15.h),
                                      child: HomeWidget(
                                          percentCardWidth: .9,
                                          onTap: () {
                                            Get.to(() => DetailsScreen(
                                                id: allItemGetxController
                                                    .subItemWithCategory[index]
                                                    .id!.toString()));
                                          },
                                          discount: '25',
                                          image: allItemGetxController
                                              .subItemWithCategory[index]
                                              .itemImage,
                                          itemType: allItemGetxController
                                              .subItemWithCategory[index]
                                              .itemCategoriesString!,
                                          location:
                                          allItemGetxController
                                              .subItemWithCategory[index]
                                              .itemDescription ?? "",
                                          title: allItemGetxController
                                              .subItemWithCategory[index]
                                              .itemTitle!,
                                          rate: allItemGetxController
                                              .subItemWithCategory[index]
                                              .itemAverageRating),
                                    );


                                  },
                                );
                              },
                            ),
                          ),
                          // SizedBox(
                          //   height: Get.height * 0.6,
                          //   child: FutureBuilder<List<ItemWithCategory>>(
                          //     future: ItemApiController().getItemWithCategory(
                          //         id: widget.id.toString()),
                          //     builder: (context, snapshot) {
                          //       if (snapshot.connectionState ==
                          //           ConnectionState.waiting) {
                          //         return Shimmer.fromColors(
                          //             baseColor: Colors.grey.shade100,
                          //             highlightColor: Colors.grey.shade300,
                          //             child: Container(
                          //               margin: const EdgeInsets.only(left: 8),
                          //               height: 236,
                          //               width: Get.width * 0.9,
                          //               decoration: BoxDecoration(
                          //                 borderRadius:
                          //                     BorderRadius.circular(12),
                          //                 color: Colors.white,
                          //               ),
                          //             ));
                          //       } else if (snapshot.hasData &&
                          //           snapshot.data!.isNotEmpty) {
                          //         return ListView.builder(
                          //           physics: const BouncingScrollPhysics(),
                          //           itemCount:
                          //               snapshot.data![0].allItems!.length,
                          //           itemBuilder: (context, index) {
                          //             return HomeWidget(
                          //                 onTap: () {
                          //                   Get.to(() => DetailsScreen(
                          //                       id: snapshot.data![0]
                          //                           .allItems![index].id!));
                          //                 },
                          //                 discount: '25',
                          //                 image: snapshot.data![0]
                          //                     .allItems![index].itemImage,
                          //                 itemType: snapshot
                          //                     .data![0]
                          //                     .allItems![index]
                          //                     .itemCategoriesString!,
                          //                 location: snapshot
                          //                             .data![0]
                          //                             .allItems![index]
                          //                             .cityId !=
                          //                         null
                          //                     ? snapshot.data![0]
                          //                         .allItems![index].cityId
                          //                         .toString()
                          //                     : '',
                          //                 title: snapshot.data![0]
                          //                     .allItems![index].itemTitle!,
                          //                 rate: snapshot
                          //                     .data![0]
                          //                     .allItems![index]
                          //                     .itemAverageRating);
                          //           },
                          //         );
                          //       } else {
                          //         return const Center(
                          //           child: Text('لا توجد اي عناصر '),
                          //         );
                          //       }
                          //     },
                          //   ),
                          // )
                        ],
                      ),
                  ),
                );
              },
            )
          ],
        ));
  }

  // void showMySheet() {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (context) {
  //       return DraggableScrollableSheet(
  //         initialChildSize: 0.9,
  //         builder: (context, scrollController) {
  //           return Container(
  //             color: Colors.white,
  //             child: Padding(
  //               padding: const EdgeInsets.only(left: 16, right: 16, top: 40),
  //               child: Column(
  //                 children: [
  //                   InkWell(
  //                     onTap: () {
  //                       Get.to(() => SearchScreen(
  //                             searchNumber: widget.id.toString(),
  //                           ));
  //                     },
  //                     child: MyTextField(
  //                         enabled: false,
  //                         onChanged: (p0) {
  //                           setState(() {});
  //                         },
  //                         hint: 'ابحث عن',
  //                         controller: _searchController,
  //                         suffixIcon: IconButton(
  //                           onPressed: () {
  //                             // _focusNode.requestFocus();
  //                           },
  //                           icon: const Icon(
  //                             Icons.filter_list_sharp,
  //                             color: Colors.black,
  //                           ),
  //                         ),
  //                         prefixIcon: const Icon(
  //                           Icons.search,
  //                           color: AppColors().mainColor,
  //                         )),
  //                   ),
  //                   const SizedBox(
  //                     height: 24,
  //                   ),
  //                   SizedBox(
  //                     height: 70,
  //                     child: FutureBuilder<List<AllCategoriesModel>>(
  //                       future:
  //                           ListApiController().getSubCategory(id: widget.id),
  //                       builder: (context, snapshot) {
  //                         if (snapshot.connectionState ==
  //                             ConnectionState.waiting) {
  //                           return Shimmer.fromColors(
  //                               baseColor: Colors.grey.shade100,
  //                               highlightColor: Colors.grey.shade300,
  //                               child: ListView.builder(
  //                                 itemCount: 8,
  //                                 scrollDirection: Axis.horizontal,

  //                                 // gridDelegate:
  //                                 //     const SliverGridDelegateWithFixedCrossAxisCount(
  //                                 //   crossAxisCount: 4,
  //                                 //   crossAxisSpacing: 31,
  //                                 //   mainAxisSpacing: 24,
  //                                 //   mainAxisExtent: 60,
  //                                 // ),
  //                                 itemBuilder: (context, index) {
  //                                   return InkWell(
  //                                     onTap: () {},
  //                                     child: CategoryWidget(
  //                                       categoryName: '',
  //                                     ),
  //                                   );
  //                                 },
  //                               ));
  //                         } else if (snapshot.hasData &&
  //                             snapshot.data!.isNotEmpty) {
  //                           return ListView.builder(
  //                             scrollDirection: Axis.horizontal,
  //                             physics: const BouncingScrollPhysics(),
  //                             itemCount: snapshot.data!.length,
  //                             itemBuilder: (context, index) {
  //                               return InkWell(
  //                                 onTap: () {
  //                                   Get.to(() => ViewAllItems(
  //                                         id: snapshot.data![index].id,
  //                                         categoryId: widget.id,
  //                                       ));
  //                                 },
  //                                 child: CategoryWidget(
  //                                   index: index,
  //                                   categoryName:
  //                                       snapshot.data![index].categoryName,
  //                                 ),
  //                               );
  //                             },
  //                           );
  //                         } else {
  //                           return const Center(
  //                             child: Text('لا توجد اي تصنفيات '),
  //                           );
  //                         }
  //                       },
  //                     ),
  //                   ),
  //                   const SizedBox(
  //                     height: 24,
  //                   ),
  //                   Expanded(
  //                     child: FutureBuilder<List<ItemWithCategory>>(
  //                       future: ItemApiController()
  //                           .getItemWithCategory(id: widget.id.toString()),
  //                       builder: (context, snapshot) {
  //                         if (snapshot.connectionState ==
  //                             ConnectionState.waiting) {
  //                           return Shimmer.fromColors(
  //                               baseColor: Colors.grey.shade100,
  //                               highlightColor: Colors.grey.shade300,
  //                               child: Container(
  //                                 margin: const EdgeInsets.only(left: 8),
  //                                 height: 236,
  //                                 width: Get.width * 0.9,
  //                                 decoration: BoxDecoration(
  //                                   borderRadius: BorderRadius.circular(12),
  //                                   color: Colors.white,
  //                                 ),
  //                               ));
  //                         } else if (snapshot.hasData &&
  //                             snapshot.data!.isNotEmpty) {
  //                           return ListView.builder(
  //                             physics: const BouncingScrollPhysics(),
  //                             itemCount: snapshot.data![0].allItems!.length,
  //                             itemBuilder: (context, index) {
  //                               return HomeWidget(
  //                                   onTap: () {
  //                                     Get.to(() => DetailsScreen(
  //                                         id: snapshot
  //                                             .data![0].allItems![index].id!));
  //                                   },
  //                                   discount: '25',
  //                                   image: snapshot
  //                                       .data![0].allItems![index].itemImage,
  //                                   itemType: snapshot.data![0].allItems![index]
  //                                       .itemCategoriesString!,
  //                                   location: snapshot.data![0].allItems![index]
  //                                               .cityId !=
  //                                           null
  //                                       ? snapshot
  //                                           .data![0].allItems![index].cityId
  //                                           .toString()
  //                                       : '',
  //                                   title: snapshot
  //                                       .data![0].allItems![index].itemTitle!,
  //                                   rate: snapshot.data![0].allItems![index]
  //                                       .itemAverageRating);
  //                             },
  //                           );
  //                         } else {
  //                           return const Center(
  //                             child: Text('لا توجد اي عناصر '),
  //                           );
  //                         }
  //                       },
  //                     ),
  //                   )
  //                 ],
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }
}
