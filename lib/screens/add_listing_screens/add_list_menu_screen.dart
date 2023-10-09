import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rakwa/controller/image_picker_controller.dart';
import 'package:rakwa/model/add_item.dart';
import 'package:rakwa/model/create_item_model.dart';
import 'package:rakwa/screens/add_listing_screens/Controllers/add_work_controller.dart';
import 'package:rakwa/screens/add_listing_screens/add_list_social_information_screen.dart';
import 'package:rakwa/screens/add_listing_screens/add_list_subcategory_screen.dart';
import 'package:rakwa/screens/claims_screens/create_claims_screen.dart';
import 'package:rakwa/Core/utils/helpers.dart';
import 'package:rakwa/widget/TextFields/text_field_default.dart';
import 'package:rakwa/widget/app_dialog.dart';
import 'package:rakwa/widget/appbars/app_bars.dart';
import 'package:rakwa/widget/main_elevated_button.dart';
import 'package:rakwa/widget/next_step_button.dart';

import '../../app_colors/app_colors.dart';
import '../../controller/all_menu_getx_controller.dart';
import '../../widget/ButtomSheets/base_bottom_sheet.dart';
import '../../widget/my_text_field.dart';
import '../../widget/steps_widget.dart';

class AddListMenuScreen extends StatefulWidget {
  final bool isList;

   AddListMenuScreen({super.key, required this.isList});

  @override
  State<AddListMenuScreen> createState() => _AddListMenuScreenState();
}

class _AddListMenuScreenState extends State<AddListMenuScreen> {
  final ImagePickerController _imagePickerController =
      Get.put(ImagePickerController());


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Get.put(AddWorkOrAdsController(isList: widget.isList));
    AddWorkOrAdsController addWordController = Get.find();
    print(addWordController.featureImage);

