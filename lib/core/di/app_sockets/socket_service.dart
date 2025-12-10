import 'dart:developer';
import 'dart:io';

import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  io.Socket? socket;

  bool get isConnected => socket?.connected ?? false;

  /// Initialize the socket
  void initSocket() {
    socket = io.io(
          Platform.isIOS ? "http://localhost:5002" : "http://10.0.2.2:5002",
      io.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .build(),
    );

    socket?.onConnect((_) {
      log("✅ Socket connected: ${socket?.id}");
    });

    socket?.onDisconnect((_) {
      log("❌ Socket disconnected");
    });

    socket?.onConnectError((data) {
      log("⚠️ Socket connection error: $data");
    });

    socket?.onError((data) {
      log("⚠️ Socket error: $data");
    });
  }

  /// Connect user to the socket
  void connectUser(String userId) {
    socket?.emit('connect_user', {'userId': userId});
  }

  /// Disconnect user from the socket
  void disconnectUser(String userId) {
    socket?.emit('disconnect_user', {'userId': userId});
  }

  /// Join a booking room
  void joinBookingRoom(String bookingId) {
    socket?.emit('booking_join_room', {'bookingId': bookingId});
  }

  /// Leave a booking room
  void leaveBookingRoom(String bookingId) {
    socket?.emit('booking_leave_room', {'bookingId': bookingId});
  }

  /// Raise an inspection request
  void raiseInspectionRequest(Map<String, dynamic> payload) {
    socket?.emit('raised_inspection_request', payload);
  }

  /// Update booking status
  void updateBookingStatus(Map<String, dynamic> payload) {
    socket?.emit('booking_status_update', payload);
  }

  /// Notify about booking creation
  void bookingCreationNotification(Map<String, dynamic> payload) {
    socket?.emit('booking_creation_notification', payload);
  }

  /// Listen to server responses
  void onEvent(String event, Function(dynamic) callback) {
    socket?.on(event, callback);
  }

  /// Remove listener
  void offEvent(String event) {
    socket?.off(event);
  }

  /// Test event
  void emitTestEvent() {
    socket?.emit('test_event', {'message': 'Hello from Flutter'});
  }
}


