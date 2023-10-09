import 'dart:convert';
import 'dart:io';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:rakwa/Core/services/dialogs.dart';
import 'package:rakwa/api/api_controllers/profile_api_controller.dart';
import 'package:rakwa/api/api_helper/api_helper.dart';
import 'package:rakwa/api/api_setting/api_setting.dart';
import 'package:rakwa/controller/all_ads_getx_controller.dart';
import 'package:rakwa/controller/all_cart_getx_controller.dart';
import 'package:rakwa/controller/all_menu_getx_controller.dart';
import 'package:rakwa/controller/all_orders_getx_controller.dart';
import 'package:rakwa/controller/all_orders_vendor_getx_controller.dart';
import 'package:rakwa/controller/all_subscribtions_getx_controller.dart';
import 'package:rakwa/controller/email_verified_getx_controller.dart';
import 'package:rakwa/controller/error_message_controller_getx.dart';
import 'package:rakwa/controller/image_picker_controller.dart';
import 'package:rakwa/model/artical_model.dart';
import 'package:rakwa/model/cart.dart';
import 'package:rakwa/model/category_items.dart';
import 'package:rakwa/model/delivery_time.dart';
import 'package:rakwa/model/item_details.dart';
import 'package:rakwa/model/menu.dart';

import 'package:flutter/material.dart';
import 'package:rakwa/model/subscriptions.dart';
import 'package:rakwa/screens/main_screens/btm_nav_screens/Home/Screens/home_screen.dart';
import 'package:rakwa/screens/main_screens/main_screen.dart';
import 'package:rakwa/screens/order/confirm_order_book_screen.dart';
import 'package:rakwa/screens/order/send_order_whatsapp_screen.dart';
import 'package:rakwa/shared_preferences/shared_preferences.dart';
import 'package:rakwa/widget/SnackBar/custom_snack_bar.dart';
import 'package:rakwa/widget/app_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:video_compress/video_compress.dart';
import '../../app_colors/app_colors.dart';
import '../../model/fees.dart';
import '../../model/order.dart';
import '../../model/orders_vendor.dart';
import '../../screens/order/send_order_book_succeess_screen.dart';

class SubscriptionApiController with ApiHelper {

  var box = GetStorage();
  Future<SubscriptionsAds?> getSubscriptions() async {
    Uri uri = Uri.parse(ApiKey.subscriptions);
    ("Hour:: ${uri}");
    var response = await http.get(uri, headers: headers);
    (jsonDecode(response.body));
    if (response.statusCode == 200) {

      var jsonResponse = jsonDecode(response.body);
      return SubscriptionsAds.fromJson(jsonResponse);
    }
    return null;
  }


  Future<void> viewAd({required String adId,required bool click}) async {
    Uri uri = Uri.parse("${ApiKey.baseUrl}views-clicks/$adId");
    print("Hour:: ${uri}");
    var response = await http.post(uri, headers: headers, body: {
      "views" :"1",
     click ? "clicks" :"1" : "",
    });
    print(jsonDecode(response.body));
    print(response.statusCode);
    if (response.statusCode == 200) {

      print("Success");
      // var jsonResponse = jsonDecode(response.body)["subscriptions"] as List;
      // return jsonResponse.map((e) => Subscriptions.fromJson(e)).toList();
    }
    // return [];
  }


  Future<void> clickAd({required String adId}) async {
    Uri uri = Uri.parse("${ApiKey.baseUrl}clicks/$adId");
    print("Hour:: ${uri}");
    var response = await http.post(uri, headers: headers, body: {
      "clicks" :"1",
    });
    print(jsonDecode(response.body));
    print(response.statusCode);
    if (response.statusCode == 200) {

      print("Success");
      // var jsonResponse = jsonDecode(response.body)["subscriptions"] as List;
      // return jsonResponse.map((e) => Subscriptions.fromJson(e)).toList();
    }
    // return [];
  }

