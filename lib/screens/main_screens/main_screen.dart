import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rakwa/api/api_controllers/auth_api_controller.dart';
import 'package:rakwa/app_colors/app_colors.dart';
import 'package:rakwa/controller/all_address_getx_controller.dart';
import 'package:rakwa/controller/all_cart_getx_controller.dart';
import 'package:rakwa/controller/all_menu_getx_controller.dart';
import 'package:rakwa/controller/app_interface_getx_controller.dart';
import 'package:rakwa/controller/fb_notifications_controller.dart';
import 'package:rakwa/controller/home_getx_controller.dart';
import 'package:rakwa/model/register_model.dart';
import 'package:rakwa/screens/add_listing_screens/add_list_category_screen.dart';
import 'package:rakwa/screens/main_screens/btm_nav_screens/Home/Screens/home_screen.dart';
import 'package:rakwa/screens/main_screens/btm_nav_screens/Ads/Screens/ads_screen.dart';
import 'package:rakwa/screens/main_screens/btm_nav_screens/Home/Screens/order_now_categories.dart';
import 'package:rakwa/screens/main_screens/btm_nav_screens/artical_screen.dart';
import 'package:rakwa/screens/main_screens/btm_nav_screens/more_screen.dart';
import 'package:rakwa/screens/order/all_orders_screen.dart';
import 'package:rakwa/shared_preferences/shared_preferences.dart';
import 'package:rakwa/Core/utils/helpers.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Core/services/geolocation_services.dart';
import '../../Core/utils/dynamic_link_service.dart';
import '../../Core/utils/extensions.dart';
import '../../api/api_controllers/home_api_controller.dart';
import '../../api/api_controllers/order_api_controller.dart';
import '../../controller/all_orders_getx_controller.dart';
import '../../controller/email_verified_getx_controller.dart';
import '../../main.dart';
import '../../widget/SVG_Widget/svg_widget.dart';
import '../../widget/app_dialog.dart';
import '../view_all_item_screens/view_all_res_screen.dart';

