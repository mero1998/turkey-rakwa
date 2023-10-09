import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:cupertino_back_gesture/cupertino_back_gesture.dart';
import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:rakwa/Core/utils/dynamic_link_service.dart';
import 'package:rakwa/app_colors/app_colors.dart';
import 'package:rakwa/controller/app_interface_getx_controller.dart';
import 'package:rakwa/controller/fb_notifications_controller.dart';
import 'package:rakwa/controller/home_getx_controller.dart';
import 'package:rakwa/model/cart.dart';
import 'package:rakwa/screens/Auth/screens/forget_password_screen.dart';
import 'package:rakwa/screens/Auth/screens/sign_in_screen.dart';
import 'package:rakwa/screens/add_listing_screens/add_list_menu_screen.dart';
import 'package:rakwa/screens/cart/cart_screen.dart';
import 'package:rakwa/screens/details_screen/details_classified_screen.dart';
import 'package:rakwa/screens/details_screen/details_screen.dart';
import 'package:rakwa/screens/launch_screen/launch_screen.dart';
import 'package:rakwa/screens/main_screens/main_screen.dart';
import 'package:rakwa/screens/menu/menu_screen.dart';
import 'package:rakwa/screens/menu/rating_screen.dart';
import 'package:rakwa/screens/menu/food_details_screen.dart';
import 'package:rakwa/screens/order/all_orders_screen.dart';
import 'package:rakwa/screens/order/create_order_screen.dart';
import 'package:rakwa/screens/order/payment_screen.dart';
import 'package:rakwa/screens/order/send_order_whatsapp_screen.dart';
import 'package:rakwa/shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';

import 'Core/utils/extensions.dart';
import 'Core/utils/notification_helper.dart';
import 'localiztion_service.dart';
enum Availability { loading, available, unavailable }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();
  // await Upgrader.clearSavedSettings(); // REMOVE this for release builds
  Stripe.publishableKey = "pk_live_51N8XouL67JT38PhC4tslfWgz0OOsdDH7E1AEtV1w40AyJXTpwDGFyAb1W22ogFuJHCQjmgxKMKL52aI2tjRQznO6000Vsja52f";
  // Stripe.publishableKey = "pk_test_51MyGdi2jXjU2QVGMuzQ0Sc56oM70uGtQApUisS52p73QMlNwYt4wCtmNAUiwZ4Jhc6cwaVT9TjxUAMFnJOKo7GGg00riEWjsiI";

  if (Platform.isAndroid) {
    await Firebase.initializeApp();
  } else if (Platform.isIOS) {
    await Firebase.initializeApp();
  }

  // await FBNotificationsController.initNotifications();
  // NotificationHelper().initNotification(context: cont);
  await GetStorage.init();
  NotificationHelper().initNotification();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  await SharedPrefController().initPreferences();
  runApp(
       EasyLocalization(
            fallbackLocale: Locale('ar', "AE"),
            supportedLocales: [Locale('ar',"AE")],
            path: 'lang',
            child: const MyApp()),
    // DevicePreview(
    //   enabled: !kReleaseMode,
    //   builder: (context) => const MyApp(), // Wrap your app
    // ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {


  late Timer _timerLink;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.put(AppInterfaceGetx());
    Get.put(HomeGetxController());



    WidgetsBinding.instance.addObserver(this);

    DynamicLink().retrieveDynamicLink();
    // DynamicLink.initDynamicLinkIOS();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    print("State::: $state");
    if (state == AppLifecycleState.resumed) {
      _timerLink = new Timer(const Duration(milliseconds: 1000), () async {

        DynamicLink().retrieveDynamicLink();
        // DynamicLink.initDynamicLinkIOS();
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return GetMaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          debugShowCheckedModeBanner: false,
          // locale: LocalizationService.locale,
          // fallbackLocale: LocalizationService.fallbackLocale,
          // smartManagement: SmartManagement.onlyBuilder,//here

          // translations: LocalizationService(),
          theme: SharedPrefController().roleId == 2
              ? ThemeData(

              pageTransitionsTheme: PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: ZoomPageTransitionsBuilder(),
                  TargetPlatform.iOS: CupertinoWillPopScopePageTransionsBuilder(),
                },
              ),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  timePickerTheme:  TimePickerThemeData(
                    // dialHandColor: AppColors().mainColor,
                  ),
                  appBarTheme: const AppBarTheme(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      iconTheme: IconThemeData(color: Colors.black)))
              : ThemeData(


              pageTransitionsTheme: PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: ZoomPageTransitionsBuilder(),
                  TargetPlatform.iOS: CupertinoWillPopScopePageTransionsBuilder(),
                },
              ),
                  timePickerTheme:  TimePickerThemeData(
                    // dialHandColor: AppColors().mainColor,
                  ),
                  appBarTheme: const AppBarTheme(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      iconTheme: IconThemeData(color: Colors.black))),
          initialRoute: '/',
          // home: AddListMenuScreen(isList: true,),
          // home: DetailsScreen(id: 1476),
          getPages: [
            GetPage(name: '/', page: () => const LaunchScreen()),
            GetPage(name: '/sign_in_screen', page: () =>  SignInScreen()),
            GetPage(name: '/main_screen', page: () => const MainScreen()),
            GetPage(
                name: '/forget_password_screen',
                page: () =>  ForgetPasswordScreen()),
          ],
        );
      },
    );
  }
}

// new packge name
// com.app.rakwa

// iOS bundle identifier
// com.example.rakwa

// SHA1
// 5B:BC:F1:25:3D:EB:10:5D:C3:9B:14:50:1D:3D:B9:6D:B0:98:54:1C

// android packge
// com.example.rakwa

// list and classified images url
//https://www.rakwa.com/laravel_project/public/storage/item/
//https://www.rakwa.com/laravel_project/public/storage/item/gallery/

// list and calssified category images url
//https://www.rakwa.com/laravel_project/public/storage/category/

// if list and classified has no images url
//https://rakwa.com/theme_assets/frontend_assets/lduruo10_dh_frontend_city_path/placeholder/

// user images url
// https://www.rakwa.com/laravel_project/public/storage/user/

// sign in uer hnynwydt@gmail.com password 12345678
