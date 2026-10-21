import '../models/dose_record.dart';
import '../models/dose_status.dart';

class AdherenceSummary {
  const AdherenceSummary({
    required this.taken,
    required this.missed,
    required this.snoozed,
    required this.pending,
  });

  final int taken;
  final int missed;
  final int snoozed;
  final int pending;

  int get logged => taken + missed;

  /// Taken / (Taken + Missed). Pending and Snoozed are excluded.
  double get rate {
    if (logged == 0) return 0;
    return taken / logged;
  }
}

AdherenceSummary summarizeAdherence(Iterable<DoseRecord> doses) {
  var taken = 0;
  var missed = 0;
  var snoozed = 0;
  var pending = 0;

  for (final dose in doses) {
    switch (dose.status) {
      case DoseStatus.taken:
        taken++;
      case DoseStatus.missed:
        missed++;
      case DoseStatus.snoozed:
        snoozed++;
      case DoseStatus.pending:
        pending++;
    }
  }

  return AdherenceSummary(
    taken: taken,
    missed: missed,
    snoozed: snoozed,
    pending: pending,
  );
}
