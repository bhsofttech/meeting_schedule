//

import 'package:meeting_schedule/const/const_color.dart';
import 'package:meeting_schedule/meeting/add_meeting_view.dart';
import 'package:meeting_schedule/meeting/meeting.dart';
import 'package:meeting_schedule/meeting/meeting_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MeetingDetailView extends StatelessWidget {
  final Meeting meeting;

  MeetingDetailView({required this.meeting});

  final MeetingController _meetingController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColor.scaffoldBG,
      appBar: AppBar(
        backgroundColor: ConstColor.appBarBG,
        title: const Text(
          'Meeting Details',
          style: TextStyle(
            color: Color(0xffF47D4E),
            fontFamily: "Poppins",
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Get.to(
              () => AddMeetingView(existingMeeting: meeting),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              Get.defaultDialog(
                title: 'Delete Meeting',
                titleStyle: const TextStyle(
                  color: Colors.black,
                  fontFamily: "Poppins",
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),
                content: const Text(
                  'Are you sure you want to delete this meeting?',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Poppins",
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                confirm: ElevatedButton(
                  onPressed: () {
                    _meetingController.deleteMeeting(meeting.id!);
                    Get.back();
                    Get.back();
                  },
                  child: const Text(
                    'Delete',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Poppins",
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                cancel: TextButton(
                  onPressed: () => Get.back(),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Poppins",
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 8,
              width: double.infinity,
              color: meeting.color,
            ),
            const SizedBox(height: 16),
            Text(
              meeting.title,
              style: const TextStyle(
                color: Colors.black,
                fontFamily: "Poppins",
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            if (meeting.description != null && meeting.description!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meeting.description!,
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: "Poppins",
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            _buildDetailRow(Icons.calendar_today,
                DateFormat.yMMMd().format(meeting.startTime)),
            _buildDetailRow(Icons.access_time,
                '${DateFormat.jm().format(meeting.startTime)} - ${DateFormat.jm().format(meeting.endTime)}'),
            if (meeting.location != null && meeting.location!.isNotEmpty)
              _buildDetailRow(Icons.location_on, meeting.location!),
            if (meeting.participants.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'Participants',
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: "Poppins",
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Wrap(
                    spacing: 8,
                    children: meeting.participants
                        .map(
                          (participant) => Chip(
                            label: Text(participant),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            const SizedBox(height: 24),
            Obx(() {
              final isCompleted = _meetingController.meetings
                  .firstWhere((m) => m.id == meeting.id)
                  .isCompleted;

              return ElevatedButton(
                onPressed: () =>
                    _meetingController.toggleMeetingCompletion(meeting.id!),
                child: Text(
                    isCompleted ? 'Mark as Incomplete' : 'Mark as Complete'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: isCompleted ? Colors.green : null,
                  minimumSize: Size(double.infinity, 50),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.black.withOpacity(0.6),
                fontFamily: "Poppins",
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
