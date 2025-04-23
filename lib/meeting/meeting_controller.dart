// // // import 'package:doc_scanner/database_helper.dart';
// // // import 'package:doc_scanner/meeting.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:get/get.dart';
// // // import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// // // import 'package:timezone/timezone.dart' as tz;
// // // import 'package:timezone/data/latest.dart' as tz;

// // // class MeetingController extends GetxController {
// // //   final DatabaseHelper _databaseHelper = DatabaseHelper();
// // //   final RxList<Meeting> meetings = <Meeting>[].obs;
// // //   final Rx<DateTime> selectedDate = DateTime.now().obs;
// // //   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// // //       FlutterLocalNotificationsPlugin();

// // //   @override
// // //   void onInit() {
// // //     super.onInit();
// // //     tz.initializeTimeZones();
// // //     _initializeNotifications();
// // //     loadMeetings();
// // //   }

// // //   Future<void> _initializeNotifications() async {
// // //     const AndroidInitializationSettings initializationSettingsAndroid =
// // //         AndroidInitializationSettings('@mipmap/ic_launcher');
    
// // //     final InitializationSettings initializationSettings =
// // //         InitializationSettings(
// // //       android: initializationSettingsAndroid,
// // //     );
    
// // //     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
// // //   }

// // //   Future<void> loadMeetings() async {
// // //     final loadedMeetings = await _databaseHelper.getAllMeetings();
// // //     meetings.assignAll(loadedMeetings);
// // //     _scheduleAllReminders();
// // //   }

// // //   Future<void> addMeeting(Meeting meeting) async {
// // //     final id = await _databaseHelper.insertMeeting(meeting);
// // //     final newMeeting = meeting.copyWith(id: id);
// // //     meetings.add(newMeeting);
// // //     _scheduleReminder(newMeeting);
// // //   }

// // //   Future<void> updateMeeting(Meeting meeting) async {
// // //     await _databaseHelper.updateMeeting(meeting);
// // //     final index = meetings.indexWhere((m) => m.id == meeting.id);
// // //     if (index != -1) {
// // //       meetings[index] = meeting;
// // //     }
// // //     _scheduleReminder(meeting);
// // //   }

// // //   Future<void> deleteMeeting(int id) async {
// // //     await _databaseHelper.deleteMeeting(id);
// // //     meetings.removeWhere((meeting) => meeting.id == id);
// // //     await flutterLocalNotificationsPlugin.cancel(id);
// // //   }

// // //   Future<void> toggleMeetingCompletion(int id) async {
// // //     final meeting = meetings.firstWhere((m) => m.id == id);
// // //     final updatedMeeting = meeting.copyWith(isCompleted: !meeting.isCompleted);
// // //     await updateMeeting(updatedMeeting);
// // //   }

// // //   Future<void> _scheduleReminder(Meeting meeting) async {
// // //     if (meeting.reminderMinutes <= 0) return;

// // //     await flutterLocalNotificationsPlugin.cancel(meeting.id!);

// // //     final reminderTime = meeting.startTime.subtract(
// // //       Duration(minutes: meeting.reminderMinutes),
// // //     );

// // //     if (reminderTime.isBefore(DateTime.now())) return;

// // //     final androidPlatformChannelSpecifics = AndroidNotificationDetails(
// // //       'meeting_reminders',
// // //       'Meeting Reminders',
// // //       channelDescription: 'Notifications for upcoming meetings',
// // //       importance: Importance.max,
// // //       priority: Priority.high,
// // //     );

// // //     final platformChannelSpecifics = NotificationDetails(
// // //       android: androidPlatformChannelSpecifics,
// // //     );

// // //     await flutterLocalNotificationsPlugin.zonedSchedule(
// // //       meeting.id!,
// // //       'Upcoming Meeting: ${meeting.title}',
// // //       'Starts at ${TimeOfDay.fromDateTime(meeting.startTime).format(Get.context!)}',
// // //       tz.TZDateTime.from(reminderTime, tz.local),
// // //       platformChannelSpecifics,
// // //       androidScheduleMode: AndroidScheduleMode.alarmClock,
// // //       uiLocalNotificationDateInterpretation:
// // //           UILocalNotificationDateInterpretation.absoluteTime,
// // //     );
// // //   }

