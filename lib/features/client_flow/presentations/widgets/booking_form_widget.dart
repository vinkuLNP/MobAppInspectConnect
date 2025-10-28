import 'dart:io';
import 'package:flutter/material.dart';
import 'package:inspect_connect/features/client_flow/data/models/booking_detail_model.dart';
import 'package:intl/intl.dart';
import 'package:inspect_connect/features/client_flow/presentations/widgets/select_time_widget.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/booking_provider.dart';
import 'package:provider/provider.dart';

class BookingFormWidget extends StatefulWidget {
  final bool isEditing;
  final dynamic? initialBooking;
  final VoidCallback? onSubmitSuccess;

  const BookingFormWidget({
    super.key,
    this.isEditing = false,
    this.initialBooking,
    this.onSubmitSuccess,
  });

  @override
  State<BookingFormWidget> createState() => _BookingFormWidgetState();
}

class _BookingFormWidgetState extends State<BookingFormWidget> {
  late BookingProvider provider;

  @override
  void initState() {
    super.initState();
    provider = BookingProvider();

    provider.init().then((_) {
      if (widget.isEditing && widget.initialBooking != null) {
        final BookingDetailModel b = widget.initialBooking;
        provider.locationController.text = b.bookingLocation ?? '';
        provider.descriptionController.text = b.description ?? '';
        provider.setDate(DateTime.parse(b.bookingDate!));
        provider.setTime(provider.parseTime(b.bookingTime ?? ''));
        provider.setInspectionType(
          b.inspector != null ? b.inspector!.name : null,
        );

        // 🖼️ Load existing image URLs if any
        if (b.images != null && b.images.isNotEmpty) {
          provider.existingImageUrls = List<String>.from(b.images);
        }
      }
    });
  }

  InputDecoration _inputDecoration(String hint) => InputDecoration(
    border: const OutlineInputBorder(),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue),
    ),
    hintText: hint,
  );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: provider,
      child: Consumer<BookingProvider>(
        builder: (context, prov, _) {
          final dates = _generateDates();
          final controller = ScrollController();

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _datePicker(context, prov, dates, controller),
                  const SizedBox(height: 20),

                  SelectTimeWidget(
                    initialTime: prov.selectedTime,
                    onTimeSelected: (t) => prov.setTime(t),
                    selectedDate: prov.selectedDate,
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'Inspection Type',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  _inspectionTypeDropdown(prov),

                  const SizedBox(height: 20),
                  const Text(
                    'Location',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: prov.locationController,
                    decoration: _inputDecoration('Enter location'),
                    onChanged: prov.setLocation,
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: prov.descriptionController,
                    maxLines: 4,
                    decoration: _inputDecoration('Add details...'),
                    onChanged: prov.setDescription,
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    'Upload Images (max 5)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  _imageGrid(prov, context),

                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (!prov.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please fill all fields'),
                            ),
                          );
                          return;
                        }

                        if (widget.isEditing) {
                          prov.updateBooking(
                            context: context,
                            bookingId: widget.initialBooking?.id,
                            // onSuccess: widget.onSubmitSuccess,
                          );
                        } else {
                          prov.createBooking(context: context);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Text(
                          widget.isEditing ? 'Save Changes' : 'Confirm Booking',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _datePicker(
    BuildContext context,
    BookingProvider prov,
    List<DateTime> dates,
    ScrollController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Select Date',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            InkWell(
              onTap: () async {
                final today = DateTime.now();
                final last = DateTime(today.year, 12, 31);
                final picked = await showDatePicker(
                  context: context,
                  initialDate: prov.selectedDate,
                  firstDate: today,
                  lastDate: last,
                );
                if (picked != null) prov.setDate(picked);
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: const Icon(Icons.calendar_month),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: ListView.builder(
            controller: controller,
            scrollDirection: Axis.horizontal,
            itemCount: dates.length,
            itemBuilder: (ctx, i) {
              final d = dates[i];
              final isSelected = _sameDate(d, prov.selectedDate);
              return GestureDetector(
                onTap: () => prov.setDate(d),
                child: Container(
                  width: 74,
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey.shade400,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _weekdayShort(d),
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${d.day}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _monthShort(d),
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _inspectionTypeDropdown(BookingProvider prov) {
    return prov.subTypes.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : DropdownButtonFormField<String>(
            decoration: _inputDecoration('Select inspection type'),
            value: prov.inspectionType,
            items: prov.subTypes
                .map(
                  (subType) => DropdownMenuItem<String>(
                    value: subType.id,
                    child: Text(subType.name),
                  ),
                )
                .toList(),
            onChanged: prov.setInspectionType,
          );
  }

  Widget _imageGrid(BookingProvider prov, BuildContext context) {
    final totalImages =
        prov.existingImageUrls.length + prov.images.length; // include old + new
    final canAddMore = totalImages < 5;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: canAddMore ? totalImages + 1 : totalImages,
      itemBuilder: (ctx, i) {
        // existing image URLs
        if (i < prov.existingImageUrls.length) {
          final url = prov.existingImageUrls[i];
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(url, fit: BoxFit.cover),
              ),
              Positioned(
                top: 2,
                right: 2,
                child: GestureDetector(
                  onTap: () => prov.removeExistingImageAt(i),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        // newly picked files
        final imgIndex = i - prov.existingImageUrls.length;
        if (imgIndex < prov.images.length) {
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  prov.images[imgIndex],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              Positioned(
                top: 2,
                right: 2,
                child: GestureDetector(
                  onTap: () => prov.removeImageAt(imgIndex),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        // add new image button
        return GestureDetector(
          onTap: () => prov.uploadImage(ctx),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: const Center(child: Icon(Icons.add_a_photo)),
          ),
        );
      },
    );
  }

  bool _sameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _weekdayShort(DateTime d) =>
      ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][d.weekday % 7];

  String _monthShort(DateTime d) => [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ][d.month - 1];

  List<DateTime> _generateDates() {
    final today = DateTime.now();
    final days = <DateTime>[];
    for (int i = 0; i < 60; i++) {
      days.add(today.add(Duration(days: i)));
    }
    return days;
  }
}
