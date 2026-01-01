import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class CalendarNotification {
  static String calendarChannelId = "calendar_channel";
  static String calendarChannelName = "Calendar";

  static FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    calendarChannelId,
    calendarChannelName,
    importance: Importance.max,
    priority: Priority.max,
    playSound: true,
    enableVibration: true,
  );

  static Future<void> initialNotification() async {
    // 1. Init timezone
    tz.initializeTimeZones();
    final TimezoneInfo timezone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timezone.identifier));
    // 2. Android settings
    const android = AndroidInitializationSettings("@mipmap/ic_launcher");
    // 3. iOS settings
    const iOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    // 4. Init settings
    const initializationSettings = InitializationSettings(
      android: android,
      iOS: iOS,
    );
    // 5. Initialize với callback
    await notificationsPlugin.initialize(initializationSettings);

    // 6. Create notification channel
    final AndroidNotificationChannel notificationChannel =
        AndroidNotificationChannel(
          calendarChannelId,
          calendarChannelName,
          description: "Thông báo lịch",
          importance: Importance.high,
        );

    final androidPlugin = notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(notificationChannel);
      // 7. Request permissions
      await androidPlugin.requestNotificationsPermission();
      await androidPlugin.requestExactAlarmsPermission();
    }
  }

  static Future<bool> canScheduleExactAlarms() async {
    final androidPlugin = notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidPlugin != null) {
      return await androidPlugin.canScheduleExactNotifications() ?? false;
    }
    return false;
  }

  static Future<void> regrantScheduleExactAlarms() async {
    final canSchedule = await canScheduleExactAlarms();
    if (!canSchedule) {
      final androidPlugin = notificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      await androidPlugin?.requestExactAlarmsPermission();
      return;
    }
  }

  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    await regrantScheduleExactAlarms();
    final details = NotificationDetails(android: androidDetails);
    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await notificationsPlugin.show(id, title, body, details);
  }

  static Future<void> scheduleNotification({
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    await regrantScheduleExactAlarms();
    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final details = NotificationDetails(android: androidDetails);
    final tz.TZDateTime scheduledTZDate = tz.TZDateTime.from(scheduledDate, tz.local);

    await notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTZDate,
      details,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}
