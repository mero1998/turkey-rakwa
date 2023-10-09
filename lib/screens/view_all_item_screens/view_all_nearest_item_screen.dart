import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rakwa/Core/services/geolocation_services.dart';
import 'package:rakwa/Core/utils/extensions.dart';
import 'package:rakwa/controller/all_item_getx_controller.dart';
import 'package:rakwa/controller/all_nearset_getx_controller.dart';
import 'package:rakwa/controller/home_getx_controller.dart';
import 'package:rakwa/screens/details_screen/details_screen.dart';
import 'package:rakwa/widget/appbars/app_bars.dart';
import 'package:shimmer/shimmer.dart';

import '../../api/api_controllers/home_api_controller.dart';
import '../../app_colors/app_colors.dart';
import '../../model/paid_items_model.dart';
import '../../shared_preferences/shared_preferences.dart';
import '../../widget/app_dialog.dart';
import '../../widget/home_widget.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ViewAllNearestItemScreen extends StatefulWidget  {
  const ViewAllNearestItemScreen({super.key});

  @override
  State<ViewAllNearestItemScreen> createState() => _ViewAllNearestItemScreenState();
}

class _ViewAllNearestItemScreenState extends State<ViewAllNearestItemScreen> with WidgetsBindingObserver{
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Get.put(AllNearsetGetxController());
    WidgetsBinding.instance.addObserver(this);

    Future.delayed(Duration.zero,()async{

      LocationPermission permission;

        Future.delayed(Duration.zero, () async {
          // bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
          permission = await Geolocator.checkPermission();

          print("name::: ${permission.name}");
          if (permission == LocationPermission.denied) {
            permission = await Geolocator.requestPermission();
            if (ModalRoute
                .of(context)
                ?.isCurrent != true) {
              Get.back();
            }
            if (Platform.isIOS) {

              AppDialog.openSittingIOS(context);
            } else {
              AppDialog.openSittingsAndroid(context);
            }
            // await _savePosition();
            await AllNearsetGetxController.to.getNestedItemsPagenation(
                current_page: 1, type: 0);
          } else if (permission == LocationPermission.deniedForever) {
            permission = await Geolocator.requestPermission();

            if (ModalRoute
                .of(context)
                ?.isCurrent != true) {
              Get.back();
            }
            if (Platform.isIOS) {


              AppDialog.openSittingIOS(context);
            } else {
              AppDialog.openSittingsAndroid(context);
            }
            await _savePosition();
            await AllNearsetGetxController.to.getNestedItemsPagenation(
                current_page: 1, type: 0);
          } else if (permission == LocationPermission.whileInUse) {
            if (ModalRoute
                .of(context)
                ?.isCurrent != true) {
              Get.back();
            }
            await _savePosition();
            await AllNearsetGetxController.to.getNestedItemsPagenation(
                current_page: 1, type: 0);

            print("I don't know");
          } else if (permission == LocationPermission.unableToDetermine) {
            print("I don't know2222");
          }
          else {
            // permission =  await Geolocator.requestPermission();
            print("location is not enabled");
            await _savePosition();
            await AllNearsetGetxController.to.getNestedItemsPagenation(
                current_page: 1, type: 0);

// getLocation();

          }
        });

    });
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {

    super.didChangeAppLifecycleState(state);
    LocationPermission permission;

    print("State:::::::: ${state}");
    if(state == AppLifecycleState.resumed){

      Future.delayed(Duration.zero,()async{
        // bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        permission = await Geolocator.checkPermission();

        print("name::: ${permission.name}");
        if(permission == LocationPermission.denied){
          permission = await Geolocator.requestPermission();

          // if(Platform.isIOS){
          //   if(ModalRoute.of(context)?.isCurrent != true){
          //     Get.back();
          //   }
          //   AppDialog.openSittingIOS(context);
          // }else{
          //   AppDialog.openSittingsAndroid(context);
          // }
        await _savePosition();
          await AllNearsetGetxController.to.getNestedItemsPagenation(current_page: 1, type: 0);

        }else if(permission == LocationPermission.deniedForever){
          permission = await Geolocator.requestPermission();
          if(ModalRoute.of(context)?.isCurrent != true){
            Get.back();
          }
          if(Platform.isIOS){
            AppDialog.openSittingIOS(context);
          }else{
            AppDialog.openSittingsAndroid(context);
          }
        await  _savePosition();
          await AllNearsetGetxController.to.getNestedItemsPagenation(current_page: 1, type: 0);

        }else if(permission == LocationPermission.whileInUse){
          if (ModalRoute
              .of(context)
              ?.isCurrent != true) {
            Get.back();
          }
          await  _savePosition();
          await AllNearsetGetxController.to.getNestedItemsPagenation(current_page: 1, type: 0);

          print("I don't know");
        }else if(permission == LocationPermission.unableToDetermine){
          print("I don't know2222");

        }
        else{
      // permission =  await Geolocator.requestPermission();
          print("location is not enabled");
        await _savePosition();
         await AllNearsetGetxController.to.getNestedItemsPagenation(current_page: 1, type: 0);

// getLocation();

        }
      });

    }
    // if(state == AppLifecycleState.paused){
    // }


  }
  Future<void> _savePosition() async {

    print("we are here");
    await getLocation().then((value) async {
      if(value != null){
        await SharedPrefController().savePosition(
          lat: value!.latitude,
          lng: value!.longitude,
        );
        printDM("lat in lunch is => ${SharedPrefController().lat}");
        printDM("lng in lunch is => ${SharedPrefController().lng}");
      }}).catchError((error) async{
      await Geolocator.requestPermission();
      await SharedPrefController().savePosition(
        lat: 0.0,
        lng: 0.0,
      );
      printDM("error in _savePosition is $error");
      printDM("lat in lunch is => ${SharedPrefController().lat}");
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBars.appBarDefault(title: "الاعمال الاقرب اليك"),
      body: GetX<AllNearsetGetxController>(
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
              ))  : controller.nestedItemsMore.isNotEmpty ? Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      controller: controller.scroll,
                      padding: EdgeInsets.zero,
                      physics: const BouncingScrollPhysics(),
                      separatorBuilder: (context, index) => 16.ESH(),
                      itemCount: controller.nestedItemsMore.length,
                      itemBuilder: (context, index) {
                        return HomeWidget(
                            isList: true,
                            percentCardWidth: .9,
                            onTap: () {
                              Get.to(() =>
                                  DetailsScreen(id: controller.nestedItemsMore[index].id.toString()));
                            },
                            doMargin: false,
                            discount: '25',
                            image: controller.nestedItemsMore[index].itemImage,
                            itemType:
                            controller.nestedItemsMore[index].itemCategoriesString,
                            location:  controller.nestedItemsMore[index].itemDescription ?? "",
                            title: controller.nestedItemsMore[index].itemTitle,
                            rate: controller.nestedItemsMore[index].itemAverageRating);
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
