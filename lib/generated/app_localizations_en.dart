// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get languageName => 'English';

  @override
  String get appName => 'BlogStore';

  @override
  String get helloWorld => 'Hello World!';

  @override
  String pronoun(String gender) {
    String _temp0 = intl.Intl.selectLogic(gender, {
      'male': 'he',
      'female': 'she',
      'other': 'they',
    });
    return '$_temp0';
  }

  @override
  String welcomeUser(String userName) {
    return 'Welcome back, $userName!';
  }

  @override
  String postCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# posts',
      one: '1 post',
      zero: 'No posts yet',
    );
    return '$_temp0';
  }

  @override
  String readingTime(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '# minutes read',
      one: '1 minute read',
      zero: 'Less than a minute',
    );
    return '$_temp0';
  }

  @override
  String searchResults(int count, String query) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# results for \"$query\"',
      one: '1 result for \"$query\"',
      zero: 'No results for \"$query\"',
    );
    return '$_temp0';
  }

  @override
  String authorRole(String role) {
    String _temp0 = intl.Intl.selectLogic(role, {
      'author': 'Author',
      'editor': 'Editor',
      'admin': 'Administrator',
      'other': 'Member',
    });
    return '$_temp0';
  }

  @override
  String articlePrice(double amount) {
    final intl.NumberFormat amountNumberFormat =
        intl.NumberFormat.compactCurrency(locale: localeName);
    final String amountString = amountNumberFormat.format(amount);

    return 'Price: $amountString';
  }

  @override
  String publishedDate(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Published $dateString';
  }

  @override
  String publishedTime(DateTime time) {
    final intl.DateFormat timeDateFormat = intl.DateFormat.jm(localeName);
    final String timeString = timeDateFormat.format(time);

    return 'Published at $timeString';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get searchSettings => 'Search settings';

  @override
  String get noSettingsFound => 'No settings found';

  @override
  String get settingsGeneralTitle => 'General';

  @override
  String get settingsGeneralSubtitle => 'Profile, preferences';

  @override
  String get settingsAppearanceTitle => 'Appearance';

  @override
  String get settingsAppearanceSubtitle => 'Theme, colors, language';

  @override
  String get settingsNotificationsTitle => 'Notifications';

  @override
  String get settingsNotificationsSubtitle => 'Alerts, sounds';

  @override
  String get settingsPrivacyTitle => 'Privacy & Security';

  @override
  String get settingsPrivacySubtitle => 'Passwords, access';
}
