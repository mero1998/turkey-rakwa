import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cupertino_back_gesture/cupertino_back_gesture.dart';
import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:html/parser.dart';
import 'package:rakwa/Core/utils/dynamic_link_service.dart';
import 'package:rakwa/Core/utils/extensions.dart';
import 'package:rakwa/api/api_controllers/details_api_controller.dart';
import 'package:rakwa/api/api_controllers/save_api_controller.dart';
import 'package:rakwa/controller/email_verified_getx_controller.dart';
import 'package:rakwa/controller/image_picker_controller.dart';
import 'package:rakwa/controller/show_title_getx_controller.dart';
import 'package:rakwa/model/details_model.dart';
import 'package:rakwa/model/paid_items_model.dart';
import 'package:rakwa/screens/add_listing_screens/add_list_category_screen.dart';
import 'package:rakwa/screens/claims_screens/create_claims_screen.dart';
import 'package:rakwa/screens/details_screen/Widgets/top_details_screen_widget.dart';
import 'package:rakwa/screens/details_screen/gallery_screen/gallery_screen.dart';
import 'package:rakwa/screens/details_screen/tab_bar_screens/details_tab_bar_screen.dart';
import 'package:rakwa/screens/details_screen/tab_bar_screens/images_tab_bar_screen.dart';
import 'package:rakwa/screens/details_screen/tab_bar_screens/location_tab_bar_screen.dart';
import 'package:rakwa/screens/details_screen/tab_bar_screens/rate_tab_bar_screen.dart';
import 'package:rakwa/screens/main_screens/main_screen.dart';
import 'package:rakwa/screens/menu/menu_screen.dart';
import 'package:rakwa/screens/messages_screen/create_message.dart';
import 'package:rakwa/shared_preferences/shared_preferences.dart';
import 'package:rakwa/Core/utils/helpers.dart';
import 'package:rakwa/widget/SVG_Widget/svg_widget.dart';
import 'package:rakwa/widget/rate_stars_widget.dart';
import 'package:rakwa/widget/share_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../api/api_controllers/menu_api_controller.dart';
import '../../app_colors/app_colors.dart';
import '../../controller/all_menu_getx_controller.dart';
import '../../controller/home_getx_controller.dart';
import '../add_listing_screens/Controllers/add_work_controller.dart';

class DetailsScreen extends StatefulWidget {
  final String id;

