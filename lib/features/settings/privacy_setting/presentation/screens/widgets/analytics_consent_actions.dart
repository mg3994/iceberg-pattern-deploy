import 'package:blogstore/app/helpers/extensions.dart';
import 'package:material_ui/material_ui.dart';

class AnalyticsConsentActions extends StatelessWidget {
  const AnalyticsConsentActions({
    super.key,
    required this.showSettingsSelection,
    required this.onAcceptAll,
    required this.onAcceptSelected,
    required this.onOpenSettings,
    required this.onBackFromSettings,
  });

  final bool showSettingsSelection;
  final VoidCallback onAcceptAll;
  final VoidCallback onAcceptSelected;
  final VoidCallback onOpenSettings;
  final VoidCallback onBackFromSettings;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;

    if (showSettingsSelection) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onBackFromSettings,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Back'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton(
              onPressed: onAcceptSelected,
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Accept'),
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onOpenSettings,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text('Settings'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton(
            onPressed: onAcceptAll,
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.primary,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text('Accept all'),
          ),
        ),
      ],
    );
  }
}