  Future<void> newStoreAd() async {
    Uri uri = Uri.parse("${ApiKey.baseUrl}new-store/${AllSubscribtionsGetxController.to.adID.value}");
    print("Hour:: ${uri}");
    var response = await http.post(uri, headers: headers, body: {
      "subscription_id" :AllSubscribtionsGetxController.to.subscriptionId.toString(),
      "stripe_id" : AllSubscribtionsGetxController.to.stripeId.value,
      "total" : AllSubscribtionsGetxController.to.total.value,
      "currency" : AllSubscribtionsGetxController.to.selectedCurrency.value,

    });
    print(jsonDecode(response.body));
    print(response.statusCode);
    if (response.statusCode == 200) {


      Get.back();
      Fluttertoast.showToast(msg: "تم انشاء الاعلان بنجاح");
      AllAdsGetxController.to.getAds();
      print("Success");
      Get.back();

      // var jsonResponse = jsonDecode(response.body)["subscriptions"] as List;
      // return jsonResponse.map((e) => Subscriptions.fromJson(e)).toList();
    }
    // return [];
  }


  Future<void> createSmartAds(BuildContext context,

      //     {required List<Cart> cart,
      //   required String stripeToken,
      //   required String delivery_method,
      //   required String address_id,
      //   required String timeslot,
      // }
      ) async{

      // Get.back();
      Uri uri = Uri.parse("${ApiKey.create_ads}");

      print("URI:::: ${uri}");
      // try{
        setLoading();

        var requset = http.MultipartRequest('POST', uri,);

        print(uri);
        requset.headers.addAll({
          "Accept" : "Application/json"
        });

        requset.fields.addAll({
          "subscription_id" : AllSubscribtionsGetxController.to.subscriptionId.value.toString(),
          "user_id" :SharedPrefController().id.toString(),
          "type" : AllSubscribtionsGetxController.to.selectedAdType.value.toString(),
          "url" :  !AllSubscribtionsGetxController.to.websiteController.text.contains("https://") ? "https://${AllSubscribtionsGetxController.to.websiteController.text}" : AllSubscribtionsGetxController.to.websiteController.text,
          "stripe_id" : AllSubscribtionsGetxController.to.stripeId.value,
          "currency" : AllSubscribtionsGetxController.to.selectedCurrency.value,
          "total" : AllSubscribtionsGetxController.to.total.value,

          // "state[]" : AllSubscribtionsGetxController.to.stateID.value.toString(),
          // "event_id" : event_id,

        });

        if(AllSubscribtionsGetxController.to.selectedAdType.value == 0){

          if(ImagePickerController.to.adImage.value != ""){
            img.Image? image_temp = img.decodeImage(
                await XFile(ImagePickerController.to.adImage.value).readAsBytes());

            img.Image resized_img = img.copyResize(
                image_temp!, width: 800, height: 800);

            File resized_file = File(ImagePickerController.to.adImage.value)
              ..writeAsBytesSync(img.encodeJpg(resized_img));

            var stream = new http.ByteStream(resized_file.openRead());
            var length = await resized_file.length();
            requset.files.add(
                http.MultipartFile('image', stream, length,
                    filename: basename("image"))
            );
          }

    }else{

          requset.fields.addAll({
            "image" : AllSubscribtionsGetxController.to.videoLinkController.text,
          });
          // final uint8list = await VideoCompress.compressVideo(
          //     ImagePickerController.to.adVideo.value,
          //     quality: VideoQuality.MediumQuality, // default(100)
          // );
          // requset.files.add(await http.MultipartFile.fromPath('image',  uint8list!.file!.path));
        }

      for(int i = 0; i < AllSubscribtionsGetxController.to.selectedCategoriesId.length; i++ ){
        requset.fields.addAll({
          "category[$i]" : AllSubscribtionsGetxController.to.selectedCategoriesId[i].toString(),
        });
      }

      for(int i = 0; i < AllSubscribtionsGetxController.to.states.length; i++ ){
        requset.fields.addAll({
          "state[$i]" : AllSubscribtionsGetxController.to.states[i].toString(),
        });
      }
        var response;
        response = await requset.send();
        print("Fileds:: ${requset.fields}");

        print("Code::: ${response.statusCode}");
        // final respStr = await response.stream.bytesToString();
        // (response.statusCode);

        var response2 = await http.Response.fromStream(response);

        // var whatsapp = json['whatsapp'];
        // ("Whatsapp:: ${whatsapp}");
        // AllOrdersGetxController.to.whatsappLink.value = whatsapp;
        // (AllOrdersGetxController.to.whatsappLink.value);
        // ("Response::: ${response}");
        // ("Response::: ${respStr}");
        // ("Response::: ${respStr}");
        if(response.statusCode == 200){
          Get.back();
          // var json = jsonDecode(response2.body);
          // var stripe_payment_id = json['stripe_payment_id'];
          // var paymentLink = json['paymentLink'];

          print("JSON:::::: ${json}");
          // AllCartsGetxController.to.carts.clear();
          // Get.off(OrderSuccessScreen());



          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (c) => MainScreen()), (route) => false);
          // Get.off(MainScreen());
          // Map<String, dynamic> body = {
          //   'amount': "10",
          //   'currency': "USD",
          //   'payment_method': AllOrdersGetxController.to.stripeToken.value
          // };
          //
          //
          // // ('Payment Intent Body->>> ${response2.body.toString()}');
          //
          // var response = await http.post(
          //   Uri.parse('https://api.stripe.com/v1/payment_intents'),
          //   headers: {
          //     'Authorization': 'Bearer sk_test_51N7z6KIzeawi2iqgusVt0kG4EGKNy5F1ZJIfQbTI5dJnA9DGB5WXskSquYievlbMVyhiWQjJMpJA3HXp1bake13a00vKYnE5Sx',
          //     'Content-Type': 'application/x-www-form-urlencoded'
          //   },
          //   body: body,
          // );
          // return json['id'];
        }
        else if(response.statusCode == 302){

          Get.back();
          // var json = jsonDecode(response2.body);

          print("JSON:::${response2.body}");

          print("we from 302");
          // AppDialog.errorDialog(context, error: "يرجى التأكد من رصيدكم البنكي وبيانات البطاقة");


          // return -1;
        }

       
        else{

          print("we from else");
          print("JSON:::${response2.body}");

          Get.back();

          // return -1;
        }
      // }
      // catch(e){
      //   // Get.back();
      //   print("we from catc");
      //
      //   ("Error::: ${e.toString()}");
      //   return -1;
      // }
    }

  Future<void> updateSmartAds(BuildContext context, adId

      //     {required List<Cart> cart,
      //   required String stripeToken,
      //   required String delivery_method,
      //   required String address_id,
      //   required String timeslot,
      // }
      ) async{

    // Get.back();
    Uri uri = Uri.parse("${ApiKey.baseUrl}update-add/${adId}");

    print("URI:::: ${uri}");
    // try{
    setLoading();

    var requset = http.MultipartRequest('POST', uri,);

    print(uri);
    requset.headers.addAll({
      "Accept" : "Application/json"
    });

    requset.fields.addAll({
      "type" : AllSubscribtionsGetxController.to.selectedAdType.value.toString(),
      "url" : !AllSubscribtionsGetxController.to.websiteController.text.contains("https://") ? "https://${AllSubscribtionsGetxController.to.websiteController.text}" : AllSubscribtionsGetxController.to.websiteController.text,
      // "state[]" : AllSubscribtionsGetxController.to.stateID.value.toString(),
      // "event_id" : event_id,

    });

    if(AllSubscribtionsGetxController.to.selectedAdType.value == 0){

      if(ImagePickerController.to.adImage.value != ""){
        img.Image? image_temp = img.decodeImage(
            await XFile(ImagePickerController.to.adImage.value).readAsBytes());

        img.Image resized_img = img.copyResize(
            image_temp!, width: 800, height: 800);

        File resized_file = File(ImagePickerController.to.adImage.value)
          ..writeAsBytesSync(img.encodeJpg(resized_img));

        var stream = new http.ByteStream(resized_file.openRead());
        var length = await resized_file.length();
        requset.files.add(
            http.MultipartFile('image', stream, length,
                filename: basename("image"))
        );
      }

    }else{

      requset.fields.addAll({
        "image" : AllSubscribtionsGetxController.to.videoLinkController.text,
      });
      // final uint8list = await VideoCompress.compressVideo(
      //     ImagePickerController.to.adVideo.value,
      //     quality: VideoQuality.MediumQuality, // default(100)
      // );
      // requset.files.add(await http.MultipartFile.fromPath('image',  uint8list!.file!.path));
    }

    for(int i = 0; i < AllSubscribtionsGetxController.to.selectedCategoriesId.length; i++ ){
      requset.fields.addAll({
        "category[$i]" : AllSubscribtionsGetxController.to.selectedCategoriesId[i].toString(),
      });
    }

    for(int i = 0; i < AllSubscribtionsGetxController.to.states.length; i++ ){
      requset.fields.addAll({
        "state[$i]" : AllSubscribtionsGetxController.to.states[i].toString(),
      });
    }
    var response;
    response = await requset.send();
    print("Fileds:: ${requset.fields}");

    print("Code::: ${response.statusCode}");
    // final respStr = await response.stream.bytesToString();
    // (response.statusCode);

    var response2 = await http.Response.fromStream(response);

    // var whatsapp = json['whatsapp'];
    // ("Whatsapp:: ${whatsapp}");
    // AllOrdersGetxController.to.whatsappLink.value = whatsapp;
    // (AllOrdersGetxController.to.whatsappLink.value);
    // ("Response::: ${response}");
    // ("Response::: ${respStr}");
    // ("Response::: ${respStr}");
    if(response.statusCode == 200){
      Get.back();
      // var json = jsonDecode(response2.body);
      // var stripe_payment_id = json['stripe_payment_id'];
      // var paymentLink = json['paymentLink'];

      // print("JSON:::::: ${json}");
      // AllCartsGetxController.to.carts.clear();
      // Get.off(OrderSuccessScreen());



      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (c) => MainScreen()), (route) => false);
      // Get.off(MainScreen());
      // Map<String, dynamic> body = {
      //   'amount': "10",
      //   'currency': "USD",
      //   'payment_method': AllOrdersGetxController.to.stripeToken.value
      // };
      //
      //
      // // ('Payment Intent Body->>> ${response2.body.toString()}');
      //
      // var response = await http.post(
      //   Uri.parse('https://api.stripe.com/v1/payment_intents'),
      //   headers: {
      //     'Authorization': 'Bearer sk_test_51N7z6KIzeawi2iqgusVt0kG4EGKNy5F1ZJIfQbTI5dJnA9DGB5WXskSquYievlbMVyhiWQjJMpJA3HXp1bake13a00vKYnE5Sx',
      //     'Content-Type': 'application/x-www-form-urlencoded'
      //   },
      //   body: body,
      // );
      // return json['id'];
    }
    else if(response.statusCode == 302){

      Get.back();
      // var json = jsonDecode(response2.body);

      print("JSON:::${response2.body}");

      print("we from 302");
      // AppDialog.errorDialog(context, error: "يرجى التأكد من رصيدكم البنكي وبيانات البطاقة");


      // return -1;
    }


    else{

      print("we from else");
      print("JSON:::${response2.body}");

      Get.back();

      // return -1;
    }
    // }
    // catch(e){
    //   // Get.back();
    //   print("we from catc");
    //
    //   ("Error::: ${e.toString()}");
    //   return -1;
    // }
  }









}
