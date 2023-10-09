import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:rakwa/Core/utils/extensions.dart';

Future<Position?> getLocation() async {
  LocationPermission permission;

  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    permission =  await Geolocator.requestPermission();
    return Future.error('Location services are disabled.');
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.deniedForever) {
      permission =  await Geolocator.requestPermission();

      return Future.error(
          Exception('Location permissions are permanently denied.'));
    }

    if (permission == LocationPermission.denied) {
      permission =  await Geolocator.requestPermission();

      return Future.error(Exception('Location permissions are denied.'));
    }
  }
  printDM("permission is => $permission");
  //LocationPermission.whileInUse
  return await Geolocator.getCurrentPosition();
  // Location location = new Location();
  //
  // bool _serviceEnabled;
  // PermissionStatus _permissionGranted;
  // LocationData _locationData;
  //
  // _serviceEnabled = await location.serviceEnabled();
  // print("we are here 2");
  // if (!_serviceEnabled) {
  //   _serviceEnabled = await location.requestService();
  //   // if (!_serviceEnabled) {
  //   //   return null;
  //   // }
  // }
  // print("we are here 3333");
  //
  // _permissionGranted = await location.hasPermission();
  // if (_permissionGranted == PermissionStatus.denied) {
  //   // _serviceEnabled = await location.requestService();
  //   print("we are here 222");
  //
  //   _permissionGranted = await location.requestPermission();
  //   _serviceEnabled = await location.requestService();
  //
  //   if (_permissionGranted != PermissionStatus.granted) {
  //     return null;
  //   }
  //
  // }
  //
  // _locationData = await location.getLocation();
}
