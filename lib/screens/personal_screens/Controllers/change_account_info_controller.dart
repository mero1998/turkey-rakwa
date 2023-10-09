import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:rakwa/Core/services/dialogs.dart';
import 'package:rakwa/Core/utils/extensions.dart';
import 'package:rakwa/controller/email_verified_getx_controller.dart';
import 'package:rakwa/model/details_calssified_model.dart';
import 'package:rakwa/screens/main_screens/main_screen.dart';
import 'package:rakwa/screens/personal_screens/Repo/change_account_info_repo.dart';
import 'package:rakwa/shared_preferences/shared_preferences.dart';
import 'package:rakwa/widget/SnackBar/custom_snack_bar.dart';

import '../../../model/countries.dart';
class ChangeAccountInfoController extends GetxController {
  static ChangeAccountInfoController get to => Get.find();
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController countryController;

  RxString s = ''.obs;
  RxString codeCountry = 'TR'.obs;
  RxString codeNumberCountry = ''.obs;
  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  final ChangeAccountInfoRepository _changeAccountInfoRepository =
      Get.put(ChangeAccountInfoRepository());


  seperatePhoneAndDialCode({required String phone}) {
    print("we are here:: ${phone}");
    Map<String, String> foundedCountry = {};
    for (var country in Countries.allCountries) {
      String dialCode = country["dial_code"].toString();
      if (phone.contains(dialCode)) {
        foundedCountry = country;
      }
    }


    print("Phone::: ${UserProfileGetxController.to.profile.first.data!.phone}");
    print("Phone::: ${"${codeNumberCountry.value}${phoneController.text}"}");

    if (foundedCountry.isNotEmpty) {

      var dialCode = phone.substring(
        0,
        foundedCountry["dial_code"]!.length,
      );
      var newPhoneNumber = phone.substring(
        foundedCountry["dial_code"]!.length,
      );
      var code = foundedCountry['code'].toString();
     print(code);
      print("map:::${{dialCode, newPhoneNumber}}");
      phoneController.text = newPhoneNumber;
      codeCountry.value = code.toString();
      codeNumberCountry.value = dialCode.toString();
    }
  }
  void changeAccountInfo({ File? file}) async {
    if (globalKey.currentState!.validate()) {
      globalKey.currentState!.save();
      setLoading();
      bool response;
      if(UserProfileGetxController.to.profile.first.data!.email == emailController.text && UserProfileGetxController.to.profile.first.data!.phone == "${codeNumberCountry.value}${phoneController.text}"){

        print("1111111");
        print(UserProfileGetxController.to.profile.first.data!.phone);
        print("${codeNumberCountry.value}${phoneController.text}");

        response   = await _changeAccountInfoRepository.changeAccountInfo(
          id: SharedPrefController().id,
          name: "${firstNameController.text} ${lastNameController.text}",
          file: file,
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          // countryId: countryId ,
        );
        Get.back();
      }else if(UserProfileGetxController.to.profile.first.data!.email == emailController.text && UserProfileGetxController.to.profile.first.data!.phone != "${codeNumberCountry.value}${phoneController.text}"){

        print("1111111 3232323");

        response   = await _changeAccountInfoRepository.changeAccountInfo(
          id: SharedPrefController().id,
          name: "${firstNameController.text} ${lastNameController.text}",
          file: file,
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          phone: "${codeNumberCountry.value}${phoneController.text}"
          // countryId: countryId ,
        );
        Get.back();
      }
     else if(UserProfileGetxController.to.profile.first.data!.email == emailController.text){
        print("222222222");

        response   = await _changeAccountInfoRepository.changeAccountInfo(
          id: SharedPrefController().id,
          name: "${firstNameController.text} ${lastNameController.text}",
          phone: "${codeNumberCountry.value}${phoneController.text}",
          file: file,
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          // countryId: countryId ,
        );
        Get.back();

      }else if(UserProfileGetxController.to.profile.first.data!.phone != "${codeNumberCountry.value}${phoneController.text}"){

        print("we are herer::::: new");
        response  = await _changeAccountInfoRepository.changeAccountInfo(
            id: SharedPrefController().id,
            name: "${firstNameController.text} ${lastNameController.text}",
            email: emailController.text,
            file: file,
            firstName: firstNameController.text,
            lastName: lastNameController.text,
            phone: "${codeNumberCountry.value}${phoneController.text}"
          // countryId: countryId ,
        );
        Get.back();

      }

     else if(UserProfileGetxController.to.profile.first.data!.phone == "${codeNumberCountry.value}${phoneController.text}"){

       print("we are herer:::::");
  response  = await _changeAccountInfoRepository.changeAccountInfo(
    id: SharedPrefController().id,
    name: "${firstNameController.text} ${lastNameController.text}",
    email: emailController.text,
    file: file,
    firstName: firstNameController.text,
    lastName: lastNameController.text,
    phone: null
    // countryId: countryId ,
    );
  Get.back();

      }else{
        response   = await _changeAccountInfoRepository.changeAccountInfo(
          id: SharedPrefController().id,
          name: "${firstNameController.text} ${lastNameController.text}",
          phone:"${codeNumberCountry.value}${phoneController.text}",
          email: emailController.text,
          file: file,
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          // countryId: countryId ,
        );
        Get.back();

      }

      Get.back();
      // if (response.statusCode == 200 ) {
      //   await SharedPrefController().saveData(
      //     userLoginModel: response.data["data"],
      //     token: response.data["data"]["api_token"],
      //     isLogined: true,
      //   );
      //   _navigation();
      //   customSnackBar(title: response.data["message"] ?? "");
      // } else {
      //   showSnakError(response);
      //   _navigation();
      //
      // }
    }
  }

