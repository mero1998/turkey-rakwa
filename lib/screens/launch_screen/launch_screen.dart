import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rakwa/Core/services/geolocation_services.dart';
import 'package:rakwa/Core/utils/extensions.dart';
import 'package:rakwa/app_colors/app_colors.dart';
import 'package:rakwa/screens/Auth/Screens/sign_in_screen.dart';
import 'package:rakwa/screens/Auth/Screens/user_role_screen.dart';
import 'package:rakwa/screens/main_screens/main_user_screen.dart';
import 'package:rakwa/shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';

import '../../widget/main_elevated_button.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  void launchFuncation() {
    Future.delayed(
      const Duration(seconds: 3),
      () async{
        printDM("token in splashScreen is ${SharedPrefController().token}");

        _savePosition().then(
              (value) {
            _navigation();
          },
        ).catchError((error){
          printDM("error in delayed in get lat ang is $error");
        });
        },

    );
  }

  Future<void> _savePosition() async {

    print("we are here");
    await getLocation().then((value) async {
      if(value != null){
        await SharedPrefController().savePosition(
          lat: value!.latitude,
          lng: value!.longitude,
        );
        printDM("lat in lunch is => ${SharedPrefController().lat}");
        printDM("lng in lunch is => ${SharedPrefController().lng}");
      }}).catchError((error) async{
      await Geolocator.requestPermission();
      await SharedPrefController().savePosition(
      lat: 0.0,
      lng: 0.0,
      );
      printDM("error in _savePosition is $error");
      printDM("lat in lunch is => ${SharedPrefController().lat}");
      });

  }

  void _navigation(){
    if (SharedPrefController().isLogined &&
        SharedPrefController().token.isNotEmpty) {
      // if (SharedPrefController().roleId == 3) {
      Get.offAllNamed('/main_screen');
      // } else {
      //   Get.offAll(() => const MainUserScreen());
      // }
    } else {
      Get.offAll(() => SignInScreen());
    }
  }

  @override
  void initState() {
    launchFuncation();
    super.initState();
    // Future.delayed(Duration.zero, ()async{
    //   PackageInfo packageInfo = await PackageInfo.fromPlatform();
    //
    //   String appName = packageInfo.appName;
    //   String packageName = packageInfo.packageName;
    //   String version = packageInfo.version;
    //   String buildNumber = packageInfo.buildNumber;
    //
    //
    //   print("Name ${appName}");
    //   print("Name ${packageName}");
    //   print("Name ${version}");
    //   print("Name ${buildNumber}");
    // });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Center(
            child: Image.asset('images/logo2.png'),
          ),
          const Spacer(),
          // Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 24),
          //     child: MainElevatedButton(
          //       onPressed: () {},
          //       borderRadius: 12,
          //       height: 56,
          //       width: Get.width,
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           Text(
          //             'ابدأ الان',
          //             style: GoogleFonts.notoKufiArabic(
          //                 textStyle: const TextStyle(
          //                     fontSize: 16, fontWeight: FontWeight.w500)),
          //           ),
          //           const SizedBox(
          //             width: 10,
          //           ),
          //           const Icon(Icons.arrow_forward)
          //         ],
          //       ),
          //     )),
          // const SizedBox(
          //   height: 26,
          // ),
        ],
      ),
    );
  }
}
