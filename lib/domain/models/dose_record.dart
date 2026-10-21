import 'dose_status.dart';

/// One scheduled intake of a Medication. Status is stored with the event;
/// adherence is never recomputed from the current time zone.
class DoseRecord {
  const DoseRecord({
    required this.reminderId,
    required this.scheduledAtUtc,
    required this.utcOffsetMinutes,
    this.id,
    this.status = DoseStatus.pending,
    this.actedAtUtc,
    this.unansweredRepeatCount = 0,
    this.escalationSent = false,
    this.nextAlarmAtUtc,
  });

  final int? id;
  final int reminderId;
  final DateTime scheduledAtUtc;
  final int utcOffsetMinutes;
  final DoseStatus status;
  final DateTime? actedAtUtc;
  final int unansweredRepeatCount;
  final bool escalationSent;
  final DateTime? nextAlarmAtUtc;

  DoseRecord copyWith({
    int? id,
    DoseStatus? status,
    DateTime? actedAtUtc,
    int? unansweredRepeatCount,
    bool? escalationSent,
    DateTime? nextAlarmAtUtc,
    bool clearNextAlarm = false,
    bool clearActedAt = false,
  }) {
    return DoseRecord(
      id: id ?? this.id,
      reminderId: reminderId,
      scheduledAtUtc: scheduledAtUtc,
      utcOffsetMinutes: utcOffsetMinutes,
      status: status ?? this.status,
      actedAtUtc: clearActedAt ? null : (actedAtUtc ?? this.actedAtUtc),
      unansweredRepeatCount:
          unansweredRepeatCount ?? this.unansweredRepeatCount,
      escalationSent: escalationSent ?? this.escalationSent,
      nextAlarmAtUtc: clearNextAlarm
          ? null
          : (nextAlarmAtUtc ?? this.nextAlarmAtUtc),
    );
  }
}
