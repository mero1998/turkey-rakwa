import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakwa/Core/utils/extensions.dart';
import 'package:rakwa/app_colors/app_colors.dart';
import 'package:rakwa/model/create_item_model.dart';
import 'package:rakwa/screens/add_listing_screens/Controllers/add_work_controller.dart';
import 'package:rakwa/screens/add_listing_screens/add_list_images_screen.dart';
import 'package:rakwa/screens/add_listing_screens/add_list_subcategory_screen.dart';
import 'package:rakwa/Core/utils/helpers.dart';
import 'package:rakwa/widget/TextFields/text_field_default.dart';
import 'package:rakwa/widget/TextFields/validator.dart';
import 'package:rakwa/widget/appbars/app_bars.dart';
import 'package:rakwa/widget/label_text.dart';
import 'package:rakwa/widget/my_text_field.dart';

import '../../widget/next_step_button.dart';
import '../../widget/steps_widget.dart';
import '../../widget/work_hour_widget.dart';

class AddListWorkDaysScreen extends StatefulWidget {
  // final CreateItemModel createItemModel;
  final bool isList;

  const AddListWorkDaysScreen({super.key,  required this.isList});

  @override
  State<AddListWorkDaysScreen> createState() => _AddListWorkDaysScreenState();
}

class _AddListWorkDaysScreenState extends State<AddListWorkDaysScreen>
    with Helpers {



  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  String getTitle(){
    if(AddWorkOrAdsController.to.isList){
      if(AddWorkOrAdsController.to.edit.value){
        return "تعديل عمل";
      }else{
        return "اضافة عمل";
      }
    }else{
      if(AddWorkOrAdsController.to.edit.value){
        return "تعديل اعلان";
      }else{
        return "اضافة اعلان";
      }
    }

  }
  @override
  Widget build(BuildContext context) {


    var node = FocusScope.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBars.appBarDefault(
          title: getTitle()),
      floatingActionButton: FloatingActionButtonNext(
        onTap: () {
          if(AddWorkOrAdsController.to.itemHours.isNotEmpty){
            AddWorkOrAdsController.to.itemHours.clear();
          }
          if (widget.isList) {
            final localizations = MaterialLocalizations.of(context);
            for (var i = 0; i < AddWorkOrAdsController.to.days.length; i++) {
              if (AddWorkOrAdsController.to.days[i][1] == true) {
                final start = localizations.formatTimeOfDay(AddWorkOrAdsController.to.days[i][2],
                    alwaysUse24HourFormat: true);
                final end = localizations.formatTimeOfDay(AddWorkOrAdsController.to.days[i][3],
                    alwaysUse24HourFormat: true);
                AddWorkOrAdsController.to.itemHours.add('${AddWorkOrAdsController.to.days[i][4]} $start $end');
                // createItemModel.itemHours.add('${days[i][4]} $start $end');

                print("Items hours :: ${AddWorkOrAdsController.to.itemHours}");
              }
            }
          } else {
            // createItemModel.price = _priceController.text;
          }
          AddWorkOrAdsController.to.navigationAfterAddWorkDay(globalKey);
        },
      ),
      body: widget.isList
          ? Column(
              children: [
                const SizedBox(
                  height: 24,
                ),
                StepsWidget(selectedStep: 3),
                const SizedBox(
                  height: 32,
                ),
                Expanded(
                    child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: AddWorkOrAdsController.to.days.length,
                  itemBuilder: (context, index) {
                    return WorkHourWidget(
                      amChild: Text(
                        'من ${AddWorkOrAdsController.to.days[index][2].hour}:${AddWorkOrAdsController.to.days[index][2].minute}',
                        style: GoogleFonts.notoKufiArabic(
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      pmChild: Text(
                        'الى ${AddWorkOrAdsController.to.days[index][3].hour}:${AddWorkOrAdsController.to.days[index][3].minute}',
                        style: GoogleFonts.notoKufiArabic(
                            textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        )),
                      ),
                      onTapAm: () async {
                        TimeOfDay? newTime = await showTimePicker(
                          context: context,
                          initialTime: AddWorkOrAdsController.to.days[index][2],
                          cancelText: 'الغاء',
                          confirmText: 'تم',
                          builder: (context, child) {
                            return Theme(
                                data: ThemeData.light().copyWith(
                                  colorScheme:  ColorScheme.light(
                                    // change the border color
                                    primary: AppColors().mainColor,
                                    // change the text color
                                    onSurface: Colors.black,
                                  ),
                                  // button colors
                                  buttonTheme:  ButtonThemeData(
                                    colorScheme: ColorScheme.light(
                                      primary: AppColors().mainColor,
                                    ),
                                  ),
                                ),
                                child: child!);
                          },
                        );
                        if (newTime != null) {
                          setState(() {
                            AddWorkOrAdsController.to.days[index][2] = newTime;
                          });
                        }
                      },
                      onTapPm: () async {
                        TimeOfDay? newTime = await showTimePicker(
                          context: context,
                          initialTime: AddWorkOrAdsController.to.days[index][3],
                          cancelText: 'الغاء',
                          confirmText: 'تم',
                          builder: (context, child) {
                            return Theme(
                                data: ThemeData.light().copyWith(
                                  colorScheme:  ColorScheme.light(
                                    // change the border color
                                    primary: AppColors().mainColor,
                                    // change the text color
                                    onSurface: Colors.black,
                                  ),
                                  // button colors
                                  buttonTheme:  ButtonThemeData(
                                    colorScheme: ColorScheme.light(
                                      primary: AppColors().mainColor,
                                    ),
                                  ),
                                ),
                                child: child!);
                          },
                        );
                        if (newTime != null) {
                          setState(() {
                            AddWorkOrAdsController.to.days[index][3] = newTime;
                          });
                        }
                      },
                      day: AddWorkOrAdsController.to.days[index][0],
                      isChecked: AddWorkOrAdsController.to.days[index][1],
                      onChanged: (p0) {
                        setState(() {
                          AddWorkOrAdsController.to.days[index][1] = !AddWorkOrAdsController.to.days[index][1];

                          print(AddWorkOrAdsController.to.days);
                        });
                      },
                    );
                  },
                )),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 100,
                ),
              ],
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: globalKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    GetBuilder<AddWorkOrAdsController>(
                      builder:(_) =>  TextFieldDefault(
                        upperTitle: "السعر",
                        hint: 'ادخل السعر',
                        controller: _.priceController,

                        // prefixIconData: Icons.lock_outline,
                        validation: priceValidator,
                        onComplete: () {
                          node.unfocus();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // CreateItemModel get createItemModel {
  //   CreateItemModel createItemModel = widget.createItemModel;
  //
  //   if (widget.isList) {
  //     final localizations = MaterialLocalizations.of(context);
  //     for (var i = 0; i < days.length; i++) {
  //       if (days[i][1] == true) {
  //         final start = localizations.formatTimeOfDay(days[i][2],
  //             alwaysUse24HourFormat: true);
  //         final end = localizations.formatTimeOfDay(days[i][3],
  //             alwaysUse24HourFormat: true);
  //         print(start);
  //         print(end);
  //
  //         createItemModel.itemHours.add('${days[i][4]} $start $end');
  //       }
  //     }
  //     print(createItemModel.itemHours);
  //   } else {
  //     createItemModel.price = _priceController.text;
  //   }
  //
  //   return createItemModel;
  // }
}