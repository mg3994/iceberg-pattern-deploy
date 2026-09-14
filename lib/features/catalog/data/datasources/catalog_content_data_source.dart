import '../models/store_product_model.dart';
import '../../domain/entities/catalog_filter.dart';

abstract interface class CatalogContentDataSource {
  Future<List<StoreProductModel>> loadProducts({required CatalogFilter filter});
}
