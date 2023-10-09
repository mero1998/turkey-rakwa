import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakwa/app_colors/app_colors.dart';
import 'package:rakwa/model/register_model.dart';
import 'package:rakwa/screens/Auth/Controllers/sign_up_controller.dart';
import 'package:rakwa/screens/Auth/Screens/sign_in_screen.dart';
import 'package:rakwa/screens/Auth/Widgets/accept_privacy_register_widget.dart';
import 'package:rakwa/screens/Auth/Widgets/have_or_not_have_account.dart';
import 'package:rakwa/screens/Auth/Widgets/sign_in_as_visitor_widget.dart';
import 'package:rakwa/screens/contact_about_screens/privacy_policy_screen.dart';
import 'package:rakwa/screens/launch_screen/launch_screen.dart';
import 'package:rakwa/widget/Loading/loading_dialog.dart';
import 'package:rakwa/widget/TextFields/text_field_default.dart';
import 'package:rakwa/widget/TextFields/validator.dart';
import 'package:rakwa/widget/appbars/app_bars.dart';

import '../../../api/api_controllers/auth_api_controller.dart';
import '../../../widget/label_text.dart';
import '../../../widget/main_elevated_button.dart';
import '../../../widget/my_text_field.dart';

class SignUpScreen extends StatelessWidget {
  final int roleId;

  const SignUpScreen({super.key, required this.roleId});

  @override
  Widget build(BuildContext context) {
    Get.put(SignUpController());
    var node = FocusScope.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBars.appBarDefault(title: 'إنشاء حساب جديد'),
      body: KeyboardVisibilityBuilder(
        builder: (p0, isKeyboardVisible) => GetBuilder<SignUpController>(
          builder: (_) => Form(
            key: _.globalKey,
            child: Padding(
              padding: EdgeInsets.only(
                right: 16.w,
                left: 16.w,
                bottom: MediaQuery.of(context).padding.bottom,
              ),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [

                   SizedBox(
                    height: 16.h,
                  ),
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
                    ltr: true,

                  ),
                   SizedBox(
                    height: 16.h,
                  ),
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
                    ltr: true,

                  ),
                   SizedBox(
                    height: 16.h
                  ),
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
                    ltr: true,

                  ),
                   SizedBox(
                    height: 16.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          width: Get.width / 1.45,
                          child:  TextFieldDefault(
                            upperTitle: "رقم الهاتف",
                            hint: 'ادخل رقم الهاتف',
                            prefixIconSvg: "TFPhone",
                            // prefixIconData: Icons.phone_outlined,
                            controller: _.phoneController,
                            keyboardType: TextInputType.phone,
                            validation: phoneValidator,
                            onComplete: () {
                              node.nextFocus();
                            },
                            ltr: true,

                          ),
                        ),
                      ),
                      Padding(
                        padding:  EdgeInsetsDirectional.only(top: 30.h),
                        child: CountryCodePicker(
                          onChanged: (v){
                            print(v);
                            _.code.value = v.toString();
                            // _.codeCountry.value = v.toString();
                          },

                          // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                          initialSelection: "TR",
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

                  SizedBox(
                    height: 16.h,
                  ),
                  TextFieldDefault(
                    upperTitle: 'كلمة المرور',
                    hint: 'ادخل كلمة المرور',
                    prefixIconSvg: "Password",
                    // prefixIconData: Icons.lock_outline,
                    controller: _.passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    secureType: SecureType.Toggle,
                    validation: passwordValidator,
                    onComplete: () {
                      node.unfocus();
                      _.signUp(roleId: roleId);
                    },
                    ltr: true,

                  ),
                   SizedBox(
                    height: 24.h,
                  ),

                   SizedBox(height: 16.h),
                  const AcceptPrivacyRegisterWidget(),
                   SizedBox(height: 16.h),

                  MainElevatedButton(
                    onPressed: () {
                      _.signUp(roleId: roleId);
                    },
                    height: 56.h,
                    width: Get.width,
                    borderRadius: 10.r,
                    child: Text(
                      'التالي',
                      style: GoogleFonts.notoKufiArabic(
                          textStyle:  TextStyle(
                              fontSize: 12.sp, fontWeight: FontWeight.w500)),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      SizedBox(),
                      SignInAsVisitor(),
                    ],
                  ),
                   SizedBox(
                    height: 16.h,
                  ),
                  HaveOrNotHaveAccount(
                      title: "املك حساب بالفعل؟",
                      subTitle: 'تسجيل دخول',
                      onTap: () {
                        Get.offAll(() => SignInScreen());
                      }),
                   SizedBox(
                    height: 16.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
