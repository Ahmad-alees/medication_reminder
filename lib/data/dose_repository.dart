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
    return _database.watchTodayReminders().asyncMap((reminders) async {
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

  Future<DoseRecord> take(DoseRecord dose) async {
    final result = _stateMachine.take(dose, _clock.nowUtc());
    if (!result.changed) return result.dose;
    await _database.upsertDoseEvent(result.dose);
    await _database.decrementStockForReminder(result.dose.reminderId);
    await _scheduler.cancel(result.dose);
    return result.dose;
  }

  Future<DoseRecord> snooze(DoseRecord dose) async {
    final result = _stateMachine.snooze(dose, _clock.nowUtc());
    if (!result.changed) return result.dose;
    await _database.upsertDoseEvent(result.dose);
    await _scheduler.replace(result.dose);
    return result.dose;
  }

  Future<DoseRecord> skip(DoseRecord dose) async {
    final result = _stateMachine.markMissed(dose, _clock.nowUtc());
    if (!result.changed) return result.dose;
    await _database.upsertDoseEvent(result.dose);
    await _scheduler.cancel(result.dose);
    return result.dose;
  }

  DoseRecord _overlay(DoseRecord generated, List<DoseRecord> stored) {
    for (final row in stored) {
      if (row.reminderId == generated.reminderId &&
          row.scheduledAtUtc == generated.scheduledAtUtc) {
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
