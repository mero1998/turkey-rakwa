import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rakwa/api/api_controllers/home_api_controller.dart';
import 'package:rakwa/model/paid_items_model.dart';
import 'package:rakwa/screens/details_screen/details_screen.dart';
import 'package:rakwa/screens/main_screens/btm_nav_screens/Ads/Screens/ads_screen.dart';
import 'package:rakwa/screens/main_screens/btm_nav_screens/Home/Widgets/shimmer_card_home_loading.dart';
import 'package:rakwa/widget/home_widget.dart';

import '../../../../../../controller/home_getx_controller.dart';



class NewItems extends StatelessWidget {
  const NewItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return FutureBuilder<List<PaidItemsModel>>(
    //   future: HomeApiController().getLatestItems(),
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState ==
    //         ConnectionState.waiting) {
    //       return const ShimmerCardHomeLoading();
    //     } else if (snapshot.hasData &&
    //         snapshot.data!.isNotEmpty) {
    //       return ListView.separated(
    //         padding: EdgeInsets.zero,
    //         shrinkWrap: true,
    //         physics:
    //         const NeverScrollableScrollPhysics(),
    //         itemCount: snapshot.data!.length <= 8
    //             ? snapshot.data!.length
    //             : 8,
    //         separatorBuilder: (context, index) =>
    //         const SizedBox(
    //           height: 12,
    //         ),
    //         itemBuilder: (context, index) {
    //           return HomeWidget(
    //               isList: true,
    //               percentCardWidth: .9,
    //               onTap: () {
    //                 Get.to(() => DetailsScreen(
    //                     id: snapshot.data![index].id.toString()));
    //               },
    //               saveOnPressed: () => saveItem(
    //                   id: snapshot.data![index].id
    //                       .toString()),
    //               discount: '25',
    //               image:
    //               snapshot.data![index].itemImage,
    //               itemType: snapshot.data![index]
    //                   .itemCategoriesString,
    //               location:
    //               snapshot.data![index].city != null
    //                   ? snapshot.data![index].city!
    //                   .cityName
    //                   : '',
    //               title:
    //               snapshot.data![index].itemTitle,
    //               rate: snapshot
    //                   .data![index].itemAverageRating);
    //         },
    //       );
    //     } else {
    //       return const Center(
    //         child: Text('لا توجد اي عناصر '),
    //       );
    //     }
    //   },
    // );

    return GetX<HomeGetxController>(builder: (controller){
            return controller.isLoading.value ? const ShimmerCardHomeLoading() : controller.latestItems.isEmpty ? const Center(
                      child: Text('لا توجد اي عناصر '),) : ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics:
              const NeverScrollableScrollPhysics(),
              itemCount:controller.configs.first.data!.itemNumberLatest != null ?
              int.parse(controller.configs.first.data!.itemNumberLatest ?? "")
              : controller.latestItems.length,
              separatorBuilder: (context, index) =>
              const SizedBox(
                height: 12,
              ),
              itemBuilder: (context, index) {
                return HomeWidget(
                    isList: true,
                    percentCardWidth: .9,
                    onTap: () {
                      Get.to(() => DetailsScreen(
                          id: controller.latestItems[index].id.toString()));
                    },
                    saveOnPressed: () => saveItem(
                        id: controller.latestItems[index].id
                            .toString()),
                    discount: '25',
                    image:
                    controller.latestItems[index].itemImage,
                    itemType: controller.latestItems[index]
                        .itemCategoriesString,
                    location:
                    controller.latestItems[index].itemDescription ?? "",
                    title:
                    controller.latestItems[index].itemTitle,
                    rate: controller.latestItems[index].itemAverageRating);
              },
            );
    });
  }
}
