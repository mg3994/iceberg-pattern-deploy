import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:blogstore/app/helpers/extensions.dart';
import 'package:blogstore/generated/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart'
    show
        Container,
        Divider,
        ListTile,
        Icons,
        Theme,
        Column,
        CrossAxisAlignment,
        Text,
        FontWeight,
        BorderRadius,
        EdgeInsets,
        BoxDecoration,
        Icon,
        StatefulWidget,
        State;

import '../../bloc/app_setting_bloc.dart'
    show AppSettingBloc, AppSettingState, AppSettingUpdateLocaleEvent;

class AppSettingLocaleWidget extends StatelessWidget {
  const AppSettingLocaleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return BlocSignalSelector<AppSettingBloc, AppSettingState, Locale>(
      selector: (state) => state.locale,
      builder: (context, selectedLocale) {
        final bloc = context.read<AppSettingBloc>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Language',
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
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  for (final (index, locale)
                      in AppLocalizations.supportedLocales.indexed) ...[
                    _LocaleTile(
                      locale: locale,
                      selectedLocale: selectedLocale,
                      appSettingBloc: bloc,
                    ),
                    if (index < AppLocalizations.supportedLocales.length - 1)
                      Divider(
                        height: 1,
                        indent: 16,
                        color: theme.colorScheme.outlineVariant.withOpacity(
                          0.3,
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _LocaleTile extends StatefulWidget {
  const _LocaleTile({
    required this.locale,
    required this.selectedLocale,
    required this.appSettingBloc,
  });

  final Locale locale;
  final Locale selectedLocale;
  final AppSettingBloc appSettingBloc;

  @override
  State<_LocaleTile> createState() => _LocaleTileState();
}

class _LocaleTileState extends State<_LocaleTile> {
  String? _languageName;

  void _handleTap() {
    widget.appSettingBloc.add(AppSettingUpdateLocaleEvent(widget.locale));
  }

  @override
  void initState() {
    super.initState();
    _loadLanguageName();
  }

  @override
  void didUpdateWidget(covariant _LocaleTile oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.locale != widget.locale) {
      _loadLanguageName();
    }
  }

  Future<void> _loadLanguageName() async {
    final localizations = await lookupAppLocalizations(widget.locale);

    if (!mounted) return;

    setState(() {
      _languageName = localizations.languageName;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSelected =
        widget.locale.languageCode == widget.selectedLocale.languageCode;

    return ListTile(
      minTileHeight: 56,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      title: Text(
        _languageName ?? widget.locale.languageCode.toUpperCase(),
        style: theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.onSurface,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check, size: 20, color: theme.colorScheme.primary)
          : null,
      onTap: _handleTap,
    );
  }
}
