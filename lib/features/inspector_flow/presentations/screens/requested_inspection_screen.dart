import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/constants/app_constants.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_button.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/booking_provider.dart';
import 'package:inspect_connect/features/inspector_flow/presentations/widgets/common_inspection_listing.dart';
import 'package:provider/provider.dart';

class RequestedInspectionScreen extends StatelessWidget {
  const RequestedInspectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseInspectionListScreen(
      title: "Pending Inspections",
      filterStatuses: [bookingStatusPending],
      bookingActionBuilder: (context, booking) {
        final provider = context.read<BookingProvider>();

        return Row(
          children: [
            Expanded(
              child: AppButton(
                text: "Accept",
                icon: Icon(Icons.thumb_up,color: AppColors.backgroundColor,),
                showIcon: true,
                iconLeftMargin: 10,
                onTap: () => _showConfirmationDialog(
                  context: context,
                  title: "Accept Booking",
                  message:
                      "Are you sure you want to accept this booking request?",
                  confirmText: "Accept",
                  confirmColor: AppColors.authThemeColor,
                  icon: Icons.check_circle_outline,
                  onConfirm: () async {
                    Navigator.pop(context);
                    await provider.updateBookingStatus(
                      context: context,
                      bookingId: booking.id,
                      newStatus: bookingStatusAccepted,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AppButton(
                   icon: Icon(Icons.thumb_down,color: AppColors.authThemeColor,),
                showIcon: true,
                iconLeftMargin: 10,
               
                text: "Reject",
                onTap: () => _showConfirmationDialog(
                  context: context,
                  title: "Reject Booking",
                  message: "Do you want to reject this booking request?",
                  confirmText: "Reject",
                  confirmColor: Colors.redAccent,
                  icon: Icons.cancel_outlined,
                  onConfirm: () async {
                    Navigator.pop(context);
                    await provider.updateBookingStatus(
                      context: context,
                      bookingId: booking.id,
                      newStatus: bookingStatusRejected,
                    );
                  },
                ),
                buttonBackgroundColor: AppColors.backgroundColor,
                textColor: AppColors.authThemeColor,
                borderColor: AppColors.authThemeColor,
                isBorder: true,
              ),
            ),
          ],
        );
      },
    );
  }

  void _showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String message,
    required String confirmText,
    required Color confirmColor,
    required IconData icon,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: confirmColor, size: 50),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        side: BorderSide(color: Colors.grey.shade400),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onConfirm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: confirmColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        confirmText,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
