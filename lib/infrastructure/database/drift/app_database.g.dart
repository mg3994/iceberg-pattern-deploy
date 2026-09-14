// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ThemeMode, int> themeMode =
      GeneratedColumn<int>(
        'theme_mode',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: Constant(AppConfig.defaultThemeMode.index),
      ).withConverter<ThemeMode>($AppSettingsTable.$converterthemeMode);
  static const VerificationMeta _languageCodeMeta = const VerificationMeta(
    'languageCode',
  );
  @override
  late final GeneratedColumn<String> languageCode = GeneratedColumn<String>(
    'language_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: Constant(AppConfig.defaultLocale.languageCode),
  );
  static const VerificationMeta _seedColorMeta = const VerificationMeta(
    'seedColor',
  );
  @override
  late final GeneratedColumn<int> seedColor = GeneratedColumn<int>(
    'seed_color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: Constant(AppConfig.defaultThemeSeedColorHex),
  );
  static const VerificationMeta _hasCompletedOnboardingMeta =
      const VerificationMeta('hasCompletedOnboarding');
  @override
  late final GeneratedColumn<bool> hasCompletedOnboarding =
      GeneratedColumn<bool>(
        'has_completed_onboarding',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("has_completed_onboarding" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _hasGivenConsentMeta = const VerificationMeta(
    'hasGivenConsent',
  );
  @override
  late final GeneratedColumn<bool> hasGivenConsent = GeneratedColumn<bool>(
    'has_given_consent',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_given_consent" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _analyticsStorageConsentGrantedMeta =
      const VerificationMeta('analyticsStorageConsentGranted');
  @override
  late final GeneratedColumn<bool> analyticsStorageConsentGranted =
      GeneratedColumn<bool>(
        'analytics_storage_consent_granted',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("analytics_storage_consent_granted" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _adStorageConsentGrantedMeta =
      const VerificationMeta('adStorageConsentGranted');
  @override
  late final GeneratedColumn<bool> adStorageConsentGranted =
      GeneratedColumn<bool>(
        'ad_storage_consent_granted',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("ad_storage_consent_granted" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _adUserDataConsentGrantedMeta =
      const VerificationMeta('adUserDataConsentGranted');
  @override
  late final GeneratedColumn<bool> adUserDataConsentGranted =
      GeneratedColumn<bool>(
        'ad_user_data_consent_granted',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("ad_user_data_consent_granted" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _adPersonalizationSignalsConsentGrantedMeta =
      const VerificationMeta('adPersonalizationSignalsConsentGranted');
  @override
  late final GeneratedColumn<bool> adPersonalizationSignalsConsentGranted =
      GeneratedColumn<bool>(
        'ad_personalization_signals_consent_granted',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("ad_personalization_signals_consent_granted" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _functionalityStorageConsentGrantedMeta =
      const VerificationMeta('functionalityStorageConsentGranted');
  @override
  late final GeneratedColumn<bool> functionalityStorageConsentGranted =
      GeneratedColumn<bool>(
        'functionality_storage_consent_granted',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("functionality_storage_consent_granted" IN (0, 1))',
        ),
        defaultValue: const Constant(true),
      );
  static const VerificationMeta _personalizationStorageConsentGrantedMeta =
      const VerificationMeta('personalizationStorageConsentGranted');
  @override
  late final GeneratedColumn<bool> personalizationStorageConsentGranted =
      GeneratedColumn<bool>(
        'personalization_storage_consent_granted',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("personalization_storage_consent_granted" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _securityStorageConsentGrantedMeta =
      const VerificationMeta('securityStorageConsentGranted');
  @override
  late final GeneratedColumn<bool> securityStorageConsentGranted =
      GeneratedColumn<bool>(
        'security_storage_consent_granted',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("security_storage_consent_granted" IN (0, 1))',
        ),
        defaultValue: const Constant(true),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    themeMode,
    languageCode,
    seedColor,
    hasCompletedOnboarding,
    hasGivenConsent,
    analyticsStorageConsentGranted,
    adStorageConsentGranted,
    adUserDataConsentGranted,
    adPersonalizationSignalsConsentGranted,
    functionalityStorageConsentGranted,
    personalizationStorageConsentGranted,
    securityStorageConsentGranted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('language_code')) {
      context.handle(
        _languageCodeMeta,
        languageCode.isAcceptableOrUnknown(
          data['language_code']!,
          _languageCodeMeta,
        ),
      );
    }
    if (data.containsKey('seed_color')) {
      context.handle(
        _seedColorMeta,
        seedColor.isAcceptableOrUnknown(data['seed_color']!, _seedColorMeta),
      );
    }
    if (data.containsKey('has_completed_onboarding')) {
      context.handle(
        _hasCompletedOnboardingMeta,
        hasCompletedOnboarding.isAcceptableOrUnknown(
          data['has_completed_onboarding']!,
          _hasCompletedOnboardingMeta,
        ),
      );
    }
    if (data.containsKey('has_given_consent')) {
      context.handle(
        _hasGivenConsentMeta,
        hasGivenConsent.isAcceptableOrUnknown(
          data['has_given_consent']!,
          _hasGivenConsentMeta,
        ),
      );
    }
    if (data.containsKey('analytics_storage_consent_granted')) {
      context.handle(
        _analyticsStorageConsentGrantedMeta,
        analyticsStorageConsentGranted.isAcceptableOrUnknown(
          data['analytics_storage_consent_granted']!,
          _analyticsStorageConsentGrantedMeta,
        ),
      );
    }
    if (data.containsKey('ad_storage_consent_granted')) {
      context.handle(
        _adStorageConsentGrantedMeta,
        adStorageConsentGranted.isAcceptableOrUnknown(
          data['ad_storage_consent_granted']!,
          _adStorageConsentGrantedMeta,
        ),
      );
    }
    if (data.containsKey('ad_user_data_consent_granted')) {
      context.handle(
        _adUserDataConsentGrantedMeta,
        adUserDataConsentGranted.isAcceptableOrUnknown(
          data['ad_user_data_consent_granted']!,
          _adUserDataConsentGrantedMeta,
        ),
      );
    }
    if (data.containsKey('ad_personalization_signals_consent_granted')) {
      context.handle(
        _adPersonalizationSignalsConsentGrantedMeta,
        adPersonalizationSignalsConsentGranted.isAcceptableOrUnknown(
          data['ad_personalization_signals_consent_granted']!,
          _adPersonalizationSignalsConsentGrantedMeta,
        ),
      );
    }
    if (data.containsKey('functionality_storage_consent_granted')) {
      context.handle(
        _functionalityStorageConsentGrantedMeta,
        functionalityStorageConsentGranted.isAcceptableOrUnknown(
          data['functionality_storage_consent_granted']!,
          _functionalityStorageConsentGrantedMeta,
        ),
      );
    }
    if (data.containsKey('personalization_storage_consent_granted')) {
      context.handle(
        _personalizationStorageConsentGrantedMeta,
        personalizationStorageConsentGranted.isAcceptableOrUnknown(
          data['personalization_storage_consent_granted']!,
          _personalizationStorageConsentGrantedMeta,
        ),
      );
    }
    if (data.containsKey('security_storage_consent_granted')) {
      context.handle(
        _securityStorageConsentGrantedMeta,
        securityStorageConsentGranted.isAcceptableOrUnknown(
          data['security_storage_consent_granted']!,
          _securityStorageConsentGrantedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      themeMode: $AppSettingsTable.$converterthemeMode.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}theme_mode'],
        )!,
      ),
      languageCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language_code'],
      )!,
      seedColor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seed_color'],
      )!,
      hasCompletedOnboarding: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_completed_onboarding'],
      )!,
      hasGivenConsent: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_given_consent'],
      )!,
      analyticsStorageConsentGranted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}analytics_storage_consent_granted'],
      )!,
      adStorageConsentGranted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}ad_storage_consent_granted'],
      )!,
      adUserDataConsentGranted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}ad_user_data_consent_granted'],
      )!,
      adPersonalizationSignalsConsentGranted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}ad_personalization_signals_consent_granted'],
      )!,
      functionalityStorageConsentGranted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}functionality_storage_consent_granted'],
      )!,
      personalizationStorageConsentGranted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}personalization_storage_consent_granted'],
      )!,
      securityStorageConsentGranted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}security_storage_consent_granted'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ThemeMode, int, int> $converterthemeMode =
      const EnumIndexConverter<ThemeMode>(ThemeMode.values);
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final int id;
  final ThemeMode themeMode;
  final String languageCode;

  /// Stores ARGB color value as an INTEGER in SQLite
  final int seedColor;
  final bool hasCompletedOnboarding;
  final bool hasGivenConsent;
  final bool analyticsStorageConsentGranted;
  final bool adStorageConsentGranted;
  final bool adUserDataConsentGranted;
  final bool adPersonalizationSignalsConsentGranted;
  final bool functionalityStorageConsentGranted;
  final bool personalizationStorageConsentGranted;
  final bool securityStorageConsentGranted;
  const AppSetting({
    required this.id,
    required this.themeMode,
    required this.languageCode,
    required this.seedColor,
    required this.hasCompletedOnboarding,
    required this.hasGivenConsent,
    required this.analyticsStorageConsentGranted,
    required this.adStorageConsentGranted,
    required this.adUserDataConsentGranted,
    required this.adPersonalizationSignalsConsentGranted,
    required this.functionalityStorageConsentGranted,
    required this.personalizationStorageConsentGranted,
    required this.securityStorageConsentGranted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['theme_mode'] = Variable<int>(
        $AppSettingsTable.$converterthemeMode.toSql(themeMode),
      );
    }
    map['language_code'] = Variable<String>(languageCode);
    map['seed_color'] = Variable<int>(seedColor);
    map['has_completed_onboarding'] = Variable<bool>(hasCompletedOnboarding);
    map['has_given_consent'] = Variable<bool>(hasGivenConsent);
    map['analytics_storage_consent_granted'] = Variable<bool>(
      analyticsStorageConsentGranted,
    );
    map['ad_storage_consent_granted'] = Variable<bool>(adStorageConsentGranted);
    map['ad_user_data_consent_granted'] = Variable<bool>(
      adUserDataConsentGranted,
    );
    map['ad_personalization_signals_consent_granted'] = Variable<bool>(
      adPersonalizationSignalsConsentGranted,
    );
    map['functionality_storage_consent_granted'] = Variable<bool>(
      functionalityStorageConsentGranted,
    );
    map['personalization_storage_consent_granted'] = Variable<bool>(
      personalizationStorageConsentGranted,
    );
    map['security_storage_consent_granted'] = Variable<bool>(
      securityStorageConsentGranted,
    );
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      id: Value(id),
      themeMode: Value(themeMode),
      languageCode: Value(languageCode),
      seedColor: Value(seedColor),
      hasCompletedOnboarding: Value(hasCompletedOnboarding),
      hasGivenConsent: Value(hasGivenConsent),
      analyticsStorageConsentGranted: Value(analyticsStorageConsentGranted),
      adStorageConsentGranted: Value(adStorageConsentGranted),
      adUserDataConsentGranted: Value(adUserDataConsentGranted),
      adPersonalizationSignalsConsentGranted: Value(
        adPersonalizationSignalsConsentGranted,
      ),
      functionalityStorageConsentGranted: Value(
        functionalityStorageConsentGranted,
      ),
      personalizationStorageConsentGranted: Value(
        personalizationStorageConsentGranted,
      ),
      securityStorageConsentGranted: Value(securityStorageConsentGranted),
    );
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      id: serializer.fromJson<int>(json['id']),
      themeMode: $AppSettingsTable.$converterthemeMode.fromJson(
        serializer.fromJson<int>(json['themeMode']),
      ),
      languageCode: serializer.fromJson<String>(json['languageCode']),
      seedColor: serializer.fromJson<int>(json['seedColor']),
      hasCompletedOnboarding: serializer.fromJson<bool>(
        json['hasCompletedOnboarding'],
      ),
      hasGivenConsent: serializer.fromJson<bool>(json['hasGivenConsent']),
      analyticsStorageConsentGranted: serializer.fromJson<bool>(
        json['analyticsStorageConsentGranted'],
      ),
      adStorageConsentGranted: serializer.fromJson<bool>(
        json['adStorageConsentGranted'],
      ),
      adUserDataConsentGranted: serializer.fromJson<bool>(
        json['adUserDataConsentGranted'],
      ),
      adPersonalizationSignalsConsentGranted: serializer.fromJson<bool>(
        json['adPersonalizationSignalsConsentGranted'],
      ),
      functionalityStorageConsentGranted: serializer.fromJson<bool>(
        json['functionalityStorageConsentGranted'],
      ),
      personalizationStorageConsentGranted: serializer.fromJson<bool>(
        json['personalizationStorageConsentGranted'],
      ),
      securityStorageConsentGranted: serializer.fromJson<bool>(
        json['securityStorageConsentGranted'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'themeMode': serializer.toJson<int>(
        $AppSettingsTable.$converterthemeMode.toJson(themeMode),
      ),
      'languageCode': serializer.toJson<String>(languageCode),
      'seedColor': serializer.toJson<int>(seedColor),
      'hasCompletedOnboarding': serializer.toJson<bool>(hasCompletedOnboarding),
      'hasGivenConsent': serializer.toJson<bool>(hasGivenConsent),
      'analyticsStorageConsentGranted': serializer.toJson<bool>(
        analyticsStorageConsentGranted,
      ),
      'adStorageConsentGranted': serializer.toJson<bool>(
        adStorageConsentGranted,
      ),
      'adUserDataConsentGranted': serializer.toJson<bool>(
        adUserDataConsentGranted,
      ),
      'adPersonalizationSignalsConsentGranted': serializer.toJson<bool>(
        adPersonalizationSignalsConsentGranted,
      ),
      'functionalityStorageConsentGranted': serializer.toJson<bool>(
        functionalityStorageConsentGranted,
      ),
      'personalizationStorageConsentGranted': serializer.toJson<bool>(
        personalizationStorageConsentGranted,
      ),
      'securityStorageConsentGranted': serializer.toJson<bool>(
        securityStorageConsentGranted,
      ),
    };
  }

  AppSetting copyWith({
    int? id,
    ThemeMode? themeMode,
    String? languageCode,
    int? seedColor,
    bool? hasCompletedOnboarding,
    bool? hasGivenConsent,
    bool? analyticsStorageConsentGranted,
    bool? adStorageConsentGranted,
    bool? adUserDataConsentGranted,
    bool? adPersonalizationSignalsConsentGranted,
    bool? functionalityStorageConsentGranted,
    bool? personalizationStorageConsentGranted,
    bool? securityStorageConsentGranted,
  }) => AppSetting(
    id: id ?? this.id,
    themeMode: themeMode ?? this.themeMode,
    languageCode: languageCode ?? this.languageCode,
    seedColor: seedColor ?? this.seedColor,
    hasCompletedOnboarding:
        hasCompletedOnboarding ?? this.hasCompletedOnboarding,
    hasGivenConsent: hasGivenConsent ?? this.hasGivenConsent,
    analyticsStorageConsentGranted:
        analyticsStorageConsentGranted ?? this.analyticsStorageConsentGranted,
    adStorageConsentGranted:
        adStorageConsentGranted ?? this.adStorageConsentGranted,
    adUserDataConsentGranted:
        adUserDataConsentGranted ?? this.adUserDataConsentGranted,
    adPersonalizationSignalsConsentGranted:
        adPersonalizationSignalsConsentGranted ??
        this.adPersonalizationSignalsConsentGranted,
    functionalityStorageConsentGranted:
        functionalityStorageConsentGranted ??
        this.functionalityStorageConsentGranted,
    personalizationStorageConsentGranted:
        personalizationStorageConsentGranted ??
        this.personalizationStorageConsentGranted,
    securityStorageConsentGranted:
        securityStorageConsentGranted ?? this.securityStorageConsentGranted,
  );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      id: data.id.present ? data.id.value : this.id,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      languageCode: data.languageCode.present
          ? data.languageCode.value
          : this.languageCode,
      seedColor: data.seedColor.present ? data.seedColor.value : this.seedColor,
      hasCompletedOnboarding: data.hasCompletedOnboarding.present
          ? data.hasCompletedOnboarding.value
          : this.hasCompletedOnboarding,
      hasGivenConsent: data.hasGivenConsent.present
          ? data.hasGivenConsent.value
          : this.hasGivenConsent,
      analyticsStorageConsentGranted:
          data.analyticsStorageConsentGranted.present
          ? data.analyticsStorageConsentGranted.value
          : this.analyticsStorageConsentGranted,
      adStorageConsentGranted: data.adStorageConsentGranted.present
          ? data.adStorageConsentGranted.value
          : this.adStorageConsentGranted,
      adUserDataConsentGranted: data.adUserDataConsentGranted.present
          ? data.adUserDataConsentGranted.value
          : this.adUserDataConsentGranted,
      adPersonalizationSignalsConsentGranted:
          data.adPersonalizationSignalsConsentGranted.present
          ? data.adPersonalizationSignalsConsentGranted.value
          : this.adPersonalizationSignalsConsentGranted,
      functionalityStorageConsentGranted:
          data.functionalityStorageConsentGranted.present
          ? data.functionalityStorageConsentGranted.value
          : this.functionalityStorageConsentGranted,
      personalizationStorageConsentGranted:
          data.personalizationStorageConsentGranted.present
          ? data.personalizationStorageConsentGranted.value
          : this.personalizationStorageConsentGranted,
      securityStorageConsentGranted: data.securityStorageConsentGranted.present
          ? data.securityStorageConsentGranted.value
          : this.securityStorageConsentGranted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('id: $id, ')
          ..write('themeMode: $themeMode, ')
          ..write('languageCode: $languageCode, ')
          ..write('seedColor: $seedColor, ')
          ..write('hasCompletedOnboarding: $hasCompletedOnboarding, ')
          ..write('hasGivenConsent: $hasGivenConsent, ')
          ..write(
            'analyticsStorageConsentGranted: $analyticsStorageConsentGranted, ',
          )
          ..write('adStorageConsentGranted: $adStorageConsentGranted, ')
          ..write('adUserDataConsentGranted: $adUserDataConsentGranted, ')
          ..write(
            'adPersonalizationSignalsConsentGranted: $adPersonalizationSignalsConsentGranted, ',
          )
          ..write(
            'functionalityStorageConsentGranted: $functionalityStorageConsentGranted, ',
          )
          ..write(
            'personalizationStorageConsentGranted: $personalizationStorageConsentGranted, ',
          )
          ..write(
            'securityStorageConsentGranted: $securityStorageConsentGranted',
          )
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    themeMode,
    languageCode,
    seedColor,
    hasCompletedOnboarding,
    hasGivenConsent,
    analyticsStorageConsentGranted,
    adStorageConsentGranted,
    adUserDataConsentGranted,
    adPersonalizationSignalsConsentGranted,
    functionalityStorageConsentGranted,
    personalizationStorageConsentGranted,
    securityStorageConsentGranted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.id == this.id &&
          other.themeMode == this.themeMode &&
          other.languageCode == this.languageCode &&
          other.seedColor == this.seedColor &&
          other.hasCompletedOnboarding == this.hasCompletedOnboarding &&
          other.hasGivenConsent == this.hasGivenConsent &&
          other.analyticsStorageConsentGranted ==
              this.analyticsStorageConsentGranted &&
          other.adStorageConsentGranted == this.adStorageConsentGranted &&
          other.adUserDataConsentGranted == this.adUserDataConsentGranted &&
          other.adPersonalizationSignalsConsentGranted ==
              this.adPersonalizationSignalsConsentGranted &&
          other.functionalityStorageConsentGranted ==
              this.functionalityStorageConsentGranted &&
          other.personalizationStorageConsentGranted ==
              this.personalizationStorageConsentGranted &&
          other.securityStorageConsentGranted ==
              this.securityStorageConsentGranted);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<int> id;
  final Value<ThemeMode> themeMode;
  final Value<String> languageCode;
  final Value<int> seedColor;
  final Value<bool> hasCompletedOnboarding;
  final Value<bool> hasGivenConsent;
  final Value<bool> analyticsStorageConsentGranted;
  final Value<bool> adStorageConsentGranted;
  final Value<bool> adUserDataConsentGranted;
  final Value<bool> adPersonalizationSignalsConsentGranted;
  final Value<bool> functionalityStorageConsentGranted;
  final Value<bool> personalizationStorageConsentGranted;
  final Value<bool> securityStorageConsentGranted;
  const AppSettingsCompanion({
    this.id = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.languageCode = const Value.absent(),
    this.seedColor = const Value.absent(),
    this.hasCompletedOnboarding = const Value.absent(),
    this.hasGivenConsent = const Value.absent(),
    this.analyticsStorageConsentGranted = const Value.absent(),
    this.adStorageConsentGranted = const Value.absent(),
    this.adUserDataConsentGranted = const Value.absent(),
    this.adPersonalizationSignalsConsentGranted = const Value.absent(),
    this.functionalityStorageConsentGranted = const Value.absent(),
    this.personalizationStorageConsentGranted = const Value.absent(),
    this.securityStorageConsentGranted = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.languageCode = const Value.absent(),
    this.seedColor = const Value.absent(),
    this.hasCompletedOnboarding = const Value.absent(),
    this.hasGivenConsent = const Value.absent(),
    this.analyticsStorageConsentGranted = const Value.absent(),
    this.adStorageConsentGranted = const Value.absent(),
    this.adUserDataConsentGranted = const Value.absent(),
    this.adPersonalizationSignalsConsentGranted = const Value.absent(),
    this.functionalityStorageConsentGranted = const Value.absent(),
    this.personalizationStorageConsentGranted = const Value.absent(),
    this.securityStorageConsentGranted = const Value.absent(),
  });
  static Insertable<AppSetting> custom({
    Expression<int>? id,
    Expression<int>? themeMode,
    Expression<String>? languageCode,
    Expression<int>? seedColor,
    Expression<bool>? hasCompletedOnboarding,
    Expression<bool>? hasGivenConsent,
    Expression<bool>? analyticsStorageConsentGranted,
    Expression<bool>? adStorageConsentGranted,
    Expression<bool>? adUserDataConsentGranted,
    Expression<bool>? adPersonalizationSignalsConsentGranted,
    Expression<bool>? functionalityStorageConsentGranted,
    Expression<bool>? personalizationStorageConsentGranted,
    Expression<bool>? securityStorageConsentGranted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (themeMode != null) 'theme_mode': themeMode,
      if (languageCode != null) 'language_code': languageCode,
      if (seedColor != null) 'seed_color': seedColor,
      if (hasCompletedOnboarding != null)
        'has_completed_onboarding': hasCompletedOnboarding,
      if (hasGivenConsent != null) 'has_given_consent': hasGivenConsent,
      if (analyticsStorageConsentGranted != null)
        'analytics_storage_consent_granted': analyticsStorageConsentGranted,
      if (adStorageConsentGranted != null)
        'ad_storage_consent_granted': adStorageConsentGranted,
      if (adUserDataConsentGranted != null)
        'ad_user_data_consent_granted': adUserDataConsentGranted,
      if (adPersonalizationSignalsConsentGranted != null)
        'ad_personalization_signals_consent_granted':
            adPersonalizationSignalsConsentGranted,
      if (functionalityStorageConsentGranted != null)
        'functionality_storage_consent_granted':
            functionalityStorageConsentGranted,
      if (personalizationStorageConsentGranted != null)
        'personalization_storage_consent_granted':
            personalizationStorageConsentGranted,
      if (securityStorageConsentGranted != null)
        'security_storage_consent_granted': securityStorageConsentGranted,
    });
  }

  AppSettingsCompanion copyWith({
    Value<int>? id,
    Value<ThemeMode>? themeMode,
    Value<String>? languageCode,
    Value<int>? seedColor,
    Value<bool>? hasCompletedOnboarding,
    Value<bool>? hasGivenConsent,
    Value<bool>? analyticsStorageConsentGranted,
    Value<bool>? adStorageConsentGranted,
    Value<bool>? adUserDataConsentGranted,
    Value<bool>? adPersonalizationSignalsConsentGranted,
    Value<bool>? functionalityStorageConsentGranted,
    Value<bool>? personalizationStorageConsentGranted,
    Value<bool>? securityStorageConsentGranted,
  }) {
    return AppSettingsCompanion(
      id: id ?? this.id,
      themeMode: themeMode ?? this.themeMode,
      languageCode: languageCode ?? this.languageCode,
      seedColor: seedColor ?? this.seedColor,
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      hasGivenConsent: hasGivenConsent ?? this.hasGivenConsent,
      analyticsStorageConsentGranted:
          analyticsStorageConsentGranted ?? this.analyticsStorageConsentGranted,
      adStorageConsentGranted:
          adStorageConsentGranted ?? this.adStorageConsentGranted,
      adUserDataConsentGranted:
          adUserDataConsentGranted ?? this.adUserDataConsentGranted,
      adPersonalizationSignalsConsentGranted:
          adPersonalizationSignalsConsentGranted ??
          this.adPersonalizationSignalsConsentGranted,
      functionalityStorageConsentGranted:
          functionalityStorageConsentGranted ??
          this.functionalityStorageConsentGranted,
      personalizationStorageConsentGranted:
          personalizationStorageConsentGranted ??
          this.personalizationStorageConsentGranted,
      securityStorageConsentGranted:
          securityStorageConsentGranted ?? this.securityStorageConsentGranted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<int>(
        $AppSettingsTable.$converterthemeMode.toSql(themeMode.value),
      );
    }
    if (languageCode.present) {
      map['language_code'] = Variable<String>(languageCode.value);
    }
    if (seedColor.present) {
      map['seed_color'] = Variable<int>(seedColor.value);
    }
    if (hasCompletedOnboarding.present) {
      map['has_completed_onboarding'] = Variable<bool>(
        hasCompletedOnboarding.value,
      );
    }
    if (hasGivenConsent.present) {
      map['has_given_consent'] = Variable<bool>(hasGivenConsent.value);
    }
    if (analyticsStorageConsentGranted.present) {
      map['analytics_storage_consent_granted'] = Variable<bool>(
        analyticsStorageConsentGranted.value,
      );
    }
    if (adStorageConsentGranted.present) {
      map['ad_storage_consent_granted'] = Variable<bool>(
        adStorageConsentGranted.value,
      );
    }
    if (adUserDataConsentGranted.present) {
      map['ad_user_data_consent_granted'] = Variable<bool>(
        adUserDataConsentGranted.value,
      );
    }
    if (adPersonalizationSignalsConsentGranted.present) {
      map['ad_personalization_signals_consent_granted'] = Variable<bool>(
        adPersonalizationSignalsConsentGranted.value,
      );
    }
    if (functionalityStorageConsentGranted.present) {
      map['functionality_storage_consent_granted'] = Variable<bool>(
        functionalityStorageConsentGranted.value,
      );
    }
    if (personalizationStorageConsentGranted.present) {
      map['personalization_storage_consent_granted'] = Variable<bool>(
        personalizationStorageConsentGranted.value,
      );
    }
    if (securityStorageConsentGranted.present) {
      map['security_storage_consent_granted'] = Variable<bool>(
        securityStorageConsentGranted.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('id: $id, ')
          ..write('themeMode: $themeMode, ')
          ..write('languageCode: $languageCode, ')
          ..write('seedColor: $seedColor, ')
          ..write('hasCompletedOnboarding: $hasCompletedOnboarding, ')
          ..write('hasGivenConsent: $hasGivenConsent, ')
          ..write(
            'analyticsStorageConsentGranted: $analyticsStorageConsentGranted, ',
          )
          ..write('adStorageConsentGranted: $adStorageConsentGranted, ')
          ..write('adUserDataConsentGranted: $adUserDataConsentGranted, ')
          ..write(
            'adPersonalizationSignalsConsentGranted: $adPersonalizationSignalsConsentGranted, ',
          )
          ..write(
            'functionalityStorageConsentGranted: $functionalityStorageConsentGranted, ',
          )
          ..write(
            'personalizationStorageConsentGranted: $personalizationStorageConsentGranted, ',
          )
          ..write(
            'securityStorageConsentGranted: $securityStorageConsentGranted',
          )
          ..write(')'))
        .toString();
  }
}

