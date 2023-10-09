import 'dart:convert';
import 'dart:io';

import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import 'package:rakwa/controller/all_cart_getx_controller.dart';
import 'package:rakwa/controller/all_menu_getx_controller.dart';
import 'package:rakwa/controller/all_orders_getx_controller.dart';
import 'package:rakwa/controller/all_orders_vendor_getx_controller.dart';
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
import 'package:rakwa/screens/main_screens/main_screen.dart';
import 'package:rakwa/screens/order/confirm_order_book_screen.dart';
import 'package:rakwa/screens/order/send_order_whatsapp_screen.dart';
import 'package:rakwa/shared_preferences/shared_preferences.dart';
import 'package:rakwa/widget/SnackBar/custom_snack_bar.dart';
import 'package:rakwa/widget/app_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../app_colors/app_colors.dart';
import '../../model/fees.dart';
import '../../model/order.dart';
import '../../model/orders_vendor.dart';
import '../../screens/order/send_order_book_succeess_screen.dart';

class OrderApiController with ApiHelper {

  var box = GetStorage();
  Future<DeliveryTime?> getTime({required String resturantId}) async {
    Uri uri = Uri.parse("${ApiKey.baseUrl2}$resturantId/hour");
    ("Hour:: ${uri}");
    var response = await http.get(uri, headers: headers);
    (jsonDecode(response.body));
    if (response.statusCode == 200) {

      var jsonResponse = jsonDecode(response.body);
      return  DeliveryTime.fromJson(jsonResponse);
    }
    return null;
  }

  // vendor_id
  // api_token
  // payment_method
  // address_id
  // timeslot
  // items[0][id]
  // items[1][id]
  // delivery_method
  // items[0][variant]
  // items[1][variant]
  // items[0][extrasSelected][0][id]
  // items[1][extrasSelected][1][id]
  // items[0][qty]
  // items[1][qty]
  // stripe_token

  Future checkVerifiyPhone(BuildContext context) async{
    // Get.back();

    Uri uri = Uri.parse("https://rakwa.me/api/v2/client/phone/check");

    var response = await http.get(uri, headers: {
      HttpHeaders.authorizationHeader : "Bearer ${box.read("token")}"
    });

    ("from check:: ${response.statusCode}");
    if(response.statusCode == 200){
      (jsonDecode(response.body)['message']);
      if(jsonDecode(response.body)['message'] == "يرجى التحقق من الهاتف"){
        AppDialog.confirmPhone(context);

        return true;

      }else{
        // AppDialog.verifyPhoneSuccess(context);

        return false;
      }

    }else{
      AppDialog.verifyPhoneFailed(context);

      return false;
    }


  }

