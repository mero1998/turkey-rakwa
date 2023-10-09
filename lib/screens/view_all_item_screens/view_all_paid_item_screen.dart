import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakwa/Core/utils/extensions.dart';
import 'package:rakwa/controller/all_paid_items_getx_controller.dart';
import 'package:rakwa/screens/details_screen/details_screen.dart';
import 'package:rakwa/widget/appbars/app_bars.dart';
import 'package:shimmer/shimmer.dart';

import '../../api/api_controllers/home_api_controller.dart';
import '../../app_colors/app_colors.dart';
import '../../model/paid_items_model.dart';
import '../../widget/home_widget.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ViewAllPaidItemScreen extends StatefulWidget {
  const ViewAllPaidItemScreen({super.key});

  @override
  State<ViewAllPaidItemScreen> createState() => _ViewAllPaidItemScreenState();
}

class _ViewAllPaidItemScreenState extends State<ViewAllPaidItemScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Get.put(AllPaidItemsGetxController());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars.appBarDefault(title: "العناصر المميزة"),
      body: GetX<AllPaidItemsGetxController>(
        // future: HomeApiController().getPaidItems(),
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
                    margin: const EdgeInsets.only(left: 8),
                    height: 236.h,
                    width: Get.width * 0.9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                  );
                },
              )) : controller.paidItemsMore.isNotEmpty ?Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                            padding: EdgeInsets.zero,
                            physics: const BouncingScrollPhysics(),
                            separatorBuilder: (context, index) => 16.ESH(),

                            controller: controller.scroll,
                            itemCount: controller.paidItemsMore.length,
                            itemBuilder: (context, index) {
                              return HomeWidget(
                                  isList: true,
                                  percentCardWidth: .9,
                                  onTap: () {
                                    Get.to(() =>
                                        DetailsScreen(id: controller.paidItemsMore[index].id.toString()));
                                  },
                                  doMargin: false,
                                  discount: '25',
                                  image: controller.paidItemsMore[index].itemImage,
                                  itemType:
                                  controller.paidItemsMore[index].itemCategoriesString,
                                  location:  controller.paidItemsMore[index].itemDescription ?? "",
                                  title: controller.paidItemsMore[index].itemTitle,
                                  rate: controller.paidItemsMore[index].itemAverageRating);
                            },
                    ),
                  ),

                  Visibility(
                      visible: controller.loading.value,
                      child: Center(child: CircularProgressIndicator()))
                ],
              ) : const Center(
            child: Text('لا توجد اي عناصر '),
          );

        },
      ),
    );
  }
}
