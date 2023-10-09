import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:rakwa/api/api_controllers/notification_api_controller.dart';
import 'package:rakwa/screens/details_screen/details_classified_screen.dart';
import 'package:rakwa/screens/details_screen/details_screen.dart';
import 'package:rakwa/screens/main_screens/btm_nav_screens/Home/Screens/home_screen.dart';
import 'package:rakwa/screens/main_screens/main_screen.dart';
import 'package:rakwa/screens/order/all_orders_screen.dart';
import 'package:rakwa/shared_preferences/shared_preferences.dart';



class NotificationHelper {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  initNotification() async {


    print("we are here from init notif");
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    RemoteMessage? message = await messaging.getInitialMessage();
    if (message != null) {
      // Get.to(() => NotificationScreen());
    }
    getFcmToken();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      // print('Message data: ${message.data}');
      // print('Message data: ${message.data['tag']}');
      // print('Message data: ${message}');
      print('Message data: ${message.data}');
      print('Message title: ${message.notification!.title!}');
      print('Message body: ${message.notification!.body!}');
       localNotification(
        title: message.notification!.title!,
        body: message.notification!.body!,
        payload: json.encode(message.data),
      );
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
      if(message.data['tag'] == "عمل"){
        print("TAG::: ${message.data['id']}");

        Get.off(
            DetailsScreen(id:  message.data['id'],fromNotification: true,)
        );
        // Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsScreen(id: message.data['id'],)));

      }
    else  if(message.data['tag'] == "تم القبول" ||
          message.data['tag'] == "الطلب جاهز" ||
          message.data['tag'] == "تم الرفض" ||
          message.data['tag'] == "تم التوصيل"
      ){

        Get.off(
            AllOrdersScreen()
        );
      }
      else if(message.data['tag'] == "اعلان"){
        Get.off(
            DetailsClassifiedScreen(id: int.parse(message.data['id']),fromNotification: true,)
        );
        // Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsClassifiedScreen(id: message.data['id'],)));

      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('onMessageOpenedApp data: ${message.data}');
      // Get.to(() => NotificationScreen());
      if(message.data['tag'] == "عمل"){
        print("TAG::: ${message.data['id']}");

        Get.off(
          DetailsScreen(id:  message.data['id'], fromNotification: true,)
        );

        // Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsScreen(id: message.data['id'],)));

      }
      else if(message.data['tag'] == "تم القبول" ||
          message.data['tag'] == "الطلب جاهز" ||
          message.data['tag'] == "تم الرفض" ||
          message.data['tag'] == "تم التوصيل"
      ){

        Get.off(
            AllOrdersScreen()
        );
      }
      else if(message.data['tag'] == "اعلان"){
        // Get.offUntil(
        //     (val) => MainScreen()
        // );

        Get.off(DetailsClassifiedScreen(id: int.parse(message.data['id']),fromNotification: true,));
        // Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsClassifiedScreen(id: message.data['id'],)));

      }
      print("TAG::: ${message.data['tag']}");

      print('onMessageOpenedApp title: ${message.notification!.title!}');
      print('onMessageOpenedApp body: ${message.notification!.body!}');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
    await FirebaseMessaging.instance.subscribeToTopic('all');

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("@mipmap/ic_launcher");

    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project

    final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings();
    final LinuxInitializationSettings initializationSettingsLinux =
    LinuxInitializationSettings(
        defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
        linux: initializationSettingsLinux);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,);
  }
  // void onDidReceiveLocalNotification(
  //     int id, String title, String body, String payload) async {
  //   // display a dialog with the notification details, tap ok to go to another page
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) => CupertinoAlertDialog(
  //       title: Text(title),
  //       content: Text(body),
  //       actions: [
  //         CupertinoDialogAction(
  //           isDefaultAction: true,
  //           child: Text('Ok'),
  //           onPressed: () async {
  //             Navigator.of(context, rootNavigator: true).pop();
  //             await Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => SecondScreen(payload),
  //               ),
  //             );
  //           },
  //         )
  //       ],
  //     ),
  //   );
  // }
  getFcmToken() async {
    print("we are here from get Token");
    String? fcmToken = await messaging.getToken();
    if(fcmToken != null){
      String platform = Platform.isAndroid ? "1" : "2";
      if(SharedPrefController().id != ""){
        NotificationApiController().storeFCMToken(fcmToken: fcmToken, device: platform);

      }
    }
    return fcmToken;
  }

  void selectNotification(String? payload) async {
    if (payload != null) {
      // debugPrint('notification payload: $payload');
      print(payload);
      Map data = json.decode(payload);
      print('data selectNotification');
      print(data);
      // Get.to(() => NotificationScreen());
    }
  }

  void onDidReceiveLocalNotification(){
    // display a dialog with the notification details, tap ok to go to another page
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) => CupertinoAlertDialog(
    //     title: Text(title),
    //     content: Text(body),
    //     actions: [
    //       CupertinoDialogAction(
    //         isDefaultAction: true,
    //         child: Text('Ok'),
    //         onPressed: () async {
    //           Navigator.of(context, rootNavigator: true).pop();
    //           await Navigator.push(
    //             context,
    //             MaterialPageRoute(
    //               builder: (context) => SecondScreen(payload),
    //             ),
    //           );
    //         },
    //       )
    //     ],
    //   ),

    print("Success");}

  localNotification({
  required  String title,
    required  String body,
    required  String payload,
  }) async {
    print("from local notifications");
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');

   const DarwinNotificationDetails iosPlatformChannelSpecifics =
   DarwinNotificationDetails();
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iosPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, title, body, platformChannelSpecifics,
        payload: payload, );

  }
}
