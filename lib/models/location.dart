// /for longtude and latidude current location.....
import 'package:geolocator/geolocator.dart';

String location = "";
late String latitude;
late String longitude;

Future<String> getLocation() async {
  location = latitude = longitude = "";

  await getCurrentLocation();

  if (latitude.isNotEmpty && longitude.isNotEmpty) {
    location = "$latitude,$longitude";
  }
  print("$location#####");
  return location;
}

Future<void> getCurrentLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Check if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    Geolocator.openLocationSettings();
    print('Location services are disabled.');
    return;
  }

  // Check location permissions.
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print('Location permissions are denied');
      return;
    }
  } else if (permission == LocationPermission.deniedForever) {
    print(
        'Location permissions are permanently denied, we cannot request permissions.');
    return;
  }

  // Get the current location.
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  latitude = position.latitude.toString();
  longitude = position.longitude.toString();
}
