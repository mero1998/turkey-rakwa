import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rakwa/api/api_controllers/menu_api_controller.dart';
import 'package:rakwa/controller/all_cart_getx_controller.dart';
import 'package:rakwa/controller/all_menu_getx_controller.dart';
import 'package:rakwa/model/categories.dart';
import 'package:rakwa/widget/app_dialog.dart';
import 'package:shimmer/shimmer.dart';

import '../../app_colors/app_colors.dart';
import '../../controller/image_picker_controller.dart';
import '../../model/add_item.dart';
import '../../widget/TextFields/text_field_default.dart';
import '../../widget/appbars/app_bars.dart';
import '../../widget/main_elevated_button.dart';
import '../../widget/my_text_field.dart';
import '../add_listing_screens/Controllers/add_work_controller.dart';

class EditMenuItemScreen extends StatefulWidget {

  int foodId;
  int resId;
  EditMenuItemScreen({required this.foodId, required this.resId});
  @override
  State<EditMenuItemScreen> createState() => _EditMenuItemScreenState();
}

class _EditMenuItemScreenState extends State<EditMenuItemScreen> {
  CarouselController buttonCarouselController = CarouselController();

  int currentIndex = 0;
  Map map = {};
  int m  = 89;
  int vartiantId = -1;
  List<int> extras = [];


  int option = 0;


  TextEditingController name = TextEditingController(text: AllMenusGetxController.to.itemDetails.first.data!.name ?? "");
  TextEditingController desc = TextEditingController(text: AllMenusGetxController.to.itemDetails.first.data!.description ?? "");
  TextEditingController price = TextEditingController(text: AllMenusGetxController.to.itemDetails.first.data!.price.toString());
  TextEditingController price2 = TextEditingController();
  TextEditingController optionName = TextEditingController();
  TextEditingController options = TextEditingController();
  TextEditingController extraName = TextEditingController();
  TextEditingController extraPrice = TextEditingController();
  XFile? image;






