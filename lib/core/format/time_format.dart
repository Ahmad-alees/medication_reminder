String formatTimeArabic(String time24) {
  final parts = time24.split(':');
  if (parts.length != 2) return time24;
  var hour = int.tryParse(parts[0]) ?? 0;
  final minute = parts[1];
  final isPM = hour >= 12;
  var hour12 = hour % 12;
  if (hour12 == 0) hour12 = 12;
  return '$hour12:$minute ${isPM ? 'م' : 'ص'}';
}

({int hour, int minute}) parseLocalTime(String time24) {
  final parts = time24.split(':');
  final hour = int.tryParse(parts.isNotEmpty ? parts[0] : '') ?? 0;
  final minute = int.tryParse(parts.length > 1 ? parts[1] : '') ?? 0;
  return (hour: hour.clamp(0, 23), minute: minute.clamp(0, 59));
}