  Future verifyPhone(BuildContext context) async{
    Uri uri = Uri.parse("https://rakwa.me/api/v2/client/phone/verify");

    var response = await http.get(uri, headers: {
      HttpHeaders.authorizationHeader : "Bearer ${box.read("token")}"
    });

    if(response.statusCode == 200){
      if(jsonDecode(response.body)['message'] == "تم ارسال الكود"){
        Get.back();
        AppDialog.showEnterOtpDialog2(context);
        // return true;
      }else{
        Get.back();

        AppDialog.verifyPhoneFailed(context);
      }
      // return false;
    }else{
      Get.back();

      AppDialog.verifyPhoneFailed(context);
      // return false;
    }


  }
  Future verifyOTPCode(BuildContext context,String code) async{
    Uri uri = Uri.parse("https://rakwa.me/api/v2/client/phone/verify");

    var response = await http.post(uri, headers: {
      HttpHeaders.authorizationHeader : "Bearer ${box.read("token")}"
    },
    body: {
      "code" : code
    }
    );

    ("code::: ${response.statusCode}");
    if(response.statusCode == 200){
      if(jsonDecode(response.body)['message'] == "تم التحقق من هاتفك بنجاح!"){
        Get.back();
        AppDialog.verifyPhoneSuccess(context);
        return true;
      }else if(jsonDecode(response.body)['message'] == "The code your provided is wrong. Please try again or request another call."){
        // .
        ErrorsMessageControllerGetx.to.otpError.value = "الكود خاطىء";

        ("Error:: ${ErrorsMessageControllerGetx.to.otpError.value}");
      }
      return false;
    }else if(response.statusCode == 422){
    }else{
      Get.back();

      AppDialog.verifyPhoneFailed(context);

      return false;
    }




  }
  Future<bool> createOrder(BuildContext context,{required String vendorId, required List<CartData> data,}
  //     {required List<Cart> cart,
  //   required String stripeToken,
  //   required String delivery_method,
  //   required String address_id,
  //   required String timeslot,
  // }
  ) async{
    if(!await checkVerifiyPhone(context)){
      Uri uri = Uri.parse("${ApiKey.create_orders}");

      setLoading();
      // try{
        var requset = http.MultipartRequest('POST', uri,);


        (uri);
        requset.headers.addAll({
          HttpHeaders.authorizationHeader : "Bearer ${box.read("token")}",
          "Accept" : "Application/json"
        });

        (vendorId);
        (AllOrdersGetxController.to.deliveryType.value.toString());
        (AllOrdersGetxController.to.timeId.value.toString());
        ("Address ID:: ${AllOrdersGetxController.to.addressId.value.toString()}");
        (box.read("token").toString());
        ( AllCartsGetxController.to.carts.first.data!.first.quantity);
        (AllOrdersGetxController.to.selectedPayment.value);
        requset.fields.addAll({
          "vendor_id" : data.first.attributes!.restorantId.toString(),
          "api_token" : box.read("token").toString(),
          "comment" : AllOrdersGetxController.to.noteController.text,
          "payment_method" : AllOrdersGetxController.to.selectedPayment.value,
          "address_id" : AllOrdersGetxController.to.addressId.value.toString(),
          "timeslot" : AllOrdersGetxController.to.timeId.value.toString(),
          "delivery_method" : AllOrdersGetxController.to.deliveryType.value.toString(),
          "deliveryCost" : AllOrdersGetxController.to.costDelivery.value,
          // "user_id" : ,
        });

        if(AllOrdersGetxController.to.coupon.value.isNotEmpty){
          requset.fields.addAll({
            "coupon" : AllOrdersGetxController.to.coupon.value,
          });

        }
        if(AllOrdersGetxController.to.selectedPayment.value == "stripe"){
          requset.fields.addAll({
            "stripe_token" : AllOrdersGetxController.to.stripeToken.value,
          });
        }else{
          // AllOrdersGetxController.to.selectedPayment.value = "cod";
          requset.fields.addAll({
            "payment_method_upon_receipt" : AllOrdersGetxController.to.selectedPaymentMethodCash.value,
          });
        }
        // for(int i = 0; i < data.length; i++){
        //   ("Item ID ::: ${data[i].itemId}");
        //   requset.fields.addAll({
        //     "items[$i][id]" : data[i].itemId.toString(),
        //     "items[$i][qty]" : data[i].quantity.toString(),
        //   });
        //   if(AllCartsGetxController.to.carts.first
        //       .data![i].attributes!.variant != null){
        //     requset.fields.addAll({
        //       "items[$i][variant]": data[i].attributes!.variant ?? "",
        //     });
        //   }else{
        //     requset.fields.addAll({
        //       "items[$i][variant]": "",
        //     });
        //   }
        //
        //   if(AllCartsGetxController.to.carts.first.data![i].attributes!.extras != null){
        //     for(int m = 0; m <data[i].attributes!.extras!.length; m++){
        //       requset.fields.addAll({
        //         "items[$i][extrasSelected][$i][id]" :data[i].attributes!.extras![m],
        //       });
        //     }
        //   }
        //   else{
        //     requset.fields.addAll({
        //       "items[$i][extrasSelected][$i][id]" : "",
        //     });
        //   }
        // }

        for(int i = 0; i < AllCartsGetxController.to.carts.first.data!.length; i++){
          ("Item ID ::: ${AllCartsGetxController.to.carts.first.data![i].itemId}");
          ("Item ID ::: ${AllCartsGetxController.to.carts.first.data![i].quantity}");
          requset.fields.addAll({
            "items[$i][id]" : AllCartsGetxController.to.carts.first.data![i].itemId.toString(),
            "items[$i][qty]" : AllCartsGetxController.to.carts.first.data![i].quantity.toString(),
          });
          if(AllCartsGetxController.to.carts.first
              .data![i].attributes!.variant != null){
            ("we are here");

            ("Ver::::${AllCartsGetxController.to.carts.first
                .data![i].attributes!.variant}");
            requset.fields.addAll({
              "items[$i][variant]": AllCartsGetxController.to.carts.first
                  .data![i].attributes!.variant ?? "",
            });
          }
          else{
            requset.fields.addAll({
              "items[$i][variant]": "",
            });
          }

          if(AllCartsGetxController.to.carts.first.data![i].attributes!.extras != null){
            ("from extra");
            for(int m = 0; m <AllCartsGetxController.to.carts.first.data![i].attributes!.extras!.length; m++){
              requset.fields.addAll({
                "items[$i][extrasSelected][$i][id]" : AllCartsGetxController.to.carts.first.data![i].attributes!.extras![m],
              });
            }
          }
          else{
            requset.fields.addAll({
              "items[$i][extrasSelected][$i][id]" : "",
            });
          }
        }


        // if(variantID.isNotEmpty){
        //   requset.fields.addAll({
        //     "variantID" : variantID,
        //   });
        // }
        //
        // if(extras.isNotEmpty){
        //
        //   for(int i = 0 ; i < extras.length; i++){
        //     requset.fields.addAll({
        //       "extras[]" : extras[i].toString(),
        //     });
        //   }
        // }
        var response;
         response = await requset.send();
        print(" Fileds:: ${requset.fields}");

        print("Code::: ${response.statusCode}");
        // final respStr = await response.stream.bytesToString();
        // (response.statusCode);

        var response2 = await http.Response.fromStream(response);

        // ("Whatsapp:: ${whatsapp}");
        // AllOrdersGetxController.to.whatsappLink.value = whatsapp;
        // (AllOrdersGetxController.to.whatsappLink.value);
        // ("Response::: ${response}");
        // ("Response::: ${respStr}");
        // ("Response::: ${respStr}");
        if(response.statusCode == 200 && jsonDecode(response2.body)['status'] == true){
          // AllCartsGetxController.to.carts.clear();
         Get.back();
          var json = jsonDecode(response2.body);

          print("JSON:::::: ${json}");
          // var whatsapp = json['whatsapp'];
          var paymentLink = json['paymentLink'];
          AllOrdersGetxController.to.getOrders(current_page: 1);
          // Get.off(OrderSuccessScreen());
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (c)=> OrderSuccessScreen()), (route) => false);
          if(paymentLink != null){
            var url = Uri.parse(paymentLink.toString());
            if (await canLaunchUrl(url)) {
              launchUrl(url,mode:LaunchMode.externalApplication);
            }
          }


          // Get.offAll(SendOrderWhatsappScreen());
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
          return true;
        }else if(response.statusCode == 302){
          Get.back();
          AppDialog.errorDialog(context, error: "يرجى التأكد من رصيدكم البنكي وبيانات البطاقة");
          return false;
        }

