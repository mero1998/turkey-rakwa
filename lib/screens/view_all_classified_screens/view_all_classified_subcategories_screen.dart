import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rakwa/api/api_controllers/classified_api_controller.dart';
import 'package:rakwa/api/api_controllers/item_api_controller.dart';
import 'package:rakwa/controller/all_item_getx_controller.dart';
import 'package:rakwa/model/classified_with_category.dart';
import 'package:rakwa/model/item_with_category.dart';
import 'package:rakwa/screens/details_screen/details_classified_screen.dart';
import 'package:rakwa/screens/details_screen/details_screen.dart';
import 'package:rakwa/screens/main_screens/btm_nav_screens/Home/Widgets/search_widget.dart';
import 'package:rakwa/screens/search_screens/search_screen.dart';
import 'package:rakwa/screens/view_all_classified_screens/view_all_classified_screen.dart';
import 'package:rakwa/widget/appbars/app_bars.dart';
import 'package:rakwa/widget/category_widget.dart';
import 'package:rakwa/widget/home_widget.dart';
import 'package:rakwa/widget/my_text_field.dart';
import 'package:shimmer/shimmer.dart';
import '../../api/api_controllers/list_api_controller.dart';
import '../../app_colors/app_colors.dart';
import '../../model/all_categories_model.dart';

class ViewAllClassifiedSubCategoriesScreen extends StatefulWidget {
  final int id;
  final String categoryName;

  const ViewAllClassifiedSubCategoriesScreen({super.key, required this.id, required this.categoryName});

  @override
  State<ViewAllClassifiedSubCategoriesScreen> createState() =>
      _ViewAllClassifiedSubCategoriesScreenState();
}

