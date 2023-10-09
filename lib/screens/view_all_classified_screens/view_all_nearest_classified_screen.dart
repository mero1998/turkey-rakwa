import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:rakwa/Core/utils/extensions.dart';
import 'package:rakwa/api/api_controllers/home_api_controller.dart';
import 'package:rakwa/controller/all_nearby_ads_getx_controller.dart';
import 'package:rakwa/controller/all_nearset_getx_controller.dart';
import 'package:rakwa/model/paid_items_model.dart';
import 'package:rakwa/screens/details_screen/details_classified_screen.dart';
import 'package:rakwa/widget/appbars/app_bars.dart';
import 'package:rakwa/widget/home_widget.dart';
import 'package:shimmer/shimmer.dart';


class ViewAllNearestClassifiedScreen extends StatefulWidget {
  const ViewAllNearestClassifiedScreen({super.key});

  @override
  State<ViewAllNearestClassifiedScreen> createState() => _ViewAllNearestClassifiedScreenState();
}

class _ViewAllNearestClassifiedScreenState extends State<ViewAllNearestClassifiedScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.put(AllNearAdsGetxController());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars.appBarDefault(title: "الاعلانات الاقرب اليك"),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 40),
        child: GetX<AllNearAdsGetxController>(
          // future: HomeApiController().getNearestClassified(type: 1),
          builder: (controller) {
          return  controller.isLoading.value ?Shimmer.fromColors(
                baseColor: Colors.grey.shade100,
                highlightColor: Colors.grey.shade300,
                child: ListView.separated(padding: EdgeInsets.zero,
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 12,
                    );
                  },
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(left: 8),
                      height: 236,
                      width: Get.width * 0.9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                    );
                  },
                )) : controller.nearAdsMore.isNotEmpty ?
            Column(
              children: [

                Expanded(
                  child: AnimationLimiter(
                    child: ListView.separated(
                      controller: controller.scroll,
                      separatorBuilder: (context, index) => 16.ESH(),
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: controller.nearAdsMore.length,
                      itemBuilder: (context, index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 375),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: HomeWidget(
                                isList: true,
                                percentCardWidth: .9,
                                onTap: () {
                                  Get.to(
                                        () => DetailsClassifiedScreen(
                                      id: controller.nearAdsMore[index].id,
                                    ),
                                  );
                                },
                                discount: '25',
                                image: controller.nearAdsMore[index].itemImage,
                                itemType:
                                controller.nearAdsMore[index].state?.stateName ?? '',
                                location:
                                controller.nearAdsMore[index].itemDescription ?? '',
                                title: controller.nearAdsMore[index].itemTitle,
                                rate: '100',
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Visibility(
                    visible: controller.loading.value,
                    child: Center(child: CircularProgressIndicator()))
              ],
            )

                : const Center(
              child: Text('لا توجد اي عناصر '),
            );

          },
        ),
      ),
    );
  }
}
