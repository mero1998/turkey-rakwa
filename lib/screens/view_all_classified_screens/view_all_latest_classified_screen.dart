import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakwa/Core/utils/extensions.dart';
import 'package:rakwa/controller/all_latest_ads_getx_controller.dart';
import 'package:rakwa/screens/details_screen/details_classified_screen.dart';
import 'package:rakwa/widget/appbars/app_bars.dart';
import 'package:shimmer/shimmer.dart';

import '../../api/api_controllers/home_api_controller.dart';
import '../../model/paid_items_model.dart';
import '../../widget/home_widget.dart';

class ViewAllLatestClassifiedScreen extends StatefulWidget {
  const ViewAllLatestClassifiedScreen({super.key});

  @override
  State<ViewAllLatestClassifiedScreen> createState() =>
      _ViewAllLatestClassifiedScreenState();
}

class _ViewAllLatestClassifiedScreenState
    extends State<ViewAllLatestClassifiedScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  Get.put(AllLatestAdsGetxController());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars.appBarDefault(title: "الاعلانات الأحدث"),

      body: Padding(
        padding:  EdgeInsets.only(left: 16.w, right: 16.w, top: 40.h),
        child: GetX<AllLatestAdsGetxController>(
          // future: HomeApiController().getLatestClassified(),
          builder: (controller) {
           return  controller.isLoading.value ? Shimmer.fromColors(
                baseColor: Colors.grey.shade100,
                highlightColor: Colors.grey.shade300,
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  separatorBuilder: (context, index) {
                    return  SizedBox(
                      height: 12.h,
                    );
                  },
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    return Container(
                      margin:  EdgeInsets.only(left: 8.w),
                      height: 236.h,
                      width: Get.width * 0.9.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                    );
                  },
                )):
           controller.latestAdsMore.isNotEmpty ?
             Column(
               children: [
                 Expanded(
                   child: ListView.separated(
                     controller: controller.scroll,
                     separatorBuilder: (context, index) => 16.ESH(),
                     physics: const BouncingScrollPhysics(),
                     scrollDirection: Axis.vertical,
                     itemCount: controller.latestAdsMore.length,
                     itemBuilder: (context, index) {
                       return HomeWidget(
                           isList: true,
                           percentCardWidth: .9,
                           onTap: () {
                             Get.to(() => DetailsClassifiedScreen(
                                 id:controller.latestAdsMore[index].id));
                           },
                           discount: '25',
                           image: controller.latestAdsMore[index].itemImage,
                           itemType: controller.latestAdsMore[index].state?.stateName ?? '',
                           location: controller.latestAdsMore[index].itemDescription ?? '',

                           title: controller.latestAdsMore[index].itemTitle,
                           rate: '100');
                     },
                   ),
                 ),
                 Visibility(
                     visible: controller.loading.value,
                     child: Center(child: CircularProgressIndicator()))
               ],
             )
                 :  const Center(
               child: Text('لا توجد اي عناصر '),
             );
            // if (snapshot.connectionState == ConnectionState.waiting) {
            //   return Shimmer.fromColors(
            //       baseColor: Colors.grey.shade100,
            //       highlightColor: Colors.grey.shade300,
            //       child: ListView.separated(
            //         padding: EdgeInsets.zero,
            //         separatorBuilder: (context, index) {
            //           return const SizedBox(
            //         height: 12,
            //       );
            //         },
            //         itemCount: 9,
            //         itemBuilder: (context, index) {
            //           return Container(
            //             margin: const EdgeInsets.only(left: 8),
            //             height: 236,
            //             width: Get.width * 0.9,
            //             decoration: BoxDecoration(
            //               borderRadius: BorderRadius.circular(12),
            //               color: Colors.white,
            //             ),
            //           );
            //         },
            //       ));
            // } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            //   return ListView.separated(
            //     separatorBuilder: (context, index) => 16.ESH(),
            //     physics: const BouncingScrollPhysics(),
            //     scrollDirection: Axis.vertical,
            //     itemCount: snapshot.data!.length,
            //     itemBuilder: (context, index) {
            //       return HomeWidget(
            //         isList: true,
            //         percentCardWidth: .9,
            //         onTap: () {
            //              Get.to(() => DetailsClassifiedScreen(
            //                     id: snapshot.data![index].id));
            //         },
            //           discount: '25',
            //           image: snapshot.data![index].itemImage,
            //           itemType: snapshot.data![index].state?.stateName ?? '',
            //           location: snapshot.data![index].itemDescription ?? '',
            //
            //           title: snapshot.data![index].itemTitle,
            //           rate: '100');
            //     },
            //   );
            // } else {
            //   return const Center(
            //     child: Text('لا توجد اي عناصر '),
            //   );
            // }
          },
        ),
      ),
    );
  }
}
