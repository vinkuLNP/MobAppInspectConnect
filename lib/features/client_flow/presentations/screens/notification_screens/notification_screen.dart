import 'package:flutter/material.dart';
import 'package:inspect_connect/features/client_flow/data/models/notification_model.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/notification_provider.dart';
import 'package:provider/provider.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<NotificationProvider>().fetchNotifications(refresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (_, provider, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Notifications'), centerTitle: true),
          body: RefreshIndicator(
            onRefresh: () => provider.fetchNotifications(refresh: true),
            child: _buildBody(provider),
          ),
        );
      },
    );
  }

  Widget _buildBody(NotificationProvider provider) {
    if (provider.isLoading && provider.notifications.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.notifications.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [_emptyState()],
      );
    }

    final grouped = groupNotificationsByDate(provider.notifications);
    final sections = grouped.keys.toList();

    return ListView(
      children: sections.expand((section) {
        final items = grouped[section]!;

        return [
          _sectionHeader(section),
          ...items.expand(
            (n) => [_notificationTile(n), _notificationDivider()],
          ),
        ];
      }).toList(),
    );
  }

  Widget _notificationTile(NotificationModel n) {
    final isUnread = !n.isRead;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        elevation: isUnread ? 2 : 0,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _leadingIcon(n.type, isUnread),
                const SizedBox(width: 12),
                Expanded(child: _content(n)),
                const SizedBox(width: 8),
                if (isUnread)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _notificationDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 72),
      child: Divider(height: 1, thickness: 0.6, color: Colors.grey.shade300),
    );
  }

  Widget _leadingIcon(String type, bool unread) {
    IconData icon;
    Color color;

    switch (type) {
      case 'booking':
        icon = Icons.calendar_today;
        color = Colors.blue;
        break;
      case 'payment':
        icon = Icons.payment;
        color = Colors.green;
        break;
      default:
        icon = Icons.notifications;
        color = Colors.grey;
    }

    return CircleAvatar(
      radius: 22,
      backgroundColor: color.withOpacity(0.12),
      child: Icon(icon, color: color, size: 22),
    );
  }

  Widget _content(NotificationModel n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          n.title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: n.isRead ? FontWeight.w500 : FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          n.message,
          style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
        ),
        const SizedBox(height: 6),
        Text(
          _formatTime(n.createdAt),
          style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
        ),
      ],
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(child: Divider(thickness: 1)),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: const [
            SizedBox(height: 200),
            Icon(Icons.notifications_off, size: 64, color: Colors.grey),
            SizedBox(height: 12),
            Text(
              'No notifications yet',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 6),
            Text(
              'We’ll notify you when something important happens.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';

    return '${date.day}/${date.month}/${date.year}';
  }
}

Map<String, List<NotificationModel>> groupNotificationsByDate(
  List<NotificationModel> notifications,
) {
  final Map<String, List<NotificationModel>> grouped = {};

  for (final n in notifications) {
    final key = _dateLabel(n.createdAt);
    grouped.putIfAbsent(key, () => []);
    grouped[key]!.add(n);
  }

  return grouped;
}

String _dateLabel(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final notificationDay = DateTime(date.year, date.month, date.day);

  final diff = today.difference(notificationDay).inDays;

  if (diff == 0) return 'Today';
  if (diff == 1) return 'Yesterday';
  return 'Earlier';
}