  void _navigation() {
    Get.offAll(() => const MainScreen());
  }

  @override
  void onInit() {
    super.onInit();
    print("Phone::: ${UserProfileGetxController.to.profile.first.data!.phone}");


    // printDM('..........>>>> ${SharedPrefController().name.split(" ").elementAt(1)}');
    print("User name:: ${UserProfileGetxController.to.profile.first.data!.firstName != null ? UserProfileGetxController.to.profile.first.data!.firstName : UserProfileGetxController.to.profile.first.data!.name}");
    firstNameController = TextEditingController(text: "${UserProfileGetxController.to.profile.first.data!.firstName != null ? UserProfileGetxController.to.profile.first.data!.firstName : UserProfileGetxController.to.profile.first.data!.name!.split(" ").first}");
    lastNameController = TextEditingController(text: "${UserProfileGetxController.to.profile.first.data!.lastName != null ? UserProfileGetxController.to.profile.first.data!.lastName : UserProfileGetxController.to.profile.first.data!.name!.split(" ").last}");
    phoneController = TextEditingController(text: "${UserProfileGetxController.to.profile.first.data!.phone ?? ""}");
    emailController = TextEditingController(text: UserProfileGetxController.to.profile.first.data!.email ?? "");
    countryController = TextEditingController(text:UserProfileGetxController.to.profile.first.data!.country != null ?
    UserProfileGetxController.to.profile.first.data!.country!.countryName ?? "" : "");

    if(phoneController.text.startsWith("00") || phoneController.text.startsWith("+")){
      seperatePhoneAndDialCode(phone: phoneController.text);
    }else{
      seperatePhoneAndDialCode(phone: "+9${phoneController.text}");

    }


    if(SharedPrefController().roleId == 3) {
      s.value = "صاحب عمل";
    }else{
      s.value = "مستخدم";

    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    countryController.dispose();
    super.dispose();
  }


  void convertUserAccount() async{
   bool success = await ChangeAccountInfoRepository().convertUserAccount();
 if(success){

   if(SharedPrefController().roleId == 2){
     SharedPrefController().setRoleId(roleId:3);
     s.value = "صاحب عمل";
     print("Role Id:: ${SharedPrefController().roleId}");
     print(s);
     Get.back();
   }else{
     SharedPrefController().setRoleId(roleId: 2);
     s.value = "مستخدم";

     print("Role Id:: ${SharedPrefController().roleId}");
     print(s);
     Get.back();

   }


 }

  }
  void showSnakError(dio.Response response) {
    if(response.data["errors"]["email"][0]!=null){
      customSnackBar(title: response.data["errors"]["email"][0] , isWarning: true);
    }else if(response.data["errors"]["phone"] != null){
      customSnackBar(title: response.data["errors"]["phone"][0] ?? "", isWarning: true);
    }
    else if(response.data["message"]!=null){
      customSnackBar(title: response.data["message"] , isWarning: true);
    }else{
      customSnackBar(title: "حدث خطاء ما..." , isWarning: true);
    }

  }


  Future<bool> updatePhoneNumber({required String phone})async{
  return await _changeAccountInfoRepository.changePhoneNumberOldWebsite(
        phone: phone
      // countryId: countryId ,
    );
  }
}


