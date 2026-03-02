import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/constants/app_strings.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_button.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/common_features/view_model/date_time_ticker_view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DateTimePickerWidget extends StatefulWidget {
  final DateTime? initialDateTime;
  final ValueChanged<DateTime> onDateTimeSelected;
  final bool showTimePicker;
  final bool viewBooking;

  const DateTimePickerWidget({
    super.key,
    this.initialDateTime,
    required this.onDateTimeSelected,
    this.showTimePicker = true,
    this.viewBooking = false,
  });

  @override
  State<DateTimePickerWidget> createState() => _DateTimePickerWidgetState();
}

class _DateTimePickerWidgetState extends State<DateTimePickerWidget> {
  late DateTime selectedDateTime;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();

    selectedDateTime =
        widget.initialDateTime ??
        (widget.showTimePicker ? now : now.add(const Duration(days: 30)));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onDateTimeSelected(selectedDateTime);
    });
  }

  @override
  void didUpdateWidget(covariant DateTimePickerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.initialDateTime != null &&
        widget.initialDateTime != oldWidget.initialDateTime) {
      selectedDateTime = widget.initialDateTime!;
    }
  }

  Future<void> _pickDateTime(BuildContext context) async {
    final now = DateTime.now().add(
      Duration(days: widget.showTimePicker ? 1 : 30),
    );

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
                title: textWidget(text: selectDateTime),
                content: SizedBox(
                  width: 300,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: constraints.maxWidth > 360
                              ? 360
                              : constraints.maxWidth,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 300,
                                child: CalendarDatePicker(
                                  initialDate: provider.tempDate,
                                  firstDate: now,
                                  lastDate: widget.showTimePicker
                                      ? now.add(const Duration(days: 365))
                                      : DateTime(2100),
                                  onDateChanged: provider.setDate,
                                ),
                              ),
                              const SizedBox(height: 16),

                              if (widget.showTimePicker)
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    final picked = await showTimePicker(
                                      context: context,
                                      initialTime: provider.tempTime,
                                    );
                                    if (picked != null) {
                                      provider.setTime(picked);
                                    }
                                  },
                                  icon: const Icon(Icons.access_time),
                                  label: textWidget(
                                    text: pickTime,
                                    color: AppColors.whiteColor,
                                  ),
                                ),

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
                      );
                    },
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: textWidget(text: cancelTxt),
                  ),

                  AppButton(
                    text: confirmTxt,
                    width: 100,
                    onTap: () {
                      setState(() {
                        selectedDateTime = provider.chosenDateTime;
                      });

                      widget.onDateTimeSelected(provider.chosenDateTime);

                      Navigator.pop(context);
                    },
                    buttonBackgroundColor: AppColors.authThemeColor,
                    textColor: AppColors.whiteColor,
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
      widget.showTimePicker ? 'EEE, MMM d • hh:mm a' : 'd MMM, yyyy',
    ).format(selectedDateTime);

    return GestureDetector(
      onTap: () => _pickDateTime(context),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.authThemeColor.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.calendar_today_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),

            if (widget.viewBooking)
              Expanded(
                child: textWidget(
                  text: formatted,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              )
            else
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
                      text: widget.showTimePicker
                          ? tapToSelectDateTime
                          : tapToChooseDate,
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
