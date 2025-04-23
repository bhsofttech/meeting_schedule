// 

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:get/get.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  late FlutterLocalNotificationsPlugin _notificationsPlugin;
  bool _isInitialized = false;

  Future<bool> initialize() async {
    try {
      _notificationsPlugin = FlutterLocalNotificationsPlugin();

      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      final InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
      );

      await _notificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (details) {},
      );

      // Request permissions for Android 13+
      final androidPlugin = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin != null) {
        final granted = await androidPlugin.requestNotificationsPermission();
        if (granted==false) {
          Get.snackbar(
            'Permission Denied',
            'Notification permissions are required for reminders. Please enable them in settings.',
            snackPosition: SnackPosition.BOTTOM,
          );
          return false;
        }
      }

      _isInitialized = true;
      return true;
    } catch (e) {
      print('Error initializing notifications: $e');
      Get.snackbar(
        'Error',
        'Failed to initialize notifications: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  Future<bool> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    if (!_isInitialized) {
      print('NotificationService not initialized');
      return false;
    }

    try {
      final location = tz.getLocation('America/New_York');
      final tzScheduledTime = tz.TZDateTime.from(scheduledTime, location);

      if (tzScheduledTime.isBefore(tz.TZDateTime.now(location))) {
        print('Scheduled time $tzScheduledTime is in the past');
        return false;
      }

      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'meeting_reminders',
        'Meeting Reminders',
        channelDescription: 'Notifications for upcoming meetings',
        importance: Importance.max,
        priority: Priority.high,
        enableVibration: true,
        playSound: true,
      );

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );

      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tzScheduledTime,
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      print('Scheduled notification $id for $tzScheduledTime');
      return true;
    } catch (e) {
      print('Error scheduling notification $id: $e');
      Get.snackbar(
        'Error',
        'Failed to schedule notification: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  Future<void> cancelNotification(int id) async {
    try {
      await _notificationsPlugin.cancel(id);
      print('Cancelled notification $id');
    } catch (e) {
      print('Error cancelling notification $id: $e');
    }
  }

  Future<void> cancelAllNotifications() async {
    try {
      await _notificationsPlugin.cancelAll();
      print('Cancelled all notifications');
    } catch (e) {
      print('Error cancelling all notifications: $e');
    }
  }
}