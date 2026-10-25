import 'package:drift/drift.dart';

import '../core/clock.dart';
import '../core/constants/reminder_constants.dart';
import '../data/local/app_database.dart';
import '../domain/models/dose_record.dart';
import '../domain/models/dose_status.dart';
import '../domain/models/reminder_schedule.dart';
import '../domain/rules/dose_generator.dart';
import 'alarm_scheduler.dart';

class ReminderSchedulerService {
  ReminderSchedulerService({
    required this.database,
    required this.scheduler,
    this.clock = const SystemClock(),
  });

  final AppDatabase database;
  final AlarmScheduler scheduler;
  final Clock clock;

  /// Reschedules all active reminders for the next [windowDays] days.
  Future<int> rescheduleAll({
    DateTime? fromLocalDate,
    int windowDays = ReminderConstants.rollingWindowDays,
  }) async {
    final nowLocal = fromLocalDate ?? DateTime.now();
    final today = DateTime(nowLocal.year, nowLocal.month, nowLocal.day);
    final offset = nowLocal.timeZoneOffset.inMinutes;

    final query = database.select(database.reminders).join([
      innerJoin(
        database.medications,
        database.medications.id.equalsExp(database.reminders.medicationId),
      ),
    ]);

    final rows = await query.get();
    final storedRows = await database.select(database.doses).get();
    final stored = storedRows.map(doseRowToRecord).toList();

    var scheduledCount = 0;
    final nowUtc = clock.nowUtc();

    for (final row in rows) {
      final reminder = row.readTable(database.reminders);

      final generated = generateDoses(
        schedule: ReminderSchedule(
          reminderId: reminder.id,
          localTime: reminder.localTime,
          everyDay: reminder.everyDay,
          activeDays: reminder.activeDays,
        ),
        fromLocalDate: today,
        utcOffsetMinutes: offset,
        windowDays: windowDays,
      );

      for (final gen in generated) {
        final activeDose = _overlay(gen, stored);
        final alarmTime =
            activeDose.nextAlarmAtUtc ?? activeDose.scheduledAtUtc;
        if (alarmTime.isAfter(nowUtc) &&
            (activeDose.status == DoseStatus.pending ||
                activeDose.status == DoseStatus.snoozed)) {
          await scheduler.schedule(activeDose);
          scheduledCount++;
        }
      }
    }

    return scheduledCount;
  }

  /// Schedules the rolling window alarms for a specific medication.
  Future<int> scheduleForMedication(
    int medicationId, {
    DateTime? fromLocalDate,
    int windowDays = ReminderConstants.rollingWindowDays,
  }) async {
    final nowLocal = fromLocalDate ?? DateTime.now();
    final today = DateTime(nowLocal.year, nowLocal.month, nowLocal.day);
    final offset = nowLocal.timeZoneOffset.inMinutes;

    final reminders = await database.getRemindersForMedication(medicationId);
    final storedRows = await database.select(database.doses).get();
    final stored = storedRows.map(doseRowToRecord).toList();

    var scheduledCount = 0;
    final nowUtc = clock.nowUtc();

    for (final reminder in reminders) {
      final generated = generateDoses(
        schedule: ReminderSchedule(
          reminderId: reminder.id,
          localTime: reminder.localTime,
          everyDay: reminder.everyDay,
          activeDays: reminder.activeDays,
        ),
        fromLocalDate: today,
        utcOffsetMinutes: offset,
        windowDays: windowDays,
      );

      for (final gen in generated) {
        final activeDose = _overlay(gen, stored);
        final alarmTime =
            activeDose.nextAlarmAtUtc ?? activeDose.scheduledAtUtc;
        if (alarmTime.isAfter(nowUtc) &&
            (activeDose.status == DoseStatus.pending ||
                activeDose.status == DoseStatus.snoozed)) {
          await scheduler.schedule(activeDose);
          scheduledCount++;
        }
      }
    }

    return scheduledCount;
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
