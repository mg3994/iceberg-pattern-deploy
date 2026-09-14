import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart' deferred as app_localizations_ar;
import 'app_localizations_en.dart' deferred as app_localizations_en;
import 'app_localizations_hi.dart' deferred as app_localizations_hi;

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('hi'),
  ];

  /// Native display name of the language
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageName;

  /// The name of the application
  ///
  /// In en, this message translates to:
  /// **'BlogStore'**
  String get appName;

  /// The conventional newborn programmer greeting
  ///
  /// In en, this message translates to:
  /// **'Hello World!'**
  String get helloWorld;

  /// A pronoun selected by gender
  ///
  /// In en, this message translates to:
  /// **'{gender, select, male{he} female{she} other{they}}'**
  String pronoun(String gender);

  /// A personalized greeting for a signed-in user
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {userName}!'**
  String welcomeUser(String userName);

  /// The number of posts in a catalog
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No posts yet} =1{1 post} other{# posts}}'**
  String postCount(int count);

  /// The estimated reading time for a blog post
  ///
  /// In en, this message translates to:
  /// **'{minutes, plural, =0{Less than a minute} =1{1 minute read} other{# minutes read}}'**
  String readingTime(int minutes);

  /// A search result summary with a nested string placeholder
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No results for \"{query}\"} =1{1 result for \"{query}\"} other{# results for \"{query}\"}}'**
  String searchResults(int count, String query);

  /// A readable label for a user's role
  ///
  /// In en, this message translates to:
  /// **'{role, select, author{Author} editor{Editor} admin{Administrator} other{Member}}'**
  String authorRole(String role);

  /// A localized numeric article price
  ///
  /// In en, this message translates to:
  /// **'Price: {amount}'**
  String articlePrice(double amount);

  /// A blog post publication date formatted for the current locale
  ///
  /// In en, this message translates to:
  /// **'Published {date}'**
  String publishedDate(DateTime date);

  /// A blog post publication time formatted for the current locale
  ///
  /// In en, this message translates to:
  /// **'Published at {time}'**
  String publishedTime(DateTime time);

  /// Title for the settings section
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Placeholder text for searching settings
  ///
  /// In en, this message translates to:
  /// **'Search settings'**
  String get searchSettings;

  /// Message displayed when search returns no matching settings
  ///
  /// In en, this message translates to:
  /// **'No settings found'**
  String get noSettingsFound;

  /// Title for general settings category
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settingsGeneralTitle;

  /// Subtitle describing general settings content
  ///
  /// In en, this message translates to:
  /// **'Profile, preferences'**
  String get settingsGeneralSubtitle;

  /// Title for appearance settings category
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearanceTitle;

  /// Subtitle describing appearance settings content
  ///
  /// In en, this message translates to:
  /// **'Theme, colors, language'**
  String get settingsAppearanceSubtitle;

  /// Title for notifications settings category
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotificationsTitle;

  /// Subtitle describing notifications settings content
  ///
  /// In en, this message translates to:
  /// **'Alerts, sounds'**
  String get settingsNotificationsSubtitle;

  /// Title for privacy & security settings category
  ///
  /// In en, this message translates to:
  /// **'Privacy & Security'**
  String get settingsPrivacyTitle;

  /// Subtitle describing privacy & security settings content
  ///
  /// In en, this message translates to:
  /// **'Passwords, access'**
  String get settingsPrivacySubtitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return lookupAppLocalizations(locale);
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

Future<AppLocalizations> lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return app_localizations_ar.loadLibrary().then(
        (dynamic _) => app_localizations_ar.AppLocalizationsAr(),
      );
    case 'en':
      return app_localizations_en.loadLibrary().then(
        (dynamic _) => app_localizations_en.AppLocalizationsEn(),
      );
    case 'hi':
      return app_localizations_hi.loadLibrary().then(
        (dynamic _) => app_localizations_hi.AppLocalizationsHi(),
      );
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
