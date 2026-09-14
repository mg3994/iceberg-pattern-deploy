// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get languageName => 'हिन्दी';

  @override
  String get appName => 'ब्लॉगस्टोर';

  @override
  String get helloWorld => 'नमस्ते दुनिया!';

  @override
  String pronoun(String gender) {
    String _temp0 = intl.Intl.selectLogic(gender, {
      'male': 'वह',
      'female': 'वह',
      'other': 'वे',
    });
    return '$_temp0';
  }

  @override
  String welcomeUser(String userName) {
    return 'पुनः स्वागत है, $userName!';
  }

  @override
  String postCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# पोस्ट',
      one: '1 पोस्ट',
      zero: 'कोई पोस्ट नहीं',
    );
    return '$_temp0';
  }

  @override
  String readingTime(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '# मिनट की पठन अवधि',
      one: '1 मिनट की पठन अवधि',
      zero: 'एक मिनट से भी कम',
    );
    return '$_temp0';
  }

  @override
  String searchResults(int count, String query) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '\"$query\" के लिए # परिणाम',
      one: '\"$query\" के लिए 1 परिणाम',
      zero: '\"$query\" के लिए कोई परिणाम नहीं',
    );
    return '$_temp0';
  }

  @override
  String authorRole(String role) {
    String _temp0 = intl.Intl.selectLogic(role, {
      'author': 'लेखक',
      'editor': 'संपादक',
      'admin': 'प्रशासक',
      'other': 'सदस्य',
    });
    return '$_temp0';
  }

  @override
  String articlePrice(double amount) {
    final intl.NumberFormat amountNumberFormat =
        intl.NumberFormat.compactCurrency(locale: localeName);
    final String amountString = amountNumberFormat.format(amount);

    return 'मूल्य: $amountString';
  }

  @override
  String publishedDate(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'प्रकाशित $dateString';
  }

  @override
  String publishedTime(DateTime time) {
    final intl.DateFormat timeDateFormat = intl.DateFormat.jm(localeName);
    final String timeString = timeDateFormat.format(time);

    return 'प्रकाशित समय $timeString';
  }

  @override
  String get settingsTitle => 'सेटिंग्स';

  @override
  String get searchSettings => 'सेटिंग्स खोजें';

  @override
  String get noSettingsFound => 'कोई सेटिंग्स नहीं मिलीं';

  @override
  String get settingsGeneralTitle => 'सामान्य';

  @override
  String get settingsGeneralSubtitle => 'प्रोफ़ाइल, प्राथमिकतियाँ';

  @override
  String get settingsAppearanceTitle => 'उपस्थिति';

  @override
  String get settingsAppearanceSubtitle => 'थीम, रंग, भाषा';

  @override
  String get settingsNotificationsTitle => 'सूचनाएं';

  @override
  String get settingsNotificationsSubtitle => 'अलर्ट, ध्वनियाँ';

  @override
  String get settingsPrivacyTitle => 'गोपनीयता और सुरक्षा';

  @override
  String get settingsPrivacySubtitle => 'पासवर्ड, पहुंच';
}
