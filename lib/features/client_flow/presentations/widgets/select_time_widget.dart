import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/client_flow/presentations/widgets/date_time_widget_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DateTimePickerWidget extends StatefulWidget {
  final DateTime? initialDateTime;
  final ValueChanged<DateTime> onDateTimeSelected;
  final bool showTimePicker;

  const DateTimePickerWidget({
    super.key,
    this.initialDateTime,
    required this.onDateTimeSelected,
    this.showTimePicker = true,
  });

  @override
  State<DateTimePickerWidget> createState() => _DateTimePickerWidgetState();
}

class _DateTimePickerWidgetState extends State<DateTimePickerWidget> {
  late DateTime selectedDateTime;

  @override
  void initState() {
    super.initState();
    selectedDateTime =
        widget.initialDateTime ?? DateTime.now().add(const Duration(hours: 2));
  }

  Future<void> _pickDateTime(BuildContext context) async {
    final now = DateTime.now();
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return ChangeNotifierProvider(
          create: (_) => DateTimePickerProvider(
            now: now,
            showTimePicker: widget.showTimePicker,
          ),
          child: Consumer<DateTimePickerProvider>(
            builder: (context, provider, _) {
              return AlertDialog(
                title: textWidget(text: "Select Date & Time"),
                content: SizedBox(
                  width: 300,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 300,
                        child: CalendarDatePicker(
                          initialDate: provider.tempDate,
                          firstDate: now,
                          lastDate: now.add(const Duration(days: 60)),
                          onDateChanged: provider.setDate,
                        ),
                      ),
                      const SizedBox(height: 16),
                      widget.showTimePicker
                          ? ElevatedButton.icon(
                              onPressed: () async {
                                final isToday = DateUtils.isSameDay(
                                  provider.tempDate,
                                  now,
                                );
                                final minTime = TimeOfDay.fromDateTime(
                                  now.add(const Duration(hours: 2)),
                                );
                                final picked = await showTimePicker(
                                  context: context,
                                  initialTime: isToday
                                      ? minTime
                                      : provider.tempTime,
                                );
                                if (picked != null) provider.setTime(picked);
                              },
                              icon: const Icon(Icons.access_time),
                              label: textWidget(
                                text: "Pick Time",
                                color: AppColors.whiteColor,
                              ),
                            )
                          : SizedBox.shrink(),
                      if (provider.errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: textWidget(
                            text: provider.errorMessage!,
                            color: Colors.red,
                          ),
                        ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: textWidget(text: "Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (!provider.validateDateTime()) return;

                      setState(
                        () => selectedDateTime = provider.chosenDateTime,
                      );
                      widget.onDateTimeSelected(provider.chosenDateTime);
                      Navigator.pop(context);
                    },
                    child: textWidget(
                      text: "Confirm",
                      color: AppColors.whiteColor,
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final formatted = DateFormat(
   widget.showTimePicker ?    'EEE, MMM d • hh:mm a' : 'd MMM, yyyy',
    ).format(selectedDateTime);

    return GestureDetector(
      onTap: () => _pickDateTime(context),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding:  EdgeInsets.symmetric(horizontal: 16 , vertical: widget.showTimePicker ?  16 : 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        
          border: Border.all(color: Colors.grey),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.authThemeColor.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.calendar_today_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textWidget(
                    text: formatted,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 2),
                  textWidget(
                    text:widget
                    .showTimePicker ?  "Tap to select date & time" : "Tap to choose date",
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.authThemeColor,
              size: 26,
            ),
          ],
        ),
      ),
    );
  }
}
