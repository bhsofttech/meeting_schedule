// import 'package:doc_scanner/meeting.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class MeetingCard extends StatelessWidget {
//   final Meeting meeting;
//   final VoidCallback onTap;

//   const MeetingCard({
//     required this.meeting,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.only(bottom: 12),
//       child: InkWell(
//         onTap: onTap,
//         child: Padding(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Container(
//                     width: 12,
//                     height: 12,
//                     decoration: BoxDecoration(
//                       color: meeting.color,
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//                   SizedBox(width: 8),
//                   Expanded(
//                     child: Text(
//                       meeting.title,
//                       style: Theme.of(context).textTheme.bodyMedium,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   if (meeting.isCompleted)
//                     Icon(Icons.check_circle, color: Colors.green),
//                 ],
//               ),
//               SizedBox(height: 8),
//               Row(
//                 children: [
//                   Icon(Icons.access_time, size: 16),
//                   SizedBox(width: 8),
//                   Text(
//                     '${DateFormat.jm().format(meeting.startTime)} - ${DateFormat.jm().format(meeting.endTime)}',
//                     style: Theme.of(context).textTheme.bodyMedium,
//                   ),
//                 ],
//               ),
//               if (meeting.location != null && meeting.location!.isNotEmpty)
//                 Padding(
//                   padding: EdgeInsets.only(top: 8),
//                   child: Row(
//                     children: [
//                       Icon(Icons.location_on, size: 16),
//                       SizedBox(width: 8),
//                       Text(
//                         meeting.location!,
//                         style: Theme.of(context).textTheme.bodyMedium,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ],
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:doc_scanner/meeting.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MeetingCard extends StatelessWidget {
  final Meeting meeting;
  final VoidCallback onTap;

  const MeetingCard({
    required this.meeting,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: meeting.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      meeting.title,
                      style: Theme.of(context).textTheme.bodyLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (meeting.isCompleted)
                    Icon(Icons.check_circle, color: Colors.green),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time, size: 16),
                  SizedBox(width: 8),
                  Text(
                    '${DateFormat.jm().format(meeting.startTime)} - ${DateFormat.jm().format(meeting.endTime)}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              if (meeting.location != null && meeting.location!.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Icon(Icons.location_on, size: 16),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          meeting.location!,
                          style: Theme.of(context).textTheme.bodyLarge,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}