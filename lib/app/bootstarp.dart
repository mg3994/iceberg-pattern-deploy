import 'dart:async';

import 'package:bloc_signals_flutter/bloc_signals_flutter.dart'
    show BlocSignalBuilder, MultiBlocSignalProvider, BlocSignalProvider;
import 'package:blogstore/app/helpers/extensions.dart';
import 'package:blogstore/app/router/router.dart' show AppRouter;
import 'package:cupertino_ui/cupertino_ui.dart'
    show GlobalCupertinoLocalizations;
import 'package:flutter/foundation.dart' show PlatformDispatcher;
import 'package:flutter_localizations/flutter_localizations.dart'
    show GlobalWidgetsLocalizations;
import 'package:intl/intl.dart' show Intl;

import 'package:material_ui/material_ui.dart'
    show
        Widget,
        MaterialApp,
        BuildContext,
        StatefulWidget,
        State,
        SizedBox,
        FlutterError,
        WidgetsBinding,
        StatelessWidget,
        Color,
        Text,
        TextStyle,
        MainAxisSize,
        FontWeight,
        LinearProgressIndicator,
        TextAlign,
        Column,
        Center,
        ColoredBox,
        Directionality,
        TextDirection,
        MaterialUiCompatibilityBridge,
        GlobalMaterialLocalizations,
        GlobalKey,
        NavigatorState;

import '../core/theme/app_theme.dart';

import '../features/settings/app_setting/presentation/bloc/app_setting_bloc.dart'
    show AppSettingBloc, AppSettingState;
import '../features/settings/privacy_setting/privacy_setting.dart'
    show AnalyticsConsentModal;
import '../generated/app_localizations.dart';
import '../infrastructure/firebase/notifications/background_messaging.dart'
    show firebaseMessagingBackgroundHandler;
import '../injection/dependency_injection.dart'
    show Dependencies, DependenciesProvider;

class BootStrap extends StatefulWidget {
  const BootStrap({super.key, required this.binding, this.appSettingsBloc});

  final WidgetsBinding binding;
  final AppSettingBloc? appSettingsBloc;

  @override
  State<BootStrap> createState() => _BootStrapState();
}

class _BootStrapState extends State<BootStrap> {
  double _progress = 0;
  String _loadingMessage = 'Starting application...';

  void _setProgress(double progress, String message) {
    if (!mounted) return;

    setState(() {
      _progress = progress;
      _loadingMessage = message;
    });
  }

  AppRouter? _appRouter;

  Dependencies? _dependencies;
  AppSettingBloc? _appSettingsBloc;

  Future<void> _initAsync() async {
    final dependencies = Dependencies.create();

    try {
      _setProgress(0.0, 'Initializing Firebase...');
      // 1. Initialize Firebase Core
      await dependencies.firebaseInitializer.initialize();

      _setProgress(0.25, 'Configuring notifications...');

      // 2. Register FCM Background Handler immediately post-Firebase initialization
      await dependencies.notificationGateway.registerBackgroundHandler(
        firebaseMessagingBackgroundHandler,
      );
      _setProgress(0.45, 'Configuring application...');
      FlutterError.onError = dependencies.crashReporter.recordFlutterFatalError;
      PlatformDispatcher.instance.onError = (error, stack) {
        dependencies.crashReporter.recordError(error, stack, fatal: true);
        return true;
      };

      Intl.defaultLocale = PlatformDispatcher.instance.locale
          .toLanguageTag(); //usefull For Manish //! TODO: support
      final appSettingBloc =
          widget.appSettingsBloc ?? dependencies.appSettingBloc;

      _setProgress(0.60, 'Loading settings...');
      // Preloads saved SQLite theme/locale into memory BEFORE native splash screen vanishes
      await appSettingBloc.loadSettings();

      _setProgress(0.75, 'Preparing navigation...');
      final appRouter = AppRouter(dependencies, appSettingBloc: appSettingBloc);
      _setProgress(1.0, 'Ready');
      if (!mounted) return;

      setState(() {
        _dependencies = dependencies;
        _appSettingsBloc = appSettingBloc;
        _appRouter = appRouter;
      });
      await dependencies.notificationGateway.requestPermission();
    } catch (error, stack) {
      dependencies.crashReporter.recordError(error, stack, fatal: true);
    } finally {
      allowFirstFrame();
    }
  }

  @override
  void initState() {
    super.initState();
    _initAsync();
  }

  @override
  void dispose() {
    if (widget.appSettingsBloc == null) {
      unawaited(_appSettingsBloc?.close());
    }
    _dependencies?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    allowFirstFrame();

    super.didChangeDependencies();
  }

  void allowFirstFrame() {
    if (!widget.binding.sendFramesToEngine) {
      widget.binding.allowFirstFrame();
    }
  }

  @override
  Widget build(BuildContext context) {
    final dependencies = _dependencies;
    final appSettingBloc = _appSettingsBloc;
    final appRouter = _appRouter;

    if (dependencies == null || appSettingBloc == null || appRouter == null) {
      return _AppBootstrapLoading(
        progress: _progress,
        message: _loadingMessage,
      );
    }

    return DependenciesProvider(
      dependencies: dependencies,
      child: MultiBlocSignalProvider(
        providers: [
          BlocSignalProvider<AppSettingBloc>.value(value: appSettingBloc),
        ],
        child: BlocSignalBuilder<AppSettingBloc, AppSettingState>(
          bloc: appSettingBloc,
          builder: (context, state) {
            return MaterialApp.router(
              routerConfig: appRouter.routerConfig, //  move it outside //TODO:
              builder: (BuildContext context, Widget? child) {
                return MaterialUiCompatibilityBridge(child: child!);
              },

              onGenerateTitle: (context) => context.l10n.appName,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: [
                // ...AppLocalizations.localizationsDelegates, // avoid using this as it is not yet fixed for gen-l10n
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              themeMode: state.themeMode,
              locale: state.locale,
              theme: AppTheme.light(seed: state.seedColor),
              darkTheme: AppTheme.dark(seed: state.seedColor),
            );
          },
        ),
      ),
    );
  }
}

// You will need to add these to your material_ui/material_ui.dart exports
// or import them directly from flutter/widgets.dart:
// import 'package:flutter/widgets.dart' show Directionality, TextDirection;

class _AppBootstrapLoading extends StatelessWidget {
  const _AppBootstrapLoading({required this.progress, required this.message});

  final double progress;
  final String message;

  @override
  Widget build(BuildContext context) {
    final percentage = (progress * 100).round();

    // 1. Wrap the widget tree in Directionality
    return Directionality(
      textDirection: TextDirection.ltr,
      child: ColoredBox(
        color: const Color(0xFF0F172A),
        child: Center(
          child: SizedBox(
            width: 260,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'BlogStore',
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 28),

                LinearProgressIndicator(value: progress),

                const SizedBox(height: 12),

                Text(
                  '$percentage%',
                  style: const TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFFCBD5E1),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