class _ViewAllClassifiedSubCategoriesScreenState
    extends State<ViewAllClassifiedSubCategoriesScreen> {
  List<AllCategoriesModel> classifeidSubCategory = [];

  List colors = const [
    Color.fromARGB(255, 224, 20, 81),
    Color.fromARGB(255, 45, 106, 228),
    Color.fromARGB(255, 159, 6, 254),
    Color.fromARGB(255, 219, 242, 12),
    Color.fromARGB(255, 224, 20, 81),
    Color.fromARGB(255, 45, 106, 228),
    Color.fromARGB(255, 159, 6, 254),
    Color.fromARGB(255, 219, 242, 12)
  ];
  final Set<Marker> _marker = {};

  late TextEditingController _searchController;
  AllItemGetxController allItemGetxController =
      Get.put(AllItemGetxController());

  @override
  void initState() {
    super.initState();
    print("ID :::: ${widget.id}");

    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    allItemGetxController
        .classifeidSubCategory.clear();

    allItemGetxController
        .classifiedWithCategory.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    allItemGetxController.getClassifiedSubCategory(id: widget.id);
    allItemGetxController.getClassified(id: widget.id.toString());
    return Scaffold(
      appBar: AppBars.appBarDefault(title: widget.categoryName),
      body: Stack(
        children: [
          GetBuilder<AllItemGetxController>(
            builder: (controller) {
              return GoogleMap(
                markers: Set<Marker>.of(allItemGetxController.markerClassified),
                mapType: MapType.normal,
                myLocationEnabled: true,
                initialCameraPosition: const CameraPosition(
                    target: LatLng(34.817411, 34.615960), zoom: 5),
              );
            },
          ),
          DraggableScrollableSheet(
            maxChildSize: 0.9,
            minChildSize: 0.2,
            initialChildSize: 0.7,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 40),
                  child: ListView(
                    controller: scrollController,
                    children: [
                      SearchWidget(
                        isItem: false,
                        searchNumber: widget.id.toString(),
                      ),

                      const SizedBox(
                        height: 24,
                      ),
                      // Container(
                      //   color: Colors.grey.shade400,
                      //   width: double.infinity,
                      //   height: 120.h,
                      //   alignment: AlignmentDirectional.center,
                      //   child: Text("مساحة اعلانية",style: TextStyle(
                      //       color: Colors.white,
                      //       fontWeight: FontWeight.bold,
                      //       fontSize: 20.sp
                      //   ),),
                      // ),
                      const SizedBox(
                        height: 24,
                      ),
                      SizedBox(
                        height: 70,
                        child: GetBuilder<AllItemGetxController>(
                            builder: (controller) {
                              print("we are here22");
                              print(widget.id);
                          return allItemGetxController
                                      .classifeidSubCategory.isEmpty &&
                                  allItemGetxController
                                          .classifiedSubCategryStatus ==
                                      1
                              ? Shimmer.fromColors(
                                  baseColor: Colors.grey.shade100,
                                  highlightColor: Colors.grey.shade300,
                                  child: ListView.builder(
                                    itemCount: 8,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {},
                                        child: CategoryWidget(
                                          image: '',
                                          categoryName: '',
                                        ),
                                      );
                                    },
                                  ))
                              : allItemGetxController
                                      .classifeidSubCategory.isNotEmpty
                                  ? ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: allItemGetxController
                                          .classifeidSubCategory.length,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            // Navigator.of(context).push(new MaterialPageRoute(builder: (_)=> ViewAllClassifiedScreen(
                                            //   categoryName:allItemGetxController
                                            //       .classifeidSubCategory[
                                            //   index].categoryName ?? "",
                                            //   categoryId: widget.id,
                                            //   id: allItemGetxController
                                            //       .classifeidSubCategory[
                                            //   index]
                                            //       .id ?? -1,
                                            // ),),)
                                            //     .then((val)=>val?
                                            // // allItemGetxController.getClassifiedSubCategory(id: widget.id);
                                            //     allItemGetxController.getClassified(id: widget.id.toString())
                                            //     :null);
                                            Get.to(
                                              () => ViewAllClassifiedScreen(
                                                categoryName:allItemGetxController
                                                  .classifeidSubCategory[
                                              index].categoryName ?? "",
                                                categoryId: widget.id,
                                                id: allItemGetxController
                                                    .classifeidSubCategory[
                                                        index]
                                                    .id ?? -1,
                                              ),
                                            )!.then((value) => value ?  allItemGetxController.getClassified(id: widget.id.toString())
                                                    :null);
                                          },
                                          child: CategoryWidget(
                                            image: allItemGetxController
                                                .classifeidSubCategory[index]
                                                .categoryImage,
                                            index: index,
                                            categoryName: allItemGetxController
                                                .classifeidSubCategory[index]
                                                .categoryName ?? "",
                                          ),
                                        );
                                      },
                                    )
                                  : Center(child: Text(''));
                        }
                            //           : allItemGetxController.classifiedStatus == 1
                            //               ? Text('لا توجد بيانات')
                            //               : SizedBox();
                            // },
                            ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      SizedBox(
                        height: Get.height * 0.6,
                        child: GetBuilder<AllItemGetxController>(
                          builder: (controller) {
                            return allItemGetxController
                                        .classifiedWithCategory.isEmpty &&
                                    allItemGetxController.classifiedStatus == 1
                                ?  Center(
                                    child: CircularProgressIndicator(
                                    color: AppColors().mainColor,
                                  ))
                                : allItemGetxController
                                        .classifiedWithCategory.isNotEmpty
                                    ? ListView.separated(
                              padding: EdgeInsets.zero,
                                        separatorBuilder: (context, index) =>
                                            const SizedBox(
                                          height: 12,
                                        ),
                                        physics: const BouncingScrollPhysics(),
                                        itemCount: allItemGetxController
                                            .classifiedWithCategory.first.classifiedCategory!
                                            .length,
                                itemBuilder: (context, index) {
                                          return HomeWidget(
                                              percentCardWidth: .9,
                                              onTap: () {
                                                print(
                                                  allItemGetxController
                                                      .classifiedWithCategory.first.classifiedCategory![index]
                                                      .id!,
                                                );
                                                Get.to(
                                                  () => DetailsClassifiedScreen(
                                                    id: allItemGetxController
                                                        .classifiedWithCategory.first.classifiedCategory![index]
                                                        .id!,
                                                  ),
                                                );
                                              },
                                              discount: '25',
                                              image: allItemGetxController
                                                  .classifiedWithCategory.first.classifiedCategory![index]
                                                  .itemImage,
                                              itemType: allItemGetxController
                                                  .classifiedWithCategory.first.classifiedCategory![index]
                                                  .itemCategoriesString ?? "",
                                              location: allItemGetxController
                                                  .classifiedWithCategory.first.classifiedCategory![index]
                                                  .itemDescription ?? "",
                                              title: allItemGetxController
                                                  .classifiedWithCategory.first.classifiedCategory![index]
                                                  .itemTitle ?? "",
                                              rate: '100');
                                        },
                                      )
                                    : const Center(
                                        child: Text(''),
                                      );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
