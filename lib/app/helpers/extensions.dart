import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoLocalizations;

import 'package:material_ui/material_ui.dart'
    show
        BuildContext,
        MaterialLocalizations,

        Theme,
        ThemeData;


import '../../generated/app_localizations.dart' show AppLocalizations;


extension BuildContextLocalizationExtensions on BuildContext {
  /// The application's generated localization strings.
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  /// Material localization strings.
  MaterialLocalizations get m10n => MaterialLocalizations.of(this);

  /// Cupertino localization strings.
  CupertinoLocalizations get c10n => CupertinoLocalizations.of(this);

  /// The current theme for this context.
  ThemeData get theme => Theme.of(this);
}
