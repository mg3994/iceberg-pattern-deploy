import 'dart:convert';

import '../../features/catalog/domain/services/schema_reference.dart';

abstract interface class SchemaDocumentFetcher {
  Future<Map<String, dynamic>?> fetch(SchemaReference reference);
}

final class SchemaReferenceResolver {
  const SchemaReferenceResolver();

  SchemaReference resolveId(String base, String idValue) {
    final value = idValue.trim();
    if (value.isEmpty) return const SchemaReference();
    if (_isHttpUrl(value)) {
      final blogger = _parseBloggerUrl(value);
      return blogger ?? SchemaReference(url: value);
    }

    final parts = value.split('/');
    if (parts.length == 2 && parts.every((part) => part.isNotEmpty)) {
      return SchemaReference(blogId: parts[0], postId: parts[1]);
    }
    if (base.contains('/')) {
      final blogId = base.split('/').first;
      if (blogId.isNotEmpty) {
        return SchemaReference(blogId: blogId, postId: value);
      }
    }
    return SchemaReference(url: value);
  }

  Map<String, dynamic> deepMerge(
    Map<String, dynamic> target,
    Map<String, dynamic> source,
  ) {
    final result = Map<String, dynamic>.from(target);
    for (final entry in source.entries) {
      final current = result[entry.key];
      final override = entry.value;
      result[entry.key] =
          current is Map<String, dynamic> && override is Map<String, dynamic>
          ? deepMerge(current, override)
          : override;
    }
    return result;
  }

  Future<Map<String, dynamic>> resolve(
    Map<String, dynamic> schema, {
    required String base,
    required SchemaDocumentFetcher fetcher,
    int maxDepth = 8,
  }) async {
    final copy = jsonDecode(jsonEncode(schema)) as Map<String, dynamic>;
    await _walk(
      copy,
      base: base,
      fetcher: fetcher,
      depth: 0,
      maxDepth: maxDepth,
    );
    return copy;
  }

  Future<void> _walk(
    dynamic node, {
    required String base,
    required SchemaDocumentFetcher fetcher,
    required int depth,
    required int maxDepth,
  }) async {
    if (depth >= maxDepth) return;
    if (node is List<dynamic>) {
      for (final item in node) {
        await _walk(
          item,
          base: base,
          fetcher: fetcher,
          depth: depth,
          maxDepth: maxDepth,
        );
      }
      return;
    }
    if (node is! Map<String, dynamic>) return;

    final rawId = node['@id'] ?? node['id'];
    if (rawId is String && rawId.trim().isNotEmpty) {
      final reference = resolveId(base, rawId);
      final fetched = await fetcher.fetch(reference);
      if (fetched != null) {
        final nestedBase = reference.isBloggerPost
            ? '${reference.blogId}/${reference.postId}'
            : base;
        final resolved = await resolve(
          fetched,
          base: nestedBase,
          fetcher: fetcher,
          maxDepth: maxDepth - depth,
        );
        final localOverrides = Map<String, dynamic>.from(node);
        node
          ..clear()
          ..addAll(deepMerge(resolved, localOverrides));
        return;
      }
    }

    for (final value in List<Object?>.from(node.values)) {
      await _walk(
        value,
        base: base,
        fetcher: fetcher,
        depth: depth + 1,
        maxDepth: maxDepth,
      );
    }
  }

  bool _isHttpUrl(String value) =>
      value.startsWith('http://') || value.startsWith('https://');

  SchemaReference? _parseBloggerUrl(String value) {
    final uri = Uri.tryParse(value);
    if (uri == null || uri.host != 'www.blogger.com') return null;
    final parts = uri.pathSegments;
    final blogIndex = parts.indexOf('feeds');
    if (blogIndex >= 0 && parts.length > blogIndex + 4) {
      return SchemaReference(
        blogId: parts[blogIndex + 1],
        postId: parts[blogIndex + 4],
      );
    }
    return null;
  }
}
