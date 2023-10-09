import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:rakwa/api/api_controllers/address_api_controller.dart';
import 'package:rakwa/api/api_controllers/home_api_controller.dart';
import 'package:rakwa/api/api_controllers/list_api_controller.dart';
import 'package:rakwa/model/address.dart';
import 'package:rakwa/model/all_categories_model.dart';
import 'package:rakwa/model/all_saved_items_model.dart';
import 'package:rakwa/model/category_items.dart';
import 'package:rakwa/model/city_model.dart';
import 'package:rakwa/model/country_model.dart';
import 'package:rakwa/model/details_calssified_model.dart';
import 'package:rakwa/model/details_model.dart';
import 'package:rakwa/model/item_details.dart';
import 'package:rakwa/screens/order/create_order_screen.dart';
import 'package:rakwa/shared_preferences/shared_preferences.dart';

import '../api/api_controllers/order_api_controller.dart';
import '../model/delivery_time.dart';
import 'all_cart_getx_controller.dart';
import 'all_orders_getx_controller.dart';


class AllAddressGetxController extends GetxController with StateMixin<List<Address>>, ScrollMixin{
  static AllAddressGetxController get to => Get.find();
  RxBool isLoading = true.obs;
  RxBool isLoading2 = true.obs;
  Geolocator? geolocator;

  double latMyLocation =39.885525;

  double longMyLocation = 32.855523;
  RxDouble latMap = 0.0.obs;

  RxDouble longMap = 0.0.obs;
  RxBool loadAddress = false.obs;

  RxString address = ''.obs;
  TextEditingController locationController = TextEditingController();

  RxList<UserAddress> addresses = <UserAddress>[].obs;
  UserAddress? selectedAddress;


  bool getFirstData = false;
  bool lastPage = false;
  RxBool loading = false.obs;
  List<String> optionsValues = [];
  List<String> optionsGroupValues = [];
  int page = 1;
  RxInt selectedItem = 0.obs;

  RxInt count = 1.obs;

  @override
  void onInit() {
    super.onInit();
    // getCurrentLocation();

    // Get.put(AllCartsGetxController());
    Future.delayed(Duration.zero, () async{


      getPlaceName(latMyLocation, longMyLocation);
      if(SharedPrefController().isLogined) {
        await getAddress(current_page: page);

      }
    });

    // getItemsByCategory(categoryId: "67");
    // getArticalesPagenation(current_page: page);
  }



