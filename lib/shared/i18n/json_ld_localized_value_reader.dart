import 'localized_text.dart';

final class JsonLdLocalizedValueReader {
  const JsonLdLocalizedValueReader();

  LocalizedText read(Object? value) {
    if (value is String) return LocalizedText({'und': value});
    if (value is num || value is bool) {
      return LocalizedText({'und': '$value'});
    }
    if (value is Map<String, dynamic>) {
      final text = value['@value'];
      final language = value['@language'];
      if (text != null) {
        return LocalizedText({language?.toString() ?? 'und': '$text'});
      }
    }
    if (value is List<dynamic>) {
      final values = <String, String>{};
      for (final item in value) {
        final localized = read(item);
        values.addAll(localized.values);
      }
      return LocalizedText(values);
    }
    return const LocalizedText({});
  }
}
