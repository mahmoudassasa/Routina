import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  tz.initializeTimeZones();
  final tzInfo = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(tzInfo.identifier));

  const androidSettings = AndroidInitializationSettings('ic_launcher');
  const initializationSettings = InitializationSettings(android: androidSettings);

  // التصحيح هنا: لازم نستخدم التسمية (settings: ...)
  await notificationsPlugin.initialize(
    settings: initializationSettings, 
    onDidReceiveNotificationResponse: (details) {
      debugPrint("Notification clicked: ${details.payload}");
    },
  );

  if (defaultTargetPlatform == TargetPlatform.android) {
    final androidImplementation = notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidImplementation?.requestNotificationsPermission();
    await androidImplementation?.requestExactAlarmsPermission();
  }
}

Future<void> scheduleDailyNotification({
  required int id,
  required String title,
  required String body,
  required int hour,
  required int minute,
}) async {
  final tzInfo = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(tzInfo.identifier));
  final scheduledTime = _nextInstanceOfTime(hour, minute);

  await notificationsPlugin.zonedSchedule(
    id: id,
    title: title,
    body: body,
    scheduledDate: scheduledTime,
    notificationDetails: const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_reminders_id',
        'Daily Reminders',
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/launcher_icon', // السطر ده اللي هيمنع الـ NullPointerException
      ),
    ),
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    matchDateTimeComponents: DateTimeComponents.time,
  );

  debugPrint("✅ إشعار مجدول عند: $scheduledTime");
}

Future<void> cancelNotification(int id) async {
  await notificationsPlugin.cancel(id: id);
}

tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
  final now = tz.TZDateTime.now(tz.local);
  var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }
  return scheduledDate;
}

Future<bool> requestNotificationPermissions() async {
    final androidPlugin = notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      // دي اللي بتطلع الـ Pop-up الرسمي بتاع أندرويد 13+
      final bool? granted = await androidPlugin.requestNotificationsPermission();
      return granted ?? false;
    }
    return false;
  }