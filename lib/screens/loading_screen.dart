import 'package:personal_assistant/screens/homepage.dart';
import 'location.dart';
import 'package:geolocator/geolocator.dart';


class LoadingScreen {

  Location location = Location();
  late double lat;
  late double long;

  Future<void> fetchLocation() async {
    try {
      Position position = await location.determinePosition();
      lat = position.latitude;
      long = position.longitude;
      print(lat);
    } catch (e) {
      // Handle errors
      print('Error fetching location: $e');
    }
  }

}