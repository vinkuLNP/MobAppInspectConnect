import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:inspect_connect/core/di/app_component/app_component.dart';
import 'package:inspect_connect/core/di/app_sockets/socket_service.dart';
import 'package:inspect_connect/core/di/notifcation_services/app_notification.dart';
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
    print('📥 Registering socket listeners | isInspector=$isInspector');

    socket.on('raise_inspection_request_listener', (payload) {
      final data = payload?['data'];
      if (data != null) {
        bookingProvider.onRaiseInspectionUpdate(data);

        if (!isInspector && !isRaiseDialogOpen) {
          final BuildContext? context =
              rootNavigatorKey.currentState?.overlay?.context;
          final user = context?.read<UserProvider>().user;
          if (context != null && user != null) {
            showRaiseDialog(data, user.userId);
          }
        }

        NotificationService.show(RemoteMessage(
          notification: RemoteNotification(
            title: 'Price Change Requested',
            body: 'New amount: ₹${data['raisedAmount']}',
          ),
          data: {
            'redirectUrl': '/booking/${data['bookingId']}',
            'click_action': '/booking/${data['bookingId']}',
          },
        ));
      }
    });

    socket.on('booking_status_update_listener', (payload) {
      final data = payload?['data'];
      if (data != null) {
        bookingProvider.onBookingStatusUpdated(
          status: data['status'],
          bookingId: data['bookingId']?.toString(),
          message: payload['message']?.toString(),
        );

        NotificationService.show(RemoteMessage(
          notification: RemoteNotification(
            title: 'Booking Status Updated',
            body: 'Booking #${data['bookingId']} status changed to ${data['status']}',
          ),
          data: {
            'redirectUrl': '/booking/${data['bookingId']}',
            'click_action': '/booking/${data['bookingId']}',
          },
        ));
      }
    });

    socket.on('booking_completed_listener', (payload) {
      final data = payload?['data'];
      if (data != null) {
        bookingProvider.onBookingCompleted(
          bookingId: data['bookingId']?.toString(),
          payload: payload,
        );

        NotificationService.show(RemoteMessage(
          notification: RemoteNotification(
            title: 'Booking Completed',
            body: 'Booking #${data['bookingId']} is completed',
          ),
          data: {
            'redirectUrl': '/booking/${data['bookingId']}',
            'click_action': '/booking/${data['bookingId']}',
          },
        ));
      }
    });

    if (isInspector) {
      socket.on('booking_creation_notification_listener', (payload) {
        final data = payload?['data'];
        if (data != null) {
          bookingProvider.onBookingAssigned(
            bookingId: data['bookingId']?.toString(),
            inspectors: data['inspectors'],
          );

          NotificationService.show(RemoteMessage(
            notification: RemoteNotification(
              title: 'New Booking Assigned',
              body: 'Booking #${data['bookingId']} assigned to you',
            ),
            data: {
              'redirectUrl': '/booking/${data['bookingId']}',
              'click_action': '/booking/${data['bookingId']}',
            },
          ));
        }
      });
    }
  }

  void unregisterAllListeners() {
    print('📥 Unregistering all socket listeners');
    socket.off('raise_inspection_request_listener');
    socket.off('booking_status_update_listener');
    socket.off('booking_completed_listener');
    socket.off('booking_creation_notification_listener');
    print('📥 All listeners removed successfully');
  }

  void showRaiseDialog(Map<String, dynamic> data, String userId) async {
    final bookingId = data['bookingId']?.toString();
    final inspectorId = data['inspectorId']?.toString();
    final raisedAmount = data['raisedAmount'];

    if (bookingId == null) return;

    final BuildContext? context =
        rootNavigatorKey.currentState?.overlay?.context;
    if (context == null) return;

    isRaiseDialogOpen = true;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Price change requested for Booking $bookingId'),
        content: Text('New amount: ₹$raisedAmount'),
        actions: [
          TextButton(
            onPressed: () {
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
              } catch (e) {
                print('⚠️ Error updating booking status: $e');
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
