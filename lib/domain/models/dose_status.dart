/// Documented Dose Status values from docs/glossary.md.
enum DoseStatus {
  pending,
  taken,
  snoozed,
  missed,
}

extension DoseStatusCodec on DoseStatus {
  String get storageValue => name;

  static DoseStatus fromStorage(String value) {
    return DoseStatus.values.firstWhere(
      (status) => status.name == value,
      orElse: () => DoseStatus.pending,
    );
  }

  bool get isTerminal => this == DoseStatus.taken || this == DoseStatus.missed;
}
