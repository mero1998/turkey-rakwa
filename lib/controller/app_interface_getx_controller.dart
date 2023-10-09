
import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rakwa/api/api_controllers/home_api_controller.dart';
import 'package:rakwa/api/api_controllers/list_api_controller.dart';
import 'package:rakwa/model/all_categories_model.dart';
import 'package:rakwa/model/all_saved_items_model.dart';
import 'package:rakwa/model/city_model.dart';
import 'package:rakwa/model/country_model.dart';
import 'package:rakwa/model/details_calssified_model.dart';
import 'package:rakwa/model/details_model.dart';
import 'package:rakwa/model/paid_items_model.dart';

import '../api/api_controllers/artical_api_controller.dart';
import '../api/api_controllers/classified_api_controller.dart';
import '../api/api_controllers/details_api_controller.dart';
import '../api/api_controllers/item_api_controller.dart';
import '../api/api_controllers/save_api_controller.dart';
import '../api/api_controllers/search_api_controller.dart';
import '../model/app_interface.dart';
import '../model/artical_model.dart';

class AppInterfaceGetx extends GetxController{
  static AppInterfaceGetx get to => Get.find();
  RxString mainColor = ''.obs;
  RxString version = ''.obs;
  RxString messageUpdate = ''.obs;
  RxBool forceUpdate = false.obs;


  @override
  void onInit() {
    Future.delayed(Duration.zero,() async{
     await getRemoteConfig();

    });

  }



  getRemoteConfig() async{
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(

      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(seconds: 1),
    ));

    await remoteConfig.fetchAndActivate();
    mainColor.value = remoteConfig.getString("main_color_app");
    if(Platform.isAndroid){
      version.value =  remoteConfig.getString("android_version");
    }else{
      version.value =  remoteConfig.getString("ios_version");
    }
    messageUpdate.value =  remoteConfig.getString("message_update");
    forceUpdate.value =  remoteConfig.getBool("force_update");

    print("Main Color :: ${mainColor}");
    print("Main Color :: ${version}");
  }
}
