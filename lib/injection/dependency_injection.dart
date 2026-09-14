import 'package:blogstore/features/settings/app_setting/domain/usecases/reset_app_settings.dart';
import 'package:firebase_analytics/firebase_analytics.dart'
    show FirebaseAnalytics;
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:firebase_crashlytics/firebase_crashlytics.dart'
    show FirebaseCrashlytics;
import 'package:firebase_messaging/firebase_messaging.dart'
    show FirebaseMessaging;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:material_ui/material_ui.dart'
    show InheritedWidget, BuildContext;

import '../core/analytics/analytics_gateway.dart' show AnalyticsGateway;
import '../core/auth/access_token_provider.dart' show AccessTokenProvider;
import '../core/location/location_service.dart' show LocationService;
import '../core/monitoring/crash_reporter.dart' show CrashReporter;
import '../core/notifications/notification_gateway.dart'
    show NotificationGateway;

import '../features/settings/app_setting/data/datasources/local/app_setting_local_datasource.dart'
    show AppSettingLocalDataSourceImpl, AppSettingLocalDataSource;
import '../features/settings/app_setting/data/repositories/app_setting_repository_impl.dart'
    show AppSettingRepositoryImpl;
import '../features/settings/app_setting/domain/repositories/app_setting_repository.dart'
    show AppSettingRepository;
import '../features/settings/app_setting/domain/usecases/get_app_settings.dart';
import '../features/settings/app_setting/domain/usecases/temp_change_locale.dart';
import '../features/settings/app_setting/domain/usecases/temp_change_seed_color.dart';
import '../features/settings/app_setting/domain/usecases/temp_change_theme_mode.dart';
import '../features/settings/app_setting/domain/usecases/update_consent.dart';
import '../features/settings/app_setting/domain/usecases/update_locale.dart';
import '../features/settings/app_setting/domain/usecases/update_onboarding_completed.dart';
import '../features/settings/app_setting/domain/usecases/update_seed_color.dart';
import '../features/settings/app_setting/domain/usecases/update_theme_mode.dart';
import '../features/settings/app_setting/domain/usecases/watch_app_settings.dart';
import '../features/settings/app_setting/presentation/bloc/app_setting_bloc.dart'
    show AppSettingBloc;
import '../firebase_web_config.dart' show FirebaseWebConfig;
import '../infrastructure/auth/firebase_access_token_provider.dart'
    show FirebaseAccessTokenProvider;
import '../infrastructure/database/drift/app_database.dart' show AppDatabase;
import '../infrastructure/firebase/firebase_analytics_gateway.dart'
    show FirebaseAnalyticsGateway;
import '../infrastructure/firebase/firebase_crash_reporter.dart'
    show FirebaseCrashReporter;
import '../infrastructure/firebase/firebase_initializer.dart'
    show DefaultFirebaseInitializer, FirebaseInitializer;
import '../infrastructure/firebase/firebase_notification_gateway.dart'
    show FirebaseNotificationGateway;
import '../infrastructure/location/geolocator_location_service.dart'
    show GeolocatorLocationService;

final class Dependencies {
  factory Dependencies.create() {
    final db = AppDatabase();
    return Dependencies._(
      database: db,
      firebaseInitializer: DefaultFirebaseInitializer(),
      appSettingLocalDataSource: AppSettingLocalDataSourceImpl(db),
    );
  }

  Dependencies._({
    required this.database,
    required this.firebaseInitializer,
    required this.appSettingLocalDataSource,
  });

  final AppDatabase database;
  final FirebaseInitializer firebaseInitializer;
  final AppSettingLocalDataSource appSettingLocalDataSource;

  // Lazily initialized post-Firebase setup
  //==>
  late final AccessTokenProvider accessTokenProvider =
      FirebaseAccessTokenProvider(FirebaseAuth.instance);

