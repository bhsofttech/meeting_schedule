// // import 'package:flutter/material.dart';

// // class Meeting {
// //   int? id;
// //   String title;
// //   String? description;
// //   DateTime startTime;
// //   DateTime endTime;
// //   List<String> participants;
// //   String? location;
// //   bool isAllDay;
// //   Color color;
// //   bool isCompleted;
// //   int reminderMinutes;

// //   Meeting({
// //     this.id,
// //     required this.title,
// //     this.description,
// //     required this.startTime,
// //     required this.endTime,
// //     this.participants = const [],
// //     this.location,
// //     this.isAllDay = false,
// //     this.color = Colors.blue,
// //     this.isCompleted = false,
// //     this.reminderMinutes = 0,
// //   });

// //   Map<String, dynamic> toMap() {
// //     return {
// //       'id': id,
// //       'title': title,
// //       'description': description,
// //       'startTime': startTime.toIso8601String(),
// //       'endTime': endTime.toIso8601String(),
// //       'participants': participants.join(','),
// //       'location': location,
// //       'isAllDay': isAllDay ? 1 : 0,
// //       'color': color.value,
// //       'isCompleted': isCompleted ? 1 : 0,
// //       'reminderMinutes': reminderMinutes,
// //     };
// //   }

// //   factory Meeting.fromMap(Map<String, dynamic> map) {
// //     return Meeting(
// //       id: map['id'],
// //       title: map['title'],
// //       description: map['description'],
// //       startTime: DateTime.parse(map['startTime']),
// //       endTime: DateTime.parse(map['endTime']),
// //       participants: map['participants']?.toString().split(',') ?? [],
// //       location: map['location'],
// //       isAllDay: map['isAllDay'] == 1,
// //       color: Color(map['color'] ?? Colors.blue.value),
// //       isCompleted: map['isCompleted'] == 1,
// //       reminderMinutes: map['reminderMinutes'] ?? 0,
// //     );
// //   }

