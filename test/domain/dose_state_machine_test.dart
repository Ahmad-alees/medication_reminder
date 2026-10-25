import 'package:flutter_test/flutter_test.dart';
import 'package:medication_reminder/core/clock.dart';
import 'package:medication_reminder/core/constants/reminder_constants.dart';
import 'package:medication_reminder/domain/models/dose_record.dart';
import 'package:medication_reminder/domain/models/dose_status.dart';
import 'package:medication_reminder/domain/rules/dose_state_machine.dart';

void main() {
  const machine = DoseStateMachine();
  final scheduled = DateTime.utc(2026, 10, 17, 5, 0);
  final clock = FakeClock(scheduled);

  DoseRecord pending() => DoseRecord(
    reminderId: 1,
    scheduledAtUtc: scheduled,
    utcOffsetMinutes: 180,
    nextAlarmAtUtc: scheduled,
  );

  test('Taken moves pending to taken and is idempotent', () {
    final first = machine.take(pending(), clock.nowUtc());
    expect(first.changed, isTrue);
    expect(first.dose.status, DoseStatus.taken);
    expect(first.dose.nextAlarmAtUtc, isNull);

    final second = machine.take(first.dose, clock.nowUtc());
    expect(second.changed, isFalse);
    expect(second.dose.status, DoseStatus.taken);
    expect(second.dose.actedAtUtc, first.dose.actedAtUtc);
  });

  test('Snooze schedules the next alarm 10 minutes later', () {
    final result = machine.snooze(pending(), clock.nowUtc());
    expect(result.dose.status, DoseStatus.snoozed);
    expect(
      result.dose.nextAlarmAtUtc,
      clock.nowUtc().add(ReminderConstants.snoozeDuration),
    );
  });

  test('Skip records the dose as Missed', () {
    final result = machine.markMissed(pending(), clock.nowUtc());
    expect(result.dose.status, DoseStatus.missed);
    expect(result.dose.nextAlarmAtUtc, isNull);
  });

  test('unanswered repeats then sends one escalation then marks Missed', () {
    var dose = pending();
    var escalationCount = 0;

    for (var i = 0; i < 3; i++) {
      clock.advance(ReminderConstants.unansweredRepeatInterval);
      final result = machine.onUnanswered(dose, clock.nowUtc());
      dose = result.dose;
      if (result.shouldSendEscalation) escalationCount++;
    }

    expect(dose.status, DoseStatus.pending);
    expect(dose.unansweredRepeatCount, 3);
    expect(dose.escalationSent, isTrue);
    expect(escalationCount, 1);

    final lateClock = FakeClock(scheduled.add(ReminderConstants.missedCutoff));
    final missed = machine.onUnanswered(dose, lateClock.nowUtc());
    expect(missed.dose.status, DoseStatus.missed);
  });

  test('cutoff at 59 minutes stays pending and 60 minutes is Missed', () {
    final at59 = machine.onUnanswered(
      pending(),
      scheduled.add(const Duration(minutes: 59)),
    );
    expect(at59.dose.status, DoseStatus.pending);

    final at60 = machine.onUnanswered(
      pending(),
      scheduled.add(const Duration(minutes: 60)),
    );
    expect(at60.dose.status, DoseStatus.missed);

    final at61 = machine.onUnanswered(
      pending(),
      scheduled.add(const Duration(minutes: 61)),
    );
    expect(at61.dose.status, DoseStatus.missed);
  });

  test('terminal Taken and Missed ignore snooze and skip', () {
    final taken = machine.take(pending(), clock.nowUtc()).dose;
    expect(machine.snooze(taken, clock.nowUtc()).changed, isFalse);
    expect(machine.markMissed(taken, clock.nowUtc()).changed, isFalse);

    final missed = machine.markMissed(pending(), clock.nowUtc()).dose;
    expect(machine.take(missed, clock.nowUtc()).changed, isFalse);
    expect(machine.snooze(missed, clock.nowUtc()).changed, isFalse);
  });

  test('snooze across midnight keeps the next alarm after midnight UTC', () {
    final late = DoseRecord(
      reminderId: 9,
      scheduledAtUtc: DateTime.utc(2026, 10, 17, 23, 55),
      utcOffsetMinutes: 0,
    );
    final result = machine.snooze(late, DateTime.utc(2026, 10, 17, 23, 55));
    expect(result.dose.nextAlarmAtUtc, DateTime.utc(2026, 10, 18, 0, 5));
  });
}
