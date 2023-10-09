import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:g_map/widgets/location_dalogue.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:rakwa/api/api_controllers/list_api_controller.dart';
import 'package:rakwa/controller/all_address_getx_controller.dart';
import 'package:rakwa/screens/order/add_address_screen.dart';
import 'package:rakwa/widget/location_search_dialog.dart';

import '../../api/api_controllers/location_controller.dart';
import '../../app_colors/app_colors.dart';
import '../../widget/appbars/app_bars.dart';
import '../../widget/main_elevated_button.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  var location = {'lat': 41.8781, 'lng': -87.6298};

  final Completer<GoogleMapController> controller2 = Completer();
  CameraPosition? cameraPosition;

  Position? pos;


  @override
  void initState(){
    Get.put(LocationController());


      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
        pos = await Geolocator.getCurrentPosition();
        // print(s);
        AllAddressGetxController.to.getPlaceName(pos!.latitude, pos!.longitude);

        setState(() { });
        LocationController.to.setMarker(lat: pos!.latitude, lng: pos!.longitude);

        cameraPosition= CameraPosition(target: LatLng(
            pos!.latitude,pos!.longitude
        ), zoom: 17);

        setState(() { });


    });

    super.initState();


    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
    //
    //
    //   setState(() { });
    // });
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
    //   setState(() { });
    // });


  }

  late GoogleMapController _mapController;
  @override
  Widget build(BuildContext context) {

    return GetBuilder<LocationController>(builder: (locationController){
      return Scaffold(
          // appBar: AppBar(
            appBar: AppBars.appBarDefault(title: "حدد موقعك"),
            // backgroundColor: AppColors().mainColor,
          // ),
          body: cameraPosition == null ? Center(child: CircularProgressIndicator(),) : Stack(
            children: <Widget>[

              GoogleMap(
                markers: locationController.marker,

                  onMapCreated: (GoogleMapController mapController)async {
                    _mapController = mapController;
                    controller2.complete(mapController);

                    // LocationSearchDialog(). _controller.complete(mapController);
                    // final GoogleMapController controller = await controller2.future;
                    // locationController.setMapController(mapController);
                  },
                  myLocationEnabled: false,
                  myLocationButtonEnabled:false,
              // zoomControlsEnabled:false,
              // mapToolbarEnabled:false,
                  onTap: (c){
                  print(c);
                  locationController.setMarker(lat: c.latitude, lng: c.longitude);
                  AllAddressGetxController.to.getPlaceName(c.latitude, c.longitude);
                  AllAddressGetxController.to.latMap.value = c.latitude;
                    AllAddressGetxController.to.longMap.value = c.longitude;
                  },
                  onCameraMove: (c){
                  print(c.target.longitude);
                  print(c.target.latitude);
                  AllAddressGetxController.to.latMap.value = c.target.latitude;
                  AllAddressGetxController.to.longMap.value = c.target.longitude;
                  },
                 onCameraIdle: ()async{
                   // await   AllAddressGetxController.to.getPlaceName(
                   //           AllAddressGetxController.to.latMap.value,
                   //     AllAddressGetxController.to.longMap.value);
                 },

                  initialCameraPosition: cameraPosition!
              ),
              PositionedDirectional(
                  bottom: 120.h,
                  start: 20.w,
                  child: InkWell(
                    onTap: ()async{
                      // print(c);


                       GoogleMapController controller = await controller2.future;

                        pos = await Geolocator.getCurrentPosition();

                          controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
                              target: LatLng(pos!.latitude,
                                  pos!.longitude),
                              zoom: 17)));


                        // cameraPosition= CameraPosition(target: LatLng(
                        //     pos!.latitude,pos!.longitude
                        // ), zoom: 14);
                        locationController.setMarker(lat: pos!.latitude, lng: pos!.longitude);
                        AllAddressGetxController.to.getPlaceName(pos!.latitude, pos!.longitude);
                        AllAddressGetxController.to.latMap.value = pos!.latitude;
                        AllAddressGetxController.to.longMap.value = pos!.longitude;

                      setState(() {

                      });
                    },
                    child: Container(
                      width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade300
                ),
                child: Icon(Icons.my_location),),
                  )),
              PositionedDirectional(
                top: 100.h,
                end: 10.w, start: 20.w,
                child: GestureDetector(
                  onTap:() {
                    Get.dialog(LocationSearchDialog(mapController: _mapController,));
                  },
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(children: [
                      Icon(Icons.location_on, size: 25, color: Theme.of(context).primaryColor),
                      SizedBox(width: 5),
                      //here we show the address on the top
                      Expanded(
                        child: GetX<AllAddressGetxController>(
                          builder: (c) {
                            print(c.longMap);
                            print(c.longMap);
                            return Text(
                              // '${locationController.pickPlaceMark.name ?? ''} ${locationController.pickPlaceMark.locality ?? ''} '
                              //     '${locationController.pickPlaceMark.postalCode ?? ''} ${locationController.pickPlaceMark.country ?? ''}',
                     c.locationController.text
                            ,     style: TextStyle(fontSize: 20),
                              maxLines: 1, overflow: TextOverflow.ellipsis,
                            );
                          }
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.search, size: 25, color: Theme.of(context).textTheme.bodyText1!.color),
                    ]),
                  ),
                ),
              ),
              PositionedDirectional(
                  bottom: 60.h,
                  start: 20.w,
                  end: 20.w,
                  child:  MainElevatedButton(child:
      Text("الاستمرار",
        style: GoogleFonts.notoKufiArabic(
          textStyle:  TextStyle(
            fontSize: 12.sp,
            color: Colors.white,
          ),),), height: 48.h,
    width: Get.width,
    borderRadius: 4.r, onPressed: () {
                Get.to(AddNewAddressScreen());
                    // Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters());
                  })
              )  ],
          )
      );
    },);
  }
}