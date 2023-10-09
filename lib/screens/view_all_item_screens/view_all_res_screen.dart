import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakwa/Core/utils/extensions.dart';
import 'package:rakwa/controller/all_nearset_getx_controller.dart';
import 'package:rakwa/controller/all_res_getx_controller.dart';
import 'package:rakwa/controller/home_getx_controller.dart';
import 'package:rakwa/screens/details_screen/details_screen.dart';
import 'package:rakwa/widget/appbars/app_bars.dart';
import 'package:shimmer/shimmer.dart';

import '../../api/api_controllers/home_api_controller.dart';
import '../../app_colors/app_colors.dart';
import '../../model/paid_items_model.dart';
import '../../widget/home_widget.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ViewAllResScreen extends StatefulWidget {
  const ViewAllResScreen({super.key});

  @override
  State<ViewAllResScreen> createState() => _ViewAllResScreenState();
}

class _ViewAllResScreenState extends State<ViewAllResScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.put(AllResGetxController());
    AllResGetxController.to.resMore.clear();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
      if(AllResGetxController.to.category.value == "bakeries"){
        AllResGetxController.to.isLoading.value = true;
        await AllResGetxController.to.getBakeriesWithPagenation(current_page: 1);
        AllResGetxController.to.isLoading.value = false;

      }else if(AllResGetxController.to.category.value == "candies"){
        AllResGetxController.to.isLoading.value = true;

        await  AllResGetxController.to.getCandiesWithPagenation(current_page: 1,);
        AllResGetxController.to.isLoading.value = false;

      }else if(AllResGetxController.to.category.value == "supermarkets"){
        AllResGetxController.to.isLoading.value = true;

        await  AllResGetxController.to.getSupermarketsWithPagenation(current_page: 1,);
        AllResGetxController.to.isLoading.value = false;

      }
      else if(AllResGetxController.to.category.value == "meats"){
            AllResGetxController.to.isLoading.value = true;
        //
            await  AllResGetxController.to.getMeatWithPagenation(current_page: 1,);
            AllResGetxController.to.isLoading.value = false;
        //
          }
      else{
          AllResGetxController.to.isLoading.value = true;

          await  AllResGetxController.to.getResWithPagenation(current_page: 1,);
        AllResGetxController.to.isLoading.value = false;

      }
    });

  }
  @override
  Widget build(BuildContext context) {
    // AllResGetxController.to.page = 1;
    // AllResGetxController.to.lastPage = false;
    return Scaffold(
      appBar: AppBars.appBarDefault(title: "اطلب الآن"),
      body: GetX<AllResGetxController>(
        // future: HomeApiController().getNearestItemsWithPagenation(type: 0,current_page: HomeGetxController.to.page),
        builder: (controller) {
          return   controller.isLoading.value ? Shimmer.fromColors(
              baseColor: Colors.grey.shade100,
              highlightColor: Colors.grey.shade300,
              child: ListView.separated(
                padding: EdgeInsets.zero,
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
              ))  : controller.resMore.isNotEmpty ? Column(
            children: [
              Expanded(
                child: ListView.separated(
                  controller: controller.scroll,
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                  separatorBuilder: (context, index) => 16.ESH(),
                  itemCount: controller.resMore.length,
                  itemBuilder: (context, index) {
                    return HomeWidget(
                        isList: true,
                        percentCardWidth: .9,
                        onTap: () {
                          Get.to(() =>
                              DetailsScreen(id: controller.resMore[index].id.toString()));
                        },
                        doMargin: false,
                        discount: '25',
                        image: controller.resMore[index].itemImage,
                        itemType:
                        controller.resMore[index].itemCategoriesString,
                        location:  controller.resMore[index].itemDescription ?? "",
                        title: controller.resMore[index].itemTitle,
                        rate: controller.resMore[index].itemAverageRating);
                  },
                ),
              ),

              Visibility(
                  visible: controller.loading.value,
                  child: Center(child: CircularProgressIndicator()))

            ],
          ) :  const Center(
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
          //             height: 12,
          //           );
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
          //   return AnimationLimiter(
          //     child: ListView.separated(
          //       padding: EdgeInsets.zero,
          //       physics: const BouncingScrollPhysics(),
          //       separatorBuilder: (context, index) => 16.ESH(),
          //       itemCount: snapshot.data!.length,
          //       itemBuilder: (context, index) {
          //         return AnimationConfiguration.staggeredList(
          //           position: index,
          //           duration: const Duration(milliseconds: 500),
          //           child: SlideAnimation(
          //             verticalOffset: 50.0,
          //             child: FadeInAnimation(
          //               child: HomeWidget(
          //                 isList: true,
          //                 percentCardWidth: .9,
          //                   onTap: () {
          //                     Get.to(() =>
          //                         DetailsScreen(id: snapshot.data![index].id.toString()));
          //                   },
          //                   doMargin: false,
          //                   discount: '25',
          //                   image: snapshot.data![index].itemImage,
          //                   itemType:
          //                       snapshot.data![index].itemCategoriesString,
          //                   location:  snapshot.data![index].itemDescription ?? "",
          //                   title: snapshot.data![index].itemTitle,
          //                   rate: snapshot.data![index].itemAverageRating),
          //             ),
          //           ),
          //         );
          //       },
          //     ),
          //   );
          // } else {
          //   return const Center(
          //     child: Text('لا توجد اي عناصر '),
          //   );
          // }
        },
      ),
    );
  }
}
