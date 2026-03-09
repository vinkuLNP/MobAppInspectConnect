import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:inspect_connect/core/di/app_component/app_component.dart';
import 'package:inspect_connect/core/di/services/app_sockets/socket_manager.dart';
import 'package:inspect_connect/core/utils/constants/app_constants.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/booking_provider.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/user_provider.dart';
import 'package:inspect_connect/main.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();
  io.Socket? socket;

  bool get isConnected => socket?.connected ?? false;
  late final SocketManager socketManager;
  void initSocket({required String token}) {
    log("🟦 [SOCKET INIT] Starting initialization…");
    log(
      "🟦 [SOCKET INIT] Token received: ${token.isNotEmpty ? 'VALID' : 'EMPTY'}",
    );

    final url = socketUrl;
    log("🟦 [SOCKET INIT] Connecting to: $url");

    socket = io.io(
      url,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .enableReconnection()
          .setReconnectionAttempts(999999)
          .setReconnectionDelay(1500)
          .setExtraHeaders({'authorization': 'Bearer $token'})
          .build(),
    );

    socket?.onConnect((_) async {
      log("🟢 [SOCKET CONNECTED] ID: ${socket?.id}");
      log(
        "🟢 [SOCKET CONNECTED] Transport: ${socket?.io.engine?.transport?.name}",
      );
      final BuildContext? usercontext =
          rootNavigatorKey.currentState?.overlay?.context;
      if (usercontext == null) return;

      final user = usercontext.read<UserProvider>().user;

      if (user == null) {
        log("⚠️ [SOCKET WARNING] No user found — cannot connect userId");
      } else {
        log("🟦 [SOCKET USER] Connecting user: ${user.userId}");
        connectUser(user.userId);
      }

      final bookingProvider = locator<BookingProvider>();
      final isInspector = user?.role == 2;

      log(
        "🟦 [SOCKET ROLE] User Role: ${isInspector ? 'INSPECTOR' : 'CLIENT'}",
      );

      log("🟦 [SOCKET LISTENERS] Registering global listeners…");
      socketManager = SocketManager(bookingProvider);

      socketManager.registerGlobalListeners(isInspector: isInspector);
      log("🟦 [SOCKET FETCH] Fetching bookings before joining rooms…");
      log(
        "🟦 [SOCKET FETCH] Before booking fetchewd ${bookingProvider.bookings}…",
      );

      await bookingProvider.fetchBookingsList(reset: true);
      log("🟦 [SOCKET FETCH] Fetching bookings before joining rooms…");
      log(
        "🟦 [SOCKET FETCH] after booking fetchewd ${bookingProvider.bookings}…",
      );

      log("🟦 [SOCKET ROOMS] Attempting to rejoin rooms…");

      int joined = 0;

      for (final booking in bookingProvider.bookings) {
        final status = booking.status;

        if (status == bookingStatusCompleted ||
            // status == bookingStatusAccepted ||
            status == bookingStatusRejected ||
            status == bookingStatusCancelledByClient ||
            status == bookingStatusCancelledByInspector ||
            status == bookingStatusExpired) {
          log(
            "⏭️ SOCKET[ROOM SKIP] Booking ${booking.id} skipped due to status: $status",
          );
          continue;
        }

        log("🏠SOCKET [ROOM JOIN] Joining booking room: ${booking.id}");
        joinBookingRoom(booking.id);
        joined++;
      }

      log("🟢SOCKET [ROOMS JOINED] Total rooms joined: $joined");
    });

    socket?.onDisconnect((_) {
      log("🔴 [SOCKET DISCONNECTED]");
    });

    socket?.onReconnect((attempt) {
      log("🔁 [SOCKET RECONNECTED] Attempt: $attempt");
    });

    socket?.onConnectError((e) {
      log("⚠️ [SOCKET CONNECT ERROR] $e");
    });

    socket?.onError((e) {
      log("⚠️ [SOCKET ERROR] $e");
    });

    log("🟦 [SOCKET INIT] Calling socket.connect()…");
    socket?.connect();
  }

  void dispose() {
    try {
      socket?.disconnect();
      socket?.destroy();
    } catch (e) {
      log(' SOCKET SocketService dispose error: $e');
    } finally {
      socket = null;
    }
  }

  void emit(String event, Map<String, dynamic> payload) {
    socket?.emit(event, payload);
    log("📥SOCKET  emit $event with payload: $payload");
  }

  void connectUser(String userId) {
    socket?.emit('connect_user', {'userId': userId});
    log("📥SOCKET     connect_user $userId   ");
  }

  void disconnectUser(String userId) {
    socket?.emit('disconnect_user', {'userId': userId});
    log("📥 SOCKET  disconnect_user $userId      ");
  }

  void joinBookingRoom(String bookingId) {
    socket?.emit('booking_join_room', {'bookingId': bookingId});
    log("📥 SOCKET  booking_join_room $bookingId      ");
  }

  void leaveBookingRoom(String bookingId) {
    // socket?.emit('booking_leave_room', {'bookingId': bookingId});
    log("📥SOCKET   booking_leave_room $bookingId      ");
  }

  void raiseInspectionRequest(Map<String, dynamic> payload) {
    socket?.emit('raised_inspection_request', payload);
    log("📥 SOCKET  raise_inspection_request_listener. $payload      ");
  }

  void updateBookingStatus(Map<String, dynamic> payload) {
    socket?.emit('booking_status_update', payload);
    log("📥 SOCKET  booking_status_update . $payload      ");
  }

  void bookingCreationNotification(Map<String, dynamic> payload) {
    socket?.emit('booking_creation_notification', payload);
    log("📥 SOCKET  booking_creation_notification . $payload      ");
  }

  void on(String event, Function(dynamic) callback) =>
      socket?.on(event, callback);

  void off(String event) => socket?.off(event);
}
