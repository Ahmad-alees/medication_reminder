import '../../core/constants/reminder_constants.dart';
import '../models/dose_record.dart';
import '../models/dose_status.dart';

class DoseTransition {
  const DoseTransition({
    required this.dose,
    required this.changed,
    this.shouldSendEscalation = false,
  });

  final DoseRecord dose;
  final bool changed;
  final bool shouldSendEscalation;
}

/// `pending → (ringing is UI-only) ⇄ snoozed → taken | missed`.
/// Terminal states stay final here. Taken is idempotent.
class DoseStateMachine {
  const DoseStateMachine();

  DoseTransition take(DoseRecord dose, DateTime nowUtc) {
    if (dose.status == DoseStatus.taken) {
      return DoseTransition(dose: dose, changed: false);
    }
    if (dose.status == DoseStatus.missed) {
      return DoseTransition(dose: dose, changed: false);
    }
    return DoseTransition(
      dose: dose.copyWith(
        status: DoseStatus.taken,
        actedAtUtc: nowUtc,
        clearNextAlarm: true,
      ),
      changed: true,
    );
  }

  DoseTransition snooze(DoseRecord dose, DateTime nowUtc) {
    if (dose.status.isTerminal) {
      return DoseTransition(dose: dose, changed: false);
    }
    return DoseTransition(
      dose: dose.copyWith(
        status: DoseStatus.snoozed,
        actedAtUtc: nowUtc,
        nextAlarmAtUtc: nowUtc.add(ReminderConstants.snoozeDuration),
      ),
      changed: true,
    );
  }

  /// Spec "تخطي" maps to Missed; "Skipped" is not a documented status.
  DoseTransition markMissed(DoseRecord dose, DateTime nowUtc) {
    if (dose.status.isTerminal) {
      return DoseTransition(dose: dose, changed: false);
    }
    return DoseTransition(
      dose: dose.copyWith(
        status: DoseStatus.missed,
        actedAtUtc: nowUtc,
        clearNextAlarm: true,
      ),
      changed: true,
    );
  }

  DoseTransition onUnanswered(DoseRecord dose, DateTime nowUtc) {
    if (dose.status.isTerminal) {
      return DoseTransition(dose: dose, changed: false);
    }

    final elapsed = nowUtc.difference(dose.scheduledAtUtc);
    if (elapsed >= ReminderConstants.missedCutoff) {
      return markMissed(dose, nowUtc);
    }

    final repeats = dose.unansweredRepeatCount + 1;
    final sendEscalation =
        !dose.escalationSent &&
        repeats >= ReminderConstants.unansweredRepeatsBeforeEscalation;

    return DoseTransition(
      dose: dose.copyWith(
        unansweredRepeatCount: repeats,
        escalationSent: dose.escalationSent || sendEscalation,
        nextAlarmAtUtc: nowUtc.add(ReminderConstants.unansweredRepeatInterval),
      ),
      changed: true,
      shouldSendEscalation: sendEscalation,
    );
  }
}
