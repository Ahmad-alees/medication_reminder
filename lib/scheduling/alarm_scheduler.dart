import '../domain/models/dose_record.dart';

/// Thin wrapper around OS alarms. Domain code talks only to this interface.
/// A real Android implementation is not wired yet — do not treat reminders
/// as working until that ships and is tested on a device.
abstract class AlarmScheduler {
  Future<void> schedule(DoseRecord dose);

  Future<void> cancel(DoseRecord dose);

  Future<void> replace(DoseRecord dose) async {
    await cancel(dose);
    await schedule(dose);
  }
}

class NoOpAlarmScheduler implements AlarmScheduler {
  const NoOpAlarmScheduler();

  @override
  Future<void> cancel(DoseRecord dose) async {}

  @override
  Future<void> schedule(DoseRecord dose) async {}

  @override
  Future<void> replace(DoseRecord dose) async {}
}
