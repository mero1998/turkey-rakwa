import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rakwa/screens/view_all_classified_screens/view_all_classified_subcategories_screen.dart';
import 'package:rakwa/widget/category_widget.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../api/api_controllers/home_api_controller.dart';
import '../../../../../model/all_categories_model.dart';



class AllAdsCategoriesWidget extends StatelessWidget {
  const AllAdsCategoriesWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding:  EdgeInsets.only(top: 24.h),
      child: SizedBox(
        height: 80.h,
        child: FutureBuilder<List<AllCategoriesModel>>(
          future: HomeApiController().getAllClassifiedCategories(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Shimmer.fromColors(
                  baseColor: Colors.grey.shade100,
                  highlightColor: Colors.grey.shade300,
                  child: ListView.builder(
                    padding: EdgeInsets.all(10),
                    scrollDirection: Axis.horizontal,
                    itemCount: 8,
                    itemBuilder: (context, index) {

                      return Container(
                        width: 80.w,
                        margin: EdgeInsetsDirectional.only(end: 10.w),
                        child: Column(
                          children: [
                            Container(
                              width: 30.w,
                              height: 30.h,
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.all(10),

                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.grey,
                              ),
                            ),
                            // Container(
                            //   width: 30.w,
                            //   height: 10.h,
                            //   padding: EdgeInsets.all(10),
                            //
                            //   margin: EdgeInsets.all(10),
                            //   decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(15),
                            //     color: Colors.grey,
                            //
                            //   ),
                            // ),
                          ],
                        ),
                      );
                    },
                  ));
            } else if (snapshot.hasData &&
                snapshot.data!.isNotEmpty) {
              return Container(
                color: Colors.white,
                margin: EdgeInsetsDirectional.only(end: 10.w),
                child: ListView.builder(
                  padding: EdgeInsets.all(10),
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.length <= 8
                      ? snapshot.data!.length
                      : 8,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: 80.w,
                      child: InkWell(
                        onTap: () {
                          Get.to(
                                () => ViewAllClassifiedSubCategoriesScreen(
                              id: snapshot.data![index].id ?? -1,
                              categoryName:
                              snapshot.data![index].categoryName ?? "",
                            ),
                          );
                        },
                        child: CategoryWidget(
                            index: index,
                            image: snapshot.data![index].categoryImage,
                            categoryName:
                            snapshot.data![index].categoryName ?? ""),
                      ),
                    );
                  },
                ),
              );
            } else {
              return const Center(
                child: Text('لا توجد اي تصنفيات '),
              );
            }
          },
        ),
      ),
    );
  }
}
