import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakwa/Core/utils/extensions.dart';
import 'package:rakwa/api/api_controllers/profile_api_controller.dart';
import 'package:rakwa/app_colors/app_colors.dart';
import 'package:rakwa/controller/email_verified_getx_controller.dart';
import 'package:rakwa/controller/image_picker_controller.dart';
import 'package:rakwa/screens/add_listing_screens/Widget/bottom_sheet_country.dart';
import 'package:rakwa/screens/main_screens/btm_nav_screens/personal_screen.dart';
import 'package:rakwa/screens/personal_screens/Controllers/change_account_info_controller.dart';
import 'package:rakwa/shared_preferences/shared_preferences.dart';
import 'package:rakwa/Core/utils/helpers.dart';
import 'package:rakwa/widget/TextFields/text_field_default.dart';
import 'package:rakwa/widget/TextFields/validator.dart';
import 'package:rakwa/widget/appbars/app_bars.dart';
import 'package:rakwa/widget/main_elevated_button.dart';
import 'package:rakwa/widget/my_text_field.dart';

import '../../api/api_controllers/order_api_controller.dart';
import '../../controller/list_controller.dart';
import '../../model/country_model.dart';
import 'package:http/http.dart' as http;

class AccountInformationScreen extends StatefulWidget {
  const AccountInformationScreen({super.key});

  @override
  State<AccountInformationScreen> createState() =>
      _AccountInformationScreenState();
}

