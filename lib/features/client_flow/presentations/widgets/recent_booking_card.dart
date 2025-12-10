import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/booking_list_entity.dart';
import 'package:intl/intl.dart';

class RecentBookingViewerCard extends StatelessWidget {
  final BookingListEntity bookingListEntity;

  const RecentBookingViewerCard({super.key, required this.bookingListEntity});

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat(
      'dd MMM yyyy',
    ).format(DateTime.parse(bookingListEntity.bookingDate));

    return Container(
      margin: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha:0.1),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            color: Colors.green.shade600,
            child: Row(
              children: [
                const Icon(Icons.confirmation_number, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: textWidget(
                    text: 'RECENT APPROVED BOOKING',
                    color: Colors.white,
                    textOverflow: TextOverflow.ellipsis,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textWidget(
                  text: bookingListEntity.description,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),

                const SizedBox(height: 10),

                _iconRow(Icons.calendar_today, 'Booking date', dateStr),
                const SizedBox(height: 6),
                _iconRow(
                  Icons.access_time,
                  'Booking time',
                  bookingListEntity.bookingTime,
                ),
                const SizedBox(height: 6),

                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconRow(IconData icon, String k, String v) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.black54),
        const SizedBox(width: 6),
        textWidget(text: k, fontWeight: FontWeight.w600, fontSize: 12),
        const SizedBox(width: 8),
        Expanded(
          child: textWidget(
            text: v,
            fontSize: 12,
            textOverflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