// // //   Future<void> _scheduleAllReminders() async {
// // //     for (final meeting in meetings) {
// // //       _scheduleReminder(meeting);
// // //     }
// // //   }

// // //   List<Meeting> getMeetingsForDate(DateTime date) {
// // //     return meetings.where((meeting) {
// // //       return meeting.startTime.year == date.year &&
// // //           meeting.startTime.month == date.month &&
// // //           meeting.startTime.day == date.day;
// // //     }).toList();
// // //   }

// // //   List<Meeting> getUpcomingMeetings() {
// // //     final now = DateTime.now();
// // //     return meetings
// // //         .where((meeting) => meeting.startTime.isAfter(now))
// // //         .toList()
// // //         .sublist(0, meetings.length > 3 ? 3 : meetings.length);
// // //   }

// // //   List<Meeting> getTodayMeetings() {
// // //     final now = DateTime.now();
// // //     return getMeetingsForDate(now);
// // //   }
// // // }

// // import 'package:doc_scanner/database_helper.dart';
// // import 'package:doc_scanner/meeting.dart';
// // import 'package:doc_scanner/notification_service.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// // import 'package:timezone/timezone.dart' as tz;
// // import 'package:timezone/data/latest.dart' as tz;
// // class MeetingController extends GetxController {
// //   final DatabaseHelper _databaseHelper = DatabaseHelper();
// //   final RxList<Meeting> meetings = <Meeting>[].obs;
// //   final Rx<DateTime> selectedDate = DateTime.now().obs;
// //   final RxBool isLoading = false.obs;
// //   final RxnString error = RxnString();
// //   final NotificationService _notificationService = NotificationService();

// //   @override
// //   void onInit() {
// //     super.onInit();
// //     _initializeTimeZones();
// //     _initializeNotifications();
// //     loadMeetings();
// //   }

// //   Future<void> _initializeTimeZones() async {
// //     tz.initializeTimeZones();
// //     final location = tz.getLocation('America/New_York');
// //     tz.setLocalLocation(location);
// //   }

// //   Future<void> _initializeNotifications() async {
// //     await _notificationService.initialize();
// //   }

// //   Future<void> loadMeetings() async {
// //     try {
// //       isLoading(true);
// //       error(null);
// //       final loadedMeetings = await _databaseHelper.getAllMeetings();
// //       meetings.assignAll(loadedMeetings);
// //       await _scheduleAllReminders();
// //     } catch (e) {
// //       error(e.toString());
// //       Get.snackbar(
// //         'Error',
// //         'Failed to load meetings: ${e.toString()}',
// //         snackPosition: SnackPosition.BOTTOM,
// //       );
// //     } finally {
// //       isLoading(false);
// //     }
// //   }

// //   Future<void> addMeeting(Meeting meeting) async {
// //     try {
// //       isLoading(true);
// //       final id = await _databaseHelper.insertMeeting(meeting);
// //       final newMeeting = meeting.copyWith(id: id);
// //       meetings.add(newMeeting);
// //       await _scheduleReminder(newMeeting);
// //     } catch (e) {
// //       error(e.toString());
// //       rethrow;
// //     } finally {
// //       isLoading(false);
// //     }
// //   }

// //   Future<void> updateMeeting(Meeting meeting) async {
// //     try {
// //       isLoading(true);
// //       await _databaseHelper.updateMeeting(meeting);
// //       final index = meetings.indexWhere((m) => m.id == meeting.id);
// //       if (index != -1) {
// //         meetings[index] = meeting;
// //       }
// //       await _scheduleReminder(meeting);
// //     } catch (e) {
// //       error(e.toString());
// //       rethrow;
// //     } finally {
// //       isLoading(false);
// //     }
// //   }

