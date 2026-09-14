import '../entities/service_area.dart';
import '../entities/user_location.dart';

final class CatalogServiceability {
  const CatalogServiceability();

  bool isServiceable({
    required List<ServiceArea> areas,
    required UserLocation location,
  }) {
    if (areas.isEmpty) return true;
    return areas.any((area) => _matches(area, location: location));
  }

  bool _matches(ServiceArea area, {required UserLocation location}) {
    final type = area.type.toLowerCase();
    final name = area.name.trim().toLowerCase();
    if (type == 'country') {
      return name == location.country.trim().toLowerCase();
    }
    if (type == 'state' || type == 'administrativearea') {
      return location.state != null &&
          name == location.state!.trim().toLowerCase();
    }
    if (type == 'city' || type == 'locality') {
      return location.city != null &&
          name == location.city!.trim().toLowerCase();
    }
    if (type == 'postalcode') {
      return location.postalCode != null &&
          name == location.postalCode!.trim().toLowerCase();
    }
    return name == location.city?.trim().toLowerCase() ||
        name == location.state?.trim().toLowerCase();
  }
}
