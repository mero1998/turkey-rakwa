import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakwa/controller/all_res_getx_controller.dart';
import 'package:rakwa/screens/view_all_classified_screens/view_all_classified_subcategories_screen.dart';
import 'package:rakwa/screens/view_all_item_screens/view_all_res_screen.dart';
import 'package:rakwa/screens/view_all_item_screens/view_all_subcategories_screen.dart';
import 'package:rakwa/widget/SVG_Widget/svg_widget.dart';
import 'package:rakwa/widget/appbars/app_bars.dart';
import 'package:shimmer/shimmer.dart';


import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class OrderNowCategoriesScreen extends StatefulWidget {
  const OrderNowCategoriesScreen({super.key});

  @override
  State<OrderNowCategoriesScreen> createState() =>
      _OrderNowCategoriesScreenState();
}

class _OrderNowCategoriesScreenState extends State<OrderNowCategoriesScreen> {

  List<String> categories = [
    "مطاعم",
    "سوبر ماركت",
    "حلويات",
    "مخابز",
    "لحوم",
  ];
  List<String> categories2 = [
    "res",
    "supermarkets",
    "candies",
    "bakeries",
    "meats",
  ];
  // bakeries
  // candies
  // supermarkets
  List<String> icons = [
    "restaurant",
    "supermarket",
    "cake",
    "bread",
    "meats",

  ];



  @override
  Widget build(BuildContext context) {
    Get.put(AllResGetxController());
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

    return Scaffold(
      appBar: AppBars.appBarDefault(title: 'اطلب الآن'),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),

        child:SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 16,),
              GridView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 12,
                  // mainAxisExtent: 60,
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {

                      AllResGetxController.to.category.value = categories2[index];
                      Get.to(
                            () => ViewAllResScreen(),
                      );
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Material(
                      elevation: 1,
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius: BorderRadius.circular(8),

                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            IconSvg(icons[index],size: 25,),
                            Text(
                              categories[index],
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.notoKufiArabic(
                                  textStyle: const TextStyle(
                                      fontWeight: FontWeight.w500)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 16,),
            ],
          ),
        ),
        ),
    );
  }
}