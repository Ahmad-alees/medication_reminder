import 'package:drift/drift.dart';

import '../core/clock.dart';
import '../domain/models/dose_record.dart';
import '../domain/models/dose_status.dart';
import '../domain/models/reminder_schedule.dart';
import '../domain/rules/dose_generator.dart';
import '../domain/rules/dose_state_machine.dart';
import '../scheduling/alarm_scheduler.dart';
import 'local/app_database.dart';

class TodayDose {
  const TodayDose({
    required this.dose,
    required this.medication,
    required this.reminder,
  });

  final DoseRecord dose;
  final Medication medication;
  final Reminder reminder;
}

class DoseRepository {
  DoseRepository({
    required this._database,
    this._clock = const SystemClock(),
    this._scheduler = const NoOpAlarmScheduler(),
    this._stateMachine = const DoseStateMachine(),
  });

  final AppDatabase _database;
  final Clock _clock;
  final AlarmScheduler _scheduler;
  final DoseStateMachine _stateMachine;

  Stream<List<TodayDose>> watchDosesForLocalDate(DateTime localDate) {
    final query = _database.select(_database.reminders).join([
      innerJoin(
        _database.medications,
        _database.medications.id.equalsExp(_database.reminders.medicationId),
      ),
      leftOuterJoin(
        _database.doses,
        _database.doses.reminderId.equalsExp(_database.reminders.id),
      ),
    ])..orderBy([OrderingTerm.asc(_database.reminders.localTime)]);

    return query.watch().asyncMap((rows) async {
      final seenReminderIds = <int>{};
      final reminders = <ReminderWithMedication>[];
      for (final row in rows) {
        final r = row.readTable(_database.reminders);
        if (seenReminderIds.add(r.id)) {
          reminders.add(
            ReminderWithMedication(
              reminder: r,
              medication: row.readTable(_database.medications),
            ),
          );
        }
      }

      final storedRows = await _database.select(_database.doses).get();
      final stored = storedRows.map(doseRowToRecord).toList();
      final offset = localDate.timeZoneOffset.inMinutes;
      final overlay = <TodayDose>[];

      for (final item in reminders) {
        final generated = generateDoses(
          schedule: ReminderSchedule(
            reminderId: item.reminder.id,
            localTime: item.reminder.localTime,
            everyDay: item.reminder.everyDay,
            activeDays: item.reminder.activeDays,
          ),
          fromLocalDate: localDate,
          utcOffsetMinutes: offset,
          windowDays: 1,
        );
        if (generated.isEmpty) continue;
        overlay.add(
          TodayDose(
            dose: _overlay(generated.single, stored),
            medication: item.medication,
            reminder: item.reminder,
          ),
        );
      }

      overlay.sort(
        (a, b) => a.dose.scheduledAtUtc.compareTo(b.dose.scheduledAtUtc),
      );
      return overlay;
    });
  }

  Future<DoseRecord?> getDose(int reminderId, DateTime scheduledAtUtc) async {
    final row = await _database.findDose(reminderId, scheduledAtUtc);
    return row == null ? null : doseRowToRecord(row);
  }

  Future<DoseRecord> take(DoseRecord dose) async {
    final existing = await getDose(dose.reminderId, dose.scheduledAtUtc);
    final current = existing ?? dose;
    final result = _stateMachine.take(current, _clock.nowUtc());
    if (!result.changed) return result.dose;
    await _database.upsertDoseEvent(result.dose);
    await _database.decrementStockForReminder(result.dose.reminderId);
    await _scheduler.cancel(result.dose);
    return result.dose;
  }

  Future<DoseRecord> snooze(DoseRecord dose) async {
    final existing = await getDose(dose.reminderId, dose.scheduledAtUtc);
    final current = existing ?? dose;
    final result = _stateMachine.snooze(current, _clock.nowUtc());
    if (!result.changed) return result.dose;
    await _database.upsertDoseEvent(result.dose);
    await _scheduler.replace(result.dose);
    return result.dose;
  }

  Future<DoseRecord> skip(DoseRecord dose) async {
    final existing = await getDose(dose.reminderId, dose.scheduledAtUtc);
    final current = existing ?? dose;
    final result = _stateMachine.markMissed(current, _clock.nowUtc());
    if (!result.changed) return result.dose;
    await _database.upsertDoseEvent(result.dose);
    await _scheduler.cancel(result.dose);
    return result.dose;
  }

  DoseRecord _overlay(DoseRecord generated, List<DoseRecord> stored) {
    for (final row in stored) {
      if (row.reminderId == generated.reminderId &&
          row.scheduledAtUtc.isAtSameMomentAs(generated.scheduledAtUtc)) {
        return row;
      }
    }
    return generated;
  }
}

String statusLabelKey(DoseStatus status) {
  switch (status) {
    case DoseStatus.pending:
      return 'pending';
    case DoseStatus.taken:
      return 'taken';
    case DoseStatus.snoozed:
      return 'snoozed';
    case DoseStatus.missed:
      return 'missed';
  }
}