// //   Future<void> deleteMeeting(int id) async {
// //     try {
// //       isLoading(true);
// //       await _databaseHelper.deleteMeeting(id);
// //       meetings.removeWhere((meeting) => meeting.id == id);
// //       await _notificationService.cancelNotification(id);
// //     } catch (e) {
// //       error(e.toString());
// //       rethrow;
// //     } finally {
// //       isLoading(false);
// //     }
// //   }

// //   Future<void> toggleMeetingCompletion(int id) async {
// //     try {
// //       isLoading(true);
// //       final meeting = meetings.firstWhere((m) => m.id == id);
// //       final updatedMeeting = meeting.copyWith(isCompleted: !meeting.isCompleted);
// //       await updateMeeting(updatedMeeting);
// //     } catch (e) {
// //       error(e.toString());
// //       rethrow;
// //     } finally {
// //       isLoading(false);
// //     }
// //   }

// //   Future<void> _scheduleReminder(Meeting meeting) async {
// //     if (meeting.reminderMinutes <= 0 || meeting.id == null) return;

// //     await _notificationService.cancelNotification(meeting.id!);

// //     final reminderTime = meeting.startTime.subtract(
// //       Duration(minutes: meeting.reminderMinutes),
// //     );

// //     if (reminderTime.isBefore(DateTime.now())) return;

// //     await _notificationService.scheduleNotification(
// //       id: meeting.id!,
// //       title: 'Upcoming Meeting: ${meeting.title}',
// //       body: 'Starts at ${TimeOfDay.fromDateTime(meeting.startTime).format(Get.context!)}',
// //       scheduledTime: reminderTime,
// //     );
// //   }

// //   Future<void> _scheduleAllReminders() async {
// //     for (final meeting in meetings) {
// //       await _scheduleReminder(meeting);
// //     }
// //   }

// //   List<Meeting> getMeetingsForDate(DateTime date) {
// //     return meetings.where((meeting) {
// //       return meeting.startTime.year == date.year &&
// //           meeting.startTime.month == date.month &&
// //           meeting.startTime.day == date.day;
// //     }).toList();
// //   }

// //   List<Meeting> getUpcomingMeetings() {
// //     final now = DateTime.now();
// //     return meetings
// //         .where((meeting) => meeting.startTime.isAfter(now))
// //         .toList()
// //         .sublist(0, meetings.length > 3 ? 3 : meetings.length);
// //   }

// //   List<Meeting> getTodayMeetings() {
// //     final now = DateTime.now();
// //     return getMeetingsForDate(now);
// //   }

// //   @override
// //   void onClose() {
// //     _databaseHelper.close();
// //     super.onClose();
// //   }
// // }

// import 'package:doc_scanner/database_helper.dart';
// import 'package:doc_scanner/meeting.dart';
// import 'package:doc_scanner/notification_service.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest.dart' as tz;

// class MeetingController extends GetxController {
//   final DatabaseHelper _databaseHelper = DatabaseHelper();
//   final RxList<Meeting> meetings = <Meeting>[].obs;
//   final Rx<DateTime> selectedDate = DateTime.now().obs;
//   final RxBool isLoading = false.obs;
//   final RxnString error = RxnString();
//   final NotificationService _notificationService = NotificationService();

//   @override
//   void onInit() {
//     super.onInit();
//     _initializeTimeZones();
//     _initializeNotifications();
//     loadMeetings();
//   }

//   Future<void> _initializeTimeZones() async {
//     tz.initializeTimeZones();
//     final location = tz.getLocation('America/New_York');
//     tz.setLocalLocation(location);
//   }

//   Future<void> _initializeNotifications() async {
//     await _notificationService.initialize();
//   }

//   Future<void> loadMeetings() async {
//     try {
//       isLoading(true);
//       error(null);
//       final loadedMeetings = await _databaseHelper.getAllMeetings();
//       meetings.assignAll(loadedMeetings);
//       await _scheduleAllReminders();
//     } catch (e) {
//       error(e.toString());
//       Get.snackbar(
//         'Error',
//         'Failed to load meetings: ${e.toString()}',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } finally {
//       isLoading(false);
//     }
//   }

