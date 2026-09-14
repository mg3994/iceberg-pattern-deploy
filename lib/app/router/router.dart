import 'dart:ui' show DisplayFeature, DisplayFeatureType;

import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:blogstore/app/helpers/extensions.dart';
import 'package:blogstore/injection/dependency_injection.dart'
    show Dependencies;
import 'package:kaisel/kaisel.dart';
import 'package:material_ui/material_ui.dart';

import '../../features/onboarding/onboarding.dart' show OnboardingScreen;
import '../../features/settings/app_setting/presentation/bloc/app_setting_bloc.dart'
    show
        AppSettingBloc,
        AppSettingUpdateSeedColorEvent,
        AppSettingTemporarilyChangeLocaleEvent;

import '../../features/settings/privacy_setting/privacy_setting.dart'
    show AnalyticsConsentModal;
import '../../features/settings/settings.dart';

import '../../generated/app_localizations.dart' show AppLocalizations;

part 'app_stack_codec.dart';

// List<AppRoute>? pendingConsentRoutes;

// KaiselGuard<AppRoute> consentGuard(AppSettingBloc? bloc) {
//   return (current, proposed) {
//     if (bloc?.stateValue.hasGivenConsent == true) {
//       pendingConsentRoutes = null;
//       return proposed;
//     }

//     // Exclude OnboardingRoute from consent checks if consent isn't needed during onboarding
//     // final needsConsent = proposed.any((route) => route is AppRoute && route is! OnboardingRoute);
//     final needsConsent = proposed.any((route) => route is AppRoute);

//     if (!needsConsent) {
//       return proposed;
//     }

//     final consentAlreadyVisible = current.any(
//       (route) => route is ConsentModalRoute,
//     );

//     if (consentAlreadyVisible) {
//       return current;
//     }

//     pendingConsentRoutes = List<AppRoute>.unmodifiable(proposed);

//     return [
//       ...proposed,
//       const ConsentModalRoute(),
//     ]; // ✅ Append to proposed stack rather than current
//   };
// }

/// Returns a guard instance with its own encapsulated pending state.
/// Returns a guard instance with atomic pending-stack handling for rapid clicks.
KaiselGuard<AppRoute> createConsentGuard(AppSettingBloc? bloc) {
  List<AppRoute>? pendingConsentRoutes;

  return (current, proposed) {
    final hasConsent = bloc?.stateValue.hasGivenConsent ?? false;

    // 1. Consent already granted: restore stashed stack or allow proposed directly
    if (hasConsent) {
      if (pendingConsentRoutes != null) {
        final restored = List<AppRoute>.from(pendingConsentRoutes!);
        pendingConsentRoutes = null;
        return restored;
      }
      return proposed;
    }

    final needsConsent = proposed.any((route) => route is AppRoute);

    if (!needsConsent) {
      return proposed;
    }

    final consentAlreadyVisible = current.any(
      (route) => route is ConsentModalRoute,
    );

    // 2. Prevent Fast-Click Stacking: If modal is already shown, lock down intermediate clicks
    if (consentAlreadyVisible) {
      return current;
    }

    // 3. Stash only the FIRST valid proposed target on entry
    pendingConsentRoutes = List<AppRoute>.unmodifiable(proposed);

    // Append modal on top of proposed targets cleanly
    return [...proposed, const ConsentModalRoute()];
  };
}

/// A transparent flow page that slides its content up from the bottom, and
/// forwards name/arguments so the flow stays observable.
class _SlideUpFlowPage extends Page<Object?> {
  const _SlideUpFlowPage({
    required LocalKey super.key,
    required this.child,
    super.name,
    super.arguments,
  });

  final Widget child;

  @override
  Route<Object?> createRoute(BuildContext context) {
    return PageRouteBuilder<Object?>(
      settings: this,
      opaque: false,
      transitionDuration: const Duration(milliseconds: 280),
      reverseTransitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (_, _, _) => child,
      transitionsBuilder: (_, animation, _, child) => SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
            .animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            ),
        child: child,
      ),
    );
  }
}

