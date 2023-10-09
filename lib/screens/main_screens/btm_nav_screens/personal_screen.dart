import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakwa/api/api_controllers/auth_api_controller.dart';
import 'package:rakwa/screens/add_listing_screens/Controllers/add_work_controller.dart';
import 'package:rakwa/screens/main_screens/btm_nav_screens/More/Widgets/card_more_screen.dart';
import 'package:rakwa/screens/personal_screens/Controllers/change_account_info_controller.dart';
import 'package:rakwa/screens/personal_screens/acount_information_screen.dart';
import 'package:rakwa/screens/personal_screens/address_screen.dart';
import 'package:rakwa/screens/personal_screens/change_password_screen.dart';
import 'package:rakwa/shared_preferences/shared_preferences.dart';
import 'package:rakwa/Core/utils/helpers.dart';
import 'package:rakwa/widget/appbars/app_bars.dart';
import 'package:rakwa/widget/drawer_data.dart';

import '../../../app_colors/app_colors.dart';
import '../../../controller/email_verified_getx_controller.dart';
import '../../../controller/home_getx_controller.dart';
import '../../../widget/my_text_field.dart';

class PersonalScreen extends StatefulWidget {
  const PersonalScreen({super.key});

  @override
  State<PersonalScreen> createState() => _PersonalScreenState();
}

class _PersonalScreenState extends State<PersonalScreen> with Helpers {
  late TextEditingController _searchController;


  final List actions = [
    ['images/user_icon.png', 'معلومات الحساب'],
    // ['images/address_icon.png', 'العنوان'],
    ['images/password_icon.png', 'كلمة المرور'],
    ['images/transfer.png', 'تحويل الحساب الى '],
  ];


  @override
  void initState() {
    super.initState();
    Get.put(AddWorkOrAdsController(isList: true));
    Get.put(ChangeAccountInfoController());
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars.appBarDefault(title: "الصفحة الشخصية"),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(
            height: 30,
          ),
          GetX<UserProfileGetxController>(
            builder: (controller) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: Colors.white,
                child: Row(
                  children: [
                controller.isLoading.value  ? Center(child: CircularProgressIndicator(),) :
                controller.profile.first.data!.userImage != null  ? CircleAvatar(
                            backgroundColor: AppColors.labelColor.withOpacity(0.4),
                            backgroundImage: NetworkImage(
                                'https://www.rakwa.com/laravel_project/public/storage/user/${UserProfileGetxController.to.profile.first.data!.userImage}'),
                            radius: 50,
                          )
                        : const CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage: AssetImage('images/defoultAvatar.png'),
                            radius: 50,
                          ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            UserProfileGetxController.to.profile.first.data!.name ?? "",
                            style: GoogleFonts.notoKufiArabic(
                                textStyle: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                          ),

                          const SizedBox(
                            height: 3,
                          ),
                          Text(
                            SharedPrefController().email,
                            style: GoogleFonts.notoKufiArabic(
                                textStyle:  TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.viewAllColor)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          ),
           SizedBox(
            height: 24.h,
          ),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الحساب',
                  style: GoogleFonts.notoKufiArabic(
                      textStyle:  TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                ),
                 SizedBox(
                  height: 3.h,
                ),
                Text(
                  'تحديث المعلومات الخاصة بك للحفاظ على حسابك',
                  style: GoogleFonts.notoKufiArabic(
                      textStyle:  TextStyle(
                          fontSize: 14.sp, color: AppColors.viewAllColor)),
                ),
                 SizedBox(
                  height: 24.h,
                ),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            child: ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      onTap: () {
                        if (index == 0) {
                          Get.to(() => const AccountInformationScreen());
                        }
                        else if (index == 1) {
                          Get.to(() => const PasswordScreen());
                        }
                        else {
                          alertDialogRoleAuthUser(context);

                          // ChangeAccountInfoController.to.convertUserAccount();
                        }
                      },
                      leading: Image.asset(actions[index][0], width:40.w , height: 40.h,fit: BoxFit.contain,),
                      title: GetX<ChangeAccountInfoController>(
                        builder: (controller) {
                          // print(controller.firstNameController.text);
                          print(controller.s.value);
                          return Text(
                          index == 2  ? "${actions[index][1]}${controller.s.value == "مستخدم"? "صاحب عمل": "مستخدم"}" :  "${actions[index][1]}" ,
                            style: GoogleFonts.notoKufiArabic(
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                          );
                        }
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    color: AppColors.viewAllColor,
                  );
                },
                itemCount: actions.length),
          ),

           SizedBox(height: 24.h),

          Container(

            color: Colors.white,
            child: ListTile(
              onTap: () async {
                if (SharedPrefController().isLogined) {
                  bool status = await AuthApiController().logout();
                } else {
                  Get.offAllNamed('/sign_in_screen');
                }
              },
              leading: Image.asset("images/LogOut.png", width:40.w , height: 40.h,),
              title: Text(
                SharedPrefController().isLogined
                    ? "تسجيل الخروج"
                    : "تسجيل الدخول",
                style: GoogleFonts.notoKufiArabic(
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
          ),
        ],
      ),
    );
  }
}
