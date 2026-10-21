import '../../core/constants/reminder_constants.dart';
import '../../core/format/time_format.dart';
import '../models/dose_record.dart';
import '../models/dose_status.dart';
import '../models/reminder_schedule.dart';

/// Converts a local calendar date + `"HH:mm"` into UTC using a fixed offset.
DateTime localWallToUtc({
  required DateTime localDate,
  required String localTime,
  required int utcOffsetMinutes,
}) {
  final parsed = parseLocalTime(localTime);
  return DateTime.utc(
    localDate.year,
    localDate.month,
    localDate.day,
    parsed.hour,
    parsed.minute,
  ).subtract(Duration(minutes: utcOffsetMinutes));
}

/// Generates Dose events for the next [windowDays] local calendar days.
///
/// Time-zone travel is an open decision; callers pass the offset that should
/// apply for this window (typically the device offset at generation time).
List<DoseRecord> generateDoses({
  required ReminderSchedule schedule,
  required DateTime fromLocalDate,
  required int utcOffsetMinutes,
  int windowDays = ReminderConstants.rollingWindowDays,
}) {
  final start = DateTime(
    fromLocalDate.year,
    fromLocalDate.month,
    fromLocalDate.day,
  );
  final doses = <DoseRecord>[];

  for (var day = 0; day < windowDays; day++) {
    final localDate = start.add(Duration(days: day));
    if (!schedule.isActiveOnWeekday(localDate.weekday)) continue;

    final scheduledAtUtc = localWallToUtc(
      localDate: localDate,
      localTime: schedule.localTime,
      utcOffsetMinutes: utcOffsetMinutes,
    );

    doses.add(
      DoseRecord(
        reminderId: schedule.reminderId,
        scheduledAtUtc: scheduledAtUtc,
        utcOffsetMinutes: utcOffsetMinutes,
        status: DoseStatus.pending,
        nextAlarmAtUtc: scheduledAtUtc,
      ),
    );
  }

  return doses;
}