// Page<Object?> _pageWrapper(KaiselPageWrapperContext<AppRoute> ctx) {
//   if (ctx.isFlow) {
//     return _SlideUpFlowPage(
//       key: ctx.key,
//       name: ctx.route.routeName,
//       arguments: ctx.route,
//       child: ctx.child,
//     );
//   }
//   return MaterialPage<Object?>(
//     key: ctx.key,
//     name: ctx.route.routeName,
//     arguments: ctx.route,
//     child: ctx.child,
//   );
// }

// Widget _modalBuilder(
//   BuildContext context,
//   KaiselModalRoute<Object?> flowRoute,
//   Widget flowChild,
// ) {
//   return ColoredBox(
//     color: Colors.black.withValues(alpha: 0.6),
//     child: Align(
//       alignment: Alignment.bottomCenter,
//       child: Container(
//         width: double.infinity,
//         margin: const EdgeInsets.all(16),
//         padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
//         decoration: BoxDecoration(
//           color: const Color(0xFF14141C),
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: SafeArea(top: false, child: flowChild),
//       ),
//     ),
//   );
// }

Page<Object?> _pageWrapper(KaiselPageWrapperContext<AppRoute> ctx) {
  final route = ctx.route;

  if (route is ConsentModalRoute) {
    return _ConsentModalPage(
      key: ctx.key,
      name: route.routeName,
      arguments: route,
      child: ctx.child,
    );
  }

  if (ctx.isFlow) {
    return _SlideUpFlowPage(
      key: ctx.key,
      name: route.routeName,
      arguments: route,
      child: ctx.child,
    );
  }

  return MaterialPage<Object?>(
    key: ctx.key,
    name: route.routeName,
    arguments: route,
    child: ctx.child,
  );
}

Widget _modalBuilder(
  BuildContext context,
  KaiselModalRoute<Object?> flowRoute,
  Widget flowChild,
) {
  return SafeArea(child: flowChild);
}

final class _ConsentModalPage extends Page<Object?> {
  const _ConsentModalPage({
    required LocalKey super.key,
    required this.child,
    super.name,
    super.arguments,
  });

  final Widget child;

  @override
  Route<Object?> createRoute(BuildContext context) {
    return PageRouteBuilder<Object?>(
      settings: this,
      opaque: false,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 280),
      reverseTransitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (_, _, _) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: child,
            ),
          ),
        );
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
              .animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              ),
          child: child,
        );
      },
    );
  }
}

//
// 1. Local state to hold the stashed routes
// List<AppRoute>? pendingRoutes;

// // 2. Define the guard capturing the local state
// KaiselGuard<AppRoute> authGuard = (current, proposed) {
//   if (loginBloc == null) return proposed;

//   final isLoggedIn = loginBloc.stateValue.isLoggedIn;
//   final needsAuth = proposed.any((r) => r is RequiresAuth);

//   // SCENARIO A: Needs auth but not logged in -> Stash and redirect
//   if (needsAuth && !isLoggedIn) {
//     pendingRoutes = proposed; // Stash the whole proposed stack

//     return [
//       ...proposed.where((r) => r is! RequiresAuth),
//       const LoginRoute(),
//     ];
//   }

//   // SCENARIO B: User just logged in -> Restore stash or default to Shell
//   if (isLoggedIn && proposed.any((r) => r is LoginRoute)) {
//     if (pendingRoutes != null && pendingRoutes!.isNotEmpty) {
//       final restored = pendingRoutes!;
//       pendingRoutes = null; // Clear the stash
//       return restored;
//     }
//     return const [MainShellRoute()];
//   }

//   return proposed;
// };

//

//  guards: [authGuard(loginBloc)],
//   reevaluateOn: loginBloc.toValueListenable(),
// KaiselGuard<AppRoute> authGuard(LoginBloc loginBloc) => (current, proposed) {
//   final isLoggedIn = loginBloc.stateValue.isLoggedIn;

