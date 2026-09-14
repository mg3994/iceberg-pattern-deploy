import '../entities/store_product.dart';
import '../entities/catalog_filter.dart';

abstract interface class CatalogRepository {
  Future<List<StoreProduct>> getProducts({
    CatalogFilter filter = const CatalogFilter(),
    bool forceRefresh = false,
  });
}
