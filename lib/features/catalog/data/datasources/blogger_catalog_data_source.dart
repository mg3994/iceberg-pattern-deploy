import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_scope.dart';
import '../../../../infrastructure/blogger/json_ld_product_parser.dart';
import '../models/store_product_model.dart';
import '../../domain/entities/catalog_filter.dart';
import 'catalog_content_data_source.dart';

final class BloggerCatalogDataSource implements CatalogContentDataSource {
  const BloggerCatalogDataSource({
    required this.client,
    required this.path,
    required this.scope,
    this.parser = const JsonLdProductParser(),
  });

  final ApiClient client;
  final String path;
  final ApiScope scope;
  final JsonLdProductParser parser;

  @override
  Future<List<StoreProductModel>> loadProducts({
    required CatalogFilter filter,
  }) async {
    final requestPath = scope == ApiScope.public && filter.labels.isNotEmpty
        ? '$path/-/${filter.labels.map(Uri.encodeComponent).join('/')}'
        : path;
    final data = await client.get(
      requestPath,
      queryParameters: <String, dynamic>{
        if (scope == ApiScope.public) 'alt': 'json',
        if (filter.searchText.isNotEmpty) 'q': filter.searchText,
        if (scope == ApiScope.authenticated && filter.labels.isNotEmpty)
          'labels': filter.labels.join(','),
      },
    );
    return _parseResponse(data, languageCode: filter.languageCode);
  }

  List<StoreProductModel> _parseResponse(
    Object? data, {
    required String languageCode,
  }) {
    if (data is Map<String, dynamic>) {
      final feed = data['feed'];
      if (feed is Map<String, dynamic>) {
        return _parseEntries(feed['entry'], languageCode);
      }
      return _parseEntries(data['items'], languageCode);
    }
    return parser.parse(data, languageCode: languageCode);
  }

  List<StoreProductModel> _parseEntries(
    Object? rawEntries,
    String languageCode,
  ) {
    if (rawEntries is! List<dynamic>) return const [];
    return rawEntries
        .whereType<Map<String, dynamic>>()
        .expand((entry) {
          final content = entry['content'];
          final value = content is Map<String, dynamic>
              ? content['\$t']
              : entry['content'];
          return parser.parse(value, languageCode: languageCode);
        })
        .toList(growable: false);
  }
}
