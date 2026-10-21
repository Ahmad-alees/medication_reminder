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
  static const VerificationMeta _onboardingCompletedMeta =
      const VerificationMeta('onboardingCompleted');
  @override
  late final GeneratedColumn<bool> onboardingCompleted = GeneratedColumn<bool>(
    'onboarding_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("onboarding_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, onboardingCompleted];
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
    if (data.containsKey('onboarding_completed')) {
      context.handle(
        _onboardingCompletedMeta,
        onboardingCompleted.isAcceptableOrUnknown(
          data['onboarding_completed']!,
          _onboardingCompletedMeta,
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
      onboardingCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}onboarding_completed'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final int id;
  final bool onboardingCompleted;
  const AppSetting({required this.id, required this.onboardingCompleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['onboarding_completed'] = Variable<bool>(onboardingCompleted);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      id: Value(id),
      onboardingCompleted: Value(onboardingCompleted),
    );
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      id: serializer.fromJson<int>(json['id']),
      onboardingCompleted: serializer.fromJson<bool>(
        json['onboardingCompleted'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'onboardingCompleted': serializer.toJson<bool>(onboardingCompleted),
    };
  }

  AppSetting copyWith({int? id, bool? onboardingCompleted}) => AppSetting(
    id: id ?? this.id,
    onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
  );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      id: data.id.present ? data.id.value : this.id,
      onboardingCompleted: data.onboardingCompleted.present
          ? data.onboardingCompleted.value
          : this.onboardingCompleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('id: $id, ')
          ..write('onboardingCompleted: $onboardingCompleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, onboardingCompleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.id == this.id &&
          other.onboardingCompleted == this.onboardingCompleted);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<int> id;
  final Value<bool> onboardingCompleted;
  const AppSettingsCompanion({
    this.id = const Value.absent(),
    this.onboardingCompleted = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.onboardingCompleted = const Value.absent(),
  });
  static Insertable<AppSetting> custom({
    Expression<int>? id,
    Expression<bool>? onboardingCompleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (onboardingCompleted != null)
        'onboarding_completed': onboardingCompleted,
    });
  }

  AppSettingsCompanion copyWith({
    Value<int>? id,
    Value<bool>? onboardingCompleted,
  }) {
    return AppSettingsCompanion(
      id: id ?? this.id,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (onboardingCompleted.present) {
      map['onboarding_completed'] = Variable<bool>(onboardingCompleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('id: $id, ')
          ..write('onboardingCompleted: $onboardingCompleted')
          ..write(')'))
        .toString();
  }
}

class $MedicationsTable extends Medications
    with TableInfo<$MedicationsTable, Medication> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _strengthMeta = const VerificationMeta(
    'strength',
  );
  @override
  late final GeneratedColumn<String> strength = GeneratedColumn<String>(
    'strength',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _formMeta = const VerificationMeta('form');
  @override
  late final GeneratedColumn<String> form = GeneratedColumn<String>(
    'form',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stockQuantityMeta = const VerificationMeta(
    'stockQuantity',
  );
  @override
  late final GeneratedColumn<int> stockQuantity = GeneratedColumn<int>(
    'stock_quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _stockThresholdMeta = const VerificationMeta(
    'stockThreshold',
  );
  @override
  late final GeneratedColumn<int> stockThreshold = GeneratedColumn<int>(
    'stock_threshold',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(7),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    strength,
    form,
    stockQuantity,
    stockThreshold,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medications';
  @override
  VerificationContext validateIntegrity(
    Insertable<Medication> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('strength')) {
      context.handle(
        _strengthMeta,
        strength.isAcceptableOrUnknown(data['strength']!, _strengthMeta),
      );
    }
    if (data.containsKey('form')) {
      context.handle(
        _formMeta,
        form.isAcceptableOrUnknown(data['form']!, _formMeta),
      );
    } else if (isInserting) {
      context.missing(_formMeta);
    }
    if (data.containsKey('stock_quantity')) {
      context.handle(
        _stockQuantityMeta,
        stockQuantity.isAcceptableOrUnknown(
          data['stock_quantity']!,
          _stockQuantityMeta,
        ),
      );
    }
    if (data.containsKey('stock_threshold')) {
      context.handle(
        _stockThresholdMeta,
        stockThreshold.isAcceptableOrUnknown(
          data['stock_threshold']!,
          _stockThresholdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Medication map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Medication(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      strength: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}strength'],
      ),
      form: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}form'],
      )!,
      stockQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stock_quantity'],
      )!,
      stockThreshold: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stock_threshold'],
      )!,
    );
  }

  @override
  $MedicationsTable createAlias(String alias) {
    return $MedicationsTable(attachedDatabase, alias);
  }
}

class Medication extends DataClass implements Insertable<Medication> {
  final int id;
  final String name;
  final String? strength;
  final String form;
  final int stockQuantity;
  final int stockThreshold;
  const Medication({
    required this.id,
    required this.name,
    this.strength,
    required this.form,
    required this.stockQuantity,
    required this.stockThreshold,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || strength != null) {
      map['strength'] = Variable<String>(strength);
    }
    map['form'] = Variable<String>(form);
    map['stock_quantity'] = Variable<int>(stockQuantity);
    map['stock_threshold'] = Variable<int>(stockThreshold);
    return map;
  }

  MedicationsCompanion toCompanion(bool nullToAbsent) {
    return MedicationsCompanion(
      id: Value(id),
      name: Value(name),
      strength: strength == null && nullToAbsent
          ? const Value.absent()
          : Value(strength),
      form: Value(form),
      stockQuantity: Value(stockQuantity),
      stockThreshold: Value(stockThreshold),
    );
  }

  factory Medication.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Medication(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      strength: serializer.fromJson<String?>(json['strength']),
      form: serializer.fromJson<String>(json['form']),
      stockQuantity: serializer.fromJson<int>(json['stockQuantity']),
      stockThreshold: serializer.fromJson<int>(json['stockThreshold']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'strength': serializer.toJson<String?>(strength),
      'form': serializer.toJson<String>(form),
      'stockQuantity': serializer.toJson<int>(stockQuantity),
      'stockThreshold': serializer.toJson<int>(stockThreshold),
    };
  }

  Medication copyWith({
    int? id,
    String? name,
    Value<String?> strength = const Value.absent(),
    String? form,
    int? stockQuantity,
    int? stockThreshold,
  }) => Medication(
    id: id ?? this.id,
    name: name ?? this.name,
    strength: strength.present ? strength.value : this.strength,
    form: form ?? this.form,
    stockQuantity: stockQuantity ?? this.stockQuantity,
    stockThreshold: stockThreshold ?? this.stockThreshold,
  );
  Medication copyWithCompanion(MedicationsCompanion data) {
    return Medication(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      strength: data.strength.present ? data.strength.value : this.strength,
      form: data.form.present ? data.form.value : this.form,
      stockQuantity: data.stockQuantity.present
          ? data.stockQuantity.value
          : this.stockQuantity,
      stockThreshold: data.stockThreshold.present
          ? data.stockThreshold.value
          : this.stockThreshold,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Medication(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('strength: $strength, ')
          ..write('form: $form, ')
          ..write('stockQuantity: $stockQuantity, ')
          ..write('stockThreshold: $stockThreshold')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, strength, form, stockQuantity, stockThreshold);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Medication &&
          other.id == this.id &&
          other.name == this.name &&
          other.strength == this.strength &&
          other.form == this.form &&
          other.stockQuantity == this.stockQuantity &&
          other.stockThreshold == this.stockThreshold);
}

class MedicationsCompanion extends UpdateCompanion<Medication> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> strength;
  final Value<String> form;
  final Value<int> stockQuantity;
  final Value<int> stockThreshold;
  const MedicationsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.strength = const Value.absent(),
    this.form = const Value.absent(),
    this.stockQuantity = const Value.absent(),
    this.stockThreshold = const Value.absent(),
  });
  MedicationsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.strength = const Value.absent(),
    required String form,
    this.stockQuantity = const Value.absent(),
    this.stockThreshold = const Value.absent(),
  }) : name = Value(name),
       form = Value(form);
  static Insertable<Medication> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? strength,
    Expression<String>? form,
    Expression<int>? stockQuantity,
    Expression<int>? stockThreshold,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (strength != null) 'strength': strength,
      if (form != null) 'form': form,
      if (stockQuantity != null) 'stock_quantity': stockQuantity,
      if (stockThreshold != null) 'stock_threshold': stockThreshold,
    });
  }

  MedicationsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? strength,
    Value<String>? form,
    Value<int>? stockQuantity,
    Value<int>? stockThreshold,
  }) {
    return MedicationsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      strength: strength ?? this.strength,
      form: form ?? this.form,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      stockThreshold: stockThreshold ?? this.stockThreshold,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (strength.present) {
      map['strength'] = Variable<String>(strength.value);
    }
    if (form.present) {
      map['form'] = Variable<String>(form.value);
    }
    if (stockQuantity.present) {
      map['stock_quantity'] = Variable<int>(stockQuantity.value);
    }
    if (stockThreshold.present) {
      map['stock_threshold'] = Variable<int>(stockThreshold.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicationsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('strength: $strength, ')
          ..write('form: $form, ')
          ..write('stockQuantity: $stockQuantity, ')
          ..write('stockThreshold: $stockThreshold')
          ..write(')'))
        .toString();
  }
}

