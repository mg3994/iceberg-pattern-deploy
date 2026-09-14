// ==========================================
// 1. LOCATION SERVICE INTERFACE (location_service.dart)
// ==========================================
import 'package:geocoding/geocoding.dart' show Placemark, Location;
import 'package:geolocator/geolocator.dart' as gl;
import 'package:material_ui/material_ui.dart' show Locale;

abstract class LocationService {
  /// Checks whether location services are enabled on the device.
  Future<bool> isLocationServiceEnabled();

  /// Checks the current location permission status.
  Future<gl.LocationPermission> checkPermissionStatus();

  /// Requests location permission from the user.
  Future<gl.LocationPermission> requestPermission();

  /// Opens the app settings screen.
  Future<bool> openAppSettings();

  /// Opens the device location settings screen.
  Future<bool> openLocationSettings();

  /// Retrieves the current device coordinates after handling permissions and service checks.
  Future<gl.Position?> getUserCoordinates();

  /// Retrieves the last known cached position on the device without requesting a new location fix.
  Future<gl.Position?> getLastKnownPosition({
    bool forceAndroidLocationManager = false,
  });

  /// Performs forward geocoding for a given address string.
  Future<List<Location>> getLocationsFromAddress(
    String address, {
    Locale? locale,
  });

  /// Performs reverse geocoding for given latitude and longitude coordinates.
  Future<List<Placemark>> placemarkFromCoordinates(
    double latitude,
    double longitude, {
    Locale? locale,
  });

  /// Performs reverse geocoding for a given address string.
  Future<List<Placemark>> placemarkFromAddress(
    String address, {
    Locale? locale,
  });

  /// Gets the user's current device position and attempts reverse geocoding to return placemarks.
  Future<List<Placemark>> getCurrentLocationAddress({Locale? locale});

  /// Calculates the distance in meters between two geographical points.
  double distanceBetween(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  );

  /// Calculates the initial bearing in degrees between two geographical points.
  double bearingBetween(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  );
}
