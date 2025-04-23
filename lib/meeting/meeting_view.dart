import 'package:meeting_schedule/meeting/add_meeting_view.dart';
import 'package:meeting_schedule/meeting/calendar_view.dart';
import 'package:meeting_schedule/const/const_color.dart';
import 'package:meeting_schedule/meeting/meeting_card.dart';
import 'package:meeting_schedule/meeting/meeting_controller.dart';
import 'package:meeting_schedule/meeting/meeting_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MeetingView extends StatelessWidget {
  final MeetingController _meetingController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColor.scaffoldBG,
      appBar: AppBar(
        backgroundColor: ConstColor.appBarBG,
        title: const Text(
          'Smart Meeting Scheduler',
          style: TextStyle(
            color: Color(0xffF47D4E),
            fontFamily: "Poppins",
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
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
              const Text(
                'Today\'s Meetings',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Poppins",
                  fontSize: 15.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              if (todayMeetings.isEmpty)
                const Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'No meetings scheduled for today',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Poppins",
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              else
                ...todayMeetings.map((meeting) => MeetingCard(
                      meeting: meeting,
                      onTap: () => Get.to(
                        () => MeetingDetailView(meeting: meeting),
                      ),
                    )),
              const SizedBox(height: 24),
              const Text(
                'Upcoming Meetings',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Poppins",
                  fontSize: 15.0,
                  fontWeight: FontWeight.w400,
                ), 
              ),
              const SizedBox(height: 8),
              if (upcomingMeetings.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'No upcoming meetings',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Poppins",
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                    ),
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
