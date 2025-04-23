import 'package:meeting_schedule/const/const_color.dart';
import 'package:meeting_schedule/meeting/meeting.dart';
import 'package:meeting_schedule/meeting/meeting_controller.dart';
import 'package:meeting_schedule/meeting/time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddMeetingView extends StatefulWidget {
  final Meeting? existingMeeting;

  const AddMeetingView({Key? key, this.existingMeeting}) : super(key: key);

  @override
  _AddMeetingViewState createState() => _AddMeetingViewState();
}

class _AddMeetingViewState extends State<AddMeetingView> {
  final MeetingController _meetingController = Get.find();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late TextEditingController _participantsController;

  late DateTime _selectedDate;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late bool _isAllDay;
  late int _reminderMinutes;
  late Color _selectedColor;

  final List<int> _reminderOptions = [0, 5, 10, 15, 30, 60];
  final List<Color> _colorOptions = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
  ];

  @override
  void initState() {
    super.initState();
    final meeting = widget.existingMeeting;

    _titleController = TextEditingController(text: meeting?.title ?? '');
    _descriptionController =
        TextEditingController(text: meeting?.description ?? '');
    _locationController = TextEditingController(text: meeting?.location ?? '');
    _participantsController =
        TextEditingController(text: meeting?.participants.join(', ') ?? '');

    _selectedDate = meeting?.startTime ?? DateTime.now();
    _startTime = TimeOfDay.fromDateTime(meeting?.startTime ?? DateTime.now());
    _endTime = TimeOfDay.fromDateTime(
        meeting?.endTime ?? DateTime.now().add(Duration(hours: 1)));
    _isAllDay = meeting?.isAllDay ?? false;
    _reminderMinutes = meeting?.reminderMinutes ?? 0;

    // Normalize _selectedColor to ensure it matches a color in _colorOptions
    if (meeting?.color != null) {
      _selectedColor = _colorOptions.firstWhere(
        (color) => color.value == meeting!.color.value,
        orElse: () => Colors.blue,
      );
    } else {
      _selectedColor = Colors.blue;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _participantsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveMeeting() {
    if (!_formKey.currentState!.validate()) return;

    final startDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _isAllDay ? 0 : _startTime.hour,
      _isAllDay ? 0 : _startTime.minute,
    );

    final endDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _isAllDay ? 23 : _endTime.hour,
      _isAllDay ? 59 : _endTime.minute,
    );

    if (endDateTime.isBefore(startDateTime)) {
      Get.snackbar(
        'Error',
        'End time cannot be before start time',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final participants = _participantsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final meeting = Meeting(
      id: widget.existingMeeting?.id,
      title: _titleController.text,
      description: _descriptionController.text.isEmpty
          ? null
          : _descriptionController.text,
      startTime: startDateTime,
      endTime: endDateTime,
      participants: participants,
      location:
          _locationController.text.isEmpty ? null : _locationController.text,
      isAllDay: _isAllDay,
      color: _selectedColor,
      reminderMinutes: _reminderMinutes,
    );

    if (widget.existingMeeting != null) {
      _meetingController.updateMeeting(meeting).then((_) {
        Get.close(2);
      }).catchError((error) {
        Get.snackbar(
          'Error',
          'Failed to update meeting: $error',
          snackPosition: SnackPosition.BOTTOM,
        );
      });
    } else {
      _meetingController.addMeeting(meeting).then((_) {
        Get.back();
      }).catchError((error) {
        Get.snackbar(
          'Error',
          'Failed to add meeting: $error',
          snackPosition: SnackPosition.BOTTOM,
        );
      });
    }
  }

  Widget _buildColorPicker() {
    return InputDecorator(
      decoration: const InputDecoration(
        labelText: 'Color',
        border: OutlineInputBorder(),
      ),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: _colorOptions.map((color) {
          final isSelected = color == _selectedColor;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedColor = color;
              });
            },
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.black : Colors.grey,
                  width: isSelected ? 3 : 1,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColor.scaffoldBG,
      appBar: AppBar(
        backgroundColor: ConstColor.appBarBG,
        title: Text(
          widget.existingMeeting != null ? 'Edit Meeting' : 'Add New Meeting',
          style: const TextStyle(
            color: Color(0xffF47D4E),
            fontFamily: "Poppins",
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title*',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(context),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Date*',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          DateFormat.yMMMd().format(_selectedDate),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TimePickerField(
                      labelText: 'Start Time*',
                      initialTime: _startTime,
                      onTimeSelected: (time) =>
                          setState(() => _startTime = time),
                      enabled: !_isAllDay,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TimePickerField(
                      labelText: 'End Time*',
                      initialTime: _endTime,
                      onTimeSelected: (time) => setState(() => _endTime = time),
                      enabled: !_isAllDay,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: CheckboxListTile(
                      title: Text('All Day'),
                      value: _isAllDay,
                      onChanged: (value) =>
                          setState(() => _isAllDay = value ?? false),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _participantsController,
                decoration: InputDecoration(
                  labelText: 'Participants (comma separated)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              // DropdownButtonFormField<int>(
              //   value: _reminderMinutes,
              //   decoration: InputDecoration(
              //     labelText: 'Reminder',
              //     border: OutlineInputBorder(),
              //   ),
              //   items: _reminderOptions.map((minutes) {
              //     return DropdownMenuItem<int>(
              //       value: minutes,
              //       child: Text(
              //         minutes == 0
              //           ? 'No reminder'
              //           : '$minutes minutes before',
              //       ),
              //     );
              //   }).toList(),
              //   onChanged: (value) => setState(() => _reminderMinutes = value ?? 0),
              // ),
              // SizedBox(height: 16),
              _buildColorPicker(),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveMeeting,
                child: Text(widget.existingMeeting != null
                    ? 'Update Meeting'
                    : 'Save Meeting'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
