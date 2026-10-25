import 'package:flutter_test/flutter_test.dart';
import 'package:medication_reminder/core/clock.dart';
import 'package:medication_reminder/data/local/app_database.dart';
import 'package:medication_reminder/domain/models/dose_record.dart';
import 'package:medication_reminder/scheduling/alarm_scheduler.dart';
import 'package:medication_reminder/scheduling/reminder_scheduler_service.dart';

class FakeAlarmScheduler implements AlarmScheduler {
  final List<DoseRecord> scheduled = [];
  final List<DoseRecord> cancelled = [];

  @override
  Future<void> schedule(DoseRecord dose) async {
    scheduled.add(dose);
  }

  @override
  Future<void> cancel(DoseRecord dose) async {
    cancelled.add(dose);
  }

  @override
  Future<void> replace(DoseRecord dose) async {
    await cancel(dose);
    await schedule(dose);
  }
}

void main() {
  test(
    'ReminderSchedulerService schedules future doses in rolling window',
    () async {
      final db = AppDatabase.forTesting();
      addTearDown(db.close);

      final fakeClock = FakeClock(DateTime.utc(2026, 10, 25, 6, 0));
      final scheduler = FakeAlarmScheduler();

      final service = ReminderSchedulerService(
        database: db,
        scheduler: scheduler,
        clock: fakeClock,
      );

      final medId = await db.addMedicationWithReminders(
        name: 'ميتفورمين',
        strength: '500 مغ',
        form: 'tablet',
        stockQuantity: 20,
        stockThreshold: 5,
        localTimes: ['08:00', '20:00'],
        everyDay: true,
        activeDays: 'all',
      );

      final scheduledCount = await service.scheduleForMedication(
        medId,
        fromLocalDate: DateTime(2026, 10, 25),
        windowDays: 7,
      );

      expect(scheduledCount, greaterThan(0));
      expect(scheduler.scheduled.length, scheduledCount);
    },
  );
}
