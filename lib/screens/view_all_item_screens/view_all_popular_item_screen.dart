import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakwa/Core/utils/extensions.dart';
import 'package:rakwa/controller/all_popular_items_getx_controller.dart';
import 'package:rakwa/screens/details_screen/details_screen.dart';
import 'package:rakwa/widget/appbars/app_bars.dart';
import 'package:shimmer/shimmer.dart';

import '../../api/api_controllers/home_api_controller.dart';
import '../../model/paid_items_model.dart';
import '../../widget/home_widget.dart';

class ViewAllPopularItemScreen extends StatefulWidget {
  const ViewAllPopularItemScreen({super.key});

  @override
  State<ViewAllPopularItemScreen> createState() =>
      _ViewAllPopularItemScreenState();
}

class _ViewAllPopularItemScreenState extends State<ViewAllPopularItemScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  Get.put(AllPopularItemsGetxController());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars.appBarDefault(title: "الأشهر"),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 40),
        child: GetX<AllPopularItemsGetxController>(
          // future: HomeApiController().getPopularItems(),
          builder: (controller) {
            return controller.isLoading.value ?Shimmer.fromColors(
                baseColor: Colors.grey.shade100,
                highlightColor: Colors.grey.shade300,
                child: Container(
                  margin: const EdgeInsets.only(left: 8),
                  height: 236,
                  width: Get.width * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                )) : controller.popularItemsMore.isNotEmpty ?Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                              separatorBuilder: (context, index) => 16.ESH(),
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                        controller: controller.scroll,

                        itemCount: controller.popularItemsMore.length,
                              itemBuilder: (context, index) {
                                return HomeWidget(
                                    isList: true,
                                    percentCardWidth: .9,
                                    onTap: () {
                                      Get.to(
                                              () => DetailsScreen(id: controller.popularItemsMore[index].id.toString()));
                                    },
                                    discount: '25',
                                    image: controller.popularItemsMore[index].itemImage,
                                    itemType: controller.popularItemsMore[index].itemCategoriesString,
                                    location:  controller.popularItemsMore[index].itemDescription ?? "",
                                    title: controller.popularItemsMore[index].itemTitle,
                                    rate: controller.popularItemsMore[index].itemAverageRating);


                              },
                      ),
                    ),

                    Visibility(
                        visible: controller.loading.value,
                        child: Center(child: CircularProgressIndicator()))
                  ],
                )  :const Center(
              child: Text('لا توجد اي عناصر '),
            );

          },
        ),
      ),
    );
  }
}
