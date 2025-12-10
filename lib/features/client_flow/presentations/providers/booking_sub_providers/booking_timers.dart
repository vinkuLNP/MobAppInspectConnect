import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_state.dart';
import 'package:inspect_connect/core/di/app_component/app_component.dart';
import 'package:inspect_connect/core/utils/constants/app_constants.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/client_flow/data/models/booking_model.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/booking_list_entity.dart';
import 'package:inspect_connect/features/client_flow/domain/usecases/update_booking_timer.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/booking_provider.dart';

class BookingTimerService {
  final BookingProvider provider;

  BookingTimerService(this.provider);

  Future<void> startInspectionTimer({
    required BuildContext context,
    required String bookingId,
  }) async {
    await updateBookingTimer(
      context: context,
      bookingId: bookingId,
      action: "start",
    );

    final previousSeconds =
        provider.updatedBookingData?.timerDuration ??
        provider.activeTimers[bookingId]?.inSeconds ??
        0;

    provider.activeTimers[bookingId] = Duration(seconds: previousSeconds);
    provider.isTimerRunning[bookingId] = true;
    _startLocalTimer(bookingId);
    provider.notify();
  }

  Future<void> pauseInspectionTimer({
    required BuildContext context,
    required String bookingId,
  }) async {
    await updateBookingTimer(
      context: context,
      bookingId: bookingId,
      action: "pause",
    );
    provider.isTimerRunning[bookingId] = false;
    provider.notify();
  }

  Future<void> stopInspectionTimer({
    required BuildContext context,
    required String bookingId,
  }) async {
    await updateBookingTimer(
      context: context,
      bookingId: bookingId,
      action: "stop",
    );
    provider.isTimerRunning[bookingId] = false;
    provider.timer?.cancel();
    provider.notify();
  }

  Future<void> updateBookingTimer({
    required BuildContext context,
    required String bookingId,
    required String action,
  }) async {
    try {
      provider.isUpdatingBooking = true;
      provider.notify();
      final updateBookingTimerUseCase = locator<UpdateBookingTimerUseCase>();
      final state = await provider
          .executeParamsUseCase<BookingData, UpdateBookingTimerParams>(
            useCase: updateBookingTimerUseCase,
            query: UpdateBookingTimerParams(
              action: action,
              bookingId: bookingId,
            ),
            launchLoader: false,
          );

      state?.when(
        data: (response) {
          provider.updatedBookingData = response;
          final index = provider.bookings.indexWhere((b) => b.id == bookingId);
          if (index != -1) {
            provider.bookings[index] = provider.updatedBookingData!;
          }
          provider.notify();
        },
        error: (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: textWidget(text: e.message ?? 'Booking update failed'),
              ),
            );
          }
        },
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: textWidget(text: 'Failed: $e')));
      }
    } finally {
      provider.isUpdatingBooking = false;
      provider.notify();
    }
  }

  Duration calculateLiveDuration(BookingListEntity booking) {
    try {
      if (booking.status == bookingStatusStarted) {
        final startedAt = DateTime.tryParse(booking.timerStartedAt ?? "");
        if (startedAt != null) {
          final now = DateTime.now().toUtc();
          final baseSeconds = booking.timerDuration ?? 0;
          final liveElapsed = now.difference(startedAt).inSeconds;
          return Duration(seconds: baseSeconds + liveElapsed);
        }
      }
      return Duration(seconds: booking.timerDuration ?? 0);
    } catch (e) {
      log(e.toString());
      return Duration.zero;
    }
  }

  void _startLocalTimer(String bookingId) {
    ensureGlobalTimerRunning();
  }
  void ensureGlobalTimerRunning() {
    if (provider.timer != null && provider.timer!.isActive) return;

    provider.timer = Timer.periodic(const Duration(seconds: 1), (_) {
      provider.activeTimers.forEach((bookingId, currentDuration) {
        if (provider.isTimerRunning[bookingId] == true) {
          provider.activeTimers[bookingId] =
              currentDuration + const Duration(seconds: 1);
        }
      });

      provider.notify();
    });
  }

  String formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  void dispose() {
    provider.timer?.cancel();
  }
}