  setMyLatLong(double lat, double long) {
    this.latMyLocation = lat;
    this.longMyLocation = long;
    update();
  }
  getCurrentLocation() async {
    // geolocator = await initGeolocator();
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) async {
      this.getPlaceName(position.latitude, position.latitude);

     setMyLatLong(position.latitude, position.longitude);

      // getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.

      Get.defaultDialog(
        title: '',
        // textConfirm: '       Enable my location       ',
        // confirmTextColor: Colors.white,
        // middleText:'Please enable to use your location to show nearby services on the map' ,
        content: Column(
          children: [
            Icon(
              Icons.my_location_outlined,
            ),
            SizedBox(
              height: 26,
            ),
            Text(
              'Enable Your Location',
            ),
            SizedBox(height: 8),
            Container(
              constraints: BoxConstraints(maxWidth: 235),
              child: Text(
                  'Please enable to use your location to show nearby services on the map'),
            ),
            SizedBox(height: 44),
            TextButton(
              onPressed: () {
                Geolocator.openLocationSettings();
              },
              child: Text('Enable my location'),
            )
          ],
        ),
        onWillPop: () {
          print('تتهبلش');
          return Future.value(false);
        },
      );

      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // geolocator = await initGeolocator();
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      this.getPlaceName(position.latitude, position.latitude);

      // appControler.setMyLatLong(position.latitude, position.longitude);
    }).catchError((e) {
      print(e);
    });
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future getPlaceName(double lat, double long) async {

    print("we are here");
    print(lat);
    print(long);
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, long, localeIdentifier: "TR");


      print(lat);
      print(long);
      print(placemarks.first.name);
      // print(placemarks.first.subLocality);
      print(placemarks.first.locality);
      print(placemarks.first.postalCode);
      print(placemarks.first.country);
      // print(placemarks.first.administrativeArea);
      // print(placemarks.first.subAdministrativeArea);
      // print(placemarks.first.street);
      // print(placemarks.first.subThoroughfare);
      // print(placemarks.first.thoroughfare);
      // print(placemarks.first.country);
      address.value = "${placemarks.first.subLocality ?? ""} ${placemarks.first.locality ?? ""} ${placemarks.first.street ?? ""} ${placemarks.first.subAdministrativeArea ?? ""} ${placemarks.first.administrativeArea ?? ""} ${placemarks.first.country ?? ""}";
     print(address);
     //  placemarks.first.administrativeArea;
     //  placemarks.first.subAdministrativeArea;
     //  placemarks.first.locality;
     //  placemarks.first.subLocality;
     //  placemarks.first.thoroughfare;
     //  placemarks.first.subThoroughfare;
     //  placemarks.first.street;
      locationController.text = address.value;
      latMap.value = lat;
      longMap.value = long;

      print(locationController.text);
      // print('fffffffff ${appControler.address.value}');
    } catch (e) {
      print("Error:::$e");
    }
  }


  addAddress({required String buildName,required String buildNumber,required String block,required String floor,required String apartment}) async{

    bool success = await AddressApiController().addAddress(address: locationController.text,
        lat: latMap.toString(),
        lng: longMap.toString(),
    floor: floor,
      apartment: apartment,
      buildNumber: buildNumber,
      buildName: buildName,
      block: block

    );

    if(success){
      print("success");
        getAddress(current_page: page);
      // selectedAddress = addresses.first;
      // AllOrdersGetxController.to.addressId.value = AllAddressGetxController.to.addresses.first.id ?? 0;

      AllOrdersGetxController.to.getFees(resId: AllCartsGetxController.to.carts.first.data!.first.attributes!.restorantId.toString());

      locationController.text = "";
      Get.back();
      Get.back();
      //
      // Get.to(CreateOrderScreen());
    }
  }


  deleteAddress({required int id}) async{

    bool success = await AddressApiController().deleteAddress(addressId: id);

    if(success){
      print("success");
      // AllOrdersGetxController.to.getFees(resId: AllCartsGetxController.to.carts.first.data!.first.attributes!.restorantId.toString());

     int i = addresses.indexWhere((p0) => p0.id == id);
     print(i);
     addresses.removeAt(i);
     // print("Active:: ${addresses[i].active}");
     addresses.refresh();
    }
  }

  Future<void> getAddress({required int current_page}) async {
    print("we are here");
    // addresses.clear();
isLoading.value = true;
  List<UserAddress> a =   await AddressApiController().getAddress(current_page:current_page);
  addresses.value = a.where((element) => element.active == 1).toList();
   if(addresses.isNotEmpty){
     // selectedAddress = addresses.last;
     // AllOrdersGetxController.to.addressId.value = AllAddressGetxController.to.addresses.last.id ?? 0;
     isLoading.value = false;
   }
    isLoading.value = false;

    // final bool emptyRepositories = address.isEmpty;
    // if (!getFirstData && emptyRepositories) {
    //   isLoading.value = false;
    //
    //   // change(null, status: RxStatus.empty());
    // } else if (getFirstData && emptyRepositories) {
    //   lastPage = true;
    //   isLoading.value = false;
    //
    // } else {
    //   isLoading.value = true;
    //   getFirstData = true;
    //
    //   // for(int i = 0; i < nestedItemsMore.length; i++){
    //   //   for(int m = 0; m < result.length; m++){
    //   //     if(nestedItemsMore)
    //
    //   // if(!nestedItemsMore.contains(result)){
    //
    //   addresses.addAll(address);
    //
    //   // }
    //
    // }
    // // }
    // isLoading.value = false;

    // change(repositories, status: RxStatus.success());
    // }
    // }, onError: (err) {
    //   isLoading.value = false;
    //
    //   // change(null, status: RxStatus.error(err.toString()));
    // });
  }

  @override
  Future<void> onEndScroll()  async{
    // TODO: implement onEndScroll
    if (!lastPage) {
      page += 1;
      loading.value = true;
      // Get.dialog(Center(child: LinearProgressIndicator()));
      await getAddress(current_page: page);
      // Get.back();
      loading.value = false;

    } else {
      loading.value = false;

      Get.snackbar('تنبيه', 'لا يوجد عناوين بعد');
    }
  }

  @override
  Future<void> onTopScroll() {
    // TODO: implement onTopScroll
    throw UnimplementedError();
  }

}