late StreamSubscription<ConnectivityResult> connectivitySubscription;
final Connectivity _connectivity = Connectivity();
ConnectivityResult connectionStatus = ConnectivityResult.none;
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with Helpers , WidgetsBindingObserver {
  int selected = 0;
  late Timer _timerLink;
  Availability _availability = Availability.loading;
  final InAppReview _inAppReview = InAppReview.instance;
  Timer? _timer;
  Timer? _timer2;
  int _start = 300;
  int _start2 = 28800;
  final List _screens = const [
    HomeScreen(),
    AllOrdersScreen(),
    ArticalScreen(),
    AdsScreen(),
    MoreScreen(),
    // MoreScreen(),
  ];


  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();

            _requestReview();

          });
        } else {
          // setState(() {
            _start--;
          // });

        }
      },
    );
  }
  void startTimer2() {
    const oneSec = const Duration(seconds: 1);
    _timer2 = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start2 == 0) {
          // setState(() {
            timer.cancel();
            if(SharedPrefController().isLogined){
              OrderApiController().checkVerifiyPhone(context);
            }
            // AppDialog.confirmPhone(context);

            // _requestReview();

          // });
        } else {
          // setState(() {
            _start2--;
          // });

        }
      },
    );
  }
  final box = GetStorage();


  @override
  void initState() {
    super.initState();
    Get.put(HomeGetxController());
    Get.put(UserProfileGetxController());

    Get.put(AllOrdersGetxController());
    Get.put(AllMenusGetxController());
    Get.put(AllCartsGetxController());
    Get.put(AllAddressGetxController());




    // print("password::: ${registerModel.password}");
    initConnectivity();
    //
    WidgetsBinding.instance.addObserver(this);

    connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    // WidgetsBinding.instance.addObserver(this);

    (<T>(T? o) => o!)(WidgetsBinding.instance).addPostFrameCallback((_) async {

      Future.delayed(Duration.zero,()async{

        PackageInfo packageInfo = await PackageInfo.fromPlatform();

        String appName = packageInfo.appName;
        String packageName = packageInfo.packageName;
        String version = packageInfo.version;
        String buildNumber = packageInfo.buildNumber;


        print("app: ${appName}");
        print(version);
        print(buildNumber);

        if(AppInterfaceGetx.to.forceUpdate.value){
          if(Platform.isIOS){
            print("Version:: ${AppInterfaceGetx.to.version}");
            print(version);
            if(AppInterfaceGetx.to.version.value.isNotEmpty){
              if(version != AppInterfaceGetx.to.version.value){
                AppDialog.showCupertinoDialog(context: context, builder: (BuildContext context) {
                  return CupertinoAlertDialog(
                    title:  Text('تحديث جديد متوفر',style: GoogleFonts.notoKufiArabic(
                        textStyle:  TextStyle(color: Colors.black, fontSize: 13.sp,height: 1.5))),
                    content:  Text(AppInterfaceGetx.to.messageUpdate.value,style: GoogleFonts.notoKufiArabic(
                        textStyle:  TextStyle(color: Colors.black, fontSize: 10.sp,height: 1.6)),),
                    actions: <Widget>[
                      CupertinoDialogAction(
                        onPressed: () {
                          // Navigator.pop(context);
                          launchUrl(Uri.parse("https://apps.apple.com/il/app/%D8%B1%D9%83%D9%88%D8%A9/id1660636889"),mode: LaunchMode.externalApplication);

                        },
                        child:  Text('التحديث الآن',style: GoogleFonts.notoKufiArabic(
                            textStyle:  TextStyle(color: Colors.blueAccent, fontSize: 10.sp)),
                        ),
                        // CupertinoDialogAction(
                        //   onPressed: () {
                        //     Navigator.pop(context);
                        //   },
                        //   child: const Text('No'),
                        // ),
                      )],
                  );
                });

              }

            }
          }else if(Platform.isAndroid){
            if(AppInterfaceGetx.to.version.isNotEmpty){
              if(version != AppInterfaceGetx.to.version.value){
                AppDialog.newUpdateAndroid(context);
              }
            }
        }


        }


          await AuthApiController().getNewToken();

        if(SharedPrefController().isLogined) {
          startTimer2();

        }
        if(HomeGetxController.to.configs.isNotEmpty){
          if(HomeGetxController.to.configs.first.data!.application_review == "yes"){
            startTimer();
          }

          RegisterModel registerModel = RegisterModel();
          registerModel.name = SharedPrefController().name;
          registerModel.password = box.read("password");
          registerModel.email =  SharedPrefController().email;
          registerModel.phone =  SharedPrefController().phone;

          if(SharedPrefController().isLogined){
            await AuthApiController().registerToNewSite(
                registerModel: registerModel,
                roleId: SharedPrefController().roleId);
          }

        }

        try {
          final isAvailable = await _inAppReview.isAvailable();

          print("IS Available:: ${isAvailable}");
          setState(() {
            // This plugin cannot be tested on Android by installing your app
            // locally. See https://github.com/britannio/in_app_review#testing for
            // more information.
            _availability = isAvailable && !Platform.isAndroid
                ? Availability.available
                : Availability.unavailable;



            // _openStoreListing();
          });
        } catch (_) {
          setState(() => _availability = Availability.unavailable);
        }
      });
    });


  }


  Future<void> _requestReview() => _inAppReview.requestReview();

  Future<void> _openStoreListing() => _inAppReview.openStoreListing(
    appStoreId: "1660636889",

  );
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // print("State::: $state");
    // if (state == AppLifecycleState.resumed) {
    //   _timerLink = new Timer(const Duration(milliseconds: 1000), () {
    //     DynamicLink().retrieveDynamicLink();
    //     // DynamicLink.initDynamicLinkIOS();
    //   });
    // }
    // if(HomeGetxController.to.configs.isNotEmpty){
    //   if(HomeGetxController.to.configs.first.data!.application_review == "yes"){
    //     if (_start == 0) {
    //       // setState(() {
    //       //   timer.cancel();
    //
    //         _requestReview();
    //
    //       // });
    //     }
    //   }
    // }
  //
  //
    print("State212323$state");
      Future.delayed(Duration.zero,()async{
        // if(await Permission.location.serviceStatus.isEnabled) {
        Future.delayed(Duration.zero,()async{
          bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

          print(serviceEnabled);
          if(serviceEnabled){
            print("location is enabled");
          }
          else{
            print("location is not enabled");
// getLocation();
            if(Platform.isIOS){
              AppDialog.openSittingIOS(context);
            }
          }
        });

        // _savePosition();
        // }
      });


  }

  @override
  void dispose() {
    // WidgetsBinding.instance.removeObserver(this);
    // if (_timerLink != null) {
    //   _timerLink.cancel();
    // }


    super.dispose();

  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();

      print("Result::: ${result}");
    } on PlatformException catch (e) {
      // developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      connectionStatus = result;

      print("From Lessn::: ${result}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 5),
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        height: 55.0.h,
        width: 55.0.w,
        child: FloatingActionButton(
            onPressed: () async{
              // if (SharedPrefController().roleId == 3) {
              //   if (SharedPrefController().verifiedEmail != 'null') {
              //     Get.to(() =>  AddListCategoryScreen());
              //   } else {
              //     ShowMySnakbar(
              //         title: 'لم تقم بتاكيد حسابك',
              //         message: 'يجب عليك تاكيد حسابك قبل',
              //         backgroundColor: Colors.red.shade700);
              //   }
              // } else if (SharedPrefController().roleId == 2) {
              //   alertDialogRoleAuthUser(context);
              // } else {
              //   AlertDialogUnAuthUser(context);
              // }

              // try{
                // launchUrl(Uri.parse("https://wa.me/message/USXSIMWMUFBOJ1"));

              // }catch(e){
              //   print("Error::: ${e}");
              // }
              // Future<void> _launchUrl() async {
              Get.to(() => const ViewAllResScreen());

              // var url = Uri.parse('https://wa.me/message/USXSIMWMUFBOJ1');
              // if (await canLaunchUrl(url)) {
              //   launchUrl(url,mode:LaunchMode.externalApplication);
              // }
              // if (!await launchUrl(Uri.parse("https://wa.me/message/USXSIMWMUFBOJ1"))) {
              //
              //     throw Exception('Could not launch');
              //   // }
              // }
              // if (SharedPrefController().isLogined &&
              //     SharedPrefController().roleId == 3) {
              //   if (SharedPrefController().verifiedEmail != null) {
              //     Get.to(() => const AddListCategoryScreen());
              //   } else {
              //     ShowMySnakbar(
              //         title: 'لم تقم بتاكيد حسابك',
              //         message: 'يجب عليك تاكيد حسابك قبل',
              //         backgroundColor: Colors.red.shade700);
              //   }
              // } else if (SharedPrefController().isLogined &&
              //     SharedPrefController().roleId == 2) {
              // } else {
              //   AlertDialogUnAuthUser(context);
              // }
            },
            backgroundColor: AppColors().mainColor,
            // child: IconSvg(
            //   "scooter",
            //   size: 28,
            //   color: Colors.white,
            // )
          child: SvgPicture.asset(
            'images/scooter.svg',
            color: Colors.white,
            width: 28.w,
            height: 28.w,
            // color: color == null ? AppColors().mainColor : color,

            // matchTextDirection: true,
          ),
        ),
      ),
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
            currentIndex: selected,
            onTap: (value) async{
              if (value != 2) {
                if (value ==  4&& SharedPrefController().token.isEmpty) {
                  AlertDialogUnAuthUser(context);
                } else {
                  setState(() {
                    selected = value;
                  });
                  if(value == 1){
                    setState(() {
                      selected = 0;
                    });
                    var url = Uri.parse('https://wa.me/message/USXSIMWMUFBOJ1');
                    if (await canLaunchUrl(url)) {
              launchUrl(url,mode:LaunchMode.externalApplication);
              }
                  }

                }
              } else {}
            },
            selectedItemColor: AppColors().mainColor,
            selectedLabelStyle: GoogleFonts.notoKufiArabic(
                textStyle:  TextStyle(color: Colors.black, fontSize: 10.sp)),
            unselectedIconTheme: const IconThemeData(
              color: Colors.grey,
            ),
            unselectedLabelStyle: GoogleFonts.notoKufiArabic(
                textStyle:  TextStyle(color: Colors.grey, fontSize: 10.sp)),
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            unselectedItemColor: Colors.black,
            items:  [
              BottomNavigationBarItem(
                  // icon: Icon(Icons.home_outlined,size: 16.w,),
                  // activeIcon: Icon(Icons.home,size: 16.w,),
                icon: IconSvg(
                  "home-new-2",
                  size: 16,
                  // color: Colors.grey.shade600,
                ),
                  label: 'الرئيسية',),
              BottomNavigationBarItem(
                  // icon: Icon(Icons.auto_awesome_mosaic_outlined),
                  // activeIcon: Icon(Icons.auto_awesome_mosaic),
                  icon: IconSvg(
                    "whatsapp",
                    size: 16,
                    // color: Colors.grey.shade600,
                  ),
                  // activeIcon: Icon(Icons.article_rounded,size: 16.w,),
                  label: 'تواصل مباشر'),
              BottomNavigationBarItem(
                  // icon: Icon(Icons.home, color: Colors.transparent,size: 16.w,),
                 icon: IconSvg(
                   "order-now-new",
                   size: 16,
                   // color: Colors.grey.shade600,
                 ),
                  label: 'اطلب الآن'),
              // BottomNavigationBarItem(
              //     icon: Icon(Icons.home, color: Colors.transparent,size: 16.w,),
              //     label: 'تواصل مباشر'),
              BottomNavigationBarItem(
                  // icon: Icon(Icons.class_, size: 16.w,),
                icon: IconSvg(
                  "ads-home",
                  size: 16,
                  // color: Colors.grey.shade600,
                ),
                  // activeIcon: Icon(Icons.class_,size: 16.w,),
                  label: 'إعلانات مبوبة'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.menu,size: 16.w,),
                  // activeIcon: Icon(Icons.menu,size: 16.w,),
              // icon:    IconSvg(
              //       "more-home",
              //       size: 16,
              //       // color: Colors.grey.shade600,
              //     ),
                  label: 'المزيد'),
            ]),
      ),
      // drawer: MyDrawer(
      //   selected: selected,
      //   homeOnTap: () {
      //     setState(() {
      //       selected = 0;
      //     });
      //     Get.back();
      //   },
      //   adsOnTap: () {
      //     if (SharedPrefController().isLogined) {
      //       setState(() {
      //         selected = 3;
      //       });
      //       Get.back();
      //     } else {
      //       AlertDialogUnAuthUser(context);
      //     }
      //   },
      //   panelOnTap: () {
      //     if (SharedPrefController().isLogined) {
      //       setState(() {
      //         selected = 1;
      //       });
      //       Get.back();
      //     } else {
      //       AlertDialogUnAuthUser(context);
      //     }
      //   },
      //   personalOnTap: () {
      //     if (SharedPrefController().isLogined) {
      //       setState(() {
      //         selected = 4;
      //       });
      //       Get.back();
      //     } else {
      //       AlertDialogUnAuthUser(context);
      //     }
      //   },
      //   contactWithUs: () {},
      //   verifiedEmail: () async {
      //     bool status = await AuthApiController().emailVerification();
      //     if (status) {
      //       Get.snackbar('تمت العملية بنجاح', 'تم تاكيد حسابك',
      //           backgroundColor: Colors.green.shade700);
      //     } else {
      //       Get.snackbar('خطأ', 'حدث خطأ ما',
      //           backgroundColor: Colors.red.shade700);
      //     }
      //     Get.back();
      //   },
      // logout: () async {
      //   if (SharedPrefController().isLogined) {
      //     bool status = await AuthApiController().logout();
      //     if (status) {
      //       Get.offAllNamed('/sign_in_screen');
      //     }
      //   } else {
      //     Get.offAllNamed('/sign_in_screen');
      //   }
      // },
      //   myList: () {
      //     if (SharedPrefController().isLogined) {
      //     } else {
      //       AlertDialogUnAuthUser(context);
      //     }
      //   },
      //   rating: () {
      //     if (SharedPrefController().isLogined) {
      //     } else {
      //       AlertDialogUnAuthUser(context);
      //     }
      //   },
      //   saved: () {
      //     if (SharedPrefController().isLogined) {
      //       Get.to(() => const SaveScreen());
      //     } else {
      //       AlertDialogUnAuthUser(context);
      //     }
      //   },
      // ),
      // appBar: selected != 4
      //     ? AppBar(
      //         backgroundColor: Colors.transparent,
      //         elevation: 0,
      //         centerTitle: true,
      //         title: Image.asset(
      //           'images/logo.jpg',
      //           height: 42,
      //           width: 42,
      //         ),
      //         leadingWidth: 45,
      //         leading: Builder(
      //           builder: (context) {
      //             return InkWell(
      //               onTap: () => Scaffold.of(context).openDrawer(),
      //               child: SharedPrefController().image.isNotEmpty
      //                   ? CircleAvatar(
      //                       radius: 30,
      //                       backgroundColor:
      //                           AppColors.labelColor.withOpacity(0.4),
      //                       backgroundImage: NetworkImage(
      //                           'https://www.rakwa.com/laravel_project/public/storage/user/${SharedPrefController().image}'),
      //                     )
      //                   : const CircleAvatar(
      //                       radius: 30,
      //                       backgroundColor: Colors.transparent,
      //                       backgroundImage:
      //                           AssetImage('images/profile_image.png'),
      //                     ),
      //             );
      //           },
      //         ),
      //       )
      //     : null,
      body: connectionStatus == ConnectivityResult.none ? Container(child:
      Center(child:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'images/no-internet.svg',
                width: 150.w,
                height: 150.h,
                color: AppColors().mainColor,
                fit: BoxFit.fill,
                // matchTextDirection: true,
              ),
              SizedBox(height: 15.h,),
              Text("لا يوجد انترنت",  style: GoogleFonts.notoKufiArabic(
                textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ))),
            ],
          ),
      ),) :_screens.elementAt(selected),
    );
  }

  sendNotification() async {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAAzSpXY5w:APA91bHWeBH9-v9HNRX5pfPDAsmuJIcrM5U1OP3y6Za1hOlexvlrdQrrjOjudWEEkqXHsSvzXsNItByQQR_UxvM6m2kZZuXh0xo0QNPj6Ct4ZAfFFFwmoOFM1vW_5WMRJ1UGIs0efpmC',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': 'body',
            'title': 'name send you a message'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': 'token',
        },
      ),
    );
  }
}
