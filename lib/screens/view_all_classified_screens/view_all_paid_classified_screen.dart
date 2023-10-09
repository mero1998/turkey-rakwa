import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakwa/controller/all_popular_classfications_getx_controller.dart';
import 'package:rakwa/screens/details_screen/details_classified_screen.dart';
import 'package:shimmer/shimmer.dart';

import '../../api/api_controllers/home_api_controller.dart';
import '../../model/paid_items_model.dart';
import '../../widget/home_widget.dart';

class ViewAllPaidClassifiedScreen extends StatefulWidget {
  const ViewAllPaidClassifiedScreen({super.key});

  @override
  State<ViewAllPaidClassifiedScreen> createState() =>
      _ViewAllPaidClassifiedScreenState();
}

class _ViewAllPaidClassifiedScreenState
    extends State<ViewAllPaidClassifiedScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  Get.put(AllPopularClassifiedGetxController());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          title: Text(
            'الاعلانات الشائعة',
            style: GoogleFonts.notoKufiArabic(
                textStyle: const TextStyle(
              color: Colors.black,
            )),
          ),
        ),
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
                  ))
               :
           controller.popularClassifiedMore.isNotEmpty ?  Column(
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
                   child: Center(child: CircularProgressIndicator()))
             ],
           ):const Center(
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
              //         itemCount: snapshot.data!.length,
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
              //   return ListView.builder(
              //     physics: const BouncingScrollPhysics(),
              //     scrollDirection: Axis.vertical,
              //     itemCount: snapshot.data!.length,
              //     itemBuilder: (context, index) {
              //       return HomeWidget(
              //         onTap: () {
              //              Get.to(() => DetailsClassifiedScreen(
              //                   id: snapshot.data![index].id));
              //         },
              //           discount: '25',
              //           image: snapshot.data![index].itemImage,
              //           itemType: snapshot.data![index].state!.stateName,
              //           location: snapshot.data![index].itemDescription ?? "",
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
        ));
  }
}
