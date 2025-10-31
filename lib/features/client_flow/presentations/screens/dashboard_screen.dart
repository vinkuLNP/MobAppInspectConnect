// import 'dart:ui';
// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';
// import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
// import 'package:inspect_connect/features/client_flow/presentations/screens/booking_screen.dart';
// import 'package:inspect_connect/features/client_flow/presentations/screens/home_screen.dart';
// import 'package:inspect_connect/features/client_flow/presentations/screens/profile_screen.dart';

// @RoutePage()
// class ClientDashboardView extends StatefulWidget {
//   const ClientDashboardView({super.key});

//   @override
//   State<ClientDashboardView> createState() => _ClientDashboardViewState();
// }

// class _ClientDashboardViewState extends State<ClientDashboardView> {
//   int _selectedIndex = 0;

//   final List<Widget> _pages = const [
//     HomeScreen(),
//     BookingsScreen(),
//     ProfileScreen(),
//   ];

//   void _onItemTapped(int index) {
//     if (index == _selectedIndex) return;
//     setState(() => _selectedIndex = index);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final primary = theme.colorScheme.primary;

//     return Scaffold(
//       extendBody: true,
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(12),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(30),
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.85),
//                 borderRadius: BorderRadius.circular(30),
//                 border: Border.all(
//                   color: Colors.grey.withOpacity(0.2),
//                   width: 1,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black12.withOpacity(0.05),
//                     blurRadius: 12,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: List.generate(_pages.length, (index) {
//                     final isSelected = _selectedIndex == index;

//                     IconData iconData;
//                     IconData activeIconData;
//                     String label;

//                     switch (index) {
//                       case 0:
//                         iconData = Icons.add_box_outlined;
//                         activeIconData = Icons.add_box;
//                         label = 'Book Now';
//                         break;
//                       case 1:
//                         iconData = Icons.assignment_outlined;
//                         activeIconData = Icons.assignment;
//                         label = 'My Bookings';
//                         break;
//                       default:
//                         iconData = Icons.person_outline;
//                         activeIconData = Icons.person;
//                         label = 'Profile';
//                     }

//                     return Material(
//                       color: Colors.transparent,
//                       child: InkWell(
//                         borderRadius: BorderRadius.circular(20),
//                         splashColor: primary.withOpacity(0.2),
//                         highlightColor: primary.withOpacity(0.1),
//                         onTap: () => _onItemTapped(index),
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(
//                             vertical: 6,
//                             horizontal: 12,
//                           ),
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               AnimatedScale(
//                                 scale: isSelected ? 1.15 : 1.0,
//                                 duration: const Duration(milliseconds: 300),
//                                 curve: Curves.elasticOut,
//                                 child: Icon(
//                                   isSelected ? activeIconData : iconData,
//                                   color: isSelected ? primary : Colors.grey,
//                                   size: 28,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               textWidget(
//                                 text: label,
//                                 fontSize: isSelected ? 13 : 12,
//                                 fontWeight: isSelected
//                                     ? FontWeight.w600
//                                     : FontWeight.w400,
//                                 color: isSelected ? primary : Colors.grey,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   }),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:ui';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/client_flow/presentations/screens/booking_screen.dart';
import 'package:inspect_connect/features/client_flow/presentations/screens/home_screen.dart';
import 'package:inspect_connect/features/client_flow/presentations/screens/profile_screen.dart';

@RoutePage()
class ClientDashboardView extends StatefulWidget {
  const ClientDashboardView({super.key});

  @override
  State<ClientDashboardView> createState() => _ClientDashboardViewState();
}

class _ClientDashboardViewState extends State<ClientDashboardView> {
  int _selectedIndex = 0;
  late List<Widget> _pages;
  // final List<Widget> _pages =  [
  //   HomeScreen(),
  //   BookingsScreen( onBookNowTapped: () {
  //     _onItemTapped(0); // switch to index 0
  //   },),
  //   ProfileScreen(),
  // ];

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeScreen(),
      BookingsScreen(
        onBookNowTapped: () {
          _onItemTapped(0); // switch to index 0
        },
      ),
      ProfileScreen(),
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
      backgroundColor: Colors.grey,
      extendBody: true,
      body: _pages[_selectedIndex],
      bottomNavigationBar: SizedBox(
        height: 100,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildNavItem(
                          icon: Icons.assignment_outlined,
                          activeIcon: Icons.assignment,
                          label: 'My Bookings',
                          index: 1,
                          primary: primary,
                        ),
                        const SizedBox(width: 60),
                        _buildNavItem(
                          icon: Icons.person_outline,
                          activeIcon: Icons.person,
                          label: 'Profile',
                          index: 2,
                          primary: primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              top: -2,
              child: GestureDetector(
                onTap: () => _onItemTapped(0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: _selectedIndex == 0
                        ? AppColors.authThemeColor
                        : AppColors.authThemeColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: (_selectedIndex == 0
                            ? AppColors.authThemeLightColor.withOpacity(0.4)
                            : AppColors.whiteColor.withOpacity(0.4)),
                        blurRadius: 18,
                        spreadRadius: 2,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.add,
                      size: 34,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: 20,
              child: Center(
                child: textWidget(
                  text: 'Book Now',
                  fontSize: 12,
                  fontWeight: _selectedIndex == 0
                      ? FontWeight.w600
                      : FontWeight.w400,
                  color: _selectedIndex == 0 ? primary : Colors.grey,
                ),
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
    bool showDot = false,
  }) {
    final isSelected = _selectedIndex == index;

    final iconWidget = Icon(
      isSelected ? activeIcon : icon,
      size: 26,
      color: isSelected ? primary : Colors.grey,
    );

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => _onItemTapped(index),
      splashColor: primary.withOpacity(0.1),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
              color: isSelected ? primary : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
