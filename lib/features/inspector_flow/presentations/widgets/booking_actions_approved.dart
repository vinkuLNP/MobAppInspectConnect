import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_constants.dart';
import 'package:inspect_connect/core/utils/constants/app_strings.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_widgets.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/booking_list_entity.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/booking_provider.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/user_provider.dart';
import 'package:inspect_connect/features/inspector_flow/data/mappers/booking_action_mapper.dart';
import 'package:inspect_connect/features/inspector_flow/domain/enum/booking_type_enum.dart';
import 'package:inspect_connect/features/inspector_flow/presentations/widgets/accepted_booking_action.dart';
import 'package:inspect_connect/features/inspector_flow/presentations/widgets/running_booking_action.dart';
import 'package:provider/provider.dart';

class BookingActionResolver {
  static Widget resolve({
    required BuildContext context,
    required BookingListEntity booking,
    required BookingProvider provider,
  }) {
    final type = BookingActionMapper.fromStatus(booking.status!);

    switch (type) {
      case InspectorBookingActionType.accepted:
        return _accepted(context, booking, provider);

      case InspectorBookingActionType.running:
        return _running(context, booking, provider);

      case InspectorBookingActionType.completed:
      case InspectorBookingActionType.none:
        return const SizedBox.shrink();
    }
  }

  static Widget _accepted(
    BuildContext context,
    BookingListEntity booking,
    BookingProvider provider,
  ) {
    final now = DateTime.now();
    final bookingTime = bookingDateTime(booking);
    final canDecline = bookingTime.difference(now).inMinutes / 60 > 8;

    final showUpFeeApplied =
        booking.showUpFeeApplied ??
        provider.showUpFeeStatusMap[booking.id] ??
        false;

    return AcceptedBookingActions(
      canDecline: canDecline,
      showUpFeeApplied: showUpFeeApplied,
      onToggleFee: () =>
          _toggleFee(context, booking, provider, showUpFeeApplied),
      onDecline: () => _decline(context, booking),
      onStart: () => provider.startInspectionTimer(
        context: context,
        bookingId: booking.id,
      ),
    );
  }

  static Widget _running(
    BuildContext context,
    BookingListEntity booking,
    BookingProvider provider,
  ) {
    final isRunning = provider.isTimerRunning[booking.id] ?? false;
    final isStopped = booking.status == bookingStatusStoppped;
    final timer = provider.activeTimers[booking.id];
    log('---------> ');
    final showUpFeeApplied =
        provider.showUpFeeStatusMap[booking.id] ??
        booking.showUpFeeApplied ??
        false;

    if (timer == null) return const SizedBox.shrink();

    return RunningBookingActions(
      isRunning: isRunning,
      isStopped: isStopped,
      showUpFeeApplied: showUpFeeApplied,
      timerText: provider.formatDuration(timer),
      onToggleFee: () =>
          _toggleFee(context, booking, provider, showUpFeeApplied),
      onPauseResume: () async {
        isRunning
            ? await provider.pauseInspectionTimer(
                context: context,
                bookingId: booking.id,
              )
            : await provider.startInspectionTimer(
                context: context,
                bookingId: booking.id,
              );
      },
      onStop: () =>
          provider.stopInspectionTimer(context: context, bookingId: booking.id),
      onComplete: () async {
        final user = context.read<UserProvider>().user;
        await provider.updateBookingStatus(
          context: context,
          bookingId: booking.id,
          newStatus: bookingStatusAwaiting,
          userId: user!.userId,
        );
      },
    );
  }

  static void _toggleFee(
    BuildContext context,
    BookingListEntity booking,
    BookingProvider provider,
    bool isApplied,
  ) {
    showShowUpFeeDialog(
      context: context,
      isApplied: isApplied,
      onConfirm: () async {
        final user = context.read<UserProvider>().user;
        final rootContext = Navigator.of(context).context;
        Navigator.pop(context);
        await provider.updateShowUpFeeStatus(
          context: rootContext,
          bookingId: booking.id,
          showUpFeeApplied: !isApplied,
          userId: user!.userId,
        );
      },
    );
  }

  static void _decline(BuildContext context, BookingListEntity booking) {
    showConfirmationDialog(
      context: context,
      confirmColor: Colors.redAccent,
      icon: Icons.cancel_outlined,
      title: declineBookingBtnText,
      message: declineBookingMsg,
      confirmText: declineTxt,
      onConfirm: () async {
        final user = context.read<UserProvider>().user;
        Navigator.pop(context);
        await context.read<BookingProvider>().updateBookingStatus(
          context: context,
          bookingId: booking.id,
          newStatus: bookingStatusCancelledByInspector,
          userId: user!.userId,
        );
      },
    );
  }
}
