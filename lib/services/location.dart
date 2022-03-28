import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocode/geocode.dart';
import 'package:verbyl_project/services/data.dart';

class PositionAndBool {
  final Position position;
  final bool isLocationDenied;
  PositionAndBool(this.position, this.isLocationDenied);
}

class StringAndBool {
  final String address;
  final bool isLocationDenied;
  StringAndBool(this.address, this.isLocationDenied);
}

//bool isLocationDenied = false;
// String address = "";

Future<PositionAndBool> _determinePosition() async {
  bool isLocationDenied = false;
  bool serviceEnabled;
  LocationPermission permission;
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    permission = await Geolocator.requestPermission();
    //return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error('Location permissions are permanently denied, we cannot request permissions.');
  }
  if(permission == LocationPermission.denied) isLocationDenied = true;
  debugPrint("isLocationDenied : " + isLocationDenied.toString());
  return PositionAndBool(await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium), isLocationDenied);
}

Future<StringAndBool> getLocation() async {
  String address = "";
  bool b = true;
  // if(verbylUserLocation != "" && isLocationPermissionDenied){
  //   return StringAndBool(verbylUserLocation, false);
  // }
  try{
    GeoCode geoCode = GeoCode();
    PositionAndBool positionAndBool = await _determinePosition();
    var adr = await geoCode.reverseGeocoding(
        latitude: positionAndBool.position.latitude,
        longitude: positionAndBool.position.longitude
    );
    b = positionAndBool.isLocationDenied;
    address = adr.region!;
    await uploadCity(address).then((value){
      return StringAndBool(address,b);
    });
    debugPrint(adr.toString());
    return StringAndBool(address,b);
  }
  catch(e){
    //print("Location services are disabled");
    print(e);
  }
  return StringAndBool(address,b);
}