  @override
  void initState() {
    // TODO: implement initState
 
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Get.put(ImagePickerController());
   await  AllMenusGetxController.to.getMenuResCategories(resId: widget.resId.toString());
      AllMenusGetxController.to.selectedCategory = AllMenusGetxController.to.categories.where((p0) => p0.id == AllMenusGetxController.to.itemDetails.first.data!.categoryId).first;

      ImagePickerController.to.path.value = "";


      AllMenusGetxController.to.optionsCount.clear();
      AllMenusGetxController.to.optionsName.clear();
      // AllMenusGetxController.to.optionsController.clear();
      AllMenusGetxController.to.options.clear();
      AllMenusGetxController.to.options2.clear();
      AllMenusGetxController.to.options3.clear();
      AllMenusGetxController.to.optionsIds.clear();
      AllMenusGetxController.to.varents.clear();
      AllMenusGetxController.to.varents2.clear();
      AllMenusGetxController.to.verIds.clear();
      AllMenusGetxController.to.extrasIds.clear();
      AllMenusGetxController.to.extras2.clear();
      AllMenusGetxController.to.extras.clear();
      AllMenusGetxController.to.selectedValue.value = "";
      AllMenusGetxController.to.editOption.value = false;
      AllMenusGetxController.to.editVarents.value = false;
      AllMenusGetxController.to.editExtra.value = false;
      AllMenusGetxController.to.indexOptions.value = -1;
      AllMenusGetxController.to.indexVarents.value = -1;
      AllMenusGetxController.to.indexExtra.value = -1;
      AllMenusGetxController.to.controllers.clear();
      AllMenusGetxController.to.textFields.clear();
    // await AllMenusGetxController.to.getItemDetails(itemId: widget.foodId.toString());
    // AllMenusGetxController.to.count.value  =1;
    // if(AllMenusGetxController.to.itemDetails.first.data!.options!.isNotEmpty){
    //   for(int i = 0; i < AllMenusGetxController.to.itemDetails.first.data!.options!.length; i++){
    //     map.addAll({
    //       AllMenusGetxController.to.itemDetails.first.data!.options![i].id.toString() : "${AllMenusGetxController.to.optionsValues[i].trimLeft().toLowerCase().replaceAll(" ", '-')}",
    //     });
    //   }
    //
    //   print("Map:: ${map}");
    //   vartiantId =   AllMenusGetxController.to.itemDetails.first.data!.variants!.where((e) => e.options!.replaceAll("\\", "").toString().replaceAll("\"", "").replaceAll("{", "").replaceAll("}", "").replaceAll(":", ": ") == map.toString().replaceAll("{", "").replaceAll("}", "").replaceAll(", ", ",").trim()).first.id!;
    //
    //   print(vartiantId);
    // }

      print("Cat::: ${AllMenusGetxController.to.categories.length}");
      AllMenusGetxController.to.controllers.add(options);
      AllMenusGetxController.to.textFields.add(  TextFieldDefault(
        controller: AllMenusGetxController.to.controllers.first,
        upperFontSize: 12,
        upperTitle: "عنصر المجموعة",
        upperTitleColor: Colors.black,
        hint: "مثال: كبير",
        errorText: "الحقل مطلوب",

      ),);

      for(int i = 0; i < AllMenusGetxController.to.itemDetails.first.data!.options!.length; i++){
        AllMenusGetxController.to.optionsName.add(AllMenusGetxController.to.itemDetails.first.data!.options![i].name ?? "");
        AllMenusGetxController.to.options3.add(AllMenusGetxController.to.itemDetails.first.data!.options![i].options!.split(','));
        AllMenusGetxController.to.optionsIds.add(AllMenusGetxController.to.itemDetails.first.data!.options![i].id.toString());

      }

      for(int m = 0; m < AllMenusGetxController.to.itemDetails.first.data!.variants!.length; m++){
        print("Var::::");
        print(AllMenusGetxController.to.itemDetails.first.data!.variants![m].options!.substring(7).replaceAll('"', "").replaceAll("{", "").replaceAll("}", "").toString());
        AllMenusGetxController.to.varents2.add(AllMenusGetxController.to.itemDetails.first.data!.variants![m].options!.substring(7).replaceAll('"', "").replaceAll("{", "").replaceAll("}", "").toString());
        AllMenusGetxController.to.varents.add(AllMenusGetxController.to.itemDetails.first.data!.variants![m].price.toString());
        AllMenusGetxController.to.verIds.add(AllMenusGetxController.to.itemDetails.first.data!.variants![m].id.toString());

      }
      for(int i = 0; i <  AllMenusGetxController.to.options3.length; i++){
        for(int m = 0; m < AllMenusGetxController.to.options3[i].length; m++){
          AllMenusGetxController.to.options.add(AllMenusGetxController.to.options3[i][m]);
          AllMenusGetxController.to.options2.add(AllMenusGetxController.to.options3[i][m]);

          print("we are here:");
          print(AllMenusGetxController.to.options3[i].length);
          print(AllMenusGetxController.to.itemDetails.first.data!.variants!.length);
          print(AllMenusGetxController.to.varents2.length);
          print(AllMenusGetxController.to.varents2);
          print(AllMenusGetxController.to.verIds);
        }

        // s.add(c.controllers[i].text);
        // c.options2.addAll(controllers[i].text);
      }



      print("options::: ${ AllMenusGetxController.to.options3.length}");
      print("options::: ${ AllMenusGetxController.to.options3}");
      print("options::: ${AllMenusGetxController.to.options}");

      AllMenusGetxController.to.selectedValue.value =AllMenusGetxController.to.options.first;


      for(int i = 0; i < AllMenusGetxController.to.itemDetails.first.data!.extras!.length; i++){
        AllMenusGetxController.to.extras2.add(AllMenusGetxController.to.itemDetails.first.data!.extras![i].name ?? "");
        AllMenusGetxController.to.extras.add(AllMenusGetxController.to.itemDetails.first.data!.extras![i].price.toString());
        AllMenusGetxController.to.extrasIds.add(AllMenusGetxController.to.itemDetails.first.data!.extras![i].id.toString());
      }

      // for(int i = 0; i < AllMenusGetxController.to.itemDetails.first.data!.options!.length; i++){
      //   map.addAll({
      //     AllMenusGetxController.to.itemDetails.first.data!.options![i].id.toString(): "${AllMenusGetxController.to.optionsValues[i].trimLeft().toLowerCase().replaceAll(" ", '-')}",
      //   });
      // }

      print("Map:::${map}");
      print("Map:::${AllMenusGetxController.to.varents}");
      print("Map:::${AllMenusGetxController.to.varents2}");

    });

 print(widget.foodId);
  }
  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBars.appBarDefault(title: "تعديل الوجبة"),
      body: GetX<AllMenusGetxController>(
        builder: (controller) {
          return controller.isLoading.value ? Shimmer.fromColors(
              baseColor: Colors.grey.shade100,
              highlightColor: Colors.grey.shade300,
              child:  ListView(
                padding: EdgeInsetsDirectional.only(
                    start: 16.w,
                    end: 16.w,
                    bottom: 34.h
                ),
                shrinkWrap: true,
                physics: ScrollPhysics(),
                children: [
                  Container(
                    height: 336.h,
                    width: Get.width,
                      padding: EdgeInsets.symmetric(vertical: 4),

                      decoration:  BoxDecoration(color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                  ),
                  SizedBox(height: 18.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 90.w,
                        height: 30.h,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(4.r)
                        ),
                      ),

                      Container(
                        width: 90.w,
                        height: 30.h,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(4.r)
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h,),
                  Container(
                    width: 90.w,
                    height: 30.h,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(4.r)
                    ),
                  ),

                  SizedBox(height: 12.h,),
                  Container(
                    width: 90.w,
                    height: 90.h,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(4.r)
                    ),
                  ),
                  SizedBox(height: 8.h,),

                ],
              )

          ):
          ListView(
            padding: EdgeInsetsDirectional.only(
              start: 16.w,
              end: 16.w,
              bottom: 34.h
            ),
            shrinkWrap: true,
            physics: ScrollPhysics(),
            children: [
              Container(
                height: 336.h,
                width: Get.width,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,


                ),
                child: GetX<ImagePickerController>(
                  builder: (pic) {
                    return Stack(
                      children: [

                        pic.path.value.isNotEmpty ? Image.file(File(pic.path.value),  width: Get.width,
                         height: double.infinity,
                         fit: BoxFit.cover,)  : Image.network(
                            controller.itemDetails.first.data!.image ?? "",
                            fit: BoxFit.cover,
                            width: Get.width,
                            height: double.infinity,
                            errorBuilder: (BuildContext context, Object? exception, StackTrace? stackTrace) {
                              return Image.asset("images/logo.jpg",
                                width: Get.width,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              );
                            }
                        ),
                    Positioned.fill(
                                        child: Container(
                                          decoration:  BoxDecoration(
                                              gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    Colors.black.withOpacity(0.10),
                                                    Colors.black.withOpacity(0.66),
                                                  ])),
                                        ),
                                      ),
                        InkWell(
                          onTap: ()async{
                            ImagePicker picker = ImagePicker();
// Pick an image.
                            image = await picker.pickImage(source: ImageSource.gallery);
                            if(image != null){
                              pic.path.value = image!.path;
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text("تعديل الصورة",
                                  style: GoogleFonts.notoKufiArabic(
                                    textStyle:  TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),),),
                              Icon(Icons.camera_alt_outlined, color: Colors.white,),
                              ],
                            ),
                          ),
                        )
                      ],
                    );
                  }
                ),
              ),

              GetX<ImagePickerController>(
                  builder: (pic) {
                    print(pic.path);
                    return SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                            child: TextFieldDefault(
                              controller: name,
                              upperFontSize: 12,
                              upperTitle: "اسم العنصر",
                              upperTitleColor: Colors.black,
                              hint: "مشاوي",
                            ),
                          ),
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                            child: TextFieldDefault(
                              controller: desc,
                              upperFontSize: 12,
                              upperTitle: "وصف العنصر",
                              upperTitleColor: Colors.black,
                              hint: "مشاوي",
                            ),
                          ),
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                            child: TextFieldDefault(
                              controller: price,
                              upperFontSize: 12,
                              upperTitle: "سعر العنصر",
                              upperTitleColor: Colors.black,
                              hint: "12",
                            ),
                          ),
                          GetX<AllMenusGetxController>(
                              builder: (c) {
                                return Column(
                                  children: [


                                    Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "القسم",
                                            style: GoogleFonts.notoKufiArabic(
                                              textStyle:  TextStyle(
                                                color: Colors.black,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                          SizedBox(width: 20.w,),
                                          DropdownButton<Categories>(

                                            dropdownColor: Colors.white,
                                            items: c.categories.map((e) => DropdownMenuItem<Categories>(child: Text(e.name ?? "", style: GoogleFonts.notoKufiArabic(
                                              textStyle:  TextStyle(
                                                color: Colors.black,
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),),value: e,),).toList(), onChanged: (value){
                                            setState(() {
                                              c.selectedCategory = value;
                                            });
                                          },hint: Text("اختار", style: GoogleFonts.notoKufiArabic(
                                            textStyle:  TextStyle(
                                              color: Colors.black,
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),),
                                            value: c.selectedCategory,
                                          ),
                                          InkWell(
                                            onTap: (){
                                              AppDialog.addNewCategoryBox(context,resturentId: widget.resId.toString());
                                            },
                                            child: Text(
                                              'اضف قسم جديد',
                                              style: GoogleFonts.notoKufiArabic(
                                                  fontSize: 12.sp,
                                                  textStyle:
                                                  const TextStyle(color: Color(0xFF3399CC))),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      "تعديل مجموعة خيارات جديدة",
                                      style: GoogleFonts.notoKufiArabic(
                                        textStyle:  TextStyle(
                                          color: Colors.black,
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                    // InkWell(
                                    //   onTap: (){
                                    //
                                    //     TextEditingController c1= TextEditingController();
                                    //     TextEditingController c2= TextEditingController();
                                    //     AllMenusGetxController.to.optionsCount.add(option);
                                    //     AllMenusGetxController.to.optionsNameController.add(c1);
                                    //     AllMenusGetxController.to.optionsController.add(c2);
                                    //     AllMenusGetxController.to.options.add("");
                                    //     option++;
                                    //     print(AllMenusGetxController.to.optionsCount);
                                    //     print(AllMenusGetxController.to.optionsController);
                                    //   },
                                    //   child: Text(
                                    //     "اضافة خيارات",
                                    //     style: GoogleFonts.notoKufiArabic(
                                    //       textStyle:  TextStyle(
                                    //         color: Colors.white,
                                    //         fontSize: 12.sp,
                                    //         fontWeight: FontWeight.w600,
                                    //       ),
                                    //     ),
                                    //     textAlign: TextAlign.start,
                                    //   ),
                                    // ),
                                    SizedBox(height: 10.h,),

                                    MyTextField(hint: "مثال: الاحجام", controller: optionName),
                                    SizedBox(height: 10.h,),
                                    Row(
                                      children: [
                                        // SizedBox(
                                        //     width: 70.w,
                                        //     child: MyTextField(hint: "مثال: صغير،كبير،متوسط (تأكد من الفصل بينهم بفاصلة)", controller: options)),
                                        Expanded(
                                          child: ListView.builder(
                                              itemCount: c.textFields.length,
                                              shrinkWrap: true,
                                              physics: NeverScrollableScrollPhysics(),
                                              itemBuilder: (context,i){
                                                return SizedBox(
                                                    width: 70.w,
                                                    child: c.textFields[i]);
                                              }),
                                        ),
                                        InkWell(
                                            onTap: (){


                                              TextEditingController cont  = TextEditingController();

                                              c.controllers.add(cont);
                                              c.textFields.add(  TextFieldDefault(
                                                controller: cont,
                                                upperFontSize: 12,
                                                upperTitle: "عنصر المجموعة",
                                                upperTitleColor: Colors.black,
                                                hint: "مثال: كبير",
                                                errorText: "الحقل مطلوب",

                                              ),);

                                            },
                                            child: Icon(Icons.add)),
                                      ],
                                    ),
                                    SizedBox(height: 10.h,),
                                    InkWell(
                                      onTap: (){
                                        // AllMenusGetxController.to.map.addAll({
                                        //   "name" : "test",
                                        //   "options" : "tets 223",
                                        // });
                                        //
                                        // if(!AllMenusGetxController.to.options.contains(c.optionsController[index].text)){
                                        //   AllMenusGetxController.to.options.removeAt(index);
                                        //   // c.options2.clear();
                                        //   AllMenusGetxController.to.options.add(c.optionsController[index].text);
                                        // }else{
                                        //   // AllMenusGetxController.to.options.removeAt(index);
                                        //   c.options[index] = c.optionsController[index].text;
                                        // }

                                        // c.options2.clear();
                                        // c.options2.addAll(c.options);

                                        // print(AllMenusGetxController.to.options.splitList((item) => false));

                                        // print( AllMenusGetxController.to.options);

                                        // c.options.clear();
                                        // for(int i = 0; i < c.optionsController.length; i++){
                                        // c.options.addAll(options.text.split(','));
                                        // c.options2.add(options.text);
                                        // c.optionsName.add(optionName.text);
                                        // // }
                                        //
                                        // c.selectedValue.value = c.options.first;
                                        // options.clear();
                                        // optionName.clear();

                                        // for(int o = 0; o < c.options.length; )
                                        // // c.options.value = c.optionsController.expand((element) => element.text).toList() as List<String>;
                                        // // c.options.add(c.optionsController[]);
                                        // print(AllMenusGetxController.to.options);
                                        // print( AllMenusGetxController.to.optionsNameController[index].text);
                                        // print( AllMenusGetxController.to.optionsController[index].text);

                                      },
                                      child: MainElevatedButton(
                                        height: 36.h,
                                        width: 120.w,
                                        borderRadius: 4,
                                        onPressed: () async{
                                          if(c.editOption.value){
                                            c.editOption.value = false;

                                            List<String> s = [];
                                            // print("index::; ${}");
                                            //              int indexVer  =    c.varents2.indexWhere((element) =>  c.options3[c.indexOptions.value].contains(element));
                                            // c.options3[c.indexOptions.value].indexWhere((element) => element)
                                            for(int i = 0; i < c.controllers.length; i++){
                                              s.add(c.controllers[i].text);
                                              // c.options.add(c.controllers[i].text);
                                              // c.options2.addAll(controllers[i].text);
                                            }
                                            c.options3[c.indexOptions.value] = s;
                                            c.options.clear();
                                            c.options2.clear();
                                            for(int i = 0; i <  c.options3.length; i++){
                                              for(int m = 0; m < c.options3[i].length; m++){
                                                if(!c.options.contains(c.options3[i][m])){
                                                  c.options.add(c.options3[i][m]);
                                                  c.options2.add(c.options3[i][m]);
                                                }
                                              }
                                              // s.add(c.controllers[i].text);
                                              // c.options2.addAll(controllers[i].text);
                                            }

                                            // c.varents2[indexVer] =
                                            c.selectedValue.value = c.options.first;
                                            // String optionId = await MenuApiController().updateOption(optionId: c.optionsIds[c.indexOptions.value],
                                            //       optionName: AllMenusGetxController.to.optionsName[c.indexOptions.value],
                                            //       options: AllMenusGetxController.to.options3[c.indexOptions.value]);
                                            //  for(int i = 0; i < AllMenusGetxController.to.varents.length; i++){
                                            //    await MenuApiController().updateVariants(verId: c.verIds[c.indexVarents.value],
                                            //        price: c.varents[i], option: c.options[i], optionId: optionId);
                                            //  }
                                            // c.options.clear();
                                            // c.varents2 = c.options;
                                            // c.varents.clear();

                                            // for(int m = 0; m < AllMenusGetxController.to.optionsName.length ; m++) {
                                            //   String optionId = await MenuApiController().updateOption(optionId: c.optionsIds[m],
                                            //       optionName: AllMenusGetxController.to.optionsName[m],
                                            //       options: AllMenusGetxController.to.options3[m]);
                                            //
                                            //   if (AllMenusGetxController.to.varents.isNotEmpty) {
                                            //     for (int z = 0; z < AllMenusGetxController.to.varents.length; z++) {
                                            //       // MenuApiController().createVariants(itemId: itemID,
                                            //       //     price: AllMenusGetxController.to.varents[z],
                                            //       //     option: AllMenusGetxController.to.varents2[z],
                                            //       //     optionId: optionId);
                                            //     }
                                            //   }
                                            // }
                                            print(c.options);
                                            print(c.options2);
                                            c.controllers.clear();
                                            c.textFields.clear();
                                            c.controllers.add(options);
                                            c.textFields.add(  TextFieldDefault(
                                              controller: c.controllers.first,
                                              upperFontSize: 12,
                                              upperTitle: "عنصر المجموعة",
                                              upperTitleColor: Colors.black,
                                              hint: "مثال: كبير",
                                              errorText: "الحقل مطلوب",

                                            ),);
                                            options.clear();
                                            optionName.clear();

                                          }else{
                                            // c.options.addAll(options.text.split(','));
                                            // c.options2.add(options.text);
                                            c.options2.clear();


                                            List<String> s = [];
                                            for(int i = 0; i < c.controllers.length; i++){

                                              if(!c.options.contains(c.controllers[i].text)){
                                                c.options2.add(c.controllers[i].text);
                                                c.options.add(c.controllers[i].text);
                                                s.add(c.controllers[i].text);
                                              }
                                              // c.options2.addAll(controllers[i].text);

                                            }
                                            await MenuApiController().createOption(itemId: controller.itemDetails.first.data!.id.toString(),
                                                optionName: optionName.text,
                                                options:  s);
                                            c.options3.add(c.options2);
                                            // }
                                            c.optionsName.add(optionName.text);

                                            c.selectedValue.value = c.options.first;
                                            c.controllers.clear();
                                            c.textFields.clear();
                                            c.controllers.add(options);
                                            c.textFields.add(  TextFieldDefault(
                                              controller: c.controllers.first,
                                              upperFontSize: 12,
                                              upperTitle: "عنصر المجموعة",
                                              upperTitleColor: Colors.black,
                                              hint: "مثال: كبير",
                                              errorText: "الحقل مطلوب",

                                            ),);
                                            options.clear();
                                            optionName.clear();
                                          }

                                        },
                                        child: Text(
                                          c.editOption.value  ? "تعديل المجموعة": "اضافة المجموعة",
                                          style: GoogleFonts.notoKufiArabic(
                                            textStyle:  TextStyle(
                                              color: Colors.white,
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10.w,),
                                    Divider(),

                                    ListView.builder(
                                        itemCount: c.optionsName.length,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, idx){
                                          return Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(c.optionsName[idx], style: GoogleFonts.notoKufiArabic(
                                                    textStyle:  TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12.sp,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),),
                                                  Text(c.options3[idx].toString(), style: GoogleFonts.notoKufiArabic(
                                                    textStyle:  TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12.sp,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),),
                                                  // Text(c.varents2[index]),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  IconButton(onPressed: (){
                                                    optionName.text = c.optionsName[idx];
                                                    c.indexOptions.value = idx;
                                                    print( c.indexOptions.value);
                                                    c.editOption.value = true;
                                                    print(c.options3.length);
                                                    c.controllers.value = List.generate(c.options3[idx].length, (index) => TextEditingController());
                                                    c.textFields.value = List.generate(c.options3[idx].length, (index) =>   TextFieldDefault(
                                                      controller: c.controllers[index],
                                                      upperFontSize: 12,
                                                      upperTitle: "عنصر المجموعة",
                                                      upperTitleColor: Colors.black,
                                                      hint: "مثال: كبير",
                                                      errorText: "الحقل مطلوب",

                                                    ),);

                                                    for(int m = 0; m < c.controllers.length; m++){
                                                      for(int z = 0; z < c.options3[idx].length; z++){
                                                        c.controllers[m].text = c.options3[idx][m];
                                                      }
                                                    }
                                                  }, icon: Icon(Icons.edit, color: AppColors().mainColor,)),
                                                  IconButton(onPressed: ()async{
                                                    c.indexOptions.value = idx;
                                                    await MenuApiController().deleteOption(optionId: c.optionsIds[c.indexOptions.value],);
                                                    c.optionsName.removeAt(c.indexOptions.value);
                                                    c.options3.removeAt(c.indexOptions.value);
                                                    c.options3.clear();
                                                    c.optionsName.clear();
                                                    setState(() {

                                                    });
                                                  }, icon: Icon(Icons.delete, color: AppColors().mainColor,)),
                                                ],
                                              )
                                            ],
                                          );
                                        }),

                                    // ListView.builder(
                                    //     itemCount: c.optionsCount.length,
                                    //     shrinkWrap: true,
                                    //     physics: ScrollPhysics(),
                                    //     itemBuilder: (context, index){
                                    //       return  Column(
                                    //         children: [
                                    //           Row(
                                    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    //             children: [
                                    //               Expanded(
                                    //                 flex: 3,
                                    //                 child: Column(
                                    //                   children: [
                                    //                     MyTextField(hint: "الاحجام", controller: c.optionsNameController[index]),
                                    //                     SizedBox(height: 10.h,),
                                    //                     MyTextField(hint: "صغير،كبير،متوسط", controller: c.optionsController[index]),
                                    //                   ],
                                    //                 ),
                                    //               ),
                                    //               SizedBox(width: 10.w,),
                                    //               InkWell(
                                    //                 onTap: (){
                                    //                   // AllMenusGetxController.to.map.addAll({
                                    //                   //   "name" : "test",
                                    //                   //   "options" : "tets 223",
                                    //                   // });
                                    //                   //
                                    //                   // if(!AllMenusGetxController.to.options.contains(c.optionsController[index].text)){
                                    //                   //   AllMenusGetxController.to.options.removeAt(index);
                                    //                   //   // c.options2.clear();
                                    //                   //   AllMenusGetxController.to.options.add(c.optionsController[index].text);
                                    //                   // }else{
                                    //                   //   // AllMenusGetxController.to.options.removeAt(index);
                                    //                   //   c.options[index] = c.optionsController[index].text;
                                    //                   // }
                                    //
                                    //                   // c.options2.clear();
                                    //           // c.options2.addAll(c.options);
                                    //
                                    //                   // print(AllMenusGetxController.to.options.splitList((item) => false));
                                    //
                                    //                   // print( AllMenusGetxController.to.options);
                                    //
                                    //                   c.options.clear();
                                    //                   for(int i = 0; i < c.optionsController.length; i++){
                                    //                     c.options.addAll(c.optionsController[i].text.split(','));
                                    //                   }
                                    //
                                    //                   c.selectedValue.value = c.options.first;
                                    //                   // for(int o = 0; o < c.options.length; )
                                    //                   // // c.options.value = c.optionsController.expand((element) => element.text).toList() as List<String>;
                                    //                   // // c.options.add(c.optionsController[]);
                                    //                   // print(AllMenusGetxController.to.options);
                                    //                   // print( AllMenusGetxController.to.optionsNameController[index].text);
                                    //                   // print( AllMenusGetxController.to.optionsController[index].text);
                                    //
                                    //                 },
                                    //                 child: Text(
                                    //                   "اضف",
                                    //                   style: GoogleFonts.notoKufiArabic(
                                    //                     textStyle:  TextStyle(
                                    //                       color: Colors.white,
                                    //                       fontSize: 10.sp,
                                    //                       fontWeight: FontWeight.w600,
                                    //                     ),
                                    //                   ),
                                    //                   textAlign: TextAlign.start,
                                    //                 ),
                                    //               ),
                                    //
                                    //             ],
                                    //           ),
                                    //           SizedBox(width: 10.w,),
                                    //           Divider(),
                                    //           // DropdownButton(items: c.optionsNameController.map((e) => DropdownMenuItem(child: Text("we sdds"))).toList(), onChanged: (value){})
                                    //         ],
                                    //       );
                                    //     }),
                                    // GetX<AllMenusGetxController>(
                                    //   builder: (con) {
                                    //     print(con.options);
                                    //     return SizedBox(
                                    //       height: 120.h,
                                    //       child: ListView.builder(
                                    //         itemCount: con.optionsController.length,
                                    //         shrinkWrap: true,
                                    //         physics: ScrollPhysics(),
                                    //         itemBuilder: (context, index) {
                                    //           return Row(
                                    //             children: [
                                    //               MyTextField(hint: "السعر", controller: con.optionsController[index]),
                                    //               DropdownButton<String>(items: con.options.map((e) => DropdownMenuItem<String>(child: Text(e),value: e,)).toList(), onChanged: (value){}),
                                    //             ],
                                    //           );
                                    //         }
                                    //       ),
                                    //     );
                                    //   }
                                    // ),
                                    Visibility(
                                      visible: c.selectedValue.isNotEmpty,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(
                                                      width:90.w,
                                                      child: MyTextField(hint: "السعر", controller: price2)),
                                                  SizedBox(width: 20.w,),
                                                  DropdownButton<String>(

                                                    dropdownColor: Colors.white,
                                                    items: c.options.map((e) => DropdownMenuItem<String>(child: Text(e, style: GoogleFonts.notoKufiArabic(
                                                      textStyle:  TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 10.sp,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),),value: e,),).toList(), onChanged: (value){
                                                    c.selectedValue.value = value!;
                                                  },hint: Text("اختار", style: GoogleFonts.notoKufiArabic(
                                                    textStyle:  TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 10.sp,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),),
                                                    value: c.selectedValue.value,),
                                                ],
                                              ),


                                              InkWell(
                                                onTap: (){
                                                  if(c.editVarents.value){
                                                    c.varents[c.indexVarents.value] = price2.text;
                                                    c.varents2[c.indexVarents.value] = c.selectedValue.value;
                                                    price2.text = "";

                                                    print(c.varents);
                                                    print(c.varents2);
                                                    // print("ID:::: ${ controller.itemDetails.first.data!.options!.where((element) => element.options!.contains(c.verIds[c.indexVarents.value])).first.id}");
                                                    // MenuApiController().updateVariants(verId: c.verIds[c.indexVarents.value], price: c.varents[c.indexVarents.value], option:  c.varents2[c.indexVarents.value], optionId: optionId)
                                                  }else{
                                                    if(!c.varents2.contains(c.selectedValue.value)){
                                                      c.varents.add(price2.text);
                                                      c.varents2.add(c.selectedValue.value);
                                                      price2.text = "";
                                                      c.verIds.add("-1");
                                                    }

                                                  }

                                                },
                                                child: Text(
                                                  c.editVarents.value ? "تعديل" :  "اضف",
                                                  style: GoogleFonts.notoKufiArabic(
                                                    textStyle:  TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 10.sp,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),


                                            ],
                                          ),
                                          ListView.builder(
                                              itemCount: c.varents.length,
                                              shrinkWrap: true,
                                              physics: NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index){
                                                return Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text("₺ ${c.varents[index]}", style: GoogleFonts.notoKufiArabic(
                                                          textStyle:  TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 12.sp,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),),
                                                        SizedBox(width: 10.w,),
                                                        Text(c.varents2[index], style: GoogleFonts.notoKufiArabic(
                                                          textStyle:  TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 12.sp,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        IconButton(onPressed: (){

                                                          print(c.varents2);
                                                          c.indexVarents.value = index;
                                                          price2.text = c.varents[index];
                                                          // c.selectedValue.value = c.varents2[c.indexVarents.value];
                                                          c.editVarents.value = true;
                                                          // optionName.text = c.optionsName[idx];
                                                          // c.indexOptions.value = idx;
                                                          // print( c.indexOptions.value);
                                                          // c.edit.value = true;
                                                          // print(c.options3.length);
                                                          // c.controllers.value = List.generate(c.options3[idx].length, (index) => TextEditingController());
                                                          // c.textFields.value = List.generate(c.options3[idx].length, (index) => MyTextField(hint: "كبير", controller: c.controllers[index]));
                                                          //
                                                          // for(int m = 0; m < c.controllers.length; m++){
                                                          //   for(int z = 0; z < c.options3[idx].length; z++){
                                                          //     c.controllers[m].text = c.options3[idx][m];
                                                          //   }
                                                          // }
                                                        }, icon: Icon(Icons.edit, color: AppColors().mainColor,)),
                                                        IconButton(onPressed: (){
                                                          c.indexVarents.value = index;
                                                          c.varents.removeAt(c.indexVarents.value);
                                                          c.varents2.removeAt(c.indexVarents.value);
                                                          c.varents.refresh();
                                                          c.varents2.refresh();
                                                          // c.options3.clear();
                                                          // c.optionsName.clear();
                                                          // setState(() {
                                                          //
                                                          // });
                                                        }, icon: Icon(Icons.delete, color: AppColors().mainColor,)),
                                                      ],
                                                    )

                                                  ],
                                                );
                                              })
                                        ],
                                      ),
                                    ),

                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,

                                      children: [
                                        Text(
                                          "اضافات على الوجبة",
                                          style: GoogleFonts.notoKufiArabic(
                                            textStyle:  TextStyle(
                                              color: Colors.black,
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: Column(
                                                children: [
                                                  MyTextField(hint: "اسم الاضافة", controller: extraName),
                                                  SizedBox(height: 10.h,),
                                                  MyTextField(hint: "السعر", controller: extraPrice),
                                                ],
                                              ),
                                            ),

                                            SizedBox(width: 10.w,),

                                            InkWell(
                                              onTap: (){

                                                if(c.editExtra.value){
                                                  c.extras2[c.indexExtra.value] = extraName.text;
                                                  c.extras[c.indexExtra.value] = extraPrice.text;
                                                  extraPrice.text = "";
                                                  extraName.text = "";
                                                  c.editExtra.value = false;
                                                }else{
                                                  c.extras.add(extraPrice.text);
                                                  c.extras2.add(extraName.text);
                                                  extraPrice.text = "";
                                                  extraName.text = "";
                                                  c.extrasIds.add("-1");
                                                  print(c.extrasIds);
                                                }

                                              },
                                              child: Text(
                                                c.editExtra.value ? "تعديل" : "اضف",
                                                style: GoogleFonts.notoKufiArabic(
                                                  textStyle:  TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 10.sp,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                            ),


                                          ],
                                        ),
                                        ListView.builder(
                                            itemCount: c.extras2.length,
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index){
                                              return Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text("₺ ${c.extras[index]}", style: GoogleFonts.notoKufiArabic(
                                                        textStyle:  TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12.sp,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),),
                                                      SizedBox(width: 10.w,),
                                                      Text(c.extras2[index], style: GoogleFonts.notoKufiArabic(
                                                        textStyle:  TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12.sp,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      IconButton(onPressed: (){

                                                        c.indexExtra.value = index;
                                                        extraPrice.text = c.extras[index];
                                                        extraName.text = c.extras2[index];
                                                        c.editExtra.value = true;
                                                        // optionName.text = c.optionsName[idx];
                                                        // c.indexOptions.value = idx;
                                                        // print( c.indexOptions.value);
                                                        // c.edit.value = true;
                                                        // print(c.options3.length);
                                                        // c.controllers.value = List.generate(c.options3[idx].length, (index) => TextEditingController());
                                                        // c.textFields.value = List.generate(c.options3[idx].length, (index) => MyTextField(hint: "كبير", controller: c.controllers[index]));
                                                        //
                                                        // for(int m = 0; m < c.controllers.length; m++){
                                                        //   for(int z = 0; z < c.options3[idx].length; z++){
                                                        //     c.controllers[m].text = c.options3[idx][m];
                                                        //   }
                                                        // }
                                                      }, icon: Icon(Icons.edit, color: AppColors().mainColor,)),
                                                      IconButton(onPressed: (){
                                                        c.indexExtra.value = index;
                                                        c.extras.removeAt(c.indexVarents.value);
                                                        c.extras2.removeAt(c.indexVarents.value);
                                                        c.extras.refresh();
                                                        c.extras2.refresh();
                                                        // c.options3.clear();
                                                        // c.optionsName.clear();
                                                        // setState(() {
                                                        //
                                                        // });
                                                      }, icon: Icon(Icons.delete, color: AppColors().mainColor,)),
                                                    ],
                                                  )
                                                ],
                                              );
                                            })
                                      ],
                                    )

                                  ],
                                );
                              }
                          ),



                          MainElevatedButton(child: Text(
                            "حفط التعديلات",
                            style: GoogleFonts.notoKufiArabic(
                              textStyle:  TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ), height: 48.h, width: Get.width, borderRadius: 5, onPressed: (){

                            if(AllMenusGetxController.to.selectedCategory != null){
                              AddItem item = AddItem();
                              // item.categoryName = controller.categories[index];
                              item.itemName = name.text;
                              item.item_price = int.parse(price.text);
                              item.itemDesc = desc.text;
                              if(pic.path.isNotEmpty){
                                item.item_image= pic.path.value;
                              }else{
                                item.item_image=null;
                              }


                              MenuApiController().updateMenuItem(item: item, categoryId: AllMenusGetxController.to.selectedCategory!.id.toString(), resId: widget.foodId.toString());

                              AllMenusGetxController.to.getMenus(resturentName: widget.resId.toString(),current_page: 1);
                            }else{
                              Fluttertoast.showToast(msg: "يجب اختيار قسم");
                            }

                          }),
                          // InkWell(
                          //   onTap: (){
                          //     // AddItem item = AddItem();
                          //     // item.categoryName = controller.categories[index];
                          //     // item.itemName = name.text;
                          //     // item.item_price = int.parse(price.text);
                          //     // item.itemDesc = desc.text;
                          //     // item.item_image= pic.path.value;
                          //     // AddWorkOrAdsController.to.items.add(item);
                          //     // // category != null ? AddWorkOrAdsController.to.categories[index!] =  controller.text :   AddWorkOrAdsController.to.categories.add(controller.text);
                          //     // Navigator.pop(context);
                          //     // AuthConsumer().sendOtpCodeCivil(context, civilId, false, "forget");
                          //   },
                          //   child: Text(
                          //     "اضافة",
                          //     style: GoogleFonts.notoKufiArabic(
                          //       textStyle:  TextStyle(
                          //         color: Colors.black,
                          //         fontSize: 12.sp,
                          //         fontWeight: FontWeight.w600,
                          //       ),
                          //     ),
                          //   ),),
                        ],
                      ),
                    );
                  }
              )
              //           Container(
    //             height: MediaQuery.of(context).size.height * 0.9,
    //             width: double.infinity,
    //             decoration: BoxDecoration(
    //               color: Colors.white,
    //               borderRadius: BorderRadius.only(
    //                 topRight: Radius.circular(20.r),
    //                 topLeft: Radius.circular(20.r),
    //               ),
    //             ),
    //             child: Column(
    //               children: [
    //                 GetX<ImagePickerController>(
    //                     builder: (pic) {
    //                       print(pic.path);
    //                       return SingleChildScrollView(
    //                         child: Column(
    //                           mainAxisAlignment: MainAxisAlignment.start,
    //                           children: [
    //                             Padding(
    //                               padding:  EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
    //                               child: TextFieldDefault(
    //                                 controller: name,
    //                                 upperFontSize: 12,
    //                                 upperTitle: "اسم العنصر",
    //                                 upperTitleColor: Colors.black,
    //                                 hint: "مشاوي",
    //                               ),
    //                             ),
    //                             Padding(
    //                               padding:  EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
    //                               child: TextFieldDefault(
    //                                 controller: desc,
    //                                 upperFontSize: 12,
    //                                 upperTitle: "وصف العنصر",
    //                                 upperTitleColor: Colors.black,
    //                                 hint: "مشاوي",
    //                               ),
    //                             ),
    //                             Padding(
    //                               padding:  EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
    //                               child: TextFieldDefault(
    //                                 controller: price,
    //                                 upperFontSize: 12,
    //                                 upperTitle: "سعر العنصر",
    //                                 upperTitleColor: Colors.black,
    //                                 hint: "12",
    //                               ),
    //                             ),
    //                             GetX<AllMenusGetxController>(
    //                                 builder: (c) {
    //                                   return Column(
    //                                     children: [
    //
    //
    //                                       Padding(
    //                                         padding: const EdgeInsets.all(16),
    //                                         child: Row(
    //                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                                           children: [
    //                                             Text(
    //                                               "القسم",
    //                                               style: GoogleFonts.notoKufiArabic(
    //                                                 textStyle:  TextStyle(
    //                                                   color: Colors.black,
    //                                                   fontSize: 12.sp,
    //                                                   fontWeight: FontWeight.w600,
    //                                                 ),
    //                                               ),
    //                                               textAlign: TextAlign.start,
    //                                             ),
    //                                             SizedBox(width: 20.w,),
    //                                             DropdownButton<Categories>(
    //
    //                                               dropdownColor: Colors.white,
    //                                               items: c.categories.map((e) => DropdownMenuItem<Categories>(child: Text(e.name ?? "", style: GoogleFonts.notoKufiArabic(
    //                                                 textStyle:  TextStyle(
    //                                                   color: Colors.black,
    //                                                   fontSize: 10.sp,
    //                                                   fontWeight: FontWeight.w600,
    //                                                 ),
    //                                               ),),value: e,),).toList(), onChanged: (value){
    //                                              setState(() {
    //                                                c.selectedCategory = value;
    //                                              });
    //                                             },hint: Text("اختار", style: GoogleFonts.notoKufiArabic(
    //                                               textStyle:  TextStyle(
    //                                                 color: Colors.black,
    //                                                 fontSize: 10.sp,
    //                                                 fontWeight: FontWeight.w600,
    //                                               ),
    //                                             ),),
    //                                               value: c.selectedCategory,
    //                                             ),
    //                                             InkWell(
    //                                               onTap: (){
    //                                                 AppDialog.addNewCategoryBox(context,resturentId: widget.resId.toString());
    //                                               },
    //                                               child: Text(
    //                                                 'اضف قسم جديد',
    //                                                 style: GoogleFonts.notoKufiArabic(
    //                                                     fontSize: 12.sp,
    //                                                     textStyle:
    //                                                     const TextStyle(color: Color(0xFF3399CC))),
    //                                               ),
    //                                             ),
    //                                           ],
    //                                         ),
    //                                       ),
    //                                       Text(
    //                                         "تعديل مجموعة خيارات جديدة",
    //                                         style: GoogleFonts.notoKufiArabic(
    //                                           textStyle:  TextStyle(
    //                                             color: Colors.black,
    //                                             fontSize: 10.sp,
    //                                             fontWeight: FontWeight.w600,
    //                                           ),
    //                                         ),
    //                                         textAlign: TextAlign.start,
    //                                       ),
    //                                       // InkWell(
    //                                       //   onTap: (){
    //                                       //
    //                                       //     TextEditingController c1= TextEditingController();
    //                                       //     TextEditingController c2= TextEditingController();
    //                                       //     AllMenusGetxController.to.optionsCount.add(option);
    //                                       //     AllMenusGetxController.to.optionsNameController.add(c1);
    //                                       //     AllMenusGetxController.to.optionsController.add(c2);
    //                                       //     AllMenusGetxController.to.options.add("");
    //                                       //     option++;
    //                                       //     print(AllMenusGetxController.to.optionsCount);
    //                                       //     print(AllMenusGetxController.to.optionsController);
    //                                       //   },
    //                                       //   child: Text(
    //                                       //     "اضافة خيارات",
    //                                       //     style: GoogleFonts.notoKufiArabic(
    //                                       //       textStyle:  TextStyle(
    //                                       //         color: Colors.white,
    //                                       //         fontSize: 12.sp,
    //                                       //         fontWeight: FontWeight.w600,
    //                                       //       ),
    //                                       //     ),
    //                                       //     textAlign: TextAlign.start,
    //                                       //   ),
    //                                       // ),
    //                                       SizedBox(height: 10.h,),
    //
    //                                       MyTextField(hint: "مثال: الاحجام", controller: optionName),
    //                                       SizedBox(height: 10.h,),
    //                                       Row(
    //                                         children: [
    //                                           // SizedBox(
    //                                           //     width: 70.w,
    //                                           //     child: MyTextField(hint: "مثال: صغير،كبير،متوسط (تأكد من الفصل بينهم بفاصلة)", controller: options)),
    //                                           Expanded(
    //                                             child: ListView.builder(
    //                                                 itemCount: c.textFields.length,
    //                                                 shrinkWrap: true,
    //                                                 physics: NeverScrollableScrollPhysics(),
    //                                                 itemBuilder: (context,i){
    //                                                   return SizedBox(
    //                                                       width: 70.w,
    //                                                       child: c.textFields[i]);
    //                                                 }),
    //                                           ),
    //                                           InkWell(
    //                                               onTap: (){
    //
    //
    //                                                 TextEditingController cont  = TextEditingController();
    //
    //                                                 c.controllers.add(cont);
    //                                                 c.textFields.add(MyTextField(hint: 'كبير', controller: cont,));
    //
    //                                               },
    //                                               child: Icon(Icons.add)),
    //                                         ],
    //                                       ),
    //                                       SizedBox(height: 10.h,),
    //                                       InkWell(
    //                                         onTap: (){
    //                                           // AllMenusGetxController.to.map.addAll({
    //                                           //   "name" : "test",
    //                                           //   "options" : "tets 223",
    //                                           // });
    //                                           //
    //                                           // if(!AllMenusGetxController.to.options.contains(c.optionsController[index].text)){
    //                                           //   AllMenusGetxController.to.options.removeAt(index);
    //                                           //   // c.options2.clear();
    //                                           //   AllMenusGetxController.to.options.add(c.optionsController[index].text);
    //                                           // }else{
    //                                           //   // AllMenusGetxController.to.options.removeAt(index);
    //                                           //   c.options[index] = c.optionsController[index].text;
    //                                           // }
    //
    //                                           // c.options2.clear();
    //                                           // c.options2.addAll(c.options);
    //
    //                                           // print(AllMenusGetxController.to.options.splitList((item) => false));
    //
    //                                           // print( AllMenusGetxController.to.options);
    //
    //                                           // c.options.clear();
    //                                           // for(int i = 0; i < c.optionsController.length; i++){
    //                                           // c.options.addAll(options.text.split(','));
    //                                           // c.options2.add(options.text);
    //                                           // c.optionsName.add(optionName.text);
    //                                           // // }
    //                                           //
    //                                           // c.selectedValue.value = c.options.first;
    //                                           // options.clear();
    //                                           // optionName.clear();
    //
    //                                           // for(int o = 0; o < c.options.length; )
    //                                           // // c.options.value = c.optionsController.expand((element) => element.text).toList() as List<String>;
    //                                           // // c.options.add(c.optionsController[]);
    //                                           // print(AllMenusGetxController.to.options);
    //                                           // print( AllMenusGetxController.to.optionsNameController[index].text);
    //                                           // print( AllMenusGetxController.to.optionsController[index].text);
    //
    //                                         },
    //                                         child: MainElevatedButton(
    //                                           height: 36.h,
    //                                           width: 120.w,
    //                                           borderRadius: 4,
    //                                           onPressed: () async{
    //                                             if(c.editOption.value){
    //                                               c.editOption.value = false;
    //
    //                                               List<String> s = [];
    //                     // print("index::; ${}");
    //                     //              int indexVer  =    c.varents2.indexWhere((element) =>  c.options3[c.indexOptions.value].contains(element));
    //                                               // c.options3[c.indexOptions.value].indexWhere((element) => element)
    //                                               for(int i = 0; i < c.controllers.length; i++){
    //                                                 s.add(c.controllers[i].text);
    //                                                 // c.options.add(c.controllers[i].text);
    //                                                 // c.options2.addAll(controllers[i].text);
    //                                               }
    //                                               c.options3[c.indexOptions.value] = s;
    //                                               c.options.clear();
    //                                               c.options2.clear();
    //                                               for(int i = 0; i <  c.options3.length; i++){
    //                                                 for(int m = 0; m < c.options3[i].length; m++){
    //                                                   if(!c.options.contains(c.options3[i][m])){
    //                                                     c.options.add(c.options3[i][m]);
    //                                                     c.options2.add(c.options3[i][m]);
    //                                                   }
    //                                                 }
    //                                                 // s.add(c.controllers[i].text);
    //                                                 // c.options2.addAll(controllers[i].text);
    //                                               }
    //
    //                                               // c.varents2[indexVer] =
    //                                               c.selectedValue.value = c.options.first;
    //                                             // String optionId = await MenuApiController().updateOption(optionId: c.optionsIds[c.indexOptions.value],
    //                                             //       optionName: AllMenusGetxController.to.optionsName[c.indexOptions.value],
    //                                             //       options: AllMenusGetxController.to.options3[c.indexOptions.value]);
    //                                             //  for(int i = 0; i < AllMenusGetxController.to.varents.length; i++){
    //                                             //    await MenuApiController().updateVariants(verId: c.verIds[c.indexVarents.value],
    //                                             //        price: c.varents[i], option: c.options[i], optionId: optionId);
    //                                             //  }
    //                                               // c.options.clear();
    //                                               // c.varents2 = c.options;
    //                                               // c.varents.clear();
    //
    // // for(int m = 0; m < AllMenusGetxController.to.optionsName.length ; m++) {
    // //   String optionId = await MenuApiController().updateOption(optionId: c.optionsIds[m],
    // //       optionName: AllMenusGetxController.to.optionsName[m],
    // //       options: AllMenusGetxController.to.options3[m]);
    // //
    // //   if (AllMenusGetxController.to.varents.isNotEmpty) {
    // //     for (int z = 0; z < AllMenusGetxController.to.varents.length; z++) {
    // //       // MenuApiController().createVariants(itemId: itemID,
    // //       //     price: AllMenusGetxController.to.varents[z],
    // //       //     option: AllMenusGetxController.to.varents2[z],
    // //       //     optionId: optionId);
    // //     }
    // //   }
    // // }
    // print(c.options);
    //                                               print(c.options2);
    //                                               c.controllers.clear();
    //                                               c.textFields.clear();
    //                                               c.controllers.add(options);
    //                                               c.textFields.add(MyTextField(hint: "كبير", controller:c.controllers.first));
    //                                               options.clear();
    //                                               optionName.clear();
    //
    //                                             }else{
    //                                               // c.options.addAll(options.text.split(','));
    //                                               // c.options2.add(options.text);
    //                                               c.options2.clear();
    //
    //
    //                                               List<String> s = [];
    //                                               for(int i = 0; i < c.controllers.length; i++){
    //
    //                                                 if(!c.options.contains(c.controllers[i].text)){
    //                                                   c.options2.add(c.controllers[i].text);
    //                                                   c.options.add(c.controllers[i].text);
    //                                                   s.add(c.controllers[i].text);
    //                                                 }
    //                                                 // c.options2.addAll(controllers[i].text);
    //
    //                                               }
    //                                               await MenuApiController().createOption(itemId: controller.itemDetails.first.data!.id.toString(),
    //                                                   optionName: optionName.text,
    //                                                   options:  s);
    //                                               c.options3.add(c.options2);
    //                                               // }
    //                                               c.optionsName.add(optionName.text);
    //
    //                                               c.selectedValue.value = c.options.first;
    //                                               c.controllers.clear();
    //                                               c.textFields.clear();
    //                                               c.controllers.add(options);
    //                                               c.textFields.add(MyTextField(hint: "كبير", controller:c.controllers.first));
    //                                               options.clear();
    //                                               optionName.clear();
    //                                             }
    //
    //                                           },
    //                                           child: Text(
    //                                             c.editOption.value  ? "تعديل المجموعة": "اضافة المجموعة",
    //                                             style: GoogleFonts.notoKufiArabic(
    //                                               textStyle:  TextStyle(
    //                                                 color: Colors.white,
    //                                                 fontSize: 10.sp,
    //                                                 fontWeight: FontWeight.w600,
    //                                               ),
    //                                             ),
    //                                             textAlign: TextAlign.start,
    //                                           ),
    //                                         ),
    //                                       ),
    //                                       SizedBox(width: 10.w,),
    //                                       Divider(),
    //
    //                                       ListView.builder(
    //                                           itemCount: c.optionsName.length,
    //                                           shrinkWrap: true,
    //                                           physics: NeverScrollableScrollPhysics(),
    //                                           itemBuilder: (context, idx){
    //                                             return Row(
    //                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                                               children: [
    //                                                 Column(
    //                                                   crossAxisAlignment: CrossAxisAlignment.start,
    //                                                   children: [
    //                                                     Text(c.optionsName[idx], style: GoogleFonts.notoKufiArabic(
    //                                                       textStyle:  TextStyle(
    //                                                         color: Colors.black,
    //                                                         fontSize: 12.sp,
    //                                                         fontWeight: FontWeight.w600,
    //                                                       ),
    //                                                     ),),
    //                                                     Text(c.options3[idx].toString(), style: GoogleFonts.notoKufiArabic(
    //                                                       textStyle:  TextStyle(
    //                                                         color: Colors.black,
    //                                                         fontSize: 12.sp,
    //                                                         fontWeight: FontWeight.w600,
    //                                                       ),
    //                                                     ),),
    //                                                     // Text(c.varents2[index]),
    //                                                   ],
    //                                                 ),
    //                                                 Row(
    //                                                   children: [
    //                                                     IconButton(onPressed: (){
    //                                                       optionName.text = c.optionsName[idx];
    //                                                       c.indexOptions.value = idx;
    //                                                       print( c.indexOptions.value);
    //                                                       c.editOption.value = true;
    //                                                       print(c.options3.length);
    //                                                       c.controllers.value = List.generate(c.options3[idx].length, (index) => TextEditingController());
    //                                                       c.textFields.value = List.generate(c.options3[idx].length, (index) => MyTextField(hint: "كبير", controller: c.controllers[index]));
    //
    //                                                       for(int m = 0; m < c.controllers.length; m++){
    //                                                         for(int z = 0; z < c.options3[idx].length; z++){
    //                                                           c.controllers[m].text = c.options3[idx][m];
    //                                                         }
    //                                                       }
    //                                                     }, icon: Icon(Icons.edit, color: AppColors().mainColor,)),
    //                                                     IconButton(onPressed: ()async{
    //                                                       c.indexOptions.value = idx;
    //                                                       await MenuApiController().deleteOption(optionId: c.optionsIds[c.indexOptions.value],);
    //                                                       c.optionsName.removeAt(c.indexOptions.value);
    //                                                       c.options3.removeAt(c.indexOptions.value);
    //                                                       c.options3.clear();
    //                                                       c.optionsName.clear();
    //                                                       setState(() {
    //
    //                                                       });
    //                                                     }, icon: Icon(Icons.delete, color: AppColors().mainColor,)),
    //                                                   ],
    //                                                 )
    //                                               ],
    //                                             );
    //                                           }),
    //
    //                                       // ListView.builder(
    //                                       //     itemCount: c.optionsCount.length,
    //                                       //     shrinkWrap: true,
    //                                       //     physics: ScrollPhysics(),
    //                                       //     itemBuilder: (context, index){
    //                                       //       return  Column(
    //                                       //         children: [
    //                                       //           Row(
    //                                       //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                                       //             children: [
    //                                       //               Expanded(
    //                                       //                 flex: 3,
    //                                       //                 child: Column(
    //                                       //                   children: [
    //                                       //                     MyTextField(hint: "الاحجام", controller: c.optionsNameController[index]),
    //                                       //                     SizedBox(height: 10.h,),
    //                                       //                     MyTextField(hint: "صغير،كبير،متوسط", controller: c.optionsController[index]),
    //                                       //                   ],
    //                                       //                 ),
    //                                       //               ),
    //                                       //               SizedBox(width: 10.w,),
    //                                       //               InkWell(
    //                                       //                 onTap: (){
    //                                       //                   // AllMenusGetxController.to.map.addAll({
    //                                       //                   //   "name" : "test",
    //                                       //                   //   "options" : "tets 223",
    //                                       //                   // });
    //                                       //                   //
    //                                       //                   // if(!AllMenusGetxController.to.options.contains(c.optionsController[index].text)){
    //                                       //                   //   AllMenusGetxController.to.options.removeAt(index);
    //                                       //                   //   // c.options2.clear();
    //                                       //                   //   AllMenusGetxController.to.options.add(c.optionsController[index].text);
    //                                       //                   // }else{
    //                                       //                   //   // AllMenusGetxController.to.options.removeAt(index);
    //                                       //                   //   c.options[index] = c.optionsController[index].text;
    //                                       //                   // }
    //                                       //
    //                                       //                   // c.options2.clear();
    //                                       //           // c.options2.addAll(c.options);
    //                                       //
    //                                       //                   // print(AllMenusGetxController.to.options.splitList((item) => false));
    //                                       //
    //                                       //                   // print( AllMenusGetxController.to.options);
    //                                       //
    //                                       //                   c.options.clear();
    //                                       //                   for(int i = 0; i < c.optionsController.length; i++){
    //                                       //                     c.options.addAll(c.optionsController[i].text.split(','));
    //                                       //                   }
    //                                       //
    //                                       //                   c.selectedValue.value = c.options.first;
    //                                       //                   // for(int o = 0; o < c.options.length; )
    //                                       //                   // // c.options.value = c.optionsController.expand((element) => element.text).toList() as List<String>;
    //                                       //                   // // c.options.add(c.optionsController[]);
    //                                       //                   // print(AllMenusGetxController.to.options);
    //                                       //                   // print( AllMenusGetxController.to.optionsNameController[index].text);
    //                                       //                   // print( AllMenusGetxController.to.optionsController[index].text);
    //                                       //
    //                                       //                 },
    //                                       //                 child: Text(
    //                                       //                   "اضف",
    //                                       //                   style: GoogleFonts.notoKufiArabic(
    //                                       //                     textStyle:  TextStyle(
    //                                       //                       color: Colors.white,
    //                                       //                       fontSize: 10.sp,
    //                                       //                       fontWeight: FontWeight.w600,
    //                                       //                     ),
    //                                       //                   ),
    //                                       //                   textAlign: TextAlign.start,
    //                                       //                 ),
    //                                       //               ),
    //                                       //
    //                                       //             ],
    //                                       //           ),
    //                                       //           SizedBox(width: 10.w,),
    //                                       //           Divider(),
    //                                       //           // DropdownButton(items: c.optionsNameController.map((e) => DropdownMenuItem(child: Text("we sdds"))).toList(), onChanged: (value){})
    //                                       //         ],
    //                                       //       );
    //                                       //     }),
    //                                       // GetX<AllMenusGetxController>(
    //                                       //   builder: (con) {
    //                                       //     print(con.options);
    //                                       //     return SizedBox(
    //                                       //       height: 120.h,
    //                                       //       child: ListView.builder(
    //                                       //         itemCount: con.optionsController.length,
    //                                       //         shrinkWrap: true,
    //                                       //         physics: ScrollPhysics(),
    //                                       //         itemBuilder: (context, index) {
    //                                       //           return Row(
    //                                       //             children: [
    //                                       //               MyTextField(hint: "السعر", controller: con.optionsController[index]),
    //                                       //               DropdownButton<String>(items: con.options.map((e) => DropdownMenuItem<String>(child: Text(e),value: e,)).toList(), onChanged: (value){}),
    //                                       //             ],
    //                                       //           );
    //                                       //         }
    //                                       //       ),
    //                                       //     );
    //                                       //   }
    //                                       // ),
    //                                       Visibility(
    //                                         visible: c.selectedValue.isNotEmpty,
    //                                         child: Column(
    //                                           children: [
    //                                             Row(
    //                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                                               children: [
    //                                                 Row(
    //                                                   children: [
    //                                                     SizedBox(
    //                                                         width:90.w,
    //                                                         child: MyTextField(hint: "السعر", controller: price2)),
    //                                                     SizedBox(width: 20.w,),
    //                                                     DropdownButton<String>(
    //
    //                                                       dropdownColor: Colors.white,
    //                                                       items: c.options.map((e) => DropdownMenuItem<String>(child: Text(e, style: GoogleFonts.notoKufiArabic(
    //                                                         textStyle:  TextStyle(
    //                                                           color: Colors.black,
    //                                                           fontSize: 10.sp,
    //                                                           fontWeight: FontWeight.w600,
    //                                                         ),
    //                                                       ),),value: e,),).toList(), onChanged: (value){
    //                                                       c.selectedValue.value = value!;
    //                                                     },hint: Text("اختار", style: GoogleFonts.notoKufiArabic(
    //                                                       textStyle:  TextStyle(
    //                                                         color: Colors.black,
    //                                                         fontSize: 10.sp,
    //                                                         fontWeight: FontWeight.w600,
    //                                                       ),
    //                                                     ),),
    //                                                       value: c.selectedValue.value,),
    //                                                   ],
    //                                                 ),
    //
    //
    //                                                 InkWell(
    //                                                   onTap: (){
    //                                                     if(c.editVarents.value){
    //                                                       c.varents[c.indexVarents.value] = price2.text;
    //                                                       c.varents2[c.indexVarents.value] = c.selectedValue.value;
    //                                                       price2.text = "";
    //
    //                                                       print(c.varents);
    //                                                       print(c.varents2);
    //                                                      // print("ID:::: ${ controller.itemDetails.first.data!.options!.where((element) => element.options!.contains(c.verIds[c.indexVarents.value])).first.id}");
    //                                                       // MenuApiController().updateVariants(verId: c.verIds[c.indexVarents.value], price: c.varents[c.indexVarents.value], option:  c.varents2[c.indexVarents.value], optionId: optionId)
    //                                                     }else{
    //                                                       if(!c.varents2.contains(c.selectedValue.value)){
    //                                                         c.varents.add(price2.text);
    //                                                         c.varents2.add(c.selectedValue.value);
    //                                                         price2.text = "";
    //                                                         c.verIds.add("-1");
    //                                                       }
    //
    //                                                     }
    //
    //                                                   },
    //                                                   child: Text(
    //                                                     c.editVarents.value ? "تعديل" :  "اضف",
    //                                                     style: GoogleFonts.notoKufiArabic(
    //                                                       textStyle:  TextStyle(
    //                                                         color: Colors.black,
    //                                                         fontSize: 10.sp,
    //                                                         fontWeight: FontWeight.w600,
    //                                                       ),
    //                                                     ),
    //                                                     textAlign: TextAlign.start,
    //                                                   ),
    //                                                 ),
    //
    //
    //                                               ],
    //                                             ),
    //                                             ListView.builder(
    //                                                 itemCount: c.varents.length,
    //                                                 shrinkWrap: true,
    //                                                 physics: NeverScrollableScrollPhysics(),
    //                                                 itemBuilder: (context, index){
    //                                                   return Row(
    //                                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                                                     children: [
    //                                                       Row(
    //                                                         children: [
    //                                                           Text("₺ ${c.varents[index]}", style: GoogleFonts.notoKufiArabic(
    //                                                             textStyle:  TextStyle(
    //                                                               color: Colors.black,
    //                                                               fontSize: 12.sp,
    //                                                               fontWeight: FontWeight.w600,
    //                                                             ),
    //                                                           ),),
    //                                                           SizedBox(width: 10.w,),
    //                                                           Text(c.varents2[index], style: GoogleFonts.notoKufiArabic(
    //                                                             textStyle:  TextStyle(
    //                                                               color: Colors.black,
    //                                                               fontSize: 12.sp,
    //                                                               fontWeight: FontWeight.w600,
    //                                                             ),
    //                                                           ),),
    //                                                         ],
    //                                                       ),
    //                                                       Row(
    //                                                         children: [
    //                                                           IconButton(onPressed: (){
    //
    //                                                             print(c.varents2);
    //                                                             c.indexVarents.value = index;
    //                                                             price2.text = c.varents[index];
    //                                                             // c.selectedValue.value = c.varents2[c.indexVarents.value];
    //                                                             c.editVarents.value = true;
    //                                                             // optionName.text = c.optionsName[idx];
    //                                                             // c.indexOptions.value = idx;
    //                                                             // print( c.indexOptions.value);
    //                                                             // c.edit.value = true;
    //                                                             // print(c.options3.length);
    //                                                             // c.controllers.value = List.generate(c.options3[idx].length, (index) => TextEditingController());
    //                                                             // c.textFields.value = List.generate(c.options3[idx].length, (index) => MyTextField(hint: "كبير", controller: c.controllers[index]));
    //                                                             //
    //                                                             // for(int m = 0; m < c.controllers.length; m++){
    //                                                             //   for(int z = 0; z < c.options3[idx].length; z++){
    //                                                             //     c.controllers[m].text = c.options3[idx][m];
    //                                                             //   }
    //                                                             // }
    //                                                           }, icon: Icon(Icons.edit, color: AppColors().mainColor,)),
    //                                                           IconButton(onPressed: (){
    //                                                             c.indexVarents.value = index;
    //                                                             c.varents.removeAt(c.indexVarents.value);
    //                                                             c.varents2.removeAt(c.indexVarents.value);
    //                                                             c.varents.refresh();
    //                                                             c.varents2.refresh();
    //                                                             // c.options3.clear();
    //                                                             // c.optionsName.clear();
    //                                                             // setState(() {
    //                                                             //
    //                                                             // });
    //                                                           }, icon: Icon(Icons.delete, color: AppColors().mainColor,)),
    //                                                         ],
    //                                                       )
    //
    //                                                     ],
    //                                                   );
    //                                                 })
    //                                           ],
    //                                         ),
    //                                       ),
    //
    //                                       Column(
    //                                         crossAxisAlignment: CrossAxisAlignment.start,
    //
    //                                         children: [
    //                                           Text(
    //                                             "اضافات على الوجبة",
    //                                             style: GoogleFonts.notoKufiArabic(
    //                                               textStyle:  TextStyle(
    //                                                 color: Colors.black,
    //                                                 fontSize: 13.sp,
    //                                                 fontWeight: FontWeight.w600,
    //                                               ),
    //                                             ),
    //                                             textAlign: TextAlign.start,
    //                                           ),
    //                                           Row(
    //                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                                             children: [
    //                                               Expanded(
    //                                                 flex: 3,
    //                                                 child: Column(
    //                                                   children: [
    //                                                     MyTextField(hint: "اسم الاضافة", controller: extraName),
    //                                                     SizedBox(height: 10.h,),
    //                                                     MyTextField(hint: "السعر", controller: extraPrice),
    //                                                   ],
    //                                                 ),
    //                                               ),
    //
    //                                               SizedBox(width: 10.w,),
    //
    //                                               InkWell(
    //                                                 onTap: (){
    //
    //                                                   if(c.editExtra.value){
    //                                                     c.extras2[c.indexExtra.value] = extraName.text;
    //                                                     c.extras[c.indexExtra.value] = extraPrice.text;
    //                                                     extraPrice.text = "";
    //                                                     extraName.text = "";
    //                                                     c.editExtra.value = false;
    //                                                   }else{
    //                                                     c.extras.add(extraPrice.text);
    //                                                     c.extras2.add(extraName.text);
    //                                                     extraPrice.text = "";
    //                                                     extraName.text = "";
    //                                                     c.extrasIds.add("-1");
    //                                                     print(c.extrasIds);
    //                                                   }
    //
    //                                                 },
    //                                                 child: Text(
    //                                                   c.editExtra.value ? "تعديل" : "اضف",
    //                                                   style: GoogleFonts.notoKufiArabic(
    //                                                     textStyle:  TextStyle(
    //                                                       color: Colors.black,
    //                                                       fontSize: 10.sp,
    //                                                       fontWeight: FontWeight.w600,
    //                                                     ),
    //                                                   ),
    //                                                   textAlign: TextAlign.start,
    //                                                 ),
    //                                               ),
    //
    //
    //                                             ],
    //                                           ),
    //                                           ListView.builder(
    //                                               itemCount: c.extras2.length,
    //                                               shrinkWrap: true,
    //                                               physics: NeverScrollableScrollPhysics(),
    //                                               itemBuilder: (context, index){
    //                                                 return Row(
    //                                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                                                   children: [
    //                                                     Row(
    //                                                       children: [
    //                                                         Text("₺ ${c.extras[index]}", style: GoogleFonts.notoKufiArabic(
    //                                                           textStyle:  TextStyle(
    //                                                             color: Colors.black,
    //                                                             fontSize: 12.sp,
    //                                                             fontWeight: FontWeight.w600,
    //                                                           ),
    //                                                         ),),
    //                                                         SizedBox(width: 10.w,),
    //                                                         Text(c.extras2[index], style: GoogleFonts.notoKufiArabic(
    //                                                           textStyle:  TextStyle(
    //                                                             color: Colors.black,
    //                                                             fontSize: 12.sp,
    //                                                             fontWeight: FontWeight.w600,
    //                                                           ),
    //                                                         ),),
    //                                                       ],
    //                                                     ),
    //                                                     Row(
    //                                                       children: [
    //                                                         IconButton(onPressed: (){
    //
    //                                                           c.indexExtra.value = index;
    //                                                           extraPrice.text = c.extras[index];
    //                                                           extraName.text = c.extras2[index];
    //                                                           c.editExtra.value = true;
    //                                                           // optionName.text = c.optionsName[idx];
    //                                                           // c.indexOptions.value = idx;
    //                                                           // print( c.indexOptions.value);
    //                                                           // c.edit.value = true;
    //                                                           // print(c.options3.length);
    //                                                           // c.controllers.value = List.generate(c.options3[idx].length, (index) => TextEditingController());
    //                                                           // c.textFields.value = List.generate(c.options3[idx].length, (index) => MyTextField(hint: "كبير", controller: c.controllers[index]));
    //                                                           //
    //                                                           // for(int m = 0; m < c.controllers.length; m++){
    //                                                           //   for(int z = 0; z < c.options3[idx].length; z++){
    //                                                           //     c.controllers[m].text = c.options3[idx][m];
    //                                                           //   }
    //                                                           // }
    //                                                         }, icon: Icon(Icons.edit, color: AppColors().mainColor,)),
    //                                                         IconButton(onPressed: (){
    //                                                           c.indexExtra.value = index;
    //                                                           c.extras.removeAt(c.indexVarents.value);
    //                                                           c.extras2.removeAt(c.indexVarents.value);
    //                                                           c.extras.refresh();
    //                                                           c.extras2.refresh();
    //                                                           // c.options3.clear();
    //                                                           // c.optionsName.clear();
    //                                                           // setState(() {
    //                                                           //
    //                                                           // });
    //                                                         }, icon: Icon(Icons.delete, color: AppColors().mainColor,)),
    //                                                       ],
    //                                                     )
    //                                                   ],
    //                                                 );
    //                                               })
    //                                         ],
    //                                       )
    //
    //                                     ],
    //                                   );
    //                                 }
    //                             ),
    //
    //
    //
    //                             MainElevatedButton(child: Text(
    //                               "حفط التعديلات",
    //                               style: GoogleFonts.notoKufiArabic(
    //                                 textStyle:  TextStyle(
    //                                   color: Colors.white,
    //                                   fontSize: 12.sp,
    //                                   fontWeight: FontWeight.w600,
    //                                 ),
    //                               ),
    //                             ), height: 48.h, width: Get.width, borderRadius: 5, onPressed: (){
    //
    //                               if(AllMenusGetxController.to.selectedCategory != null){
    //                                 AddItem item = AddItem();
    //                                 // item.categoryName = controller.categories[index];
    //                                 item.itemName = name.text;
    //                                 item.item_price = int.parse(price.text);
    //                                 item.itemDesc = desc.text;
    //                                 if(pic.path.isNotEmpty){
    //                                   item.item_image= pic.path.value;
    //                                 }else{
    //                                   item.item_image=null;
    //                                 }
    //
    //
    //                                 MenuApiController().updateMenuItem(item: item, categoryId: AllMenusGetxController.to.selectedCategory!.id.toString(), resId: widget.foodId.toString());
    //
    //                                 AllMenusGetxController.to.getMenus(resturentName: widget.resId.toString());
    //                               }else{
    //                                 Fluttertoast.showToast(msg: "يجب اختيار قسم");
    //                               }
    //
    //                             }),
    //                             // InkWell(
    //                             //   onTap: (){
    //                             //     // AddItem item = AddItem();
    //                             //     // item.categoryName = controller.categories[index];
    //                             //     // item.itemName = name.text;
    //                             //     // item.item_price = int.parse(price.text);
    //                             //     // item.itemDesc = desc.text;
    //                             //     // item.item_image= pic.path.value;
    //                             //     // AddWorkOrAdsController.to.items.add(item);
    //                             //     // // category != null ? AddWorkOrAdsController.to.categories[index!] =  controller.text :   AddWorkOrAdsController.to.categories.add(controller.text);
    //                             //     // Navigator.pop(context);
    //                             //     // AuthConsumer().sendOtpCodeCivil(context, civilId, false, "forget");
    //                             //   },
    //                             //   child: Text(
    //                             //     "اضافة",
    //                             //     style: GoogleFonts.notoKufiArabic(
    //                             //       textStyle:  TextStyle(
    //                             //         color: Colors.black,
    //                             //         fontSize: 12.sp,
    //                             //         fontWeight: FontWeight.w600,
    //                             //       ),
    //                             //     ),
    //                             //   ),),
    //                           ],
    //                         ),
    //                       );
    //                     }
    //                 )                            ],
    //             ),
    //           )
            ],
          );
        }
      ),
    );
  }
}
