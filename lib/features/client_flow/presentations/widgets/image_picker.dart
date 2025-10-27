import 'package:flutter/material.dart';

class SelectTimeWidget extends StatelessWidget {
  const SelectTimeWidget({super.key, required this.onTimeSelected, this.initialTime});

  final TimeOfDay? initialTime;
  final ValueChanged<TimeOfDay> onTimeSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Time',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final TimeOfDay? pickedTime = await showTimePicker(
              context: context,
              initialTime: initialTime ?? TimeOfDay.now(),
            );

            if (pickedTime != null) {
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
                      ? initialTime!.format(context)
                      : 'Choose a time',
                  style: TextStyle(
                    fontSize: 15,
                    color: initialTime != null ? Colors.black : Colors.grey.shade600,
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
