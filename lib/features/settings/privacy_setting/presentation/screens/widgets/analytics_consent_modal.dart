// import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
// import 'package:blogstore/app/helpers/extensions.dart';
// import 'package:material_ui/material_ui.dart';

// import '../../../../app_setting/presentation/bloc/app_setting_bloc.dart'
//     show AppSettingBloc, AppSettingUpdateConsentEvent;
// import 'analytics_consent_actions.dart';
// import 'analytics_consent_header.dart';
// import 'analytics_consent_preferences.dart';

// class AnalyticsConsentModal extends StatefulWidget {
//   const AnalyticsConsentModal({super.key});

//   /// Shows the Modal Bottom Sheet if the user has not yet given consent.
//   static Future<void> showIfNeeded(BuildContext context) async {
//     final bloc = context.read<AppSettingBloc>();
//     if (!bloc.stateValue.hasGivenConsent) {
//       await show(context, bloc: bloc);
//     }
//   }

//   /// Explicitly shows the Analytics Consent Modal Bottom Sheet.
//   static Future<void> show(
//     BuildContext context, {
//     AppSettingBloc? bloc,
//     GlobalKey<NavigatorState>? navigatorKey,
//   }) async {
//     final appSettingBloc = bloc ?? context.read<AppSettingBloc>();
//     // Determine the context that actually sits under/within a Navigator
//     final navContext = navigatorKey?.currentContext ?? context;
//     await showModalBottomSheet<void>(
//       context: navContext,
//       isScrollControlled: true,
//       useSafeArea: true,
//       isDismissible: false,
//       enableDrag: false,
//       useRootNavigator: true,
//       backgroundColor: Colors.transparent,
//       builder: (modalContext) => BlocSignalProvider<AppSettingBloc>.value(
//         value: appSettingBloc,
//         child: const AnalyticsConsentModal(),
//       ),
//     );
//   }

//   @override
//   State<AnalyticsConsentModal> createState() => _AnalyticsConsentModalState();
// }

// class _AnalyticsConsentModalState extends State<AnalyticsConsentModal> {
//   bool _showSettingsSelection = false;
//   bool _analyticsConsent = true;
//   bool _advertisingConsent = true;
//   bool _personalizationConsent = true;

//   void _onAcceptAll() {
//     context.read<AppSettingBloc>().add(
//       const AppSettingUpdateConsentEvent(
//         hasGivenConsent: true,
//         analyticsStorageConsentGranted: true,
//         adStorageConsentGranted: true,
//         adUserDataConsentGranted: true,
//         adPersonalizationSignalsConsentGranted: true,
//         functionalityStorageConsentGranted: true,
//         personalizationStorageConsentGranted: true,
//         securityStorageConsentGranted: true,
//       ),
//     );
//     Navigator.of(context).maybePop();
//   }

//   void _onAcceptSelected() {
//     context.read<AppSettingBloc>().add(
//       AppSettingUpdateConsentEvent(
//         hasGivenConsent: true,
//         analyticsStorageConsentGranted: _analyticsConsent,
//         adStorageConsentGranted: _advertisingConsent,
//         adUserDataConsentGranted: _advertisingConsent,
//         adPersonalizationSignalsConsentGranted: _advertisingConsent,
//         functionalityStorageConsentGranted: true,
//         personalizationStorageConsentGranted: _personalizationConsent,
//         securityStorageConsentGranted: true,
//       ),
//     );
//     Navigator.of(context).maybePop();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = context.theme;
//     final colorScheme = theme.colorScheme;

