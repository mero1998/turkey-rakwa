import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:html/parser.dart';
import 'package:rakwa/Core/services/launcher_service.dart';
import 'package:rakwa/Core/utils/extensions.dart';
import 'package:rakwa/Core/utils/view_photo.dart';
import 'package:rakwa/api/api_controllers/comment_api_controller.dart';
import 'package:rakwa/api/api_controllers/menu_api_controller.dart';
import 'package:rakwa/api/api_controllers/review_api_controller.dart';
import 'package:rakwa/app_colors/app_colors.dart';
import 'package:rakwa/controller/all_menu_getx_controller.dart';
import 'package:rakwa/controller/image_picker_controller.dart';
import 'package:rakwa/model/details_model.dart';
import 'package:rakwa/model/res_details.dart';
import 'package:rakwa/screens/add_listing_screens/Controllers/add_work_controller.dart';
import 'package:rakwa/screens/details_screen/details_screen.dart';
import 'package:rakwa/screens/details_screen/gallery_screen/gallery_screen.dart';
import 'package:rakwa/screens/menu/menu_screen.dart';
import 'package:rakwa/screens/messages_screen/create_message.dart';
import 'package:rakwa/Core/utils/helpers.dart';
import 'package:rakwa/widget/TextFields/text_field_default.dart';
import 'package:rakwa/widget/main_elevated_button.dart';
import 'package:rakwa/widget/my_text_field.dart';
import 'package:rakwa/widget/photo_view.dart';
import 'package:rakwa/widget/rate_stars_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../shared_preferences/shared_preferences.dart';
import '../pdf_viewer.dart';

class DetailsTabBarScreen extends StatefulWidget {
  final DetailsModel detailsModel;
  final Key rateKey;
  final Key addImage;
  final Key addReview;
  final Key report;
  final Key detailsKey;
  final FocusNode focusNode;

  DetailsTabBarScreen(
      {required this.detailsModel,
      required this.addImage,
      required this.addReview,
      required  this.report,
      required this.detailsKey,
      required this.rateKey,
      required this.focusNode});

  @override
  State<DetailsTabBarScreen> createState() => _DetailsTabBarScreenState();
}