//   // When unauthenticated, only LoginRoute is permitted
//   if (!isLoggedIn) {
//     if (proposed.length == 1 && proposed.first is LoginRoute) {
//       return proposed;
//     }
//     return const [LoginRoute()];
//   }

//   // When authenticated, redirect away from LoginRoute to HomeRoute
//   if (proposed.any((r) => r is LoginRoute)) {
//     return [HomeRoute(loginBloc.stateValue.username)];
//   }

//   return proposed;
// };

/// ===========================================================================
/// Application routes
/// ===========================================================================
/// Marker for routes that require authentication.
abstract interface class RequiresAuth {
  const RequiresAuth();
}

/// Marker for routes that require authentication.

sealed class AppRoute extends KaiselRoute {
  const AppRoute();
}

final class ConsentModalRoute extends AppRoute
    implements KaiselModalRoute<bool?> {
  const ConsentModalRoute();
}

final class OnboardingRoute extends AppRoute {
  const OnboardingRoute();
}

/// ===========================================================================
/// Main shell
///
/// ├── HomeRoute
/// │   └── HomeRoot
/// │       └── ProductDetailRoute
/// │
/// └── SettingsRoute
///     └── SettingsMasterRoute
///         └── AppSettingRoute
/// ===========================================================================

// sealed

final class MainShellRoute extends AppRoute {
  // this is our ShellHost
  const MainShellRoute();
}

/// ===========================================================================
/// Home branch
/// ===========================================================================

sealed class HomeRoute extends MainShellRoute {
  const HomeRoute();
}

/// Root of the Home navigation stack.
final class HomeRoot extends HomeRoute {
  const HomeRoot();
}