//   Future<void> addMeeting(Meeting meeting) async {
//     try {
//       isLoading(true);
//       final id = await _databaseHelper.insertMeeting(meeting);
//       final newMeeting = meeting.copyWith(id: id);
//       meetings.add(newMeeting);
//       await _scheduleReminder(newMeeting);
//     } catch (e) {
//       error(e.toString());
//       rethrow;
//     } finally {
//       isLoading(false);
//     }
//   }

//   Future<void> updateMeeting(Meeting meeting) async {
//     try {
//       isLoading(true);
//       await _databaseHelper.updateMeeting(meeting);
//       final index = meetings.indexWhere((m) => m.id == meeting.id);
//       if (index != -1) {
//         meetings[index] = meeting;
//       }
//       await _scheduleReminder(meeting);
//     } catch (e) {
//       error(e.toString());
//       rethrow;
//     } finally {
//       isLoading(false);
//     }
//   }

//   Future<void> deleteMeeting(int id) async {
//     try {
//       isLoading(true);
//       await _databaseHelper.deleteMeeting(id);
//       meetings.removeWhere((meeting) => meeting.id == id);
//       await _notificationService.cancelNotification(id);
//     } catch (e) {
//       error(e.toString());
//       rethrow;
//     } finally {
//       isLoading(false);
//     }
//   }

//   Future<void> toggleMeetingCompletion(int id) async {
//     try {
//       isLoading(true);
//       final meeting = meetings.firstWhere((m) => m.id == id);
//       final updatedMeeting = meeting.copyWith(isCompleted: !meeting.isCompleted);
//       await updateMeeting(updatedMeeting);
//     } catch (e) {
//       error(e.toString());
//       rethrow;
//     } finally {
//       isLoading(false);
//     }
//   }

//   Future<void> _scheduleReminder(Meeting meeting) async {
//     if (meeting.reminderMinutes <= 0 || meeting.id == null) return;

//     await _notificationService.cancelNotification(meeting.id!);

//     final reminderTime = meeting.startTime.subtract(
//       Duration(minutes: meeting.reminderMinutes),
//     );

//     if (reminderTime.isBefore(DateTime.now())) return;

//     await _notificationService.scheduleNotification(
//       id: meeting.id!,
//       title: 'Upcoming Meeting: ${meeting.title}',
//       body: 'Starts at ${TimeOfDay.fromDateTime(meeting.startTime).format(Get.context!)}',
//       scheduledTime: reminderTime,
//     );
//   }

//   Future<void> _scheduleAllReminders() async {
//     for (final meeting in meetings) {
//       await _scheduleReminder(meeting);
//     }
//   }

//   List<Meeting> getMeetingsForDate(DateTime date) {
//     return meetings.where((meeting) {
//       return meeting.startTime.year == date.year &&
//           meeting.startTime.month == date.month &&
//           meeting.startTime.day == date.day;
//     }).toList();
//   }

//   List<Meeting> getUpcomingMeetings() {
//     final now = DateTime.now();
//     final upcoming = meetings
//         .where((meeting) => meeting.startTime.isAfter(now))
//         .toList();
//     return upcoming.length > 3 ? upcoming.sublist(0, 3) : upcoming;
//   }

//   List<Meeting> getTodayMeetings() {
//     final now = DateTime.now();
//     return getMeetingsForDate(now);
//   }

//   @override
//   void onClose() {
//     _databaseHelper.close();
//     super.onClose();
//   }
// }

