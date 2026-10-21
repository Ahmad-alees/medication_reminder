import 'package:flutter_test/flutter_test.dart';
import 'package:medication_reminder/domain/models/dose_record.dart';
import 'package:medication_reminder/domain/models/dose_status.dart';
import 'package:medication_reminder/domain/rules/adherence.dart';

DoseRecord _dose(DoseStatus status) {
  return DoseRecord(
    reminderId: 1,
    scheduledAtUtc: DateTime.utc(2026, 10, 17),
    utcOffsetMinutes: 180,
    status: status,
  );
}

void main() {
  test('rate uses stored Taken and Missed only', () {
    final summary = summarizeAdherence([
      _dose(DoseStatus.taken),
      _dose(DoseStatus.taken),
      _dose(DoseStatus.missed),
      _dose(DoseStatus.snoozed),
      _dose(DoseStatus.pending),
    ]);

    expect(summary.taken, 2);
    expect(summary.missed, 1);
    expect(summary.snoozed, 1);
    expect(summary.pending, 1);
    expect(summary.rate, closeTo(2 / 3, 0.0001));
  });

  test('rate is zero when nothing is logged', () {
    final summary = summarizeAdherence([_dose(DoseStatus.pending)]);
    expect(summary.rate, 0);
  });
}
