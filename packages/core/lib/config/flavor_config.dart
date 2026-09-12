import '../build_mode/build_mode_interface.dart';
import '../flavor/flavor_interface.dart';

final class FlavorConfig<
F extends FlavorInterface,
B extends BuildModeInterface
> {
  const FlavorConfig({required this.flavor, required this.buildMode});

  final F flavor;
  final B buildMode;

  String get baseUrl => flavor.baseUrl;
}