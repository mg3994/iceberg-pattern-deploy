import '../../../../config/app_config.dart';
import '../../../../core/auth/access_token_provider.dart';
import '../../../../core/network/api_client.dart';
import '../../../../infrastructure/blogger/json_ld_document_extractor.dart';
import '../../domain/entities/catalog_filter.dart';
import '../models/blogger_post_model.dart';
import 'blogger_posts_data_source.dart';

final class BloggerPostsDataSourceImpl implements BloggerPostsDataSource {
  const BloggerPostsDataSourceImpl({
    required this.publicClient,
    required this.authenticatedClient,
    required this.accessTokenProvider,
    this.documentExtractor = const JsonLdDocumentExtractor(),
  });

  final ApiClient publicClient;
  final ApiClient authenticatedClient;
  final AccessTokenProvider accessTokenProvider;
  final JsonLdDocumentExtractor documentExtractor;

  @override
  Future<List<BloggerPostModel>> fetchPosts(CatalogFilter filter) async {
    final token = await accessTokenProvider.getAccessToken();
    if (token != null && token.isNotEmpty) {
      final data = await authenticatedClient.get(
        AppConfig.authenticatedCatalogPath,
        queryParameters: <String, dynamic>{
          'maxResults': 20,
          if (filter.searchText.isNotEmpty) 'q': filter.searchText,
          if (filter.labels.isNotEmpty) 'labels': filter.labels.join(','),
        },
      );
      return _mapV3Posts(data, filter.languageCode);
    }

    final path = filter.labels.isEmpty
        ? AppConfig.publicCatalogPath
        : '${AppConfig.publicCatalogPath}/-/${filter.labels.map(Uri.encodeComponent).join('/')}';
    final data = await publicClient.get(
      path,
      queryParameters: <String, dynamic>{
        'alt': 'json',
        'max-results': 20,
        if (filter.searchText.isNotEmpty) 'q': filter.searchText,
      },
    );
    return _mapFeedPosts(data, filter.languageCode);
  }

  @override
  Future<BloggerPostModel?> fetchPost({required String postId}) async {
    final token = await accessTokenProvider.getAccessToken();
    if (token != null && token.isNotEmpty) {
      final data = await authenticatedClient.get(
        '/blogs/${AppConfig.blogId}/posts/$postId',
      );
      return data is Map<String, dynamic>
          ? _mapV3Post(data, AppConfig.blogId)
          : null;
    }

    final data = await publicClient.get(
      '/${AppConfig.blogId}/posts/default/$postId',
      queryParameters: const {'alt': 'json'},
    );
    if (data is! Map<String, dynamic>) return null;
    final entry = data['entry'];
    return entry is Map<String, dynamic>
        ? _mapFeedPost(entry, AppConfig.blogId)
        : null;
  }

  List<BloggerPostModel> _mapFeedPosts(Object? data, String languageCode) {
    if (data is! Map<String, dynamic>) return const [];
    final feed = data['feed'];
    if (feed is! Map<String, dynamic>) return const [];
    final entries = feed['entry'];
    if (entries is! List<dynamic>) return const [];
    return entries
        .whereType<Map<String, dynamic>>()
        .map((entry) => _mapFeedPost(entry, AppConfig.blogId, languageCode))
        .toList(growable: false);
  }

  List<BloggerPostModel> _mapV3Posts(Object? data, String languageCode) {
    if (data is! Map<String, dynamic>) return const [];
    final items = data['items'];
    if (items is! List<dynamic>) return const [];
    return items
        .whereType<Map<String, dynamic>>()
        .map((item) => _mapV3Post(item, AppConfig.blogId, languageCode))
        .toList(growable: false);
  }

  BloggerPostModel _mapFeedPost(
    Map<String, dynamic> entry,
    String blogId, [
    String languageCode = 'en',
  ]) {
    final rawId = _text(entry['id']);
    final postId = rawId.split('post-').last.split('/').last;
    return BloggerPostModel(
      blogId: blogId,
      postId: postId,
      title: _text(entry['title']),
      content: _text(entry['content']),
      labels: _labels(entry['category']),
      publishedAt: DateTime.tryParse(_text(entry['published']))?.toLocal(),
      updatedAt: DateTime.tryParse(_text(entry['updated']))?.toLocal(),
      sourceUrl: _alternateUrl(entry['link']),
      schema: _schema(entry['content']),
    );
  }

  BloggerPostModel _mapV3Post(
    Map<String, dynamic> item,
    String blogId, [
    String languageCode = 'en',
  ]) {
    final content = _text(item['content']);
    return BloggerPostModel(
      blogId: blogId,
      postId: _text(item['id']),
      title: _text(item['title']),
      content: content,
      labels:
          (item['labels'] as List<dynamic>?)?.whereType<String>().toList() ??
          const [],
      publishedAt: DateTime.tryParse(_text(item['published']))?.toLocal(),
      updatedAt: DateTime.tryParse(_text(item['updated']))?.toLocal(),
      sourceUrl: item['url'] as String?,
      schema: _schema(content),
    );
  }

  Map<String, dynamic>? _schema(Object? content) {
    final documents = documentExtractor.extract(content);
    return documents.isEmpty ? null : documents.first;
  }

  String _text(Object? value) {
    if (value is String) return value;
    if (value is Map<String, dynamic>) return value['\$t']?.toString() ?? '';
    return value?.toString() ?? '';
  }

  List<String> _labels(Object? value) => value is List<dynamic>
      ? value
            .whereType<Map<String, dynamic>>()
            .map((item) => _text(item['term']))
            .where((item) => item.isNotEmpty)
            .toList()
      : const [];

  String? _alternateUrl(Object? value) {
    if (value is! List<dynamic>) return null;
    for (final item in value.whereType<Map<String, dynamic>>()) {
      if (item['rel'] == 'alternate') return item['href'] as String?;
    }
    return null;
  }
}
