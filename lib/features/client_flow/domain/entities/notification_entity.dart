import 'package:inspect_connect/features/client_flow/domain/entities/booking_mini_entity.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/user_mini_entity.dart';

class NotificationEntity {
  final String id;
  final UserMiniEntity sender;
  final UserMiniEntity receiver;
  final BookingMiniEntity? booking;
  final String title;
  final String message;
  final bool isRead;
  final String type;
  final DateTime createdAt;

  NotificationEntity({
    required this.id,
    required this.sender,
    required this.receiver,
    this.booking,
    required this.title,
    required this.message,
    required this.isRead,
    required this.type,
    required this.createdAt,
  });
}
