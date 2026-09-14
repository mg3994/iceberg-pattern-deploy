import 'user_location.dart';

final class CatalogFilter {
  const CatalogFilter({
    this.searchText = '',
    this.labels = const [],
    this.languageCode = 'en',
    this.country,
    this.state,
    this.city,
    this.postalCode,
    this.location,
  });

  final String searchText;
  final List<String> labels;
  final String languageCode;
  final String? country;
  final String? state;
  final String? city;
  final String? postalCode;
  final UserLocation? location;

  factory CatalogFilter.fromSearch(String input, {String languageCode = 'en'}) {
    final parsed = PowerSearchParser().parse(input);
    return CatalogFilter(
      searchText: parsed.text,
      labels: parsed.labels,
      languageCode: languageCode,
    );
  }
}

final class ParsedPowerSearch {
  const ParsedPowerSearch({required this.text, required this.labels});

  final String text;
  final List<String> labels;
}

final class PowerSearchParser {
  static final _labelPattern = RegExp(
    r'label:(?:"([^"]+)"|([^\s|]+))',
    caseSensitive: false,
  );

  const PowerSearchParser();

  ParsedPowerSearch parse(String input) {
    final labels = <String>[];
    for (final match in _labelPattern.allMatches(input)) {
      final value = (match.group(1) ?? match.group(2))?.trim();
      if (value != null && value.isNotEmpty) labels.add(value);
    }
    final text = input
        .replaceAll(_labelPattern, ' ')
        .replaceAll('|', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    return ParsedPowerSearch(labels: List.unmodifiable(labels), text: text);
  }
}
