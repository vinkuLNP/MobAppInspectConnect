import 'package:flutter/material.dart';

class SelectTimeWidget extends StatelessWidget {
  const SelectTimeWidget({
    super.key,
    required this.onTimeSelected,
    this.initialTime,
    required this.selectedDate,
  });

  final TimeOfDay? initialTime;
  final ValueChanged<TimeOfDay> onTimeSelected;
  final DateTime selectedDate;

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Time',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final now = DateTime.now();

            final TimeOfDay? pickedTime = await showTimePicker(
              context: context,

              initialTime: initialTime ?? TimeOfDay.now(),
              builder: (BuildContext context, Widget? child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: Theme.of(context).primaryColor,
                      onPrimary: Colors.white,
                      surface: Theme.of(context).colorScheme.surface,
                      onSurface: Theme.of(context).primaryColor,
                    ),
                  ),
                  child: child!,
                );
              },
            );

            if (pickedTime != null) {
              final isToday =
                  selectedDate.year == now.year &&
                  selectedDate.month == now.month &&
                  selectedDate.day == now.day;

              if (isToday) {
                final selectedDateTime = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  pickedTime.hour,
                  pickedTime.minute,
                );

                if (selectedDateTime.isBefore(now)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please select a time after the current time.',
                      ),
                    ),
                  );
                  return;
                }
              }
              onTimeSelected(pickedTime);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  initialTime != null
                      ? _formatTime(initialTime!)
                      // initialTime!.format(context)
                      : 'Choose a time',
                  style: TextStyle(
                    fontSize: 15,
                    color: initialTime != null
                        ? Colors.black
                        : Colors.grey.shade600,
                  ),
                ),
                const Icon(Icons.access_time, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
