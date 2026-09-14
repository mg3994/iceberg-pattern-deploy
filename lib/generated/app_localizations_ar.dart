// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get languageName => 'العربية';

  @override
  String get appName => 'متجر المدونات';

  @override
  String get helloWorld => 'أهلاً بالعالم!';

  @override
  String pronoun(String gender) {
    String _temp0 = intl.Intl.selectLogic(gender, {
      'male': 'هو',
      'female': 'هي',
      'other': 'هم',
    });
    return '$_temp0';
  }

  @override
  String welcomeUser(String userName) {
    return 'مرحباً بك مجدداً، $userName!';
  }

  @override
  String postCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count منشور',
      many: '$count منشوراً',
      few: '$count منشورات',
      one: 'منشور واحد',
      zero: 'لا توجد منشورات بعد',
    );
    return '$_temp0';
  }

  @override
  String readingTime(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'قراءة لمدة $minutes دقيقة',
      many: 'قراءة لمدة $minutes دقيقة',
      few: 'قراءة لمدة $minutes دقائق',
      one: 'قراءة لمدة دقيقة واحدة',
      zero: 'أقل من دقيقة',
    );
    return '$_temp0';
  }

  @override
  String searchResults(int count, String query) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count نتيجة لـ \"$query\"',
      many: '$count نتيجة لـ \"$query\"',
      few: '$count نتائج لـ \"$query\"',
      one: 'نتيجة واحدة لـ \"$query\"',
      zero: 'لا توجد نتائج لـ \"$query\"',
    );
    return '$_temp0';
  }

  @override
  String authorRole(String role) {
    String _temp0 = intl.Intl.selectLogic(role, {
      'author': 'مؤلف',
      'editor': 'محرر',
      'admin': 'مسؤول',
      'other': 'عضو',
    });
    return '$_temp0';
  }

  @override
  String articlePrice(double amount) {
    final intl.NumberFormat amountNumberFormat =
        intl.NumberFormat.compactCurrency(locale: localeName);
    final String amountString = amountNumberFormat.format(amount);

    return 'السعر: $amountString';
  }

  @override
  String publishedDate(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'نُشر في $dateString';
  }

  @override
  String publishedTime(DateTime time) {
    final intl.DateFormat timeDateFormat = intl.DateFormat.jm(localeName);
    final String timeString = timeDateFormat.format(time);

    return 'نُشر في تمام الساعة $timeString';
  }

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get searchSettings => 'البحث في الإعدادات';

  @override
  String get noSettingsFound => 'لم يتم العثور على إعدادات';

  @override
  String get settingsGeneralTitle => 'عام';

  @override
  String get settingsGeneralSubtitle => 'الملف الشخصي، التفضيلات';

  @override
  String get settingsAppearanceTitle => 'المظهر';

  @override
  String get settingsAppearanceSubtitle => 'المظهر، الألوان، اللغة';

  @override
  String get settingsNotificationsTitle => 'الإشعارات';

  @override
  String get settingsNotificationsSubtitle => 'التنبيهات، الأصوات';

  @override
  String get settingsPrivacyTitle => 'الخصوصية والأمان';

  @override
  String get settingsPrivacySubtitle => 'كلمات المرور، الوصول';
}
