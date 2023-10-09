import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:html/parser.dart';
import 'package:rakwa/api/api_controllers/details_api_controller.dart';
import 'package:rakwa/api/api_controllers/save_api_controller.dart';
import 'package:rakwa/controller/show_title_getx_controller.dart';
import 'package:rakwa/model/details_calssified_model.dart';
import 'package:rakwa/screens/details_screen/details_screen.dart';
import 'package:rakwa/screens/details_screen/tab_bar_screens/details_classified_tab_bar_screen.dart';
import 'package:rakwa/Core/utils/helpers.dart';
import 'package:rakwa/widget/share_widget.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../app_colors/app_colors.dart';
import '../../controller/home_getx_controller.dart';
import '../../shared_preferences/shared_preferences.dart';
import '../add_listing_screens/Controllers/add_work_controller.dart';
import '../add_listing_screens/add_list_classified_category_screen.dart';
import '../main_screens/main_screen.dart';

class DetailsClassifiedScreen extends StatefulWidget {
  final int id;

  bool? fromNotification;
  DetailsClassifiedScreen({super.key, required this.id, this.fromNotification});

  @override
  State<DetailsClassifiedScreen> createState() =>
      _DetailsClassifiedScreenState();
}

class _DetailsClassifiedScreenState extends State<DetailsClassifiedScreen>
    with SingleTickerProviderStateMixin, Helpers {
  final rateClassifiedKey = new GlobalKey();
  final detailsClassifiedKey = new GlobalKey();
  ScrollController scrollController = ScrollController();
  ShowTitleGetxController showTitleGetxController =
      Get.put(ShowTitleGetxController());

  late TabController _tabController;
  bool showWorkHour = false;
  final Set<Marker> _marker = {};

  void _setMarker({required var detailsModel}) {
    _marker.add(
      Marker(
        markerId: const MarkerId('value'),
        position: LatLng(
            detailsModel.item!.itemLat != null
                ? double.parse(
                    detailsModel.item!.itemLat!,
                  )
                : 41.0082,
            detailsModel.item!.itemLng != null
                ? double.parse(
                    detailsModel.item!.itemLng!,
                  )
                : 28.9784),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(
          title: detailsModel.item!.state != null
              ? detailsModel.item!.state!.stateName
              : 'İstanbul',
          snippet: detailsModel.item!.city != null
              ? detailsModel.item!.city!.cityName
              : 'İstanbul',
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Get.put(HomeGetxController());


    WidgetsBinding.instance.addPostFrameCallback((timeStamp)async {
      await HomeGetxController.to.getDetailsAds(widget.id.toString());

    });

    _tabController = TabController(length: 2, vsync: this);
    scrollController.addListener(() {
      if (scrollController.offset > 260) {
        // do what ever you want when silver is collapsing !
        showTitleGetxController.showTitle(newShow: true);
      }
      if (scrollController.offset <= 260) {
        showTitleGetxController.showTitle(newShow: false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print("id ::: ${widget.id}");
    return SafeArea(
      bottom: false,
      child: WillPopScope(
        onWillPop: ()async{
          HomeGetxController.to.adsDetails.removeLast();
          if(HomeGetxController.to.adsDetails.isEmpty){
            Get.offAll(
                MainScreen()
            );
          }
          Get.back();
          return true;
        },
        child: Scaffold(
            backgroundColor: Colors.white,
            body: GetX<HomeGetxController>(
              builder: (controller){
                return controller.isLoading.value ? Center(
                  child: CircularProgressIndicator(
                    color: AppColors().mainColor,
                  ),
                ) : controller.adsDetails.isEmpty ?  Center(child: Text('لا توجد بيانات'))
                    : CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 254.h,
                      pinned: true,
                      stretch: true,
                      backgroundColor: Colors.black12,
                      leadingWidth: 80.w,
                      leading: LeadingSliverAppBarIconDetailsScreen(fromNotification: widget.fromNotification,),
                      actions: [
                        Visibility(
                          visible: controller.adsDetails.last.classified!.itemStatus == 2,
                          child: SaveItemWidget(
                            id: controller.adsDetails.last.classified!.id.toString(),
                          ),
                        ),
                        ShareItemWidget(
                          id: controller.adsDetails.last.classified!.id.toString(),
                          title: _parseHtmlString(controller.adsDetails.last.classified!.itemTitle ?? ""),
                          desc: _parseHtmlString(controller.adsDetails.last.classified!.itemDescription ?? ""),
                          image:controller.adsDetails.last.classified!.galleries!.isNotEmpty ?
                          'https://www.rakwa.com/laravel_project/public/storage/item/gallery/${controller.adsDetails.last.classified!.galleries!.first.itemImageGalleryName  ?? ""}' : "",
                          // image: 'https://www.rakwa.com/laravel_project/public/storage/item/gallery/${controller.adsDetails.last.classified!.galleries!.first.itemImageGalleryName  ?? ""}',
                          kayType: "classified",
                          tag: "ad",
                        ),
                        SharedPrefController().isLogined ? InkWell(
                          onTap: (){
                            Get.put(AddWorkOrAdsController(isList: false));
                            AddWorkOrAdsController.to.edit.value = true;
                            Navigator.push(context, MaterialPageRoute(builder: (c) => AddListClassifiedCategoryScreen(detailsModel: controller.adsDetails.last,)));

                          },
                          child: Visibility(
                            visible: controller.adsDetails.last.classified!.userId == int.parse(SharedPrefController().id),
                            child: Padding(
                              padding:  EdgeInsets.symmetric(vertical: 8.h),
                              child: CircleAvatar(
                                backgroundColor: Colors.black.withOpacity(0.4),
                                child: IconButton(
                                    onPressed: () async {
                                      Get.put(AddWorkOrAdsController(isList: false));
                                      AddWorkOrAdsController.to.edit.value = true;
                                      Navigator.push(context, MaterialPageRoute(builder: (c) => AddListClassifiedCategoryScreen(detailsModel: controller.adsDetails.last,)));

                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      // Icons.bookmark_outlined,
                                      color: Colors.white,
                                    )),
                              ),
                            ),
                          ),
                        ) : Container()
                      ],
                      flexibleSpace: FlexibleSpaceBar(
                        // title: Container(
                        //   padding: const EdgeInsets.symmetric(
                        //       vertical: 5, horizontal: 10),
                        //   decoration: BoxDecoration(
                        //       // color: Colors.white.withOpacity(0.5),
                        //       borderRadius: BorderRadius.circular(10)),
                        //   child: Container(
                        //     padding: const EdgeInsets.symmetric(
                        //         vertical: 5, horizontal: 10),
                        //     decoration: BoxDecoration(
                        //         // color: Colors.white.withOpacity(0.5),
                        //         borderRadius: BorderRadius.circular(10)),
                        //     child: Text(
                        //       snapshot.data!.classified!.itemTitle!,
                        //       style: GoogleFonts.notoKufiArabic(
                        //         textStyle: const TextStyle(
                        //           fontSize: 18,
                        //           color: Colors.white,
                        //           fontWeight: FontWeight.bold,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        titlePadding: const EdgeInsets.symmetric(
                          horizontal: 0,
                          vertical: 0,
                        ),
                        background: SizedBox(
                          height: 0,
                          width: Get.width,
                          child: TopDetailsClassifiedWidget(snapshot: controller.adsDetails.last),
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Container(
                            color: Colors.white,
                            child: Padding(
                              padding:  EdgeInsets.symmetric(
                                  vertical: 16.h,
                                  horizontal: 10.w
                              ),
                              child: SizedBox(
                                height: 35.h,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: controller.adsDetails.last.classified!.allCategories!.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      padding:  EdgeInsets.symmetric(
                                        vertical: 5.h,
                                        horizontal: 12.w,
                                      ),
                                      margin: const EdgeInsets.only(left: 5),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: AppColors().mainColor,
                                        // border: Border.all(
                                        //   color: const Color.fromARGB(
                                        //     255,
                                        //     170,
                                        //     234,
                                        //     247,
                                        //   ),
                                        // ),
                                      ),
                                      child: Text(
                                        controller.adsDetails.last
                                            .classified!
                                            .allCategories![index]
                                            .categoryName!,
                                        style: GoogleFonts.notoKufiArabic(
                                          // ignore: prefer_const_constructors
                                          textStyle: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          DetailsClassifiedTabBarScreen(
                            detailsModel: controller.adsDetails.last,
                            rateClassifiedKey: rateClassifiedKey,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            )

            //
            // FutureBuilder<DetailsClassifiedModel?>(
            //   future: DetailsApiController()
            //       .getClassifiedDetails(id: widget.id.toString()),
            //   builder: (context, snapshot) {
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return const Center(
            //         child: CircularProgressIndicator(
            //           color: AppColors().mainColor,
            //         ),
            //       );
            //     } else if (snapshot.hasData) {
            //       bool show = false;
            //       return CustomScrollView(
            //         controller: scrollController,
            //         slivers: [
            //           SliverAppBar(
            //             expandedHeight: 254,
            //             pinned: true,
            //             stretch: true,
            //             backgroundColor: Colors.black12,
            //             leadingWidth: 80,
            //             leading: LeadingSliverAppBarIconDetailsScreen(),
            //             actions: [
            //               Visibility(
            //                 visible: snapshot.data!.classified!.itemStatus == 2,
            //                 child: SaveItemWidget(
            //                   id: snapshot.data!.classified!.id.toString(),
            //                 ),
            //               ),
            //               ShareItemWidget(
            //                 id: snapshot.data!.classified!.id.toString(),
            //                 title: snapshot.data!.classified!.itemTitle!,
            //                 desc: snapshot.data!.classified!.itemDescription!,
            //                 image: 'https://www.rakwa.com/laravel_project/public/storage/item/gallery/${snapshot.data!.classified!.itemImage}',
            //                 kayType: "classified",
            //               ),
            //              SharedPrefController().isLogined ? InkWell(
            //                 onTap: (){
            //                   Get.put(AddWorkOrAdsController(isList: false));
            //                   AddWorkOrAdsController.to.edit.value = true;
            //                   Navigator.push(context, MaterialPageRoute(builder: (c) => AddListClassifiedCategoryScreen(detailsModel: snapshot.data,)));
            //
            //                 },
            //                 child: Visibility(
            //                   visible: snapshot.data!.classified!.userId == int.parse(SharedPrefController().id),
            //                   child: Padding(
            //                     padding: const EdgeInsets.symmetric(vertical: 8),
            //                     child: CircleAvatar(
            //                       backgroundColor: Colors.black.withOpacity(0.4),
            //                       child: IconButton(
            //                           onPressed: () async {
            //                             Get.put(AddWorkOrAdsController(isList: false));
            //                             AddWorkOrAdsController.to.edit.value = true;
            //                             Navigator.push(context, MaterialPageRoute(builder: (c) => AddListClassifiedCategoryScreen(detailsModel: snapshot.data,)));
            //
            //                           },
            //                           icon: const Icon(
            //                             Icons.edit,
            //                             // Icons.bookmark_outlined,
            //                             color: Colors.white,
            //                           )),
            //                     ),
            //                   ),
            //                 ),
            //               ) : Container()
            //             ],
            //             flexibleSpace: FlexibleSpaceBar(
            //               // title: Container(
            //               //   padding: const EdgeInsets.symmetric(
            //               //       vertical: 5, horizontal: 10),
            //               //   decoration: BoxDecoration(
            //               //       // color: Colors.white.withOpacity(0.5),
            //               //       borderRadius: BorderRadius.circular(10)),
            //               //   child: Container(
            //               //     padding: const EdgeInsets.symmetric(
            //               //         vertical: 5, horizontal: 10),
            //               //     decoration: BoxDecoration(
            //               //         // color: Colors.white.withOpacity(0.5),
            //               //         borderRadius: BorderRadius.circular(10)),
            //               //     child: Text(
            //               //       snapshot.data!.classified!.itemTitle!,
            //               //       style: GoogleFonts.notoKufiArabic(
            //               //         textStyle: const TextStyle(
            //               //           fontSize: 18,
            //               //           color: Colors.white,
            //               //           fontWeight: FontWeight.bold,
            //               //         ),
            //               //       ),
            //               //     ),
            //               //   ),
            //               // ),
            //               titlePadding: const EdgeInsets.symmetric(
            //                 horizontal: 0,
            //                 vertical: 0,
            //               ),
            //               background: SizedBox(
            //                 height: 0,
            //                 width: Get.width,
            //                 child: TopDetailsClassifiedWidget(snapshot: snapshot),
            //               ),
            //             ),
            //           ),
            //           SliverList(
            //             delegate: SliverChildListDelegate(
            //               [
            //                 Container(
            //                   color: Colors.white,
            //                   child: Padding(
            //                     padding: const EdgeInsets.symmetric(
            //                       vertical: 16,
            //                       horizontal: 10
            //                     ),
            //                     child: SizedBox(
            //                       height: 35,
            //                       child: ListView.builder(
            //                         scrollDirection: Axis.horizontal,
            //                         physics: const BouncingScrollPhysics(),
            //                         itemCount: snapshot
            //                             .data!.classified!.allCategories!.length,
            //                         itemBuilder: (context, index) {
            //                           return Container(
            //                             padding: const EdgeInsets.symmetric(
            //                               vertical: 5,
            //                               horizontal: 12,
            //                             ),
            //                             margin: const EdgeInsets.only(left: 5),
            //                             alignment: Alignment.center,
            //                             decoration: BoxDecoration(
            //                               borderRadius: BorderRadius.circular(8),
            //                               color: AppColors().mainColor,
            //                               // border: Border.all(
            //                               //   color: const Color.fromARGB(
            //                               //     255,
            //                               //     170,
            //                               //     234,
            //                               //     247,
            //                               //   ),
            //                               // ),
            //                             ),
            //                             child: Text(
            //                               snapshot
            //                                   .data!
            //                                   .classified!
            //                                   .allCategories![index]
            //                                   .categoryName!,
            //                               style: GoogleFonts.notoKufiArabic(
            //                                 // ignore: prefer_const_constructors
            //                                 textStyle: TextStyle(
            //                                   fontSize: 12,
            //                                   color: Colors.white,
            //                                   fontWeight: FontWeight.bold,
            //                                 ),
            //                               ),
            //                             ),
            //                           );
            //                         },
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //                 DetailsClassifiedTabBarScreen(
            //                   detailsModel: snapshot.data!,
            //                   rateClassifiedKey: rateClassifiedKey,
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ],
            //       );
            //     } else {
            //       print("snapshot.hasData is => ${snapshot.data}");
            //       return const Center(child: Text('لا توجد بيانات'));
            //     }
            //   },
            // )
    ),
      ),
    );
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
  }

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=41.0082,28.9784';
    if (await canLaunchUrlString(googleUrl)) {
      await launchUrlString(
        googleUrl,
      );
    } else {
      throw 'Could not open the map.';
    }
  }
}

class TopDetailsClassifiedWidget extends StatelessWidget with Helpers {
  final DetailsClassifiedModel snapshot;

  const TopDetailsClassifiedWidget({Key? key, required this.snapshot})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    CarouselController buttonCarouselController = Get.put(CarouselController());
    return SizedBox(
      height: 254.h,
      width: Get.width,
      child: Stack(
        children: [
          snapshot.classified!.galleries != null &&
                  snapshot.classified!.galleries!.isNotEmpty
              ? CarouselSlider(

            carouselController: buttonCarouselController,
            options: CarouselOptions(
              height: double.infinity,
              autoPlay: true,
              viewportFraction: .96,
              reverse: false,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              enlargeFactor: 0.4,
              scrollDirection: Axis.horizontal,
            ),
                  items: snapshot.classified!.galleries!.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 4.h),
                          decoration: BoxDecoration(color: Colors.white),
                          child: Stack(
                            children: [
                              Image.network(
                                'https://www.rakwa.com/laravel_project/public/storage/item/gallery/${i.itemImageGalleryName}',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                              Positioned.fill(
                                child: Opacity(
                                  opacity: 0.5,
                                  child: Container(
                                    color: const Color(0xFF000000),
                                  ),
                                ),
                              ),
                              PositionedDirectional(
                                  start: 10,
                                  bottom: 50,
                                  child: Text(snapshot.classified!.itemTitle ?? "",
                                    style: GoogleFonts.notoKufiArabic(
                                      textStyle:  TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),),))
                            ],
                          ),
                        );
                      },
                    );
                  }).toList(),
                )
              : Stack(
                  children: [
                    Image.network(
                      'https://www.rakwa.com/laravel_project/public/storage/item/${snapshot.classified!.itemImage}',
                      fit: BoxFit.cover,
                      width: Get.width,
                    ),
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0.5,
                        child: Container(
                          color: const Color(0xFF000000),
                        ),
                      ),
                    ),
                  ],
                ),

          // Image.network(
          //   'https://www.rakwa.com/laravel_project/public/storage/item/${snapshot.data!.classified!.itemImage}',
          //   fit: BoxFit.fitWidth,
          //   width: Get.width,
          // ),
          // Positioned.fill(
          //   child: Opacity(
          //     opacity: 0.5,
          //     child: Container(
          //       color: const Color(0xFF000000),
          //     ),
          //   ),
          // ),

          // Positioned(
          //   right: 16,
          //   bottom: 19,
          //   child: RateStarsWidget(
          //       rate: snapshot.data!.item!.itemAverageRating),
          // ),
        ],
      ),
    );
  }



}

class SaveItemWidget extends StatelessWidget with Helpers {
  final String id;

  const SaveItemWidget({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 8.h),
      child: CircleAvatar(
        backgroundColor: Colors.black.withOpacity(0.4),
        child: IconButton(
            onPressed: () async {

              saveItem(id: id);
            },
            icon: GetX<HomeGetxController>(
                builder: (c) {
                  return  Icon(
                    c.savedClassifiedIDS.contains(int.parse(id)) ? Icons.bookmark  :  Icons.bookmark_outline_sharp,
                    // Icons.bookmark_outlined,
                    color: Colors.white,
                  );
                }
            )),
      ),
    );
  }

  Future<void> saveItem({required String id}) async {
    if(SharedPrefController().id != ""){
      if(HomeGetxController.to.savedClassifiedIDS.contains(int.parse(id))){
        int index = HomeGetxController.to.savedClassifiedIDS.indexWhere((element) => element == int.parse(id));
        HomeGetxController.to.savedClassifiedIDS.removeAt(index);
        HomeGetxController.to.savedClassified.removeWhere((element) => element.id == int.parse(id));
        print(HomeGetxController.to.savedClassifiedIDS);
        bool status = await SaveApiController().unSaveClassified(classifiedId: id);

        if (status) {

          // ShowMySnakbar(
          //     title: 'هذا العنصر مضاف سابقاً',
          //     message: 'تم حذف العنصر بنجاح',
          //     backgroundColor: Colors.green.shade700);
        } else {
          ShowMySnakbar(
              title: 'خطأ',
              message: 'حدث خطأ ما',
              backgroundColor: Colors.red.shade700);
        }
      }
      else{
        HomeGetxController.to.savedClassifiedIDS.add(int.parse(id));

        bool status = await SaveApiController().saveClassified(classifiedId: id);
        HomeGetxController.to.getSavedClassified();
        // HomeGetxController.to.savedItems.add(HomeGetxController.to.itemsDetails.where((p0) => p0.item.id == id).first);
        if (status) {
          // ShowMySnakbar(
          //     title: 'تم العملية بنجاح',
          //     message: 'تم حفظ العنصر بنجاح',
          //     backgroundColor: Colors.green.shade700);
        } else {
          ShowMySnakbar(
              title: 'خطأ',
              message: 'حدث خطأ ما',
              backgroundColor: Colors.red.shade700);
        }
      }

    }else{
      ShowMySnakbar(
          title: 'خطأ',
          message: 'يجب عليك تسجيل دخول اولاً',
          backgroundColor: Colors.red.shade700);
    }
  }

}
class LeadingSliverAppBarIconDetailsScreen extends StatelessWidget {

  bool? fromNotification;
   LeadingSliverAppBarIconDetailsScreen({
    Key? key,
    this.fromNotification
   }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircleAvatar(
        backgroundColor: Colors.black.withOpacity(0.4),
        child: IconButton(
            onPressed: () {
              // NavigatorObserver().didPop(MaterialPageRoute(builder: (c) => MainScreen()), MaterialPageRoute(builder: (c) => DetailsScreen(id: )));

              HomeGetxController.to.adsDetails.removeLast();
              if(fromNotification != null){
                if(HomeGetxController.to.adsDetails.isEmpty){
                  Get.offAll(
                      MainScreen()
                  );
                }
              }else{
                Get.back();

              }

              // Get.offAll(
              //   MainScreen()
              // );
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
      ),
    );
  }
}

