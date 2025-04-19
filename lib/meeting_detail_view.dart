// 

import 'package:doc_scanner/add_meeting_view.dart';
import 'package:doc_scanner/meeting.dart';
import 'package:doc_scanner/meeting_controller.dart';
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
      appBar: AppBar(
        title: Text('Meeting Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => Get.to(
              () => AddMeetingView(existingMeeting: meeting),
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              Get.defaultDialog(
                title: 'Delete Meeting',
                content: Text('Are you sure you want to delete this meeting?'),
                confirm: ElevatedButton(
                  onPressed: () {
                    _meetingController.deleteMeeting(meeting.id!);
                    Get.back();
                    Get.back();
                  },
                  child: Text('Delete'),
                ),
                cancel: TextButton(
                  onPressed: () => Get.back(),
                  child: Text('Cancel'),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 8,
              width: double.infinity,
              color: meeting.color,
            ),
            SizedBox(height: 16),
            Text(
              meeting.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 8),
            if (meeting.description != null && meeting.description!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meeting.description!,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(height: 16),
                ],
              ),
            _buildDetailRow(Icons.calendar_today,
                '${DateFormat.yMMMd().format(meeting.startTime)}'),
            _buildDetailRow(Icons.access_time,
                '${DateFormat.jm().format(meeting.startTime)} - ${DateFormat.jm().format(meeting.endTime)}'),
            if (meeting.location != null && meeting.location!.isNotEmpty)
              _buildDetailRow(Icons.location_on, meeting.location!),
            if (meeting.participants.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Text(
                    'Participants',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: meeting.participants
                        .map((participant) => Chip(
                              label: Text(participant),
                            ))
                        .toList(),
                  ),
                ],
              ),
            SizedBox(height: 24),
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
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}