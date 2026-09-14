import '../models/store_product_model.dart';
import '../../domain/entities/catalog_filter.dart';

abstract interface class CatalogCacheDataSource {
  Future<List<StoreProductModel>> readProducts({required CatalogFilter filter});

  Future<void> writeProducts(List<StoreProductModel> products);
}
