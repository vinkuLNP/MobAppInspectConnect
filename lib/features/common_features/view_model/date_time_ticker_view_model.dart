import 'package:flutter/material.dart';

class DateTimePickerProvider extends ChangeNotifier {
  DateTime tempDate;
  TimeOfDay tempTime;
  String? errorMessage;
  final bool showTimePicker;
  final DateTime now;

  DateTimePickerProvider({required this.now, this.showTimePicker = true})
    : tempDate = now,
      tempTime = TimeOfDay.fromDateTime(now);

  void setDate(DateTime date) {
    tempDate = date;
    errorMessage = null;
    notifyListeners();
  }

  void setTime(TimeOfDay time) {
    tempTime = time;
    errorMessage = null;
    notifyListeners();
  }

  DateTime get chosenDateTime => DateTime(
    tempDate.year,
    tempDate.month,
    tempDate.day,
    tempTime.hour,
    tempTime.minute,
  );
}