/// Detail pushed from [HomeRoot].
final class ProductDetailRoute extends HomeRoute {
  const ProductDetailRoute(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

/// ===========================================================================
/// Settings branch
/// ===========================================================================

sealed class SettingsRoute extends MainShellRoute {
  const SettingsRoute();
}

/// Root/master of the Settings navigation stack.
final class SettingsMasterRoute extends SettingsRoute {
  const SettingsMasterRoute();
}

final class GeneralSettingRoute extends SettingsRoute {
  const GeneralSettingRoute();
}

/// Detail pushed from [SettingsMasterRoute].
final class AppSettingRoute extends SettingsRoute {
  const AppSettingRoute();
}

final class NotificationsSettingRoute extends SettingsRoute {
  const NotificationsSettingRoute();
}

final class PrivacySettingRoute extends SettingsRoute {
  const PrivacySettingRoute();
}

/// ===========================================================================
/// Home module
/// ===========================================================================

final class HomeRouteModule extends RouteModule<HomeRoute> {
  const HomeRouteModule();

  @override
  List<HomeRoute> get initialStack => const [HomeRoot()];

  @override
  Widget buildPage(BuildContext context, HomeRoute route) {
    return switch (route) {
      HomeRoot() => const HomeScreen(),
      ProductDetailRoute(:final id) => ProductDetailScreen(id: id),
    };
  }

  @override
  ModuleStackCodec<HomeRoute>? get codec => const HomeModuleCodec();
}

final class HomeModuleCodec extends ModuleStackCodec<HomeRoute> {
  const HomeModuleCodec();

  @override
  List<String> encode(List<HomeRoute> stack) {
    return switch (stack.last) {
      HomeRoot() => const [],
      ProductDetailRoute(:final id) => ['product', id],
    };
  }

  @override
  List<HomeRoute>? decode(List<String> segments) {
    return switch (segments) {
      [] => const [HomeRoot()],
      ['product', final id] => [HomeRoot(), ProductDetailRoute(id)],
      _ => null,
    };
  }
}

/// ===========================================================================
/// Settings module
/// ===========================================================================

final class SettingsRouteModule extends RouteModule<SettingsRoute> {
  const SettingsRouteModule();

  @override
  List<SettingsRoute> get initialStack => const [SettingsMasterRoute()];

  @override
  Widget buildPage(BuildContext context, SettingsRoute route) {
    return switch (route) {
      SettingsMasterRoute() => const SettingsMasterScreen(),
      AppSettingRoute() => const AppSettingScreen(),
      GeneralSettingRoute() => const Placeholder(),
      NotificationsSettingRoute() => const Placeholder(),
      PrivacySettingRoute() => const Placeholder(),
    };
  }

  @override
  ModuleStackCodec<SettingsRoute>? get codec => const SettingsModuleCodec();
}

final class SettingsModuleCodec extends ModuleStackCodec<SettingsRoute> {
  const SettingsModuleCodec();

  @override
  List<String> encode(List<SettingsRoute> stack) {
    return switch (stack.last) {
      SettingsMasterRoute() => const [],
      AppSettingRoute() => const ['appearance'],
      GeneralSettingRoute() => const ['general'],
      NotificationsSettingRoute() => const ['notifications'],
      PrivacySettingRoute() => const ['privacy'],
    };
  }

  @override
  List<SettingsRoute>? decode(List<String> segments) {
    return switch (segments) {
      [] => const [SettingsMasterRoute()],
      ['appearance'] => const [SettingsMasterRoute(), AppSettingRoute()],
      ['general'] => const [SettingsMasterRoute(), GeneralSettingRoute()],
      ['notifications'] => const [
        SettingsMasterRoute(),
        NotificationsSettingRoute(),
      ],
      ['privacy'] => const [SettingsMasterRoute(), PrivacySettingRoute()],
      _ => null,
    };
  }
}

/// ===========================================================================
/// Adaptive helpers
/// ===========================================================================

/// Helper function to detect a vertical fold / hinge
DisplayFeature? _verticalFold(MediaQueryData mq) {
  for (final f in mq.displayFeatures) {
    final vertical =
        f.bounds.left > 0 && f.bounds.height >= mq.size.height * 0.9;
    final isFold =
        f.type == DisplayFeatureType.fold || f.type == DisplayFeatureType.hinge;
    if (vertical && isFold) return f;
  }
  return null;
}

/// ===========================================================================
/// Router
/// ===========================================================================

final class AppRouter {
  AppRouter(this._dependencies, {this._appSettingBloc})
    : _routerConfig = _createRouterConfig(
        _dependencies,
        createConsentGuard(_appSettingBloc),
        _appSettingBloc,
      ) {
    debugPrint('🔥 AppRouter CREATED');
  }

  final Dependencies _dependencies;
  final AppSettingBloc? _appSettingBloc;

  late final KaiselRouterConfig<AppRoute> _routerConfig;

  KaiselRouterConfig<AppRoute> get routerConfig => _routerConfig;

  static KaiselRouterConfig<AppRoute> _createRouterConfig(
    Dependencies dependencies,
    KaiselGuard<AppRoute> consentGuard,
    AppSettingBloc? appSettingBloc,
  ) {
    final hasCompletedOnboarding =
        appSettingBloc?.stateValue.hasCompletedOnboarding ?? false;

    final initialRoute = hasCompletedOnboarding
        ? const MainShellRoute()
        : const OnboardingRoute();

    return KaiselRouterConfig<AppRoute>.adaptive(
      initial: initialRoute, // ✅ Dynamically resolves to OnboardingRoute
      codec: AppStackCodec(dependencies, appSettingBloc: appSettingBloc),
      guards: [consentGuard],
      observers: () => [dependencies.analyticsGateway.observer()],
      onScreenChanged: (route) {
        debugPrint('🔥 ROUTE = ${route.routeName}');
        dependencies.analyticsGateway.logScreenView(
          screenName: route.routeName,
        );
      },
      pageWrapper: _pageWrapper,
      modalBuilder: _modalBuilder,
      builder: _buildRoute,
    );
  }

  static KaiselPageResult _buildRoute(
    BuildContext context,
    AppRoute route,
    KaiselStackContext<AppRoute> stack,
  ) {
    final mediaQuery = MediaQuery.of(context);
    final fold = _verticalFold(mediaQuery);

    final isWide = fold != null || mediaQuery.size.width >= 700;

    return switch ((stack.previous, route, isWide)) {
      // ---------------------------------------------------------------------
      // Onboarding
      // ---------------------------------------------------------------------

      (_, OnboardingRoute(), _) => const KaiselStandalonePage(
        OnboardingScreen(), // will make it responsive in future  may be different for a larger display
      ),

      (_, MainShellRoute(), _) => KaiselStandalonePage(_LazyShell()),

      // TODO: Handle this case.
      // TODO: Handle this case.
      (_, ConsentModalRoute(), _) => KaiselStandalonePage(
        AnalyticsConsentModal(),
      ), //TODO:....,
    };
  }
}

/// ===========================================================================
/// Settings adaptive layout
/// ===========================================================================

// final class SettingsTwoPane extends StatelessWidget {
//   const SettingsTwoPane({
//     super.key,
//     required this.master,
//     required this.detail,
//     this.hinge,
//   });

//   final Widget master;
//   final Widget detail;
//   final Rect? hinge;

//   @override
//   Widget build(BuildContext context) {
//     final h = hinge;

//     if (h == null) {
//       return Row(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           SizedBox(width: 320, child: master),
//           const VerticalDivider(width: 1),
//           Expanded(child: detail),
//         ],
//       );
//     }

//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         SizedBox(width: h.left, child: master),
//         SizedBox(width: h.width),
//         Expanded(child: detail),
//       ],
//     );
//   }
// }

/// ===========================================================================
/// Screens
/// ===========================================================================

final class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: context.theme.colorScheme.primary,
        actions: [
          IconButton(
            onPressed: () {
              context.push(const SettingsMasterRoute());
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Container(
        color: context.theme.colorScheme.primaryContainer,
        alignment: Alignment.center,
        child: IconButton(
          onPressed: () {
            context.read<AppSettingBloc>().add(
              AppSettingUpdateSeedColorEvent(Colors.purple),
            );
          },
          icon: const Icon(Icons.color_lens),
        ),
      ),
    );
  }
}

final class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return Placeholder(key: ValueKey(id));
  }
}