  bool? fromNotification;
  DetailsScreen({required this.id, this.fromNotification});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen>
    with SingleTickerProviderStateMixin, Helpers {
  ScrollController scrollController = ScrollController();
  CarouselController buttonCarouselController = CarouselController();

  ShowTitleGetxController showTitleGetxController =
      Get.put(ShowTitleGetxController());
  final rateKey = new GlobalKey();
  final detailsKey = new GlobalKey();
  final addReview = new GlobalKey();
  final addImage = new GlobalKey();
  final report = new GlobalKey();
  FocusNode focusNode = FocusNode();
  bool silverCollapsed = false;
  bool show = false;

  late TabController _tabController;
  bool showWorkHour = false;
  final Set<Marker> _marker = {};

  void _setMarker({required var detailsModel}) {
    _marker.add(
      Marker(
        markerId: const MarkerId('value'),
        position: LatLng(
            detailsModel.item!.itemLat != null
                ? double.parse(detailsModel.item!.itemLat!)
                : 41.0082,
            detailsModel.item!.itemLng != null
                ? double.parse(detailsModel.item!.itemLng!)
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
    Get.put(AddWorkOrAdsController(isList: true));

    Get.put(HomeGetxController());
    WidgetsBinding.instance.addPostFrameCallback((timeStamp)async {
     await HomeGetxController.to.getDetails(widget.id);

     // AddWorkOrAdsController.to.resId.value = HomeGetxController.to.itemsDetails.first.
     scrollController.addListener(() {
       if (scrollController.offset > 254) {
         showTitleGetxController.showTitle(newShow: true);
       } else {
         showTitleGetxController.showTitle(newShow: false);
       }
     });
    });

    _tabController = TabController(length: 2, vsync: this);
  }

  Future<bool> _backPressed(GlobalKey<NavigatorState> _yourKey) async {
    //Checks if current Navigator still has screens on the stack.

    HomeGetxController.to.itemsDetails.removeLast();

    if( widget.fromNotification != null){
      if(HomeGetxController.to.itemsDetails.isEmpty){
        Get.offAll(
            MainScreen()
        );
      }
    }else{
      Get.back();
    }


    if (_yourKey.currentState!.canPop()) {
      // 'maybePop' method handles the decision of 'pop' to another WillPopScope if they exist.
      //If no other WillPopScope exists, it returns true
      _yourKey.currentState!.maybePop();
      // Get.back();
      Navigator.pop(context);
      return Future<bool>.value(false);
    }
//if nothing remains in the stack, it simply pops
    Navigator.pop(context);

    return Future<bool>.value(true);
  }
  @override
  Widget build(BuildContext context) {
    print("ID::: ${SharedPrefController().id}");
    print("ID::: ${widget.id}");
    GlobalKey<NavigatorState> _yourKey  = GlobalKey();
    bool s = true;
    return ConditionalWillPopScope(
      onWillPop: () => _backPressed(_yourKey),
      shouldAddCallback: true,
      child: Scaffold(
          backgroundColor: Colors.white,
          // appBar: AppBar(
          //   title: GetBuilder<ShowTitleGetxController>(
          //     builder: (controller) {
          //       return Text('${showTitleGetxController.show}');
          //     },
          //   ),
          // ),
          body: GetX<HomeGetxController>(
            // future: DetailsApiController().getDetails(id: widget.id.toString()),
            builder: (c) {
          return  c.isLoading.value ?  Center(
                child: CircularProgressIndicator(
                  color: AppColors().mainColor,
                )): c.itemsDetails.isNotEmpty ? CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverAppBar(
                  expandedHeight: 254.h,
                  pinned: true,
                  stretch: false,
                  backgroundColor: Colors.black12,
                  leadingWidth: 70.w,
                  leading: LeadingSliverAppBarIconDetailsScreen(fromNotification: widget.fromNotification,),
                  actions: [
                    SaveItemWidget(id: c.itemsDetails.last.item!.id.toString()),
                    ShareItemWidget(
                      id: c.itemsDetails.last.item!.id.toString(),
                      title: c.itemsDetails.last.item!.itemTitle ?? "",
                      desc: _parseHtmlString(c.itemsDetails.last.item!.itemDescription ?? ""),
                      image: c.itemsDetails.last.item!.galleries!.isEmpty
                          ? ""
                          : 'https://www.rakwa.com/laravel_project/public/storage/item/gallery/${c.itemsDetails.last!.item!.galleries![0].itemImageGalleryName}',
                      kayType: "category",
                      tag: "item",
                    ),

                    SharedPrefController().isLogined ? Visibility(
                      visible: c.itemsDetails.last.item!.userId == int.parse(SharedPrefController().id),
                      child: InkWell(
                        onTap: ()
                        {
                          Get.put(AddWorkOrAdsController(isList: true));
                          AddWorkOrAdsController.to.edit.value = true;
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AddListCategoryScreen(detailsModel: c.itemsDetails.last,)));

                        },
                        child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: CircleAvatar(
                              backgroundColor: Colors.black.withOpacity(0.4),
                              child: Icon(Icons.edit),
                            )),
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
                    //   child: Align(
                    //     alignment: AlignmentDirectional.bottomStart,
                    //     child: Text(
                    //       snapshot.data!.item!.itemTitle!,
                    //       style: GoogleFonts.notoKufiArabic(
                    //         textStyle: const TextStyle(
                    //           fontSize: 14,
                    //           color: Colors.white,
                    //           fontWeight: FontWeight.bold,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    titlePadding: EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 0,
                    ),
                    background: SizedBox(
                      height: 0,
                      width: Get.width,
                      child: TopDetailsScreenWidget(snapshot: c.itemsDetails.last),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      AnimationLimiter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                              Container(
                                  color: Colors.white,
                                  padding:  EdgeInsets.symmetric(
                                      horizontal: 16.w, vertical: 16.h),
                                  child: SizedBox(
                                    height: 35.h,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      physics:
                                      const BouncingScrollPhysics(),
                                      itemCount: c.itemsDetails.last.item!
                                          .allCategories!.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          padding:
                                           EdgeInsets.symmetric(
                                              vertical: 4.h,
                                              horizontal: 12.w),
                                          margin: const EdgeInsets.only(
                                              left: 5),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(30),
                                            color: AppColors.blueLightColor,
                                            // gradient:
                                            //     AppColors.mainGradient,
                                          ),
                                          child: Text(
                                            c.itemsDetails.last
                                                .item!
                                                .allCategories![index]
                                                .categoryName!,
                                            style:
                                            GoogleFonts.notoKufiArabic(
                                              // ignore: prefer_const_constructors
                                              textStyle: TextStyle(
                                                fontSize: 10.sp,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )),
                            SharedPrefController().isLogined ?
                            Visibility(
                                visible: int.parse(SharedPrefController().id) != c.itemsDetails.last.item!.userId,
                                replacement: Visibility(
                                  visible:  c.itemsDetails.last.item!.itemStatus == 1,
                                  child: Text("عملك قيد المراجعة", style: GoogleFonts.notoKufiArabic(
                                    textStyle:  TextStyle(
                                      color: AppColors().mainColor,
                                    ),
                                  ),),
                                ),
                                child: Container(
                                  color: Colors.white,
                                  child: Padding(
                                    padding:  EdgeInsets.symmetric(
                                        horizontal: 16.w, vertical: 16.h),
                                    child: Container(
                                      height: 45.h,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                        BorderRadius.circular(10.r),
                                        border: Border.all(
                                          color: AppColors().mainColor,
                                        ),
                                      ),
                                      child: TextButton(
                                          style: ButtonStyle(
                                              fixedSize:
                                              MaterialStateProperty.all(
                                                  Size(Get.width, 40.h))),
                                          onPressed: () {
                                            if (SharedPrefController()
                                                .roleId ==
                                                3) {
                                              if (SharedPrefController()
                                                  .verifiedEmail !=
                                                  'null') {
                                                if( c.itemsDetails.last.claim == "يوجد مطالبة"){
                                                  if(getStatus() == "المطالبة بإدارة العمل") {
                                                    Get.to(() =>
                                                        CreateClaimsScreen(
                                                            id: c.itemsDetails
                                                                .first.item!
                                                                .id
                                                                .toString()));
                                                  }
                                                }else{
                                                  return null;
                                                }

                                              } else {
                                                ShowMySnakbar(
                                                    title:
                                                    'لم تقم بتاكيد حسابك',
                                                    message:
                                                    'يجب عليك تاكيد حسابك قبل',
                                                    backgroundColor:
                                                    Colors.red.shade700);
                                              }
                                            } else if (SharedPrefController()
                                                .roleId ==
                                                2) {
                                              alertDialogRoleAuthUser(
                                                  context);
                                            } else {
                                              AlertDialogUnAuthUser(context);
                                            }
                                          },
                                          child: Text(
              // c.itemsDetails.last.item!.claims!.isNotEmpty ?
              // c.itemsDetails.last.item!.claims!.where((element) => element.itemClaimStatus == 3).where((element) => element.userId == int.parse(SharedPrefController().id)).isNotEmpty?
              // c.itemsDetails.last.item!.claims!.where((element) => element.itemClaimStatus == 1).where((element) => element.userId == int.parse(SharedPrefController().id)).isNotEmpty ?
              // "العمل مدار بواسطة${ c.itemsDetails.last.item!.claims!.where((element) => element.itemClaimStatus == 3).first.itemClaimFullName}" : 'المطالبة بالعمل تحت المراجعة'
              //     : 'المطالبة بإدارة العمل'
              //     : 'المطالبة بإدارة العمل',
                                      c.itemsDetails.last.claim == "لايوجد مطالبة" ?    "العمل مدار بواسطة ${ c.itemsDetails.last.user_name ?? ""}": getStatus(),
                                            style: GoogleFonts.notoKufiArabic(
                                              textStyle:  TextStyle(
                                                color: AppColors().mainColor,
                                              ),
                                            ),
                                          )),
                                    ),
                                  ),
                                ),
                              ) : Container(),
                                                    Visibility(
                                                      visible: c.itemsDetails.first.item!.menu != null,
                                                      child: Container(
                                                        color: Colors.white,
                                                        child: Padding(
                                                          padding:  EdgeInsets.symmetric(
                                                              horizontal: 16.w, vertical: 16.h),
                                                          child: Container(
                                                            height: 45.h,
                                                            decoration: BoxDecoration(
                                                              color: Colors.white,
                                                              borderRadius:
                                                              BorderRadius.circular(10.r),
                                                              border: Border.all(
                                                                color: AppColors().mainColor,
                                                              ),
                                                            ),
                                                            child: TextButton(
                                                                style: ButtonStyle(
                                                                    fixedSize:
                                                                    MaterialStateProperty.all(
                                                                        Size(Get.width, 40.h))),
                                                                onPressed: () {
              if(c.itemsDetails.first.item!.menu != null) {
                // c.itemsDetails.first.item!.menu = "";
                String s = c.itemsDetails.last.item!.menu ?? "";
//Remove everything after last '.'
                var pos = s.lastIndexOf('t/');
                String result = (pos != -1) ? s.substring(pos + 2) : s;
                print(" result::${result}");
                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    MenuScreen(resName: result,
                      userId: c.itemsDetails.first.item!.userId ?? -1,)));
              }
              },
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    Text(
                                                                     c.itemsDetails.first.item!.itemCategoriesString!.contains("تأجير سيارات")  ||  c.itemsDetails.first.item!.itemCategoriesString!.contains("تأجير شقق") ? "احجز الآن" :    "اطلب الآن",
                                                                      style: GoogleFonts.notoKufiArabic(
                                                                        textStyle:  TextStyle(
                                                                          color: AppColors().mainColor,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(width: 10.w,),
                                                                    IconSvg("scooter",size: 25.w,),
                                                                  ],
                                                                )),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                              Container(
                                padding:  EdgeInsetsDirectional.only(
                                    top: 16.h,start: 16.w,
                                  bottom: 16.h
                                ),
                                alignment: Alignment.center,
                                color: Colors.white,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    DetailsButton(
                                      iconData:
                                      Icons.messenger_outline_rounded,
                                      name: 'رسالة',
                                      onTap: () {
                                        print(c.itemsDetails.last.item!.id
                                            .toString());
                                        Get.to(
                                              () => CreateMessage(
                                            itemId: c.itemsDetails.last.item!.id
                                                .toString(),
                                          ),
                                        );
                                      },
                                    ),
//
                                  SizedBox(width: 10.w,),
                                    DetailsButton(
                                      iconData: Icons.location_on_outlined,
                                      name: 'الموقع',
                                      onTap: () async {
                                        openMap(
                                            c.itemsDetails.last.item!.itemLat !=
                                                null
                                                ? double.parse(c.itemsDetails.last.item!.itemLat!)
                                                : 41.0082,
                                            c.itemsDetails.last.item!.itemLng !=
                                                null
                                                ? double.parse(c.itemsDetails.last.item!.itemLng!)
                                                : 28.9784);
                                      },
                                    ),
//                                     Visibility(
//                                       visible: c.itemsDetails.first.item!.menu != null,
//
//                                       child: Expanded(
//                                         child: DetailsButton(
//                                           iconData: Icons.menu,
//                                           name: 'اطلب الان',
//                                           onTap: () async {
//               if(c.itemsDetails.first.item!.menu != null){
//                       String s = c.itemsDetails.first.item!.menu ?? "";
// //Remove everything after last '.'
//                       var pos = s.lastIndexOf('t/');
//                       String result = (pos != -1)? s.substring(pos+2): s;
//                       print(" result::${result}");
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => MenuScreen( resName: result,userId: c.itemsDetails.first.item!.userId ?? -1,)));
//
//                       // if(AllMenusGetxController.to.resDetails.isNotEmpty){
//                       //
//                       // print("ID From screen:::${AllMenusGetxController.to.resDetails.first.data!.id.toString()}");
//                       //
//                       // }
//
//                       // MenuApiController().storeFcmTokenVendor(userId: AllMenusGetxController.to.resDetails.first.data!.userId.toString(), token: AllMenusGetxController.to.resDetails.first.token.toString());
//
//                       }
//                                           },
//                                         ),
//                                       ),
//                                     ),
                                    SizedBox(width: 10.w,),

                                    DetailsButton(
                                      iconData: Icons.star_border_rounded,
                                      name: 'اضافة تقييم',
                                      onTap: () {
                                        Scrollable.ensureVisible(
                                            addReview.currentContext!);
                                        focusNode.requestFocus();
                                      },
                                    ),
                                    SizedBox(width: 10.w,),

                                    DetailsButton(
                                      iconData: Icons.info_outline,
                                      name: 'ابلاغ عن محتوى',
                                      onTap: () {
                                        Scrollable.ensureVisible(
                                            report.currentContext!);
                                        focusNode.requestFocus();
                                      },
                                    ),
                                    SizedBox(width: 10.w,),

                                    DetailsButton(
                                      iconData: Icons.add_a_photo_outlined,
                                      name: 'إضافة صورة',
                                      onTap: () {
                                        Scrollable.ensureVisible(
                                            addImage.currentContext!);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                               SizedBox(
                                height: 16.h,
                              ),
                              Column(
                                children: [
                                  DetailsTabBarScreen(
                                      detailsModel: c.itemsDetails.last,
                                      addImage: addImage,
                                      addReview: addReview,
                                      detailsKey: detailsKey,
                                      report: report,
                                      rateKey: rateKey,
                                      focusNode: focusNode),
                                ],
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            )
                :Center(child: Text('لا توجد بيانات'));

            },
          )),
    );
  }
  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
  }
 String getStatus(){

   // c.itemsDetails.last.item!.claims!.isNotEmpty ?
   // c.itemsDetails.last.item!.claims!.where((element) => element.itemClaimStatus == 3).where((element) => element.userId == int.parse(SharedPrefController().id)).isNotEmpty?
   // c.itemsDetails.last.item!.claims!.where((element) => element.itemClaimStatus == 1).where((element) => element.userId == int.parse(SharedPrefController().id)).isNotEmpty ?
   // "العمل مدار بواسطة${ c.itemsDetails.last.item!.claims!.where((element) => element.itemClaimStatus == 3).first.itemClaimFullName}" : 'المطالبة بالعمل تحت المراجعة'
   //     : 'المطالبة بإدارة العمل'
   //     : 'المطالبة بإدارة العمل',

   if(HomeGetxController.to.itemsDetails.last.item!.claims!.isNotEmpty) {
     if(HomeGetxController.to.itemsDetails.last.item!
         .claims!
         .where((element) => element.itemClaimStatus == 3).isNotEmpty){
       if (HomeGetxController.to.itemsDetails.last.item!
           .claims!
           .where((element) => element.itemClaimStatus == 3).first.userId
           .toString()
           .isNotEmpty) {
         return "العمل مدار بواسطة ${ HomeGetxController.to.itemsDetails.last
             .item!.claims!.where((element) => element.itemClaimStatus == 3).first
             .itemClaimFullName}";
       }
     }

     else if (HomeGetxController.to.itemsDetails.last.item!
         .claims!
         .where((element) => element.itemClaimStatus == 1)
         .where((element) =>
     element.userId == int.parse(SharedPrefController().id))
         .isNotEmpty) {
       return 'المطالبة بالعمل تحت المراجعة';
     }
     return 'المطالبة بإدارة العمل';

   }
   else {
   return 'المطالبة بإدارة العمل';
   }
  }
  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunchUrlString(googleUrl)) {
      await launchUrlString(
        googleUrl,
      );
    } else {
      throw 'Could not open the map.';
    }
  }
}

class SaveItemWidget extends StatelessWidget with Helpers {
  final String id;
   SaveItemWidget({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: CircleAvatar(
        backgroundColor: Colors.black.withOpacity(0.4),
        child: IconButton(
            onPressed: () async {

              saveItem(id: id);
            },
            icon: GetX<HomeGetxController>(
              builder: (c) {
                return  Icon(
                c.savedItemsIDS.contains(int.parse(id)) ? Icons.bookmark  :  Icons.bookmark_outline_sharp,
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
      if(HomeGetxController.to.savedItemsIDS.contains(int.parse(id))){
        int index = HomeGetxController.to.savedItemsIDS.indexWhere((element) => element == int.parse(id));
        HomeGetxController.to.savedItemsIDS.removeAt(index);
        HomeGetxController.to.savedItems.removeWhere((element) => element.id == int.parse(id));
        print(HomeGetxController.to.savedItemsIDS);
        bool status = await SaveApiController().unSaveItem(itemId: id);

        if (status) {

          HomeGetxController.to.getSavedItems();

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
      }else{
        HomeGetxController.to.savedItemsIDS.add(int.parse(id));

        bool status = await SaveApiController().saveItem(itemId: id);
        HomeGetxController.to.getSavedItems();
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
              print("Route:: ${Get.currentRoute}");
              // print("Route:: ${Get.forceAppUpdate()}");

              HomeGetxController.to.itemsDetails.removeLast();
print( HomeGetxController.to.itemsDetails.length);
              if(fromNotification != null){
                if(HomeGetxController.to.itemsDetails.isEmpty){
                  Get.offAll(
                      MainScreen()
                  );
                }
              }else{
                Get.back();
              }
              // else{
              //   // if(Get.currentRoute.isNotEmpty){
              //   //   Get.back();
              //   // }
              //
              //   print("1111111");
              //   if(HomeGetxController.to.itemsDetails.isNotEmpty){
              //     print( HomeGetxController.to.itemsDetails.length);
              //     Get.back();
              //     HomeGetxController.to.itemsDetails.value.removeLast();
              //
              //     HomeGetxController.to.itemsDetails.refresh();
              //     print("2222222");
              //
              //   }else{
              //
              //     // print("33333333");
              //     // Get.back();
              //   }
              // }


              print("Route:: ${Get.currentRoute}");
              // Get.back();
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

class DetailsButton extends StatelessWidget {
  final String name;
  final IconData iconData;
  void Function()? onTap;

  DetailsButton(
      {required this.iconData, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        // width: 20.w,
        // height: 70.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: AppColors().mainColor.withOpacity(.05),
              child: Icon(
                iconData,
                color: AppColors().mainColor,
                size: 15.w,
              ),
            ),
             SizedBox(
              height: 5.h,
            ),
            SizedBox(
              width: 50.w,
              child: Text(
                name,
                style: GoogleFonts.notoKufiArabic(
                    textStyle:
                         TextStyle(color: AppColors().mainColor, fontSize: 12.sp)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomPageRouteBuilder<T> extends PageRoute<T> {
  final RoutePageBuilder pageBuilder;
  final PageTransitionsBuilder matchingBuilder = const CupertinoPageTransitionsBuilder(); // Default iOS/macOS (to get the swipe right to go back gesture)
  // final PageTransitionsBuilder matchingBuilder = const FadeUpwardsPageTransitionsBuilder(); // Default Android/Linux/Windows

  CustomPageRouteBuilder({required this.pageBuilder});

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return pageBuilder(context, animation, secondaryAnimation);
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => Duration(milliseconds: 900); // Can give custom Duration, unlike in MaterialPageRoute

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return matchingBuilder.buildTransitions<T>(this, context, animation, secondaryAnimation, child);
  }
}