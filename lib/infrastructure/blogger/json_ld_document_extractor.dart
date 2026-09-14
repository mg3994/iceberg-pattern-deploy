import 'dart:convert';

final class JsonLdDocumentExtractor {
  const JsonLdDocumentExtractor();

  List<Map<String, dynamic>> extract(Object? source) {
    final values = _values(source);
    return values
        .map(_decode)
        .expand((value) => value is List<dynamic> ? value : <Object?>[value])
        .whereType<Map<String, dynamic>>()
        .toList(growable: false);
  }

  Iterable<Object?> _values(Object? source) {
    if (source is Map<String, dynamic> || source is List<dynamic>) {
      return <Object?>[source];
    }
    if (source is! String) return const [];

    final scripts = RegExp(
      r'''<script[^>]*type=["']application/ld\+json["'][^>]*>(.*?)</script>''',
      caseSensitive: false,
      dotAll: true,
    ).allMatches(source).map((match) => match.group(1));
    return scripts.isEmpty ? <Object?>[source] : scripts;
  }

  Object? _decode(Object? value) {
    if (value is! String) return value;
    final cleaned = _decodeEntities(value)
        .replaceAll(RegExp(r'/\*[\s\S]*?\*/'), '')
        .trim();
    try {
      return jsonDecode(cleaned);
    } on FormatException {
      final start = cleaned.indexOf('{');
      final end = cleaned.lastIndexOf('}');
      if (start < 0 || end <= start) return null;
      try {
        return jsonDecode(cleaned.substring(start, end + 1));
      } on FormatException {
        return null;
      }
    }
  }

  String _decodeEntities(String value) => value
      .replaceAll('&quot;', '"')
      .replaceAll('&amp;', '&')
      .replaceAll('&#39;', "'")
      .replaceAll('&apos;', "'")
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>');
}
