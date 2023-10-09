import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rakwa/Core/services/dialogs.dart';
import 'package:rakwa/Core/utils/extensions.dart';
import 'package:rakwa/Core/utils/notification_helper.dart';
import 'package:rakwa/api/api_controllers/auth_api_controller.dart';
import 'package:rakwa/screens/Auth/Repositories/send_FCM_token_repo.dart';
import 'package:rakwa/screens/Auth/Repositories/sign_in_repo.dart';
import 'package:rakwa/screens/Auth/Screens/user_role_screen.dart';
import 'package:rakwa/shared_preferences/shared_preferences.dart';
import 'package:rakwa/widget/SnackBar/custom_snack_bar.dart';

import '../../../api/api_controllers/notification_api_controller.dart';
import '../../../model/register_model.dart';

class SignInController extends GetxController {
  TextEditingController? emailController;
  TextEditingController? passwordController;
  final box = GetStorage();

  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  final SignInRepository _signInRepository = Get.put(SignInRepository());
  bool remember = true;
  final SendFCMTokenRepository _sendFCMTokenRepository =
      Get.put(SendFCMTokenRepository());

  void submit() async {
    if (globalKey.currentState!.validate()) {
      globalKey.currentState!.save();
      var response = await _signInRepository.logIn(
        email: emailController!.text,
        password: passwordController!.text,
      );
      // Get.back();

      if (response.statusCode == 200 && response.data["code"] == 200) {
        setLoading();

        await SharedPrefController().saveData(
          userLoginModel: response.data["user"],
          token: response.data["token"],
          isLogined: true,
        );
        RegisterModel registerModel = RegisterModel();
        registerModel.name = SharedPrefController().name;
        registerModel.password = passwordController!.text;
        registerModel.email =  SharedPrefController().email;
        registerModel.phone =  SharedPrefController().phone;

        await AuthApiController().registerToNewSite(
            registerModel: registerModel,
            roleId: SharedPrefController().roleId);
        await AuthApiController().getNewToken();
        NotificationHelper().getFcmToken();
        if(remember){
          print("we are here");
          // bool success = await SharedPrefController().saveLoginDataForUser(emailController!.text, passwordController!.text);
          //  if(success){
          //    print("saved");
          //  }
          box.write('email', emailController!.text);
          box.write('password', passwordController!.text);

        }else{
          box.write('email', "");
          box.write('password', "");

        }

        customSnackBar(title: response.data["message"] ?? "");
        _sendFCMToken();

      } else {
        customSnackBar(title: response.data["message"] ?? "", isWarning: true);

      }

    }
  }

  void _sendFCMToken() async {
    var response = await _sendFCMTokenRepository.sendFCMToken();
    Get.offAllNamed('/main_screen');
  }
  void remmber(bool value)  {

    remember = value;
    update();
  }

  void moveToForgetPassword() {
    Get.toNamed('/forget_password_screen');
  }

  void moveToRegister() {
    Get.to(() => const UserRoleScreen());
  }

  @override
  void onInit() {
    super.onInit();
    // emailController = TextEditingController(text: "adoma3015@gmail.com");
    // passwordController = TextEditingController(text: "password");

    emailController = TextEditingController(text: remember ?  box.read('email') : "");
    passwordController = TextEditingController(text: remember ? box.read('password') : "");
  }

  @override
  void dispose() {
    emailController?.dispose();
    passwordController?.dispose();
    super.dispose();
  }
}
