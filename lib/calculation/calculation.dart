import 'dart:math' show atan2, cos, pi, pow, sin, sqrt;

class Calculation {

  double calculateDistanceInMeters(
      double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371000; // Radius of the Earth in meters
    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);

    double a = pow(sin(dLat / 2), 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            pow(sin(dLon / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c;

    return distance;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  bool isNearSavedLocation(
    double userLat,
    double userLong,
    List<Map<String, dynamic>> savedLocations,
  ) {
    const double radius = 6371000; // Earth's radius in meters
    const double distanceThreshold = 500.0; // Threshold distance in meters

    for (var location in savedLocations) {
      double savedLat = double.tryParse(location['latitude']) ?? 0.0;
      double savedLong = double.tryParse(location['longitude']) ?? 0.0;

      double latDistance = _toRadians(savedLat - userLat);
      double longDistance = _toRadians(savedLong - userLong);

      double a = pow(sin(latDistance / 2), 2) +
          cos(_toRadians(userLat)) *
              cos(_toRadians(savedLat)) *
              pow(sin(longDistance / 2), 2);

      double c = 2 * atan2(sqrt(a), sqrt(1 - a));
      double distance = radius * c;

      if (distance <= distanceThreshold) {
        return true; // User is near this location
      }
    }
    return false; // User is not near any saved location
  }

  double _toRadians(double degree) {
    return degree * (pi / 180);
  }
}
