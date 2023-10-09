import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rakwa/api/api_controllers/home_api_controller.dart';
import 'package:rakwa/model/all_categories_model.dart';
import 'package:rakwa/screens/main_screens/btm_nav_screens/Home/Widgets/cell_category_widget.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../widget/category_widget.dart';



class SliderHomeCategories extends StatelessWidget {
  const SliderHomeCategories({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AllCategoriesModel>>(
      future:
      HomeApiController().getAllCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade100,
            highlightColor: Colors.grey.shade300,
            child: Container(
              color: Colors.white,
              alignment: Alignment.center,
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              child: GridView.builder(
                padding: EdgeInsets.all(5),
                shrinkWrap: true,

                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 1.9,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10

                ),
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 8,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                    },
                    child: Container(

                      padding: EdgeInsets.zero,
                      // alignment: Alignment.center,
                      margin: EdgeInsetsDirectional.only(end: 10.w,),
                      // padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(

                        // color: Colors.white,
                        borderRadius: BorderRadius.circular(4),

                      ),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 30.w,
                            height: 30.h,
                            color: Colors.grey,
                          ),

                          Container(
                            width: 50.w,
                            height: 10.h,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          );
        } else if (snapshot.hasData &&
            snapshot.data!.isNotEmpty) {
          return CellCategoryWidget(
            data: snapshot.data!,
          );
        } else {
          return const Center(
            child: Text('لا توجد اي تصنفيات '),
          );
        }
      },
    );
  }
}
