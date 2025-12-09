import 'package:inspect_connect/core/di/app_sockets/socket_service.dart';

class AppSocket {
  AppSocket._privateConstructor();

  static final AppSocket _instance = AppSocket._privateConstructor();

  factory AppSocket() => _instance;

  final SocketService _socketService = SocketService();

  SocketService get service => _socketService;

  void init() {
    _socketService.initSocket();
  }

  void connectUser(String userId) {
    _socketService.connectUser(userId);
  }

  void disconnectUser(String userId) {
    _socketService.disconnectUser(userId);
  }

  void joinBookingRoom(String bookingId) {
    _socketService.joinBookingRoom(bookingId);
  }

  void leaveBookingRoom(String bookingId) {
    _socketService.leaveBookingRoom(bookingId);
  }

  void raiseInspectionRequest(Map<String, dynamic> payload) {
    _socketService.raiseInspectionRequest(payload);
  }

  void updateBookingStatus(Map<String, dynamic> payload) {
    _socketService.updateBookingStatus(payload);
  }

  void bookingCreationNotification(Map<String, dynamic> payload) {
    _socketService.bookingCreationNotification(payload);
  }

  void on(String event, Function(dynamic) callback) {
    _socketService.onEvent(event, callback);
  }

  void off(String event) {
    _socketService.offEvent(event);
  }

  void emitTestEvent() {
    _socketService.emitTestEvent();
  }
}
