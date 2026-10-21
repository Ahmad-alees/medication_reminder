class ReminderSchedule {
  const ReminderSchedule({
    required this.reminderId,
    required this.localTime,
    required this.everyDay,
    required this.activeDays,
  });

  final int reminderId;

  /// Local wall-clock time as `"HH:mm"`.
  final String localTime;
  final bool everyDay;

  /// `"all"` or comma-separated [DateTime.weekday] values (`1` = Monday).
  final String activeDays;

  bool isActiveOnWeekday(int weekday) {
    if (everyDay || activeDays == 'all') return true;
    final days = activeDays
        .split(',')
        .map((value) => int.tryParse(value.trim()))
        .whereType<int>();
    return days.contains(weekday);
  }
}
