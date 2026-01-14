import 'package:inspect_connect/features/client_flow/data/models/notification_model.dart';

class NotificationListModel {
  final List<NotificationModel> notifications;
  final int totalCount;
  final int totalPages;
  final int currentPage;

  NotificationListModel({
    required this.notifications,
    required this.totalCount,
    required this.totalPages,
    required this.currentPage,
  });

  factory NotificationListModel.fromJson(Map<String, dynamic> json) {
    return NotificationListModel(
      notifications: (json['notifications'] as List)
          .map((e) => NotificationModel.fromJson(e))
          .toList(),
      totalCount: json['totalCount'],
      totalPages: json['totalPages'],
      currentPage: json['currentPage'],
    );
  }
}
