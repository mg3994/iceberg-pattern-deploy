import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../features/catalog/data/datasources/catalog_cache_data_source.dart';
import '../../../features/catalog/data/models/store_product_model.dart';
import '../../../features/catalog/domain/entities/catalog_filter.dart';
import '../../../features/catalog/domain/entities/service_area.dart';
import 'app_database.dart';

final class DriftCatalogCache implements CatalogCacheDataSource {
  const DriftCatalogCache(this._database);

  final AppDatabase _database;

  @override
  Future<List<StoreProductModel>> readProducts({
    required CatalogFilter filter,
  }) async {
    if (filter.searchText.isNotEmpty || filter.labels.isNotEmpty) {
      return const [];
    }
    final rows = await _database.select(_database.cachedCatalogProducts).get();
    return rows
        .map(
          (row) => StoreProductModel(
            id: row.id,
            name: row.name,
            description: row.description,
            imageUrl: row.imageUrl,
            price: row.price,
            currency: row.currency,
            sourceUrl: row.sourceUrl,
            serviceAreas: (jsonDecode(row.serviceAreasJson) as List<dynamic>)
                .whereType<Map<String, dynamic>>()
                .map(
                  (area) => ServiceArea(
                    type: area['type'] as String? ?? 'Place',
                    name: area['name'] as String? ?? '',
                  ),
                )
                .toList(growable: false),
            publishedAt: row.publishedAt,
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<void> writeProducts(List<StoreProductModel> products) async {
    await _database.batch((batch) {
      batch.deleteAll(_database.cachedCatalogProducts);
      batch.insertAll(
        _database.cachedCatalogProducts,
        products
            .map(
              (product) => CachedCatalogProductsCompanion.insert(
                id: product.id,
                name: product.name,
                description: product.description,
                imageUrl: Value(product.imageUrl),
                price: Value(product.price),
                currency: Value(product.currency),
                sourceUrl: product.sourceUrl,
                serviceAreasJson: jsonEncode(
                  product.serviceAreas
                      .map((area) => {'type': area.type, 'name': area.name})
                      .toList(growable: false),
                ),
                publishedAt: Value(product.publishedAt),
              ),
            )
            .toList(growable: false),
      );
    });
  }
}