// //   Meeting copyWith({
// //     int? id,
// //     String? title,
// //     String? description,
// //     DateTime? startTime,
// //     DateTime? endTime,
// //     List<String>? participants,
// //     String? location,
// //     bool? isAllDay,
// //     Color? color,
// //     bool? isCompleted,
// //     int? reminderMinutes,
// //   }) {
// //     return Meeting(
// //       id: id ?? this.id,
// //       title: title ?? this.title,
// //       description: description ?? this.description,
// //       startTime: startTime ?? this.startTime,
// //       endTime: endTime ?? this.endTime,
// //       participants: participants ?? this.participants,
// //       location: location ?? this.location,
// //       isAllDay: isAllDay ?? this.isAllDay,
// //       color: color ?? this.color,
// //       isCompleted: isCompleted ?? this.isCompleted,
// //       reminderMinutes: reminderMinutes ?? this.reminderMinutes,
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class Meeting {
//   final int? id;
//   final String title;
//   final String? description;
//   final DateTime startTime;
//   final DateTime endTime;
//   final List<String> participants;
//   final String? location;
//   final bool isAllDay;
//   final Color color;
//   final bool isCompleted;
//   final int reminderMinutes;

//   Meeting({
//     this.id,
//     required this.title,
//     this.description,
//     required this.startTime,
//     required this.endTime,
//     List<String>? participants,
//     this.location,
//     this.isAllDay = false,
//     Color? color,
//     this.isCompleted = false,
//     this.reminderMinutes = 0,
//   }) : 
//     participants = participants ?? [],
//     color = color ?? Colors.blue,
//     assert(startTime.isBefore(endTime), 'Start time must be before end time');

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'title': title,
//       'description': description,
//       'startTime': startTime.toUtc().toIso8601String(),
//       'endTime': endTime.toUtc().toIso8601String(),
//       'participants': participants.join(','),
//       'location': location,
//       'isAllDay': isAllDay ? 1 : 0,
//       'color': color.value,
//       'isCompleted': isCompleted ? 1 : 0,
//       'reminderMinutes': reminderMinutes,
//     };
//   }

//   factory Meeting.fromMap(Map<String, dynamic> map) {
//     return Meeting(
//       id: map['id'] as int?,
//       title: map['title'] as String,
//       description: map['description'] as String?,
//       startTime: DateTime.parse(map['startTime'] as String).toLocal(),
//       endTime: DateTime.parse(map['endTime'] as String).toLocal(),
//       participants: (map['participants'] as String?)?.split(',') ?? [],
//       location: map['location'] as String?,
//       isAllDay: (map['isAllDay'] as int?) == 1,
//       color: Color(map['color'] as int? ?? Colors.blue.value),
//       isCompleted: (map['isCompleted'] as int?) == 1,
//       reminderMinutes: map['reminderMinutes'] as int? ?? 0,
//     );
//   }

//   Meeting copyWith({
//     int? id,
//     String? title,
//     String? description,
//     DateTime? startTime,
//     DateTime? endTime,
//     List<String>? participants,
//     String? location,
//     bool? isAllDay,
//     Color? color,
//     bool? isCompleted,
//     int? reminderMinutes,
//   }) {
//     return Meeting(
//       id: id ?? this.id,
//       title: title ?? this.title,
//       description: description ?? this.description,
//       startTime: startTime ?? this.startTime,
//       endTime: endTime ?? this.endTime,
//       participants: participants ?? this.participants,
//       location: location ?? this.location,
//       isAllDay: isAllDay ?? this.isAllDay,
//       color: color ?? this.color,
//       isCompleted: isCompleted ?? this.isCompleted,
//       reminderMinutes: reminderMinutes ?? this.reminderMinutes,
//     );
//   }

//   String get formattedDate => DateFormat.yMMMd().format(startTime);
//   String get formattedTimeRange => '${DateFormat.jm().format(startTime)} - ${DateFormat.jm().format(endTime)}';
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Meeting {
  final int? id;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime endTime;
  final List<String> participants;
  final String? location;
  final bool isAllDay;
  final Color color;
  final bool isCompleted;
  final int reminderMinutes;

  Meeting({
    this.id,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    List<String>? participants,
    this.location,
    this.isAllDay = false,
    Color? color,
    this.isCompleted = false,
    this.reminderMinutes = 0,
  }) : 
    participants = participants ?? [],
    color = color ?? Colors.blue,
    assert(startTime.isBefore(endTime), 'Start time must be before end time');

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startTime': startTime.toUtc().toIso8601String(),
      'endTime': endTime.toUtc().toIso8601String(),
      'participants': participants.join(','),
      'location': location,
      'isAllDay': isAllDay ? 1 : 0,
      'color': color.value,
      'isCompleted': isCompleted ? 1 : 0,
      'reminderMinutes': reminderMinutes,
    };
  }

  factory Meeting.fromMap(Map<String, dynamic> map) {
    return Meeting(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String?,
      startTime: DateTime.parse(map['startTime'] as String).toLocal(),
      endTime: DateTime.parse(map['endTime'] as String).toLocal(),
      participants: (map['participants'] as String?)?.split(',') ?? [],
      location: map['location'] as String?,
      isAllDay: (map['isAllDay'] as int?) == 1,
      color: Color(map['color'] as int? ?? Colors.blue.value),
      isCompleted: (map['isCompleted'] as int?) == 1,
      reminderMinutes: map['reminderMinutes'] as int? ?? 0,
    );
  }

  Meeting copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    List<String>? participants,
    String? location,
    bool? isAllDay,
    Color? color,
    bool? isCompleted,
    int? reminderMinutes,
  }) {
    return Meeting(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      participants: participants ?? this.participants,
      location: location ?? this.location,
      isAllDay: isAllDay ?? this.isAllDay,
      color: color ?? this.color,
      isCompleted: isCompleted ?? this.isCompleted,
      reminderMinutes: reminderMinutes ?? this.reminderMinutes,
    );
  }

  String get formattedDate => DateFormat.yMMMd().format(startTime);
  String get formattedTimeRange => '${DateFormat.jm().format(startTime)} - ${DateFormat.jm().format(endTime)}';
}