  late final NotificationGateway notificationGateway =
      FirebaseNotificationGateway(
        FirebaseMessaging.instance,
        vapidKey: kIsWeb ? FirebaseWebConfig.vapidKey : null,
        serviceWorkerScriptPath: kIsWeb
            ? FirebaseWebConfig.serviceWorkerScriptPath
            : null,
      );

  late final CrashReporter crashReporter = FirebaseCrashReporter(
    FirebaseCrashlytics.instance,
  );

  late final AnalyticsGateway analyticsGateway = FirebaseAnalyticsGateway(
    FirebaseAnalytics.instance,
  );

  late final LocationService locationService = GeolocatorLocationService();
  //<==
  ///
  late final AppSettingRepository appSettingRepository =
      AppSettingRepositoryImpl(
        localDataSource: appSettingLocalDataSource,
        analyticsGateway: analyticsGateway,
      );

  late final GetAppSettingsUseCase getAppSettings = GetAppSettingsUseCase(
    appSettingRepository,
  );
  late final WatchAppSettingsUseCase watchAppSettings = WatchAppSettingsUseCase(
    appSettingRepository,
  );
  late final ResetAppSettingsUseCase resetAppSettings = ResetAppSettingsUseCase(
    appSettingRepository,
  );
  late final UpdateThemeModeUseCase updateThemeMode = UpdateThemeModeUseCase(
    appSettingRepository,
  );
  late final UpdateLocaleUseCase updateLocale = UpdateLocaleUseCase(
    appSettingRepository,
  );
  late final UpdateSeedColorUseCase updateSeedColor = UpdateSeedColorUseCase(
    appSettingRepository,
  );
  late final UpdateOnboardingCompletedUseCase updateOnboardingCompleted =
      UpdateOnboardingCompletedUseCase(appSettingRepository);
  late final UpdateConsentUseCase updateConsent = UpdateConsentUseCase(
    appSettingRepository,
  );
  //temp
  late final TemporarilyChangeThemeModeUseCase tempChangeThemeMode =
      TemporarilyChangeThemeModeUseCase(appSettingRepository);
  late final TemporarilyChangeLocaleUseCase tempChangeLocale =
      TemporarilyChangeLocaleUseCase(appSettingRepository);
  late final TemporarilyChangeSeedColorUseCase tempChangeSeedColor =
      TemporarilyChangeSeedColorUseCase(appSettingRepository);
  //\temp

  ///
  // Lazy singleton - instantiated on first read in BootStrap
  //  why we do DI like this as We want to avid multiple Factory instances
  // for same Bloc
  late final AppSettingBloc appSettingBloc = AppSettingBloc(
    getAppSettings: getAppSettings,
    resetAppSettings: resetAppSettings,
    updateThemeMode: updateThemeMode,
    updateLocale: updateLocale,
    updateSeedColor: updateSeedColor,
    updateOnboardingCompleted: updateOnboardingCompleted,
    updateConsent: updateConsent,
    tempChangeThemeMode: tempChangeThemeMode,
    tempChangeLocale: tempChangeLocale,
    tempChangeSeedColor: tempChangeSeedColor,
    crashReporter: crashReporter,
  );

  Future<void> dispose() async {
    await appSettingBloc.close();
    await database.close();
  }
}

class DependenciesProvider extends InheritedWidget {
  const DependenciesProvider({
    super.key,
    required this.dependencies,
    required super.child,
  });

  final Dependencies dependencies;

  static Dependencies of(BuildContext context) {
    final DependenciesProvider? result = context
        .dependOnInheritedWidgetOfExactType<DependenciesProvider>();
    assert(result != null, 'No DependenciesProvider found in context');
    return result!.dependencies;
  }

  @override
  bool updateShouldNotify(DependenciesProvider oldWidget) =>
      dependencies != oldWidget.dependencies;
}

extension DependenciesBuildContextX on BuildContext {
  Dependencies get dependencies => DependenciesProvider.of(this);
}
