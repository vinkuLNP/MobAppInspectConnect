import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/client_flow/presentations/widgets/common_app_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: const CommonAppBar(
    showLogo: true,
    title: 'Dashboard',
  ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _DashboardCard(
              title: 'Active Jobs',
              icon: Icons.work,
              onTap: () {},
            ),
            _DashboardCard(
              title: 'Payments',
              icon: Icons.payment,
              onTap: () {},
            ),
            _DashboardCard(
              title: 'Notifications',
              icon: Icons.notifications,
              onTap: () {},
            ),
            _DashboardCard(
              title: 'Settings',
              icon: Icons.settings,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.blue.withValues(alpha:0.1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.blue, size: 36),
            const SizedBox(height: 8),
         textWidget(text: title, fontWeight: FontWeight.w600),
          ],
        ),
      ),
    );
  }
}
