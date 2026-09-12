// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AppearanceSettingsTable extends AppearanceSettings
    with TableInfo<$AppearanceSettingsTable, AppearanceSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppearanceSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
  static const String $name = 'appearance_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppearanceSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
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
  AppearanceSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppearanceSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
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
  $AppearanceSettingsTable createAlias(String alias) {
    return $AppearanceSettingsTable(attachedDatabase, alias);
  }
}

class AppearanceSetting extends DataClass
    implements Insertable<AppearanceSetting> {
  final int id;
  final bool hasCompletedOnboarding;
  final bool hasGivenConsent;
  final bool analyticsStorageConsentGranted;
  final bool adStorageConsentGranted;
  final bool adUserDataConsentGranted;
  final bool adPersonalizationSignalsConsentGranted;
  final bool functionalityStorageConsentGranted;
  final bool personalizationStorageConsentGranted;
  final bool securityStorageConsentGranted;
  const AppearanceSetting({
    required this.id,
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

  AppearanceSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppearanceSettingsCompanion(
      id: Value(id),
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

  factory AppearanceSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppearanceSetting(
      id: serializer.fromJson<int>(json['id']),
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

  AppearanceSetting copyWith({
    int? id,
    bool? hasCompletedOnboarding,
    bool? hasGivenConsent,
    bool? analyticsStorageConsentGranted,
    bool? adStorageConsentGranted,
    bool? adUserDataConsentGranted,
    bool? adPersonalizationSignalsConsentGranted,
    bool? functionalityStorageConsentGranted,
    bool? personalizationStorageConsentGranted,
    bool? securityStorageConsentGranted,
  }) => AppearanceSetting(
    id: id ?? this.id,
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
  AppearanceSetting copyWithCompanion(AppearanceSettingsCompanion data) {
    return AppearanceSetting(
      id: data.id.present ? data.id.value : this.id,
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
    return (StringBuffer('AppearanceSetting(')
          ..write('id: $id, ')
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
      (other is AppearanceSetting &&
          other.id == this.id &&
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

class AppearanceSettingsCompanion extends UpdateCompanion<AppearanceSetting> {
  final Value<int> id;
  final Value<bool> hasCompletedOnboarding;
  final Value<bool> hasGivenConsent;
  final Value<bool> analyticsStorageConsentGranted;
  final Value<bool> adStorageConsentGranted;
  final Value<bool> adUserDataConsentGranted;
  final Value<bool> adPersonalizationSignalsConsentGranted;
  final Value<bool> functionalityStorageConsentGranted;
  final Value<bool> personalizationStorageConsentGranted;
  final Value<bool> securityStorageConsentGranted;
  const AppearanceSettingsCompanion({
    this.id = const Value.absent(),
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
  AppearanceSettingsCompanion.insert({
    this.id = const Value.absent(),
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
  static Insertable<AppearanceSetting> custom({
    Expression<int>? id,
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

  AppearanceSettingsCompanion copyWith({
    Value<int>? id,
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
    return AppearanceSettingsCompanion(
      id: id ?? this.id,
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
    return (StringBuffer('AppearanceSettingsCompanion(')
          ..write('id: $id, ')
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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AppearanceSettingsTable appearanceSettings =
      $AppearanceSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [appearanceSettings];
}

typedef $$AppearanceSettingsTableCreateCompanionBuilder =
    AppearanceSettingsCompanion Function({
      Value<int> id,
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
typedef $$AppearanceSettingsTableUpdateCompanionBuilder =
    AppearanceSettingsCompanion Function({
      Value<int> id,
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

class $$AppearanceSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppearanceSettingsTable> {
  $$AppearanceSettingsTableFilterComposer({
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

class $$AppearanceSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppearanceSettingsTable> {
  $$AppearanceSettingsTableOrderingComposer({
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

class $$AppearanceSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppearanceSettingsTable> {
  $$AppearanceSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

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

class $$AppearanceSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppearanceSettingsTable,
          AppearanceSetting,
          $$AppearanceSettingsTableFilterComposer,
          $$AppearanceSettingsTableOrderingComposer,
          $$AppearanceSettingsTableAnnotationComposer,
          $$AppearanceSettingsTableCreateCompanionBuilder,
          $$AppearanceSettingsTableUpdateCompanionBuilder,
          (
            AppearanceSetting,
            BaseReferences<
              _$AppDatabase,
              $AppearanceSettingsTable,
              AppearanceSetting
            >,
          ),
          AppearanceSetting,
          PrefetchHooks Function()
        > {
  $$AppearanceSettingsTableTableManager(
    _$AppDatabase db,
    $AppearanceSettingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppearanceSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppearanceSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppearanceSettingsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
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
              }) => AppearanceSettingsCompanion(
                id: id,
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
              }) => AppearanceSettingsCompanion.insert(
                id: id,
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
              .map(
                (e) => (
                  e.readTable<$AppearanceSettingsTable, AppearanceSetting>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $AppearanceSettingsTable,
                    AppearanceSetting
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppearanceSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppearanceSettingsTable,
      AppearanceSetting,
      $$AppearanceSettingsTableFilterComposer,
      $$AppearanceSettingsTableOrderingComposer,
      $$AppearanceSettingsTableAnnotationComposer,
      $$AppearanceSettingsTableCreateCompanionBuilder,
      $$AppearanceSettingsTableUpdateCompanionBuilder,
      (
        AppearanceSetting,
        BaseReferences<
          _$AppDatabase,
          $AppearanceSettingsTable,
          AppearanceSetting
        >,
      ),
      AppearanceSetting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AppearanceSettingsTableTableManager get appearanceSettings =>
      $$AppearanceSettingsTableTableManager(_db, _db.appearanceSettings);
}
