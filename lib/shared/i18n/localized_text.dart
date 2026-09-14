final class LocalizedText {
  const LocalizedText(this.values);

  final Map<String, String> values;

  String resolve(String languageCode, {String fallbackLanguage = 'en'}) {
    return values[languageCode] ??
        values[fallbackLanguage] ??
        values.values.firstOrNull ??
        '';
  }
}
