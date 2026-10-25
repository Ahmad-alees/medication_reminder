import 'package:flutter_test/flutter_test.dart';
import 'package:medication_reminder/core/clock.dart';
import 'package:medication_reminder/data/dose_repository.dart';
import 'package:medication_reminder/data/local/app_database.dart';
import 'package:medication_reminder/domain/models/dose_record.dart';
import 'package:medication_reminder/domain/models/dose_status.dart';

void main() {
  test('Taken is persisted and decrements stock only once', () async {
    final database = AppDatabase.forTesting();
    addTearDown(database.close);

    await database.addMedicationWithReminders(
      name: 'TestMed',
      strength: '500 mg',
      form: 'tablet',
      stockQuantity: 10,
      stockThreshold: 7,
      localTimes: ['08:00'],
    );

    final reminder = (await database.select(database.reminders).get()).single;
    final clock = FakeClock(DateTime.utc(2026, 10, 17, 5, 0));
    final repository = DoseRepository(database: database, clock: clock);
    final dose = DoseRecord(
      reminderId: reminder.id,
      scheduledAtUtc: DateTime.utc(2026, 10, 17, 5, 0),
      utcOffsetMinutes: 180,
    );

    await repository.take(dose);
    await repository.take(dose);

    final stored = await database.select(database.doses).get();
    expect(stored, hasLength(1));
    expect(stored.single.status, DoseStatus.taken.storageValue);

    final medication =
        (await database.select(database.medications).get()).single;
    expect(medication.stockQuantity, 9);
  });
}
