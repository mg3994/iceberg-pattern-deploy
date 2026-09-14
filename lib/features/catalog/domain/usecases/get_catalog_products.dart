import '../entities/store_product.dart';
import '../entities/catalog_filter.dart';
import '../repositories/catalog_repository.dart';

final class GetCatalogProducts {
  const GetCatalogProducts(this._repository);

  final CatalogRepository _repository;

  Future<List<StoreProduct>> call({
    CatalogFilter filter = const CatalogFilter(),
    bool forceRefresh = false,
  }) {
    return _repository.getProducts(filter: filter, forceRefresh: forceRefresh);
  }
}
