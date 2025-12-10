import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:inspect_connect/core/di/app_sockets/app_socket.dart';
import 'package:inspect_connect/core/di/app_sockets/socket_service.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/booking_provider.dart';

class BookingSocketService {
  final BookingProvider provider;

  BookingSocketService(this.provider);
  void listenRaiseInspectionClient(SocketService socket, BuildContext context) {
        AppSocket().on('raise_inspection_request_listener', (payload) {
  final bookingId = payload['data']['bookingId'];
  final raisedAmount = payload['data']['raisedAmount'];
  final agreed = payload['data']['agreedToRaise'];
  final actorRole = payload['data']['actorRole'];

  log(bookingId.toString());
log(  raisedAmount.toString());
log(  agreed.toString());
log(  actorRole.toString());
});
  }

  void listenRaiseInspectionInspector(SocketService socket) {

    AppSocket().on('raise_inspection_request_listener', (payload) {
  final bookingId = payload['data']['bookingId'];
  final raisedAmount = payload['data']['raisedAmount'];
  final agreed = payload['data']['agreedToRaise'];
  final actorRole = payload['data']['actorRole'];

  log(bookingId.toString());
log(  raisedAmount.toString());
log(  agreed.toString());
log(  actorRole.toString());
});

  }

  void listenSocketEvents(SocketService socket) {
  }
  
}
