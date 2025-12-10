import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:inspect_connect/core/di/app_component/app_component.dart';
import 'package:inspect_connect/core/di/app_sockets/socket_service.dart';
import 'package:inspect_connect/core/utils/constants/app_constants.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/booking_provider.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/user_provider.dart';
import 'package:inspect_connect/main.dart';
import 'package:provider/provider.dart';

class SocketManager {
  final SocketService socket = locator<SocketService>();
  final BookingProvider bookingProvider;
bool isRaiseDialogOpen = false;
  SocketManager(this.bookingProvider);

  void registerGlobalListeners({bool isInspector = false}) {
    log(' 📥Registering listeners|isInspector=$isInspector');

    socket.on('raise_inspection_request_listener', (payload) {
      log(' 📥 EVENT: raise_inspection_request_listener $payload');
      final data = payload?['data'];
      if (data != null) {
        bookingProvider.onRaiseInspectionUpdate(data);
      }
      if (!isInspector && data != null && !isRaiseDialogOpen) {
        final BuildContext? context =
            rootNavigatorKey.currentState?.overlay?.context;
        final user = context!.read<UserProvider>().user;

        showRaiseDialog(data, user!.userId);
      }
    });

    socket.on('booking_status_update_listener', (payload) {
      log(' 📥 EVENT: booking_status_update_listener $payload');

      final data = payload?['data'];
      bookingProvider.onBookingStatusUpdated(
        status: data?['status'],
        bookingId: data?['bookingId']?.toString(),
        message: payload?['message']?.toString(),
      );

      log(' 📥 -> BookingProvider booking status updated');
    });

    socket.on('booking_completed_listener', (payload) {
      log(' 📥 EVENT: booking_completed_listener $payload');

      final data = payload?['data'];
      bookingProvider.onBookingCompleted(
        bookingId: data?['bookingId']?.toString(),
        payload: payload,
      );

      log(' 📥 -> BookingProvider booking completed event processed');
    });

    if (isInspector) {
      socket.on('booking_creation_notification_listener', (payload) {
        log(' 📥 EVENT: booking_creation_notification_listener $payload');

        final data = payload?['data'];
        if (data != null) {
          log(' 📥 -> New booking assigned to Inspector');
          bookingProvider.onBookingAssigned(
            bookingId: data['bookingId']?.toString(),
            inspectors: data['inspectors'],
          );
        }
      });
    }
  }

  void unregisterAllListeners() {
    log(' 📥     [SocketManager] Unregistering ALL socket listeners');
    socket.off('raise_inspection_request_listener');
    socket.off('booking_status_update_listener');
    socket.off('booking_completed_listener');
    socket.off('booking_creation_notification_listener');
    log(' 📥     [SocketManager] All listeners removed successfully');
  }

  void showRaiseDialog(Map<String, dynamic> data, String userId) async {
    final bookingId = data['bookingId']?.toString();
    final inspectorId = data['inspectorId']?.toString();
    final raisedAmount = data['raisedAmount'];
    log(' 📥     [Dialog] Showing raise amount dialog for booking $bookingId');
    if (bookingId == null) {
      log(' 📥 ialog][ERROR] Missing bookingId, cannot show dialog');
      return;
    }
    final BuildContext? context =
        rootNavigatorKey.currentState?.overlay?.context;

    if (context == null) {
      log(' 📥 [Dialog][ERROR] Global context is NULL, cannot show dialog');
      return;
    }
    isRaiseDialogOpen = true;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Price change requested for Booking '),
        content: Text('New amount: ₹$raisedAmount'),
        actions: [
          TextButton(
            onPressed: () {
              log(' 📥   [Dialog] User REJECTED raise request');
              socket.emit('raised_inspection_request', {
                'bookingId': bookingId,
                'inspectorId': inspectorId,
                'agreedToRaise': 2,
                'raisedAmount': raisedAmount,
              });
              isRaiseDialogOpen = false;
              Navigator.of(context).pop();
            },
            child: const Text('Reject'),
          ),
          ElevatedButton(
            onPressed: () {
              log(' 📥     [Dialog] User ACCEPTED raise request');
              socket.emit('raised_inspection_request', {
                'bookingId': bookingId,
                'inspectorId': inspectorId,
                'agreedToRaise': 1,
                'raisedAmount': raisedAmount,
              });
              try {
                bookingProvider.actionsService.updateBookingStatus(
                  context: context,
                  bookingId: bookingId,
                  newStatus: bookingStatusAccepted,
                  userId: userId,
                );
                log(' 📥   [Dialog] Booking status updated to Accepted');
              } catch (e) {
                log(' ⚠️ Error updating booking status: $e');
              }
              isRaiseDialogOpen = false;

              Navigator.of(context).pop();
            },
            child: const Text('Accept'),
          ),
        ],
      ),
    ).then((_) {
      isRaiseDialogOpen = false; 
    });
  }
}