import 'package:meeting_schedule/meeting/database_helper.dart';
import 'package:meeting_schedule/meeting/meeting.dart';
import 'package:meeting_schedule/meeting/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class MeetingController extends GetxController {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final RxList<Meeting> meetings = <Meeting>[].obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final RxBool isLoading = false.obs;
  final RxnString error = RxnString();
  final NotificationService _notificationService = NotificationService();

  @override
  void onInit() {
    super.onInit();
    _initializeTimeZones();
    _initializeAndLoadMeetings();
  }

  Future<void> _initializeTimeZones() async {
    tz.initializeTimeZones();
    final location = tz.getLocation('America/New_York');
    tz.setLocalLocation(location);
  }

  Future<void> _initializeAndLoadMeetings() async {
    final initialized = await _notificationService.initialize();
    if (initialized) {
      await loadMeetings();
    } else {
      error('Notification service initialization failed');
      Get.snackbar(
        'Error',
        'Failed to initialize notifications. Reminders may not work.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> loadMeetings() async {
    try {
      isLoading(true);
      error(null);
      final loadedMeetings = await _databaseHelper.getAllMeetings();
      meetings.assignAll(loadedMeetings);
      await _scheduleAllReminders();
    } catch (e) {
      error(e.toString());
      Get.snackbar(
        'Error',
        'Failed to load meetings: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> addMeeting(Meeting meeting) async {
    try {
      isLoading(true);
      final id = await _databaseHelper.insertMeeting(meeting);
      final newMeeting = meeting.copyWith(id: id);
      meetings.add(newMeeting);
      await _scheduleReminder(newMeeting);
    } catch (e) {
      error(e.toString());
      rethrow;
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateMeeting(Meeting meeting) async {
    try {
      isLoading(true);
      await _databaseHelper.updateMeeting(meeting);
      final index = meetings.indexWhere((m) => m.id == meeting.id);
      if (index != -1) {
        meetings[index] = meeting;
      }
      await _scheduleReminder(meeting);
    } catch (e) {
      error(e.toString());
      rethrow;
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteMeeting(int id) async {
    try {
      isLoading(true);
      await _databaseHelper.deleteMeeting(id);
      meetings.removeWhere((meeting) => meeting.id == id);
      await _notificationService.cancelNotification(id);
    } catch (e) {
      error(e.toString());
      rethrow;
    } finally {
      isLoading(false);
    }
  }

  Future<void> toggleMeetingCompletion(int id) async {
    try {
      isLoading(true);
      final meeting = meetings.firstWhere((m) => m.id == id);
      final updatedMeeting = meeting.copyWith(isCompleted: !meeting.isCompleted);
      await updateMeeting(updatedMeeting);
    } catch (e) {
      error(e.toString());
      rethrow;
    } finally {
      isLoading(false);
    }
  }

  Future<void> _scheduleReminder(Meeting meeting) async {
    if (meeting.reminderMinutes <= 0 || meeting.id == null) {
      print('Skipping reminder for meeting ${meeting.id}: no reminder set or no ID');
      return;
    }

    final reminderTime = meeting.startTime.subtract(
      Duration(minutes: meeting.reminderMinutes),
    );

    final success = await _notificationService.scheduleNotification(
      id: meeting.id!,
      title: 'Upcoming Meeting: ${meeting.title}',
      body:
          'Starts at ${TimeOfDay.fromDateTime(meeting.startTime).format(Get.context!)}',
      scheduledTime: reminderTime,
    );

    if (!success) {
      print('Failed to schedule reminder for meeting ${meeting.id}');
    }
  }

  Future<void> _scheduleAllReminders() async {
    for (final meeting in meetings) {
      await _scheduleReminder(meeting);
    }
  }

  List<Meeting> getMeetingsForDate(DateTime date) {
    return meetings.where((meeting) {
      return meeting.startTime.year == date.year &&
          meeting.startTime.month == date.month &&
          meeting.startTime.day == date.day;
    }).toList();
  }

  List<Meeting> getUpcomingMeetings() {
    final now = DateTime.now();
    final upcoming = meetings
        .where((meeting) => meeting.startTime.isAfter(now))
        .toList();
    return upcoming.length > 3 ? upcoming.sublist(0, 3) : upcoming;
  }

  List<Meeting> getTodayMeetings() {
    final now = DateTime.now();
    return getMeetingsForDate(now);
  }

  @override
  void onClose() {
    _databaseHelper.close();
    super.onClose();
  }
}