import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_assets_constants.dart';
import 'package:inspect_connect/core/utils/presentation/app_assets_widget.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/user_provider.dart';
import 'package:inspect_connect/features/client_flow/presentations/screens/profile_screen.dart';
import 'package:inspect_connect/features/client_flow/presentations/widgets/common_app_bar.dart';
import 'package:inspect_connect/features/inspector_flow/presentations/screens/inspection_screen.dart';
import 'package:inspect_connect/features/inspector_flow/presentations/screens/other_inspection_listing.dart';
import 'package:inspect_connect/features/inspector_flow/presentations/screens/requested_inspection_screen.dart';
import 'package:provider/provider.dart';

class InspectorMainDashboard extends StatefulWidget {
  const InspectorMainDashboard({super.key});

  @override
  State<InspectorMainDashboard> createState() => _InspectorMainDashboardState();
}

class _InspectorMainDashboardState extends State<InspectorMainDashboard> {
  int _selectedIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const RequestedInspectionScreen(),
      ApprovedInspectionsScreen(),
      const ProfileScreen(),
    ];
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      extendBody: true,
      drawer: _buildDrawer(context),
      appBar: _selectedIndex == 2
          ? null
          : CommonAppBar(
              showLogo: false,
              showDrawerIcon: true,
              title: _selectedIndex == 1
                  ? 'My Inspections'
                  : _selectedIndex == 2
                  ? 'Profile'
                  : "New Requests",
            ),

      body: _pages[_selectedIndex],
      bottomNavigationBar: SizedBox(
        height: 95,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF1B90FF),
                        Color(0xFF0070F2),
                        Color(0xFF002A86),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.topRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: _buildNavItem(
                            icon: Icons.assignment_outlined,
                            activeIcon: Icons.assignment,
                            label: 'My Inspections',
                            index: 1,
                            primary: primary,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: _buildNavItem(
                            icon: Icons.remove_from_queue_outlined,
                            activeIcon: Icons.remove_from_queue,
                            label: 'Requested',
                            index: 0,
                            primary: primary,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: _buildNavItem(
                            icon: Icons.person_outline,
                            activeIcon: Icons.person,
                            label: 'Profile',
                            index: 2,
                            primary: primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    final size = MediaQuery.of(context).size;

    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      backgroundColor: Colors.grey[200],
      child: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                width: size.width,
                height: size.height * 0.28,
                child: imageAsset(
                  image: finalImage,
                  width: size.width,
                  height: size.height * 0.28,
                  boxFit: BoxFit.cover,
                ),
              ),
              Positioned(
                left: 20,
                top: 80,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textWidget(
                      text: user?.name ?? 'Inspector Name',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 4),
                    textWidget(
                      text: user?.email ?? 'inspector@email.com',
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              children: [
                _buildDrawerCard(
                  context,
                  icon: Icons.payment,
                  label: 'Payments',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 12),
                _buildDrawerCard(
                  context,
                  icon: Icons.message_outlined,
                  label: 'Messages',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 12),
                _buildDrawerCard(
                  context,
                  icon: Icons.attach_money,
                  label: 'Payout List',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 12),
                _buildDrawerCard(
                  context,
                  icon: Icons.history,
                  label: 'Past Inspections',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OtherInspectionsScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildDrawerCard(
                  context,
                  icon: Icons.logout,
                  label: 'Logout',
                  color: Colors.redAccent,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    VoidCallback? onTap,
    Color? color,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: ListTile(
        leading: Icon(icon, color: color ?? Colors.black87),
        title: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: color ?? Colors.black87,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onTap: onTap,
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    required Color primary,
  }) {
    final isSelected = _selectedIndex == index;

    final iconWidget = Icon(
      isSelected ? activeIcon : icon,
      size: 26,
      color: isSelected ? Colors.white : Colors.white.withOpacity(0.8),
    );

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => _onItemTapped(index),
      splashColor: primary.withOpacity(0.1),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.15 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutBack,
              child: iconWidget,
            ),
            const SizedBox(height: 4),
            textWidget(
              text: label,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.8),
            ),
          ],
        ),
      ),
    );
  }
}
