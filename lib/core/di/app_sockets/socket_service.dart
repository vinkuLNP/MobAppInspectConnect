import 'dart:developer';
import 'dart:io';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();
  io.Socket? socket;

  bool get isConnected => socket?.connected ?? false;

  void initSocket({required String token}) {
    log("🔌 Initializing socket connection...");
    socket = io.io(
      Platform.isIOS ? "http://localhost:5002" : "http://10.0.2.2:5002",
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setExtraHeaders({"authorization": "Bearer $token"})
          .enableAutoConnect()
          .build(),
    );
    socket?.connect();
    socket?.onConnect((_) {
      log("📥  Socket connected: ${socket?.id}");
    });

    socket?.onDisconnect((_) => log("❌ Socket disconnected"));

    socket?.onConnectError((data) => log("⚠️ Connect Error: $data"));
    socket?.onError((data) => log("⚠️ Socket Error: $data"));
  }

  void dispose() {
    try {
      socket?.disconnect();
      socket?.destroy();
    } catch (e) {
      log('SocketService dispose error: $e');
    } finally {
      socket = null;
    }
  }

  void emit(String event, Map<String, dynamic> payload) {
    socket?.emit(event, payload);
    log("📥  emit $event with payload: $payload");
  }

  void connectUser(String userId) {
    socket?.emit('connect_user', {'userId': userId});
    log("📥     connect_user $userId   ");
  }

  void disconnectUser(String userId) {
    socket?.emit('disconnect_user', {'userId': userId});
    log("📥   disconnect_user $userId      ");
  }

  void joinBookingRoom(String bookingId) {
    socket?.emit('booking_join_room', {'bookingId': bookingId});
    log("📥   booking_join_room $bookingId      ");
  }

  void leaveBookingRoom(String bookingId) {
    socket?.emit('booking_leave_room', {'bookingId': bookingId});
    log("📥   booking_leave_room $bookingId      ");
  }

  void raiseInspectionRequest(Map<String, dynamic> payload) {
    socket?.emit('raised_inspection_request', payload);
    log("📥   raise_inspection_request_listener. $payload      ");
  }

  void updateBookingStatus(Map<String, dynamic> payload) {
    socket?.emit('booking_status_update', payload);
    log("📥   booking_status_update . $payload      ");
  }

  void bookingCreationNotification(Map<String, dynamic> payload) {
    socket?.emit('booking_creation_notification', payload);
    log("📥   booking_creation_notification . $payload      ");
  }

  void on(String event, Function(dynamic) callback) =>
      socket?.on(event, callback);

  void off(String event) => socket?.off(event);
}
