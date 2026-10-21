/// Named reminder timings. Values follow the approved spec (10-minute
/// snooze and unanswered repeat). Missed cutoff and escalation counts are
/// the standing defaults in AGENTS.md.
abstract final class ReminderConstants {
  static const Duration snoozeDuration = Duration(minutes: 10);
  static const Duration unansweredRepeatInterval = Duration(minutes: 10);
  static const int unansweredRepeatsBeforeEscalation = 3;
  static const Duration missedCutoff = Duration(minutes: 60);
  static const int rollingWindowDays = 7;
}
