// import 'package:flutter/material.dart';
// import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

// class TimePickerField extends StatelessWidget {
//   final String labelText;
//   final TimeOfDay initialTime;
//   final ValueChanged<TimeOfDay> onTimeSelected;
//   final bool enabled;

//   const TimePickerField({
//     required this.labelText,
//     required this.initialTime,
//     required this.onTimeSelected,
//     this.enabled = true,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: enabled
//           ? () {
//               DatePicker.showTimePicker(
//                 context,
//                 showTitleActions: true,
//                 onConfirm: (time) {
//                   onTimeSelected(TimeOfDay.fromDateTime(time));
//                 },
//                 currentTime: DateTime(
//                   DateTime.now().year,
//                   DateTime.now().month,
//                   DateTime.now().day,
//                   initialTime.hour,
//                   initialTime.minute,
//                 ),
//               );
//             }
//           : null,
//       child: InputDecorator(
//         decoration: InputDecoration(
//           labelText: labelText,
//           border: OutlineInputBorder(),
//           enabled: enabled,
//         ),
//         child: Text(
//           initialTime.format(context),
//           style: enabled
//               ? null
//               : TextStyle(color: Theme.of(context).disabledColor),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class TimePickerField extends StatelessWidget {
  final String labelText;
  final TimeOfDay initialTime;
  final ValueChanged<TimeOfDay> onTimeSelected;
  final bool enabled;

  const TimePickerField({
    required this.labelText,
    required this.initialTime,
    required this.onTimeSelected,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled
          ? () {
              DatePicker.showTimePicker(
                context,
                showTitleActions: true,
                onConfirm: (time) {
                  onTimeSelected(TimeOfDay.fromDateTime(time));
                },
                currentTime: DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                  initialTime.hour,
                  initialTime.minute,
                ),
              );
            }
          : null,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
          enabled: enabled,
        ),
        child: Text(
          initialTime.format(context),
          style: enabled
              ? null
              : TextStyle(color: Theme.of(context).disabledColor),
        ),
      ),
    );
  }
}