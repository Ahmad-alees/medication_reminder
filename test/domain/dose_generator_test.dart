import 'package:flutter_test/flutter_test.dart';
import 'package:medication_reminder/core/constants/reminder_constants.dart';
import 'package:medication_reminder/domain/models/reminder_schedule.dart';
import 'package:medication_reminder/domain/rules/dose_generator.dart';

void main() {
  const offsetPlus3h = 180;

  test('generates one dose per active day in the rolling window', () {
    const schedule = ReminderSchedule(
      reminderId: 1,
      localTime: '08:00',
      everyDay: true,
      activeDays: 'all',
    );

    final doses = generateDoses(
      schedule: schedule,
      fromLocalDate: DateTime(2026, 10, 17),
      utcOffsetMinutes: offsetPlus3h,
    );

    expect(doses, hasLength(ReminderConstants.rollingWindowDays));
    expect(doses.first.scheduledAtUtc, DateTime.utc(2026, 10, 17, 5, 0));
    expect(doses.first.utcOffsetMinutes, offsetPlus3h);
    expect(doses.last.scheduledAtUtc, DateTime.utc(2026, 10, 23, 5, 0));
  });

  test('honors Active Days instead of every day', () {
    const schedule = ReminderSchedule(
      reminderId: 4,
      localTime: '21:00',
      everyDay: false,
      activeDays: '6,7',
    );

    final doses = generateDoses(
      schedule: schedule,
      fromLocalDate: DateTime(2026, 10, 17), // Saturday
      utcOffsetMinutes: offsetPlus3h,
      windowDays: 7,
    );

    expect(doses, hasLength(2));
    expect(doses[0].scheduledAtUtc, DateTime.utc(2026, 10, 17, 18, 0));
    expect(doses[1].scheduledAtUtc, DateTime.utc(2026, 10, 18, 18, 0));
  });

  test('keeps 23:59 and 00:00 on the intended local calendar day', () {
    const late = ReminderSchedule(
      reminderId: 2,
      localTime: '23:59',
      everyDay: true,
      activeDays: 'all',
    );
    const early = ReminderSchedule(
      reminderId: 3,
      localTime: '00:00',
      everyDay: true,
      activeDays: 'all',
    );

    final lateDoses = generateDoses(
      schedule: late,
      fromLocalDate: DateTime(2026, 10, 17),
      utcOffsetMinutes: offsetPlus3h,
      windowDays: 1,
    );
    final earlyDoses = generateDoses(
      schedule: early,
      fromLocalDate: DateTime(2026, 10, 17),
      utcOffsetMinutes: offsetPlus3h,
      windowDays: 1,
    );

    expect(lateDoses.single.scheduledAtUtc, DateTime.utc(2026, 10, 17, 20, 59));
    expect(earlyDoses.single.scheduledAtUtc, DateTime.utc(2026, 10, 16, 21, 0));
  });

  test('two reminders at the same minute stay distinct', () {
    const first = ReminderSchedule(
      reminderId: 10,
      localTime: '08:00',
      everyDay: true,
      activeDays: 'all',
    );
    const second = ReminderSchedule(
      reminderId: 11,
      localTime: '08:00',
      everyDay: true,
      activeDays: 'all',
    );

    final doses = [
      ...generateDoses(
        schedule: first,
        fromLocalDate: DateTime(2026, 10, 17),
        utcOffsetMinutes: offsetPlus3h,
        windowDays: 1,
      ),
      ...generateDoses(
        schedule: second,
        fromLocalDate: DateTime(2026, 10, 17),
        utcOffsetMinutes: offsetPlus3h,
        windowDays: 1,
      ),
    ];

    expect(doses, hasLength(2));
    expect(doses[0].scheduledAtUtc, doses[1].scheduledAtUtc);
    expect(doses[0].reminderId, isNot(doses[1].reminderId));
  });
}