class $CachedCatalogProductsTable extends CachedCatalogProducts
    with TableInfo<$CachedCatalogProductsTable, CachedCatalogProduct> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedCatalogProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceUrlMeta = const VerificationMeta(
    'sourceUrl',
  );
  @override
  late final GeneratedColumn<String> sourceUrl = GeneratedColumn<String>(
    'source_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serviceAreasJsonMeta = const VerificationMeta(
    'serviceAreasJson',
  );
  @override
  late final GeneratedColumn<String> serviceAreasJson = GeneratedColumn<String>(
    'service_areas_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _publishedAtMeta = const VerificationMeta(
    'publishedAt',
  );
  @override
  late final GeneratedColumn<DateTime> publishedAt = GeneratedColumn<DateTime>(
    'published_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    imageUrl,
    price,
    currency,
    sourceUrl,
    serviceAreasJson,
    publishedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_catalog_products';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedCatalogProduct> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('source_url')) {
      context.handle(
        _sourceUrlMeta,
        sourceUrl.isAcceptableOrUnknown(data['source_url']!, _sourceUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceUrlMeta);
    }
    if (data.containsKey('service_areas_json')) {
      context.handle(
        _serviceAreasJsonMeta,
        serviceAreasJson.isAcceptableOrUnknown(
          data['service_areas_json']!,
          _serviceAreasJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_serviceAreasJsonMeta);
    }
    if (data.containsKey('published_at')) {
      context.handle(
        _publishedAtMeta,
        publishedAt.isAcceptableOrUnknown(
          data['published_at']!,
          _publishedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedCatalogProduct map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedCatalogProduct(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      ),
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      ),
      sourceUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_url'],
      )!,
      serviceAreasJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}service_areas_json'],
      )!,
      publishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}published_at'],
      ),
    );
  }

  @override
  $CachedCatalogProductsTable createAlias(String alias) {
    return $CachedCatalogProductsTable(attachedDatabase, alias);
  }
}

