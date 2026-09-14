import '../../domain/entities/store_product.dart';
import '../../domain/entities/service_area.dart';

final class StoreProductModel {
  const StoreProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.currency,
    required this.sourceUrl,
    required this.serviceAreas,
    this.publishedAt,
  });

  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final double? price;
  final String? currency;
  final String sourceUrl;
  final List<ServiceArea> serviceAreas;
  final DateTime? publishedAt;

  StoreProduct toEntity() => StoreProduct(
    id: id,
    name: name,
    description: description,
    imageUrl: imageUrl,
    price: price,
    currency: currency,
    sourceUrl: sourceUrl,
    serviceAreas: serviceAreas,
    publishedAt: publishedAt,
  );
}
