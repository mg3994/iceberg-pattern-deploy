import 'package:material_ui/material_ui.dart' show Locale, ThemeMode;

abstract final class AppConfig {
  static const defaultThemeMode = ThemeMode.system;
  static const defaultThemeSeedColorHex = 0xFF3F51B5;
  static const defaultLocale = Locale.fromSubtags(languageCode: 'en');
  static const blogId = String.fromEnvironment(
    'BLOG_ID',
    defaultValue: '1774904866501098696',
  );

  static const bloggerFeedsBaseUrl = 'https://www.blogger.com/feeds';
  static const bloggerV3BaseUrl = 'https://www.googleapis.com/blogger/v3';
  static const sharedApiBaseUrl = 'https://api.antinna.in';

  static const publicCatalogPath = '/$blogId/posts/default';
  static const authenticatedCatalogPath = '/blogs/$blogId/posts';
  static const sharedCatalogPath = '/catalog';

  static const publicApiBaseUrl = bloggerFeedsBaseUrl;
  static const authenticatedApiBaseUrl = bloggerV3BaseUrl;
}
