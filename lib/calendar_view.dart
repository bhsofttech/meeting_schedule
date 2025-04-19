// import 'package:meeting_schedule/meeting_controller.dart';
// import 'package:doc_scanner/meeting_detail_view.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import 'package:table_calendar/table_calendar.dart';
// import 'package:intl/intl.dart';

// class CalendarView extends StatelessWidget {
//   final MeetingController _meetingController = Get.find();
//   final CalendarFormat _calendarFormat = CalendarFormat.month;
//   final DateTime _focusedDay = DateTime.now();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Calendar'),
//       ),
//       body: Column(
//         children: [
//         TableCalendar(
//               firstDay: DateTime.now(),
//               lastDay: DateTime(DateTime.now().year + 5),
//               focusedDay: _focusedDay,
//               calendarFormat: _calendarFormat,
//               eventLoader: (day) => _meetingController.getMeetingsForDate(day),
//               calendarStyle: CalendarStyle(
//                 markerDecoration: BoxDecoration(
//                   color: Colors.blue,
//                   shape: BoxShape.circle,
//                 ),
//                 todayDecoration: BoxDecoration(
//                   color: Colors.blue.withOpacity(0.3),
//                   shape: BoxShape.circle,
//                 ),
//                 selectedDecoration: BoxDecoration(
//                   color: Colors.blue,
//                   shape: BoxShape.circle,
//                 ),
//               ),
//               headerStyle: HeaderStyle(
//                 formatButtonVisible: false,
//                 titleCentered: true,
//               ),
//               onDaySelected: (selectedDay, focusedDay) {
//                 final meetings = _meetingController.getMeetingsForDate(selectedDay);
//                 if (meetings.isNotEmpty) {
//                   Get.bottomSheet(
//                     Container(
//                       padding: EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Theme.of(context).scaffoldBackgroundColor,
//                         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//                       ),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text(
//                             'Meetings on ${DateFormat.yMMMd().format(selectedDay)}',
//                             style: Theme.of(context).textTheme.bodyMedium,
//                           ),
//                           SizedBox(height: 16),
//                           ...meetings.map((meeting) => ListTile(
//                                 leading: Container(
//                                   width: 12,
//                                   height: 12,
//                                   decoration: BoxDecoration(
//                                     color: meeting.color,
//                                     shape: BoxShape.circle,
//                                   ),
//                                 ),
//                                 title: Text(meeting.title),
//                                 subtitle: Text(
//                                   '${DateFormat.jm().format(meeting.startTime)} - ${DateFormat.jm().format(meeting.endTime)}',
//                                 ),
//                                 onTap: () {
//                                   Get.back();
//                                   Get.to(() => MeetingDetailView(meeting: meeting));
//                                 },
//                               )),
//                         ],
//                       ),
//                     ),
//                   );
//                 }
//               },
//             )
//         ],
//       ),
//     );
//   }
// }

import 'package:meeting_schedule/meeting_controller.dart';
import 'package:meeting_schedule/meeting_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CalendarView extends StatefulWidget {
  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  final MeetingController _meetingController = Get.find();
  late CalendarFormat _calendarFormat = CalendarFormat.month;
  late DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.now(),
            lastDay: DateTime(DateTime.now().year + 5),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            eventLoader: (day) => _meetingController.getMeetingsForDate(day),
            calendarStyle: CalendarStyle(
              markerDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: true,
              titleCentered: true,
            ),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              final meetings = _meetingController.getMeetingsForDate(selectedDay);
              if (meetings.isNotEmpty) {
                Get.bottomSheet(
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Meetings on ${DateFormat.yMMMd().format(selectedDay)}',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        SizedBox(height: 16),
                        Flexible(
                          child: ListView(
                            shrinkWrap: true,
                            children: meetings.map((meeting) => ListTile(
                              leading: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: meeting.color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              title: Text(meeting.title),
                              subtitle: Text(
                                '${DateFormat.jm().format(meeting.startTime)} - ${DateFormat.jm().format(meeting.endTime)}',
                              ),
                              onTap: () {
                                Get.back();
                                Get.to(() => MeetingDetailView(meeting: meeting));
                              },
                            )).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
        ],
      ),
    );
  }
}