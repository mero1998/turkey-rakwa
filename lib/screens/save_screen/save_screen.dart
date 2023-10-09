import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakwa/api/api_controllers/save_api_controller.dart';
import 'package:rakwa/app_colors/app_colors.dart';
import 'package:rakwa/controller/home_getx_controller.dart';
import 'package:rakwa/model/all_saved_items_model.dart';
import 'package:rakwa/model/paid_items_model.dart';
import 'package:rakwa/screens/details_screen/details_classified_screen.dart';
import 'package:rakwa/shared_preferences/shared_preferences.dart';
import 'package:rakwa/Core/utils/helpers.dart';
import 'package:rakwa/widget/SimmerLoading/simmer_loading_list_home_widget.dart';
import 'package:rakwa/widget/appbars/app_bars.dart';
import 'package:shimmer/shimmer.dart';
import '../../widget/home_widget.dart';
import '../details_screen/details_screen.dart';

class SaveScreen extends StatefulWidget {
  const SaveScreen({super.key});

  @override
  State<SaveScreen> createState() => _SaveScreenState();
}

class _SaveScreenState extends State<SaveScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.put(HomeGetxController());

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBars.appBarDefault(title: "العناصر المحفوظة"),
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: TabBar(
            labelStyle: GoogleFonts.notoKufiArabic(
              textStyle:  TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            unselectedLabelStyle: GoogleFonts.notoKufiArabic(
              textStyle:  TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors().mainColor,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 2.h,
            tabs: const [
              Tab(
                text: "الاعمال المحفوظة",
              ),
              Tab(
                text: "الاعلانات المحفوظة",
              ),
            ],
          ),
          body:  Padding(
            padding: EdgeInsets.only(top: 16.h),
            child: TabBarView(
              children: [
                SavedWorksTap(),
                SavedAdsTap(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SavedAdsTap extends StatefulWidget {
  const SavedAdsTap({Key? key}) : super(key: key);

  @override
  State<SavedAdsTap> createState() => _SavedAdsTapState();
}

class _SavedAdsTapState extends State<SavedAdsTap> with Helpers {
  @override
  Widget build(BuildContext context) {
    return GetX<HomeGetxController>(
      // future: SaveApiController().getSaveClassified(),
      builder: (controller) {
        return controller.isLoading.value ? SimmerLoadingListHomeWidget() :
        controller.savedClassified.isNotEmpty ? ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: controller.savedClassified.length,
          separatorBuilder: (context, index) =>  SizedBox(height: 16.h),
          itemBuilder: (context, index) {
            return HomeWidget(
                percentCardWidth: .9.w,
                onTap: () {
                  Get.to(() => DetailsClassifiedScreen(
                    id: controller.savedClassified[index].id!,
                  ));
                },
                doMargin: false,
                saveOnPressed: () => unSaveClassified(
                    id: controller.savedClassified[index].id.toString()),
                discount: '25',
                saveIcon:  Icon(
                  Icons.bookmark_outlined,
                  color: AppColors().mainColor,
                ),
                image: controller.savedClassified[index].itemImage,
                itemType: controller.savedClassified[index].item_categories_string.toString(),
                location: controller.savedClassified[index].itemDescription ?? "",
                title: controller.savedClassified[index].itemTitle,
                rate:controller.savedClassified[index].itemAverageRating);
          },
        ): Center(child: Text('لم تقم بحفظ اي اعلانات'));
      },
    );
  }

  Future<void> unSaveItem({required String id}) async {
    bool status = await SaveApiController().unSaveItem(itemId: id);
    if (status) {
      ShowMySnakbar(
          title: 'تم العملية بنجاح',
          message: 'تم ازالة العنصر بنجاح',
          backgroundColor: Colors.green.shade700);
      setState(() {});
    } else {
      ShowMySnakbar(
          title: 'خطأ',
          message: 'حدث خطأ ما',
          backgroundColor: Colors.red.shade700);
    }
  }

  Future<void> unSaveClassified({required String id}) async {
    bool status = await SaveApiController().unSaveClassified(classifiedId: id);
    if (status) {
      ShowMySnakbar(
          title: 'تم العملية بنجاح',
          message: 'تم ازالة العنصر بنجاح',
          backgroundColor: Colors.green.shade700);
      setState(() {});
    } else {
      ShowMySnakbar(
          title: 'خطأ',
          message: 'حدث خطأ ما',
          backgroundColor: Colors.red.shade700);
    }
  }
}

class SavedWorksTap extends StatefulWidget {
  const SavedWorksTap({Key? key}) : super(key: key);

  @override
  State<SavedWorksTap> createState() => _SavedWorksTapState();
}

class _SavedWorksTapState extends State<SavedWorksTap> with Helpers {
  @override
  Widget build(BuildContext context) {
    return GetX<HomeGetxController>(
      builder: (controller) {
        return controller.isLoading.value ? SimmerLoadingListHomeWidget() :
        controller.savedItems.isNotEmpty ? ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount:  controller.savedItems.length,
          separatorBuilder: (context, index) =>  SizedBox(height: 16.h),
          itemBuilder: (context, index) {
            return HomeWidget(
                percentCardWidth: .9.w,
                onTap: () {
                  Get.to(
                        () => DetailsScreen(
                      id:  controller.savedItems[index].id.toString(),
                    ),
                  );
                },
                doMargin: false,
                saveOnPressed: () =>
                    unSaveItem(id:  controller.savedItems[index].id.toString()),
                discount: '25',
                saveIcon:  Icon(
                  Icons.bookmark_outlined,
                  color: AppColors().mainColor,
                ),
                image:  controller.savedItems[index].itemImage,
                itemType:  controller.savedItems[index].item_categories_string.toString(),
                location:  controller.savedItems[index].itemDescription ?? "",
                title:  controller.savedItems[index].itemTitle,
                rate:  controller.savedItems[index].itemAverageRating);
          },
        ) : Center(child: Text('لم تقم بحفظ اي عناصر'));
        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   return SimmerLoadingListHomeWidget();
        // } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
        //   return ListView.separated(
        //     padding: EdgeInsets.zero,
        //     itemCount: snapshot.data!.length,
        //     separatorBuilder: (context, index) => const SizedBox(height: 16),
        //     itemBuilder: (context, index) {
        //       return HomeWidget(
        //           percentCardWidth: .9,
        //           onTap: () {
        //             Get.to(
        //               () => DetailsScreen(
        //                 id: snapshot.data![index].id.toString(),
        //               ),
        //             );
        //           },
        //           doMargin: false,
        //           saveOnPressed: () =>
        //               unSaveItem(id: snapshot.data![index].id.toString()),
        //           discount: '25',
        //           saveIcon: const Icon(
        //             Icons.bookmark_outlined,
        //             color: AppColors().mainColor,
        //           ),
        //           image: snapshot.data![index].itemImage,
        //           itemType: snapshot.data![index].stateId.toString(),
        //           location: snapshot.data![index].itemDescription ?? "",
        //           title: snapshot.data![index].itemTitle,
        //           rate: snapshot.data![index].itemAverageRating);
        //     },
        //   );
        // } else {
        //   return const Center(child: Text('لم تقم بحفظ اي عناصر'));
        // }
      },
    );
  }

  Future<void> unSaveItem({required String id}) async {
    bool status = await SaveApiController().unSaveItem(itemId: id);
    if (status) {
      ShowMySnakbar(
          title: 'تم العملية بنجاح',
          message: 'تم ازالة العنصر بنجاح',
          backgroundColor: Colors.green.shade700);
      setState(() {});
    } else {
      ShowMySnakbar(
          title: 'خطأ',
          message: 'حدث خطأ ما',
          backgroundColor: Colors.red.shade700);
    }
  }

  Future<void> unSaveClassified({required String id}) async {
    bool status = await SaveApiController().unSaveClassified(classifiedId: id);
    if (status) {
      ShowMySnakbar(
          title: 'تم العملية بنجاح',
          message: 'تم ازالة العنصر بنجاح',
          backgroundColor: Colors.green.shade700);
      setState(() {});
    } else {
      ShowMySnakbar(
          title: 'خطأ',
          message: 'حدث خطأ ما',
          backgroundColor: Colors.red.shade700);
    }
  }
}