class _AccountInformationScreenState extends State<AccountInformationScreen>
    with Helpers {
  dynamic countryName;
  int? countryID;

  dynamic selectedCountry;
  late TextEditingController _locationController;

  // var kGoogleApiKey = "AIzaSyBGOvwzbb9UAQ5K2ECo1Jtb5rH9N9YRaF8";
  var kGoogleApiKey = "AIzaSyBwFkLaLQpcmX-vrUhKhaRlqF5-ISeBa8E";

  ListController _listController = Get.put(ListController());
  ImagePickerController _imagePickerController =
      Get.put(ImagePickerController());

  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  bool success = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
Future.delayed(Duration.zero,() async{
 success = await OrderApiController().checkVerifiyPhone(context);
});

  }
  @override
  Widget build(BuildContext context) {
    printDM("SharedPrefController().userPreferCountryId is => ${SharedPrefController()
        .userPreferCountryId}");
    ChangeAccountInfoController changeAccountInfoController =
        Get.put(ChangeAccountInfoController());
    var node = FocusScope.of(context);
    return Scaffold(
      appBar: AppBars.appBarDefault(title: "تغير معلومات الحساب"),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(height: 24),
          GetBuilder<ImagePickerController>(
            builder: (controller) {
              return Center(
                child: Stack(
                  children: [
                    GetX<UserProfileGetxController>(
                      builder: (controller) {
                        return InkWell(
                          onTap: () {
                            _imagePickerController.getImageFromGallary();
                          },
                          borderRadius: BorderRadius.circular(777),
                          child: _imagePickerController.image_file != null
                              ? Container(
                                  height: 100.h,
                                  width: 100.w,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(777),
                                      child: Image.file(
                                        File(
                                          _imagePickerController.image_file!.path,
                                        ),
                                        height: 100.h,
                                        width: 100.w,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                )
                              :        controller.isLoading.value  ? Center(child: CircularProgressIndicator(),) :
                          controller.profile.first.data!.userImage != null
                                  ? Container(
                                      height: 100.h,
                                      width: 100.w,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(777),
                                          child: Image.network(
                                            'https://www.rakwa.com/laravel_project/public/storage/user/${controller.profile.first.data!.userImage}',
                                            height: 100.h,
                                            width: 100.w,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      height: 100.h,
                                      width: 100.w,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(777),
                                          child: Image.asset(
                                            'images/defoultAvatar.png',
                                            height: 100.h,
                                            width: 100.w,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                        );
                      }
                    ),
                    PositionedDirectional(
                      start: 0.w,end: 0.w,
                      bottom: 0.h,
                      child: Container(
                        width: double.infinity,
                        height: 50.h,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          // shape: BoxShape.circle,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(100.r),
                            bottomRight: Radius.circular(100.r),
                          ),

                          color: Colors.black.withOpacity(0.30),

                        ),
                        child: IconButton(onPressed: (){

                          _imagePickerController.getImageFromGallary();

                        }, icon: Icon(Icons.camera_alt_outlined,color: Colors.white,)),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          GetBuilder<ChangeAccountInfoController>(
            builder: (_) => Form(
              key: _.globalKey,
              child: Column(
                children: [
                  TextFieldDefault(
                    upperTitle: 'الاسم الأول',
                    hint: 'ادخل الاسم الأول',
                    prefixIconSvg: "User",
                    // prefixIconData: Icons.person_outline,
                    controller: _.firstNameController,
                    keyboardType: TextInputType.name,
                    validation: firstNameValidator,
                    onComplete: () {
                      node.nextFocus();
                    },
                  ),
                   SizedBox(height: 16.h),
                  TextFieldDefault(
                    upperTitle: 'الاسم الأخير',
                    hint: 'ادخل الاسم الأخير',
                    prefixIconSvg: "User",
                    controller: _.lastNameController,
                    keyboardType: TextInputType.name,
                    validation: lastNameValidator,
                    onComplete: () {
                      node.nextFocus();
                    },
                  ),
                   SizedBox(height: 16.h),
                  TextFieldDefault(
                    upperTitle: 'البريد الالكتروني',
                    hint: 'ادخل البريد الالكتروني',
                    prefixIconSvg: "Email",
                    // prefixIconData: Icons.email_outlined,
                    controller: _.emailController,
                    keyboardType: TextInputType.emailAddress,
                    validation: emailValidator,


                    onComplete: () {
                      node.nextFocus();
                    },
                  ),
                   SizedBox(height: 16.h),

                 Row(
                   children: [

                     Expanded(
                       child: SizedBox(
                         width: Get.width / 1.54,
                         child: TextFieldDefault(
                           upperTitle: "رقم الهاتف",
                           hint: '0587654634',
                           prefixIconSvg: "TFPhone",
                           // prefixIconData: Icons.phone_outlined,
                           controller: _.phoneController,
                           keyboardType: TextInputType.phone,
                           validation: phoneValidator,
                           onComplete: () {
                             node.nextFocus();
                           },
                         ),
                       ),
                     ),
                     Padding(
                       padding:  EdgeInsets.only(top: 35.h),
                       child: CountryCodePicker(
                         onChanged: (v){
                           print(v);
                           _.codeCountry.value = v.toString();
                         },

                         // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                         initialSelection: _.codeCountry.value,
                         // favorite: ['+39','FR'],
                         // optional. Shows only country name and flag
                         showCountryOnly: false,
                         // optional. Shows only country name and flag when popup is closed.
                         showOnlyCountryWhenClosed: false,
                         // optional. aligns the flag and the Text left
                         alignLeft: false,
                       ),
                     ),

                   ],
                 ),

              Visibility(
               visible: success,
                child: InkWell(
                  onTap: (){
                    OrderApiController().checkVerifiyPhone(context);
                  },
                  child: Align(
                    alignment: AlignmentDirectional.topEnd,
                        child: Text(
                          "تحقق من الرقم",
                          // textDirection: TextDirection.rtl,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.notoKufiArabic(
                            textStyle:  TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          // style: Theme.of(context).textTheme.caption!.copyWith(
                          //     color: usedUpperTitleColor,
                          //     fontSize: 16,
                          //     fontFamily: 'light',
                          // ),
                        ),
                      ),
                ),
              ),
                   SizedBox(height: 16.h),
                  // GetBuilder<ListController>(
                  //   builder: (controller) => GestureDetector(
                  //     onTap: () {
                  //       node.unfocus();
                  //       Get.bottomSheet(
                  //         BottomSheetCountry(
                  //           country: controller.countrys,
                  //           bottomSheetTitle: "الدول",
                  //           countrySelectedId: countryID !=null ? countryID!:
                  //               SharedPrefController()
                  //                   .userPreferCountryId!="null"?int.tryParse(SharedPrefController()
                  //               .userPreferCountryId) as int :
                  //               0,
                  //           onSelect: (country) {
                  //             setState(() {
                  //               selectedCountry = country;
                  //               _.countryController.text = country.countryName ?? "";
                  //               countryID = country.id;
                  //             });
                  //           },
                  //         ),
                  //       );
                  //     },
                  //     child: TextFieldDefault(
                  //       enable: false,
                  //       upperTitle: "الدولة",
                  //       hint: 'اختار الدولة',
                  //       prefixIconSvg: "country",
                  //       suffixIconData: Icons.arrow_drop_down_sharp,
                  //       controller: _.countryController,
                  //       validation: locationValidator,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
           SizedBox(height: 32.h),
          MainElevatedButton(
            height: 56.h,
            width: Get.width,
            borderRadius: 12.r,
            onPressed: () {

              node.unfocus();
              if(ChangeAccountInfoController.to.globalKey.currentState!.validate()){
                changeAccountInfoController.changeAccountInfo(
                  // countryId: countryID != null ? countryID.toString() : '399',
                  file: _imagePickerController.image_file != null
                      ? File(_imagePickerController.image_file!.path)
                      : null,
                );
              }


            },
            child: Text(
              'حفظ التغيرات',
              style: GoogleFonts.notoKufiArabic(
                textStyle:  TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
           SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
