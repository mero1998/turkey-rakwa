import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:rakwa/api/api_controllers/list_api_controller.dart';
import 'package:rakwa/controller/all_address_getx_controller.dart';
import 'package:rakwa/controller/list_controller.dart';
import 'package:rakwa/model/autocomplete_model.dart';
import 'package:rakwa/model/city_model.dart';
import 'package:rakwa/model/country_model.dart';
import 'package:rakwa/model/create_item_model.dart';
import 'package:rakwa/model/paid_items_model.dart';
import 'package:rakwa/screens/add_listing_screens/Controllers/add_work_controller.dart';
import 'package:rakwa/screens/add_listing_screens/Widget/bottom_sheet_city.dart';
import 'package:rakwa/screens/add_listing_screens/Widget/bottom_sheet_country.dart';
import 'package:rakwa/screens/add_listing_screens/Widget/bottom_sheet_state.dart';
import 'package:rakwa/screens/add_listing_screens/add_list_images_screen.dart';
import 'package:rakwa/screens/add_listing_screens/add_list_subcategory_screen.dart';
import 'package:rakwa/screens/add_listing_screens/add_list_work_days_screen.dart';
import 'package:rakwa/screens/address/map_screen.dart';
import 'package:rakwa/screens/google_maps_services/places_service.dart';
import 'package:rakwa/Core/utils/helpers.dart';
import 'package:rakwa/widget/TextFields/text_field_default.dart';
import 'package:rakwa/widget/TextFields/validator.dart';
import 'package:rakwa/widget/appbars/app_bars.dart';
import 'package:rakwa/widget/main_elevated_button.dart';
import 'package:rakwa/widget/my_text_field.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:shimmer/shimmer.dart';

import '../../app_colors/app_colors.dart';
import '../../widget/next_step_button.dart';
import '../../widget/steps_widget.dart';
import '../google_maps_services/place_search.dart';

class AddNewAddressScreen extends StatefulWidget {

  @override
  State<AddNewAddressScreen> createState() => _AddNewAddressScreenState();
}

final homeScaffoldKey = GlobalKey<ScaffoldState>();
final searchScaffoldKey = GlobalKey<ScaffoldState>();

