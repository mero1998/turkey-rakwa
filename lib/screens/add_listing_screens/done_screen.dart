import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakwa/app_colors/app_colors.dart';
import 'package:rakwa/screens/add_listing_screens/Controllers/add_work_controller.dart';
import 'package:rakwa/screens/add_listing_screens/add_list_category_screen.dart';
import 'package:rakwa/screens/add_listing_screens/add_list_classified_category_screen.dart';
import 'package:rakwa/screens/main_screens/main_screen.dart';
import 'package:rakwa/widget/main_elevated_button.dart';

class DoneScreen extends StatefulWidget {
  final bool isList;

  DoneScreen({required this.isList});

  @override
  State<DoneScreen> createState() => _DoneScreenState();
}

class _DoneScreenState extends State<DoneScreen> {
  @override
  Widget build(BuildContext context) {
    Get.put(AddWorkOrAdsController(isList: widget.isList));

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: AddWorkOrAdsController.to.edit.value == false,
              child: Center(
                child: Text(
                 AddWorkOrAdsController.to.isList ? 'عملك قيد المراجعة' : 'اعلانك قيد المراجعة',
                  style: GoogleFonts.notoKufiArabic(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Image.asset(
              'images/done.png',
              height: 250,
              width: 250,
            ),
            const SizedBox(
              height: 24,
            ),
            MainElevatedButton(
              height: 60,
              width: 260,
              borderRadius: 20,
              onPressed: () => Get.offAll(() => const MainScreen()),
              child: Text('العودة الى الصفحة الرئيسية',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.notoKufiArabic(
                      textStyle: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500))),
            ),
            const SizedBox(
              height: 24,
            ),
            Visibility(
              visible: widget.isList,
              replacement: MainElevatedButton(
                height: 47,
                width: 192,
                borderRadius: 20,
                backgroundColor: Colors.white,
                borderSide: true,
                onPressed: () {
                  Get.to(() =>  AddListClassifiedCategoryScreen());
                },
                child: Text(
                  'اضافة اعلان جديد',
                  style: GoogleFonts.notoKufiArabic(
                      textStyle:  TextStyle(
                          color: AppColors().mainColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                ),
              ),
              child: MainElevatedButton(
                height: 47,
                width: 192,
                borderRadius: 20,
                backgroundColor: Colors.white,
                borderSide: true,
                onPressed: () {
                  Get.to(() =>  AddListCategoryScreen());
                },
                child: Text(
                  'اضافة عمل جديد',
                  style: GoogleFonts.notoKufiArabic(
                      textStyle:  TextStyle(
                          color: AppColors().mainColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}