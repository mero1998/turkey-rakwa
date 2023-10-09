import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rakwa/Core/utils/extensions.dart';
import 'package:rakwa/api/api_controllers/classified_api_controller.dart';
import 'package:rakwa/api/api_controllers/item_api_controller.dart';
import 'package:rakwa/api/api_controllers/list_api_controller.dart';
import 'package:rakwa/api/api_controllers/notification_api_controller.dart';
import 'package:rakwa/model/all_categories_model.dart';
import 'package:rakwa/model/classified_with_category.dart';
import 'package:rakwa/model/item_with_category.dart';
import 'package:rakwa/model/notifications.dart';

import '../api/api_controllers/notifications_api_controller.dart';

class NotificationsGetXController extends GetxController {

  RxBool isLoading = true.obs;
  RxList<Notifications> notification = <Notifications>[].obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getNotifications();
  }



  void getNotifications()async{
    isLoading.value = true;
   Notifications? notifications = await NotificationsApiController().getNotifications();

   if(notifications != null){
     notification.add(notifications);

     // notification.reversed.toList();
     print(notification.first.notification!.length);
     isLoading.value = false;

   }else{
     notification.value = [];
     isLoading.value = false;

   }
    isLoading.value = false;

  }
}