    return Scaffold(
      appBar: AppBars.appBarDefault(
          title: widget.isList ? AddWorkOrAdsController.to.edit.value ? "تعديل العمل" : 'إضافة عمل' : AddWorkOrAdsController.to.edit.value ? "تعديل اعلان" : 'اضافة اعلان'),
      floatingActionButton: FloatingActionButtonNext(onTap: () {
        // if(AddWorkOrAdsController.to.edit.value){
          addWordController.navigationAfterAddMenu();
        // }else{
        //   if (checkData()) {
        //     if (_imagePickerController.images != null &&
        //         _imagePickerController.images!.isNotEmpty) {
        //       addWordController.imageGallery.clear();
        //       for (int i = 0; i < _imagePickerController.images!.length; i++) {
        //         var path = _imagePickerController.images![i].path;
        //         _imagePickerController.urls.add(path);
        //       }
        //       addWordController.imageGallery = _imagePickerController.urls;
        //     }
        //     addWordController.featureImage = _imagePickerController.image_file!.path;
        //     addWordController.navigationAfterAddImages();
        //
        //   }
        // }

      }),
//       body: GetX<AddWorkOrAdsController>(
//         builder: (controller) {
//           return ListView(
//             padding:  EdgeInsets.symmetric(horizontal: 16.w,),
//
//             // crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(
//                 height: 24,
//               ),
//               StepsWidget(selectedStep: 4),
//               const SizedBox(
//                 height: 32,
//               ),
// //               const SizedBox(
// //                 height: 12,
// //               ),
// //               Padding(
// //                 padding: const EdgeInsets.symmetric(horizontal: 16),
// //                 child: InkWell(
// //                   onTap: () async{
// //                     // await controller.getMenuFile();
// //                     AppDialog.addNewCategoryBox(context);
// //                   },
// //                   child: DottedBorder(
// //                     dashPattern: const [5, 5],
// //                     borderType: BorderType.RRect,
// //                     radius: const Radius.circular(12),
// //                     child: Container(
// //                       height: 120.h,
// //                       padding: const EdgeInsets.all(24),
// //                       decoration: BoxDecoration(
// //                         // border: Border.all(color: AppColors.kCTFFocusBorder),
// //                         borderRadius: BorderRadius.circular(12),
// //                       ),
// //                       child: Center(
// //                         child: Column(
// //                           crossAxisAlignment: CrossAxisAlignment.center,
// //                           mainAxisAlignment: MainAxisAlignment.center,
// //                           children: [
// //                             Text(
// //                               'اضف قسم جديد',
// //                               style: GoogleFonts.notoKufiArabic(
// //                                   fontSize: 14.sp,
// //                                   textStyle:
// //                                   const TextStyle(color: Color(0xFF3399CC))),
// //                             ),
// //                             SizedBox(
// //                               height: 8.h,
// //                             ),
// //                             Icon(
// //                               Icons.add,
// //                               color: AppColors().mainColor,
// //                               size: 30.w,
// //                             ),
// //
// //                           ],
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 )
// //               ),
// //
// //               ListView.builder(
// //                   padding:  EdgeInsets.symmetric(horizontal: 10.w, vertical: 16.h),
// //                   shrinkWrap: true,
// //                   physics: ScrollPhysics(),
// //                   itemCount: controller.categories.length,
// //                   itemBuilder: (context, index){
// //                 return Column(
// //                   children: [
// //                     Row(
// //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                       children: [
// //                         Text(controller.categories[index]),
// //
// //                         Row(
// //                           children: [
// //
// //                             IconButton(onPressed: (){
// //                               controller.categories.removeAt(index);
// //                             }, icon: Icon(Icons.delete, size: 14.w, color: AppColors().mainColor,)),
// //                             IconButton(onPressed: (){
// //
// //                               AppDialog.addNewCategoryBox(context, category: controller.categories[index], index: index);
// //                             }, icon: Icon(Icons.edit, size: 14.w, color: AppColors().mainColor,)),
// //                           ],
// //                         ),
// //                       ],
// //                     ),
// //                     InkWell(
// //                       onTap: (){
// //                         // AppDialog.addNewItemBox(context, category: controller.categories[index]);
// //                      // AppDialog().showBottomSheet(context);
// //                         TextEditingController name = TextEditingController();
// //                         TextEditingController desc = TextEditingController();
// //                         TextEditingController price = TextEditingController();
// //                         TextEditingController price2 = TextEditingController();
// //                         TextEditingController optionName = TextEditingController();
// //                         TextEditingController options = TextEditingController();
// //                         TextEditingController extraName = TextEditingController();
// //                         TextEditingController extraPrice = TextEditingController();
// //                         XFile? image;
// //
// //
// //
// //                         Get.put(ImagePickerController());
// //                         Get.put(AllMenusGetxController());
// //
// //                         int option = 0;
// //
// //                         GlobalKey<FormState> key= GlobalKey<FormState>();
// //                         AllMenusGetxController.to.optionsCount.clear();
// //                         AllMenusGetxController.to.optionsName.clear();
// //                         // AllMenusGetxController.to.optionsController.clear();
// //                         AllMenusGetxController.to.options.clear();
// //                         AllMenusGetxController.to.options2.clear();
// //                         AllMenusGetxController.to.options3.clear();
// //                         AllMenusGetxController.to.varents.clear();
// //                         AllMenusGetxController.to.varents2.clear();
// //                         AllMenusGetxController.to.extras2.clear();
// //                         AllMenusGetxController.to.extras.clear();
// //                         AllMenusGetxController.to.selectedValue.value = "";
// //                         AllMenusGetxController.to.editOption.value = false;
// //                         AllMenusGetxController.to.editVarents.value = false;
// //                         AllMenusGetxController.to.editExtra.value = false;
// //                         AllMenusGetxController.to.indexOptions.value = -1;
// //                         AllMenusGetxController.to.indexVarents.value = -1;
// //                         AllMenusGetxController.to.indexExtra.value = -1;
// //                         AllMenusGetxController.to.controllers.clear();
// //                         AllMenusGetxController.to.textFields.clear();
// //
// //                         AllMenusGetxController.to.controllers.add(options);
// //                         AllMenusGetxController.to.textFields.add(  TextFieldDefault(
// //                           controller: AllMenusGetxController.to.controllers.first,
// //                           upperFontSize: 12,
// //                           upperTitle: "عنصر المجموعة",
// //                           upperTitleColor: Colors.black,
// //                           hint: "مثال: كبير",
// //                           // errorText: "الحقل مطلوب",
// //
// //                         ),);
// //                       Get.bottomSheet(
// //                         Container(
// //                           height: MediaQuery.of(context).size.height * 0.9,
// //                           width: double.infinity,
// //                           padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
// //                           decoration: BoxDecoration(
// //                             color: Colors.white,
// //                             borderRadius: BorderRadius.only(
// //                               topRight: Radius.circular(20.r),
// //                               topLeft: Radius.circular(20.r),
// //                             ),
// //                           ),
// //                           child: SingleChildScrollView(
// //                             child: Form(
// //                               key: key,
// //                               child: Column(
// //                                 children: [
// //                                   const DividerBottomSheet(),
// //                                   Padding(
// //                                     padding:  EdgeInsets.symmetric(horizontal: 16.h),
// //                                     child: Align(
// //                                       alignment: Alignment.topRight,
// //                                       child: Text(
// //                                           "اضافة عنصر جديد",
// //                                           style: GoogleFonts.notoKufiArabic(
// //                                             textStyle: const TextStyle(
// //                                               fontSize: 18,
// //                                               fontWeight: FontWeight.bold,
// //                                             ),
// //                                           )
// //                                       ),
// //                                     ),
// //                                   ),
// //                                   GetX<ImagePickerController>(
// //                                       builder: (pic) {
// //                                         print(pic.path);
// //                                         return SingleChildScrollView(
// //                                           child: Column(
// //                                             mainAxisAlignment: MainAxisAlignment.start,
// //                                             children: [
// //                                               Text(
// //                                                 "اضافة عنصر جديد",
// //                                                 style: GoogleFonts.notoKufiArabic(
// //                                                   textStyle:  TextStyle(
// //                                                     color: Colors.white,
// //                                                     fontSize: 12.sp,
// //                                                     fontWeight: FontWeight.w600,
// //                                                   ),
// //                                                 ),
// //                                               ),
// //                                               SizedBox(height: 15.h,),
// //                                               Padding(
// //                                                 padding:  EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
// //                                                 child: TextFieldDefault(
// //                                                   controller: name,
// //                                                   upperFontSize: 12,
// //                                                   upperTitle: "اسم العنصر",
// //                                                   upperTitleColor: Colors.black,
// //                                                   hint: "مشاوي",
// //                                                     errorText: "الحقل مطلوب",
// //                                                 ),
// //                                               ),
// //                                               Padding(
// //                                                 padding:  EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
// //                                                 child: TextFieldDefault(
// //                                                   controller: desc,
// //                                                   upperFontSize: 12,
// //                                                   upperTitle: "وصف العنصر",
// //                                                   upperTitleColor: Colors.black,
// //                                                   hint: "مشاوي",
// //                                                   errorText: "الحقل مطلوب",
// //
// //                                                 ),
// //                                               ),
// //                                               Padding(
// //                                                 padding:  EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
// //                                                 child: TextFieldDefault(
// //                                                   controller: price,
// //                                                   upperFontSize: 12,
// //                                                   upperTitle: "سعر العنصر",
// //                                                   upperTitleColor: Colors.black,
// //                                                   hint: "12",
// //                                                     keyboardType: TextInputType.number,
// //                                                     // validation: (value){
// //                                                     //   if(value!.isEmpty){
// //                                                     //     return "الحقل مطلوب";
// //                                                     //   }
// //                                                     // }
// //                                                   errorText: "الحقل مطلوب",
// //                                                 ),
// //                                               ),
// //                                               Text(
// //                                                 "صورة العنصر",
// //                                                 style: GoogleFonts.notoKufiArabic(
// //                                                   textStyle:  TextStyle(
// //                                                     color: Colors.black,
// //                                                     fontSize: 12.sp,
// //                                                     fontWeight: FontWeight.w600,
// //                                                   ),
// //                                                 ),
// //                                                 textAlign: TextAlign.start,
// //                                               ),
// //                                               InkWell(
// //                                                 onTap: () async{
// //                                                   ImagePicker picker = ImagePicker();
// // // Pick an image.
// //                                                   image = await picker.pickImage(source: ImageSource.gallery);
// //                                                   if(image != null){
// //                                                     pic.path.value = image!.path;
// //                                                   }
// //                                                 },
// //                                                 child: Container(
// //                                                   width: 120.w,
// //                                                   height: 120.h,
// //                                                   color: Colors.grey.shade400,
// //                                                   child: image != null ? Image.file(File(pic.path.value,),fit: BoxFit.cover,) : Icon(Icons.add),
// //                                                 ),
// //                                               ),
// //
// //                                               Row(
// //                                                 children: [
// //                                                   Switch(value: pic.value.value,
// //                                                       onChanged: (v){
// //                                                         pic.value.value = v;
// //                                                       }),
// //
// //
// //                                                   Text(
// //                                                     "هل يوجد خيارات في الوجبة؟",
// //                                                     style: GoogleFonts.notoKufiArabic(
// //                                                       textStyle:  TextStyle(
// //                                                         color: Colors.black,
// //                                                         fontSize: 12.sp,
// //                                                         fontWeight: FontWeight.w600,
// //                                                       ),
// //                                                     ),
// //                                                     textAlign: TextAlign.start,
// //                                                   ),
// //                                                 ],
// //                                               ),
// //
// //                                               GetX<AllMenusGetxController>(
// //                                                   builder: (c) {
// //                                                     return Visibility(
// //                                                       visible: ImagePickerController.to.value.value,
// //                                                       child: Column(
// //                                                         children: [
// //                                                           Text(
// //                                                             "اضافة مجموعة خيارات جديدة",
// //                                                             style: GoogleFonts.notoKufiArabic(
// //                                                               textStyle:  TextStyle(
// //                                                                 color: Colors.black,
// //                                                                 fontSize: 10.sp,
// //                                                                 fontWeight: FontWeight.w600,
// //                                                               ),
// //                                                             ),
// //                                                             textAlign: TextAlign.start,
// //                                                           ),
// //                                                           // InkWell(
// //                                                           //   onTap: (){
// //                                                           //
// //                                                           //     TextEditingController c1= TextEditingController();
// //                                                           //     TextEditingController c2= TextEditingController();
// //                                                           //     AllMenusGetxController.to.optionsCount.add(option);
// //                                                           //     AllMenusGetxController.to.optionsNameController.add(c1);
// //                                                           //     AllMenusGetxController.to.optionsController.add(c2);
// //                                                           //     AllMenusGetxController.to.options.add("");
// //                                                           //     option++;
// //                                                           //     print(AllMenusGetxController.to.optionsCount);
// //                                                           //     print(AllMenusGetxController.to.optionsController);
// //                                                           //   },
// //                                                           //   child: Text(
// //                                                           //     "اضافة خيارات",
// //                                                           //     style: GoogleFonts.notoKufiArabic(
// //                                                           //       textStyle:  TextStyle(
// //                                                           //         color: Colors.white,
// //                                                           //         fontSize: 12.sp,
// //                                                           //         fontWeight: FontWeight.w600,
// //                                                           //       ),
// //                                                           //     ),
// //                                                           //     textAlign: TextAlign.start,
// //                                                           //   ),
// //                                                           // ),
// //                                                           SizedBox(height: 10.h,),
// //                                                           TextFieldDefault(
// //                                                             controller: optionName,
// //                                                             upperFontSize: 12,
// //                                                             upperTitle: "اسم المجموعة",
// //                                                             upperTitleColor: Colors.black,
// //                                                             hint: "مثال: الاحجام",
// //                                                             // errorText: "الحقل مطلوب",
// //                                                           ),
// //                                                           // MyTextField(hint: "مثال: الاحجام", controller: optionName,errorText: "الحقل مطلوب",),
// //                                                           SizedBox(height: 10.h,),
// //                                                           Row(
// //                                                             children: [
// //                                                               // SizedBox(
// //                                                               //     width: 70.w,
// //                                                               //     child: MyTextField(hint: "مثال: صغير،كبير،متوسط (تأكد من الفصل بينهم بفاصلة)", controller: options)),
// //                                                               Expanded(
// //                                                                 child: ListView.builder(
// //                                                                     itemCount: c.textFields.length,
// //                                                                    shrinkWrap: true,
// //                                                                     physics: ScrollPhysics(),
// //                                                                     itemBuilder: (context,i){
// //                                                                   return SizedBox(
// //                                                                       width: 70.w,
// //                                                                       child: c.textFields[i]);
// //                                                                 }),
// //                                                               ),
// //                                                               InkWell(
// //                                                                   onTap: (){
// //
// //
// //   TextEditingController cont  = TextEditingController();
// //
// //   c.controllers.add(cont);
// //   c.textFields.add(  TextFieldDefault(
// //     controller: cont,
// //     upperFontSize: 12,
// //     upperTitle: "عنصر المجموعة",
// //     upperTitleColor: Colors.black,
// //     hint: "مثال: كبير",
// //     errorText: "الحقل مطلوب",
// //
// //   ),);
// //
// //                                                                   },
// //                                                                   child: Icon(Icons.add)),
// //                                                             ],
// //                                                           ),
// //                                                           SizedBox(height: 10.h,),
// //                                                           InkWell(
// //                                                             onTap: (){
// //                                                               // AllMenusGetxController.to.map.addAll({
// //                                                               //   "name" : "test",
// //                                                               //   "options" : "tets 223",
// //                                                               // });
// //                                                               //
// //                                                               // if(!AllMenusGetxController.to.options.contains(c.optionsController[index].text)){
// //                                                               //   AllMenusGetxController.to.options.removeAt(index);
// //                                                               //   // c.options2.clear();
// //                                                               //   AllMenusGetxController.to.options.add(c.optionsController[index].text);
// //                                                               // }else{
// //                                                               //   // AllMenusGetxController.to.options.removeAt(index);
// //                                                               //   c.options[index] = c.optionsController[index].text;
// //                                                               // }
// //
// //                                                               // c.options2.clear();
// //                                                               // c.options2.addAll(c.options);
// //
// //                                                               // print(AllMenusGetxController.to.options.splitList((item) => false));
// //
// //                                                               // print( AllMenusGetxController.to.options);
// //
// //                                                               // c.options.clear();
// //                                                               // for(int i = 0; i < c.optionsController.length; i++){
// //                                                               c.options.addAll(options.text.split(','));
// //                                                               c.options2.add(options.text);
// //                                                               c.optionsName.add(optionName.text);
// //                                                               // }
// //
// //                                                               c.selectedValue.value = c.options.first;
// //                                                               options.clear();
// //                                                               optionName.clear();
// //
// //                                                               // for(int o = 0; o < c.options.length; )
// //                                                               // // c.options.value = c.optionsController.expand((element) => element.text).toList() as List<String>;
// //                                                               // // c.options.add(c.optionsController[]);
// //                                                               // print(AllMenusGetxController.to.options);
// //                                                               // print( AllMenusGetxController.to.optionsNameController[index].text);
// //                                                               // print( AllMenusGetxController.to.optionsController[index].text);
// //
// //                                                             },
// //                                                             child: MainElevatedButton(
// //                                                               height: 36.h,
// //                                                               width: 120.w,
// //                                                               borderRadius: 4,
// //                                                               onPressed: () {
// //                                                                 if(c.editOption.value){
// //                                                                   c.editOption.value = false;
// //
// //
// //                                                                   List<String> s = [];
// //
// //                                                                   for(int i = 0; i < c.controllers.length; i++){
// //                                                                     s.add(c.controllers[i].text);
// //                                                                     // c.options.add(c.controllers[i].text);
// //                                                                     // c.options2.addAll(controllers[i].text);
// //                                                                   }
// //                                                                   c.options3[c.indexOptions.value] = s;
// //                                                                   c.options.clear();
// //                                                                   c.options2.clear();
// //                                                                   for(int i = 0; i <  c.options3.length; i++){
// //                                                                     for(int m = 0; m < c.options3[i].length; m++){
// //                                                                       c.options.add(c.options3[i][m]);
// //                                                                       c.options2.add(c.options3[i][m]);
// //                                                                     }
// //                                                                     // s.add(c.controllers[i].text);
// //                                                                     // c.options2.addAll(controllers[i].text);
// //                                                                   }
// //
// //                                                                  c.selectedValue.value = c.options.first;
// //
// //                                                                   print(c.options);
// //                                                                   print(c.options2);
// //                                                                   c.controllers.clear();
// //                                                                   c.textFields.clear();
// //                                                                   c.controllers.add(options);
// //                                                                   c.textFields.add(  TextFieldDefault(
// //                                                                     controller: c.controllers.first,
// //                                                                     upperFontSize: 12,
// //                                                                     upperTitle: "عنصر المجموعة",
// //                                                                     upperTitleColor: Colors.black,
// //                                                                     hint: "مثال: كبير",
// //                                                                     errorText: "الحقل مطلوب",
// //
// //                                                                   ),);
// //                                                                   options.clear();
// //                                                                   optionName.clear();
// //
// //                                                                 }else{
// //                                                                   // c.options.addAll(options.text.split(','));
// //                                                                   // c.options2.add(options.text);
// //                                                                   c.options2.clear();
// //                                                                  List<String> s = [];
// //                                                                  // s.add(c.controllers[index].text);
// //                                                                   for(int i = 0; i < c.controllers.length; i++){
// //                                                                     c.options2.add(c.controllers[i].text);
// //                                                                     c.options.add(c.controllers[i].text);
// //                                                                     s.add(c.controllers[i].text);
// //                                                                   }
// //
// //                                                                   c.options3.add(s);
// //
// //                                                                   print(c.options3);
// //                                                                   // }
// //
// //                                                                   c.optionsName.add(optionName.text);
// //                                                                   // for(int i = 0; i < c.optionsName.length; i++){
// //                                                                   // }
// //                                                                   c.selectedValue.value = c.options.first;
// //                                                                   c.controllers.clear();
// //                                                                   c.textFields.clear();
// //                                                                   c.controllers.add(options);
// //                                                                   c.textFields.add(  TextFieldDefault(
// //                                                                     controller: c.controllers.first,
// //                                                                     upperFontSize: 12,
// //                                                                     upperTitle: "عنصر المجموعة",
// //                                                                     upperTitleColor: Colors.black,
// //                                                                     hint: "مثال: كبير",
// //                                                                   ),);
// //                                                                   options.clear();
// //                                                                   optionName.clear();
// //                                                                 }
// //
// //                                                               },
// //                                                               child: Text(
// //                                                                 c.editOption.value  ? "تعديل المجموعة": "اضافة المجموعة",
// //                                                                 style: GoogleFonts.notoKufiArabic(
// //                                                                   textStyle:  TextStyle(
// //                                                                     color: Colors.white,
// //                                                                     fontSize: 10.sp,
// //                                                                     fontWeight: FontWeight.w600,
// //                                                                   ),
// //                                                                 ),
// //                                                                 textAlign: TextAlign.start,
// //                                                               ),
// //                                                             ),
// //                                                           ),
// //                                                           SizedBox(width: 10.w,),
// //                                                           Divider(),
// //
// //                                                           ListView.builder(
// //                                                               itemCount: c.optionsName.length,
// //                                                               shrinkWrap: true,
// //                                                               physics: ScrollPhysics(),
// //                                                               itemBuilder: (context, idx){
// //                                                                 return Row(
// //                                                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                                                                   children: [
// //                                                                     Expanded(
// //                                                                       child: Column(
// //                                                                         crossAxisAlignment: CrossAxisAlignment.start,
// //                                                                         children: [
// //                                                                           Text(c.optionsName[idx], style: GoogleFonts.notoKufiArabic(
// //                                                                             textStyle:  TextStyle(
// //                                                                               color: Colors.black,
// //                                                                               fontSize: 12.sp,
// //                                                                               fontWeight: FontWeight.w600,
// //                                                                             ),
// //                                                                           ),),
// //                                                                           Text(c.options3[idx].toString(), style: GoogleFonts.notoKufiArabic(
// //                                                                             textStyle:  TextStyle(
// //                                                                               color: Colors.black,
// //                                                                               fontSize: 12.sp,
// //                                                                               fontWeight: FontWeight.w600,
// //                                                                             ),
// //                                                                           ),),
// //                                                                           // Text(c.varents2[index]),
// //                                                                         ],
// //                                                                       ),
// //                                                                     ),
// //                                                                     Row(
// //                                                                       children: [
// //                                                                         IconButton(onPressed: (){
// //                                                                           optionName.text = c.optionsName[idx];
// //                                                                           c.indexOptions.value = idx;
// //                                                                           print( c.indexOptions.value);
// //                                                                           c.editOption.value = true;
// //                                                                           print(c.options3.length);
// //                                                                           c.controllers.value = List.generate(c.options3[idx].length, (index) => TextEditingController());
// //                                                                           c.textFields.value = List.generate(c.options3[idx].length, (index) =>   TextFieldDefault(
// //                                                                             controller: c.controllers[index],
// //                                                                             upperFontSize: 12,
// //                                                                             upperTitle: "عنصر المجموعة",
// //                                                                             upperTitleColor: Colors.black,
// //                                                                             hint: "مثال: كبير",
// //                                                                             errorText: "الحقل مطلوب",
// //
// //                                                                           ),);
// //
// //                                                                           for(int m = 0; m < c.controllers.length; m++){
// //                                                                             for(int z = 0; z < c.options3[idx].length; z++){
// //                                                                               c.controllers[m].text = c.options3[idx][m];
// //                                                                             }
// //                                                                           }
// //                                                                           }, icon: Icon(Icons.edit, color: AppColors().mainColor,)),
// //                                                                         IconButton(onPressed: (){
// //                                                                           c.indexOptions.value = idx;
// //                                                                           c.optionsName.removeAt(c.indexOptions.value);
// //                                                                           c.options3.removeAt(c.indexOptions.value);
// //                                                                           c.options3.clear();
// //                                                                           c.optionsName.clear();
// //                                                                           setState(() {
// //
// //                                                                           });
// //                                                                         }, icon: Icon(Icons.delete, color: AppColors().mainColor,)),
// //                                                                       ],
// //                                                                     )
// //                                                                   ],
// //                                                                 );
// //                                                               }),
// //
// //                                                           // ListView.builder(
// //                                                           //     itemCount: c.optionsCount.length,
// //                                                           //     shrinkWrap: true,
// //                                                           //     physics: ScrollPhysics(),
// //                                                           //     itemBuilder: (context, index){
// //                                                           //       return  Column(
// //                                                           //         children: [
// //                                                           //           Row(
// //                                                           //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                                                           //             children: [
// //                                                           //               Expanded(
// //                                                           //                 flex: 3,
// //                                                           //                 child: Column(
// //                                                           //                   children: [
// //                                                           //                     MyTextField(hint: "الاحجام", controller: c.optionsNameController[index]),
// //                                                           //                     SizedBox(height: 10.h,),
// //                                                           //                     MyTextField(hint: "صغير،كبير،متوسط", controller: c.optionsController[index]),
// //                                                           //                   ],
// //                                                           //                 ),
// //                                                           //               ),
// //                                                           //               SizedBox(width: 10.w,),
// //                                                           //               InkWell(
// //                                                           //                 onTap: (){
// //                                                           //                   // AllMenusGetxController.to.map.addAll({
// //                                                           //                   //   "name" : "test",
// //                                                           //                   //   "options" : "tets 223",
// //                                                           //                   // });
// //                                                           //                   //
// //                                                           //                   // if(!AllMenusGetxController.to.options.contains(c.optionsController[index].text)){
// //                                                           //                   //   AllMenusGetxController.to.options.removeAt(index);
// //                                                           //                   //   // c.options2.clear();
// //                                                           //                   //   AllMenusGetxController.to.options.add(c.optionsController[index].text);
// //                                                           //                   // }else{
// //                                                           //                   //   // AllMenusGetxController.to.options.removeAt(index);
// //                                                           //                   //   c.options[index] = c.optionsController[index].text;
// //                                                           //                   // }
// //                                                           //
// //                                                           //                   // c.options2.clear();
// //                                                           //           // c.options2.addAll(c.options);
// //                                                           //
// //                                                           //                   // print(AllMenusGetxController.to.options.splitList((item) => false));
// //                                                           //
// //                                                           //                   // print( AllMenusGetxController.to.options);
// //                                                           //
// //                                                           //                   c.options.clear();
// //                                                           //                   for(int i = 0; i < c.optionsController.length; i++){
// //                                                           //                     c.options.addAll(c.optionsController[i].text.split(','));
// //                                                           //                   }
// //                                                           //
// //                                                           //                   c.selectedValue.value = c.options.first;
// //                                                           //                   // for(int o = 0; o < c.options.length; )
// //                                                           //                   // // c.options.value = c.optionsController.expand((element) => element.text).toList() as List<String>;
// //                                                           //                   // // c.options.add(c.optionsController[]);
// //                                                           //                   // print(AllMenusGetxController.to.options);
// //                                                           //                   // print( AllMenusGetxController.to.optionsNameController[index].text);
// //                                                           //                   // print( AllMenusGetxController.to.optionsController[index].text);
// //                                                           //
// //                                                           //                 },
// //                                                           //                 child: Text(
// //                                                           //                   "اضف",
// //                                                           //                   style: GoogleFonts.notoKufiArabic(
// //                                                           //                     textStyle:  TextStyle(
// //                                                           //                       color: Colors.white,
// //                                                           //                       fontSize: 10.sp,
// //                                                           //                       fontWeight: FontWeight.w600,
// //                                                           //                     ),
// //                                                           //                   ),
// //                                                           //                   textAlign: TextAlign.start,
// //                                                           //                 ),
// //                                                           //               ),
// //                                                           //
// //                                                           //             ],
// //                                                           //           ),
// //                                                           //           SizedBox(width: 10.w,),
// //                                                           //           Divider(),
// //                                                           //           // DropdownButton(items: c.optionsNameController.map((e) => DropdownMenuItem(child: Text("we sdds"))).toList(), onChanged: (value){})
// //                                                           //         ],
// //                                                           //       );
// //                                                           //     }),
// //                                                           // GetX<AllMenusGetxController>(
// //                                                           //   builder: (con) {
// //                                                           //     print(con.options);
// //                                                           //     return SizedBox(
// //                                                           //       height: 120.h,
// //                                                           //       child: ListView.builder(
// //                                                           //         itemCount: con.optionsController.length,
// //                                                           //         shrinkWrap: true,
// //                                                           //         physics: ScrollPhysics(),
// //                                                           //         itemBuilder: (context, index) {
// //                                                           //           return Row(
// //                                                           //             children: [
// //                                                           //               MyTextField(hint: "السعر", controller: con.optionsController[index]),
// //                                                           //               DropdownButton<String>(items: con.options.map((e) => DropdownMenuItem<String>(child: Text(e),value: e,)).toList(), onChanged: (value){}),
// //                                                           //             ],
// //                                                           //           );
// //                                                           //         }
// //                                                           //       ),
// //                                                           //     );
// //                                                           //   }
// //                                                           // ),
// //                                                           Visibility(
// //                                                             visible: c.selectedValue.isNotEmpty,
// //                                                             child: Column(
// //                                                               children: [
// //                                                                 Row(
// //                                                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                                                                   children: [
// //                                                                     Row(
// //                                                                       children: [
// //                                                                         SizedBox(
// //                                                                             width:90.w,
// //                                                                             child: MyTextField(hint: "السعر", controller: price2)),
// //                                                                         SizedBox(width: 20.w,),
// //                                                                         DropdownButton<String>(
// //
// //                                                                           dropdownColor: Colors.white,
// //                                                                           items: c.options.map((e) => DropdownMenuItem<String>(child: Text(e, style: GoogleFonts.notoKufiArabic(
// //                                                                             textStyle:  TextStyle(
// //                                                                               color: Colors.black,
// //                                                                               fontSize: 10.sp,
// //                                                                               fontWeight: FontWeight.w600,
// //                                                                             ),
// //                                                                           ),),value: e,),).toList(), onChanged: (value){
// //                                                                           c.selectedValue.value = value!;
// //                                                                         },hint: Text("اختار", style: GoogleFonts.notoKufiArabic(
// //                                                                           textStyle:  TextStyle(
// //                                                                             color: Colors.black,
// //                                                                             fontSize: 10.sp,
// //                                                                             fontWeight: FontWeight.w600,
// //                                                                           ),
// //                                                                         ),),
// //                                                                           value: c.selectedValue.value,),
// //                                                                       ],
// //                                                                     ),
// //
// //
// //                                                                     InkWell(
// //                                                                       onTap: (){
// //                                                                         if(c.editVarents.value){
// //                                                                           c.varents[c.indexVarents.value] = price2.text;
// //                                                                           c.varents2[c.indexVarents.value] = c.selectedValue.value;
// //                                                                           price2.text = "";
// //
// //                                                                         }else{
// //                                                                           if(price2.text.isNotEmpty){
// //                                                                             c.varents.add(price2.text);
// //                                                                             c.varents2.add(c.selectedValue.value);
// //                                                                             price2.text = "";
// //                                                                           }else{
// //                                                                             Fluttertoast.showToast(msg: "ادخل السعر");
// //                                                                           }
// //
// //                                                                         }
// //
// //                                                                       },
// //                                                                       child: Text(
// //                                                                       c.editVarents.value ? "تعديل" :  "اضف",
// //                                                                         style: GoogleFonts.notoKufiArabic(
// //                                                                           textStyle:  TextStyle(
// //                                                                             color: AppColors().mainColor,
// //                                                                             fontSize: 10.sp,
// //                                                                             fontWeight: FontWeight.w600,
// //                                                                           ),
// //                                                                         ),
// //                                                                         textAlign: TextAlign.start,
// //                                                                       ),
// //                                                                     ),
// //
// //
// //                                                                   ],
// //                                                                 ),
// //                                                                 ListView.builder(
// //                                                                     itemCount: c.varents.length,
// //                                                                     shrinkWrap: true,
// //                                                                     physics: ScrollPhysics(),
// //                                                                     itemBuilder: (context, index){
// //                                                                       return Row(
// //                                                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                                                                         children: [
// //                                                                           Row(
// //                                                                             children: [
// //                                                                               Text("₺ ${c.varents[index]}", style: GoogleFonts.notoKufiArabic(
// //                                                                                 textStyle:  TextStyle(
// //                                                                                   color: Colors.black,
// //                                                                                   fontSize: 12.sp,
// //                                                                                   fontWeight: FontWeight.w600,
// //                                                                                 ),
// //                                                                               ),),
// //                                                                               SizedBox(width: 10.w,),
// //                                                                               Text(c.varents2[index], style: GoogleFonts.notoKufiArabic(
// //                                                                                 textStyle:  TextStyle(
// //                                                                                   color: Colors.black,
// //                                                                                   fontSize: 12.sp,
// //                                                                                   fontWeight: FontWeight.w600,
// //                                                                                 ),
// //                                                                               ),),
// //                                                                             ],
// //                                                                           ),
// //                                                                           Row(
// //                                                                             children: [
// //                                                                               IconButton(onPressed: (){
// //
// //                                                                                 c.indexVarents.value = index;
// //                                                                               price2.text = c.varents[index];
// //                                                                               c.selectedValue.value = c.varents2[index];
// //                                                                               c.editVarents.value = true;
// //                                                                                 // optionName.text = c.optionsName[idx];
// //                                                                                 // c.indexOptions.value = idx;
// //                                                                                 // print( c.indexOptions.value);
// //                                                                                 // c.edit.value = true;
// //                                                                                 // print(c.options3.length);
// //                                                                                 // c.controllers.value = List.generate(c.options3[idx].length, (index) => TextEditingController());
// //                                                                                 // c.textFields.value = List.generate(c.options3[idx].length, (index) => MyTextField(hint: "كبير", controller: c.controllers[index]));
// //                                                                                 //
// //                                                                                 // for(int m = 0; m < c.controllers.length; m++){
// //                                                                                 //   for(int z = 0; z < c.options3[idx].length; z++){
// //                                                                                 //     c.controllers[m].text = c.options3[idx][m];
// //                                                                                 //   }
// //                                                                                 // }
// //                                                                               }, icon: Icon(Icons.edit, color: AppColors().mainColor,)),
// //                                                                               IconButton(onPressed: (){
// //                                                                                 c.indexVarents.value = index;
// //                                                                                 c.varents.removeAt(c.indexVarents.value);
// //                                                                                 c.varents2.removeAt(c.indexVarents.value);
// //                                                                                 c.varents.refresh();
// //                                                                                 c.varents2.refresh();
// //                                                                                 // c.options3.clear();
// //                                                                                 // c.optionsName.clear();
// //                                                                                 // setState(() {
// //                                                                                 //
// //                                                                                 // });
// //                                                                               }, icon: Icon(Icons.delete, color: AppColors().mainColor,)),
// //                                                                             ],
// //                                                                           )
// //
// //                                                                         ],
// //                                                                       );
// //                                                                     })
// //                                                               ],
// //                                                             ),
// //                                                           ),
// //
// //                                                           Column(
// //                                                             crossAxisAlignment: CrossAxisAlignment.start,
// //
// //                                                             children: [
// //                                                               Text(
// //                                                                 "اضافات على الوجبة",
// //                                                                 style: GoogleFonts.notoKufiArabic(
// //                                                                   textStyle:  TextStyle(
// //                                                                     color: Colors.black,
// //                                                                     fontSize: 13.sp,
// //                                                                     fontWeight: FontWeight.w600,
// //                                                                   ),
// //                                                                 ),
// //                                                                 textAlign: TextAlign.start,
// //                                                               ),
// //                                                               Row(
// //                                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                                                                 children: [
// //                                                                   Expanded(
// //                                                                     flex: 3,
// //                                                                     child: Column(
// //                                                                       children: [
// //                                                                         MyTextField(hint: "اسم الاضافة", controller: extraName),
// //                                                                         SizedBox(height: 10.h,),
// //                                                                         MyTextField(hint: "السعر", controller: extraPrice),
// //                                                                       ],
// //                                                                     ),
// //                                                                   ),
// //
// //                                                                   SizedBox(width: 10.w,),
// //
// //                                                                   InkWell(
// //                                                                     onTap: (){
// //
// //                                                                       if(c.editExtra.value){
// //                                                                         c.extras2[c.indexExtra.value] = extraName.text;
// //                                                                         c.extras[c.indexExtra.value] = extraPrice.text;
// //                                                                         extraPrice.text = "";
// //                                                                       extraName.text = "";
// //                                                                       c.editExtra.value = false;
// //                                                                       }else{
// //
// //                                                                         if(extraPrice.text.isNotEmpty){
// //                                                                           if(extraName.text.isNotEmpty){
// //                                                                             c.extras.add(extraPrice.text);
// //                                                                             c.extras2.add(extraName.text);
// //                                                                             extraPrice.text = "";
// //                                                                             extraName.text = "";
// //                                                                           }else{
// //                                                                             Fluttertoast.showToast(msg: "ادخل اسم الاضافة");
// //                                                                           }
// //                                                                         }else if(extraName.text.isNotEmpty){
// //                                                                           if(extraPrice.text.isNotEmpty){
// //                                                                             c.extras.add(extraPrice.text);
// //                                                                             c.extras2.add(extraName.text);
// //                                                                             extraPrice.text = "";
// //                                                                             extraName.text = "";
// //                                                                           }else{
// //                                                                             Fluttertoast.showToast(msg: "ادخل سعر الاضافة");
// //                                                                           }
// //                                                                         }
// //
// //                                                                       }
// //
// //                                                                     },
// //                                                                     child: Text(
// //                                                                      c.editExtra.value ? "تعديل" : "اضف",
// //                                                                       style: GoogleFonts.notoKufiArabic(
// //                                                                         textStyle:  TextStyle(
// //                                                                           color: AppColors().mainColor,
// //                                                                           fontSize: 10.sp,
// //                                                                           fontWeight: FontWeight.w600,
// //                                                                         ),
// //                                                                       ),
// //                                                                       textAlign: TextAlign.start,
// //                                                                     ),
// //                                                                   ),
// //
// //
// //                                                                 ],
// //                                                               ),
// //                                                               ListView.builder(
// //                                                                   itemCount: c.extras2.length,
// //                                                                   shrinkWrap: true,
// //                                                                   physics: ScrollPhysics(),
// //                                                                   itemBuilder: (context, index){
// //                                                                     return Row(
// //                                                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                                                                       children: [
// //                                                                         Row(
// //                                                                           children: [
// //                                                                             Text("₺ ${c.extras[index]}", style: GoogleFonts.notoKufiArabic(
// //                                                                               textStyle:  TextStyle(
// //                                                                                 color: Colors.black,
// //                                                                                 fontSize: 12.sp,
// //                                                                                 fontWeight: FontWeight.w600,
// //                                                                               ),
// //                                                                             ),),
// //                                                                             SizedBox(width: 10.w,),
// //                                                                             Text(c.extras2[index], style: GoogleFonts.notoKufiArabic(
// //                                                                               textStyle:  TextStyle(
// //                                                                                 color: Colors.black,
// //                                                                                 fontSize: 12.sp,
// //                                                                                 fontWeight: FontWeight.w600,
// //                                                                               ),
// //                                                                             ),),
// //                                                                           ],
// //                                                                         ),
// //                                                                         Row(
// //                                                                           children: [
// //                                                                             IconButton(onPressed: (){
// //
// //                                                                               c.indexExtra.value = index;
// //                                                                               extraPrice.text = c.extras[index];
// //                                                                               extraName.text = c.extras2[index];
// //                                                                               c.editExtra.value = true;
// //                                                                               // optionName.text = c.optionsName[idx];
// //                                                                               // c.indexOptions.value = idx;
// //                                                                               // print( c.indexOptions.value);
// //                                                                               // c.edit.value = true;
// //                                                                               // print(c.options3.length);
// //                                                                               // c.controllers.value = List.generate(c.options3[idx].length, (index) => TextEditingController());
// //                                                                               // c.textFields.value = List.generate(c.options3[idx].length, (index) => MyTextField(hint: "كبير", controller: c.controllers[index]));
// //                                                                               //
// //                                                                               // for(int m = 0; m < c.controllers.length; m++){
// //                                                                               //   for(int z = 0; z < c.options3[idx].length; z++){
// //                                                                               //     c.controllers[m].text = c.options3[idx][m];
// //                                                                               //   }
// //                                                                               // }
// //                                                                             }, icon: Icon(Icons.edit, color: AppColors().mainColor,)),
// //                                                                             IconButton(onPressed: (){
// //                                                                               c.indexExtra.value = index;
// //                                                                               c.extras.removeAt(c.indexVarents.value);
// //                                                                               c.extras2.removeAt(c.indexVarents.value);
// //                                                                               c.extras.refresh();
// //                                                                               c.extras2.refresh();
// //                                                                               // c.options3.clear();
// //                                                                               // c.optionsName.clear();
// //                                                                               // setState(() {
// //                                                                               //
// //                                                                               // });
// //                                                                             }, icon: Icon(Icons.delete, color: AppColors().mainColor,)),
// //                                                                           ],
// //                                                                         )
// //                                                                       ],
// //                                                                     );
// //                                                                   })
// //                                                             ],
// //                                                           )
// //
// //                                                         ],
// //                                                       ),
// //                                                     );
// //                                                   }
// //                                               ),
// //
// //                                               MainElevatedButton(
// //                                                 height: 48.h,
// //                                                 width: Get.width / 1.2,
// //                                                 onPressed: (){
// //
// //                                                   print("Extra :::${AllMenusGetxController.to.extras.length}");
// //                                                   print("Extra :::${AllMenusGetxController.to.extras2.length}");
// //                                                   print("Extra :::${AllMenusGetxController.to.varents2.length}");
// //                                                   print("Extra :::${AllMenusGetxController.to.varents.length}");
// //                                                   print("Extra :::${AllMenusGetxController.to.options.length}");
// //                                                   print("Extra :::${AllMenusGetxController.to.options3.length}");
// //                                                   print("Extra :::${AllMenusGetxController.to.options2.length}");
// //
// //
// //                                                   if(key.currentState!.validate()){
// //                                                     AddItem item = AddItem();
// //                                                     item.categoryName = controller.categories[index];
// //                                                     item.itemName = name.text;
// //                                                     item.item_price = int.parse(price.text);
// //                                                     item.itemDesc = desc.text;
// //                                                     item.item_image= pic.path.value;
// //                                                     AddWorkOrAdsController.to.items.add(item);
// //                                                     Navigator.pop(context);
// //                                                   }else{
// //
// //                                                   }
// //
// //                                                 },
// //                                                 borderRadius: 5,
// //                                                 child: Text(
// //                                                   " اضافةالعنصر",
// //                                                   style: GoogleFonts.notoKufiArabic(
// //                                                     textStyle:  TextStyle(
// //                                                       color: Colors.white,
// //                                                       fontSize: 12.sp,
// //                                                       fontWeight: FontWeight.w600,
// //                                                     ),
// //                                                   ),
// //                                                 ),
// //                                               ),
// //                                             ],
// //                                           ),
// //                                         );
// //                                       }
// //                                   )                            ],
// //                               ),
// //                             ),
// //                           ),
// //                         ),
// //                         isScrollControlled: true,
// //                         enableDrag: true,
// //
// //                       );
// //                         //  showMaterialModalBottomSheet(
// //                         // // expand: false,
// //                         //    // isScrollControlled: true,
// //                         //    // constraints: BoxConstraints(
// //                         //    //   maxHeight: Get.width / 1.2
// //                         //    // ),
// //                         //
// //                         //
// //                         // context: context,
// //                         // backgroundColor: Colors.transparent,
// //                         //
// //                         // builder: (context) => Container(color: Colors.red, height: Get.width,child: InkWell( onTap: () => appModalBottomSheet(context),child: Text("click")),),
// //                         // );
// //                       },
// //                       child: Row(
// //                         children: [
// //                           Text(
// //                             'اضف عنصر جديد',
// //                             style: GoogleFonts.notoKufiArabic(
// //                                 fontSize: 10.sp,
// //                                 textStyle:
// //                                 const TextStyle(color: Color(0xFF3399CC))),
// //                           ),
// //                           SizedBox(
// //                             height: 8.h,
// //                           ),
// //                           Icon(
// //                             Icons.add,
// //                             color: AppColors().mainColor,
// //                             size: 10.w,
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //
// //                     GetX<AddWorkOrAdsController>(
// //                       builder: (c) {
// //                         return ListView.builder(
// //                           shrinkWrap: true,
// //                             physics: ScrollPhysics(),
// //                             itemCount: c.items.where((p0) => p0.categoryName == controller.categories[index]).length,
// //                             itemBuilder: (context, i){
// //                           return Row(
// //                             children: [
// //                               Text(
// //                                 c.items.where((p0) => p0.categoryName == controller.categories[index]).toList()[i].itemName ?? "",
// //                                 style: GoogleFonts.notoKufiArabic(
// //                                     fontSize: 10.sp,
// //                                     textStyle:
// //                                     const TextStyle(color: Color(0xFF3399CC))),
// //                               ),
// //                               Image.file(File(c.items.where((p0) => p0.categoryName == controller.categories[index]).toList()[i].item_image ?? "" ?? ""),fit: BoxFit.cover,width: 50.w, height: 50.h,)
// //                             ],
// //                           );
// //                         });
// //                       }
// //                     ),
// //                     Divider(),
// //                   ],
// //                 );
// //               }),
// //               const SizedBox(
// //                 height: 32,
// //               ),
//               // Padding(
//               //     padding: const EdgeInsets.symmetric(horizontal: 16),
//               //     child: InkWell(
//               //       onTap: () async{
//               //         // await controller.getMenuFile();
//               //       },
//               //       child: DottedBorder(
//               //         dashPattern: const [5, 5],
//               //         borderType: BorderType.RRect,
//               //         radius: const Radius.circular(12),
//               //         child: Container(
//               //           height: 120.h,
//               //           padding: const EdgeInsets.all(24),
//               //           decoration: BoxDecoration(
//               //             // border: Border.all(color: AppColors.kCTFFocusBorder),
//               //             borderRadius: BorderRadius.circular(12),
//               //           ),
//               //           child: Center(
//               //             child: Column(
//               //               crossAxisAlignment: CrossAxisAlignment.center,
//               //               mainAxisAlignment: MainAxisAlignment.center,
//               //               children: [
//               //                 Text(
//               //                   'اضف عنصر جديد',
//               //                   style: GoogleFonts.notoKufiArabic(
//               //                       fontSize: 14.sp,
//               //                       textStyle:
//               //                       const TextStyle(color: Color(0xFF3399CC))),
//               //                 ),
//               //                 SizedBox(
//               //                   height: 8.h,
//               //                 ),
//               //                 Icon(
//               //                   Icons.add,
//               //                   color: AppColors().mainColor,
//               //                   size: 30.w,
//               //                 ),
//               //
//               //               ],
//               //             ),
//               //           ),
//               //         ),
//               //       ),
//               //     )
//               // ),
//
//               // Padding(
//               //   padding: const EdgeInsets.symmetric(horizontal: 16),
//               //   child: TextFieldDefault(
//               //     controller: addWordController.menuController,
//               //     upperTitle: "رابط المنيو",
//               //     hint: "في حال لا يوجد بالوقت الحالي رابط اتركه فارغاً",
//               //   ),
//               // ),
//             ],
//           );
//         }
//       ),
    body:   ListView(
      padding:  EdgeInsets.symmetric(horizontal: 16.w,),

      children: [
            // crossAxisAlignment: CrossAxisAlignment.start,
              const SizedBox(
                height: 24,
              ),
              StepsWidget(selectedStep: 4),
              const SizedBox(
                height: 32,
              ),
//               const SizedBox(
//                 height: 12,
//               ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextFieldDefault(
            controller: addWordController.menuController,
            upperTitle: "رابط المنيو",
            hint: "في حال لا يوجد بالوقت الحالي رابط اتركه فارغاً",
          ),
        ),
      ],
    ),
    );
  }

  bool checkData() {
    if (_imagePickerController.menuFile != null) {
      return true;
    }
    ShowMySnakbar(
        title: 'لم تقم باختيار صورة رئيسية',
        message: ' يجب عليك اختيار صورة رئيسية ',
        backgroundColor: Colors.red.shade700);
    return false;
  }

// CreateItemModel get createItemModel {
  void appModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Text("Common bottomSheet");
      },
    );
  }
}
