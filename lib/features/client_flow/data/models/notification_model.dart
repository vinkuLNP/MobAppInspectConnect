import 'package:inspect_connect/features/client_flow/data/models/booking_mini_model.dart';
import 'package:inspect_connect/features/client_flow/data/models/user_mini_model.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/notification_entity.dart';

class NotificationModel {
  final String id;
  final UserMiniModel sender;
  final UserMiniModel receiver;
  final BookingMiniModel? booking;
  final String title;
  final String message;
  final bool isRead;
  final String type;
  final DateTime createdAt;

  NotificationModel({
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

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'],
      sender: UserMiniModel.fromJson(json['senderId']),
      receiver: UserMiniModel.fromJson(json['receiverId']),
      booking: json['bookingId'] != null
          ? BookingMiniModel.fromJson(json['bookingId'])
          : null,
      title: json['title'],
      message: json['message'],
      isRead: json['isRead'],
      type: json['type'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  NotificationEntity toEntity() {
    return NotificationEntity(
      id: id,
      sender: sender.toEntity(),
      receiver: receiver.toEntity(),
      booking: booking?.toEntity(),
      title: title,
      message: message,
      isRead: isRead,
      type: type,
      createdAt: createdAt,
    );
  }
}
