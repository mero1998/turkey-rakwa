

import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:rakwa/model/time_prayer.dart';
import 'package:http/http.dart' as http;
import 'package:rakwa/shared_preferences/shared_preferences.dart';
class TimePrayerGetXController extends GetxController {

  RxBool isLoading = true.obs;
  RxList<TimePrayer> timePrayer = <TimePrayer>[].obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getTimePrayer();
  }



  void getTimePrayer()async{
    isLoading.value = true;
    TimePrayer? time = await getTimes();

    if(time != null){
      timePrayer.add(time);

      print("Time ::: ${time.data!.timings!.asr}");
      isLoading.value = false;

    }else{
      timePrayer.value = [];
      isLoading.value = false;

    }
    isLoading.value = false;

  }
  Future<TimePrayer?> getTimes() async {
    // List<Placemark> placemarks = await placemarkFromCoordinates(41.044412, 28.974256);
    List<Placemark> placemarks = await placemarkFromCoordinates(double.parse(SharedPrefController().lat), double.parse(SharedPrefController().lng));
DateTime now = DateTime.now();
// DateFormat format = DateFormat.yMMMd();
// String date = format.format(now);
print("${now.day}-${now.month}-${now.year}");
    // Uri uri = Uri.parse("http://api.aladhan.com/v1/timingsByAddress?address=${placemarks.first.subAdministrativeArea},${placemarks.first.country}&date=${now.month}/${now.year}");
    Uri uri = Uri.parse("http://api.aladhan.com/v1/timings/${now.day}-${now.month}-${now.year}?latitude=${double.parse(SharedPrefController().lat)}&longitude=${double.parse(SharedPrefController().lng)}&method=2");

    print("URL ::: ${uri}");

    var response = await http.get(uri,headers: {
      "Accept" : "*/*",

    });
    print("Code: ::: ${response.statusCode}");
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      print("JSON RESPONSE:::: ${jsonResponse}");
      return TimePrayer.fromJson(jsonResponse);
    }
    return null;
  }

}