class $RemindersTable extends Reminders
    with TableInfo<$RemindersTable, Reminder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _medicationIdMeta = const VerificationMeta(
    'medicationId',
  );
  @override
  late final GeneratedColumn<int> medicationId = GeneratedColumn<int>(
    'medication_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localTimeMeta = const VerificationMeta(
    'localTime',
  );
  @override
  late final GeneratedColumn<String> localTime = GeneratedColumn<String>(
    'local_time',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 5,
      maxTextLength: 5,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _everyDayMeta = const VerificationMeta(
    'everyDay',
  );
  @override
  late final GeneratedColumn<bool> everyDay = GeneratedColumn<bool>(
    'every_day',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("every_day" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _activeDaysMeta = const VerificationMeta(
    'activeDays',
  );
  @override
  late final GeneratedColumn<String> activeDays = GeneratedColumn<String>(
    'active_days',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('all'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    medicationId,
    localTime,
    everyDay,
    activeDays,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders';
  @override
  VerificationContext validateIntegrity(
    Insertable<Reminder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('medication_id')) {
      context.handle(
        _medicationIdMeta,
        medicationId.isAcceptableOrUnknown(
          data['medication_id']!,
          _medicationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_medicationIdMeta);
    }
    if (data.containsKey('local_time')) {
      context.handle(
        _localTimeMeta,
        localTime.isAcceptableOrUnknown(data['local_time']!, _localTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_localTimeMeta);
    }
    if (data.containsKey('every_day')) {
      context.handle(
        _everyDayMeta,
        everyDay.isAcceptableOrUnknown(data['every_day']!, _everyDayMeta),
      );
    }
    if (data.containsKey('active_days')) {
      context.handle(
        _activeDaysMeta,
        activeDays.isAcceptableOrUnknown(data['active_days']!, _activeDaysMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Reminder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reminder(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      medicationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}medication_id'],
      )!,
      localTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_time'],
      )!,
      everyDay: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}every_day'],
      )!,
      activeDays: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}active_days'],
      )!,
    );
  }

  @override
  $RemindersTable createAlias(String alias) {
    return $RemindersTable(attachedDatabase, alias);
  }
}

class Reminder extends DataClass implements Insertable<Reminder> {
  final int id;
  final int medicationId;
  final String localTime;
  final bool everyDay;
  final String activeDays;
  const Reminder({
    required this.id,
    required this.medicationId,
    required this.localTime,
    required this.everyDay,
    required this.activeDays,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['medication_id'] = Variable<int>(medicationId);
    map['local_time'] = Variable<String>(localTime);
    map['every_day'] = Variable<bool>(everyDay);
    map['active_days'] = Variable<String>(activeDays);
    return map;
  }

  RemindersCompanion toCompanion(bool nullToAbsent) {
    return RemindersCompanion(
      id: Value(id),
      medicationId: Value(medicationId),
      localTime: Value(localTime),
      everyDay: Value(everyDay),
      activeDays: Value(activeDays),
    );
  }

  factory Reminder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reminder(
      id: serializer.fromJson<int>(json['id']),
      medicationId: serializer.fromJson<int>(json['medicationId']),
      localTime: serializer.fromJson<String>(json['localTime']),
      everyDay: serializer.fromJson<bool>(json['everyDay']),
      activeDays: serializer.fromJson<String>(json['activeDays']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'medicationId': serializer.toJson<int>(medicationId),
      'localTime': serializer.toJson<String>(localTime),
      'everyDay': serializer.toJson<bool>(everyDay),
      'activeDays': serializer.toJson<String>(activeDays),
    };
  }

  Reminder copyWith({
    int? id,
    int? medicationId,
    String? localTime,
    bool? everyDay,
    String? activeDays,
  }) => Reminder(
    id: id ?? this.id,
    medicationId: medicationId ?? this.medicationId,
    localTime: localTime ?? this.localTime,
    everyDay: everyDay ?? this.everyDay,
    activeDays: activeDays ?? this.activeDays,
  );
  Reminder copyWithCompanion(RemindersCompanion data) {
    return Reminder(
      id: data.id.present ? data.id.value : this.id,
      medicationId: data.medicationId.present
          ? data.medicationId.value
          : this.medicationId,
      localTime: data.localTime.present ? data.localTime.value : this.localTime,
      everyDay: data.everyDay.present ? data.everyDay.value : this.everyDay,
      activeDays: data.activeDays.present
          ? data.activeDays.value
          : this.activeDays,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reminder(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('localTime: $localTime, ')
          ..write('everyDay: $everyDay, ')
          ..write('activeDays: $activeDays')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, medicationId, localTime, everyDay, activeDays);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reminder &&
          other.id == this.id &&
          other.medicationId == this.medicationId &&
          other.localTime == this.localTime &&
          other.everyDay == this.everyDay &&
          other.activeDays == this.activeDays);
}

class RemindersCompanion extends UpdateCompanion<Reminder> {
  final Value<int> id;
  final Value<int> medicationId;
  final Value<String> localTime;
  final Value<bool> everyDay;
  final Value<String> activeDays;
  const RemindersCompanion({
    this.id = const Value.absent(),
    this.medicationId = const Value.absent(),
    this.localTime = const Value.absent(),
    this.everyDay = const Value.absent(),
    this.activeDays = const Value.absent(),
  });
  RemindersCompanion.insert({
    this.id = const Value.absent(),
    required int medicationId,
    required String localTime,
    this.everyDay = const Value.absent(),
    this.activeDays = const Value.absent(),
  }) : medicationId = Value(medicationId),
       localTime = Value(localTime);
  static Insertable<Reminder> custom({
    Expression<int>? id,
    Expression<int>? medicationId,
    Expression<String>? localTime,
    Expression<bool>? everyDay,
    Expression<String>? activeDays,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medicationId != null) 'medication_id': medicationId,
      if (localTime != null) 'local_time': localTime,
      if (everyDay != null) 'every_day': everyDay,
      if (activeDays != null) 'active_days': activeDays,
    });
  }

  RemindersCompanion copyWith({
    Value<int>? id,
    Value<int>? medicationId,
    Value<String>? localTime,
    Value<bool>? everyDay,
    Value<String>? activeDays,
  }) {
    return RemindersCompanion(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      localTime: localTime ?? this.localTime,
      everyDay: everyDay ?? this.everyDay,
      activeDays: activeDays ?? this.activeDays,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (medicationId.present) {
      map['medication_id'] = Variable<int>(medicationId.value);
    }
    if (localTime.present) {
      map['local_time'] = Variable<String>(localTime.value);
    }
    if (everyDay.present) {
      map['every_day'] = Variable<bool>(everyDay.value);
    }
    if (activeDays.present) {
      map['active_days'] = Variable<String>(activeDays.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemindersCompanion(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('localTime: $localTime, ')
          ..write('everyDay: $everyDay, ')
          ..write('activeDays: $activeDays')
          ..write(')'))
        .toString();
  }
}

class $DosesTable extends Doses with TableInfo<$DosesTable, Dose> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DosesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _reminderIdMeta = const VerificationMeta(
    'reminderId',
  );
  @override
  late final GeneratedColumn<int> reminderId = GeneratedColumn<int>(
    'reminder_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scheduledAtUtcMeta = const VerificationMeta(
    'scheduledAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> scheduledAtUtc =
      GeneratedColumn<DateTime>(
        'scheduled_at_utc',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _utcOffsetMinutesMeta = const VerificationMeta(
    'utcOffsetMinutes',
  );
  @override
  late final GeneratedColumn<int> utcOffsetMinutes = GeneratedColumn<int>(
    'utc_offset_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actedAtUtcMeta = const VerificationMeta(
    'actedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> actedAtUtc = GeneratedColumn<DateTime>(
    'acted_at_utc',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unansweredRepeatCountMeta =
      const VerificationMeta('unansweredRepeatCount');
  @override
  late final GeneratedColumn<int> unansweredRepeatCount = GeneratedColumn<int>(
    'unanswered_repeat_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _escalationSentMeta = const VerificationMeta(
    'escalationSent',
  );
  @override
  late final GeneratedColumn<bool> escalationSent = GeneratedColumn<bool>(
    'escalation_sent',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("escalation_sent" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _nextAlarmAtUtcMeta = const VerificationMeta(
    'nextAlarmAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> nextAlarmAtUtc =
      GeneratedColumn<DateTime>(
        'next_alarm_at_utc',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    reminderId,
    scheduledAtUtc,
    utcOffsetMinutes,
    status,
    actedAtUtc,
    unansweredRepeatCount,
    escalationSent,
    nextAlarmAtUtc,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'doses';
  @override
  VerificationContext validateIntegrity(
    Insertable<Dose> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('reminder_id')) {
      context.handle(
        _reminderIdMeta,
        reminderId.isAcceptableOrUnknown(data['reminder_id']!, _reminderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_reminderIdMeta);
    }
    if (data.containsKey('scheduled_at_utc')) {
      context.handle(
        _scheduledAtUtcMeta,
        scheduledAtUtc.isAcceptableOrUnknown(
          data['scheduled_at_utc']!,
          _scheduledAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledAtUtcMeta);
    }
    if (data.containsKey('utc_offset_minutes')) {
      context.handle(
        _utcOffsetMinutesMeta,
        utcOffsetMinutes.isAcceptableOrUnknown(
          data['utc_offset_minutes']!,
          _utcOffsetMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_utcOffsetMinutesMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('acted_at_utc')) {
      context.handle(
        _actedAtUtcMeta,
        actedAtUtc.isAcceptableOrUnknown(
          data['acted_at_utc']!,
          _actedAtUtcMeta,
        ),
      );
    }
    if (data.containsKey('unanswered_repeat_count')) {
      context.handle(
        _unansweredRepeatCountMeta,
        unansweredRepeatCount.isAcceptableOrUnknown(
          data['unanswered_repeat_count']!,
          _unansweredRepeatCountMeta,
        ),
      );
    }
    if (data.containsKey('escalation_sent')) {
      context.handle(
        _escalationSentMeta,
        escalationSent.isAcceptableOrUnknown(
          data['escalation_sent']!,
          _escalationSentMeta,
        ),
      );
    }
    if (data.containsKey('next_alarm_at_utc')) {
      context.handle(
        _nextAlarmAtUtcMeta,
        nextAlarmAtUtc.isAcceptableOrUnknown(
          data['next_alarm_at_utc']!,
          _nextAlarmAtUtcMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {reminderId, scheduledAtUtc},
  ];
  @override
  Dose map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Dose(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      reminderId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_id'],
      )!,
      scheduledAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}scheduled_at_utc'],
      )!,
      utcOffsetMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}utc_offset_minutes'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      actedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}acted_at_utc'],
      ),
      unansweredRepeatCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unanswered_repeat_count'],
      )!,
      escalationSent: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}escalation_sent'],
      )!,
      nextAlarmAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_alarm_at_utc'],
      ),
    );
  }

  @override
  $DosesTable createAlias(String alias) {
    return $DosesTable(attachedDatabase, alias);
  }
}

class Dose extends DataClass implements Insertable<Dose> {
  final int id;
  final int reminderId;
  final DateTime scheduledAtUtc;
  final int utcOffsetMinutes;
  final String status;
  final DateTime? actedAtUtc;
  final int unansweredRepeatCount;
  final bool escalationSent;
  final DateTime? nextAlarmAtUtc;
  const Dose({
    required this.id,
    required this.reminderId,
    required this.scheduledAtUtc,
    required this.utcOffsetMinutes,
    required this.status,
    this.actedAtUtc,
    required this.unansweredRepeatCount,
    required this.escalationSent,
    this.nextAlarmAtUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['reminder_id'] = Variable<int>(reminderId);
    map['scheduled_at_utc'] = Variable<DateTime>(scheduledAtUtc);
    map['utc_offset_minutes'] = Variable<int>(utcOffsetMinutes);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || actedAtUtc != null) {
      map['acted_at_utc'] = Variable<DateTime>(actedAtUtc);
    }
    map['unanswered_repeat_count'] = Variable<int>(unansweredRepeatCount);
    map['escalation_sent'] = Variable<bool>(escalationSent);
    if (!nullToAbsent || nextAlarmAtUtc != null) {
      map['next_alarm_at_utc'] = Variable<DateTime>(nextAlarmAtUtc);
    }
    return map;
  }

  DosesCompanion toCompanion(bool nullToAbsent) {
    return DosesCompanion(
      id: Value(id),
      reminderId: Value(reminderId),
      scheduledAtUtc: Value(scheduledAtUtc),
      utcOffsetMinutes: Value(utcOffsetMinutes),
      status: Value(status),
      actedAtUtc: actedAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(actedAtUtc),
      unansweredRepeatCount: Value(unansweredRepeatCount),
      escalationSent: Value(escalationSent),
      nextAlarmAtUtc: nextAlarmAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(nextAlarmAtUtc),
    );
  }

  factory Dose.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Dose(
      id: serializer.fromJson<int>(json['id']),
      reminderId: serializer.fromJson<int>(json['reminderId']),
      scheduledAtUtc: serializer.fromJson<DateTime>(json['scheduledAtUtc']),
      utcOffsetMinutes: serializer.fromJson<int>(json['utcOffsetMinutes']),
      status: serializer.fromJson<String>(json['status']),
      actedAtUtc: serializer.fromJson<DateTime?>(json['actedAtUtc']),
      unansweredRepeatCount: serializer.fromJson<int>(
        json['unansweredRepeatCount'],
      ),
      escalationSent: serializer.fromJson<bool>(json['escalationSent']),
      nextAlarmAtUtc: serializer.fromJson<DateTime?>(json['nextAlarmAtUtc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'reminderId': serializer.toJson<int>(reminderId),
      'scheduledAtUtc': serializer.toJson<DateTime>(scheduledAtUtc),
      'utcOffsetMinutes': serializer.toJson<int>(utcOffsetMinutes),
      'status': serializer.toJson<String>(status),
      'actedAtUtc': serializer.toJson<DateTime?>(actedAtUtc),
      'unansweredRepeatCount': serializer.toJson<int>(unansweredRepeatCount),
      'escalationSent': serializer.toJson<bool>(escalationSent),
      'nextAlarmAtUtc': serializer.toJson<DateTime?>(nextAlarmAtUtc),
    };
  }

  Dose copyWith({
    int? id,
    int? reminderId,
    DateTime? scheduledAtUtc,
    int? utcOffsetMinutes,
    String? status,
    Value<DateTime?> actedAtUtc = const Value.absent(),
    int? unansweredRepeatCount,
    bool? escalationSent,
    Value<DateTime?> nextAlarmAtUtc = const Value.absent(),
  }) => Dose(
    id: id ?? this.id,
    reminderId: reminderId ?? this.reminderId,
    scheduledAtUtc: scheduledAtUtc ?? this.scheduledAtUtc,
    utcOffsetMinutes: utcOffsetMinutes ?? this.utcOffsetMinutes,
    status: status ?? this.status,
    actedAtUtc: actedAtUtc.present ? actedAtUtc.value : this.actedAtUtc,
    unansweredRepeatCount: unansweredRepeatCount ?? this.unansweredRepeatCount,
    escalationSent: escalationSent ?? this.escalationSent,
    nextAlarmAtUtc: nextAlarmAtUtc.present
        ? nextAlarmAtUtc.value
        : this.nextAlarmAtUtc,
  );
  Dose copyWithCompanion(DosesCompanion data) {
    return Dose(
      id: data.id.present ? data.id.value : this.id,
      reminderId: data.reminderId.present
          ? data.reminderId.value
          : this.reminderId,
      scheduledAtUtc: data.scheduledAtUtc.present
          ? data.scheduledAtUtc.value
          : this.scheduledAtUtc,
      utcOffsetMinutes: data.utcOffsetMinutes.present
          ? data.utcOffsetMinutes.value
          : this.utcOffsetMinutes,
      status: data.status.present ? data.status.value : this.status,
      actedAtUtc: data.actedAtUtc.present
          ? data.actedAtUtc.value
          : this.actedAtUtc,
      unansweredRepeatCount: data.unansweredRepeatCount.present
          ? data.unansweredRepeatCount.value
          : this.unansweredRepeatCount,
      escalationSent: data.escalationSent.present
          ? data.escalationSent.value
          : this.escalationSent,
      nextAlarmAtUtc: data.nextAlarmAtUtc.present
          ? data.nextAlarmAtUtc.value
          : this.nextAlarmAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Dose(')
          ..write('id: $id, ')
          ..write('reminderId: $reminderId, ')
          ..write('scheduledAtUtc: $scheduledAtUtc, ')
          ..write('utcOffsetMinutes: $utcOffsetMinutes, ')
          ..write('status: $status, ')
          ..write('actedAtUtc: $actedAtUtc, ')
          ..write('unansweredRepeatCount: $unansweredRepeatCount, ')
          ..write('escalationSent: $escalationSent, ')
          ..write('nextAlarmAtUtc: $nextAlarmAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    reminderId,
    scheduledAtUtc,
    utcOffsetMinutes,
    status,
    actedAtUtc,
    unansweredRepeatCount,
    escalationSent,
    nextAlarmAtUtc,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Dose &&
          other.id == this.id &&
          other.reminderId == this.reminderId &&
          other.scheduledAtUtc == this.scheduledAtUtc &&
          other.utcOffsetMinutes == this.utcOffsetMinutes &&
          other.status == this.status &&
          other.actedAtUtc == this.actedAtUtc &&
          other.unansweredRepeatCount == this.unansweredRepeatCount &&
          other.escalationSent == this.escalationSent &&
          other.nextAlarmAtUtc == this.nextAlarmAtUtc);
}

class DosesCompanion extends UpdateCompanion<Dose> {
  final Value<int> id;
  final Value<int> reminderId;
  final Value<DateTime> scheduledAtUtc;
  final Value<int> utcOffsetMinutes;
  final Value<String> status;
  final Value<DateTime?> actedAtUtc;
  final Value<int> unansweredRepeatCount;
  final Value<bool> escalationSent;
  final Value<DateTime?> nextAlarmAtUtc;
  const DosesCompanion({
    this.id = const Value.absent(),
    this.reminderId = const Value.absent(),
    this.scheduledAtUtc = const Value.absent(),
    this.utcOffsetMinutes = const Value.absent(),
    this.status = const Value.absent(),
    this.actedAtUtc = const Value.absent(),
    this.unansweredRepeatCount = const Value.absent(),
    this.escalationSent = const Value.absent(),
    this.nextAlarmAtUtc = const Value.absent(),
  });
  DosesCompanion.insert({
    this.id = const Value.absent(),
    required int reminderId,
    required DateTime scheduledAtUtc,
    required int utcOffsetMinutes,
    required String status,
    this.actedAtUtc = const Value.absent(),
    this.unansweredRepeatCount = const Value.absent(),
    this.escalationSent = const Value.absent(),
    this.nextAlarmAtUtc = const Value.absent(),
  }) : reminderId = Value(reminderId),
       scheduledAtUtc = Value(scheduledAtUtc),
       utcOffsetMinutes = Value(utcOffsetMinutes),
       status = Value(status);
  static Insertable<Dose> custom({
    Expression<int>? id,
    Expression<int>? reminderId,
    Expression<DateTime>? scheduledAtUtc,
    Expression<int>? utcOffsetMinutes,
    Expression<String>? status,
    Expression<DateTime>? actedAtUtc,
    Expression<int>? unansweredRepeatCount,
    Expression<bool>? escalationSent,
    Expression<DateTime>? nextAlarmAtUtc,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (reminderId != null) 'reminder_id': reminderId,
      if (scheduledAtUtc != null) 'scheduled_at_utc': scheduledAtUtc,
      if (utcOffsetMinutes != null) 'utc_offset_minutes': utcOffsetMinutes,
      if (status != null) 'status': status,
      if (actedAtUtc != null) 'acted_at_utc': actedAtUtc,
      if (unansweredRepeatCount != null)
        'unanswered_repeat_count': unansweredRepeatCount,
      if (escalationSent != null) 'escalation_sent': escalationSent,
      if (nextAlarmAtUtc != null) 'next_alarm_at_utc': nextAlarmAtUtc,
    });
  }

  DosesCompanion copyWith({
    Value<int>? id,
    Value<int>? reminderId,
    Value<DateTime>? scheduledAtUtc,
    Value<int>? utcOffsetMinutes,
    Value<String>? status,
    Value<DateTime?>? actedAtUtc,
    Value<int>? unansweredRepeatCount,
    Value<bool>? escalationSent,
    Value<DateTime?>? nextAlarmAtUtc,
  }) {
    return DosesCompanion(
      id: id ?? this.id,
      reminderId: reminderId ?? this.reminderId,
      scheduledAtUtc: scheduledAtUtc ?? this.scheduledAtUtc,
      utcOffsetMinutes: utcOffsetMinutes ?? this.utcOffsetMinutes,
      status: status ?? this.status,
      actedAtUtc: actedAtUtc ?? this.actedAtUtc,
      unansweredRepeatCount:
          unansweredRepeatCount ?? this.unansweredRepeatCount,
      escalationSent: escalationSent ?? this.escalationSent,
      nextAlarmAtUtc: nextAlarmAtUtc ?? this.nextAlarmAtUtc,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (reminderId.present) {
      map['reminder_id'] = Variable<int>(reminderId.value);
    }
    if (scheduledAtUtc.present) {
      map['scheduled_at_utc'] = Variable<DateTime>(scheduledAtUtc.value);
    }
    if (utcOffsetMinutes.present) {
      map['utc_offset_minutes'] = Variable<int>(utcOffsetMinutes.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (actedAtUtc.present) {
      map['acted_at_utc'] = Variable<DateTime>(actedAtUtc.value);
    }
    if (unansweredRepeatCount.present) {
      map['unanswered_repeat_count'] = Variable<int>(
        unansweredRepeatCount.value,
      );
    }
    if (escalationSent.present) {
      map['escalation_sent'] = Variable<bool>(escalationSent.value);
    }
    if (nextAlarmAtUtc.present) {
      map['next_alarm_at_utc'] = Variable<DateTime>(nextAlarmAtUtc.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DosesCompanion(')
          ..write('id: $id, ')
          ..write('reminderId: $reminderId, ')
          ..write('scheduledAtUtc: $scheduledAtUtc, ')
          ..write('utcOffsetMinutes: $utcOffsetMinutes, ')
          ..write('status: $status, ')
          ..write('actedAtUtc: $actedAtUtc, ')
          ..write('unansweredRepeatCount: $unansweredRepeatCount, ')
          ..write('escalationSent: $escalationSent, ')
          ..write('nextAlarmAtUtc: $nextAlarmAtUtc')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $MedicationsTable medications = $MedicationsTable(this);
  late final $RemindersTable reminders = $RemindersTable(this);
  late final $DosesTable doses = $DosesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    appSettings,
    medications,
    reminders,
    doses,
  ];
}

typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<bool> onboardingCompleted,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<bool> onboardingCompleted,
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

  ColumnFilters<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
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

  ColumnOrderings<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
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

  GeneratedColumn<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
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
                Value<bool> onboardingCompleted = const Value.absent(),
              }) => AppSettingsCompanion(
                id: id,
                onboardingCompleted: onboardingCompleted,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> onboardingCompleted = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                id: id,
                onboardingCompleted: onboardingCompleted,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppSettingsTable, AppSetting>(table),
                  BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
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
typedef $$MedicationsTableCreateCompanionBuilder =
    MedicationsCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> strength,
      required String form,
      Value<int> stockQuantity,
      Value<int> stockThreshold,
    });
typedef $$MedicationsTableUpdateCompanionBuilder =
    MedicationsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> strength,
      Value<String> form,
      Value<int> stockQuantity,
      Value<int> stockThreshold,
    });

class $$MedicationsTableFilterComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get strength => $composableBuilder(
    column: $table.strength,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get form => $composableBuilder(
    column: $table.form,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stockQuantity => $composableBuilder(
    column: $table.stockQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stockThreshold => $composableBuilder(
    column: $table.stockThreshold,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MedicationsTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get strength => $composableBuilder(
    column: $table.strength,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get form => $composableBuilder(
    column: $table.form,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stockQuantity => $composableBuilder(
    column: $table.stockQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stockThreshold => $composableBuilder(
    column: $table.stockThreshold,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MedicationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get strength =>
      $composableBuilder(column: $table.strength, builder: (column) => column);

  GeneratedColumn<String> get form =>
      $composableBuilder(column: $table.form, builder: (column) => column);

  GeneratedColumn<int> get stockQuantity => $composableBuilder(
    column: $table.stockQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<int> get stockThreshold => $composableBuilder(
    column: $table.stockThreshold,
    builder: (column) => column,
  );
}

class $$MedicationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedicationsTable,
          Medication,
          $$MedicationsTableFilterComposer,
          $$MedicationsTableOrderingComposer,
          $$MedicationsTableAnnotationComposer,
          $$MedicationsTableCreateCompanionBuilder,
          $$MedicationsTableUpdateCompanionBuilder,
          (
            Medication,
            BaseReferences<_$AppDatabase, $MedicationsTable, Medication>,
          ),
          Medication,
          PrefetchHooks Function()
        > {
  $$MedicationsTableTableManager(_$AppDatabase db, $MedicationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> strength = const Value.absent(),
                Value<String> form = const Value.absent(),
                Value<int> stockQuantity = const Value.absent(),
                Value<int> stockThreshold = const Value.absent(),
              }) => MedicationsCompanion(
                id: id,
                name: name,
                strength: strength,
                form: form,
                stockQuantity: stockQuantity,
                stockThreshold: stockThreshold,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> strength = const Value.absent(),
                required String form,
                Value<int> stockQuantity = const Value.absent(),
                Value<int> stockThreshold = const Value.absent(),
              }) => MedicationsCompanion.insert(
                id: id,
                name: name,
                strength: strength,
                form: form,
                stockQuantity: stockQuantity,
                stockThreshold: stockThreshold,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MedicationsTable, Medication>(table),
                  BaseReferences<_$AppDatabase, $MedicationsTable, Medication>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MedicationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedicationsTable,
      Medication,
      $$MedicationsTableFilterComposer,
      $$MedicationsTableOrderingComposer,
      $$MedicationsTableAnnotationComposer,
      $$MedicationsTableCreateCompanionBuilder,
      $$MedicationsTableUpdateCompanionBuilder,
      (
        Medication,
        BaseReferences<_$AppDatabase, $MedicationsTable, Medication>,
      ),
      Medication,
      PrefetchHooks Function()
    >;
typedef $$RemindersTableCreateCompanionBuilder = RemindersCompanion Function({
  Value<int> id,
  required int medicationId,
  required String localTime,
  Value<bool> everyDay,
  Value<String> activeDays,
});
typedef $$RemindersTableUpdateCompanionBuilder = RemindersCompanion Function({
  Value<int> id,
  Value<int> medicationId,
  Value<String> localTime,
  Value<bool> everyDay,
  Value<String> activeDays,
});

class $$RemindersTableFilterComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableFilterComposer({
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

  ColumnFilters<int> get medicationId => $composableBuilder(
    column: $table.medicationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localTime => $composableBuilder(
    column: $table.localTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get everyDay => $composableBuilder(
    column: $table.everyDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activeDays => $composableBuilder(
    column: $table.activeDays,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableOrderingComposer({
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

  ColumnOrderings<int> get medicationId => $composableBuilder(
    column: $table.medicationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localTime => $composableBuilder(
    column: $table.localTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get everyDay => $composableBuilder(
    column: $table.everyDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activeDays => $composableBuilder(
    column: $table.activeDays,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get medicationId => $composableBuilder(
    column: $table.medicationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get localTime =>
      $composableBuilder(column: $table.localTime, builder: (column) => column);

  GeneratedColumn<bool> get everyDay =>
      $composableBuilder(column: $table.everyDay, builder: (column) => column);

  GeneratedColumn<String> get activeDays => $composableBuilder(
    column: $table.activeDays,
    builder: (column) => column,
  );
}

class $$RemindersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RemindersTable,
          Reminder,
          $$RemindersTableFilterComposer,
          $$RemindersTableOrderingComposer,
          $$RemindersTableAnnotationComposer,
          $$RemindersTableCreateCompanionBuilder,
          $$RemindersTableUpdateCompanionBuilder,
          (Reminder, BaseReferences<_$AppDatabase, $RemindersTable, Reminder>),
          Reminder,
          PrefetchHooks Function()
        > {
  $$RemindersTableTableManager(_$AppDatabase db, $RemindersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> medicationId = const Value.absent(),
                Value<String> localTime = const Value.absent(),
                Value<bool> everyDay = const Value.absent(),
                Value<String> activeDays = const Value.absent(),
              }) => RemindersCompanion(
                id: id,
                medicationId: medicationId,
                localTime: localTime,
                everyDay: everyDay,
                activeDays: activeDays,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int medicationId,
                required String localTime,
                Value<bool> everyDay = const Value.absent(),
                Value<String> activeDays = const Value.absent(),
              }) => RemindersCompanion.insert(
                id: id,
                medicationId: medicationId,
                localTime: localTime,
                everyDay: everyDay,
                activeDays: activeDays,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RemindersTable, Reminder>(table),
                  BaseReferences<_$AppDatabase, $RemindersTable, Reminder>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RemindersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RemindersTable,
      Reminder,
      $$RemindersTableFilterComposer,
      $$RemindersTableOrderingComposer,
      $$RemindersTableAnnotationComposer,
      $$RemindersTableCreateCompanionBuilder,
      $$RemindersTableUpdateCompanionBuilder,
      (Reminder, BaseReferences<_$AppDatabase, $RemindersTable, Reminder>),
      Reminder,
      PrefetchHooks Function()
    >;
typedef $$DosesTableCreateCompanionBuilder = DosesCompanion Function({
  Value<int> id,
  required int reminderId,
  required DateTime scheduledAtUtc,
  required int utcOffsetMinutes,
  required String status,
  Value<DateTime?> actedAtUtc,
  Value<int> unansweredRepeatCount,
  Value<bool> escalationSent,
  Value<DateTime?> nextAlarmAtUtc,
});
typedef $$DosesTableUpdateCompanionBuilder = DosesCompanion Function({
  Value<int> id,
  Value<int> reminderId,
  Value<DateTime> scheduledAtUtc,
  Value<int> utcOffsetMinutes,
  Value<String> status,
  Value<DateTime?> actedAtUtc,
  Value<int> unansweredRepeatCount,
  Value<bool> escalationSent,
  Value<DateTime?> nextAlarmAtUtc,
});

class $$DosesTableFilterComposer extends Composer<_$AppDatabase, $DosesTable> {
  $$DosesTableFilterComposer({
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

  ColumnFilters<int> get reminderId => $composableBuilder(
    column: $table.reminderId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get scheduledAtUtc => $composableBuilder(
    column: $table.scheduledAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get utcOffsetMinutes => $composableBuilder(
    column: $table.utcOffsetMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actedAtUtc => $composableBuilder(
    column: $table.actedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unansweredRepeatCount => $composableBuilder(
    column: $table.unansweredRepeatCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get escalationSent => $composableBuilder(
    column: $table.escalationSent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextAlarmAtUtc => $composableBuilder(
    column: $table.nextAlarmAtUtc,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DosesTableOrderingComposer
    extends Composer<_$AppDatabase, $DosesTable> {
  $$DosesTableOrderingComposer({
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

  ColumnOrderings<int> get reminderId => $composableBuilder(
    column: $table.reminderId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get scheduledAtUtc => $composableBuilder(
    column: $table.scheduledAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get utcOffsetMinutes => $composableBuilder(
    column: $table.utcOffsetMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actedAtUtc => $composableBuilder(
    column: $table.actedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unansweredRepeatCount => $composableBuilder(
    column: $table.unansweredRepeatCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get escalationSent => $composableBuilder(
    column: $table.escalationSent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextAlarmAtUtc => $composableBuilder(
    column: $table.nextAlarmAtUtc,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DosesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DosesTable> {
  $$DosesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get reminderId => $composableBuilder(
    column: $table.reminderId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get scheduledAtUtc => $composableBuilder(
    column: $table.scheduledAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<int> get utcOffsetMinutes => $composableBuilder(
    column: $table.utcOffsetMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get actedAtUtc => $composableBuilder(
    column: $table.actedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<int> get unansweredRepeatCount => $composableBuilder(
    column: $table.unansweredRepeatCount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get escalationSent => $composableBuilder(
    column: $table.escalationSent,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get nextAlarmAtUtc => $composableBuilder(
    column: $table.nextAlarmAtUtc,
    builder: (column) => column,
  );
}

class $$DosesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DosesTable,
          Dose,
          $$DosesTableFilterComposer,
          $$DosesTableOrderingComposer,
          $$DosesTableAnnotationComposer,
          $$DosesTableCreateCompanionBuilder,
          $$DosesTableUpdateCompanionBuilder,
          (Dose, BaseReferences<_$AppDatabase, $DosesTable, Dose>),
          Dose,
          PrefetchHooks Function()
        > {
  $$DosesTableTableManager(_$AppDatabase db, $DosesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DosesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DosesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DosesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> reminderId = const Value.absent(),
                Value<DateTime> scheduledAtUtc = const Value.absent(),
                Value<int> utcOffsetMinutes = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> actedAtUtc = const Value.absent(),
                Value<int> unansweredRepeatCount = const Value.absent(),
                Value<bool> escalationSent = const Value.absent(),
                Value<DateTime?> nextAlarmAtUtc = const Value.absent(),
              }) => DosesCompanion(
                id: id,
                reminderId: reminderId,
                scheduledAtUtc: scheduledAtUtc,
                utcOffsetMinutes: utcOffsetMinutes,
                status: status,
                actedAtUtc: actedAtUtc,
                unansweredRepeatCount: unansweredRepeatCount,
                escalationSent: escalationSent,
                nextAlarmAtUtc: nextAlarmAtUtc,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int reminderId,
                required DateTime scheduledAtUtc,
                required int utcOffsetMinutes,
                required String status,
                Value<DateTime?> actedAtUtc = const Value.absent(),
                Value<int> unansweredRepeatCount = const Value.absent(),
                Value<bool> escalationSent = const Value.absent(),
                Value<DateTime?> nextAlarmAtUtc = const Value.absent(),
              }) => DosesCompanion.insert(
                id: id,
                reminderId: reminderId,
                scheduledAtUtc: scheduledAtUtc,
                utcOffsetMinutes: utcOffsetMinutes,
                status: status,
                actedAtUtc: actedAtUtc,
                unansweredRepeatCount: unansweredRepeatCount,
                escalationSent: escalationSent,
                nextAlarmAtUtc: nextAlarmAtUtc,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DosesTable, Dose>(table),
                  BaseReferences<_$AppDatabase, $DosesTable, Dose>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DosesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DosesTable,
      Dose,
      $$DosesTableFilterComposer,
      $$DosesTableOrderingComposer,
      $$DosesTableAnnotationComposer,
      $$DosesTableCreateCompanionBuilder,
      $$DosesTableUpdateCompanionBuilder,
      (Dose, BaseReferences<_$AppDatabase, $DosesTable, Dose>),
      Dose,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$MedicationsTableTableManager get medications =>
      $$MedicationsTableTableManager(_db, _db.medications);
  $$RemindersTableTableManager get reminders =>
      $$RemindersTableTableManager(_db, _db.reminders);
  $$DosesTableTableManager get doses =>
      $$DosesTableTableManager(_db, _db.doses);
}
