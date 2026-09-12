import '../build_mode/build_mode.dart' show BuildMode;
import '../config/config.dart' show Flavor, FlavorConfig;

/// A type alias for the application's flavor and build-mode configuration.
///
/// Example:
/// ```
/// final AppFlavorConfig appFlavorConfig = FlavorConfig(
///   flavor: Flavor.fromString(
///     const String.fromEnvironment('FLAVOR', defaultValue: 'production'),
///   ),
///   buildMode: BuildMode.current,
/// );
/// ```
///

typedef AppFlavorConfig = FlavorConfig<Flavor, BuildMode>;

/// The flavor this app was built with.
///
/// This is equivalent to the value argued to the `--flavor` option at build time.
/// This will be `null` if the `--flavor` option was not provided.
const String appFlavor = String.fromEnvironment(
  'FLUTTER_APP_FLAVOR',
  defaultValue: 'production',
);