import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:drift/native.dart';

import '../../domain/models/dose_record.dart';
import '../../domain/models/dose_status.dart';

part 'app_database.g.dart';

class AppSettings extends Table {
  IntColumn get id => integer()();

  BoolColumn get onboardingCompleted =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class Medications extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1, max: 120)();

  TextColumn get strength => text().nullable()();

  TextColumn get form => text()();

  IntColumn get stockQuantity => integer().withDefault(const Constant(0))();

  IntColumn get stockThreshold => integer().withDefault(const Constant(7))();
}

class Reminders extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get medicationId => integer()();

  TextColumn get localTime => text().withLength(min: 5, max: 5)();

  BoolColumn get everyDay => boolean().withDefault(const Constant(true))();

  TextColumn get activeDays => text().withDefault(const Constant('all'))();
}

class Doses extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get reminderId => integer()();

  DateTimeColumn get scheduledAtUtc => dateTime()();

  IntColumn get utcOffsetMinutes => integer()();

  TextColumn get status => text()();

  DateTimeColumn get actedAtUtc => dateTime().nullable()();

  IntColumn get unansweredRepeatCount =>
      integer().withDefault(const Constant(0))();

  BoolColumn get escalationSent =>
      boolean().withDefault(const Constant(false))();

  DateTimeColumn get nextAlarmAtUtc => dateTime().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {reminderId, scheduledAtUtc},
  ];
}

class ReminderWithMedication {
  final Reminder reminder;
  final Medication medication;

  const ReminderWithMedication({
    required this.reminder,
    required this.medication,
  });
}

@DriftDatabase(tables: [AppSettings, Medications, Reminders, Doses])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'medication_reminder'));

  AppDatabase.forTesting() : super(NativeDatabase.memory());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(doses);
      }
    },
  );

  Future<bool> isOnboardingCompleted() async {
    final settings = await select(appSettings).getSingleOrNull();
    return settings?.onboardingCompleted ?? false;
  }

  Future<void> markOnboardingCompleted() async {
    await into(appSettings).insertOnConflictUpdate(
      AppSettingsCompanion.insert(
        id: const Value(1),
        onboardingCompleted: const Value(true),
      ),
    );
  }

  Stream<List<Medication>> watchMedications() => select(medications).watch();

  Stream<List<ReminderWithMedication>> watchTodayReminders() {
    final query = select(reminders).join([
      innerJoin(medications, medications.id.equalsExp(reminders.medicationId)),
    ])..orderBy([OrderingTerm.asc(reminders.localTime)]);

    return query.watch().map((rows) {
      return rows.map((row) {
        return ReminderWithMedication(
          reminder: row.readTable(reminders),
          medication: row.readTable(medications),
        );
      }).toList();
    });
  }

  Stream<List<Dose>> watchDoseEvents() => select(doses).watch();

  Future<int> addMedicationWithReminders({
    required String name,
    required String? strength,
    required String form,
    required int stockQuantity,
    required int stockThreshold,
    required List<String> localTimes,
    bool everyDay = true,
    String activeDays = 'all',
  }) async {
    return transaction(() async {
      final medicationId = await into(medications).insert(
        MedicationsCompanion.insert(
          name: name,
          strength: Value(strength),
          form: form,
          stockQuantity: Value(stockQuantity),
          stockThreshold: Value(stockThreshold),
        ),
      );
      for (final time in localTimes) {
        await into(reminders).insert(
          RemindersCompanion.insert(
            medicationId: medicationId,
            localTime: time,
            everyDay: Value(everyDay),
            activeDays: Value(activeDays),
          ),
        );
      }
      return medicationId;
    });
  }

  Future<int> addMedicationWithReminder({
    required String name,
    required String? strength,
    required String form,
    required int stockQuantity,
    required int stockThreshold,
    required String localTime,
  }) async {
    return addMedicationWithReminders(
      name: name,
      strength: strength,
      form: form,
      stockQuantity: stockQuantity,
      stockThreshold: stockThreshold,
      localTimes: [localTime],
    );
  }

  Future<void> upsertDoseEvent(DoseRecord record) async {
    await into(doses).insertOnConflictUpdate(
      DosesCompanion.insert(
        reminderId: record.reminderId,
        scheduledAtUtc: record.scheduledAtUtc,
        utcOffsetMinutes: record.utcOffsetMinutes,
        status: record.status.storageValue,
        actedAtUtc: Value(record.actedAtUtc),
        unansweredRepeatCount: Value(record.unansweredRepeatCount),
        escalationSent: Value(record.escalationSent),
        nextAlarmAtUtc: Value(record.nextAlarmAtUtc),
      ),
    );
  }

  Future<void> decrementStockForReminder(int reminderId) async {
    final reminder = await (select(
      reminders,
    )..where((row) => row.id.equals(reminderId))).getSingle();
    final medication = await (select(
      medications,
    )..where((row) => row.id.equals(reminder.medicationId))).getSingle();
    final nextQuantity = medication.stockQuantity > 0
        ? medication.stockQuantity - 1
        : 0;
    await (update(medications)
          ..where((row) => row.id.equals(medication.id)))
        .write(MedicationsCompanion(stockQuantity: Value(nextQuantity)));
  }
}

DoseRecord doseRowToRecord(Dose row) {
  return DoseRecord(
    id: row.id,
    reminderId: row.reminderId,
    scheduledAtUtc: row.scheduledAtUtc,
    utcOffsetMinutes: row.utcOffsetMinutes,
    status: DoseStatusCodec.fromStorage(row.status),
    actedAtUtc: row.actedAtUtc,
    unansweredRepeatCount: row.unansweredRepeatCount,
    escalationSent: row.escalationSent,
    nextAlarmAtUtc: row.nextAlarmAtUtc,
  );
}
