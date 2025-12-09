import 'dart:developer';
import 'dart:ui';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:inspect_connect/core/di/app_component/app_component.dart';
import 'package:inspect_connect/core/di/app_sockets/socket_service.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/booking_provider.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/user_provider.dart';
import 'package:inspect_connect/features/client_flow/presentations/screens/booking_screen.dart';
import 'package:inspect_connect/features/client_flow/presentations/screens/home_screen.dart';
import 'package:inspect_connect/features/client_flow/presentations/screens/profile_screen.dart';
import 'package:provider/provider.dart';

@RoutePage()
class ClientDashboardView extends StatefulWidget {
  const ClientDashboardView({super.key});

  @override
  State<ClientDashboardView> createState() => _ClientDashboardViewState();
}

class _ClientDashboardViewState extends State<ClientDashboardView> {
  int _selectedIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeScreen(),
      BookingsScreen(
        onBookNowTapped: () {
          _onItemTapped(0);
        },
      ),
      ProfileScreen(),
    ];
    final socket = locator<SocketService>();
    socket.initSocket();
       final user = context.read<UserProvider>().user;
  socket.connectUser(user!.userId.toString());

  Provider.of<BookingProvider>(context, listen: false)
      .listenSocketEvents(socket);



// Listen for test responses
socket.socket?.on("test_event", (data) {
  log("✅ Received from server: $data");
});

// Send a test event
socket.emitTestEvent();

  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Colors.grey,
      extendBody: true,
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
                        color: Colors.black.withValues(alpha:0.1),
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
                            label: 'My Bookings',
                            index: 1,
                            primary: primary,
                          ),
                        ),
                      ),

                      const SizedBox(width: 60),

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

            Positioned(
              top: -10,
              child: GestureDetector(
                onTap: () => _onItemTapped(0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutBack,
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha:0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.add,
                    size: 32,
                    color: _selectedIndex == 0
                        ? Colors.white
                        : Colors.white.withValues(alpha:0.9),
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: 20,
              child: textWidget(
                text: 'Book Now',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _selectedIndex == 0
                    ? Colors.white
                    : Colors.white.withValues(alpha:0.8),
              ),
            ),
          ],
        ),
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
      color: isSelected ? Colors.white : Colors.white.withValues(alpha:0.8),
    );

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => _onItemTapped(index),
      splashColor: primary.withValues(alpha:0.1),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedScale(
                  scale: isSelected ? 1.15 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutBack,
                  child: iconWidget,
                ),
              ],
            ),
            const SizedBox(height: 4),
            textWidget(
              text: label,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? Colors.white : Colors.white.withValues(alpha:0.8),
            ),
          ],
        ),
      ),
    );
  }
}
