import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakwa/Core/utils/extensions.dart';
import 'package:rakwa/controller/all_popular_classfications_getx_controller.dart';
import 'package:rakwa/screens/details_screen/details_classified_screen.dart';
import 'package:rakwa/widget/appbars/app_bars.dart';
import 'package:shimmer/shimmer.dart';

import '../../api/api_controllers/home_api_controller.dart';
import '../../model/paid_items_model.dart';
import '../../widget/home_widget.dart';

class ViewAllPopularClassifiedScreen extends StatefulWidget {
  const ViewAllPopularClassifiedScreen({super.key});

  @override
  State<ViewAllPopularClassifiedScreen> createState() =>
      _ViewAllPopularClassifiedScreenState();
}

class _ViewAllPopularClassifiedScreenState
    extends State<ViewAllPopularClassifiedScreen> {
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
 Get.put(AllPopularClassifiedGetxController());
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars.appBarDefault(title: "الاعلانات الأشهر"),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 40),
        child: GetX<AllPopularClassifiedGetxController>(
          // future: HomeApiController().getPopularClassified(),
          builder: (controller) {
    return  controller.isLoading.value ? Shimmer.fromColors(
    baseColor: Colors.grey.shade100,
    highlightColor: Colors.grey.shade300,
    child: ListView.separated(
    padding: EdgeInsets.zero,
    separatorBuilder: (context, index) {
    return const SizedBox(
    height: 12,
    );
    },
    itemCount: controller.popularClassifiedMore.length,
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
    )) : controller.popularClassifiedMore.isNotEmpty ?  Column(
      children: [
        Expanded(
          child: ListView.builder(
          controller: controller.scroll,
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: controller.popularClassifiedMore.length,
          itemBuilder: (context, index) {
          return HomeWidget(
          onTap: () {
          Get.to(() => DetailsClassifiedScreen(
          id: controller.popularClassifiedMore[index].id));
          },
          discount: '25',
          image: controller.popularClassifiedMore[index].itemImage,
          itemType: controller.popularClassifiedMore[index].state!.stateName,
          location: controller.popularClassifiedMore[index].itemDescription ?? "",
          title: controller.popularClassifiedMore[index].itemTitle,
          rate: '100');
          },
          ),
        ),
        Visibility(
            visible: controller.loading.value,
            child: Center(child: CircularProgressIndicator()))      ],
    ):const Center(
    child: Text('لا توجد اي عناصر '),
    );
  },
        ),
      ),
    );
  }
}
