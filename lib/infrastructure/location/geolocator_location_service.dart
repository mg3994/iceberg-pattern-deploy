// ==========================================
// 2. GEOLOCATOR IMPLEMENTATION (geolocator_location_service.dart)
// ==========================================
import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart' as gl;
import 'package:material_ui/material_ui.dart' show Locale;

import '../../core/location/location_service.dart';

class GeolocatorLocationService implements LocationService {
  GeolocatorLocationService([geo.Geocoding? geocoding])
    : _geocoding = geocoding ?? geo.Geocoding();

  final geo.Geocoding _geocoding;

  @override
  Future<bool> isLocationServiceEnabled() =>
      gl.Geolocator.isLocationServiceEnabled();

  @override
  Future<gl.LocationPermission> checkPermissionStatus() =>
      gl.Geolocator.checkPermission();

  @override
  Future<gl.LocationPermission> requestPermission() =>
      gl.Geolocator.requestPermission();

  @override
  Future<bool> openAppSettings() => gl.Geolocator.openAppSettings();

  @override
  Future<bool> openLocationSettings() => gl.Geolocator.openLocationSettings();

  @override
  Future<gl.Position?> getUserCoordinates() async {
    final isEnabled = await isLocationServiceEnabled();
    if (!isEnabled) {
      return null;
    }

    var permissionStatus = await checkPermissionStatus();
    if (permissionStatus == gl.LocationPermission.denied) {
      permissionStatus = await requestPermission();
    }

    if (permissionStatus == gl.LocationPermission.deniedForever ||
        permissionStatus == gl.LocationPermission.unableToDetermine) {
      await openLocationSettings();
      return null;
    }

    if (permissionStatus != gl.LocationPermission.whileInUse &&
        permissionStatus != gl.LocationPermission.always) {
      return null;
    }

    try {
      return await gl.Geolocator.getCurrentPosition(
        locationSettings: const gl.LocationSettings(
          accuracy: gl.LocationAccuracy.high,
        ),
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<gl.Position?> getLastKnownPosition({
    bool forceAndroidLocationManager = false,
  }) => gl.Geolocator.getLastKnownPosition(
    forceAndroidLocationManager: forceAndroidLocationManager,
  );

  @override
  Future<List<geo.Location>> getLocationsFromAddress(
    String address, {
    Locale? locale,
  }) => _geocoding.locationFromAddress(address, locale: locale);

  @override
  Future<List<geo.Placemark>> placemarkFromCoordinates(
    double latitude,
    double longitude, {
    Locale? locale,
  }) =>
      _geocoding.placemarkFromCoordinates(latitude, longitude, locale: locale);

  @override
  Future<List<geo.Placemark>> placemarkFromAddress(
    String address, {
    Locale? locale,
  }) => _geocoding.placemarkFromAddress(address, locale: locale);

  @override
  Future<List<geo.Placemark>> getCurrentLocationAddress({
    Locale? locale,
  }) async {
    try {
      final position = await getUserCoordinates();
      if (position == null) {
        return [];
      }

      return await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
        locale: locale,
      );
    } catch (_) {
      return [];
    }
  }

  @override
  double distanceBetween(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) => gl.Geolocator.distanceBetween(
    startLatitude,
    startLongitude,
    endLatitude,
    endLongitude,
  );

  @override
  double bearingBetween(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) => gl.Geolocator.bearingBetween(
    startLatitude,
    startLongitude,
    endLatitude,
    endLongitude,
  );
}