class _DetailsTabBarScreenState extends State<DetailsTabBarScreen>
    with Helpers {
  late TextEditingController _reviewTextController;
  late TextEditingController _commentTextController;
  late TextEditingController _replayCommentTextController;
  late TextEditingController _reportTextController;
  // final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  final GlobalKey<FormState> _keyComment = GlobalKey();
  final GlobalKey<FormState> _keyReport = GlobalKey();
  final GlobalKey<FormState> _keyReview = GlobalKey();


  ImagePickerController imagePickerController =
      Get.put(ImagePickerController());
  double finalRating = 3;

  bool showWorkHour = false;
  final Set<Marker> _marker = {};
  List<Features> features = [];

  void _setMarker() {
    setState(() {
      _marker.add(Marker(
          markerId: const MarkerId('value'),
          position: LatLng(
              widget.detailsModel.item!.itemLat != null
                  ? double.parse(widget.detailsModel.item!.itemLat!)
                  : 41.0082,
              widget.detailsModel.item!.itemLng != null
                  ? double.parse(widget.detailsModel.item!.itemLng!)
                  : 28.9784),
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(
              title: widget.detailsModel.item!.state != null
                  ? widget.detailsModel.item!.state!.stateName
                  : 'İstanbul',
              snippet: widget.detailsModel.item!.city != null
                  ? widget.detailsModel.item!.city!.cityName
                  : 'İstanbul')));
    });
  }

  @override
  void initState() {
    super.initState();
    _setMarker();
    createFeaturesList();
    if(widget.detailsModel.item!.vendor_id != null){
      AddWorkOrAdsController.to.resId.value = widget.detailsModel.item!.vendor_id.toString();
    }
    _reviewTextController = TextEditingController();
    _commentTextController = TextEditingController();
    _replayCommentTextController = TextEditingController();
    _reportTextController = TextEditingController();

  }

  @override
  void dispose() {
    _reviewTextController.dispose();
    _commentTextController.dispose();
    _replayCommentTextController.dispose();
    _reportTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // physics: const BouncingScrollPhysics(),
      children: [
        // Text(
        //   'التفاصيل',
        //   style: GoogleFonts.notoKufiArabic(
        //       textStyle: const TextStyle(
        //           fontSize: 16,
        //           fontWeight: FontWeight.w700,
        //           color: Colors.black)),
        // ),

        Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                key: widget.detailsKey,
                padding: const EdgeInsets.only(left: 16, right: 16, top: 0),
                child: Text(
                  'الوصف',
                  style: GoogleFonts.notoKufiArabic(
                      textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _parseHtmlString(widget.detailsModel.item!.itemDescription ?? ""),
                  style: GoogleFonts.notoKufiArabic(
                      textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.describtionLabel)),
                ),
              ),
//               Visibility(
//                 visible: widget.detailsModel.item!.menu != null,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(left: 16, right: 16, top: 0),
//                       child: Text(
//                         'المنيو',
//                         style: GoogleFonts.notoKufiArabic(
//                             textStyle: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w700,
//                                 color: Colors.black)),
//                       ),
//                     ),
//                     InkWell(
//                       onTap: () async{
//                         print("Click");
//                         // await OpenFilex.open(widget.detailsModel.pdfUrl);
//                         // if(widget.detailsModel.pdfUrl != null){
//
//
//
//                         if(widget.detailsModel.item!.menu != null){
//                           String s = widget.detailsModel.item!.menu ?? "";
// //Remove everything after last '.'
//                           var pos = s.lastIndexOf('t/');
//                           String result = (pos != -1)? s.substring(pos+2): s;
//                           print(result);
//                         await AllMenusGetxController.to.getResDetails(resName: result);
//                          if(AllMenusGetxController.to.resDetails.isNotEmpty){
//
//                            print("ID From screen:::${AllMenusGetxController.to.resDetails.first.data!.id.toString()}");
//                            Navigator.push(context, MaterialPageRoute(builder: (c) => MenuScreen(resId:  AllMenusGetxController.to.resDetails.first.data!.id.toString(),userId: widget.detailsModel.item!.userId ?? -1,)));
//
//                          }
//
//                           MenuApiController().storeFcmTokenVendor(userId: AllMenusGetxController.to.resDetails.first.data!.userId.toString(), token: AllMenusGetxController.to.resDetails.first.token.toString());
//
//                         }
//                         // }
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Text(
//                           "انقر هنا لمشاهدة المنيو كامل",
//                           style: GoogleFonts.notoKufiArabic(
//                               textStyle:  TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w500,
//                                   color: AppColors().mainColor)),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),


              SizedBox(
                  height: 290.h,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(9.r),
                    child: GoogleMap(
                      markers: _marker,
                      mapType: MapType.normal,
                      myLocationEnabled: false,
                      initialCameraPosition: CameraPosition(
                        zoom: 16,
                        target: LatLng(
                            widget.detailsModel.item!.itemLat != null
                                ? double.parse(
                                    widget.detailsModel.item!.itemLat!)
                                : 41.0082,
                            widget.detailsModel.item!.itemLng != null
                                ? double.parse(
                                    widget.detailsModel.item!.itemLng!)
                                : 28.9784),
                      ),
                    ),
                  )),
               SizedBox(
                height: 12.h,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: widget.detailsModel.item!.itemAddress != null
                    ? InkWell(
                        onTap: () {
                          openMap(
                              widget.detailsModel.item!.itemLat != null
                                  ? double.parse(
                                      widget.detailsModel.item!.itemLat!)
                                  : 41.0082,
                              widget.detailsModel.item!.itemLng != null
                                  ? double.parse(
                                      widget.detailsModel.item!.itemLng!)
                                  : 28.9784);
                        },
                        child: Row(
                          children: [
                             Icon(
                              Icons.location_on_outlined,
                              color: AppColors().mainColor,
                            ),
                             SizedBox(
                              width: 12.w,
                            ),
                            SizedBox(
                              width: Get.width * 0.7.w,
                              child: Text(
                                widget.detailsModel.item!.itemAddress!
                                    .toString(),
                                style:  TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.titleBlack,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Row(
                        children:  [
                          Icon(
                            Icons.location_on_outlined,
                          ),
                          SizedBox(
                            width: 12.w,
                          ),
                          Text(
                            'İstanbul',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.describtionLabel),
                          ),
                        ],
                      ),
              ),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: MainElevatedButton(
                  child: Text('الاتجاهات'),
                  height: 56.h,
                  width: Get.width,
                  borderRadius: 12.r,
                  onPressed: () {
                    openMap(
                        widget.detailsModel.item!.itemLat != null
                            ? double.parse(widget.detailsModel.item!.itemLat!)
                            : 41.0082,
                        widget.detailsModel.item!.itemLng != null
                            ? double.parse(widget.detailsModel.item!.itemLng!)
                            : 28.9784);
                  },
                ),
              ),
            ],
          ),
        ),

        const SizedBox(
          height: 18,
        ),

        Container(
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              widget.detailsModel.item!.itemHours!.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(
                        right: 16,
                        left: 16,
                      ),
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            showWorkHour = !showWorkHour;
                            print(showWorkHour);
                          });
                        },
                        title: Text(
                          'ساعات العمل',
                          style: GoogleFonts.notoKufiArabic(
                              textStyle: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                        trailing: Icon(
                          !showWorkHour
                              ? Icons.arrow_drop_down
                              : Icons.arrow_drop_up_rounded,
                          size: 32,
                        ),
                      ),
                    )
                  : const SizedBox(),
              Visibility(
                  visible: showWorkHour,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                        color: AppColors.subTitleColor.withOpacity(.2),
                        borderRadius: BorderRadius.circular(12)),
                    height: 300,
                    child: Center(
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 1,
                          );
                        },
                        itemCount: widget.detailsModel.item!.itemHours!.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: index % 2 == 0
                                    ? Colors.white
                                    : AppColors.controlPanelView),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(widget.detailsModel.item!.itemHours![index]
                                            .itemHourDayOfWeek ==
                                        1
                                    ? 'الاثنين'
                                    : widget
                                                .detailsModel
                                                .item!
                                                .itemHours![index]
                                                .itemHourDayOfWeek ==
                                            2
                                        ? 'الثلاثاء'
                                        : widget
                                                    .detailsModel
                                                    .item!
                                                    .itemHours![index]
                                                    .itemHourDayOfWeek ==
                                                3
                                            ? 'الاربعاء'
                                            : widget
                                                        .detailsModel
                                                        .item!
                                                        .itemHours![index]
                                                        .itemHourDayOfWeek ==
                                                    4
                                                ? 'الخميس'
                                                : widget
                                                            .detailsModel
                                                            .item!
                                                            .itemHours![index]
                                                            .itemHourDayOfWeek ==
                                                        5
                                                    ? 'الجمعة'
                                                    : widget
                                                                .detailsModel
                                                                .item!
                                                                .itemHours![
                                                                    index]
                                                                .itemHourDayOfWeek ==
                                                            6
                                                        ? 'السبت'
                                                        : widget
                                                                    .detailsModel
                                                                    .item!
                                                                    .itemHours![
                                                                        index]
                                                                    .itemHourDayOfWeek ==
                                                                7
                                                            ? 'الاحد'
                                                            : ''),
                                const Spacer(),
                                Text(
                                    '${widget.detailsModel.item!.itemHours![index].itemHourOpenTime}-'),
                                Text(
                                    '${widget.detailsModel.item!.itemHours![index].itemHourCloseTime}'),
                                const Spacer(),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  )),
              widget.detailsModel.item!.itemHours!.isNotEmpty
                  ? const Divider(
                      color: AppColors.describtionLabel,
                    )
                  : const SizedBox(),
              widget.detailsModel.item!.email != null
                  ? Padding(
                      padding: const EdgeInsets.only(
                        right: 16,
                        left: 16,
                      ),
                      child: ListTile(
                        onTap: () {
                          LauncherServices.launchToMail(widget.detailsModel.item!.email ?? "");
                          // launchUrlString(
                          //     'mailto:${widget.detailsModel.item!.email}?subject=This is Subject Title&body=This is Body of Email');
                        },
                        title: Text(
                          'البريد الالكتروني',
                          style: GoogleFonts.notoKufiArabic(
                              textStyle: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                        subtitle: Text(widget.detailsModel.item!.email ?? ""),
                        trailing: const Icon(Icons.email),
                      ),
                    )
                  : const SizedBox(),
              widget.detailsModel.item!.email != null
                  ? const Divider(
                      color: AppColors.describtionLabel,
                    )
                  : const SizedBox(),
              widget.detailsModel.item!.itemPhone != null
                  ? Padding(
                      padding: const EdgeInsets.only(
                        right: 16,
                        left: 16,
                      ),
                      child: ListTile(
                        onTap: () {
                          launchUrlString(
                              "tel://${widget.detailsModel.item!.itemPhone}");
                        },
                        title: Text(
                          'مكالمة',
                          style: GoogleFonts.notoKufiArabic(
                              textStyle: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                        subtitle: Text(widget.detailsModel.item!.itemPhone!.replaceAll("+", "00")),
                        // : null,
                        trailing: const Icon(Icons.phone_android_rounded),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
        features.isNotEmpty
            ? const SizedBox(
                height: 16,
              )
            : const SizedBox(),

        features.isNotEmpty
            ? Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Text(
                        'المميزات',
                        style: GoogleFonts.notoKufiArabic(
                            textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.black)),
                      ),
                    ),
                    const SizedBox(
                      height: 11,
                    ),
                    Container(
                      height: features.length == 1
                          ? 50
                          : features.length == 2
                              ? 100
                              : features.length == 3
                                  ? 150
                                  : features.length == 4
                                      ? 200
                                      : features.length == 5
                                          ? 250
                                          : features.length == 6
                                              ? 300
                                              : features.length == 7
                                                  ? 350
                                                  : 400,
                      // padding: const EdgeInsets.symmetric(horizontal: 16),
                      color: const Color(0xFFF9F7FA),
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                        physics: const ScrollPhysics(),
                        itemCount: features.length,
                        itemBuilder: (context, index) {
                          return SizedBox(
                            height: 45,
                            child: Row(
                              children: [
                                Expanded(
                                    child: features[index].customFieldId == 5
                                        ? Text('متوفر')
                                        : features[index].customFieldId == 2
                                            ? Text('مواقف سيارات')
                                            : features[index].customFieldId == 1
                                                ? Text('معدل الاسعار')
                                                : features[index]
                                                            .customFieldId ==
                                                        3
                                                    ? Text('Wi-fi ')
                                                    : features[index]
                                                                .customFieldId ==
                                                            8
                                                        ? Text('الوجبات')
                                                        : features[index]
                                                                    .customFieldId ==
                                                                48
                                                            ? Text('تخصص')
                                                            : Text('خدمات')),
                                Expanded(
                                    child: Text(
                                  features[index].itemFeatureValue ??
                                      'Features',
                                  overflow: TextOverflow.ellipsis,
                                ))
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              )
            : SizedBox(),

        widget.detailsModel.item!.galleries != null &&
                widget.detailsModel.item!.galleries!.isNotEmpty
            ? Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 18,
                    ),
                    Padding(
                      padding:  EdgeInsets.only(left: 16.w, right: 16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'الصور والفيديوهات',
                            style: GoogleFonts.notoKufiArabic(
                                textStyle:  TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black)),
                          ),
                          IconButton(
                              onPressed: () {
                                Get.to(() => GalleryScreen(
                                    galleries:
                                        widget.detailsModel.item!.galleries!));
                              },
                              icon: const Icon(Icons.arrow_forward_outlined))
                        ],
                      ),
                    ),
                     SizedBox(
                      height: 11.h,
                    ),
                    SizedBox(
                      height: 157.h,
                      child: ListView.separated(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            List<String> photos = [];
                            for (var item
                                in widget.detailsModel.item!.galleries!) {
                              photos.add(
                                  'https://www.rakwa.com/laravel_project/public/storage/item/gallery/${item.itemImageGalleryName}');
                            }
                            return ImageViewWidget(
                                photos: photos,
                                photo: widget.detailsModel.item!
                                    .galleries![index].itemImageGalleryName!,
                         );
                          },
                          separatorBuilder: (context, index) {
                            return  SizedBox(
                              width: 8.w,
                            );
                          },
                          itemCount:
                              widget.detailsModel.item!.galleries!.length),
                    ),
                     SizedBox(
                      height: 24.h,
                    ),
                  ],
                ),
              )
            : const SizedBox(),
        // Container(
        //   color: Colors.grey.shade400,
        //   width: double.infinity,
        //   height: 120.h,
        //   alignment: AlignmentDirectional.center,
        //   child: Text("مساحة اعلانية",style: TextStyle(
        //       color: Colors.white,
        //       fontWeight: FontWeight.bold,
        //       fontSize: 20.sp
        //   ),
        //           ),
        // ),

        // Container(
        //   // padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        //   decoration: const BoxDecoration(color: Colors.white),
        //   child: Column(
        //     children: [
        //       // SizedBox(
        //       //     height: 280,
        //       //     width: double.infinity,
        //       //     child: GoogleMap(
        //       //       markers: _marker,
        //       //       mapType: MapType.normal,
        //       //       myLocationEnabled: false,
        //       //       initialCameraPosition: CameraPosition(
        //       //         zoom: 18,
        //       //         target: LatLng(
        //       //             widget.detailsModel.item!.itemLat != null
        //       //                 ? double.parse(widget.detailsModel.item!.itemLat!)
        //       //                 : 41.0082,
        //       //             widget.detailsModel.item!.itemLng != null
        //       //                 ? double.parse(widget.detailsModel.item!.itemLng!)
        //       //                 : 28.9784),
        //       //       ),
        //       //     )),
        //       // const SizedBox(
        //       //   height: 12,
        //       // ),
        //       // widget.detailsModel.item!.itemAddress != null
        //       //     ? InkWell(
        //       //         onTap: () {
        //       //           openMap(
        //       //               widget.detailsModel.item!.itemLat != null
        //       //                   ? double.parse(
        //       //                       widget.detailsModel.item!.itemLat!)
        //       //                   : 41.0082,
        //       //               widget.detailsModel.item!.itemLng != null
        //       //                   ? double.parse(
        //       //                       widget.detailsModel.item!.itemLng!)
        //       //                   : 28.9784);
        //       //         },
        //       //         child: Text(
        //       //           widget.detailsModel.item!.itemAddress!.toString(),
        //       //           style: GoogleFonts.notoKufiArabic(
        //       //               textStyle: const TextStyle(
        //       //                   fontSize: 12,
        //       //                   fontWeight: FontWeight.w400,
        //       //                   color: AppColors.describtionLabel)),
        //       //         ),
        //       //       )
        //       //     : Text(
        //       //         'İstanbul',
        //       //         style: GoogleFonts.tajawal(
        //       //             textStyle: const TextStyle(
        //       //                 fontSize: 14,
        //       //                 fontWeight: FontWeight.w500,
        //       //                 color: AppColors.describtionLabel)),
        //       //       ),
        //       // const SizedBox(
        //       //   height: 16,
        //       // ),
        //       // Padding(
        //       //   padding: const EdgeInsets.symmetric(horizontal: 16),
        //       //   child: MainElevatedButton(
        //       //     child: Text('الاتجاهات'),
        //       //     height: 56,
        //       //     width: Get.width,
        //       //     borderRadius: 12,
        //       //     onPressed: () {
        //       //       openMap(
        //       //           widget.detailsModel.item!.itemLat != null
        //       //               ? double.parse(widget.detailsModel.item!.itemLat!)
        //       //               : 41.0082,
        //       //           widget.detailsModel.item!.itemLng != null
        //       //               ? double.parse(widget.detailsModel.item!.itemLng!)
        //       //               : 28.9784);
        //       //     },
        //       //   ),
        //       // ),
        //     ],
        //   ),
        // ),

         SizedBox(
          height: 16.h,
        ),
        Container(
          height: 100.h,

          color: Colors.white,
          // padding:  EdgeInsets.symmetric(vertical: 18.h),
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding:  EdgeInsets.only(left: 16.w, right: 16.w),
                child: Text(
                  'التواصل مع ادارة العمل',
                  style: GoogleFonts.notoKufiArabic(
                      textStyle:  TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.black)),
                ),
              ),
               SizedBox(
                height: 15.h,
              ),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Get.to(() => CreateMessage(
                          itemId: widget.detailsModel.item!.id.toString()));
                    },
                    child: Column(
                      children: [
                        Icon(Icons.message, color: AppColors().mainColor,size: 15.w,),
                        Expanded(
                          child: Text('أرسل رسالة', style: GoogleFonts.notoKufiArabic(
                            textStyle:  TextStyle(
                              color: AppColors().mainColor,
                              fontSize: 10.sp
                            ),)),
                        )
                      ],
                    ),
                  ),
                  const VerticalDivider(
                    color: Color(0xffF4F4F4),
                    thickness: 1,
                  ),
                  InkWell(
                    onTap: () {
                      final data =
                          ClipboardData(text: widget.detailsModel.url ?? "");
                      Clipboard.setData(data);
                      Fluttertoast.showToast(
                          msg: "تم نسخ الرابط",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black54,
                          textColor: Colors.white,
                          fontSize: 16.0.sp);
                    },
                    child: Column(
                      children:  [
                        Icon(Icons.copy, color: AppColors().mainColor,size: 15.w,),
                        Expanded(
                          child: Text('نسخ الرابط', style: GoogleFonts.notoKufiArabic(
                            textStyle:  TextStyle(
                              color: AppColors().mainColor,
                              fontSize: 10.sp
                            ),)),
                        )
                      ],
                    ),
                  ),
                ],
              ))
            ],
          ),
        ),
         SizedBox(
          height: 16.h,
        ),

        Form(
          key: _keyReview,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  key: widget.addReview,
                  padding: const EdgeInsets.only(
                    right: 16,
                    left: 16,
                  ),
                  child: TextFieldDefault(
                    upperTitle: "اكتب تقييم",
                    hint: 'قم بإدخل تقييمك و ملاحاظاتك ...',
                    controller: _reviewTextController,
                    keyboardType: TextInputType.name,
                    maxLines: 5,
                    onComplete: () {
                      widget.focusNode;

                      if(_keyReview.currentState!.validate()){
                        createReview(
                          id: widget.detailsModel.item!.id.toString(),
                          reviewImageGalleries:
                          imagePickerController.image_file != null
                              ? imagePickerController.image_file!.path
                              : null,
                          rating: finalRating.toString(),
                          title: _reviewTextController.text,
                          body: _reviewTextController.text,
                          recommend: '1',
                        );
                      }
                    },
                    validation: (value){
                      if(value!.isEmpty){
                        return "يجب عليك ادخال تقييمك";
                      }else{
                        return null;
                      }
                    },

                  ),
                ),
                 SizedBox(
                  height: 8.h,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: RatingBar.builder(
                    initialRating: finalRating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) =>  Icon(
                      Icons.star,
                      color: AppColors().mainColor,
                      size: 15.w,
                    ),
                    onRatingUpdate: (rating) {
                      finalRating = rating;
                      print(finalRating);
                    },
                  ),
                ),
                 SizedBox(
                  height: 8.h,
                ),
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 16.w),
                  child: SizedBox(
                    height: 70.h,
                    child: Row(
                      children: [
                        Expanded(
                            key: widget.addImage,
                            child: GetBuilder<ImagePickerController>(
                              builder: (controller) {
                                return controller.image_file == null
                                    ? Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5.r),
                                          border: Border.all(
                                            color: AppColors().mainColor,
                                          ),
                                        ),
                                        child: TextButton(
                                            onPressed: () {
                                              imagePickerController
                                                  .getImageFromGallary();
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'تحميل صورة',
                                              style: GoogleFonts.notoKufiArabic(
                                                textStyle:  TextStyle(
                                                  color: AppColors().mainColor,
                                                ),)
                                                ),
                                                 SizedBox(
                                                  width: 5.w,
                                                ),
                                                 Icon(
                                                  Icons.upload,
                                                  color: AppColors().mainColor,
                                                  size: 20.w,
                                                ),
                                              ],
                                            )),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          imagePickerController
                                              .getImageFromGallary();
                                        },
                                        child: Image.file(
                                          File(imagePickerController
                                              .image_file!.path),
                                          height: 70.h,
                                        ),
                                      );
                              },
                            )),
                         SizedBox(
                          width: 8.w,
                        ),
                        Expanded(
                            child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: AppColors().mainColor,
                            ),
                          ),
                          child: TextButton(
                              onPressed: () {
                                print(_keyReview.currentState!.validate());
                                if(_keyReview.currentState!.validate()){
                                  print("we are here");
                                  createReview(
                                    id: widget.detailsModel.item!.id.toString(),
                                    reviewImageGalleries:
                                    imagePickerController.image_file != null
                                        ? imagePickerController.image_file!.path
                                        : null,
                                    rating: finalRating.toString(),
                                    title: _reviewTextController.text,
                                    body: _reviewTextController.text,
                                    recommend: '1',
                                  );
                                }else{
                                  print("not validate");
                                }

                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'ارسال',
                                    style: GoogleFonts.notoKufiArabic(
                                        color: AppColors().mainColor),
                                  ),
                                   SizedBox(
                                    width: 5.w,
                                  ),
                                   Icon(
                                    Icons.add_circle_outline_sharp,
                                    color: AppColors().mainColor,
                                    size: 20.sp,
                                  ),
                                ],
                              )),
                        )),
                      ],
                    ),
                  ),
                ),

                Form(
                  key: _keyComment,
                  child: Padding(
                    // key: widget.addReview,
                    padding: const EdgeInsets.only(
                      right: 16,
                      left: 16,
                    ),
                    child: TextFieldDefault(
                      upperTitle: "اكتب تعليق",
                      hint: 'قم بإدخل تعليقك و ملاحاظاتك ...',
                      controller: _commentTextController,
                      keyboardType: TextInputType.name,
                      maxLines: 5,
                      validation: (value){
                        if(value!.isEmpty){
                          return "يجب عليك ادخال تعليقك";
                        }else{
                         return null;
                        }
                      },
                      onComplete: () async{
                        widget.focusNode;
                        if(_keyComment.currentState!.validate()){
                          bool success = await  CommentApiController().createComment(
                              commentable_id: widget.detailsModel.item!.id.toString(),
                              message: _commentTextController.text);
                          if(success){
                            _commentTextController.text = "";
                          }
                        }
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: AppColors().mainColor,
                      ),
                    ),
                    child: TextButton(
                        onPressed: () async {
                          if(_keyComment.currentState!.validate()){
                            bool success = await  CommentApiController().createComment(
                                commentable_id: widget.detailsModel.item!.id.toString(),
                                message: _commentTextController.text);
                            if(success){
                              _commentTextController.text = "";
                            }
                          }

                      },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'ارسال',
                              style: GoogleFonts.notoKufiArabic(
                                  color: AppColors().mainColor),
                            ),
                             SizedBox(
                              width: 5.w
                            ),
                             Icon(
                              Icons.add_circle_outline_sharp,
                              color: AppColors().mainColor,
                              size: 20.sp,
                            ),
                          ],
                        )),
                  ),
                )
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),

        Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                key: widget.rateKey,
                padding: const EdgeInsets.only(right: 16, left: 16),
                child: Text(
                  'تقييمات',
                  style: GoogleFonts.notoKufiArabic(
                      textStyle:  TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.black)),
                ),
              ),
               SizedBox(
                height: 12.h,
              ),
              widget.detailsModel.reviews!.isNotEmpty
                  ? SizedBox(
                      height: 250.h,
                      child: ListView.separated(
                        padding:
                             EdgeInsets.only(right: 16.w, left: 16.w, top: 16.h),
                        separatorBuilder: (context, index) {
                          return const Divider(
                            color: AppColors.describtionLabel,
                          );
                        },
                        physics: const ScrollPhysics(),
                        itemCount: widget.detailsModel.reviews!.length,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      widget.detailsModel.reviews![index].title!,
                                      style: GoogleFonts.notoKufiArabic(
                                          textStyle: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      )),
                                    ),
                                  ),
                                   SizedBox(
                                    width: 24.w,
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: widget.detailsModel
                                                      .reviews![index].rating ==
                                                  null
                                              ? Colors.grey
                                              : widget
                                                          .detailsModel
                                                          .reviews![index]
                                                          .rating! >=
                                                      1
                                                  ? AppColors().rateColor
                                                  : Colors.grey,
                                          // size: 12,
                                        ),
                                        Icon(
                                          Icons.star,
                                          color: widget.detailsModel
                                                      .reviews![index].rating ==
                                                  null
                                              ? Colors.grey
                                              : widget
                                                          .detailsModel
                                                          .reviews![index]
                                                          .rating! >=
                                                      2
                                                  ? AppColors().rateColor
                                                  : Colors.grey,
                                          // size: 12,
                                        ),
                                        Icon(
                                          Icons.star,
                                          color: widget.detailsModel
                                                      .reviews![index].rating ==
                                                  null
                                              ? Colors.grey
                                              : widget
                                                          .detailsModel
                                                          .reviews![index]
                                                          .rating! >=
                                                      3
                                                  ? AppColors().rateColor
                                                  : Colors.grey,
                                          // size: 12,
                                        ),
                                        Icon(
                                          Icons.star,
                                          color: widget.detailsModel
                                                      .reviews![index].rating ==
                                                  null
                                              ? Colors.grey
                                              : widget
                                                          .detailsModel
                                                          .reviews![index]
                                                          .rating! >=
                                                      4
                                                  ? AppColors().rateColor
                                                  : Colors.grey,
                                          // size: 12,
                                        ),
                                        Icon(
                                          Icons.star,
                                          color: widget.detailsModel
                                                      .reviews![index].rating ==
                                                  null
                                              ? Colors.grey
                                              : widget
                                                          .detailsModel
                                                          .reviews![index]
                                                          .rating! >=
                                                      5
                                                  ? AppColors().rateColor
                                                  : Colors.grey,
                                          // size: 12,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                               SizedBox(
                                height: 24.h,
                              ),
                              Container(
                                margin:
                                     EdgeInsets.symmetric(horizontal: 10.w),
                                child: Text(
                                  widget.detailsModel.reviews![index].body!,
                                  style: GoogleFonts.notoKufiArabic(
                                      textStyle:  TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                  )),
                                ),
                              ),
                            ],
                          );
                        },
                      ))
                  : Center(
                      child: Text(
                        'لا توجد اي تقييمات',
                        style: GoogleFonts.notoKufiArabic(
                            textStyle:  TextStyle(
                          fontSize: 10.sp,
                        )),
                      ),
                    ),
            ],
          ),
        ),
         SizedBox(
          height: 16.h,
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                // key: widget.rateKey,
                padding: const EdgeInsets.only(right: 16, left: 16),
                child: Text(
                  'تعليقات',
                  style: GoogleFonts.notoKufiArabic(
                      textStyle:  TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.black)),
                ),
              ),
               SizedBox(
                height: 12.h,
              ),
              widget.detailsModel.allComments!.isNotEmpty
                  ? ListView.separated(
                shrinkWrap: true,

                    padding:
                    const EdgeInsets.only(right: 16, left: 16, top: 16),
                    separatorBuilder: (context, index) {
                      return const Divider(
                        color: AppColors.describtionLabel,
                      );
                    },
                    physics: const ScrollPhysics(),
                    itemCount: widget.detailsModel.allComments!.where((element) => element.childId == null).length,
                    itemBuilder: (context, index) {
                  RxList<bool> hide = RxList.generate(widget.detailsModel.allComments!.where((element) => element.childId == null).length, (i) => false);
                  RxList<TextEditingController> controllers = RxList.generate(widget.detailsModel.allComments!.where((element) => element.childId == null).length, (i) => TextEditingController());
                  print(hide);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                            ),
                            child:     Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      widget.detailsModel.allComments![index].commenter!.name ?? "",
                                      style: GoogleFonts.notoKufiArabic(
                                          textStyle:  TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w700,
                                          )),
                                    ),

                                    Text(
                                      widget.detailsModel.allComments![index].createdAt ?? "",
                                      style: GoogleFonts.notoKufiArabic(
                                          textStyle:  TextStyle(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w700,
                                          )),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Text(
                                      widget.detailsModel.allComments![index].comment!,
                                      style: GoogleFonts.notoKufiArabic(
                                          textStyle:  TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w700,
                                          )),
                                    ),
                                    InkWell(
                                      onTap: (){
                                        // setState(() {
                                          hide[index] = !hide[index];
                                          print("hide:::: ${hide[index]}");
                                        // });
                                      },
                                      child: Text(
                                        "رد",
                                        style: GoogleFonts.notoKufiArabic(
                                            textStyle:  TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w700,
                                            )),
                                      ),
                                    ),
                                  Obx(() => Visibility(
                                    visible: hide[index],
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Padding(
                                            // key: widget.addReview,
                                            padding: const EdgeInsets.only(
                                              right: 16,
                                              left: 16,
                                            ),
                                            child: TextFieldDefault(
                                              upperTitle: "",
                                              hint: 'قم بادخال ردك',
                                              controller: controllers[index],
                                              keyboardType: TextInputType.name,
                                              maxLines: 1,
                                              onComplete: () {
                                                // widget.focusNode;
                                              },
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                borderRadius: BorderRadius.circular(5),
                                                border: Border.all(
                                                  color: AppColors().mainColor,
                                                ),
                                              ),
                                              child: TextButton(
                                                  onPressed: () async {
                                                 bool success =  await CommentApiController().createReplayComment(
                                                        comment_id: widget.detailsModel.allComments![index].id.toString(),
                                                        message: controllers[index].text);
                                                  if(success){
                                                    controllers[index].text = "";
                                                  }
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        'ارسال',
                                                        style: GoogleFonts.notoKufiArabic(
                                                            color: AppColors().mainColor),
                                                      ),
                                                       SizedBox(
                                                        width: 5.w,
                                                      ),
                                                       Icon(
                                                        Icons.add_circle_outline_sharp,
                                                        color: AppColors().mainColor,
                                                        size: 20.w,
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ))
                                  ],
                                ),
                              ],
                            ),

                          ),
                          ListView.builder(
                              itemCount: widget.detailsModel.allComments!.where((element) => element.childId == widget.detailsModel.allComments![index].id).length,
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemBuilder: (context, i){
                                RxList<bool> hide2 = RxList.generate(widget.detailsModel.allComments!.where((element) => element.childId == widget.detailsModel.allComments![index].id).length, (i) => false);
                                RxList<TextEditingController> controllers2 = RxList.generate(widget.detailsModel.allComments!.where((element) => element.childId == widget.detailsModel.allComments![index].id).length, (i) => TextEditingController());
                                return  Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "رداً على تعليق ${widget.detailsModel.allComments!.where((element) => element.childId == widget.detailsModel.allComments![index].id).toList()[i].commenter!.name ?? ""}",
                                      style: GoogleFonts.notoKufiArabic(
                                          textStyle:  TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w700,
                                          )),
                                    ),
                                    Text(
                                      widget.detailsModel.allComments!.where((element) => element.childId == widget.detailsModel.allComments![index].id).toList()[i].comment ?? "",
                                      style: GoogleFonts.notoKufiArabic(
                                          textStyle:  TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w700,
                                          )),
                                    ),
                                    InkWell(
                                      onTap:() => hide2[i] = !hide2[i],
                                      child: Text(
                                        "رد",
                                        style: GoogleFonts.notoKufiArabic(
                                            textStyle:  TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w700,
                                            )),
                                      ),
                                    ),
                                    Obx(() => Visibility(
                                      visible: hide2[i],
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Padding(
                                              // key: widget.addReview,
                                              padding: const EdgeInsets.only(
                                                right: 16,
                                                left: 16,
                                              ),
                                              child: TextFieldDefault(
                                                upperTitle: "",
                                                hint: 'قم بادخال ردك',
                                                controller: controllers2[i],
                                                keyboardType: TextInputType.name,
                                                maxLines: 1,
                                                onComplete: () {
                                                  // widget.focusNode;
                                                },
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  borderRadius: BorderRadius.circular(5),
                                                  border: Border.all(
                                                    color: AppColors().mainColor,
                                                  ),
                                                ),
                                                child: TextButton(
                                                    onPressed: () async{
                                                  bool  success =  await CommentApiController().createReplayComment(
                                                          comment_id: widget.detailsModel.allComments!.where((element) => element.childId == widget.detailsModel.allComments![index].id).toList()[i].id.toString(),
                                                          message: controllers2[i].text);

                                                  if(success) {
                                                    controllers2[i].text = "";
                                                  }
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          'ارسال',
                                                          style: GoogleFonts.notoKufiArabic(
                                                              color: AppColors().mainColor),
                                                        ),
                                                         SizedBox(
                                                          width: 5.w,
                                                        ),
                                                         Icon(
                                                          Icons.add_circle_outline_sharp,
                                                          color: AppColors().mainColor,
                                                          size: 20.w,
                                                        ),
                                                      ],
                                                    )),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ))
                                  ],
                                );
                              }),


                        ],
                      );
                    },
                  )
                  : Center(
                child: Text(
                  'لا توجد اي تعليقات',
                  style: GoogleFonts.notoKufiArabic(
                      textStyle:  TextStyle(
                        fontSize: 10.sp,
                      )),
                ),
              ),
            ],
          ),
        ),
         SizedBox(
          height: 16.h,
        ),
        Container(
          decoration: const BoxDecoration(color: Colors.white),
          child: Form(
            key: _keyReport,
            child: Column(
              children: [
                Padding(
                  key: widget.report,
                  padding: const EdgeInsets.only(
                    right: 16,
                    left: 16,
                  ),
                  child: TextFieldDefault(
                    upperTitle: "ابلاغ عن محتوى",
                    hint: 'قم بإدخل وصف عن المحتوى الذي تريد الابلاغ عنه ...',
                    controller: _reportTextController,
                    keyboardType: TextInputType.name,
                    maxLines: 5,
                    onComplete: () async{
                      widget.focusNode;
                      if(_keyReport.currentState!.validate()){
                        bool success = await  CommentApiController().createReport(
                            item_id: widget.detailsModel.item!.id.toString(),
                            description: _reportTextController.text
                        );
                        if(success){
                          _reportTextController.text = "";
                        }
                      }
                    },
                    validation: (value){
                      if(value!.isEmpty){
                        return "يجب عليك كتابة وصف عن الابلاغ";
                      }else{
                        return null;
                      }
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: AppColors().mainColor,
                      ),
                    ),
                    child: TextButton(
                        onPressed: () async {
                          if(_keyReport.currentState!.validate()){
                            bool success = await  CommentApiController().createReport(
                                item_id: widget.detailsModel.item!.id.toString(),
                                description: _reportTextController.text
                            );
                            if(success){
                              _reportTextController.text = "";
                            }
                          }

                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'ارسال',
                              style: GoogleFonts.notoKufiArabic(
                                  color: AppColors().mainColor),
                            ),
                             SizedBox(
                              width: 5.w,
                            ),
                             Icon(
                              Icons.add_circle_outline_sharp,
                              color: AppColors().mainColor,
                              size: 20.w,
                            ),
                          ],
                        )),
                  ),
                ),
              ],
            ),
          ),

        ),
         SizedBox(
          height: 16.h,
        ),
        Container(
          padding:  EdgeInsets.symmetric(vertical: 16.h),
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:  EdgeInsets.only(
                  right: 16.w,
                  left: 16.w,
                ),
                child: Text(
                  'عناصر مشابهة',
                  style: GoogleFonts.notoKufiArabic(
                      textStyle:  TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.black)),
                ),
              ),
              // const SizedBox(
              //   height: 12,
              // ),
              widget.detailsModel.similarItems != null &&
                      widget.detailsModel.similarItems!.isNotEmpty
                  ? SizedBox(
                      height: widget.detailsModel.similarItems!.length >= 3
                          ? 480.h
                          : widget.detailsModel.similarItems!.length >= 2
                              ? 320.h
                              : 160.h,
                      child: ListView.separated(
                        padding:
                             EdgeInsets.only(right: 16.w, left: 16.w, top: 16.h),
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, index) {
                          return  SizedBox(
                              height: 32.h,
                              child: Divider(
                                color: AppColors.describtionLabel,
                              ));
                        },
                        itemCount: widget.detailsModel.similarItems!.length >= 3
                            ? 3
                            : widget.detailsModel.similarItems!.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return DetailsScreen(
                                      id: widget.detailsModel
                                          .similarItems![index].id!.toString());
                                },
                              ));
                            },
                            child: SizedBox(
                              width: Get.width,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Image.network(
                                        'https://www.rakwa.com/laravel_project/public/storage/item/${widget.detailsModel.similarItems![index].itemImage}',
                                        height: 100.h,
                                        width: 100.w,
                                        fit: BoxFit.cover,
                                        errorBuilder: (BuildContext context, Object? exception, StackTrace? stackTrace) {
                                          return Image.asset("images/logo.jpg",
                                            height: 100.h,
                                            width: 100.w,
                                          );
                                        })),
                                  ),
                                   SizedBox(
                                    width: 15.w,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: Get.width * 0.5.w,
                                        child: Text(
                                          widget.detailsModel
                                              .similarItems![index].itemTitle!,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.notoKufiArabic(
                                              textStyle:  TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16.sp)),
                                        ),
                                      ),
                                       SizedBox(
                                        height: 5.h,
                                      ),
                                      RateStarsWidget(
                                          rate: widget
                                                      .detailsModel
                                                      .similarItems![index]
                                                      .itemAverageRating ==
                                                  null
                                              ? null
                                              : double.parse(widget
                                                  .detailsModel
                                                  .similarItems![index]
                                                  .itemAverageRating)),
                                       SizedBox(
                                        height: 5.h,
                                      ),
                                      SizedBox(
                                        width: Get.width * 0.6.w,
                                        child: Text(
                                          _parseHtmlString(widget
                                              .detailsModel
                                              .similarItems![index]
                                              .itemDescription
                                              .toString()),
                                          style: GoogleFonts.notoKufiArabic(
                                              textStyle: const TextStyle(
                                                  color: AppColors
                                                      .describtionLabel)),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                       SizedBox(
                                        height: 24.h,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : Center(
                      child: Text(
                        'لا توجد اي عناصر مشابهة',
                        style: GoogleFonts.notoKufiArabic(
                            textStyle:  TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                        )),
                      ),
                    ),

            ],
          ),
        ),
         SizedBox(
          height: 16.h,
        ),

        widget.detailsModel.item!.itemSocialFacebook == null &&
                widget.detailsModel.item!.itemSocialInstagram == null &&
                widget.detailsModel.item!.itemWebsite == null &&
                widget.detailsModel.item!.itemSocialTwitter == null
            ? const SizedBox()
            : Container(
                padding:  EdgeInsets.symmetric(vertical: 16.h),
                decoration: const BoxDecoration(color: Colors.white),
                height: 140.h,
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       SizedBox(
                        height: 24.h,
                      ),
                      Text(
                        'قم بزيارة مواقع التواصل الاجتماعي الخاص بنا',
                        style: GoogleFonts.notoKufiArabic(
                            textStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                        )),
                      ),
                       SizedBox(
                        height: 15.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Visibility(
                              visible: widget
                                      .detailsModel.item!.itemSocialFacebook !=
                                  null,
                              child: InkWell(
                                  onTap: () async {
                                    if (await canLaunchUrlString(widget
                                        .detailsModel
                                        .item!
                                        .itemSocialFacebook!)) {
                                      launchUrlString(
                                          widget.detailsModel.item!
                                              .itemSocialFacebook!,
                                          mode: LaunchMode.externalApplication);
                                    }
                                  },
                                  child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child:
                                          Image.asset('images/Facebook.png')))),
                          Visibility(
                              visible:
                                  widget.detailsModel.item!.itemSocialTwitter !=
                                      null,
                              child: InkWell(
                                  onTap: () async {
                                    if (await canLaunchUrlString(widget
                                        .detailsModel
                                        .item!
                                        .itemSocialTwitter!)) {
                                      launchUrlString(
                                          widget.detailsModel.item!
                                              .itemSocialTwitter!,
                                          mode: LaunchMode.externalApplication);
                                    }
                                  },
                                  child: Container(
                                      margin:  EdgeInsets.symmetric(
                                          horizontal: 10.w),
                                      child:
                                          Image.asset('images/Twitter.png')))),
                          Visibility(
                              visible: widget
                                      .detailsModel.item!.itemSocialInstagram !=
                                  null,
                              child: InkWell(
                                  onTap: () async {
                                    // print( "Instagram::: ${widget.detailsModel.item!
                                    //     .itemSocialInstagram}");
                                    // print("https://www.instagram.com/${widget.detailsModel.item!
                                    //     .itemSocialInstagram!}");
                                    // launchUrl(Uri.parse("https://instagram.com/${widget.detailsModel.item!
                                    //     .itemSocialInstagram!}"));
                                      if(!widget
                                          .detailsModel
                                          .item!
                                          .itemSocialInstagram!.contains("instagram")){
                                        launchUrl(Uri.parse("https://instagram.com/${widget.detailsModel.item!
                                            .itemSocialInstagram!}"),
                                            mode: LaunchMode.externalApplication);
                                        // launchUrlString(
                                        //     "https://instagram.com/${widget.detailsModel.item!
                                        //         .itemSocialInstagram!}",
                                        //     mode: LaunchMode.externalApplication);

                                        print("https://instagram.com/${widget.detailsModel.item!
                                            .itemSocialInstagram!}");

                                      }else{
                                        launchUrl(
                                          Uri.parse( widget.detailsModel.item!
                                              .itemSocialInstagram!),
                                            mode: LaunchMode.externalApplication);
                                      }


                                  },
                                  child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Image.asset(
                                          'images/Instagram.png')))),
                          Visibility(
                              visible:
                                  widget.detailsModel.item!.itemWebsite != null,
                              child: InkWell(
                                  onTap: () async {
                                    if (await canLaunchUrlString(widget
                                        .detailsModel.item!.itemWebsite!)) {
                                      launchUrlString(
                                          widget
                                              .detailsModel.item!.itemWebsite!,
                                          mode: LaunchMode.externalApplication);
                                    }
                                  },
                                  child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Image.asset('images/Link.png'))))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ],
    );
  }

  void createFeaturesList() {
    for (int i = 0; i <= widget.detailsModel.item!.features!.length - 1; i++) {
      if (widget.detailsModel.item!.features![i].itemFeatureValue != null &&
          widget.detailsModel.item!.features![i].itemFeatureValue!.isNotEmpty) {
        features.add(widget.detailsModel.item!.features![i]);
      }
    }
    print(features);
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
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

  Future<void> createReview(
      {required String id,
      required var reviewImageGalleries,
      required String rating,
      required String title,
      required String body,
      required String recommend}) async {
    bool status = await ReviewApiController().createReview(
        id: id,
        reviewImageGalleries: reviewImageGalleries,
        rating: rating,
        title: title,
        body: body,
        recommend: recommend);
    if(SharedPrefController().id != ""){
      if (status) {
        imagePickerController.image_file = null;
        _reviewTextController.text = '';
        finalRating = 3;
        setState(() {});
        // ShowMySnakbar(
        //     title: 'تمت العملية بنجاح',
        //     message: 'تقييمك قيد المراجعة',
        //     backgroundColor: Colors.green.shade700);
      } else {
        // ShowMySnakbar(
        //     title: 'خطا',
        //     message: 'حدث خطا ما',
        //     backgroundColor: Colors.red.shade700);
      }
    }else{
      ShowMySnakbar(
          title: 'خطا',
          message: 'يجب عليك تسجيل الدخول اولاً',
          backgroundColor: Colors.red.shade700);
    }

  }
}

class ImageViewWidget extends StatelessWidget {
   ImageViewWidget({
    Key? key,
    required this.photos,
    required this.photo,
  }) : super(key: key);

  final List<String> photos;
  final String photo;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(4),
      onTap: () {
        Get.to(
          () => ViewPhoto(
            photos: photos,
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.network(
          'https://www.rakwa.com/laravel_project/public/storage/item/gallery/$photo',
          fit: BoxFit.cover,
          width: 180.w,
          height: 157.h,
          errorBuilder: (BuildContext context, Object? exception, StackTrace? stackTrace) {
            return Image.asset("images/logo.jpg",  width: 180.w,
              height: 157.h);
          },
        ),
        ),
      );
  }


   // Future<void> openFile({required String path}) async {
   //   var filePath = r'/storage/emulated/0/update.apk';
   //   FilePickerResult result = await FilePicker.platform.pickFiles();
   //
   //   if (result != null) {
   //     filePath = result.files.single.path;
   //   } else {
   //     // User canceled the picker
   //   }
   //   final _result = await OpenFile.open(filePath);
   //   print(_result.message);
   //
   //   setState(() {
   //     _openResult = "type=${_result.type}  message=${_result.message}";
   //   });
   // }
}
