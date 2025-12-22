import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:inspect_connect/core/utils/app_widgets/common_address_auto_complete_field.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_button.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/core/utils/presentation/app_text_style.dart';
import 'package:inspect_connect/features/auth_flow/presentation/client/widgets/input_fields.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/certificate_sub_type_entity.dart';
import 'package:inspect_connect/features/client_flow/presentations/widgets/policies_widget.dart';
import 'package:provider/provider.dart';
import 'package:inspect_connect/features/client_flow/data/models/booking_detail_model.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/booking_provider.dart';
import 'package:inspect_connect/features/client_flow/presentations/widgets/select_time_widget.dart';

class BookingFormWidget extends StatefulWidget {
  final bool isEditing, isReadOnly;
  final dynamic initialBooking;
  final VoidCallback? onSubmitSuccess;

  const BookingFormWidget({
    super.key,
    this.isEditing = false,
    this.isReadOnly = false,

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
        log(b.images.toString());

        provider.locationController.text = b.bookingLocation;
        provider.location = b.bookingLocation;
        provider.description = b.description;
        provider.descriptionController.text = b.description;
        provider.setDate(DateTime.parse(b.bookingDate));
        provider.setTime(provider.parseTime(b.bookingTime));
        provider.setInspectionType(
          (b.certificateSubTypes != [] ? b.certificateSubTypes[0] : null),
        );

        if (b.images != [] && b.images.isNotEmpty) {
          provider.uploadedUrls = List<String>.from(b.images);
          provider.existingImageUrls = List<String>.from(b.images);
          log(
            '--------->provider.uploadedUrls ${provider.uploadedUrls.toString()}',
          );
          log(
            '--------->provider.existingImageUrls ${provider.existingImageUrls.toString()}',
          );
        }
      }
    });
  }

  InputDecoration _inputDecoration(String hint) => InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Colors.grey.shade50,
    errorStyle: appTextStyle(fontSize: 12, color: Colors.red),
    hintStyle: appTextStyle(fontSize: 12, color: Colors.grey),

    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColors.authThemeColor),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: provider,
      child: Consumer<BookingProvider>(
        builder: (context, prov, _) {
          final now = DateTime.now();

          return Stack(
            children: [
              AbsorbPointer(
                absorbing: prov.isProcessing,
                child: Opacity(
                  opacity: prov.isProcessing ? 0.6 : 1.0,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _section(
                            title: 'Select Date & Time',
                            child: IgnorePointer(
                              ignoring: widget.isReadOnly,
                              child: DateTimePickerWidget(
                                viewBooking: widget.isReadOnly,
                                initialDateTime:
                                    widget.isEditing &&
                                        widget.initialBooking != null
                                    ? _combineBookingDateTime(
                                        widget.initialBooking.bookingDate,
                                        widget.initialBooking.bookingTime,
                                      )
                                    : DateTime(
                                        prov.selectedDate.year,
                                        prov.selectedDate.month,
                                        prov.selectedDate.day,
                                        prov.selectedTime?.hour ?? now.hour,
                                        prov.selectedTime?.minute ?? now.minute,
                                      ),
                                onDateTimeSelected: (dt) {
                                  prov.setDate(dt);
                                  prov.setTime(TimeOfDay.fromDateTime(dt));
                                },
                              ),
                            ),
                          ),

                          _section(
                            title: 'Inspection Type',
                            child: _inspectionTypeDropdown(prov),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            child: AddressAutocompleteField(
                              label: "Address",
                              style: AddressFieldStyle.bookingInput,
                              controller: prov.locationController,
                              googleApiKey: dotenv.env['GOOGLE_API_KEY']!,
                              onAddressSelected: (prediction) {
                                log("Selected: ${prediction.fullText}");
                              },
                              onChanged: prov.setLocation,
                              onFullAddressFetched: (data) {
                                prov.setAddressData(data);
                              },
                            ),
                          ),
                          BookingInputField(
                            label: 'Description',
                            controller: prov.descriptionController,
                            readOnly: widget.isReadOnly,
                            maxLines: 4,
                            onChanged: widget.isReadOnly
                                ? null
                                : prov.setDescription,
                            hint: 'Add details...',
                          ),

                          _section(
                            title: 'Upload Images (max 5)',
                            child: _imageGrid(prov, context),
                          ),
                          widget.isReadOnly
                              ? SizedBox.shrink()
                              : PolicyAgreementRow(),
                          const SizedBox(height: 10),
                          if (!widget.isReadOnly)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              child: IgnorePointer(
                                ignoring: !prov.agreedToPolicies,
                                child: AppButton(
                                  buttonBackgroundColor: prov.agreedToPolicies
                                      ? AppColors.authThemeColor
                                      : AppColors.disableColor,
                                  borderColor: prov.agreedToPolicies
                                      ? AppColors.authThemeColor
                                      : AppColors.disableColor,
                                  text: widget.isEditing
                                      ? 'Save Changes'
                                      : 'Confirm Booking',
                                  onTap: prov.isProcessing
                                      ? null
                                      : () {
                                          if (!prov.validate(cntx: context)) {
                                            return;
                                          }
                                          log(prov.locationController.text);
                                          if (widget.isEditing) {
                                            prov.updateBooking(
                                              context: context,
                                              bookingId:
                                                  widget.initialBooking?.id,
                                            );
                                          } else {
                                            prov.createBooking(
                                              context: context,
                                            );
                                          }
                                        },
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (prov.isProcessing)
                const Center(child: CircularProgressIndicator()),
            ],
          );
        },
      ),
    );
  }

  Widget _section({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textWidget(text: title, fontWeight: FontWeight.w600, fontSize: 12),
          const SizedBox(height: 3),
          child,
        ],
      ),
    );
  }

  Widget _inspectionTypeDropdown(BookingProvider prov) {
    return DropdownButtonFormField<CertificateSubTypeEntity>(
      isDense: true,
      isExpanded: true,
      decoration: _inputDecoration('Select inspection type').copyWith(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 14,
        ),
      ),
      style: appTextStyle(fontSize: 12),
      initialValue: prov.provInspectionType,

      items: prov.subTypes.map((subType) {
        return DropdownMenuItem<CertificateSubTypeEntity>(
          value: subType,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 250, minWidth: 50),
            child: Text(
              subType.name,
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.visible,
              style: appTextStyle(fontSize: 12),
            ),
          ),
        );
      }).toList(),

      onChanged: widget.isReadOnly ? null : prov.setInspectionType,
    );
  }

  Widget _imageGrid(BookingProvider prov, BuildContext context) {
    final totalImages = prov.existingImageUrls.length + prov.images.length;
    final canAddMore = totalImages < 5;

    if (totalImages == 0 && !widget.isReadOnly) {
      return GestureDetector(
        onTap: () => prov.uploadImage(context),
        child: Container(
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300),
            color: Colors.grey.shade50,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_a_photo, size: 32, color: Colors.grey),
              SizedBox(height: 8),
              textWidget(text: "Add Image", color: Colors.grey, fontSize: 12),
            ],
          ),
        ),
      );
    }

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
        if (i < prov.existingImageUrls.length) {
          final url = prov.existingImageUrls[i];
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(url, fit: BoxFit.cover),
              ),
              if (!widget.isReadOnly)
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

        final imgIndex = i - prov.existingImageUrls.length;
        if (imgIndex < prov.images.length) {
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  prov.images[imgIndex],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              if (!widget.isReadOnly)
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
        if (!widget.isReadOnly) {
          return GestureDetector(
            onTap: () => prov.uploadImage(ctx),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
                color: Colors.grey.shade50,
              ),
              child: const Center(child: Icon(Icons.add_a_photo)),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

DateTime _combineBookingDateTime(String dateStr, String timeStr) {
  final date = DateTime.parse(dateStr);
  final offset = _parseBookingTime(timeStr);
  return date.add(offset);
}

Duration _parseBookingTime(String timeStr) {
  if (timeStr.trim().isEmpty) return Duration.zero;

  try {
    final cleaned = timeStr.toUpperCase().replaceAll('.', '').trim();

    if (cleaned.contains('AM') || cleaned.contains('PM')) {
      final regex = RegExp(r'(\d{1,2})(?::(\d{2}))?\s*(AM|PM)');
      final match = regex.firstMatch(cleaned);
      if (match != null) {
        int hour = int.parse(match.group(1)!);
        int minute = int.tryParse(match.group(2) ?? '0') ?? 0;
        final meridian = match.group(3)!;

        if (meridian == 'PM' && hour != 12) hour += 12;
        if (meridian == 'AM' && hour == 12) hour = 0;

        return Duration(hours: hour, minutes: minute);
      }
    }

    final parts = cleaned.split(':');
    final hour = int.parse(parts[0]);
    final minute = parts.length > 1 ? int.parse(parts[1]) : 0;
    return Duration(hours: hour, minutes: minute);
  } catch (e) {
    log("⛔ Time parse error for '$timeStr' → $e");
    return Duration.zero;
  }
}
