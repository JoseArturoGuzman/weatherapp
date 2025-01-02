import 'package:geolocator/geolocator.dart';

class Location{
  var latitude;
  var longitude;

  Future<void> getCurrentPosition() async {
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.low,
      distanceFilter: 100,
    );
    try{
      LocationPermission permission = await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition( locationSettings: locationSettings);
      latitude = position.latitude;
      longitude = position.longitude;
    }
    catch (e){
      print(e);
    }
  }

}