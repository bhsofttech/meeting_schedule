import 'package:meeting_schedule/add_meeting_view.dart';
import 'package:meeting_schedule/calendar_view.dart';
import 'package:meeting_schedule/meeting_card.dart';
import 'package:meeting_schedule/meeting_controller.dart';
import 'package:meeting_schedule/meeting_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MeetingView extends StatelessWidget {
  final MeetingController _meetingController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Meeting Scheduler'),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () => Get.to(() => CalendarView()),
          ),
        ],
      ),
      body: Obx(() {
        final todayMeetings = _meetingController.getTodayMeetings();
        final upcomingMeetings = _meetingController.getUpcomingMeetings();

        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Today\'s Meetings',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 8),
              if (todayMeetings.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'No meetings scheduled for today',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                )
              else
                ...todayMeetings.map((meeting) => MeetingCard(
                      meeting: meeting,
                      onTap: () => Get.to(
                        () => MeetingDetailView(meeting: meeting),
                      ),
                    )),
              SizedBox(height: 24),
              Text(
                'Upcoming Meetings',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 8),
              if (upcomingMeetings.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'No upcoming meetings',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                )
              else
                ...upcomingMeetings.map((meeting) => MeetingCard(
                      meeting: meeting,
                      onTap: () => Get.to(
                        () => MeetingDetailView(meeting: meeting),
                      ),
                    )),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Get.to(() => AddMeetingView()),
      ),
    );
  }
}
