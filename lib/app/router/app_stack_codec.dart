part of 'router.dart';

final class AppStackCodec implements KaiselConfigCodec<AppRoute> {
  const AppStackCodec(this._dependencies, {this._appSettingBloc});

  final Dependencies _dependencies;
  final AppSettingBloc? _appSettingBloc;

  static const _homeBranch = 0;
  static const _settingsBranch = 3;

  @override
  KaiselConfig<AppRoute>? decode(Uri uri) {
    debugPrint('🔥 DECODE URI = $uri');

    _applyGlobalLanguage(uri);

    final segments = uri.pathSegments
        .where((segment) => segment.isNotEmpty)
        .toList(growable: false);

    return switch (segments) {
      [] => _rootConfig(),
      ['onboarding'] => _onboardingConfig(),
      ['products', final id] => _productConfig(id),
      ['settings'] => _settingsConfig(),
      ['settings', 'appearance'] => _appearanceConfig(),
      ['settings', 'general'] => _generalSettingsConfig(),
      ['settings', 'notifications'] => _notificationsConfig(),
      ['settings', 'privacy'] => _privacyConfig(),
      _ => null,
    };
  }

  KaiselConfig<AppRoute> _rootConfig() {
    final hasCompletedOnboarding =
        _appSettingBloc?.stateValue.hasCompletedOnboarding ?? false;

    debugPrint(
      '🔥 ROOT CONFIG → '
      '${hasCompletedOnboarding ? 'Home' : 'Onboarding'}',
    );

    return hasCompletedOnboarding ? _homeConfig() : _onboardingConfig();
  }

  KaiselConfig<AppRoute> _onboardingConfig() {
    return KaiselConfig(mainStack: [const OnboardingRoute()]);
  }

  KaiselConfig<AppRoute> _homeConfig() {
    return KaiselConfig(
      mainStack: [const MainShellRoute()],
      nestedState:  KaiselShellConfig(
        activeBranch: _homeBranch,
        activeBranchStack: [HomeRoot()],
      ),
    );
  }

  KaiselConfig<AppRoute> _productConfig(String id) {
    return KaiselConfig(
      mainStack: const [MainShellRoute()],
      nestedState: KaiselShellConfig(
        activeBranch: _homeBranch,
        activeBranchStack: [const HomeRoot(), ProductDetailRoute(id)],
      ),
    );
  }

  KaiselConfig<AppRoute> _settingsConfig() {
    return KaiselConfig(
      mainStack: [const MainShellRoute()],
      nestedState:  KaiselShellConfig(
        activeBranch: _settingsBranch,
        activeBranchStack: [SettingsMasterRoute()],
      ),
    );
  }

  KaiselConfig<AppRoute> _appearanceConfig() {
    return KaiselConfig(
      mainStack: [const MainShellRoute()],
      nestedState:  KaiselShellConfig(
        activeBranch: _settingsBranch,
        activeBranchStack: [SettingsMasterRoute(), AppSettingRoute()],
      ),
    );
  }

  KaiselConfig<AppRoute> _generalSettingsConfig() {
    return KaiselConfig(
      mainStack: [const MainShellRoute()],
      nestedState:  KaiselShellConfig(
        activeBranch: _settingsBranch,
        activeBranchStack: [SettingsMasterRoute(), GeneralSettingRoute()],
      ),
    );
  }

  KaiselConfig<AppRoute> _notificationsConfig() {
    return KaiselConfig(
      mainStack: [const MainShellRoute()],
      nestedState:  KaiselShellConfig(
        activeBranch: _settingsBranch,
        activeBranchStack: [SettingsMasterRoute(), NotificationsSettingRoute()],
      ),
    );
  }

  KaiselConfig<AppRoute> _privacyConfig() {
    return KaiselConfig(
      mainStack: [const MainShellRoute()],
      nestedState: KaiselShellConfig(
        activeBranch: _settingsBranch,
        activeBranchStack: [SettingsMasterRoute(), PrivacySettingRoute()],
      ),
    );
  }

  @override
  Uri encode(KaiselConfig<AppRoute> config) {
    final uri = switch ((config.mainStack.lastOrNull, config.nestedState)) {
      (OnboardingRoute(), _) => Uri(path: '/onboarding'),

      (MainShellRoute(), final KaiselShellConfig shell) =>
        switch (shell.activeBranch) {
          _homeBranch => _encodeHome(shell.activeBranchStack),
          _settingsBranch => _encodeSettings(shell.activeBranchStack),
          _ => Uri(path: '/'),
        },

      _ => Uri(path: '/'),
    };

    debugPrint(
      '🔥 ENCODE '
      '${config.mainStack.map((route) => route.routeName).toList()} '
      '→ $uri',
    );

    return uri;
  }

  Uri _encodeHome(List<KaiselRoute> stack) {
    if (stack.isEmpty) return Uri(path: '/');

    return switch (stack.last) {
      ProductDetailRoute(:final id) => Uri(path: '/products/$id'),
      _ => Uri(path: '/'),
    };
  }

  /// Match on [stack.last] instead of rigid 2-element list patterns.
  Uri _encodeSettings(List<KaiselRoute> stack) {
    if (stack.isEmpty) return Uri(path: '/settings');

    return switch (stack.last) {
      AppSettingRoute() => Uri(path: '/settings/appearance'),
      GeneralSettingRoute() => Uri(path: '/settings/general'),
      NotificationsSettingRoute() => Uri(path: '/settings/notifications'),
      PrivacySettingRoute() => Uri(path: '/settings/privacy'),
      SettingsMasterRoute() => Uri(path: '/settings'),
      _ => Uri(path: '/settings'),
    };
  }

  void _applyGlobalLanguage(Uri uri) {
    final globalLanguage = uri.queryParameters['gl'];

    if (globalLanguage == null || globalLanguage.isEmpty) {
      return;
    }

    final languageCode = globalLanguage.split('_').first.toLowerCase();

    final supported = AppLocalizations.supportedLocales.any(
      (locale) => locale.languageCode.toLowerCase() == languageCode,
    );

    if (!supported) {
      return;
    }

    _appSettingBloc?.add(
      AppSettingTemporarilyChangeLocaleEvent(
        Locale.fromSubtags(languageCode: languageCode),
      ),
    );
  }
}
