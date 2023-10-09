import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:http/http.dart' as http;
import 'package:image/image.dart';
import 'package:path/path.dart';
import 'package:rakwa/api/api_helper/api_helper.dart';
import 'package:rakwa/api/api_setting/api_setting.dart';
import 'package:rakwa/controller/home_getx_controller.dart';
import 'package:rakwa/model/details_model.dart';
import 'package:rakwa/shared_preferences/shared_preferences.dart';

import '../../controller/image_picker_controller.dart';

class ClaimsApiController with ApiHelper {
  Future<bool> createClaims({
    required var image,
    required String id,
    required String name,
    required String phone,
    required String email,
    required String proof,
  }) async {
    Uri uri =
    Uri.parse('${ApiKey.user}${SharedPrefController().id}/item-claims');
    try {
      var requset = http.MultipartRequest('POST', uri);
      requset.headers['Accept'] = 'application/json';
      // var itemClaimAdditionalUpload = await http.MultipartFile.fromPath(
      //     'item_claim_additional_upload', image);

      Image? image_temp = decodeImage(
          await ImagePickerController.to.image_file!.readAsBytes());

      Image resized_img = copyResize(image_temp!, width: 800, height: 800);

      File resized_file = File(ImagePickerController.to.image_file!.path)
        ..writeAsBytesSync(encodeJpg(resized_img));

      var stream = new http.ByteStream(resized_file.openRead());
      var length = await resized_file.length();

      requset.files.add(
          http.MultipartFile('item_claim_additional_upload', stream, length,
              filename: basename("test"))
      );
      // requset.files.add(itemClaimAdditionalUpload);
      requset.fields['item_claims_item_id'] = id;
      requset.fields['item_claim_full_name'] = name;
      requset.fields['item_claim_phone'] = phone;
      requset.fields['item_claim_email'] = email;
      requset.fields['item_claim_additional_proof'] = proof;

      print("requset.fields is => ${requset.fields}");
      var response = await requset.send();
      print("response.statusCode is => ${response.statusCode}");

      // response.stream.transform(utf8.decoder).listen((value) {
      //   print(value);
      // });

      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();

        // Claims detailsModel = Claims.fromJson(jsonDecode(respStr)['item_claim']);

        // HomeGetxController.to.itemsDetails.first.item!.claims!.add(detailsModel);
        HomeGetxController.to.getDetails(HomeGetxController.to.itemsDetails.first.item!.id.toString());
        return true;
      }
      print(response.statusCode);
      return false;
    } catch (e) {

      print("Error:::${e}");
      return false;
    }
  }
}
