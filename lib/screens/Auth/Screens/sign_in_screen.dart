import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakwa/app_colors/app_colors.dart';
import 'package:rakwa/controller/fb_notifications_controller.dart';
import 'package:rakwa/controller/home_getx_controller.dart';
import 'package:rakwa/screens/Auth/Controllers/sign_in_controller.dart';
import 'package:rakwa/screens/Auth/Widgets/have_or_not_have_account.dart';
import 'package:rakwa/screens/Auth/Widgets/sign_in_as_visitor_widget.dart';
import 'package:rakwa/shared_preferences/shared_preferences.dart';
import 'package:rakwa/widget/Buttons/button_default.dart';
import 'package:rakwa/widget/TextFields/text_field_default.dart';
import 'package:rakwa/widget/TextFields/validator.dart';
import 'package:rakwa/widget/main_elevated_button.dart';
import 'package:upgrader/upgrader.dart';

class SignInScreen extends StatelessWidget with FBNotificationsController {
  SignInScreen({super.key});


  @override
  Widget build(BuildContext context) {
    Get.put(SignInController());

    var node = FocusScope.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 16.w,),
        child: KeyboardVisibilityBuilder(
          builder: (context, isKeyboardVisible) {
            return GetBuilder<SignInController>(
              builder: (_) => Form(
                key: _.globalKey,
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  // shrinkWrap: true,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 48.h,
                    ),
                    Center(
                      child: Image.asset(
                        'images/logo3.png',
                        height: 73.h,
                        width: 73.w,
                      ),
                    ),
                     SizedBox(
                      height: 24.h,
                    ),
                    Center(
                      child: Text(
                        'تسجيل الدخول',
                        style: GoogleFonts.notoKufiArabic(
                          textStyle:  TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                     SizedBox(
                      height: 24.h,
                    ),
                    TextFieldDefault(
                      upperTitle: "البريد الالكتروني",
                      hint: 'ادخل البريد الالكتروني',
                      prefixIconSvg: "Email",
                      // prefixIconData: Icons.email_outlined,
                      controller: _.emailController,
                      keyboardType: TextInputType.emailAddress,
                      validation: userNameValidator,
                      onComplete: () {
                        node.nextFocus();
                      },
                      ltr: true,

                    ),
                     SizedBox(height: 16.h),
                    TextFieldDefault(
                      upperTitle: "كلمة المرور",
                      hint: 'ادخل كلمه المرور',
                      controller: _.passwordController,
                      secureType: SecureType.Toggle,
                      prefixIconSvg: "Password",
                      // prefixIconData: Icons.lock_outline,
                      validation: passwordValidator,
                      onComplete: () {
                        node.unfocus();
                        _.submit();
                      },
                      ltr: true,

                    ),
                     SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Row(
                          children: [
                            Transform.scale(
                              scale: 1.1.h,
                              child: Checkbox(value: _.remember, onChanged: (value){
                                _.remmber(value!);
                                print(_.remember);
                              },
                              activeColor: AppColors().mainColor,

                              ),
                            ),
                            SizedBox(width: 2.w,),
                            Text("تذكرني",style:  GoogleFonts.notoKufiArabic(
                                textStyle:  TextStyle(
                                  fontSize: 10.sp,
                                ),),)
                          ],
                        ),

                        // SizedBox(),
                        Spacer(),
                        Expanded(
                          child: ButtonDefault(
                            onTap: () {
                              _.moveToForgetPassword();
                            },
                            title: 'نسيت كلمة المرور ؟',
                            titleColor: Colors.black,
                            titleSize: 12.sp,
                            buttonColor: Colors.transparent,
                            // width: 120.w,
                          ),
                        ),
                      ],
                    ),
                     SizedBox(
                      height: 32.h,
                    ),
                    MainElevatedButton(
                      height: 56.h,
                      width: Get.width,
                      borderRadius: 12.r,
                      onPressed: () {
                        node.unfocus();
                        _.submit();
                      },
                      child: Text(
                        'تسجيل الدخول',
                        style: GoogleFonts.notoKufiArabic(
                          textStyle:  TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                     SizedBox(
                      height: 12.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        SizedBox(),
                        SignInAsVisitor(),
                      ],
                    ),
                     SizedBox(height: 10.h),
                    HaveOrNotHaveAccount(
                      title: 'لا تمتلك حساب؟',
                      subTitle: 'قم بإنشاء حساب',
                      onTap: () {
                       _.moveToRegister();
                      },
                    ),
                    SizedBox(
                      height: 48.h,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

}