//     return Container(
//       decoration: BoxDecoration(
//         color: colorScheme.surface,
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       padding: EdgeInsets.only(
//         left: 24,
//         right: 24,
//         top: 16,
//         bottom: MediaQuery.of(context).viewInsets.bottom + 24,
//       ),
//       child: SafeArea(
//         top: false,
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const AnalyticsConsentHeader(),
//               const SizedBox(height: 20),
//               if (_showSettingsSelection) ...[
//                 AnalyticsConsentPreferences(
//                   analyticsConsent: _analyticsConsent,
//                   advertisingConsent: _advertisingConsent,
//                   personalizationConsent: _personalizationConsent,
//                   onAnalyticsChanged: (val) {
//                     setState(() {
//                       _analyticsConsent = val;
//                     });
//                   },
//                   onAdvertisingChanged: (val) {
//                     setState(() {
//                       _advertisingConsent = val;
//                     });
//                   },
//                   onPersonalizationChanged: (val) {
//                     setState(() {
//                       _personalizationConsent = val;
//                     });
//                   },
//                 ),
//                 const SizedBox(height: 24),
//               ],
//               AnalyticsConsentActions(
//                 showSettingsSelection: _showSettingsSelection,
//                 onAcceptAll: _onAcceptAll,
//                 onAcceptSelected: _onAcceptSelected,
//                 onOpenSettings: () {
//                   setState(() {
//                     _showSettingsSelection = true;
//                   });
//                 },
//                 onBackFromSettings: () {
//                   setState(() {
//                     _showSettingsSelection = false;
//                   });
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

///////////////////
///
///

import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:blogstore/app/helpers/extensions.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../app_setting/presentation/bloc/app_setting_bloc.dart'
    show AppSettingBloc, AppSettingUpdateConsentEvent;
import 'analytics_consent_actions.dart';
import 'analytics_consent_header.dart';
import 'analytics_consent_preferences.dart';

class AnalyticsConsentModal extends StatefulWidget {
  const AnalyticsConsentModal({super.key});

  @override
  State<AnalyticsConsentModal> createState() => _AnalyticsConsentModalState();
}

class _AnalyticsConsentModalState extends State<AnalyticsConsentModal> {
  bool _showSettingsSelection = false;

  bool _analyticsConsent = true;
  bool _advertisingConsent = true;
  bool _personalizationConsent = true;

  void _onAcceptAll() {
    context.read<AppSettingBloc>().add(
      const AppSettingUpdateConsentEvent(
        hasGivenConsent: true,
        analyticsStorageConsentGranted: true,
        adStorageConsentGranted: true,
        adUserDataConsentGranted: true,
        adPersonalizationSignalsConsentGranted: true,
        functionalityStorageConsentGranted: true,
        personalizationStorageConsentGranted: true,
        securityStorageConsentGranted: true,
      ),
    );

    Navigator.of(context).maybePop();
  }

  void _onAcceptSelected() {
    context.read<AppSettingBloc>().add(
      AppSettingUpdateConsentEvent(
        hasGivenConsent: true,
        analyticsStorageConsentGranted: _analyticsConsent,
        adStorageConsentGranted: _advertisingConsent,
        adUserDataConsentGranted: _advertisingConsent,
        adPersonalizationSignalsConsentGranted: _advertisingConsent,
        functionalityStorageConsentGranted: true,
        personalizationStorageConsentGranted: _personalizationConsent,
        securityStorageConsentGranted: true,
      ),
    );

    Navigator.of(context).maybePop();
  }

  void _setShowSettings(bool value) {
    setState(() {
      _showSettingsSelection = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;

    return Material(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AnalyticsConsentHeader(),

                const SizedBox(height: 20),

                if (_showSettingsSelection) ...[
                  AnalyticsConsentPreferences(
                    analyticsConsent: _analyticsConsent,
                    advertisingConsent: _advertisingConsent,
                    personalizationConsent: _personalizationConsent,
                    onAnalyticsChanged: (value) {
                      setState(() {
                        _analyticsConsent = value;
                      });
                    },
                    onAdvertisingChanged: (value) {
                      setState(() {
                        _advertisingConsent = value;
                      });
                    },
                    onPersonalizationChanged: (value) {
                      setState(() {
                        _personalizationConsent = value;
                      });
                    },
                  ),

                  const SizedBox(height: 24),
                ],

                AnalyticsConsentActions(
                  showSettingsSelection: _showSettingsSelection,
                  onAcceptAll: _onAcceptAll,
                  onAcceptSelected: _onAcceptSelected,
                  onOpenSettings: () {
                    _setShowSettings(true);
                  },
                  onBackFromSettings: () {
                    _setShowSettings(false);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// ```

// And use this as your **Kaisel modal builder**:

// ```dart
// Widget _modalBuilder(
//   BuildContext context,
//   KaiselModalRoute<Object?> flowRoute,
//   Widget flowChild,
// ) {
//   final mediaQuery = MediaQuery.of(context);

//   return ColoredBox(
//     color: Colors.black.withValues(alpha: 0.6),
//     child: Align(
//       alignment: Alignment.bottomCenter,
//       child: SafeArea(
//         top: false,
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: ConstrainedBox(
//             constraints: BoxConstraints(
//               maxWidth: 720,
//               maxHeight: mediaQuery.size.height * 0.9,
//             ),
//             child: flowChild,
//           ),
//         ),
//       ),
//     ),
//   );
// }
// ```

// And your route remains:

// ```dart
// (_, ConsentModalRoute(), _) => KaiselStandalonePage(
//   AnalyticsConsentModal(),
// ),
// ```

// The important behavior is now:

// ```text
// Kaisel modal route
//        │
//        ├── Full-screen transparent/scrim layer
//        │
//        └── Align(bottomCenter)
//               │
//               └── AnalyticsConsentModal
//                      │
//                      └── height = content height
// ```

// So if the consent content is 320 px tall, the panel is **320 px tall**, not screen height. If the content becomes taller than 90% of the screen, the `SingleChildScrollView` handles the overflow.
