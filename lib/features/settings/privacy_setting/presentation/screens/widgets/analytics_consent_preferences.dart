import 'package:blogstore/app/helpers/extensions.dart';
import 'package:material_ui/material_ui.dart';

class AnalyticsConsentPreferences extends StatelessWidget {
  const AnalyticsConsentPreferences({
    super.key,
    required this.analyticsConsent,
    required this.advertisingConsent,
    required this.personalizationConsent,
    required this.onAnalyticsChanged,
    required this.onAdvertisingChanged,
    required this.onPersonalizationChanged,
  });

  final bool analyticsConsent;
  final bool advertisingConsent;
  final bool personalizationConsent;
  final ValueChanged<bool> onAnalyticsChanged;
  final ValueChanged<bool> onAdvertisingChanged;
  final ValueChanged<bool> onPersonalizationChanged;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  const Switch(value: true, onChanged: null),
                  const SizedBox(width: 8),
                  Text(
                    'Necessary',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Switch(
                    value: analyticsConsent,
                    onChanged: onAnalyticsChanged,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Analytics',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Switch(
                    value: advertisingConsent,
                    onChanged: onAdvertisingChanged,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Advertising',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Switch(
                    value: personalizationConsent,
                    onChanged: onPersonalizationChanged,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Personalization',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