class CachedCatalogProduct extends DataClass
    implements Insertable<CachedCatalogProduct> {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final double? price;
  final String? currency;
  final String sourceUrl;
  final String serviceAreasJson;
  final DateTime? publishedAt;
  const CachedCatalogProduct({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    this.price,
    this.currency,
    required this.sourceUrl,
    required this.serviceAreasJson,
    this.publishedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    if (!nullToAbsent || price != null) {
      map['price'] = Variable<double>(price);
    }
    if (!nullToAbsent || currency != null) {
      map['currency'] = Variable<String>(currency);
    }
    map['source_url'] = Variable<String>(sourceUrl);
    map['service_areas_json'] = Variable<String>(serviceAreasJson);
    if (!nullToAbsent || publishedAt != null) {
      map['published_at'] = Variable<DateTime>(publishedAt);
    }
    return map;
  }

  CachedCatalogProductsCompanion toCompanion(bool nullToAbsent) {
    return CachedCatalogProductsCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      price: price == null && nullToAbsent
          ? const Value.absent()
          : Value(price),
      currency: currency == null && nullToAbsent
          ? const Value.absent()
          : Value(currency),
      sourceUrl: Value(sourceUrl),
      serviceAreasJson: Value(serviceAreasJson),
      publishedAt: publishedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(publishedAt),
    );
  }

  factory CachedCatalogProduct.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedCatalogProduct(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      price: serializer.fromJson<double?>(json['price']),
      currency: serializer.fromJson<String?>(json['currency']),
      sourceUrl: serializer.fromJson<String>(json['sourceUrl']),
      serviceAreasJson: serializer.fromJson<String>(json['serviceAreasJson']),
      publishedAt: serializer.fromJson<DateTime?>(json['publishedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'price': serializer.toJson<double?>(price),
      'currency': serializer.toJson<String?>(currency),
      'sourceUrl': serializer.toJson<String>(sourceUrl),
      'serviceAreasJson': serializer.toJson<String>(serviceAreasJson),
      'publishedAt': serializer.toJson<DateTime?>(publishedAt),
    };
  }

  CachedCatalogProduct copyWith({
    String? id,
    String? name,
    String? description,
    Value<String?> imageUrl = const Value.absent(),
    Value<double?> price = const Value.absent(),
    Value<String?> currency = const Value.absent(),
    String? sourceUrl,
    String? serviceAreasJson,
    Value<DateTime?> publishedAt = const Value.absent(),
  }) => CachedCatalogProduct(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    price: price.present ? price.value : this.price,
    currency: currency.present ? currency.value : this.currency,
    sourceUrl: sourceUrl ?? this.sourceUrl,
    serviceAreasJson: serviceAreasJson ?? this.serviceAreasJson,
    publishedAt: publishedAt.present ? publishedAt.value : this.publishedAt,
  );
  CachedCatalogProduct copyWithCompanion(CachedCatalogProductsCompanion data) {
    return CachedCatalogProduct(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      price: data.price.present ? data.price.value : this.price,
      currency: data.currency.present ? data.currency.value : this.currency,
      sourceUrl: data.sourceUrl.present ? data.sourceUrl.value : this.sourceUrl,
      serviceAreasJson: data.serviceAreasJson.present
          ? data.serviceAreasJson.value
          : this.serviceAreasJson,
      publishedAt: data.publishedAt.present
          ? data.publishedAt.value
          : this.publishedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedCatalogProduct(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('price: $price, ')
          ..write('currency: $currency, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('serviceAreasJson: $serviceAreasJson, ')
          ..write('publishedAt: $publishedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    imageUrl,
    price,
    currency,
    sourceUrl,
    serviceAreasJson,
    publishedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedCatalogProduct &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.imageUrl == this.imageUrl &&
          other.price == this.price &&
          other.currency == this.currency &&
          other.sourceUrl == this.sourceUrl &&
          other.serviceAreasJson == this.serviceAreasJson &&
          other.publishedAt == this.publishedAt);
}

class CachedCatalogProductsCompanion
    extends UpdateCompanion<CachedCatalogProduct> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> description;
  final Value<String?> imageUrl;
  final Value<double?> price;
  final Value<String?> currency;
  final Value<String> sourceUrl;
  final Value<String> serviceAreasJson;
  final Value<DateTime?> publishedAt;
  final Value<int> rowid;
  const CachedCatalogProductsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.price = const Value.absent(),
    this.currency = const Value.absent(),
    this.sourceUrl = const Value.absent(),
    this.serviceAreasJson = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedCatalogProductsCompanion.insert({
    required String id,
    required String name,
    required String description,
    this.imageUrl = const Value.absent(),
    this.price = const Value.absent(),
    this.currency = const Value.absent(),
    required String sourceUrl,
    required String serviceAreasJson,
    this.publishedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       description = Value(description),
       sourceUrl = Value(sourceUrl),
       serviceAreasJson = Value(serviceAreasJson);
  static Insertable<CachedCatalogProduct> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? imageUrl,
    Expression<double>? price,
    Expression<String>? currency,
    Expression<String>? sourceUrl,
    Expression<String>? serviceAreasJson,
    Expression<DateTime>? publishedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (imageUrl != null) 'image_url': imageUrl,
      if (price != null) 'price': price,
      if (currency != null) 'currency': currency,
      if (sourceUrl != null) 'source_url': sourceUrl,
      if (serviceAreasJson != null) 'service_areas_json': serviceAreasJson,
      if (publishedAt != null) 'published_at': publishedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedCatalogProductsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? description,
    Value<String?>? imageUrl,
    Value<double?>? price,
    Value<String?>? currency,
    Value<String>? sourceUrl,
    Value<String>? serviceAreasJson,
    Value<DateTime?>? publishedAt,
    Value<int>? rowid,
  }) {
    return CachedCatalogProductsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      serviceAreasJson: serviceAreasJson ?? this.serviceAreasJson,
      publishedAt: publishedAt ?? this.publishedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (sourceUrl.present) {
      map['source_url'] = Variable<String>(sourceUrl.value);
    }
    if (serviceAreasJson.present) {
      map['service_areas_json'] = Variable<String>(serviceAreasJson.value);
    }
    if (publishedAt.present) {
      map['published_at'] = Variable<DateTime>(publishedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedCatalogProductsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('price: $price, ')
          ..write('currency: $currency, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('serviceAreasJson: $serviceAreasJson, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $CachedCatalogProductsTable cachedCatalogProducts =
      $CachedCatalogProductsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    appSettings,
    cachedCatalogProducts,
  ];
}

typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<ThemeMode> themeMode,
      Value<String> languageCode,
      Value<int> seedColor,
      Value<bool> hasCompletedOnboarding,
      Value<bool> hasGivenConsent,
      Value<bool> analyticsStorageConsentGranted,
      Value<bool> adStorageConsentGranted,
      Value<bool> adUserDataConsentGranted,
      Value<bool> adPersonalizationSignalsConsentGranted,
      Value<bool> functionalityStorageConsentGranted,
      Value<bool> personalizationStorageConsentGranted,
      Value<bool> securityStorageConsentGranted,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<ThemeMode> themeMode,
      Value<String> languageCode,
      Value<int> seedColor,
      Value<bool> hasCompletedOnboarding,
      Value<bool> hasGivenConsent,
      Value<bool> analyticsStorageConsentGranted,
      Value<bool> adStorageConsentGranted,
      Value<bool> adUserDataConsentGranted,
      Value<bool> adPersonalizationSignalsConsentGranted,
      Value<bool> functionalityStorageConsentGranted,
      Value<bool> personalizationStorageConsentGranted,
      Value<bool> securityStorageConsentGranted,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ThemeMode, ThemeMode, int> get themeMode =>
      $composableBuilder(
        column: $table.themeMode,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get seedColor => $composableBuilder(
    column: $table.seedColor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasCompletedOnboarding => $composableBuilder(
    column: $table.hasCompletedOnboarding,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasGivenConsent => $composableBuilder(
    column: $table.hasGivenConsent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get analyticsStorageConsentGranted => $composableBuilder(
    column: $table.analyticsStorageConsentGranted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get adStorageConsentGranted => $composableBuilder(
    column: $table.adStorageConsentGranted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get adUserDataConsentGranted => $composableBuilder(
    column: $table.adUserDataConsentGranted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get adPersonalizationSignalsConsentGranted =>
      $composableBuilder(
        column: $table.adPersonalizationSignalsConsentGranted,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<bool> get functionalityStorageConsentGranted =>
      $composableBuilder(
        column: $table.functionalityStorageConsentGranted,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<bool> get personalizationStorageConsentGranted =>
      $composableBuilder(
        column: $table.personalizationStorageConsentGranted,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<bool> get securityStorageConsentGranted => $composableBuilder(
    column: $table.securityStorageConsentGranted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get seedColor => $composableBuilder(
    column: $table.seedColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasCompletedOnboarding => $composableBuilder(
    column: $table.hasCompletedOnboarding,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasGivenConsent => $composableBuilder(
    column: $table.hasGivenConsent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get analyticsStorageConsentGranted =>
      $composableBuilder(
        column: $table.analyticsStorageConsentGranted,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<bool> get adStorageConsentGranted => $composableBuilder(
    column: $table.adStorageConsentGranted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get adUserDataConsentGranted => $composableBuilder(
    column: $table.adUserDataConsentGranted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get adPersonalizationSignalsConsentGranted =>
      $composableBuilder(
        column: $table.adPersonalizationSignalsConsentGranted,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<bool> get functionalityStorageConsentGranted =>
      $composableBuilder(
        column: $table.functionalityStorageConsentGranted,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<bool> get personalizationStorageConsentGranted =>
      $composableBuilder(
        column: $table.personalizationStorageConsentGranted,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<bool> get securityStorageConsentGranted => $composableBuilder(
    column: $table.securityStorageConsentGranted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ThemeMode, int> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumn<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get seedColor =>
      $composableBuilder(column: $table.seedColor, builder: (column) => column);

  GeneratedColumn<bool> get hasCompletedOnboarding => $composableBuilder(
    column: $table.hasCompletedOnboarding,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hasGivenConsent => $composableBuilder(
    column: $table.hasGivenConsent,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get analyticsStorageConsentGranted =>
      $composableBuilder(
        column: $table.analyticsStorageConsentGranted,
        builder: (column) => column,
      );

  GeneratedColumn<bool> get adStorageConsentGranted => $composableBuilder(
    column: $table.adStorageConsentGranted,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get adUserDataConsentGranted => $composableBuilder(
    column: $table.adUserDataConsentGranted,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get adPersonalizationSignalsConsentGranted =>
      $composableBuilder(
        column: $table.adPersonalizationSignalsConsentGranted,
        builder: (column) => column,
      );

  GeneratedColumn<bool> get functionalityStorageConsentGranted =>
      $composableBuilder(
        column: $table.functionalityStorageConsentGranted,
        builder: (column) => column,
      );

  GeneratedColumn<bool> get personalizationStorageConsentGranted =>
      $composableBuilder(
        column: $table.personalizationStorageConsentGranted,
        builder: (column) => column,
      );

  GeneratedColumn<bool> get securityStorageConsentGranted => $composableBuilder(
    column: $table.securityStorageConsentGranted,
    builder: (column) => column,
  );
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<ThemeMode> themeMode = const Value.absent(),
                Value<String> languageCode = const Value.absent(),
                Value<int> seedColor = const Value.absent(),
                Value<bool> hasCompletedOnboarding = const Value.absent(),
                Value<bool> hasGivenConsent = const Value.absent(),
                Value<bool> analyticsStorageConsentGranted =
                    const Value.absent(),
                Value<bool> adStorageConsentGranted = const Value.absent(),
                Value<bool> adUserDataConsentGranted = const Value.absent(),
                Value<bool> adPersonalizationSignalsConsentGranted =
                    const Value.absent(),
                Value<bool> functionalityStorageConsentGranted =
                    const Value.absent(),
                Value<bool> personalizationStorageConsentGranted =
                    const Value.absent(),
                Value<bool> securityStorageConsentGranted =
                    const Value.absent(),
              }) => AppSettingsCompanion(
                id: id,
                themeMode: themeMode,
                languageCode: languageCode,
                seedColor: seedColor,
                hasCompletedOnboarding: hasCompletedOnboarding,
                hasGivenConsent: hasGivenConsent,
                analyticsStorageConsentGranted: analyticsStorageConsentGranted,
                adStorageConsentGranted: adStorageConsentGranted,
                adUserDataConsentGranted: adUserDataConsentGranted,
                adPersonalizationSignalsConsentGranted:
                    adPersonalizationSignalsConsentGranted,
                functionalityStorageConsentGranted:
                    functionalityStorageConsentGranted,
                personalizationStorageConsentGranted:
                    personalizationStorageConsentGranted,
                securityStorageConsentGranted: securityStorageConsentGranted,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<ThemeMode> themeMode = const Value.absent(),
                Value<String> languageCode = const Value.absent(),
                Value<int> seedColor = const Value.absent(),
                Value<bool> hasCompletedOnboarding = const Value.absent(),
                Value<bool> hasGivenConsent = const Value.absent(),
                Value<bool> analyticsStorageConsentGranted =
                    const Value.absent(),
                Value<bool> adStorageConsentGranted = const Value.absent(),
                Value<bool> adUserDataConsentGranted = const Value.absent(),
                Value<bool> adPersonalizationSignalsConsentGranted =
                    const Value.absent(),
                Value<bool> functionalityStorageConsentGranted =
                    const Value.absent(),
                Value<bool> personalizationStorageConsentGranted =
                    const Value.absent(),
                Value<bool> securityStorageConsentGranted =
                    const Value.absent(),
              }) => AppSettingsCompanion.insert(
                id: id,
                themeMode: themeMode,
                languageCode: languageCode,
                seedColor: seedColor,
                hasCompletedOnboarding: hasCompletedOnboarding,
                hasGivenConsent: hasGivenConsent,
                analyticsStorageConsentGranted: analyticsStorageConsentGranted,
                adStorageConsentGranted: adStorageConsentGranted,
                adUserDataConsentGranted: adUserDataConsentGranted,
                adPersonalizationSignalsConsentGranted:
                    adPersonalizationSignalsConsentGranted,
                functionalityStorageConsentGranted:
                    functionalityStorageConsentGranted,
                personalizationStorageConsentGranted:
                    personalizationStorageConsentGranted,
                securityStorageConsentGranted: securityStorageConsentGranted,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;
typedef $$CachedCatalogProductsTableCreateCompanionBuilder =
    CachedCatalogProductsCompanion Function({
      required String id,
      required String name,
      required String description,
      Value<String?> imageUrl,
      Value<double?> price,
      Value<String?> currency,
      required String sourceUrl,
      required String serviceAreasJson,
      Value<DateTime?> publishedAt,
      Value<int> rowid,
    });
typedef $$CachedCatalogProductsTableUpdateCompanionBuilder =
    CachedCatalogProductsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> description,
      Value<String?> imageUrl,
      Value<double?> price,
      Value<String?> currency,
      Value<String> sourceUrl,
      Value<String> serviceAreasJson,
      Value<DateTime?> publishedAt,
      Value<int> rowid,
    });

class $$CachedCatalogProductsTableFilterComposer
    extends Composer<_$AppDatabase, $CachedCatalogProductsTable> {
  $$CachedCatalogProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceUrl => $composableBuilder(
    column: $table.sourceUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serviceAreasJson => $composableBuilder(
    column: $table.serviceAreasJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedCatalogProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedCatalogProductsTable> {
  $$CachedCatalogProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceUrl => $composableBuilder(
    column: $table.sourceUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serviceAreasJson => $composableBuilder(
    column: $table.serviceAreasJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedCatalogProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedCatalogProductsTable> {
  $$CachedCatalogProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get sourceUrl =>
      $composableBuilder(column: $table.sourceUrl, builder: (column) => column);

  GeneratedColumn<String> get serviceAreasJson => $composableBuilder(
    column: $table.serviceAreasJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => column,
  );
}

class $$CachedCatalogProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedCatalogProductsTable,
          CachedCatalogProduct,
          $$CachedCatalogProductsTableFilterComposer,
          $$CachedCatalogProductsTableOrderingComposer,
          $$CachedCatalogProductsTableAnnotationComposer,
          $$CachedCatalogProductsTableCreateCompanionBuilder,
          $$CachedCatalogProductsTableUpdateCompanionBuilder,
          (
            CachedCatalogProduct,
            BaseReferences<
              _$AppDatabase,
              $CachedCatalogProductsTable,
              CachedCatalogProduct
            >,
          ),
          CachedCatalogProduct,
          PrefetchHooks Function()
        > {
  $$CachedCatalogProductsTableTableManager(
    _$AppDatabase db,
    $CachedCatalogProductsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedCatalogProductsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$CachedCatalogProductsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CachedCatalogProductsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<double?> price = const Value.absent(),
                Value<String?> currency = const Value.absent(),
                Value<String> sourceUrl = const Value.absent(),
                Value<String> serviceAreasJson = const Value.absent(),
                Value<DateTime?> publishedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedCatalogProductsCompanion(
                id: id,
                name: name,
                description: description,
                imageUrl: imageUrl,
                price: price,
                currency: currency,
                sourceUrl: sourceUrl,
                serviceAreasJson: serviceAreasJson,
                publishedAt: publishedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String description,
                Value<String?> imageUrl = const Value.absent(),
                Value<double?> price = const Value.absent(),
                Value<String?> currency = const Value.absent(),
                required String sourceUrl,
                required String serviceAreasJson,
                Value<DateTime?> publishedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedCatalogProductsCompanion.insert(
                id: id,
                name: name,
                description: description,
                imageUrl: imageUrl,
                price: price,
                currency: currency,
                sourceUrl: sourceUrl,
                serviceAreasJson: serviceAreasJson,
                publishedAt: publishedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedCatalogProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedCatalogProductsTable,
      CachedCatalogProduct,
      $$CachedCatalogProductsTableFilterComposer,
      $$CachedCatalogProductsTableOrderingComposer,
      $$CachedCatalogProductsTableAnnotationComposer,
      $$CachedCatalogProductsTableCreateCompanionBuilder,
      $$CachedCatalogProductsTableUpdateCompanionBuilder,
      (
        CachedCatalogProduct,
        BaseReferences<
          _$AppDatabase,
          $CachedCatalogProductsTable,
          CachedCatalogProduct
        >,
      ),
      CachedCatalogProduct,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$CachedCatalogProductsTableTableManager get cachedCatalogProducts =>
      $$CachedCatalogProductsTableTableManager(_db, _db.cachedCatalogProducts);
}
