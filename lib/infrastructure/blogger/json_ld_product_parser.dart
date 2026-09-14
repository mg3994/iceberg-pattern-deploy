import '../../features/catalog/data/models/store_product_model.dart';
import '../../features/catalog/domain/entities/service_area.dart';
import '../../shared/i18n/json_ld_localized_value_reader.dart';
import 'json_ld_document_extractor.dart';

final class JsonLdProductParser {
  const JsonLdProductParser({
    this.localizedValueReader = const JsonLdLocalizedValueReader(),
    this.documentExtractor = const JsonLdDocumentExtractor(),
  });

  final JsonLdLocalizedValueReader localizedValueReader;
  final JsonLdDocumentExtractor documentExtractor;

  List<StoreProductModel> parse(Object? source, {String languageCode = 'en'}) {
    final documents = _decodeDocuments(source);
    final products = documents.expand(_findProducts);
    return products
        .map((value) => _toModel(value, languageCode))
        .whereType<StoreProductModel>()
        .toList(growable: false);
  }

  Iterable<Map<String, dynamic>> _decodeDocuments(Object? source) {
    return documentExtractor.extract(source);
  }

  Iterable<Map<String, dynamic>> _findProducts(Map<String, dynamic> document) {
    final graph = document['@graph'];
    final values = graph is List<dynamic>
        ? graph.whereType<Map<String, dynamic>>()
        : <Map<String, dynamic>>[document];
    return values.where(_isProduct);
  }

  bool _isProduct(Map<String, dynamic> value) {
    final type = value['@type'];
    if (type is String) return type.toLowerCase() == 'product';
    if (type is List<dynamic>) {
      return type.any((item) => item.toString().toLowerCase() == 'product');
    }
    return false;
  }

  StoreProductModel? _toModel(Map<String, dynamic> value, String languageCode) {
    final name = localizedValueReader.read(value['name']).resolve(languageCode);
    if (name.trim().isEmpty) return null;

    final offer = value['offers'];
    final offerMap = offer is Map<String, dynamic>
        ? offer
        : offer is List<dynamic> && offer.firstOrNull is Map<String, dynamic>
        ? offer.first as Map<String, dynamic>
        : const <String, dynamic>{};
    final priceValue = offerMap['price'] ?? value['price'];
    final price = priceValue is num
        ? priceValue.toDouble()
        : double.tryParse('$priceValue');
    final description = localizedValueReader
        .read(value['description'])
        .resolve(languageCode);
    final image = value['image'];
    final imageUrl = image is String
        ? image
        : image is List<dynamic> && image.firstOrNull is String
        ? image.first as String
        : null;

    final areas = _serviceAreas(value['areaServed'], languageCode);
    final publishedAt = DateTime.tryParse(
      value['datePublished']?.toString() ?? '',
    )?.toLocal();

    return StoreProductModel(
      id: '${value['sku'] ?? value['productID'] ?? value['url'] ?? name}',
      name: name,
      description: description,
      imageUrl: imageUrl,
      price: price,
      currency: offerMap['priceCurrency'] as String?,
      sourceUrl: value['url'] as String? ?? '',
      serviceAreas: areas,
      publishedAt: publishedAt,
    );
  }

  List<ServiceArea> _serviceAreas(Object? value, String languageCode) {
    final values = value is List<dynamic> ? value : <Object?>[value];
    return values
        .whereType<Map<String, dynamic>>()
        .map((area) {
          final type = area['@type']?.toString() ?? 'Place';
          final name = localizedValueReader
              .read(area['name'])
              .resolve(languageCode);
          return ServiceArea(type: type, name: name);
        })
        .where((area) => area.name.isNotEmpty)
        .toList(growable: false);
  }
}
