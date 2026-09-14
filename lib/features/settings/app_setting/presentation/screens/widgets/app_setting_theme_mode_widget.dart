import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:blogstore/app/helpers/extensions.dart';
import 'package:blogstore/features/settings/app_setting/presentation/bloc/app_setting_bloc.dart';
import 'package:material_ui/material_ui.dart';

class AppSettingThemeModeWidget extends StatelessWidget {
  const AppSettingThemeModeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return BlocSignalSelector<AppSettingBloc, AppSettingState, ThemeMode>(
      selector: (state) => state.themeMode,
      builder: (context, currentMode) {
        final appSettingBloc = context.read<AppSettingBloc>();
        final isCompact = MediaQuery.sizeOf(context).width < 440; //better with 500 //TODO: Here  Layout constrained max width works better as that is relatd to current widget only but we are avoiding Heavy widgets
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Theme Mode',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(12),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: theme.colorScheme.outlineVariant.withOpacity(0.5),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _ThemeOptionButton(
                      mode: ThemeMode.light,
                      label: 'Light',
                      icon: Icons.light_mode_outlined,
                      showLabel: !isCompact,
                      isSelected: currentMode == ThemeMode.light,
                      appSettingBloc: appSettingBloc,
                    ),
                    _ThemeOptionButton(
                      mode: ThemeMode.dark,
                      label: 'Dark',
                      icon: Icons.dark_mode_outlined,
                      showLabel: !isCompact,
                      isSelected: currentMode == ThemeMode.dark,
                      appSettingBloc: appSettingBloc,
                    ),
                    _ThemeOptionButton(
                      mode: ThemeMode.system,
                      label: 'System',
                      icon: Icons.settings_suggest_outlined,
                      showLabel: !isCompact,
                      isSelected: currentMode == ThemeMode.system,
                      appSettingBloc: appSettingBloc,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ThemeOptionButton extends StatelessWidget {
  const _ThemeOptionButton({
    required this.mode,
    required this.label,
    required this.icon,
    required this.showLabel,
    required this.isSelected,
    required this.appSettingBloc,
  });

  final ThemeMode mode;
  final String label;
  final IconData icon;
  final bool showLabel;
  final bool isSelected;
  final AppSettingBloc appSettingBloc;

  void _handleTap() {
    appSettingBloc.add(AppSettingUpdateThemeModeEvent(mode));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final backgroundColor = isSelected
        ? colorScheme.primary
        : Colors.transparent;
    final textColor = isSelected
        ? colorScheme.onPrimary
        : colorScheme.onSurfaceVariant;
    final iconColor = isSelected
        ? colorScheme.onPrimary
        : colorScheme.onSurfaceVariant;

    return Expanded(
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: _handleTap,
          borderRadius: BorderRadius.circular(10),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,

                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 20, color: iconColor),

                  if (showLabel) ...[
                    const SizedBox(width: 8),
                    Text(
                      label,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: textColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