class AppNavItem {
  final String label;
  final IconData unselectedIcon;
  final IconData selectedIcon;

  const AppNavItem({
    required this.label,
    required this.unselectedIcon,
    required this.selectedIcon,
  });
}

class _LazyShell extends StatelessWidget {
  // add some constructor stuffs
  const _LazyShell();

  // Single source of truth for all navigation destinations
  static final List<AppNavItem> _navItems = [
    AppNavItem(
      label: 'Home',
      unselectedIcon: Icons.home_outlined,
      selectedIcon: Icons.home,
    ),
    AppNavItem(
      label: 'Store',
      unselectedIcon: Icons.storefront_outlined,
      selectedIcon: Icons.storefront,
    ),
    AppNavItem(
      label: 'Drafts',
      unselectedIcon: Icons.edit_note_outlined,
      selectedIcon: Icons.edit_note,
    ),
    AppNavItem(
      label: 'Settings',
      unselectedIcon: Icons.settings_outlined,
      selectedIcon: Icons.settings,
    ),
  ];

  KaiselPageResult _buildContentRoute(
    BuildContext context,
    SettingsRoute route,
    KaiselStackContext<SettingsRoute> ctx,
  ) {
    final mq = MediaQuery.of(context);
    final fold = _verticalFold(mq);
    final isWide = fold != null || mq.size.width >= 700;

    if (isWide) {
      // Default to AppSettingRoute when nothing specific is selected (i.e. at SettingsMasterRoute)
      final effectiveRoute = route is SettingsMasterRoute
          ? const AppSettingRoute()
          : route;

      final twoPaneWidget = KaiselMasterDetailScaffold(
        master: SettingsMasterScreen(
          selectedRoute: effectiveRoute,
          onSelectRoute: (tileContext, targetRoute) {
            if (effectiveRoute.runtimeType == targetRoute.runtimeType) return;

            tileContext.pushOrReplaceTop(targetRoute);
          },
        ),
        detail: switch (effectiveRoute) {
          AppSettingRoute() => const AppSettingScreen(),
          GeneralSettingRoute() => const Placeholder(),
          NotificationsSettingRoute() => const Placeholder(),
          PrivacySettingRoute() => const Placeholder(),
          _ => const AppSettingScreen(),
        },

        // hinge: fold?.bounds,
      );

      return (ctx.previous is SettingsMasterRoute)
          ? KaiselAbsorbingPage(widget: twoPaneWidget)
          : KaiselStandalonePage(twoPaneWidget);
    }

    return KaiselStandalonePage(switch (route) {
      AppSettingRoute() => const AppSettingScreen(),
      GeneralSettingRoute() => const Placeholder(),
      NotificationsSettingRoute() => const Placeholder(),
      PrivacySettingRoute() => const Placeholder(),
      _ => SettingsMasterScreen(
        selectedRoute: route,
        onSelectRoute: (tileContext, targetRoute) {
          // ✅ Safely replace top to prevent fast tap duplication
          tileContext.pushOrReplaceTop(targetRoute);
        },
      ),
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final fold = _verticalFold(mediaQuery);

    final isWide = fold != null || mediaQuery.size.width >= 700;

    return KaiselBranchedShell.specs(
      // lazy: true,

      branches: [
        KaiselBranchSpec<HomeRoute>.adaptive(
          initial: const HomeRoot(),
          builder: (context, route, stack) {
            return switch (route) {
              HomeRoot() => const KaiselStandalonePage(HomeScreen()),

              ProductDetailRoute(:final id) => KaiselStandalonePage(
                ProductDetailScreen(id: id),
              ),
            };
          },
        ),
        //below todo
        KaiselBranchSpec<HomeRoute>.adaptive(
          initial: const HomeRoot(),
          builder: (context, route, stack) {
            return switch (route) {
              HomeRoot() => const KaiselStandalonePage(HomeScreen()),

              ProductDetailRoute(:final id) => KaiselStandalonePage(
                ProductDetailScreen(id: id),
              ),
            };
          },
        ),
        KaiselBranchSpec<HomeRoute>.adaptive(
          initial: const HomeRoot(),
          builder: (context, route, stack) {
            return switch (route) {
              HomeRoot() => const KaiselStandalonePage(HomeScreen()),

              ProductDetailRoute(:final id) => KaiselStandalonePage(
                ProductDetailScreen(id: id),
              ),
            };
          },
        ),
        // above todo
        KaiselBranchSpec<SettingsRoute>.adaptive(
          initial: const SettingsMasterRoute(),
          builder: _buildContentRoute,
        ),
      ],
      chromeBuilder: (context, active, content, switchBranch) => (isWide)
          ? Scaffold(
              body: Row(
                children: [
                  NavigationRail(
                    selectedIndex: active,
                    onDestinationSelected: switchBranch,
                    labelType: NavigationRailLabelType.all,
                    backgroundColor: context.theme.colorScheme.surfaceContainer,
                    // Top header icon
                    leading: Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 24),
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor:
                            context.theme.colorScheme.primaryContainer,
                        child: Icon(
                          Icons.settings,
                          color: context.theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    destinations: _navItems.map((item) {
                      return NavigationRailDestination(
                        icon: Icon(item.unselectedIcon),
                        selectedIcon: Icon(item.selectedIcon),
                        label: Text(item.label),
                      );
                    }).toList(),
                  ),
                  const VerticalDivider(width: 1, thickness: 1),
                  Expanded(child: content),
                ],
              ),
            )
          : Scaffold(
              body: content,
              bottomNavigationBar: NavigationBar(
                selectedIndex: active,
                onDestinationSelected: switchBranch,
                destinations: _navItems.map((item) {
                  return NavigationDestination(
                    icon: Icon(item.unselectedIcon),
                    selectedIcon: Icon(item.selectedIcon),
                    label: item.label,
                  );
                }).toList(),
              ),
            ),
    );
  }
}
