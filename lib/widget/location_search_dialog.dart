import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

import '../api/api_controllers/list_api_controller.dart';
import '../api/api_controllers/location_controller.dart';
import '../controller/all_address_getx_controller.dart';

class LocationSearchDialog extends StatefulWidget {
  final GoogleMapController? mapController;
  // final Completer<GoogleMapController> controller;

  LocationSearchDialog({required this.mapController,});

  @override
  State<LocationSearchDialog> createState() => _LocationSearchDialogState();
}

class _LocationSearchDialogState extends State<LocationSearchDialog> {

  // Future<void> moveCamera({required double lat, required double lng}) async {
  //   final GoogleMapController controller = await widget.controller.future;
  //   controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
  //       target: LatLng(lat,
  //           lng),
  //       zoom: 14)));
  // }


  var location = {};

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();

    // AllAddressGetxController.to.locationController.clear();
    return Container(
      margin: EdgeInsets.only(top : 150),
      padding: EdgeInsets.all(5),
      alignment: Alignment.topCenter,
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: SizedBox(width: 350, child: TypeAheadField(
          textFieldConfiguration: TextFieldConfiguration(
            controller: _controller,
            textInputAction: TextInputAction.search,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            keyboardType: TextInputType.streetAddress,
            decoration: InputDecoration(
              hintText: 'search_location',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(style: BorderStyle.none, width: 0),
              ),
              hintStyle: Theme.of(context).textTheme.headline2?.copyWith(
                fontSize: 16, color: Theme.of(context).disabledColor,
              ),
              filled: true, fillColor: Theme.of(context).cardColor,
            ),
            style: Theme.of(context).textTheme.headline2?.copyWith(
              color: Colors.black, fontSize: 20,
            ),
          ),
          suggestionsCallback: (pattern) async {
            return await Get.find<LocationController>().searchLocation(context, pattern);
          },
          itemBuilder: (context, Prediction suggestion) {
            return Padding(
              padding: EdgeInsets.all(10),
              child: Row(children: [
                Icon(Icons.location_on),
                Expanded(
                  child: Text("${suggestion.description!}", maxLines: 4, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.headline2?.copyWith(
                    color: Theme.of(context).textTheme.bodyText1?.color, fontSize: 20,
                  )),
                ),
              ]),
            );
          },
          onSuggestionSelected: (Prediction suggestion) async {
            location = await ListApiController()
                .getAddressDetails(
                id: suggestion.placeId ??
                    '');
            // _setMarker(
            //     lat: double.parse(
            //         location['lat'].toString()),
            //     lng: double.parse(
            //         location['lng'].toString()));
            print("My location is "+suggestion.description!);
            widget.mapController!.moveCamera(CameraUpdate.newLatLng(LatLng(
                double.parse(
                location['lat'].toString()), double.parse(
                location['lng'].toString()))));

            LocationController.to.setMarker(lat:  double.parse(
                location['lat'].toString()), lng: double.parse(
                location['lng'].toString()));
            // AllAddressGetxController.to.getPlaceName(double.parse(
            //     location['lat'].toString()), double.parse(
            //     location['lng'].toString()));

            AllAddressGetxController.to.locationController.text = suggestion.description ?? "";
            //Get.find<LocationController>().setLocation(suggestion.placeId!, suggestion.description!, mapController);
            Get.back();
            // Get.back();
          },
        )),
      ),
    );
  }


}