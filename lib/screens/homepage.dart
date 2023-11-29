import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'loading_screen.dart';
import '../calculation/calculation.dart';
import '../calculation/do_not_distrub.dart';
import 'package:flutter_dnd/flutter_dnd.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late double lat = 0.0;
  late double long = 0.0;

  final TextEditingController _placeController = TextEditingController();
  String _latitude = '';
  String _longitude = '';
  List<Map<String, dynamic>> _savedLocations = [];

  // Instance of Calculation class
  Calculation calculation = Calculation();

  void checkProximityToSavedLocations() {
    // Assuming 'lat' and 'long' are user's current latitude and longitude
    bool isNear = calculation.isNearSavedLocation(lat, long, _savedLocations);
    if (isNear) {

      FlutterDnd.setInterruptionFilter(FlutterDnd.INTERRUPTION_FILTER_NONE);

      // Perform action when user is near a saved location
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Alert'),
            content: Text('You are near a saved location!'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _getUserLocation() async {
    LoadingScreen loadingScreen = LoadingScreen();
    try {
      await loadingScreen.fetchLocation();
      setState(() {
        lat = loadingScreen.lat;
        long = loadingScreen.long;
      });
    } catch (e) {
      print('Error fetching location: $e');
    }
  }

  Future<void> _getLatLongFromPlace() async {
    try {
      List<Location> locations = await locationFromAddress(_placeController.text);
      if (locations.isNotEmpty) {
        double enteredLocationLat = locations[0].latitude;
        double enteredLocationLong = locations[0].longitude;

        // Calculate distance between user's current location and entered location
        double distanceInMeters = calculation.calculateDistanceInMeters(
            lat, long, enteredLocationLat, enteredLocationLong);

        // Print the distance (you can use it as needed)
        print('Distance between locations: $distanceInMeters meters');

        setState(() {
          _latitude = enteredLocationLat.toString();
          _longitude = enteredLocationLong.toString();

          // Add location details to the list
          _savedLocations.add({
            'placeName': _placeController.text,
            'latitude': _latitude,
            'longitude': _longitude,
            'distance': distanceInMeters, // Store the distance in the saved location data
          });

          // Clear the text field after saving the location
          _placeController.clear();
        });
      } else {
        setState(() {
          _latitude = 'Not found';
          _longitude = 'Not found';
        });
      }
    } catch (e) {
      setState(() {
        _latitude = 'Error';
        _longitude = 'Error';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Personal Assistant'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextField(
                  controller: _placeController,
                  decoration: InputDecoration(
                    hintText: 'Enter place name',
                    labelText: 'Place',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _getLatLongFromPlace,
                child: const Text('Add the place to your list'),

              ),
              const SizedBox(height: 20),
              Text('My Current Latitude: ${lat ?? 'Loading...'}'),
              Text('My Current Longitude: ${long ?? 'Loading...'}'),
              SizedBox(height: 20),
              Text('Added Locations:'),
              Expanded(
                child: ListView.builder(
                  itemCount: _savedLocations.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text(_savedLocations[index]['placeName']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Latitude: ${double.parse(_savedLocations[index]['latitude']).toStringAsFixed(2)}',
                            ),
                            Text(
                              'Longitude: ${double.parse(_savedLocations[index]['longitude']).toStringAsFixed(2)}',
                            ),
                            Text(
                              'Distance: ${double.parse(_savedLocations[index]['distance'].toString()).toStringAsFixed(2)} meters',
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _savedLocations.removeAt(index);
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),

              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Call the method when needed (e.g., button press)
            checkProximityToSavedLocations();
          },
          tooltip: 'Check Proximity',
          child: Icon(Icons.check),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _placeController.dispose();
    super.dispose();
  }

}