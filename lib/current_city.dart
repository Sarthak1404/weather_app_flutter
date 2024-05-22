import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

Future<String> getCurrentCity() async{
    if (kDebugMode) {
      print('inside getCurrentCity..');
    }
    //permission
    if (kDebugMode) {
      print('checking permissions..');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if( permission == LocationPermission.denied){
      if (kDebugMode) {
        print('permissions denied..');
      }
      if (kDebugMode) {
        print('requested permissions again..');
      }
      permission = await Geolocator.requestPermission(); 
    }

    if (kDebugMode) {
      print('permissions granted..');
    }
    if (kDebugMode) {
      print('fetching city..');
    }
    //fetch location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    //convert to cityname
    String? city = placemarks[0].locality;

    if (kDebugMode) {
      print('CurrentCity is $city ..');
    }
    return city??'';
  }