class _AddNewAddressScreenState extends State<AddNewAddressScreen>
    with Helpers {
  Mode _mode = Mode.overlay;


  List<PlaceSearch>? searchResults = [];

  var kGoogleApiKey = "AIzaSyBauBUw7ABmSkqpsx0yLM73Eqehz1guZS0";

  final Set<Marker> _marker = {};
  var location = {'lat': 41.8781, 'lng': -87.6298};
  final Completer<GoogleMapController> _controller = Completer();

  GlobalKey<FormState> key= GlobalKey<FormState>();
  TextEditingController buildName = TextEditingController();
  TextEditingController buildNumber = TextEditingController();
  TextEditingController floor = TextEditingController();
  TextEditingController block = TextEditingController();
  TextEditingController apartment = TextEditingController();

  Future<void> moveCamera() async {
    final GoogleMapController controller = await _controller.future;
    controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(AllAddressGetxController.to.latMyLocation,
            AllAddressGetxController.to.longMyLocation),
    zoom: 14)));
  }

  bool value = true;

  bool businessIs = true;

  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  Set<Marker> allMarkers = <Marker>{};
   late CameraPosition myLocation;

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);
  List latLong = [
    '31.5219406,34.453096',
    '31.407038,34.3297314',
    '31.2795339,34.2931137',
    '31.5325508,34.4523132',
  ];


  changeMarkerTap(double lat, double long) {
    allMarkers.add(Marker(
      markerId: MarkerId('change'),
      position: LatLng(lat, long),
    ));
    setState(() {

    });
  }


  @override
  void initState() {

    Get.put(AllAddressGetxController());

    // TODO: implement initState
    myLocation = CameraPosition(
      target: LatLng(AllAddressGetxController.to.latMyLocation, AllAddressGetxController.to.longMyLocation),
      zoom: 14.4746,
    );
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    var node = FocusScope.of(context);
    // AllAddressGetxController.to.locationController.text = "";
    var box = GetStorage();
    print(box.read("token"));
    // ListController listController = Get.put(ListController());
    // Get.put(AddWorkOrAdsController(isList: true));
    // AddWorkOrAdsController addWordController = Get.find();
    // var node = FocusScope.of(context);
    // print(addWordController.lng);
    return Scaffold(
        appBar: AppBars.appBarDefault(title: "اضافة عنوان جديد",),

        body: GetX<AllAddressGetxController>(
        builder: (c) {
          print(c.locationController.text);
          print(c.addresses.length);
          // return Stack(
          //   children: [
          //     // _info == null
          //     //     ? CircularProgressIndicator()
          //     //     :
          //     GoogleMap(
          //       myLocationEnabled: true,
          //       mapType: MapType.terrain,
          //       // markers: allMarkers,
          //       // polylines: {
          //       //   if (_info != null)
          //       //     Polyline(
          //       //       polylineId: const PolylineId('overview_polyline'),
          //       //       color: const Color(0xFF027A8A),
          //       //       width: 5,
          //       //       points: _info!.polylinePoints
          //       //           .map((e) => LatLng(e.latitude, e.longitude))
          //       //           .toList(),
          //       //     ),
          //       // },
          //       // onTap: (argument) {
          //       //   changeMarkerTap(argument.latitude, argument.longitude);
          //       // },
          //       onCameraMove: (position) {
          //         c.latMap.value = position.target.latitude;
          //         c.longMap.value = position.target.longitude;
          //         c.loadAddress.value = true;
          //       },
          //       onCameraIdle: () async {
          //         await c.getPlaceName(
          //             c.latMap.value,
          //             c.longMap.value);
          //         c.loadAddress.value = false;
          //       },
          //       initialCameraPosition: myLocation,
          //       onMapCreated: (GoogleMapController controller) {
          //         _controller.complete(controller);
          //       },
          //     ),
          //     PositionedDirectional(
          //       top: 50.h,
          //       start: 0,
          //       end: 0,
          //       child: Padding(
          //         padding:  EdgeInsets.symmetric(horizontal: 16.w),
          //         child: Form(
          //           key: key,
          //           child: Column(
          //             children: [
          //               TextFieldDefault(
          //                 hint: 'ادخل الموقع',
          //                 suffixIconUrl: "location",
          //                 controller: c.locationController,
          //                 keyboardType: TextInputType.text,
          //                 onChanged: (p0) {
          //                   setState(() {
          //                     value = true;
          //                   });
          //
          //                 },
          //                 onComplete: () {
          //                   node.nextFocus();
          //                 },
          //               ),
          //               c.locationController.text.isNotEmpty && value
          //                   ? Container(
          //                 color: Colors.white,
          //                 height: 150.h,
          //                 child: FutureBuilder<List<AutoCompleteModel>>(
          //                   future: ListApiController()
          //                       .getAddress(input: c.locationController.text),
          //                   builder: (context, snapshot) {
          //                     if (snapshot.connectionState ==
          //                         ConnectionState.waiting) {
          //                       return ListView.builder(
          //                           physics: const BouncingScrollPhysics(),
          //                           itemBuilder: (context, index) {
          //                             return Shimmer.fromColors(
          //                                 baseColor: Colors.grey.shade100,
          //                                 highlightColor: Colors.grey.shade300,
          //                                 child: const ListTile(
          //                                   title: Text(''),
          //                                 ));
          //                           },
          //                           itemCount: 4);
          //                     } else if (snapshot.hasData &&
          //                         snapshot.data!.isNotEmpty) {
          //                       return ListView.separated(
          //                           padding: EdgeInsets.zero,
          //                           physics: const BouncingScrollPhysics(),
          //                           itemBuilder: (context, index) {
          //                             return ListTile(
          //                               onTap: () async {
          //                                 setState(() {
          //                                   c.locationController.text =
          //                                       snapshot.data![index].description ??
          //                                           '';
          //                                   value = false;
          //                                 });
          //                                 location = await ListApiController()
          //                                     .getAddressDetails(
          //                                     id: snapshot.data![index].placeId ??
          //                                         '');
          //                                 _setMarker(
          //                                     lat: double.parse(
          //                                         location['lat'].toString()),
          //                                     lng: double.parse(
          //                                         location['lng'].toString()));
          //                                 moveCamera();
          //                                 c.getPlaceName(c.latMyLocation, c.longMyLocation);
          //                                 c.latMyLocation = double.parse(
          //                                     location['lat'].toString());
          //                                 c.longMyLocation = double.parse(
          //                                     location['lng'].toString());
          //                                 print(location['lat'].toString());
          //                                 print(location['lng'].toString());
          //                               },
          //                               leading: const Icon(Icons.location_pin),
          //                               title: Text(
          //                                   snapshot.data![index].description ?? ''),
          //                             );
          //                           },
          //                           separatorBuilder: (context, index) {
          //                             return Divider(
          //                               color: Colors.grey.shade300,
          //                               thickness: 1,
          //                             );
          //                           },
          //                           itemCount: snapshot.data!.length);
          //                     } else {
          //                       print(snapshot.data!);
          //                       print('====================================');
          //                       Fluttertoast.showToast(msg: "لم يتم العثور علي العنوان، يرجى تحديده على الخريطة", backgroundColor: Colors.black.withOpacity(0.64));
          //
          //                       return Visibility(
          //                           visible: false,
          //                           child: const Text('لا توجد بيانات'));
          //                     }
          //                   },
          //                 ),
          //               )
          //                   : SizedBox(),
          //
          //               SizedBox(height: 15.h,),
          //               TextFieldDefault(hint: "اسم البناء",controller: buildName,
          //                 validation: (value){
          //                 if(value!.isEmpty){
          //                   return "هذا الحقل اجباري";
          //                 }else{
          //                   return null;
          //                 }
          //               },),
          //               SizedBox(height: 15.h,),
          //
          //               SizedBox(
          //                 height: 70.h,
          //                 child: Row(
          //                   children: [
          //                     Expanded(
          //                       child: SizedBox(
          //                           width: Get.width / 2,
          //                           child: TextFieldDefault(hint: "رقم البناء",controller: buildNumber,)),
          //                     ),
          //                     Expanded(
          //                       child: SizedBox(
          //                           width: Get.width / 2,
          //                           child: TextFieldDefault(hint: "الطابق",controller: floor,
          //                               validation: (value){
          //                                 if(value!.isEmpty){
          //                                   return "هذا الحقل اجباري";
          //                                 }else{
          //                                   return null;
          //                                 }
          //                               })),
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //               SizedBox(
          //                 height: 68.h,
          //                 child: Row(
          //                   children: [
          //                     Expanded(
          //                       child: SizedBox(
          //                           width: Get.width / 2,
          //                           child: TextFieldDefault(hint: "رقم الشقة",
          //                               controller: apartment,
          //                               validation: (value){
          //                                 if(value!.isEmpty){
          //                                   return "هذا الحقل اجباري";
          //                                 }else{
          //                                   return null;
          //                                 }
          //                               })),
          //                     ),
          //                     Expanded(
          //                       child: SizedBox(
          //                           width: Get.width / 2,
          //                           child: TextFieldDefault(hint: "البلوك",controller: block,)),
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //     // PositionedDirectional(
          //     //     top: 50.h,
          //     //     start: 0,
          //     //     end: 0,
          //     //     child: Padding(
          //     //       padding: EdgeInsets.symmetric(horizontal: 16.w),
          //     //       child: MyTextField(hint: "اضف عنوانك", controller: locationController, onChanged: (value) async{
          //     //
          //     //        var locations = await locationFromAddress(value);
          //     //        print(locations.first.latitude);
          //     //        print(locations.first.longitude);
          //     //         c.longMyLocation = locations.first.latitude;
          //     //         c.latMyLocation =locations.first.longitude;
          //     //        // await ListApiController()
          //     //        //     .getAddressDetails(
          //     //        //     id: snapshot.data![index].placeId ??
          //     //        //         '');
          //     //        c.getPlaceName(c.latMyLocation, c.longMyLocation);
          //     //
          //     //        moveCamera();
          //     //       },),
          //     //     )),
          //
          //     Positioned(
          //       top: 0,
          //       bottom: 0,
          //       left: 0,
          //       right: 0,
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           // Image.asset(
          //           //   'assets/images/shopping-basket.png',
          //           //   height: 50,
          //           //   width: 50,
          //           //   color: Colors.white,
          //           // ),
          //           Icon(Icons.location_on_rounded, size: 35.w, color: AppColors().mainColor,),
          //         ],
          //       ),
          //     ),
          //     Positioned(
          //       bottom: 10,
          //       left: 0,
          //       right: 0,
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           c.loadAddress.value
          //               ? CircularProgressIndicator()
          //               : MainElevatedButton(child: Text("اضافة"),
          //               height: 48.h,
          //               width: Get.width / 4,
          //               borderRadius: 7.r,
          //               onPressed: (){
          //                 if(key.currentState!.validate()){
          //                   c.addAddress(apartment: apartment.text, floor: floor.text, buildName: buildName.text
          //                       ,buildNumber: buildNumber.text,
          //                       block: block.text
          //                   );
          //
          //                 }
          //
          //               }),
          //         ],
          //       ),
          //     ),
          //     // if (_info != null)
          //     //   Padding(
          //     //     padding: EdgeInsets.only(top: 40.0),
          //     //     child: Row(
          //     //       mainAxisAlignment: MainAxisAlignment.center,
          //     //       children: [
          //     //         Container(
          //     //           padding: const EdgeInsets.symmetric(
          //     //             vertical: 6.0,
          //     //             horizontal: 12.0,
          //     //           ),
          //     //           decoration: BoxDecoration(
          //     //             color: Colors.yellowAccent,
          //     //             borderRadius: BorderRadius.circular(20.0),
          //     //             boxShadow: const [
          //     //               BoxShadow(
          //     //                 color: Colors.black26,
          //     //                 offset: Offset(0, 2),
          //     //                 blurRadius: 6.0,
          //     //               )
          //     //             ],
          //     //           ),
          //     //           child: Text(
          //     //             '${_info!.totalDistance}, ${_info!.totalDuration}',
          //     //             style: const TextStyle(
          //     //               fontSize: 18.0,
          //     //               fontFamily: 'Gotham Pro',
          //     //               fontWeight: FontWeight.w600,
          //     //             ),
          //     //           ),
          //     //         ),
          //     //         SizedBox()
          //     //       ],
          //     //     ),
          //     //   ),
          //   ],
          // );

          return ListView(
            children: [
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 16.w,vertical: 40.h),
                child: Form(
                  key: key,
                  child: Column(
                    children: [
                          // Stack(
                          //   children: [
                          //
                          //     InkWell(
                          //       onTap: () => Get.to(MapScreen()),
                          //       child: SizedBox(
                          //         height: 120.h,
                          //         child: AbsorbPointer(
                          //           absorbing: true,
                          //           child: GoogleMap(
                          //             // myLocationEnabled: true,
                          //             liteModeEnabled: false,
                          //             mapType: MapType.terrain,
                          //             onTap: (c){
                          //               return null;
                          //             },
                          //             // markers: allMarkers,
                          //             // polylines: {
                          //             //   if (_info != null)
                          //             //     Polyline(
                          //             //       polylineId: const PolylineId('overview_polyline'),
                          //             //       color: const Color(0xFF027A8A),
                          //             //       width: 5,
                          //             //       points: _info!.polylinePoints
                          //             //           .map((e) => LatLng(e.latitude, e.longitude))
                          //             //           .toList(),
                          //             //     ),
                          //             // },
                          //             // onTap: (argument) {
                          //             //   changeMarkerTap(argument.latitude, argument.longitude);
                          //             // },
                          //             // onCameraMove: (position) {
                          //             //   c.latMap.value = position.target.latitude;
                          //             //   c.longMap.value = position.target.longitude;
                          //             //   c.loadAddress.value = true;
                          //             // },
                          //             // onCameraIdle: () async {
                          //             //   await c.getPlaceName(
                          //             //       c.latMap.value,
                          //             //       c.longMap.value);
                          //             //   c.loadAddress.value = false;
                          //             // },
                          //             initialCameraPosition: myLocation,
                          //             onMapCreated: (GoogleMapController controller) {
                          //               _controller.complete(controller);
                          //             },
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //     InkWell(
                          //       onTap: () => Get.to(MapScreen()),
                          //       child: Container(
                          //         height: 120.h,
                          //         color: Colors.black.withOpacity(0.50),
                          //       child:       Padding(
                          //         padding:  EdgeInsets.only(top: 30.h),
                          //         child: Center(
                          //           child: Text("اضغط هنا لتحديد موقعك على الخريطة",
                          //               style: GoogleFonts.notoKufiArabic(
                          //                 textStyle:  TextStyle(
                          //                     fontSize: 12.sp,
                          //                     fontWeight: FontWeight.bold,
                          //                     color:Colors.white
                          //                 ),)),
                          //         ),
                          //       ),
                          //       ),
                          //     ),
                          //
                          //   ],
                          // ),
                      SizedBox(height: 15.h,),
                      TextFieldDefault(
                        hint: 'ادخل الموقع',
                        suffixIconUrl: "location",
                        controller: c.locationController,
                        keyboardType: TextInputType.text,
                        enable: false,
                        validation: (val){
                          if(val!.isEmpty){
                            return "هذا الحقل اجباري";
                          }else{
                            return null;
                          }
                        },
                      ),
                      // c.locationController.text.isNotEmpty && value
                      //     ? Container(
                      //   color: Colors.white,
                      //   height: 150.h,
                      //   child: FutureBuilder<List<AutoCompleteModel>>(
                      //     future: ListApiController()
                      //         .getAddress(input: c.locationController.text),
                      //     builder: (context, snapshot) {
                      //       if (snapshot.connectionState ==
                      //           ConnectionState.waiting) {
                      //         return ListView.builder(
                      //             physics: const BouncingScrollPhysics(),
                      //             itemBuilder: (context, index) {
                      //               return Shimmer.fromColors(
                      //                   baseColor: Colors.grey.shade100,
                      //                   highlightColor: Colors.grey.shade300,
                      //                   child: const ListTile(
                      //                     title: Text(''),
                      //                   ));
                      //             },
                      //             itemCount: 4);
                      //       } else if (snapshot.hasData &&
                      //           snapshot.data!.isNotEmpty) {
                      //         return ListView.separated(
                      //             padding: EdgeInsets.zero,
                      //             physics: const BouncingScrollPhysics(),
                      //             itemBuilder: (context, index) {
                      //               return ListTile(
                      //                 onTap: () async {
                      //                   setState(() {
                      //                     c.locationController.text =
                      //                         snapshot.data![index].description ??
                      //                             '';
                      //                     value = false;
                      //                   });
                      //                   location = await ListApiController()
                      //                       .getAddressDetails(
                      //                       id: snapshot.data![index].placeId ??
                      //                           '');
                      //                   _setMarker(
                      //                       lat: double.parse(
                      //                           location['lat'].toString()),
                      //                       lng: double.parse(
                      //                           location['lng'].toString()));
                      //                   moveCamera();
                      //                   c.getPlaceName(c.latMyLocation, c.longMyLocation);
                      //                   c.latMyLocation = double.parse(
                      //                       location['lat'].toString());
                      //                   c.longMyLocation = double.parse(
                      //                       location['lng'].toString());
                      //                   print(location['lat'].toString());
                      //                   print(location['lng'].toString());
                      //                 },
                      //                 leading: const Icon(Icons.location_pin),
                      //                 title: Text(
                      //                     snapshot.data![index].description ?? ''),
                      //               );
                      //             },
                      //             separatorBuilder: (context, index) {
                      //               return Divider(
                      //                 color: Colors.grey.shade300,
                      //                 thickness: 1,
                      //               );
                      //             },
                      //             itemCount: snapshot.data!.length);
                      //       } else {
                      //         print(snapshot.data!);
                      //         print('====================================');
                      //         Fluttertoast.showToast(msg: "لم يتم العثور علي العنوان، يرجى تحديده على الخريطة", backgroundColor: Colors.black.withOpacity(0.64));
                      //
                      //         return Visibility(
                      //             visible: false,
                      //             child: const Text('لا توجد بيانات'));
                      //       }
                      //     },
                      //   ),
                      // )
                      //     : SizedBox(),

                      SizedBox(height: 15.h,),
                      TextFieldDefault(hint: "اسم البناء",controller: buildName,
                        validation: (value){
                          if(value!.isEmpty){
                            return "هذا الحقل اجباري";
                          }else{
                            return null;
                          }
                        },),
                      SizedBox(height: 15.h,),

                      SizedBox(
                        height: 70.h,
                        child: Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                  width: Get.width / 2,
                                  child: TextFieldDefault(hint: "رقم البناء",controller: buildNumber,)),
                            ),
                            Expanded(
                              child: SizedBox(
                                  width: Get.width / 2,
                                  child: TextFieldDefault(hint: "الطابق",controller: floor,
                                      validation: (value){
                                        if(value!.isEmpty){
                                          return "هذا الحقل اجباري";
                                        }else{
                                          return null;
                                        }
                                      })),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 68.h,
                        child: Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                  width: Get.width / 2,
                                  child: TextFieldDefault(hint: "رقم الشقة",
                                      controller: apartment,
                                      validation: (value){
                                        if(value!.isEmpty){
                                          return "هذا الحقل اجباري";
                                        }else{
                                          return null;
                                        }
                                      })),
                            ),
                            Expanded(
                              child: SizedBox(
                                  width: Get.width / 2,
                                  child: TextFieldDefault(hint: "البلوك",controller: block,)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 16.w),
                child: MainElevatedButton(child: Text("اضافة"),
                          height: 48.h,
                          width: Get.width / 4,
                          borderRadius: 7.r,
                          onPressed: (){
                            if(key.currentState!.validate()){
                              c.addAddress(apartment: apartment.text, floor: floor.text, buildName: buildName.text
                                  ,buildNumber: buildNumber.text,
                                  block: block.text,

                              );}
                              }),
              )
          //
            ],
          );
        }
      )
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToTheLake,
      //   label: Text('To the lake!'),
      //   icon: Icon(Icons.directions_boat),
      // ),
    );
  }

  void _setMarker({required double lat, required double lng}) {
    setState(() {
      _marker.add(Marker(
        markerId: const MarkerId('value'),
        position: LatLng(lat, lng),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }


  //
  // CreateItemModel get createItemModel {
  //   CreateItemModel createItemModel = widget.createItemModel;
  //   createItemModel.countryId = countryID.toString();
  //   createItemModel.stateId = stateID.toString();
  //   createItemModel.cityId = cityID.toString();
  //   createItemModel.itemLat = location['lat'];
  //   createItemModel.itemLng = location['lng'];
  //   createItemModel.itemAddress = _locationController.text;
  //   createItemModel.itemHourTimeZone = _locationController.text;
  //
  //   return createItemModel;
  // }
}
