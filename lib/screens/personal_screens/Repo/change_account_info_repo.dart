import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image/image.dart';
import 'package:path/path.dart';
import 'package:rakwa/Core/services/network_services.dart';
import 'package:rakwa/Core/utils/network_exceptions.dart';
import 'package:rakwa/api/api_setting/api_setting.dart';
import 'package:http/http.dart' as http;
import 'package:rakwa/controller/email_verified_getx_controller.dart';
import 'package:rakwa/controller/home_getx_controller.dart';
import 'package:rakwa/shared_preferences/shared_preferences.dart';

import '../../../model/user_login_model.dart';
import '../../../widget/SnackBar/custom_snack_bar.dart';
class ChangeAccountInfoRepository {
  final NetworkService _networkService = Get.put(NetworkService());

  Future<bool> changeAccountInfo({
    required String id,
    required String name,
    required String firstName,
    required String lastName,
     String? phone,
     String? email,
    // required String countryId,
    required File? file,

  }) async {

    print("from func::: ${phone}");
    // Response response;
    Map<String, dynamic> body = {};
    if (phone == null && email == null) {
      body = {
        'name': name,
        // 'user_prefer_country_id': countryId,
        'user_prefer_language': "ar",
        'first_name': firstName,
        'last_name': lastName,
      };
    } else if (phone == null) {
      body = {
        'name': name,
        'email': email,
        // 'user_prefer_country_id': countryId,
        'user_prefer_language': "ar",
        'first_name': firstName,
        'last_name': lastName,
      };
    } else if (email == null) {
      body = {
        'name': name,
        'phone': phone,
        // 'user_prefer_country_id': countryId,
        'user_prefer_language': "ar",
        'first_name': firstName,
        'last_name': lastName,
      };
    } else {
      body = {
        'name': name,
        'phone': phone,
        'email': email,
        // 'user_prefer_country_id': countryId,
        'user_prefer_language': "ar",
        'first_name': firstName,
        'last_name': lastName,
      };
    }

    print("Body::: ${body}");
    try {
     var uri = Uri.parse('${ApiKey.user}$id/update-profile');
      var requset = http.MultipartRequest('POST', uri);
     requset.headers['Accept'] = 'application/json';

     if(file != null){
       // var image = await http.MultipartFile.fromPath(
       //     'user_image', file.path);
       // requset.files.add(image);
       Image? image_temp = decodeImage(
           await file!.readAsBytes());

       Image resized_img = copyResize(image_temp!, width: 800, height: 800);

       File resized_file = File(file!.path)
         ..writeAsBytesSync(encodeJpg(resized_img));

       var stream = new http.ByteStream(resized_file.openRead());
       var length = await resized_file.length();

       requset.files.add(
           http.MultipartFile('user_image', stream, length,
               filename: basename("test"))
       );
     }
     requset.fields['name'] = name;
     if(phone != null){
       requset.fields['phone'] = phone;
     }
     if(email != null){
       requset.fields['email'] = email;
     }
     // requset.fields['user_prefer_country_id'] = countryId;
     requset.fields['user_prefer_language'] = "ar";
     requset.fields['first_name'] = firstName;
     requset.fields['last_name'] = lastName;
      //   requset.headers['Accept'] = 'application/json';
      //   response = await _networkService.post(
      //     url:'${ApiKey.user}$id/update-profile',
      //     // responseType:  ResponseType.bytes,
      //     isForm: true,
      //     fileKey: "user_image",
      //     fileName: "user_image",
      //     fileList: file!=null? [file]:null,
      //
      //     body: body
      //   );
      // } on SocketException {
      //   throw SocketException('No Internet Connection');
      // } on Exception {
      //   throw UnKnownException('there is unKnown Exception');
      // } catch (e) {
      //   throw UnKnownException(e.toString());
      // }
      // return response;
     var response = await requset.send();


     // response.stream.transform(utf8.decoder).listen((value) {
     //   print(value);
     // });
     // Fluttertoast.showToast(msg: "${respStr}");

     // customSnackBar(title: respStr);
     if (response.statusCode == 200) {

       final respStr = await response.stream.bytesToString();
       //
       // print("RESPONSE::::: ${respStr}");
       UserLoginModel user = UserLoginModel.fromJson(jsonDecode(respStr));
       print("User ::: ${user.data!.userImage}");
       if(user != null){
         UserProfileGetxController.to.profile.first.data = user.data;

       }
       print(response.statusCode);
       Fluttertoast.showToast(msg: "Updated");

       changeAccountInfoNewWebsite(id: id, name: name, firstName: firstName, lastName: lastName, file: file,phone: phone);
       Get.back();

       return true;
     }else if(response.statusCode == 422){
       var response2 = await http.Response.fromStream(response);
       print(response2);
       var json = jsonDecode(response2.body);
       print(json);
       var error = json['errors'];
       print("message::: ${error}");
       Fluttertoast.showToast(msg: error.toString().replaceAll("[", "").replaceAll("]", "").replaceAll("phone:", "-").replaceAll("{", "").replaceAll("}", "").replaceAll("email:", "-"));
       // Get.back();

     }

     print(response.statusCode);

     return false;

    } catch (e) {
      print(e);
      Get.back();

      return false;
    }


  }
  Future<bool> changePhoneNumberOldWebsite({

    String? phone,

  }) async {



    print("from func::: ${phone}");
    // Response response;
    Map<String, dynamic> body = {};
      body = {
        'phone': phone,

      };
    try {
      var uri = Uri.parse('${ApiKey.user}${SharedPrefController().id}/update-profile');

      // var requset = http.MultipartRequest('POST', uri);
      // requset.headers['Accept'] = 'application/json';

      var response = await http.post(uri,body: body);

      if (response.statusCode == 200) {
        UserLoginModel user = UserLoginModel.fromJson(jsonDecode(response.body));
        if(user != null){
          UserProfileGetxController.to.profile.first.data = user.data;
        }
        print(response.statusCode);
        Fluttertoast.showToast(msg: "Updated");

        changePhoneNumberNewWebsite(phone: phone);
        // Get.back();

        return true;
      }else if(response.statusCode == 422){
        // var response2 = await http.Response.fromStream(response);
        // print(response2);
        // var json = jsonDecode(response2.body);
        // print(json);
        // var error = json['errors'];
        // print("message::: ${error}");
        // Fluttertoast.showToast(msg: error.toString().replaceAll("[", "").replaceAll("]", "").replaceAll("phone:", "-").replaceAll("{", "").replaceAll("}", "").replaceAll("email:", "-"));
        // Get.back();

        return false;
      }else{
        print(response.statusCode);

        return false;
      }

    } catch (e) {
      print(e);
      Get.back();

      return false;
    }


  }
  Future<bool> changePhoneNumberNewWebsite({

    String? phone,

  }) async {

    var box = GetStorage();
    print("from func::: ${phone}");
    // Response response;
    Map<String, dynamic> body = {};
    body = {
      'phone': phone,

    };
    try {
      var uri = Uri.parse('https://rakwa.me/api/user/${box.read("id")}/update-profile');

      // var requset = http.MultipartRequest('POST', uri);
      // requset.headers['Accept'] = 'application/json';

      var response = await http.post(uri,body: body);

      if (response.statusCode == 200) {
        // UserLoginModel user = UserLoginModel.fromJson(jsonDecode(response.body));
        // if(user != null){
        //   UserProfileGetxController.to.profile.first.data = user.data;
        // }
        // print(response.statusCode);
        // Fluttertoast.showToast(msg: "Updated");

        // Get.back();

        return true;
      }else if(response.statusCode == 422){
        // var response2 = await http.Response.fromStream(response);
        // print(response2);
        // var json = jsonDecode(response2.body);
        // print(json);
        // var error = json['errors'];
        // print("message::: ${error}");
        // Fluttertoast.showToast(msg: error.toString().replaceAll("[", "").replaceAll("]", "").replaceAll("phone:", "-").replaceAll("{", "").replaceAll("}", "").replaceAll("email:", "-"));
        // Get.back();

        return false;
      }else{
        print(response.statusCode);

        return false;
      }

    } catch (e) {
      print(e);
      Get.back();

      return false;
    }


  }
  Future<bool> changeAccountInfoNewWebsite({
    required String id,
    required String name,
    required String firstName,
    required String lastName,
    String? phone,
    String? email,
    // required String countryId,
    required File? file,

  }) async {

    var box = GetStorage();
    // Response response;
    Map<String, dynamic> body = {};
    if (phone == null && email == null) {
      body = {
        'name': name,
        // 'user_prefer_country_id': countryId,
        'user_prefer_language': "ar",
        'first_name': firstName,
        'last_name': lastName,
      };
    } else if (phone == null) {
      body = {
        'name': name,
        'email': email,
        // 'user_prefer_country_id': countryId,
        'user_prefer_language': "ar",
        'first_name': firstName,
        'last_name': lastName,
      };
    } else if (email == null) {
      body = {
        'name': name,
        'phone': phone,
        // 'user_prefer_country_id': countryId,
        'user_prefer_language': "ar",
        'first_name': firstName,
        'last_name': lastName,
      };
    } else {
      body = {
        'name': name,
        'phone': phone,
        'email': email,
        // 'user_prefer_country_id': countryId,
        'user_prefer_language': "ar",
        'first_name': firstName,
        'last_name': lastName,
      };
    }

    print("Body::: ${body}");
    try {
      var uri = Uri.parse('https://rakwa.me/api/user/${box.read("id")}/update-profile');
      var requset = http.MultipartRequest('POST', uri);
      requset.headers['Accept'] = 'application/json';
      print("URLL::::: ${uri}");
      if(file != null){
        // var image = await http.MultipartFile.fromPath(
        //     'user_image', file.path);
        // requset.files.add(image);
        Image? image_temp = decodeImage(
            await file!.readAsBytes());

        Image resized_img = copyResize(image_temp!, width: 800, height: 800);

        File resized_file = File(file!.path)
          ..writeAsBytesSync(encodeJpg(resized_img));

        var stream = new http.ByteStream(resized_file.openRead());
        var length = await resized_file.length();

        requset.files.add(
            http.MultipartFile('user_image', stream, length,
                filename: basename("test"))
        );
      }
      requset.fields['name'] = name;
      if(phone != null){
        requset.fields['phone'] = phone;
      }
      if(email != null){
        requset.fields['email'] = email;
      }
      // requset.fields['user_prefer_country_id'] = countryId;
      requset.fields['user_prefer_language'] = "ar";
      requset.fields['first_name'] = firstName;
      requset.fields['last_name'] = lastName;
      //   requset.headers['Accept'] = 'application/json';
      //   response = await _networkService.post(
      //     url:'${ApiKey.user}$id/update-profile',
      //     // responseType:  ResponseType.bytes,
      //     isForm: true,
      //     fileKey: "user_image",
      //     fileName: "user_image",
      //     fileList: file!=null? [file]:null,
      //
      //     body: body
      //   );
      // } on SocketException {
      //   throw SocketException('No Internet Connection');
      // } on Exception {
      //   throw UnKnownException('there is unKnown Exception');
      // } catch (e) {
      //   throw UnKnownException(e.toString());
      // }
      // return response;
      var response = await requset.send();

      final respStr = await response.stream.bytesToString();

      print("RESPONSE2::::: ${respStr}");
      // UserLoginModel user = UserLoginModel.fromJson(jsonDecode(respStr));
      // print("User ::: ${user.data!.userImage}");
      // UserProfileGetxController.to.profile.first.data = user.data;
      // print(response.statusCode);
      // response.stream.transform(utf8.decoder).listen((value) {
      //   print(value);
      // });

      print("Status code:: ${response.statusCode}");
      if (response.statusCode == 200) {

        Get.back();

        return true;
      }

      print(response.statusCode);
      // Get.back();

      return false;

    } catch (e) {
      print("Error:::${e}");
      // Fluttertoast.showToast(msg: "${e.toString()}");
      // Get.back();

      return false;
    }


  }

  convertUserAccount()async{
    var url = Uri.parse('${ApiKey.user}${SharedPrefController().id}/update-account');
    var response = await http.post(
      url,
    );
    print("URLLLL:::: ${url}");
    print(response.statusCode);
    if (response.statusCode == 200) {
      // var jsonResponse = jsonDecode(response.body);
      // print(jsonResponse);
      // Get.back();
      print(response.statusCode);
      return true;
    }
    return false;
  }
}
