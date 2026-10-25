import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../domain/models/dose_record.dart';
import 'alarm_scheduler.dart';

class AndroidAlarmScheduler implements AlarmScheduler {
  AndroidAlarmScheduler({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin() {
    tzdata.initializeTimeZones();
  }

  final FlutterLocalNotificationsPlugin _plugin;

  static const String channelId = 'medication_alarms';
  static const String channelName = 'Medication Alarms';
  static const String channelDescription =
      'Medication dose reminders and alarms';

  static const String actionTake = 'action_take';
  static const String actionSnooze = 'action_snooze';

  /// Generates a stable positive 31-bit notification ID per reminder and scheduled time.
  int notificationId(int reminderId, DateTime scheduledAtUtc) {
    final dayPart = scheduledAtUtc.day * 10000;
    final timePart = scheduledAtUtc.hour * 100 + scheduledAtUtc.minute;
    return ((reminderId * 1000000) + dayPart + timePart) & 0x7FFFFFFF;
  }

  int _id(DoseRecord dose) =>
      dose.id ?? notificationId(dose.reminderId, dose.scheduledAtUtc);

  Future<void> initialize({
    void Function(NotificationResponse response)? onNotificationResponse,
  }) async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initSettings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: onNotificationResponse,
    );

    const channel = AndroidNotificationChannel(
      channelId,
      channelName,
      description: channelDescription,
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  Future<NotificationAppLaunchDetails?> getLaunchDetails() {
    return _plugin.getNotificationAppLaunchDetails();
  }

  @override
  Future<void> schedule(DoseRecord dose, {String? title, String? body}) async {
    final when = tz.TZDateTime.from(
      dose.nextAlarmAtUtc ?? dose.scheduledAtUtc,
      tz.UTC,
    );

    // Only schedule if the alarm time is in the future
    if (when.isBefore(tz.TZDateTime.now(tz.UTC))) {
      return;
    }

    final payload =
        '${dose.reminderId}|${dose.scheduledAtUtc.toIso8601String()}';

    await _plugin.zonedSchedule(
      id: _id(dose),
      title: title ?? 'تذكير بالدواء',
      body: body ?? 'حان موعد تناول الدواء',
      scheduledDate: when,
      payload: payload,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          channelDescription: channelDescription,
          importance: Importance.max,
          priority: Priority.high,
          fullScreenIntent: true,
          category: AndroidNotificationCategory.alarm,
          visibility: NotificationVisibility.public,
          actions: [
            AndroidNotificationAction(
              actionTake,
              'تم أخذ الدواء',
              showsUserInterface: true,
            ),
            AndroidNotificationAction(actionSnooze, 'تأجيل 10 د'),
          ],
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  @override
  Future<void> cancel(DoseRecord dose) async {
    await _plugin.cancel(id: _id(dose));
  }

  @override
  Future<void> replace(DoseRecord dose) async {
    await cancel(dose);
    await schedule(dose);
  }
}
