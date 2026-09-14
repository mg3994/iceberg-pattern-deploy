import 'package:blogstore/app/helpers/extensions.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../app/router/router.dart'
    show
        SettingsRoute,
        GeneralSettingRoute,
        AppSettingRoute,
        NotificationsSettingRoute,
        PrivacySettingRoute;

class SettingsCategoryItemData {
  const SettingsCategoryItemData({
    required this.route,
    required this.titleBuilder,
    required this.subtitleBuilder,
    required this.icon,
  });

  final SettingsRoute route;
  final String Function(BuildContext context) titleBuilder;
  final String Function(BuildContext context) subtitleBuilder;
  final IconData icon;
}

final List<SettingsCategoryItemData> kSettingsCategoryItems = [
  SettingsCategoryItemData(
    route: const GeneralSettingRoute(),
    titleBuilder: (context) => context.l10n.settingsGeneralTitle,
    subtitleBuilder: (context) => context.l10n.settingsGeneralSubtitle,
    icon: Icons.person_outline,
  ),
  SettingsCategoryItemData(
    route: const AppSettingRoute(),
    titleBuilder: (context) => context.l10n.settingsAppearanceTitle,
    subtitleBuilder: (context) => context.l10n.settingsAppearanceSubtitle,
    icon: Icons.palette_outlined,
  ),
  SettingsCategoryItemData(
    route: const NotificationsSettingRoute(),
    titleBuilder: (context) => context.l10n.settingsNotificationsTitle,
    subtitleBuilder: (context) => context.l10n.settingsNotificationsSubtitle,
    icon: Icons.notifications_none,
  ),
  SettingsCategoryItemData(
    route: const PrivacySettingRoute(),
    titleBuilder: (context) => context.l10n.settingsPrivacyTitle,
    subtitleBuilder: (context) => context.l10n.settingsPrivacySubtitle,
    icon: Icons.lock_outline,
  ),
];

class SettingsMasterScreen extends StatefulWidget {
  const SettingsMasterScreen({
    super.key,
    this.selectedRoute,
    this.onSelectRoute,
  });

  final SettingsRoute? selectedRoute;
  final void Function(BuildContext context, SettingsRoute route)? onSelectRoute;

  @override
  State<SettingsMasterScreen> createState() => _SettingsMasterScreenState();
}

class _SettingsMasterScreenState extends State<SettingsMasterScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.trim().toLowerCase();
    });
  }

  void _clearSearch() {
    _searchController.clear();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  List<SettingsCategoryItemData> _getFilteredItems(BuildContext context) {
    if (_searchQuery.isEmpty) return kSettingsCategoryItems;
    return kSettingsCategoryItems.where((item) {
      final title = item.titleBuilder(context).toLowerCase();
      final subtitle = item.subtitleBuilder(context).toLowerCase();
      return title.contains(_searchQuery) || subtitle.contains(_searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filtered = _getFilteredItems(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                context.l10n.settingsTitle,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: context.l10n.searchSettings,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: _clearSearch,
                        )
                      : null,
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHigh,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text(
                        context.l10n.noSettingsFound,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount: filtered.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final item = filtered[index];
                        final isSelected =
                            widget.selectedRoute?.runtimeType ==
                            item.route.runtimeType;

                        return _SettingsCategoryTile(
                          icon: item.icon,
                          title: item.titleBuilder(context),
                          subtitle: item.subtitleBuilder(context),
                          isSelected: isSelected,
                          onTap: (tileContext) {
                            // ✅ Fix: Guard against duplicate clicks
                            if (isSelected) return;
                            widget.onSelectRoute?.call(tileContext, item.route);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsCategoryTile extends StatelessWidget {
  const _SettingsCategoryTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final void Function(BuildContext context) onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final backgroundColor = isSelected
        ? colorScheme.secondaryContainer
        : Colors.transparent;
    final iconColor = isSelected
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant;
    final textColor = isSelected
        ? colorScheme.onSecondaryContainer
        : colorScheme.onSurface;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        leading: Icon(icon, color: iconColor),
        title: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        onTap: () => onTap(context),
      ),
    );
  }
}
