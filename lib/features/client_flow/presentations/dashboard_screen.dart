import 'dart:ui';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:inspect_connect/features/client_flow/presentations/booking_screen.dart';
import 'package:inspect_connect/features/client_flow/presentations/home_screen.dart';
import 'package:inspect_connect/features/client_flow/presentations/profile_screen.dart';

@RoutePage()
class ClientDashboardView extends StatefulWidget {
  const ClientDashboardView({super.key});

  @override
  State<ClientDashboardView> createState() => _ClientDashboardViewState();
}

class _ClientDashboardViewState extends State<ClientDashboardView> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    BookingsScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Scaffold(
      extendBody: true,
      body: _pages[_selectedIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(_pages.length, (index) {
                    final isSelected = _selectedIndex == index;

                    IconData iconData;
                    IconData activeIconData;
                    String label;

                    switch (index) {
                      case 0:
                        // iconData = Icons.dashboard_outlined;
                        iconData = Icons.add_box_outlined;

                        activeIconData = Icons.add_box;
                        label = 'Book Now';
                        break;
                      case 1:
                        iconData = Icons.assignment_outlined;
                        activeIconData = Icons.assignment;
                        label = 'My Bookings';
                        break;
                      default:
                        iconData = Icons.person_outline;
                        activeIconData = Icons.person;
                        label = 'Profile';
                    }

                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        splashColor: primary.withOpacity(0.2),
                        highlightColor: primary.withOpacity(0.1),
                        onTap: () => _onItemTapped(index),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedScale(
                                scale: isSelected ? 1.15 : 1.0,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.elasticOut,
                                child: Icon(
                                  isSelected ? activeIconData : iconData,
                                  color: isSelected ? primary : Colors.grey,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                label,
                                style: TextStyle(
                                  fontSize: isSelected ? 13 : 12,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                  color: isSelected ? primary : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
