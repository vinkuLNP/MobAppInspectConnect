import 'package:flutter/material.dart';

class DateTimePickerProvider extends ChangeNotifier {
  DateTime tempDate;
  TimeOfDay tempTime;
  String? errorMessage;

  final DateTime now;

  DateTimePickerProvider({required this.now})
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

  bool validateDateTime() {
    final chosenDateTime = DateTime(
      tempDate.year,
      tempDate.month,
      tempDate.day,
      tempTime.hour,
      tempTime.minute,
    );

    if (DateUtils.isSameDay(tempDate, now) &&
        chosenDateTime.isBefore(now.add(const Duration(hours: 2)))) {
      errorMessage = "Please select a time at least 2 hours from now.";
      notifyListeners();
      return false;
    }

    return true;
  }

  DateTime get chosenDateTime => DateTime(
        tempDate.year,
        tempDate.month,
        tempDate.day,
        tempTime.hour,
        tempTime.minute,
      );
}
