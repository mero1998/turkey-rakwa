import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakwa/Core/utils/helpers.dart';
import 'package:rakwa/api/api_controllers/auth_api_controller.dart';
import 'package:rakwa/app_colors/app_colors.dart';
import 'package:rakwa/screens/add_ad/add_ad_screen.dart';
import 'package:rakwa/screens/add_listing_screens/add_list_category_screen.dart';
import 'package:rakwa/screens/add_listing_screens/add_list_classified_category_screen.dart';
import 'package:rakwa/screens/address/all_address_screen.dart';
import 'package:rakwa/screens/ads/user_ads_screen.dart';
import 'package:rakwa/screens/all_last_activities/all_last_activities_screen.dart';
import 'package:rakwa/screens/cart/cart_screen.dart';
import 'package:rakwa/screens/contact_about_screens/about_screen.dart';
import 'package:rakwa/screens/contact_about_screens/contact_screen.dart';
import 'package:rakwa/screens/contact_about_screens/create_contact_screen.dart';
import 'package:rakwa/screens/contact_about_screens/privacy_policy_screen.dart';
import 'package:rakwa/screens/main_screens/btm_nav_screens/More/Widgets/card_more_screen.dart';
import 'package:rakwa/screens/main_screens/btm_nav_screens/More/Widgets/container_card_icon_title_arrow_widget.dart';
import 'package:rakwa/screens/main_screens/btm_nav_screens/More/Widgets/custom_more_screen_divider.dart';
import 'package:rakwa/screens/main_screens/btm_nav_screens/More/Widgets/user_info_widget.dart';
import 'package:rakwa/screens/main_screens/btm_nav_screens/artical_screen.dart';
import 'package:rakwa/screens/main_screens/btm_nav_screens/control_panel_screen.dart';
import 'package:rakwa/screens/menu/menu_screen.dart';
import 'package:rakwa/screens/messages_screen/messages_screen.dart';
import 'package:rakwa/screens/my_items_classifieds_screens/my_classifieds_screen.dart';
import 'package:rakwa/screens/my_items_classifieds_screens/my_item_screen.dart';
import 'package:rakwa/screens/notifications/notifications_screen.dart';
import 'package:rakwa/screens/order/all_orders_screen.dart';
import 'package:rakwa/screens/order/payment_screen.dart';
import 'package:rakwa/screens/order/vendor/all_orders_vendor_screen.dart';
import 'package:rakwa/screens/question_and_answer/question_and_answer_screen.dart';
import 'package:rakwa/screens/save_screen/save_screen.dart';
import 'package:rakwa/shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controller/all_orders_getx_controller.dart';
import '../../../controller/email_verified_getx_controller.dart';
import '../../../controller/home_getx_controller.dart';
import '../../time_prayer/timer_prayer_screen.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> with Helpers {

  @override
  Widget build(BuildContext context) {

    return GetX<UserProfileGetxController>(
      builder: (c) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: c.profile.isEmpty ? Padding(
            padding: EdgeInsets.symmetric(vertical: 50.h,horizontal: 20.w),
              child: Column(
                children: [
                  Text("حدث خطأ غير متوقع يرجى اعادة المحاولة",style: GoogleFonts.notoKufiArabic(
                    textStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),)),
                  IconButton(onPressed: (){
                    // HomeGetxController.to.getNestedItems();
                    // HomeGetxController.to.getPaidItems();
                    // HomeGetxController.to.getPopularItems();
                    // HomeGetxController.to.getLatestItems();
                    // HomeGetxController.to.getPopularClassified();
                    // HomeGetxController.to.getArticales();
                    // HomeGetxController.to.getActivities();
                   c.readUserProfile();
                    HomeGetxController.to.getConfig();
                    // AppInterfaceGetx.to.getRemoteConfig();

                  }, icon: Icon(Icons.refresh))
                ],
              )):Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                 SizedBox(height: 10.h),
                const UserInfoWidget(),
                 SizedBox(height: 24.h),
                ContainerCardIconTitleArrowWidget(
                  widget: Column(
                    children: [
                      // CardMoreScreen(
                      //   onTap: () {
                      //     Get.to(() => const MenuScreen());
                      //   },
                      //   title: "المنيو",
                      //   icon: "MActivty",
                      // ),
                      CardMoreScreen(
                        onTap: () {
                          Get.to(() => const CartScreen());
                        },
                        title: "السلة",
                        icon: "cart-new",
                      ),
                      CardMoreScreen(
                        onTap: () {
                          Get.to(() => const AllAddressScreen());
                        },
                        title: "العناوين",
                        icon: "address-new",
                      ),
                      CardMoreScreen(
                        onTap: () {
                          Get.to(() => const AllOrdersScreen());
                        },
                        title: "طلباتي",
                        icon: "my-orders",
                      ),
                      Visibility(

                        visible: UserProfileGetxController.to.profile.first.data!.vendor_id != null,
                        child: CardMoreScreen(
                          onTap: () {
                            Get.to(() => const AllOrdersVendorScreen());
                          },
                          title: "الطلبات الواردة",
                          icon: "orders-recevied",
                        ),
                      ),
                      CardMoreScreen(
                        onTap: () {
                          Get.to(() => const ArticalScreen());
                        },
                        title: "المقالات",
                        icon: "articals",
                      ),

                      CardMoreScreen(
                        onTap: () {
                          Get.to(() => const ControlPanelScreen());
                        },
                        title: "الأنشطة",
                        icon: "activites",
                      ),
                      const CustomMoreScreenDivider(),
                      CardMoreScreen(
                        onTap: () {
                          Get.to(() => const SaveScreen());
                        },
                        title: "العناصر المحفوظة",
                        icon: "my-save",
                      ),
                      const CustomMoreScreenDivider(),
                      CardMoreScreen(
                        onTap: () {
                          Get.to(() => const NotificationsScreen());
                        },
                        title: "الاشعارات",
                        icon: "notifications-new",
                      ),
                      const CustomMoreScreenDivider(),
                      CardMoreScreen(
                        onTap: () {
                          Get.to(() => const MyItemScreen());
                        },
                        title: "مشاريعي",
                        icon: "projects",
                      ),
                      const CustomMoreScreenDivider(),
                      CardMoreScreen(
                        onTap: () {
                          Get.to(() => const MyClassifiedScreen());
                        },
                        title: "اعلاناتي",
                        icon: "ads-new",
                      ),
                      const CustomMoreScreenDivider(),
                      CardMoreScreen(
                        onTap: () {
                          Get.to(() => const MessagesScreen());
                        },
                        title: "الرسائل",
                        icon: "message-new",
                      ),
                      const CustomMoreScreenDivider(),
                      CardMoreScreen(
                        onTap: () {
                          Get.to(() => const QuestionAndAnswerScreen());
                        },
                        title: "سؤال وجواب",
                        icon: "q-a",
                      ),
                      const CustomMoreScreenDivider(),
                      CardMoreScreen(
                        onTap: () {
                          Get.to(() => const TimerPrayerScreen());
                        },
                        title: "أوقات الصلاة",
                        icon: "mosque-new",
                      ),
                      const CustomMoreScreenDivider(),
                      CardMoreScreen(
                        onTap: () {
                          Get.to(() => const CreateContactScreen());
                        },
                        title: "تواصل معنا",
                        icon: "contact-us-new",
                      ),
                      const CustomMoreScreenDivider(),
                      CardMoreScreen(
                        onTap: () async {
                          if (SharedPrefController().isLogined) {
                            bool status = await AuthApiController().logout();
                          } else {
                            Get.offAllNamed('/sign_in_screen');
                          }
                        },
                        title: SharedPrefController().isLogined
                            ? "تسجيل الخروج"
                            : "تسجيل الدخول",
                        icon: "sign-out",
                      ),
                    ],
                  ),
                ),

                 SizedBox(height: 24.h),
                ContainerCardIconTitleArrowWidget(
                  widget: Column(
                    children: [
                      CardMoreScreen(
                        onTap: () {
                          chickIsRoleidAndNavigation(
                            navigateTo: () {
                              Get.to(() => AddListCategoryScreen());
                            },
                          );
                        },
                        title: "اضف عملك",
                        icon: "add-work",
                      ),
                      const CustomMoreScreenDivider(),
                      CardMoreScreen(
                        onTap: () {
                          chickIsRoleidAndNavigation(navigateTo: () {
                            Get.to(() =>  AddListClassifiedCategoryScreen());
                          });
                        },
                        title: "اضف اعلان",
                        icon: "add-ad",
                      ),
                      CardMoreScreen(
                        onTap: () {
                          chickIsRoleidAndNavigation(navigateTo: () {
                            Get.to(() =>  AddAdScreen());
                          });
                        },
                        title: "اضف اعلان",
                        icon: "add-ad",
                      ),
                      CardMoreScreen(
                        onTap: () {
                          chickIsRoleidAndNavigation(navigateTo: () {
                            Get.to(() =>  UserAdsScreen());
                          });
                        },
                        title: "اعلاناتي",
                        icon: "add-ad",
                      ),
                      const CustomMoreScreenDivider(),
                      CardMoreScreen(
                        onTap: () {
                          Get.to(() => const AboutScreen());
                        },
                        title: "من نحن",
                        icon: "who-us",
                      ),
                      const CustomMoreScreenDivider(),
                      CardMoreScreen(
                        onTap: () {
                          Get.to(() => const PrivacyPolicyScreen());
                        },
                        title: "سياسة الخصوصية",
                        icon: "privacy-new",
                      ),
                      const CustomMoreScreenDivider(),
                      CardMoreScreen(
                        onTap: () {
                          Get.to(() => const AllLastActivtiesScreen());
                        },
                        title: "أخر الأنشطة",
                        icon: "last-activites",
                      ),
                      const CustomMoreScreenDivider(),
                      CardMoreScreen(
                        onTap: () {
                          Get.to(() => const ContactScreen());
                        },
                        title: "الدعم",
                        icon: "support-new",
                      ),
                      const CustomMoreScreenDivider(),

                      CardMoreScreen(
                        onTap: () {
                          if(Platform.isAndroid){
                            launchUrl(Uri.parse("https://play.google.com/store/apps/details?id=rakwa.turkey.com"));
                          }else{
                            launchUrl(Uri.parse("https://apps.apple.com/il/app/%D8%B1%D9%83%D9%88%D8%A9/id1660636889"));
                          }
                          // Get.to(() => const ContactScreen());
                        },
                        title: "قيمنا",
                        icon: "rate-us",
                      ),
                      const CustomMoreScreenDivider(),

                      CardMoreScreen(
                        onTap: () async{
                          var url = Uri.parse('https://wa.me/message/USXSIMWMUFBOJ1');
                          if (await canLaunchUrl(url)) {
                          launchUrl(url,mode:LaunchMode.externalApplication);
                          }
                        },
                        title: "دعم فني مباشر",
                        icon: "support-tech",
                      ),
                      if (SharedPrefController().isLogined) ...[
                        const CustomMoreScreenDivider(),
                        CardMoreScreen(
                          onTap: () async {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                  title: const Text('هل انت متاكد؟'),
                                  content: const Text(
                                      'سيتم حذف حسابك بشكل نهائي هل انت متاكد ؟'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: Text('الغاء',
                                          style: GoogleFonts.notoKufiArabic(
                                              textStyle: const TextStyle(
                                                  color: AppColors.labelColor))),
                                    ),
                                    ElevatedButton(
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12.r))),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.red.shade700),
                                        ),
                                        onPressed: () async {
                                          if (SharedPrefController().isLogined) {
                                            await AuthApiController()
                                                .deleteAccount();
                                          }
                                        },
                                        child: Text('نعم',
                                            style: GoogleFonts.notoKufiArabic())),
                                  ]),
                            );
                          },
                          title: "حذف حسابك",
                          icon: "delete-account",
                        ),
                      ]
                    ],
                  ),
                ),

                // const Divider(),
                // ListTile(
                //   onTap: () {},
                //   leading: const Icon(Icons.settings),
                //   title: Text(
                //     'الضبط',
                //     style: GoogleFonts.notoKufiArabic(
                //         textStyle: const TextStyle(
                //       color: Colors.black,
                //       fontSize: 12,
                //       fontWeight: FontWeight.w400,
                //     )),
                //   ),
                // ),
                 SizedBox(
                  height: 24.h,
                )
              ],
            ),
          ),
        );
      }
    );
  }

  void chickIsRoleidAndNavigation({required Function navigateTo}) {
    if (SharedPrefController().roleId == 3) {
      if (SharedPrefController().verifiedEmail != 'null') {
        navigateTo();
      } else {
        ShowMySnakbar(
            title: 'لم تقم بتاكيد حسابك',
            message: 'يجب عليك تاكيد حسابك قبل',
            backgroundColor: Colors.red.shade700);
      }
    } else if (SharedPrefController().roleId == 2) {
      alertDialogRoleAuthUser(context);
    } else {
      AlertDialogUnAuthUser(context);
    }
  }
}
