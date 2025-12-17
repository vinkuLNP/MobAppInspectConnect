import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:inspect_connect/core/di/app_component/app_component.dart';
import 'package:inspect_connect/core/di/app_sockets/socket_service.dart';
import 'package:inspect_connect/core/di/notifcation_services/app_notification.dart';
import 'package:inspect_connect/core/utils/constants/app_constants.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_button.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/booking_provider.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/user_provider.dart';
import 'package:inspect_connect/main.dart';
import 'package:provider/provider.dart';

class SocketManager {
  final SocketService _socket = locator<SocketService>();
  final BookingProvider bookingProvider;

  final Set<String> handledRaiseRequests = {};
  final Set<String> handledNotifications = {};

  bool isRaiseDialogOpen = false;

  SocketManager(this.bookingProvider);

  void registerGlobalListeners({required bool isInspector}) {
    log("🔌 Registering Socket Listeners | Inspector: $isInspector");

    registerRaiseInspectionListener(isInspector);
    registerBookingStatusUpdateListener();
    registerBookingCompletedListener();

    if (isInspector) {
      registerBookingCreationListener();
    }
  }

  void unregisterAllListeners() {
    log("🔌 Removing all socket listeners");

    _socket.off('raise_inspection_request_listener');
    _socket.off('booking_status_update_listener');
    _socket.off('booking_completed_listener');
    _socket.off('booking_creation_notification_listener');
  }

  void registerRaiseInspectionListener(bool isInspector) {
    _socket.on('raise_inspection_request_listener', (payload) {
      final data = payload?['data'];
      if (data == null) return;
      log(
        "🔔 Client Raise Inspection Request OPutdisdedddddd| Payload: $payload",
      );
      final String? bookingId = data['bookingId']?.toString();
      if (bookingId == null) return;

      final raisedAmount = data['raisedAmount'];
      final int agreedToRaise = data['agreedToRaise'];
      final inspectorId = data['inspectorId']?.toString();

      if (agreedToRaise == 1) {
        log(  
          "🔔 Client Raise Inspection Request | Booking ID: $bookingId | Raised Amount: $raisedAmount | AGREED",
        );
        bookingProvider.onRaiseInspectionUpdate(data);
      }
      log(
        "🔔 Client Raise Inspection Request OPutdisdedddddd| Booking ID: $bookingId | Raised Amount: $raisedAmount",
      );

      if (!isInspector) {
        log(
          "🔔 Client Raise Inspection Request | Booking ID: $bookingId | Raised Amount: $raisedAmount",
        );
        handleClientRaiseRequest(
          bookingId: bookingId,
          data: data,
          raisedAmount: raisedAmount,
          inspectorId: inspectorId,
          agreedToRaise: agreedToRaise,
        );
      }

      if (isInspector && (agreedToRaise != 0)) {
        showClientRaiseResponseNotification(
          bookingId: bookingId,
          agreedToRaise: agreedToRaise,
        );
      }
    });
  }

  void registerBookingStatusUpdateListener() {
    _socket.on('booking_status_update_listener', (payload) {
      final data = payload?['data'];
      if (data == null) return;

      bookingProvider.onBookingStatusUpdated(
        status: data['status'],
        bookingId: data['bookingId']?.toString(),
        message: payload['message']?.toString(),
      );
      final statusText = bookingStatusToText(data['status']);

      _showNotification(
        title: "Booking Status Updated",
        body: "Booking #${data['bookingId']} status changed to $statusText",
        bookingId: data['bookingId'].toString(),
      );
    });
  }

  void registerBookingCompletedListener() {
    _socket.on('booking_completed_listener', (payload) {
      final data = payload?['data'];
      if (data == null) return;

      bookingProvider.onBookingCompleted(
        bookingId: data['bookingId']?.toString(),
        payload: payload,
      );

      _showNotification(
        title: "Booking Completed",
        body: "Booking #${data['bookingId']} is completed",
        bookingId: data['bookingId'].toString(),
      );
    });
  }

  void registerBookingCreationListener() {
    _socket.on('booking_creation_notification_listener', (payload) {
      final data = payload?['data'];
      if (data == null) return;

      bookingProvider.onBookingAssigned(
        bookingId: data['bookingId']?.toString(),
        inspectors: data['inspectors'],
      );

      _showNotification(
        title: "New Booking Assigned",
        body: "Booking #${data['bookingId']} assigned to you",
        bookingId: data['bookingId'].toString(),
      );
    });
  }

  void handleClientRaiseRequest({
    required String bookingId,
    required Map<String, dynamic> data,
    required dynamic raisedAmount,
    required String? inspectorId,
    required int? agreedToRaise,
  }) {
    if (handledRaiseRequests.contains(bookingId) && agreedToRaise != 0) {
      log("⚠️ Client dialog already shown for booking $bookingId");
      return;
    }

    handledRaiseRequests.add(bookingId);

    final BuildContext? context =
        rootNavigatorKey.currentState?.overlay?.context;
    if (context == null) return;

    final user = context.read<UserProvider>().user;
    if (user == null) return;

    if (!handledNotifications.contains(bookingId)) {
      handledNotifications.add(bookingId);

      _showNotification(
        title: "Price Change Requested",
        body: "New amount: ₹$raisedAmount",
        bookingId: bookingId,
      );
    }

    showRaiseDialog(
      bookingId: bookingId,
      inspectorId: inspectorId,
      raisedAmount: raisedAmount,
      userId: user.userId,
      context: context,
    );
  }

  void showClientRaiseResponseNotification({
    required String bookingId,
    required int agreedToRaise,
  }) {
    final msg = agreedToRaise == 1
        ? "Client accepted the price change"
        : "Client rejected the price change";

    _showNotification(
      title: "Client Responded",
      body: msg,
      bookingId: bookingId,
    );
  }

  void _showNotification({
    required String title,
    required String body,
    required String bookingId,
  }) {
    NotificationService.show(
      RemoteMessage(
        notification: RemoteNotification(title: title, body: body),
        data: {
          'redirectUrl': '/booking/$bookingId',
          'click_action': '/booking/$bookingId',
        },
      ),
    );
  }

  void showRaiseDialog({
    required String bookingId,
    required String? inspectorId,
    required dynamic raisedAmount,
    required String userId,
    required BuildContext context,
  }) {
    if (isRaiseDialogOpen) return;
    isRaiseDialogOpen = true;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Price change for Booking $bookingId"),
        content: Text("New amount: ₹$raisedAmount"),
        actions: [
          TextButton(
            child: const Text("Reject"),
            onPressed: () {
              _socket.emit('raised_inspection_request', {
                'bookingId': bookingId,
                'inspectorId': inspectorId,
                'agreedToRaise': 2,
                'raisedAmount': raisedAmount,
              });
              isRaiseDialogOpen = false;

              Navigator.pop(context);
            },
          ),
          AppButton(
            width: MediaQuery.of(context).size.width / 3,
            text: "Accept",
            onTap: () {
              _socket.emit('raised_inspection_request', {
                'bookingId': bookingId,
                'inspectorId': inspectorId,
                'agreedToRaise': 1,
                'raisedAmount': raisedAmount,
              });

              bookingProvider.actionsService.updateBookingStatus(
                context: context,
                bookingId: bookingId,
                newStatus: bookingStatusAccepted,
                userId: userId,
              );
              Navigator.pop(context);
              isRaiseDialogOpen = false;
            },
          ),
        ],
      ),
    ).then((_) {
      isRaiseDialogOpen = false;
    });
  }
}
