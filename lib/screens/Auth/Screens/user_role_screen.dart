import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakwa/app_colors/app_colors.dart';
import 'package:rakwa/screens/Auth/Screens/sign_up_screen.dart';
import 'package:rakwa/screens/details_screen/details_screen.dart';
import 'package:rakwa/widget/main_elevated_button.dart';

class UserRoleScreen extends StatefulWidget {
  const UserRoleScreen({super.key});

  @override
  State<UserRoleScreen> createState() => _UserRoleScreenState();
}

class _UserRoleScreenState extends State<UserRoleScreen> {
  String userRole = 'userRole';

  Widget buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 200.h,
      pinned: true,
      stretch: true,
      backgroundColor: Colors.white,
      leading: Center(
        child: CircleAvatar(
          backgroundColor: Colors.black.withOpacity(0.4),
          child: IconButton(
              onPressed: () {


                  Get.back();



              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
        ),
      ),
      title: Text(
        'تسجيل حساب',
        style: GoogleFonts.notoKufiArabic(
          textStyle:  TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 18.sp,
            color: Colors.white,
          ),
        ),
      ),
      centerTitle: true,

      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [

            Image.asset(
              width: double.infinity,
              height: double.infinity,
              'images/users.png',
              fit: BoxFit.cover,
            ),
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black.withOpacity(0.64),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          buildSliverAppBar(),
          SliverList(
              delegate: SliverChildListDelegate([
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  SizedBox(height: 24.h),
                  Image.asset(
                    'images/logo3.png',
                    height: 98.h,
                    width: 98.w,
                  ),
                   SizedBox(
                    height: 32.h,
                  ),
                  Text(
                    'قم باختيار تسجيل المستخدم الذي تريده كصاحب عمل أو مشتري',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.notoKufiArabic(
                        textStyle:  TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18.sp,
                      color: AppColors.drawerColor,
                    )),
                  ),
                   SizedBox(
                    height: 42.h,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: userRole == 'business'
                            ? Border.all(color: AppColors().mainColor)
                            : null),
                    child: RadioListTile(
                      activeColor: AppColors().mainColor,
                      title: Row(
                        children: [
                          const Icon(
                            Icons.account_balance_rounded,
                            color: Colors.black,
                          ),
                           SizedBox(
                            width: 8.w,
                          ),
                          Text(
                            'صاحب عمل',
                            style: GoogleFonts.notoKufiArabic(
                              fontSize: 12.sp,
                              color: userRole == 'business'
                                  ? AppColors().mainColor
                                  : Colors.black,

                            ),
                          ),
                        ],
                      ),
                      value: 'business',
                      groupValue: userRole,
                      onChanged: (value) {
                        setState(() {
                          userRole = 'business';
                        });
                      },
                    ),
                  ),
                  Divider(thickness: 1),
                  Container(
                    decoration: BoxDecoration(
                        border: userRole == 'user'
                            ? Border.all(color: AppColors().mainColor)
                            : null),
                    child: RadioListTile(
                      activeColor: AppColors().mainColor,
                      title: Row(
                        children: [
                          const Icon(
                            Icons.person,
                            color: Colors.black,
                          ),
                           SizedBox(
                            width: 8.w,
                          ),
                          Text(
                            'مستخدم',
                            style: GoogleFonts.notoKufiArabic(
                              fontSize: 12.sp,

                              color: userRole == 'user'
                                  ? AppColors().mainColor
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                      value: 'user',
                      groupValue: userRole,

                      onChanged: (value) {
                        setState(() {
                          userRole = 'user';
                        });
                      },
                    ),
                  ),
                   SizedBox(
                    height: 32.h,
                  ),
                  MainElevatedButton(
                    onPressed: () {
                      if (userRole == 'business') {
                        Get.to(() => SignUpScreen(roleId: 3));
                      } else if (userRole == 'user') {
                        Get.to(() => SignUpScreen(roleId: 2));
                      } else {
                        Get.snackbar('خطأ', 'قم باختيار نوع حسابك',
                            backgroundColor: Colors.red.shade700,
                            colorText: Colors.white);
                      }
                    },
                    borderRadius: 12,
                    height: 56.h,
                    width: Get.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ابدأ الان',
                          style: GoogleFonts.notoKufiArabic(
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                         SizedBox(
                          width: 10.w,
                        ),
                        const Icon(Icons.arrow_forward)
                      ],
                    ),
                  ),
                  SizedBox(height: 200.h)
                ],
              ),
            ),
          ])),
        ],
      ),

      // Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     Container(
      //       height:300 ,
      //       width: double.infinity,
      //       color: Colors.red,
      //       child: Image.asset(
      //         'images/users.png',
      //         fit: BoxFit.cover,
      //       ),
      //     ),
      //     const SizedBox(
      //       height: 7,
      //     ),
      //     Expanded(
      //         child: ListView(
      //       padding: const EdgeInsets.symmetric(horizontal: 16),
      //       physics: const BouncingScrollPhysics(),
      //       children: [
      //         Image.asset(
      //           'images/logo.jpg',
      //           height: 98,
      //           width: 98,
      //         ),
      //         const SizedBox(
      //           height: 32,
      //         ),
      //         Text(
      //           'قم باختيار تسجيل المستخدم الذي تريده كصاحب عمل أو مشتري',
      //           textAlign: TextAlign.center,
      //           style: GoogleFonts.notoKufiArabic(
      //               textStyle: const TextStyle(
      //             fontWeight: FontWeight.w800,
      //             fontSize: 18,
      //             color: AppColors.drawerColor,
      //           )),
      //         ),
      //         const SizedBox(
      //           height: 42,
      //         ),
      //         Container(
      //           decoration: BoxDecoration(
      //               border: userRole == 'business'
      //                   ? Border.all(color: AppColors().mainColor)
      //                   : null),
      //           child: RadioListTile(
      //             activeColor: AppColors().mainColor,
      //             title: Row(
      //               children: [
      //                 const Icon(
      //                   Icons.account_balance_rounded,
      //                   color: Colors.black,
      //                 ),
      //                 const SizedBox(
      //                   width: 8,
      //                 ),
      //                 Text(
      //                   'صاحب عمل',
      //                   style: GoogleFonts.notoKufiArabic(
      //                     color: userRole == 'business'
      //                         ? AppColors().mainColor
      //                         : Colors.black,
      //                   ),
      //                 ),
      //               ],
      //             ),
      //             value: 'business',
      //             groupValue: userRole,
      //             onChanged: (value) {
      //               setState(() {
      //                 userRole = 'business';
      //               });
      //             },
      //           ),
      //         ),
      //         Container(
      //           decoration: BoxDecoration(
      //               border: userRole == 'user'
      //                   ? Border.all(color: AppColors().mainColor)
      //                   : null),
      //           child: RadioListTile(
      //             activeColor: AppColors().mainColor,
      //             title: Row(
      //               children: [
      //                 const Icon(
      //                   Icons.person,
      //                   color: Colors.black,
      //                 ),
      //                 const SizedBox(
      //                   width: 8,
      //                 ),
      //                 Text(
      //                   'مستخدم',
      //                   style: GoogleFonts.notoKufiArabic(
      //                     color: userRole == 'user'
      //                         ? AppColors().mainColor
      //                         : Colors.black,
      //                   ),
      //                 ),
      //               ],
      //             ),
      //             value: 'user',
      //             groupValue: userRole,
      //             onChanged: (value) {
      //               setState(() {
      //                 userRole = 'user';
      //               });
      //             },
      //           ),
      //         ),
      //         const SizedBox(
      //           height: 32,
      //         ),
      //         MainElevatedButton(
      //           onPressed: () {
      //             if (userRole == 'business') {
      //               Get.to(() => SignUpScreen(roleId: 3));
      //             } else if (userRole == 'user') {
      //               Get.to(() => SignUpScreen(roleId: 2));
      //             } else {
      //               Get.snackbar('خطأ', 'قم باختيار نوع حسابك',
      //                   backgroundColor: Colors.red.shade700,
      //                   colorText: Colors.white);
      //             }
      //           },
      //           borderRadius: 12,
      //           height: 56,
      //           width: Get.width,
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: [
      //               Text(
      //                 'ابدأ الان',
      //                 style: GoogleFonts.notoKufiArabic(
      //                     textStyle: const TextStyle(
      //                         fontSize: 16, fontWeight: FontWeight.w500)),
      //               ),
      //               const SizedBox(
      //                 width: 10,
      //               ),
      //               const Icon(Icons.arrow_forward)
      //             ],
      //           ),
      //         ),
      //       ],
      //     )),
      //     // const SizedBox(
      //     //   height: 160,
      //     // ),
      //     // Text(
      //     //   'قم بتسجيل الدخول كـ',
      //     //   style: GoogleFonts.notoKufiArabic(
      //     //       textStyle: const TextStyle(
      //     //           color: Colors.black,
      //     //           fontSize: 18,
      //     //           fontWeight: FontWeight.bold)),
      //     // ),
      //     // const Spacer(),
      //     // SizedBox(
      //     //   height: 150,
      //     //   child: Row(
      //     //     children: [
      //     //       Expanded(
      //     //         child: InkWell(
      //     //           onTap: () => Get.to(() => SignUpScreen(roleId: 2)),
      //     //           child: Container(
      //     //             alignment: Alignment.center,
      //     //             decoration: BoxDecoration(
      //     //               color: AppColors().mainColor.withOpacity(0.4),
      //     //               borderRadius: BorderRadius.circular(12),
      //     //             ),
      //     //             child: Column(
      //     //               mainAxisAlignment: MainAxisAlignment.center,
      //     //               children: [
      //     //                 const Icon(
      //     //                   Icons.person,
      //     //                   color: Colors.white,
      //     //                   size: 40,
      //     //                 ),
      //     //                 const SizedBox(
      //     //                   height: 8,
      //     //                 ),
      //     //                 Text(
      //     //                   'مستخدم',
      //     //                   style: GoogleFonts.notoKufiArabic(
      //     //                       textStyle: const TextStyle(
      //     //                           color: Colors.white,
      //     //                           fontSize: 18,
      //     //                           fontWeight: FontWeight.bold)),
      //     //                 ),
      //     //               ],
      //     //             ),
      //     //           ),
      //     //         ),
      //     //       ),
      //     //       const SizedBox(
      //     //         width: 24,
      //     //       ),
      //     //       Expanded(
      //     //         child: InkWell(
      //     //           onTap: () => Get.to(() => SignUpScreen(roleId: 3)),
      //     //           child: Container(
      //     //             alignment: Alignment.center,
      //     //             decoration: BoxDecoration(
      //     //               color: AppColors().mainColor.withOpacity(0.4),
      //     //               borderRadius: BorderRadius.circular(12),
      //     //             ),
      //     //             child: Column(
      //     //               mainAxisAlignment: MainAxisAlignment.center,
      //     //               children: [
      //     //                 const Icon(
      //     //                   Icons.account_balance_rounded,
      //     //                   color: Colors.white,
      //     //                   size: 40,
      //     //                 ),
      //     //                 const SizedBox(
      //     //                   height: 8,
      //     //                 ),
      //     //                 Text(
      //     //                   'صاحب عمل',
      //     //                   style: GoogleFonts.notoKufiArabic(
      //     //                       textStyle: const TextStyle(
      //     //                           color: Colors.white,
      //     //                           fontSize: 18,
      //     //                           fontWeight: FontWeight.bold)),
      //     //                 ),
      //     //               ],
      //     //             ),
      //     //           ),
      //     //         ),
      //     //       ),
      //     //     ],
      //     //   ),
      //     // ),
      //     // const Spacer(),
      //   ],
      // ),
    );
  }
}
