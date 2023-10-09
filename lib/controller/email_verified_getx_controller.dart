import 'package:get/get.dart';
import 'package:rakwa/api/api_controllers/home_api_controller.dart';
import 'package:rakwa/model/user_login_model.dart';
import 'package:rakwa/shared_preferences/shared_preferences.dart';

class UserProfileGetxController extends GetxController {
  static UserProfileGetxController get to => Get.find();


  RxList<UserLoginModel> profile = <UserLoginModel>[].obs;
  RxBool isLoading = true.obs;
  @override
  void onInit() {
    super.onInit();
    if(SharedPrefController().isLogined){
      readUserProfile();
    }
  }

  readUserProfile() async {
    print("from Email verifiled");
    profile.clear();
    isLoading.value = true;
      UserLoginModel? userLoginModel = await HomeApiController().emailVerified();

      if (userLoginModel != null) {

        SharedPrefController().setVerifiedEmail(
          emailVerification: userLoginModel.data!.emailVerifiedAt.toString(),
        );
        profile.add(userLoginModel);

        print("Vendor ID::: ${profile.first.data!.vendor_id.toString()}");
        isLoading.value = false;

      }

    isLoading.value = false;
    update();

  }
}
