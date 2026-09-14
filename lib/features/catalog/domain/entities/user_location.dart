final class UserLocation {
  const UserLocation({
    required this.country,
    this.state,
    this.city,
    this.postalCode,
    this.latitude,
    this.longitude,
  });

  final String country;
  final String? state;
  final String? city;
  final String? postalCode;
  final double? latitude;
  final double? longitude;
}