        else{
          Get.back();

          return false;
        }
      // }catch(e){
      //   print("Error::: ${e.toString()}");
      //   return false;
      // }
    }
    else{

      return false;
    }



  }

  Future<int> createBookOrder(BuildContext context,{required String vendorId,
    required String itemID,
    required String numberofDays,
    required String assurnace ,
    required String clean,
   }
      //     {required List<Cart> cart,
      //   required String stripeToken,
      //   required String delivery_method,
      //   required String address_id,
      //   required String timeslot,
      // }
      ) async{
    if(!await checkVerifiyPhone(context)){
      // Get.back();
      Uri uri = Uri.parse("${ApiKey.create_book_orders}");

      print("URI:::: ${uri}");
      // try{
        setLoading();

        var requset = http.MultipartRequest('POST', uri,);

        print(uri);
        requset.headers.addAll({
          HttpHeaders.authorizationHeader : "Bearer ${box.read("token")}",
          "Accept" : "Application/json"
        });

        print(vendorId);
        print(AllOrdersGetxController.to.deliveryType.value.toString());
        print(AllOrdersGetxController.to.timeId.value.toString());
        // print("Address ID:: ${AllOrdersGetxController.to.addressId.value.toString()}");
        print(box.read("token").toString());
        // print( AllCartsGetxController.to.carts.first.data!.first.quantity);
        // print(AllOrdersGetxController.to.selectedPayment.value);
        requset.fields.addAll({
          "vendor_id" : vendorId,
          "api_token" : box.read("token").toString(),
          // "address_id" : "",
          "timeslot" : "990_1020",
          "delivery_method" : "pickup",
          "clean" : clean,
          "insurance" : assurnace,
          "type" : AllOrdersGetxController.to.typePay.value,
          "stripe_token" : AllOrdersGetxController.to.stripeToken.value,
          // "stripe_token" : 'pm_1Nx5Q4L67JT38PhC82CLc87T',
          "payment_method" : "stripe"

          // "event_id" : event_id,

        });

        if(AllMenusGetxController.to.type == 5){
            requset.fields.addAll({
              "address_id" :AllOrdersGetxController.to.addressId == 0 ? "" : AllOrdersGetxController.to.addressId.value.toString(),
              "delivery_method" : AllOrdersGetxController.to.deliveryType.value.toString()
            });

    }
        // for(int i = 0; i < data.length; i++){
        //   ("Item ID ::: ${data[i].itemId}");
        //   requset.fields.addAll({
        //     "items[$i][id]" : data[i].itemId.toString(),
        //     "items[$i][qty]" : data[i].quantity.toString(),
        //   });
        //   if(AllCartsGetxController.to.carts.first
        //       .data![i].attributes!.variant != null){
        //     requset.fields.addAll({
        //       "items[$i][variant]": data[i].attributes!.variant ?? "",
        //     });
        //   }else{
        //     requset.fields.addAll({
        //       "items[$i][variant]": "",
        //     });
        //   }
        //
        //   if(AllCartsGetxController.to.carts.first.data![i].attributes!.extras != null){
        //     for(int m = 0; m <data[i].attributes!.extras!.length; m++){
        //       requset.fields.addAll({
        //         "items[$i][extrasSelected][$i][id]" :data[i].attributes!.extras![m],
        //       });
        //     }
        //   }
        //   else{
        //     requset.fields.addAll({
        //       "items[$i][extrasSelected][$i][id]" : "",
        //     });
        //   }
        // }
        requset.fields.addAll({
          "items[0][id]" : itemID,
          "items[0][qty]" : numberofDays,
        });
        requset.fields.addAll({
          "items[0][variant]": "",
        });
        requset.fields.addAll({
          "items[0][extrasSelected][0][id]" : "",
        });


        if(ImagePickerController.to.ldrive.value != ""){
          img.Image? image_temp = img.decodeImage(
              await XFile(ImagePickerController.to.ldrive.value).readAsBytes());

          img.Image resized_img = img.copyResize(
              image_temp!, width: 800, height: 800);

          File resized_file = File(ImagePickerController.to.ldrive.value)
            ..writeAsBytesSync(img.encodeJpg(resized_img));

          var stream = new http.ByteStream(resized_file.openRead());
          var length = await resized_file.length();
          requset.files.add(
              http.MultipartFile('image', stream, length,
                  filename: basename("image"))
          );
        }


        // if(variantID.isNotEmpty){
        //   requset.fields.addAll({
        //     "variantID" : variantID,
        //   });
        // }
        //
        // if(extras.isNotEmpty){
        //
        //   for(int i = 0 ; i < extras.length; i++){
        //     requset.fields.addAll({
        //       "extras[]" : extras[i].toString(),
        //     });
        //   }
        // }
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
        if(response.statusCode == 200 &&jsonDecode(response2.body)['status'] == true){
          Get.back();
          var json = jsonDecode(response2.body);
          var stripe_payment_id = json['stripe_payment_id'];
          var paymentLink = json['paymentLink'];

          print("JSON:::::: ${json}");
          // AllCartsGetxController.to.carts.clear();
          AllOrdersGetxController.to.getOrders(current_page: 1);
          // Get.off(OrderSuccessScreen());
          if(paymentLink != null){
            var url = Uri.parse(paymentLink.toString());
            if (await canLaunchUrl(url)) {
              launchUrl(url,mode:LaunchMode.externalApplication);
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (c)=> ConfirmOrderBookScreen(orderId: json['id'].toString(),)), (route) => false);

            }
          }else{
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (c)=> OrderBookSuccessScreen(orderId: json['id'].toString(),)), (route) => false);

          }


          // Get.offAll(SendOrderWhatsappScreen());
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
          return json['id'];
        }
        else if(response.statusCode == 302){

          Get.back();
          // var json = jsonDecode(response2.body);

          print("JSON:::${response2.body}");

          print("we from 302");
          AppDialog.errorDialog(context, error: "يرجى التأكد من رصيدكم البنكي وبيانات البطاقة");


          return -1;
        }

       
        else{

          print("we from else");
          print("JSON:::${response2.body}");

          Get.back();

          return -1;
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
    else{
      print("from else 2");
      return -1;
    }



  }


  Future<List<Orders>> getOrders({required int current_page}) async {
    Uri uri = Uri.parse("${ApiKey.all_orders}${box.read('id')}?page=$current_page");
    ("URL:::: ${uri}");
    ("URL:::: ${box.read("token")}");

    var response = await http.get(uri, headers: {
      HttpHeaders.authorizationHeader : "Bearer ${box.read("token")}",
      "Accept" : "application/json"
    });
    ("URL:::: ${response.statusCode}");
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      ("jsonResponse:::${jsonResponse}");
      var jsonArray = jsonResponse['data']['data'] as List;

      return jsonArray.map((e) => Orders.fromJson(e)).toList();
    }
    return [];
  }
  Future<bool> checkOrder({required int orderId}) async {
    Uri uri = Uri.parse("https://rakwa.me/api/handle-order-payment-stripe/$orderId");

    print(uri);
    var response = await http.get(uri, headers: {
      "Accept" : "application/json"
    });
    ("URL:::: ${response.statusCode}");
    ("URL:::: ${jsonDecode(response.body)}");
    if (response.statusCode == 200 && jsonDecode(response.body)['message'] == 'Order created' ) {
      return true;
    }
    return false;
  }
  Future<List<Fees>> getDeliveryCost({required String resId}) async {
    Uri uri = Uri.parse("${ApiKey.fees}$resId/${box.read('id')}");
    ("URL:::: ${uri}");

    var response = await http.get(uri, headers: {
      "Accept" : "application/json"
    });
    ("URL:::: ${response.statusCode}");
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      ("jsonResponse:::${jsonResponse}");
      var jsonArray = jsonResponse['data'] as List;

      return jsonArray.map((e) => Fees.fromJson(e)).toList();
    }
    return [];
  }
  Future<List<OrdersVendor>> getOrdersVendor({required int current_page}) async {


    Uri uri = Uri.parse("${ApiKey.baseUrl2}orders?page=$current_page");
      var requset = http.MultipartRequest('POST', uri,);
      (uri);
      requset.headers.addAll({
        HttpHeaders.authorizationHeader : "Bearer ${box.read("token")}",
        "Accept" : "Application/json"
      });
      if(UserProfileGetxController.to.profile.first.data!.vendor_id != null){
     List<String> ids =  UserProfileGetxController.to.profile.first.data!.vendor_id!.split(',');
      for(int i = 0; i < ids.length; i++){
        requset.fields.addAll({
          "name[$i]" : ids[i]
        });
      }

      }

    ("URL:::: ${uri}");
    // ("URL:::: ${box.read("token")}");
    var response = await requset.send();
    print(" Fileds:: ${requset.fields}");

    ("Code::: ${response.statusCode}");
    // final respStr = await response.stream.bytesToString();
    // (response.statusCode);

    var response2 = await http.Response.fromStream(response);
    var json = jsonDecode(response2.body);

    ("URL:::: ${response.statusCode}");
    if (response.statusCode == 200 && json['status'] == true) {
      // var jsonResponse = jsonDecode(response.body);
      // ("jsonResponse:::${jsonResponse}");
      var jsonArray = json['data']['data'] as List;

      return jsonArray.map((e) => OrdersVendor.fromJson(e)).toList();
    }
    return [];
  }

  Future<bool> acceptOrder({required String orderId}) async{
    Uri uri = Uri.parse("${ApiKey.baseUrl5}vendor/acceptorder/${orderId}}");
    // setLoading();

    var response = await http.get(uri,
    );
    (uri);

    ("code::: ${response.statusCode}");
    if(response.statusCode == 200){
      if(jsonDecode(response.body)['message'] == "تم تحديث الطلب"){
        // Get.back();
        customSnackBar(title: "تم قبول الطلب",);
        AllOrdersVendorGetxController.to.getOrdersVendor(current_page: 1);
        return  true;
      }else{
        // Get.back();
        customSnackBar(title: "حدث خطأ ما، يرجى المحاولة مرة اخرى",isWarning: true);

        return false;
      }
      // return false;
    }else{
      // Get.back();
      customSnackBar(title: "حدث خطأ ما، يرجى المحاولة مرة اخرى",isWarning: true);

      return false;

      // return false;
    }

  }
  Future<bool> rejectOrder({required String orderId}) async{
    Uri uri = Uri.parse("${ApiKey.baseUrl5}vendor/rejectorder/${orderId}}");

// setLoading();
var response = await http.get(uri,);
    ("code::: ${response.statusCode}");
    if(response.statusCode == 200){
      if(jsonDecode(response.body)['message'] == "تم تحديث الطلب"){
        // Get.back();
        customSnackBar(title: "تم رفض الطلب",);
        AllOrdersVendorGetxController.to.getOrdersVendor(current_page: 1);

        return  true;
      }else{
        // Get.back();
        customSnackBar(title: "حدث خطأ ما، يرجى المحاولة مرة اخرى",isWarning: true);

        return false;
      }
      // return false;
    }else{

      // Get.back();
      customSnackBar(title: "حدث خطأ ما، يرجى المحاولة مرة اخرى",isWarning: true);


      return false;

      // return false;
    }

  }
  Future<bool> updateStatusOrder({required String orderId,required int status}) async{
    Uri uri = Uri.parse("${ApiKey.baseUrl5}vendor/updateorderstatus/${orderId}/${status}");
    // setLoading();
    var response = await http.get(uri,);
    ("code::: ${response.statusCode}");
    if(response.statusCode == 200){
      if(jsonDecode(response.body)['message'] == "تم تحديث الطلب"){
        // Get.back();
        customSnackBar(title: "تم تحديث حالة الطلب",);
        AllOrdersVendorGetxController.to.getOrdersVendor(current_page: 1);

        return  true;
      }else{
        // Get.back();
        customSnackBar(title: "حدث خطأ ما، يرجى المحاولة مرة اخرى",isWarning: true);

        return false;
      }
      // return false;
    }else{

      // Get.back();
      customSnackBar(title: "حدث خطأ ما، يرجى المحاولة مرة اخرى",isWarning: true);


      return false;

      // return false;
    }

  }
  Future<int?> applyCoupon({required String code}) async{
    Uri uri = Uri.parse(ApiKey.coupon);
    // setLoading();
    var response = await http.post(uri,body: {
      "code" : code,
      "cartValue" : AllCartsGetxController.to.carts.first.total.toString(),
      // "restaurant_id" :'26',
      "user_id" : box.read("id").toString(),
      "restaurant_id" :AllCartsGetxController.to.carts.first.data!.first.attributes!.restorantId.toString(),
    });
    ("code::: ${response.statusCode}");
    ("code::: ${jsonDecode(response.body)}");
    if(response.statusCode == 200 && jsonDecode(response.body)['status']== true){
      // if(jsonDecode(response.body)['message'] == "تم تحديث الطلب"){
      //   Get.back();
        customSnackBar(title: "تم تطبيق كوبون الخصم",);

        return jsonDecode(response.body)['deduct'];
      }else{
        // Get.back();
        customSnackBar(title: "لم يتم تطبيق كوبون الخصم",isWarning: true);


        return null;
      }
      // return false;
  }


}
