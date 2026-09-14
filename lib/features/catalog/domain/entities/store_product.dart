import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'service_area.dart';

/// Pure Dart 3 Record Typedef representation of StoreProduct entity.
typedef StoreProduct = ({
  String id,
  String name,
  String description,
  String? imageUrl,
  double? price,
  String? currency,
  String sourceUrl,
  IList<ServiceArea> serviceAreas,
  DateTime? publishedAt,
});
