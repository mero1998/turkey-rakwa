import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:rakwa/Core/services/dialogs.dart';
import 'package:rakwa/Core/utils/extensions.dart';
import 'package:rakwa/api/api_controllers/auth_api_controller.dart';
import 'package:rakwa/screens/Auth/Repositories/send_FCM_token_repo.dart';
import 'package:rakwa/screens/Auth/Repositories/sign_in_repo.dart';
import 'package:rakwa/screens/Auth/Repositories/sign_up_repo.dart';
import 'package:rakwa/screens/Auth/Screens/user_role_screen.dart';
import 'package:rakwa/shared_preferences/shared_preferences.dart';
import 'package:rakwa/widget/SnackBar/custom_snack_bar.dart';

import '../../../model/register_model.dart';

class SignUpController extends GetxController {

  TextEditingController? firstNameController;
  TextEditingController? lastNameController;
  TextEditingController? phoneController;
  TextEditingController? emailController;
  TextEditingController? passwordController;
  RxBool accept = false.obs;
  RxString code = "+90".obs;
  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  final SignUpRepository _signUpRepository = Get.put(SignUpRepository());

  void signUp({required int roleId}) async {
    if (globalKey.currentState!.validate()) {
      globalKey.currentState!.save();
      if(accept.value){
        setLoading();
        var response = await _signUpRepository.signUp(
          roleId: roleId,
          name: "${firstNameController!.text} ${lastNameController!.text}",
          phone: "$code${phoneController!.text}",
          email: emailController!.text,
          password: passwordController!.text,
          firstName: firstNameController!.text,
          lastName: lastNameController!.text
        );
        Get.back();
        if (response.statusCode == 200 && response.data["code"] == 200) {
          await SharedPrefController().saveData(
            userLoginModel: response.data["user"],
            token: response.data["token"],
            isLogined: true,
          );
          // RegisterModel registerModel = RegisterModel();
          // registerModel.name = "${firstNameController!.text} ${lastNameController!.text}";
          // registerModel.password = passwordController!.text;
          // registerModel.email =  emailController!.text;
          // registerModel.phone =   "$code${phoneController!.text}";
          //
          // await AuthApiController().registerToNewSite(
          //     registerModel: registerModel,
          //     roleId: roleId);
          printDM("SharedPrefController().token ${SharedPrefController().token}");
          customSnackBar(title: response.data["message"] ?? "");
          _navigation();
          _sendEmailVerification();
        } else {
          if(response.data["errors"]["email"] != null){
            customSnackBar(title: response.data["errors"]["email"][0] ?? "", isWarning: true);
          }else if(response.data["errors"]["phone"] != null){
            customSnackBar(title: response.data["errors"]["phone"][0] ?? "", isWarning: true);

          }
        }
      }else{
        customSnackBar(title: "لتتمكن من انشاء حساب جديد يجب عليك الموافقة على شروط الخدمة و سياسية الخصوصية", isWarning: true);

      }

    }
  }
  Future<void> _sendEmailVerification()async{
    bool state =
    await AuthApiController().emailVerification();
    if (state) {
      customSnackBar(
        title: 'تمت ارسال طلب لتأكيد الحساب',
        subtitle:
        'يرجى مراجعة بريدك الالكتروني لتأكيد الحساب',
      );}
  }

  void _navigation() {
    Get.offAllNamed('/sign_in_screen');
  }

  @override
  void onInit() {
    super.onInit();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    firstNameController?.dispose();
    lastNameController?.dispose();
    phoneController?.dispose();
    emailController?.dispose();
    passwordController?.dispose();
    super.dispose();
  }
}
