import '../flavor/flavor_interface.dart';

class Flavor implements FlavorInterface {
  static const Flavor development = Flavor._(
    baseUrl: String.fromEnvironment(
      'DEV_BLOGGER_URL',
      defaultValue: 'https://api.dev.yourdomain.com',
    ),
  );

  static const Flavor staging = Flavor._(
    baseUrl: String.fromEnvironment(
      'STG_BLOGGER_URL',
      defaultValue: 'https://api.stg.yourdomain.com',
    ),
  );

  static const Flavor production = Flavor._(
    baseUrl: String.fromEnvironment(
      'PROD_BLOGGER_URL',
      defaultValue: 'https://api.prod.yourdomain.com',
    ),
  );

  static Flavor fromString(String? value) {
    return switch (value?.toLowerCase()) {
      'dev' || 'development' => development,
      'stg' || 'staging' => staging,
      'prod' || 'production' => production,
      _ => production,
    };
  }

  const Flavor._({required this.baseUrl});

  @override
  final String baseUrl;

  String get name {
    if (identical(this, development)) return 'development';
    if (identical(this, staging)) return 'staging';
    return 'production';
  }
}