import '../../domain/entities/store_product.dart';
import '../../domain/entities/catalog_filter.dart';
import '../../domain/services/catalog_serviceability.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../datasources/catalog_cache_data_source.dart';
import '../datasources/catalog_content_data_source.dart';
import '../models/store_product_model.dart';

final class CatalogRepositoryImpl implements CatalogRepository {
  const CatalogRepositoryImpl(this._content, this._cache, this._serviceability);

  final CatalogContentDataSource _content;
  final CatalogCacheDataSource _cache;
  final CatalogServiceability _serviceability;

  @override
  Future<List<StoreProduct>> getProducts({
    CatalogFilter filter = const CatalogFilter(),
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh) {
      final cached = await _cache.readProducts(filter: filter);
      if (cached.isNotEmpty) {
        return _filter(
          cached,
          filter,
        ).map((product) => product.toEntity()).toList(growable: false);
      }
    }

    final remote = await _content.loadProducts(filter: filter);
    await _cache.writeProducts(remote);
    return _filter(
      remote,
      filter,
    ).map((product) => product.toEntity()).toList(growable: false);
  }

  List<StoreProductModel> _filter(
    List<StoreProductModel> products,
    CatalogFilter filter,
  ) {
    final location = filter.location;
    if (location == null) return products;
    return products
        .where(
          (product) => _serviceability.isServiceable(
            areas: product.serviceAreas,
            location: location,
          ),
        )
        .toList(growable: false);
  }
}
