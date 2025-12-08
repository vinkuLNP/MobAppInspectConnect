import 'dart:developer';
import 'dart:io';

import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  io.Socket? socket;

  Function(Map<String, dynamic>)? onBookingStatusUpdated;
  Function(String)? onBookingJoined;
  Function(String)? onBookingLeft;

  void initSocket() {
    socket = io.io(
      // 'http://<YOUR_IP>:5002',
      Platform.isIOS ? 'http://localhost:5002' : 'http://10.0.2.2:5002',
      {
        'transports': ['websocket'],
        'autoConnect': false,
      },
    );

    socket!.connect();

    socket!.onConnect((_) {
      log(" SOCKET CONNECTED");
    });

    socket!.onDisconnect((_) {
      log(" SOCKET DISCONNECTED");
    });

    _initializeListeners();
  }

  // LISTENERS FROM SERVER
  void _initializeListeners() {
    socket!.on("booking_join_room_listener", (data) {
      log("📥 booking_join_room_listener => $data");
      if (onBookingJoined != null) {
        onBookingJoined!(data["bookingId"]);
      }
    });
    socket!.on("raise_inspection_request", (data) {
      log("📩 Raise Request Received: $data");
      if (onRaiseInspectionRequest != null) {
        onRaiseInspectionRequest!(Map<String, dynamic>.from(data));
      }
    });
    socket!.on("booking_leave_room_listener", (data) {
      log("📥 booking_leave_room_listener => $data");
      if (onBookingLeft != null) {
        onBookingLeft!(data["bookingId"]);
      }
    });
    socket!.on("booking_status_update_listener", (data) {
      log("📥 booking_status_update_listener => $data");
      if (onBookingStatusUpdated != null) {
        onBookingStatusUpdated!(Map<String, dynamic>.from(data));
      }
    });
  }

  // SENDERS TO SERVER

  void connectUser(String userId) {
    socket!.emit("connect_user", {"userId": userId});
    log("📤 connect_user => $userId");
  }

  void disconnectUser(String userId) {
    socket!.emit("disconnect_user", {"userId": userId});
    log("📤 disconnect_user => $userId");
  }

  void joinBookingRoom(String bookingId) {
    socket!.emit("booking_join_room", {"bookingId": bookingId});
    log("📤 booking_join_room => $bookingId");
  }

  void leaveBookingRoom(String bookingId) {
    socket!.emit("booking_leave_room", {"bookingId": bookingId});
    log("📤 booking_leave_room => $bookingId");
  }

  void sendBookingStatusUpdate({
    required String bookingId,
    required String userId,
    required int status,
  }) {
    final payload = {
      "bookingId": bookingId,
      "userId": userId,
      "status": status,
    };

    socket!.emit("booking_status_update", payload);
    log("📤 booking_status_update => $payload");
  }

  void dispose() {
    socket?.disconnect();
  }

  Function(Map<String, dynamic>)? onRaiseInspectionRequest;
  void sendRaiseInspectionRequest(Map<String, dynamic> payload) {
    socket!.emit("raise=inspection=request", payload);
  }
}
